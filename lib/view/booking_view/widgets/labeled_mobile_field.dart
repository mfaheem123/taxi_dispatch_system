// labeled_mobile_field.dart
//
// MOBILE field with customer lookup.
//
// Ported from the dashboard booking form so both forms behave identically:
//   * typing filters the known customers by mobile, name or email;
//   * matches drop into an Overlay panel under the field (mobile on top, name
//     underneath), NOT a modal;
//   * ↑ / ↓ walk the list, Enter picks, Esc closes, the mouse highlights;
//   * picking writes the mobile into this field and hands the whole customer
//     back through [onPicked] so NAME / EMAIL / TEL can be filled in.
//
// See create_new_booking_form.dart for how this fits into the wider form.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'booking_form_layout.dart';

/// One customer the MOBILE field can suggest.
class CustomerSuggestion {
  final String mobile;
  final String name;
  final String email;
  final String telephone;
  const CustomerSuggestion({
    required this.mobile,
    this.name = '',
    this.email = '',
    this.telephone = '',
  });
}

class LabeledMobileField extends StatefulWidget implements LabelledField {
  @override
  final String label;
  final TextEditingController controller;

  /// Candidates to filter. Swap this for a backend-fed list later — the widget
  /// re-filters whenever the list identity changes, without losing the
  /// keyboard highlight.
  final List<CustomerSuggestion> customers;

  /// Fired on every keystroke, for kicking off a server-side lookup.
  final ValueChanged<String>? onSearch;

  /// Fired once, with the customer the user committed to.
  final ValueChanged<CustomerSuggestion>? onPicked;

  const LabeledMobileField(
    this.label, {
    super.key,
    required this.controller,
    this.customers = const [],
    this.onSearch,
    this.onPicked,
  });

  @override
  State<LabeledMobileField> createState() => _LabeledMobileFieldState();
}

class _LabeledMobileFieldState extends State<LabeledMobileField> {
  static const double _itemHeight = 48;
  static const double _panelHeight = 260;

  final _layerLink = LayerLink();
  final _focusNode = FocusNode();
  final _fieldKey = GlobalKey();
  final _scrollController = ScrollController();
  OverlayEntry? _entry;

  List<CustomerSuggestion> _filtered = const [];
  int _highlighted = -1;
  bool _userTyped = false;
  // Set while _pick writes the mobile back into the controller, so that write
  // does not immediately re-open the panel it just closed.
  bool _suppressPanel = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocus);
    widget.controller.addListener(_onText);
  }

  @override
  void didUpdateWidget(covariant LabeledMobileField old) {
    super.didUpdateWidget(old);
    if (old.customers != widget.customers && _userTyped) {
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
    if (text.isEmpty) {
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
    final CustomerSuggestion? current = (preserveHighlight &&
            _highlighted >= 0 &&
            _highlighted < _filtered.length)
        ? _filtered[_highlighted]
        : null;

    if (query.isEmpty) {
      _filtered = const [];
    } else {
      _filtered = widget.customers.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.mobile.toLowerCase().contains(query) ||
            c.email.toLowerCase().contains(query);
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

  void _pick(CustomerSuggestion c) {
    _suppressPanel = true;
    widget.controller.text = c.mobile;
    widget.controller.selection =
        TextSelection.collapsed(offset: c.mobile.length);
    _suppressPanel = false;
    _userTyped = false;
    _hide();
    widget.onPicked?.call(c);
    // Focus is deliberately kept: Tab then carries straight on to TEL instead
    // of restarting traversal at the top of the form.
    setState(() {});
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
    // The same accent the focused field border uses, so the highlighted row in
    // this panel matches the ring around the field it hangs off.
    const accent = fieldFocusColor;
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 280.0;
    final height = box?.size.height ?? 40.0;

    return Positioned(
      width: width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, height + 4),
        child: TapRegion(
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
                        final c = _filtered[i];
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
                            onTap: () => _pick(c),
                            child: Container(
                              width: double.infinity,
                              height: _itemHeight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              color: active
                                  ? accent.withValues(alpha: 0.10)
                                  : Colors.white,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                Icon(Icons.person_outline,
                                    size: 16,
                                    color: active ? accent : Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        c.mobile,
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
                                      const SizedBox(height: 2),
                                      Text(
                                        c.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: Density.labelFont,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
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
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            style: const TextStyle(fontSize: Density.fieldFont),
            decoration: const InputDecoration(
              prefixIconConstraints:
                  BoxConstraints(minWidth: 28, minHeight: 0),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 8, right: 4),
                child: Icon(Icons.phone_outlined, size: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
