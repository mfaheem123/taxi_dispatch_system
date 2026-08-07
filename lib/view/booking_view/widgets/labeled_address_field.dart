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

import 'booking_form_layout.dart';
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
  });

  @override
  State<LabeledAddressField> createState() => _LabeledAddressFieldState();
}

class _LabeledAddressFieldState extends State<LabeledAddressField> {
  static const double _itemHeight = 44;
  static const double _panelHeight = 260;

  final _layerLink = LayerLink();
  final _focusNode = FocusNode();
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
      });
    }
  }

  @override
  void dispose() {
    _hide();
    _focusNode.removeListener(_onFocus);
    widget.controller.removeListener(_onText);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (!_focusNode.hasFocus) _hide();
  }

  void _onText() {
    if (_suppressPanel || !_focusNode.hasFocus) return;
    final text = widget.controller.text.trim();
    // No candidates at all (this screen hits no API) means no panel — not even
    // an empty "No data" one. Once a real list is supplied, a search that
    // simply misses still reports "No data", as on the dashboard.
    if (text.isEmpty || widget.addresses.isEmpty) {
      _userTyped = false;
      _hide();
      return;
    }
    _userTyped = true;
    _filter(widget.controller.text);
    _show();
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
      _filtered = widget.addresses.where((a) {
        return a.name.toLowerCase().contains(query) ||
            a.postcode.toLowerCase().contains(query);
      }).toList();
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
    _entry = OverlayEntry(builder: _buildPanel);
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
    _suppressPanel = false;
    _userTyped = false;
    _hide();
    widget.onPicked?.call(a);
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
    _highlighted = next;
    _entry?.markNeedsBuild();
    _scrollHighlightedIntoView();
  }

  void _scrollHighlightedIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = _scrollController;
      if (!c.hasClients || _highlighted < 0) return;
      final itemTop = _highlighted * _itemHeight;
      final itemBottom = itemTop + _itemHeight;
      final viewTop = c.offset;
      final viewBottom = viewTop + _panelHeight;
      final maxScroll = c.position.maxScrollExtent;
      if (itemTop < viewTop) {
        c.jumpTo(itemTop.clamp(0.0, maxScroll));
      } else if (itemBottom > viewBottom) {
        c.jumpTo((itemBottom - _panelHeight).clamp(0.0, maxScroll));
      }
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
    final accent = Theme.of(context).colorScheme.primary;
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
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final a = _filtered[i];
                        final active = _highlighted == i;
                        return MouseRegion(
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
                              height: _itemHeight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
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
                                    maxLines: 1,
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
                      },
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
  /// Wrapped in [ExcludeFocus] because these buttons live *inside* a field:
  /// left focusable they would cost one or two extra Tab presses per location
  /// field, which is exactly what this form's ordered traversal avoids.
  Widget _suffixIcons() {
    Widget iconBtn(IconData icon, String tooltip, VoidCallback onTap) =>
        IconButton(
          tooltip: tooltip,
          onPressed: onTap,
          icon: Icon(icon, size: 14, color: Colors.grey),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          splashRadius: 14,
        );

    return ExcludeFocus(
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller,
        builder: (_, value, __) => Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (value.text.isNotEmpty) iconBtn(Icons.close, 'Clear', _clear),
            if (widget.onSwap != null)
              iconBtn(Icons.swap_vert, 'Swap pickup and drop', widget.onSwap!),
            const SizedBox(width: 2),
          ],
        ),
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
            style: const TextStyle(fontSize: Density.fieldFont),
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
