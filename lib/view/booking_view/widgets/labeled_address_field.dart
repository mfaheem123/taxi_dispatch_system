// labeled_address_field.dart
//
// PICK / DROP address field with lookup.
//
// Ported from the dashboard booking form's _locationRow + _AddressModelAutocomplete:
//   * a coloured dot marks the field — green for a pickup, red for a drop;
//   * typing filters the known addresses by name or postcode and drops the
//     matches into an Overlay panel under the field;
//   * ↑ / ↓ walk the list, Enter picks, Esc closes, the mouse highlights;
//   * a × button appears once there is text, and an optional swap button
//     exchanges the pickup and drop locations;
//   * input is upper-cased, as on the dashboard.
//
// See create_new_booking_form.dart for how this fits into the wider form.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// GlowFocus: the focus ring the dashboard form puts on these same buttons.
import 'package:flutter_web_date_picker/flutter_web_date_picker.dart'
    show GlowFocus;

import '../../dashboard_view/utils/address_query_match.dart';
import 'booking_form_layout.dart';
import 'labeled_icon_actions.dart' show IconAction;
import 'labeled_input.dart' show UpperCaseTextFormatter;

/// One address the PICK / DROP fields can suggest.
class AddressSuggestion {
  final String name;
  final String postcode;
  const AddressSuggestion({required this.name, this.postcode = ''});

  /// What lands in the field when this entry is picked.
  String get display {
    if (name.isEmpty) return postcode;
    if (postcode.isEmpty) return name;
    return '$name, $postcode';
  }
}

class LabeledAddressField extends StatefulWidget implements LabelledField {
  @override
  final String label;
  final TextEditingController controller;

  /// Candidates to filter. Swap this for a backend-fed list later — the widget
  /// re-filters whenever the list identity changes, without losing the
  /// keyboard highlight.
  final List<AddressSuggestion> addresses;

  /// Green for a pickup, red for a drop — same cue the dashboard's dot gives.
  final Color dotColor;

  /// Fired on every keystroke, for kicking off a server-side lookup.
  final ValueChanged<String>? onSearch;

  /// Fired once, with the address the user committed to.
  final ValueChanged<AddressSuggestion>? onPicked;

  /// Extra cleanup after the × button empties the field (dropping map markers,
  /// resetting the fare, and so on).
  final VoidCallback? onCleared;

  /// Swaps this location with its counterpart. Null hides the swap button.
  final VoidCallback? onSwap;

  /// One more button beside × / swap — the update form's via-point picker on
  /// DROP and R/DROP. Only [IconAction.icon], [IconAction.tooltip] and
  /// [IconAction.onTap] are read; the colours are ignored, since a button
  /// inside a field takes the field's own greys.
  final IconAction? extraAction;

  /// Focus node to drive this field with, when something outside it needs to
  /// put the caret here — the update form's clear buttons hand focus back to
  /// the field they emptied, using the node DashboardController already keeps
  /// per location field. Left null, the field owns a private node.
  ///
  /// A node supplied here is NOT disposed with the field: whoever created it
  /// owns it.
  final FocusNode? focusNode;

  const LabeledAddressField(
    this.label, {
    super.key,
    required this.controller,
    this.addresses = const [],
    this.dotColor = Colors.green,
    this.onSearch,
    this.onPicked,
    this.onCleared,
    this.onSwap,
    this.extraAction,
    this.focusNode,
  });

  @override
  State<LabeledAddressField> createState() => _LabeledAddressFieldState();
}

class _LabeledAddressFieldState extends State<LabeledAddressField> {
  static const double _panelHeight = 260;

  /// One key per panel row, so arrow-key navigation can scroll the highlighted
  /// row into view — rows size to their text, so there's no fixed row height
  /// to compute offsets from.
  List<GlobalKey> _rowKeys = const [];
  int _lastMoveDelta = 1;

  final _layerLink = LayerLink();

  /// Null unless this field had to make its own — see [_focusNode].
  FocusNode? _ownedFocusNode;
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  final _fieldKey = GlobalKey();
  final _scrollController = ScrollController();
  OverlayEntry? _entry;

  List<AddressSuggestion> _filtered = const [];
  int _highlighted = -1;
  bool _userTyped = false;
  // Set while _pick writes the address back into the controller, so that write
  // does not immediately re-open the panel it just closed.
  bool _suppressPanel = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocus);
    widget.controller.addListener(_onText);
  }

  @override
  void didUpdateWidget(covariant LabeledAddressField old) {
    super.didUpdateWidget(old);
    if (old.addresses != widget.addresses && _userTyped) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_focusNode.hasFocus) return;
        // Late backend results arriving while the user navigates with the
        // arrow keys must NOT snap the highlight back to the top.
        _filter(widget.controller.text, preserveHighlight: true);
        // This is the path that OPENS the panel for a live backend list.
        // DashboardController debounces its lookup by 800ms, so when the user
        // typed there was nothing to show yet and _onText left the panel shut;
        // the results land here instead.
        _syncPanel();
      });
    }
  }

  @override
  void dispose() {
    _hide();
    _focusNode.removeListener(_onFocus);
    widget.controller.removeListener(_onText);
    // Only a node this field made is a node this field may dispose.
    _ownedFocusNode?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (!_focusNode.hasFocus) _hide();
  }

  void _onText() {
    if (_suppressPanel || !_focusNode.hasFocus) return;
    if (widget.controller.text.trim().isEmpty) {
      _userTyped = false;
      _hide();
      return;
    }
    // Flagged as typed even when there is nothing to show yet. The candidate
    // list is fed by a debounced backend call, so on the first search it is
    // still empty at this point — and _userTyped is what lets didUpdateWidget
    // open the panel once the results actually arrive.
    _userTyped = true;
    _filter(widget.controller.text);
    _syncPanel();
  }

  /// Opens the panel when there is something to put in it, closes it otherwise.
  ///
  /// "Something" includes a genuine miss — the panel reports 'No data' for that,
  /// as the dashboard does — but NOT the gap before the first results land.
  /// Showing an empty panel then would flash 'No data' under every first
  /// keystroke, while the lookup for it is still in flight.
  void _syncPanel() {
    if (_filtered.isNotEmpty || widget.addresses.isNotEmpty) {
      _show();
    } else {
      _hide();
    }
  }

  void _filter(String q, {bool preserveHighlight = false}) {
    final query = q.trim().toLowerCase();
    // Remember the currently highlighted item so a list refresh can keep it.
    final AddressSuggestion? current = (preserveHighlight &&
            _highlighted >= 0 &&
            _highlighted < _filtered.length)
        ? _filtered[_highlighted]
        : null;

    if (query.isEmpty) {
      _filtered = const [];
    } else {
      // Token-wise, same matcher as the dashboard form: the backend answers
      // "A H" with rows like "ASDA, HIGH STREET", which a single substring
      // check would drop, leaving 'No data' over a good response.
      _filtered = widget.addresses
          .where((a) => addressMatchesQuery(
              name: a.name, postcode: a.postcode, query: query))
          .toList();
    }

    if (_filtered.isEmpty) {
      _highlighted = -1;
    } else if (preserveHighlight) {
      final idx = current == null ? -1 : _filtered.indexOf(current);
      _highlighted =
          idx >= 0 ? idx : _highlighted.clamp(0, _filtered.length - 1);
    } else {
      _highlighted = 0;
    }
    _entry?.markNeedsBuild();
  }

  void _show() {
    if (_entry != null) return;
    // Wrapped again: an OverlayEntry inherits nothing from the screen.
    _entry = OverlayEntry(
        builder: (ctx) => withBookingFormFont(ctx, _buildPanel(ctx)));
    Overlay.of(context).insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  void _pick(AddressSuggestion a) {
    final text = a.display.toUpperCase();
    _suppressPanel = true;
    widget.controller.text = text;
    widget.controller.selection = TextSelection.collapsed(offset: text.length);
    _userTyped = false;
    _hide();
    // Still suppressed across the callback, because onPicked may write this
    // field again: the update form routes it through
    // DashboardController.tapSelect, which sets the text itself. That second
    // write must not re-open the panel this just closed.
    widget.onPicked?.call(a);
    _suppressPanel = false;
    // Focus is deliberately kept: Tab then carries straight on to the zone
    // dropdown instead of restarting traversal at the top of the form.
    setState(() {});
  }

  void _clear() {
    _suppressPanel = true;
    widget.controller.clear();
    _suppressPanel = false;
    _userTyped = false;
    _hide();
    widget.onCleared?.call();
    _focusNode.requestFocus();
  }

  void _moveHighlight(int delta) {
    if (_filtered.isEmpty) return;
    final next = (_highlighted + delta).clamp(0, _filtered.length - 1);
    if (next == _highlighted) return;
    _lastMoveDelta = delta;
    _highlighted = next;
    _entry?.markNeedsBuild();
    _scrollHighlightedIntoView();
  }

  void _scrollHighlightedIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_highlighted < 0 || _highlighted >= _rowKeys.length) return;
      final rowContext = _rowKeys[_highlighted].currentContext;
      if (rowContext == null) return;
      // Same as the dashboard's panel: scroll only as far as needed to show
      // the row at the edge it is moving towards.
      Scrollable.ensureVisible(
        rowContext,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        alignmentPolicy: _lastMoveDelta > 0
            ? ScrollPositionAlignmentPolicy.keepVisibleAtEnd
            : ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    });
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      if (_entry != null) _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (_entry != null) _moveHighlight(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      if (_entry != null &&
          _highlighted >= 0 &&
          _highlighted < _filtered.length) {
        _pick(_filtered[_highlighted]);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.escape) {
      if (_entry != null) {
        _hide();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  Widget _buildPanel(BuildContext context) {
    // The same accent the focused field border uses, so the highlighted row in
    // this panel matches the ring around the field it hangs off.
    const accent = fieldFocusColor;
    if (_rowKeys.length != _filtered.length) {
      _rowKeys = List.generate(_filtered.length, (_) => GlobalKey());
    }
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 280.0;
    final height = box?.size.height ?? 40.0;

    return Positioned(
      width: width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, height + 4),
        child: TextFieldTapRegion(
          onTapOutside: (_) => _focusNode.unfocus(),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: _panelHeight),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _filtered.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('No data',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Density.fieldFont)),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      // A Column rather than ListView.builder, as on the
                      // dashboard: rows size to their own text, and every row
                      // must be built so its key can be scrolled to.
                      child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_filtered.length, (i) {
                        final a = _filtered[i];
                        final active = _highlighted == i;
                        return MouseRegion(
                          key: _rowKeys[i],
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) {
                            if (_highlighted == i) return;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) {
                              if (!mounted) return;
                              _highlighted = i;
                              _entry?.markNeedsBuild();
                            });
                          },
                          child: InkWell(
                            canRequestFocus: false,
                            onTap: () => _pick(a),
                            child: Container(
                              width: double.infinity,
                              // No fixed height, same as the dashboard's panel:
                              // a short address takes one line, a long one
                              // wraps to a second.
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              color: active
                                  ? accent.withValues(alpha: 0.10)
                                  : Colors.white,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                Icon(Icons.place_outlined,
                                    size: 14,
                                    color: active ? accent : Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    a.display,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Density.fieldFont,
                                      fontWeight: active
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        );
                      }),
                      ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// The × / swap pair. Rebuilt on its own so showing and hiding × costs no
  /// more than a repaint of the two icons.
  ///
  /// Tab stops, exactly as on the dashboard form: address → × → swap / via →
  /// zone. Each gets an explicit fractional order between the field's own
  /// grid order and the next cell's (dashboard: tabBase + 1.3 / + 1.6), so
  /// the sequence never depends on a geometry tie-break, and the same
  /// [GlowFocus] ring marks the focused icon.
  Widget _suffixIcons() {
    // The grid cell's order; the icons slot in just after it.
    final cellOrder = FocusTraversalOrder.maybeOf(context);
    final base =
        cellOrder is NumericFocusOrder ? cellOrder.order : null;

    Widget iconBtn(IconData icon, String tooltip, VoidCallback onTap,
        double step,
        {Color color = Colors.grey}) {
      final Widget button = GlowFocus(
        radius: 14,
        child: IconButton(
          tooltip: tooltip,
          onPressed: onTap,
          icon: Icon(icon, size: 14, color: color),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          splashRadius: 14,
        ),
      );
      return base == null
          ? button
          : FocusTraversalOrder(
              order: NumericFocusOrder(base + step), child: button);
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (_, value, __) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Red because it throws the address away — the one destructive
          // button in the row.
          if (value.text.isNotEmpty)
            iconBtn(Icons.cancel, 'Clear', _clear, 0.3,
                color: const Color(0xFFD9412B)),
          if (widget.onSwap != null)
            iconBtn(Icons.swap_vert, 'Swap pickup and drop', widget.onSwap!,
                0.6),
          if (widget.extraAction != null)
            iconBtn(widget.extraAction!.icon, widget.extraAction!.tooltip,
                widget.extraAction!.onTap, 0.8),
          const SizedBox(width: 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: widget.label,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Focus(
          onKeyEvent: _handleKey,
          child: TextField(
            key: _fieldKey,
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: widget.onSearch,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: const [UpperCaseTextFormatter()],
            textInputAction: TextInputAction.next,
            style: kFormValueStyle,
            decoration: InputDecoration(
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 24, minHeight: 0),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 4),
                child: Icon(Icons.circle, size: 8, color: widget.dotColor),
              ),
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 28, minHeight: 0),
              suffixIcon: _suffixIcons(),
            ),
          ),
        ),
      ),
    );
  }
}
