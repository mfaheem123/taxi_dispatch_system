// responsive_booking_form.dart
//
// A responsive booking / dispatch form for Flutter.
// Works on phone, iPad and web from a SINGLE layout definition.
//
// Responsive strategy:
//   * LayoutBuilder measures the available width.
//   * A breakpoint chooses a "base column count" (phone=1, tablet=2, desktop=4).
//   * Each field declares how many base columns it spans.
//   * A Wrap reflows the fields, so the same field list restacks automatically.
//
// Drop this file into a Flutter project and run it as-is.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timepickerfield/timepickerfield.dart';

import '../../alert/child_seats_alert.dart';
import '../../alert/extra_fares_alert.dart';
import '../../alert/extra_info_alert.dart';
import '../../alert/restrict_drivers_alert.dart';


/// Dense, form-friendly input styling shared by every field.
///
/// BookingFormScreen applies this itself rather than relying on the ambient
/// theme — without `isDense` Material forces a 48px minimum on every input and
/// the form roughly doubles in height.
const InputDecorationTheme denseInputTheme = InputDecorationTheme(
  isDense: true,
  contentPadding:
      EdgeInsets.symmetric(horizontal: 8, vertical: Density.fieldPadY),
  border: OutlineInputBorder(),
  filled: true,
  fillColor: Colors.white,
  hintStyle: TextStyle(fontSize: Density.fieldFont),
);

// ---------------------------------------------------------------------------
// Vertical density — the single place to tune how tall the form gets.
// Everything that contributes height reads from here.
// ---------------------------------------------------------------------------
class Density {
  // Inner padding of every input. This is THE knob for field height:
  // rendered height is roughly 20 + 2 * fieldPadY (so 8 -> ~36px).
  static const double fieldPadY = 8;
  // A dense DropdownButton has a hard-coded 24px inner height, taller than a
  // 13px line of text, so it needs 2px less padding to match the text fields.
  static const double dropPadY = fieldPadY - 2;
  static const double fieldFont = 13; // text inside inputs
  static const double labelFont = 10; // the small caps labels
  static const double labelGap = 2; // label -> input, stacked mode
  static const double labelGapX = 6; // label -> input, inline mode
  static const double labelWidth = 86; // label column width, inline mode
  static const double gridSpacing = 6; // between fields (x and y)
  static const double cardPad = 8; // inside a SectionCard
  static const double cardGap = 6; // between SectionCards
}

// ---------------------------------------------------------------------------
// Breakpoints — tweak these to taste.
// ---------------------------------------------------------------------------
class Breakpoints {
  static const double tablet = 640; // >= this width -> at least 2 columns
  static const double desktop = 1024; // >= this width -> 4 columns

  /// >= this width -> labels sit to the LEFT of their field instead of above
  /// it, which removes a whole text line from every row.
  ///
  /// Deliberately above the desktop breakpoint: iPads land below it (portrait
  /// is <= 1024, landscape is 1080-1180 on every model but the 12.9" Pro), so
  /// they keep the taller but easier-to-read stacked layout. Lower this to
  /// 1024 if you want inline labels on iPad landscape too.
  static const double inlineLabel = 1200;

  /// Base column count for the current width.
  static int columns(double width) {
    if (width >= desktop) return 4;
    if (width >= tablet) return 2;
    return 1;
  }
}

// ---------------------------------------------------------------------------
// Carries the label-placement decision down to every field, so the choice is
// made ONCE from the real screen width instead of each field guessing from
// its own (narrow) column.
// ---------------------------------------------------------------------------
class FormLayout extends InheritedWidget {
  final bool inlineLabels;

  const FormLayout({
    super.key,
    required this.inlineLabels,
    required super.child,
  });

  static bool inlineOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FormLayout>()?.inlineLabels ??
      false;

  @override
  bool updateShouldNotify(FormLayout oldWidget) =>
      oldWidget.inlineLabels != inlineLabels;
}

/// Puts [label] next to [child] on wide screens and above it otherwise.
/// Every labelled field in this form is built from it, so the two layouts
/// can never drift apart.
class _FieldShell extends StatelessWidget {
  final String label;
  final Widget child;
  const _FieldShell({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    if (FormLayout.inlineOf(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Two lines allowed so long labels ('DROPOFF NOTES') wrap instead of
          // being ellipsised — still shorter than the input beside them, so
          // the row does not grow.
          SizedBox(
            width: Density.labelWidth,
            child: _FieldLabel(label, maxLines: 2),
          ),
          const SizedBox(width: Density.labelGapX),
          Expanded(child: child),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: Density.labelGap),
        child,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Keyboard traversal.
//
// Tab walks the form in visual order: every field, then the action buttons.
// Two things make it feel smooth rather than jumpy:
//   * [smoothTraversalFocus] animates the scroll that brings the next field
//     into view, instead of Flutter's default instant jump.
//   * [_FocusRing] fades a highlight in behind whichever field has focus.
// ---------------------------------------------------------------------------

/// Same behaviour as Flutter's default traversal scroll — including only
/// scrolling when the target is actually off-screen — but animated.
void smoothTraversalFocus(
  FocusNode node, {
  ScrollPositionAlignmentPolicy? alignmentPolicy,
  double? alignment,
  Duration? duration,
  Curve? curve,
}) {
  FocusTraversalPolicy.defaultTraversalRequestFocusCallback(
    node,
    // Passed straight through: the policy sends keepVisibleAtEnd going
    // forward and keepVisibleAtStart going back, which is what stops an
    // already-visible field from being yanked to the edge of the viewport.
    alignmentPolicy: alignmentPolicy,
    alignment: alignment,
    duration: duration ?? const Duration(milliseconds: 200),
    curve: curve ?? Curves.easeOutCubic,
  );
}

/// Fades a soft highlight in behind [child] while it (or anything inside it)
/// holds focus, so the eye can follow Tab from field to field.
///
/// Draws with a shadow only — no border, no padding — so adding it cannot
/// change any field's height.
class _FocusRing extends StatefulWidget {
  final Widget child;
  const _FocusRing({required this.child});

  @override
  State<_FocusRing> createState() => _FocusRingState();
}

class _FocusRingState extends State<_FocusRing> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Focus(
      // Not a tab stop itself — it only listens for focus landing on the
      // real field inside it.
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (has) {
        if (has != _focused) setState(() => _focused = has);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ]
              : const [],
        ),
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// A field that knows how many base columns it wants to occupy.
// span is clamped to the available column count, so a span-2 field
// becomes full-width on a 1-column phone automatically.
// ---------------------------------------------------------------------------
class SpanField {
  final int span;
  final Widget child;
  double? widths;
  SpanField(this.child, {this.span = 1, this.widths});
}

/// Lays SpanField children out on a base grid of [columns] columns and
/// reflows them with a Wrap. Used for every logical section of the form.
class ResponsiveGrid extends StatelessWidget {
  final List<SpanField> children;
  final double spacing;
  final double runSpacing;

  /// Tab order of this grid's first field. Each following field takes the
  /// next number, so sections stay in order as long as their bases are
  /// spaced further apart than any section is long.
  final int orderBase;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.orderBase = 0,
    this.spacing = Density.gridSpacing,
    this.runSpacing = Density.gridSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = Breakpoints.columns(width);
        // Width of one base column, after subtracting the gaps between them.
        final colWidth = (width - spacing * (columns - 1)) / columns;

        double widthForSpan(int span) {
          final s = span.clamp(1, columns);
          return colWidth * s + spacing * (s - 1);
        }

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final (i, f) in children.indexed)
              SizedBox(
                width: f.widths ?? widthForSpan(f.span),
                child: FocusTraversalOrder(
                  order: NumericFocusOrder((orderBase + i).toDouble()),
                  child: _FocusRing(child: f.child),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Small reusable field widgets so the form body stays readable.
// ---------------------------------------------------------------------------
class LabeledInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextInputType? keyboardType;

  /// Optional, so fields that another widget fills in — NAME / EMAIL / TEL,
  /// written by [LabeledMobileField] when a customer is picked — can be driven
  /// from outside. Fields nobody else touches can keep leaving it null.
  final TextEditingController? controller;

  /// Upper-cases as you type, the way the dashboard form treats its address
  /// and notes fields.
  final bool uppercase;

  const LabeledInput(this.label,
      {super.key,
      this.hint,
      this.keyboardType,
      this.controller,
      this.uppercase = false});

  @override
  Widget build(BuildContext context) {
    return _FieldShell(
      label: label,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization:
            uppercase ? TextCapitalization.characters : TextCapitalization.none,
        inputFormatters: uppercase ? const [_UpperCaseTextFormatter()] : null,
        style: const TextStyle(fontSize: Density.fieldFont),
        // So the on-screen keyboard's "next" key walks the form too, not
        // just a hardware Tab.
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}

/// Forces everything typed into a field to upper case, matching the dashboard
/// form's address / notes fields. Defined locally so this file stays free of00
/// the GetX-bound shared component library.
class _UpperCaseTextFormatter extends TextInputFormatter {
  const _UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

// ---------------------------------------------------------------------------
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
// ---------------------------------------------------------------------------

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

class LabeledAddressField extends StatefulWidget {
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
    return _FieldShell(
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
            inputFormatters: const [_UpperCaseTextFormatter()],
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

// ---------------------------------------------------------------------------
// MOBILE field with customer lookup.
//
// Ported from the dashboard booking form so both forms behave identically:
//   * typing filters the known customers by mobile, name or email;
//   * matches drop into an Overlay panel under the field (mobile on top, name
//     underneath), NOT a modal;
//   * ↑ / ↓ walk the list, Enter picks, Esc closes, the mouse highlights;
//   * picking writes the mobile into this field and hands the whole customer
//     back through [onPicked] so NAME / EMAIL / TEL can be filled in.
// ---------------------------------------------------------------------------

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

class LabeledMobileField extends StatefulWidget {
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
    return _FieldShell(
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

class LabeledDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final String? value;
  const LabeledDropdown(this.label,
      {super.key, required this.items, this.value});

  @override
  State<LabeledDropdown> createState() => _LabeledDropdownState();
}

class _LabeledDropdownState extends State<LabeledDropdown> {
  late String? _value = widget.value ?? widget.items.first;

  @override
  Widget build(BuildContext context) {
    return _FieldShell(
      label: widget.label,
      child: DropdownButtonFormField<String>(
        initialValue: _value,
        isExpanded: true,
        isDense: true,
        // null -> the button hugs the text instead of the 48px tap target,
        // which is what makes the dropdowns line up with the text fields.
        itemHeight: null,
        // 16 keeps the icon from becoming the tallest thing in the row.
        iconSize: 16,
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 8, vertical: Density.dropPadY),
        ),
        style:
            const TextStyle(fontSize: Density.fieldFont, color: Colors.black87),
        items: [
          for (final i in widget.items)
            DropdownMenuItem(
              value: i,
              child: Text(i, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: (v) => setState(() => _value = v),
      ),
    );
  }
}

/// Date field backed by the same dropdown calendar the dashboard booking form
/// uses: one Tab stop, Enter / Space / Down opens a calendar anchored under the
/// field, arrow keys move the day, Enter confirms and Esc closes.
class LabeledDatePicker extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onChanged;
  const LabeledDatePicker(this.label,
      {super.key, this.initialDate, this.onChanged});

  @override
  State<LabeledDatePicker> createState() => _LabeledDatePickerState();
}

class _LabeledDatePickerState extends State<LabeledDatePicker> {
  late DateTime _date = widget.initialDate ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return _FieldShell(
      label: widget.label,
      child: _CalendarDropdownField(
        value: _date,
        accent: accent,
        accentSoft: accent.withValues(alpha: 0.12),
        idleColor: Colors.grey,
        textStyle: const TextStyle(
            fontSize: Density.fieldFont, color: Colors.black87),
        onChanged: (d) {
          setState(() => _date = d);
          widget.onChanged?.call(d);
        },
      ),
    );
  }
}

/// Time field backed by the shared `TimePickerField` (HOURS / MINUTES dropdown
/// panel, `HH:mm` 24-hour value) — the same widget the dashboard form uses.
class LabeledTimePicker extends StatefulWidget {
  final String label;
  final String? initialTime; // 'HH:mm'
  final ValueChanged<String>? onChanged;
  const LabeledTimePicker(this.label,
      {super.key, this.initialTime, this.onChanged});

  @override
  State<LabeledTimePicker> createState() => _LabeledTimePickerState();
}

class _LabeledTimePickerState extends State<LabeledTimePicker> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialTime ?? _now());

  static String _now() {
    final n = TimeOfDay.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FieldShell(
      label: widget.label,
      child: TimePickerField(
        controller: _controller,
        accent: Theme.of(context).colorScheme.primary,
        textStyle: const TextStyle(fontSize: Density.fieldFont),
        onChanged: widget.onChanged,
        decoration: const InputDecoration(
          // The prefix icon is drawn by the package, so only the room for it
          // has to be reserved here.
          prefixIconConstraints: BoxConstraints(minWidth: 28, minHeight: 0),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// React-datepicker-style dropdown calendar.
//
// Ported from the dashboard booking form so both forms behave identically:
//   * a single Tab stop — icon, border and value take the accent color;
//   * Enter / Space / Down (or a click) opens an Overlay panel under the field,
//     NOT a modal dialog;
//   * inside the panel: ‹ › page the month, the title toggles the month / year
//     grids, arrows move the selection, PageUp/PageDown page, Enter confirms,
//     Esc closes.
// ---------------------------------------------------------------------------
class _CalendarDropdownField extends StatefulWidget {
  const _CalendarDropdownField({
    required this.value,
    required this.onChanged,
    required this.textStyle,
    required this.accent,
    required this.accentSoft,
    required this.idleColor,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final TextStyle textStyle;
  final Color accent;
  final Color accentSoft;
  final Color idleColor;

  @override
  State<_CalendarDropdownField> createState() => _CalendarDropdownFieldState();
}

class _CalendarDropdownFieldState extends State<_CalendarDropdownField> {
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', //
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  static const _weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  // 0 = days, 1 = months, 2 = years
  static const _viewDays = 0;
  static const _viewMonths = 1;
  static const _viewYears = 2;

  final LayerLink _link = LayerLink();
  final FocusNode _fieldFocus = FocusNode(debugLabel: 'dateField');
  final FocusNode _calendarFocus = FocusNode(debugLabel: 'dateCalendar');
  final GlobalKey _fieldKey = GlobalKey();
  // Shared so a tap on the field is NOT treated as "outside" the calendar
  // (otherwise the field click closes via TapRegion AND reopens via InkWell).
  final Object _tapGroupId = Object();
  OverlayEntry? _entry;

  bool _focused = false;
  int _view = _viewDays;
  late DateTime _visibleMonth; // first-of-month being displayed
  DateTime? _selected;
  late int _yearPageStart;

  @override
  void initState() {
    super.initState();
    _fieldFocus.addListener(_onFocusChange);
    _selected = widget.value;
    final base = widget.value ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
    _yearPageStart = base.year - 5;
  }

  @override
  void didUpdateWidget(covariant _CalendarDropdownField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _selected = widget.value;
      if (widget.value != null) {
        _visibleMonth = DateTime(widget.value!.year, widget.value!.month);
      }
    }
  }

  @override
  void dispose() {
    _closeCalendar(notify: false);
    _fieldFocus.removeListener(_onFocusChange);
    _fieldFocus.dispose();
    _calendarFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focused != _fieldFocus.hasFocus) {
      setState(() => _focused = _fieldFocus.hasFocus);
    }
  }

  bool get _isOpen => _entry != null;

  void _toggleCalendar() => _isOpen ? _closeCalendar() : _openCalendar();

  void _openCalendar() {
    if (_isOpen) return;
    _view = _viewDays;
    final base = _selected ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
    _entry = OverlayEntry(builder: _buildCalendarPanel);
    Overlay.of(context).insert(_entry!);
    setState(() {}); // refresh field chrome (arrow / accent)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _calendarFocus.requestFocus();
    });
  }

  void _closeCalendar({bool notify = true}) {
    _entry?.remove();
    _entry = null;
    if (notify && mounted) setState(() {});
  }

  void _rebuildPanel() => _entry?.markNeedsBuild();

  void _setView(int v) {
    if (v == _viewYears) _yearPageStart = _visibleMonth.year - 5;
    _view = v;
    _rebuildPanel();
  }

  void _navPrev() {
    if (_view == _viewDays) {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    } else if (_view == _viewMonths) {
      _visibleMonth = DateTime(_visibleMonth.year - 1, _visibleMonth.month);
    } else {
      _yearPageStart -= 12;
    }
    _rebuildPanel();
  }

  void _navNext() {
    if (_view == _viewDays) {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    } else if (_view == _viewMonths) {
      _visibleMonth = DateTime(_visibleMonth.year + 1, _visibleMonth.month);
    } else {
      _yearPageStart += 12;
    }
    _rebuildPanel();
  }

  void _pick(DateTime day) {
    _selected = DateTime(day.year, day.month, day.day);
    widget.onChanged(_selected!);
    _closeCalendar();
    _fieldFocus.requestFocus();
  }

  void _moveSelection(int days) {
    final base = _selected ?? _visibleMonth;
    final next = DateTime(base.year, base.month, base.day + days);
    _selected = next;
    _visibleMonth = DateTime(next.year, next.month);
    _view = _viewDays;
    _rebuildPanel();
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _format(DateTime? v) {
    if (v == null) return '';
    final d = v.day.toString().padLeft(2, '0');
    final m = v.month.toString().padLeft(2, '0');
    return '$d / $m / ${v.year}';
  }

  // ── field key handling: open the calendar
  KeyEventResult _onFieldKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.enter ||
        k == LogicalKeyboardKey.numpadEnter ||
        k == LogicalKeyboardKey.space ||
        k == LogicalKeyboardKey.arrowDown) {
      _openCalendar();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ── calendar key handling: navigate / confirm / close
  KeyEventResult _onCalendarKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.arrowLeft) {
      _moveSelection(-1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowRight) {
      _moveSelection(1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp) {
      _moveSelection(-7);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown) {
      _moveSelection(7);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.pageUp) {
      _navPrev();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.pageDown) {
      _navNext();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.numpadEnter) {
      _pick(_selected ?? _visibleMonth);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.escape) {
      _closeCalendar();
      _fieldFocus.requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ──────────────────────────────── field
  @override
  Widget build(BuildContext context) {
    final highlight = _focused || _isOpen;
    final iconColor = highlight ? widget.accent : widget.idleColor;

    // No `label:` here — _FieldShell already renders the caption above or
    // beside the field, exactly like every other field in this form.
    final decoration = InputDecoration(
      prefixIconConstraints:
          const BoxConstraints(minWidth: 28, minHeight: 0),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 8, right: 4),
        child: Icon(Icons.calendar_today, size: 14, color: iconColor),
      ),
      suffixIconConstraints:
          const BoxConstraints(minWidth: 28, minHeight: 0),
      suffixIcon: Icon(
        _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        size: 20,
        color: iconColor,
      ),
    );

    return TapRegion(
      groupId: _tapGroupId,
      child: CompositedTransformTarget(
        link: _link,
        child: Focus(
          focusNode: _fieldFocus,
          onKeyEvent: _onFieldKey,
          child: InkWell(
            key: _fieldKey,
            canRequestFocus: false,
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              _fieldFocus.requestFocus();
              _toggleCalendar();
            },
            child: InputDecorator(
              isFocused: highlight,
              decoration: decoration,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: highlight
                    ? BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(3),
                      )
                    : null,
                child: Text(
                  _format(widget.value),
                  overflow: TextOverflow.ellipsis,
                  style: widget.textStyle.copyWith(
                    color: highlight ? widget.accent : widget.textStyle.color,
                    fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────── calendar popup
  Widget _buildCalendarPanel(BuildContext context) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth = box?.size.width ?? 280.0;
    final fieldHeight = box?.size.height ?? 40.0;
    final panelWidth = fieldWidth < 300 ? 300.0 : fieldWidth;

    return Positioned(
      width: panelWidth,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        offset: Offset(0, fieldHeight + 4),
        child: TapRegion(
          groupId: _tapGroupId,
          onTapOutside: (_) => _closeCalendar(),
          child: Focus(
            focusNode: _calendarFocus,
            onKeyEvent: _onCalendarKey,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _header(),
                    const SizedBox(height: 8),
                    if (_view == _viewDays) ...[
                      _weekdayRow(),
                      const SizedBox(height: 4),
                      _daysGrid(),
                    ] else if (_view == _viewMonths)
                      _monthsGrid()
                    else
                      _yearsGrid(),
                    const SizedBox(height: 6),
                    _footer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final String title = _view == _viewYears
        ? '$_yearPageStart - ${_yearPageStart + 11}'
        : '${_months[_visibleMonth.month - 1]} ${_visibleMonth.year}';
    return Row(
      children: [
        _navButton(Icons.chevron_left, _navPrev),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => _setView(_view == _viewDays ? _viewYears : _viewDays),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: widget.accent,
                  ),
                ),
              ),
            ),
          ),
        ),
        _navButton(Icons.chevron_right, _navNext),
      ],
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) => InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: widget.accent),
        ),
      );

  Widget _weekdayRow() => Row(
        children: [
          for (final w in _weekdays)
            Expanded(
              child: Center(
                child: Text(
                  w,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: widget.accent.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
        ],
      );

  Widget _daysGrid() {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday % 7; // Sunday = 0
    final today = DateTime.now();

    final cells = <Widget>[];
    for (var i = 0; i < leadingBlanks; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var d = 1; d <= daysInMonth; d++) {
      final day = DateTime(_visibleMonth.year, _visibleMonth.month, d);
      final isSelected = _selected != null && _sameDay(_selected!, day);
      final isToday = _sameDay(today, day);
      cells.add(_dayCell(d, isSelected, isToday, () => _pick(day)));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      childAspectRatio: 1.1,
      children: cells,
    );
  }

  Widget _dayCell(int day, bool selected, bool today, VoidCallback onTap) {
    Color bg = Colors.transparent;
    Color fg = Colors.black87;
    if (selected) {
      bg = widget.accent;
      fg = Colors.white;
    } else if (today) {
      bg = widget.accentSoft;
      fg = widget.accent;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: today && !selected
              ? Border.all(color: widget.accent, width: 1)
              : null,
        ),
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 12,
            color: fg,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _monthsGrid() => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.8,
        children: [
          for (var m = 1; m <= 12; m++)
            _chip(
              _months[m - 1].substring(0, 3),
              m == _visibleMonth.month,
              () {
                _visibleMonth = DateTime(_visibleMonth.year, m);
                _setView(_viewDays);
              },
            ),
        ],
      );

  Widget _yearsGrid() => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.8,
        children: [
          for (var i = 0; i < 12; i++)
            _chip(
              '${_yearPageStart + i}',
              (_yearPageStart + i) == _visibleMonth.year,
              () {
                _visibleMonth = DateTime(_yearPageStart + i, _visibleMonth.month);
                _setView(_viewMonths);
              },
            ),
        ],
      );

  Widget _chip(String label, bool selected, VoidCallback onTap) => InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? widget.accent : widget.accentSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : widget.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  Widget _footer() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _pick(DateTime.now()),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Today',
              style: TextStyle(
                  color: widget.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () {
              _closeCalendar();
              _fieldFocus.requestFocus();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
}

class LabeledCheckbox extends StatefulWidget {
  final String label;
  final bool value;
  final MainAxisAlignment mainAxisAlignment;
  const LabeledCheckbox(this.label, {super.key, this.value = false,
    this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  State<LabeledCheckbox> createState() => _LabeledCheckboxState();
}

class _LabeledCheckboxState extends State<LabeledCheckbox> {
  late bool _v = widget.value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // In stacked mode the fields beside this one carry a label above them,
      // so nudge down to stay aligned. Inline mode needs no nudge.
      padding: EdgeInsets.only(
        top: FormLayout.inlineOf(context)
            ? 0
            : Density.labelFont + Density.labelGap,
      ),
      child: InkWell(
        // The Checkbox inside is already a tab stop; letting the InkWell take
        // focus too would make every checkbox cost two Tab presses.
        canRequestFocus: false,
        onTap: () => setState(() => _v = !_v),
        child: Row(
          // mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _v,
              onChanged: (x) => setState(() => _v = x ?? false),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                widget.label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: Density.fieldFont),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final int maxLines;
  const _FieldLabel(this.text, {this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: Density.labelFont,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: Color(0xFF444444),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Density.cardGap),
      padding: const EdgeInsets.all(Density.cardPad),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// The screen itself.
// ---------------------------------------------------------------------------
class CreateNewBookingForm extends StatefulWidget {
  const CreateNewBookingForm({super.key});

  @override
  State<CreateNewBookingForm> createState() => _CreateNewBookingFormState();
}

class _CreateNewBookingFormState extends State<CreateNewBookingForm> {
  // The contact block is controller-driven because picking a customer in the
  // MOBILE field has to write into the three fields beside it.
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _tel = TextEditingController();

  // Likewise the four locations: swapping exchanges the text of a pair.
  final _pick = TextEditingController();
  final _drop = TextEditingController();
  final _rPick = TextEditingController();
  final _rDrop = TextEditingController();

  // Deliberately empty: this screen makes no API call, so there is nothing to
  // suggest and the fields behave as plain (upper-cased) text inputs. Feed a
  // real list into each LabeledAddressField's `addresses` and the lookup panel
  // starts working with no other change.
  static const _addresses = <AddressSuggestion>[];

  // Stand-in for the customer lookup the dashboard form gets from the backend.
  // Replace with real results and call setState (or pass a fresh list in) —
  // LabeledMobileField re-filters whenever the list changes.
  static const _customers = <CustomerSuggestion>[
    CustomerSuggestion(
        mobile: '07700 900111',
        name: 'JOHN SMITH',
        email: 'john.smith@example.com',
        telephone: '0121 496 0111'),
    CustomerSuggestion(
        mobile: '07700 900222',
        name: 'SARAH JONES',
        email: 'sarah.jones@example.com',
        telephone: '0121 496 0222'),
    CustomerSuggestion(
        mobile: '07700 900333',
        name: 'DAVID BROWN',
        email: 'd.brown@example.com',
        telephone: '0121 496 0333'),
  ];

  @override
  void dispose() {
    for (final c in [
      _name,
      _email,
      _mobile,
      _tel,
      _pick,
      _drop,
      _rPick,
      _rDrop,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onCustomerPicked(CustomerSuggestion c) {
    setState(() {
      _name.text = c.name;
      _email.text = c.email;
      _tel.text = c.telephone;
    });
  }

  /// Exchanges a pickup with its drop, like the dashboard's swap button.
  void _swap(TextEditingController a, TextEditingController b) {
    final tmp = a.text;
    a.text = b.text;
    b.text = tmp;
  }

  @override
  Widget build(BuildContext context) {
    const zones = ['SELECT ZONE', 'Zone A', 'Zone B', 'Zone C'];
    const vehicles = ['SALOON', 'ESTATE', 'MPV', 'EXECUTIVE'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Theme(
          // Applied here so the compact field heights survive even if this
          // screen is embedded under someone else's MaterialApp.
          data:
              Theme.of(context).copyWith(inputDecorationTheme: denseInputTheme),
          child: LayoutBuilder(
            builder: (context, constraints) => FormLayout(
              // Decided once, from the real screen width, for the whole form.
              inlineLabels: constraints.maxWidth >= Breakpoints.inlineLabel,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Center(
                  // Cap the width on very large screens so the form doesn't stretch
                  // into an unusable full-bleed layout on big monitors.
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: FocusTraversalGroup(
                      // Explicit order rather than geometry: a Wrap can place
                      // a short field (a checkbox) above a tall one, which is
                      // enough to confuse reading-order traversal.
                      policy: OrderedTraversalPolicy(
                        requestFocusCallback: smoothTraversalFocus,
                      ),
                      child: Column(
                        children: [
                          const _TopTabs(),
                          const SizedBox(height: Density.cardGap),

                          // ---- Booking header: source + sub ----
                          SectionCard(
                            child: ResponsiveGrid(
                              orderBase: 100,
                              children: [
                                SpanField(_HeaderTitle('BOOKING'), span: 2),
                                SpanField(LabeledDropdown('SOURCE',
                                    items: ['OPT', 'WEB', 'APP', 'PHONE'])),
                                SpanField(LabeledDropdown('SUB', items: [
                                  'DEMO COMPANY',
                                  'Company 2',
                                  'Company 3'
                                ])),
                              ],
                            ),
                          ),

                          // ---- Pick / Drop + contact ----
                          SectionCard(
                            child: ResponsiveGrid(
                              orderBase: 200,
                              children: [
                                SpanField(
                                    LabeledAddressField(
                                      'PICK',
                                      controller: _pick,
                                      addresses: _addresses,
                                      dotColor: Colors.green,
                                      onSwap: () => _swap(_pick, _drop),
                                    ),
                                    span: 2),
                                SpanField(
                                    LabeledDropdown('PICK ZONE', items: zones)),
                                SpanField(
                                    LabeledInput('PICKUP NOTES',
                                        uppercase: true)),
                                SpanField(
                                    LabeledAddressField(
                                      'DROP',
                                      controller: _drop,
                                      addresses: _addresses,
                                      dotColor: Colors.red,
                                      onSwap: () => _swap(_pick, _drop),
                                    ),
                                    span: 2),
                                SpanField(
                                    LabeledDropdown('DROP ZONE', items: zones)),
                                SpanField(
                                    LabeledInput('DROPOFF NOTES',
                                        uppercase: true)),
                                SpanField(
                                    LabeledInput('NAME', controller: _name)),
                                SpanField(LabeledInput('EMAIL',
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress)),
                                SpanField(LabeledMobileField(
                                  'MOBILE',
                                  controller: _mobile,
                                  customers: _customers,
                                  onPicked: _onCustomerPicked,
                                )),
                                SpanField(LabeledInput('TEL',
                                    controller: _tel,
                                    keyboardType: TextInputType.phone)),
                              ],
                            ),
                          ),

                          // ---- Dates & times ----
                          SectionCard(
                            child: ResponsiveGrid(
                              orderBase: 300,
                              children: [
                                SpanField(LabeledDatePicker('DATE')),
                                SpanField(LabeledTimePicker('TIME')),
                                SpanField(LabeledDatePicker('R/DATE')),
                                SpanField(LabeledTimePicker('R/TIME')),
                                SpanField(
                                    LabeledAddressField(
                                      'R/PICK',
                                      controller: _rPick,
                                      addresses: _addresses,
                                      dotColor: Colors.green,
                                      onSwap: () => _swap(_rPick, _rDrop),
                                    ),
                                    span: 2),
                                SpanField(LabeledDropdown('R/PICK ZONE',
                                    items: zones)),
                                SpanField(
                                    LabeledInput('R/PICK NOTES',
                                        uppercase: true)),
                                SpanField(
                                    LabeledAddressField(
                                      'R/DROP',
                                      controller: _rDrop,
                                      addresses: _addresses,
                                      dotColor: Colors.red,
                                      onSwap: () => _swap(_rPick, _rDrop),
                                    ),
                                    span: 2),
                                SpanField(LabeledDropdown('R/DROP ZONE',
                                    items: zones)),
                                SpanField(
                                    LabeledInput('R/DROP NOTES',
                                        uppercase: true)),
                              ],
                            ),
                          ),

                          // ---- Journey details ----
                          SectionCard(
                            child: ResponsiveGrid(
                              orderBase: 400,
                              children: [
                                SpanField(LabeledInput('LEAD (MINS)',
                                    keyboardType: TextInputType.number)),
                                SpanField(LabeledDropdown('JOUR',
                                    items: ['R/N', 'ONE WAY'])),
                                SpanField(
                                    LabeledDropdown('VEH', items: vehicles)),
                                SpanField(
                                    LabeledDropdown('R/VEH', items: vehicles)),
                                SpanField(LabeledDropdown('ACC', items: [
                                  'SELECT ACCOUNT',
                                  'Account 1',
                                  'Account 2'
                                ])),
                                SpanField(LabeledInput('PASS',
                                    keyboardType: TextInputType.number)),
                                SpanField(LabeledInput('LUGG',
                                    keyboardType: TextInputType.number)),
                                SpanField(LabeledInput('SLGG',
                                    keyboardType: TextInputType.number)),
                              ],
                            ),
                          ),

                          // ---- Payment + options ----
                          SectionCard(
                            child: ResponsiveGrid(
                              orderBase: 500,
                              children: [
                                SpanField(LabeledDropdown('PAY', items: [
                                  'CASH',
                                  'CARD',
                                  'ACCOUNT',
                                  'INVOICE'
                                ])),
                                SpanField(LabeledInput('R/LEAD (MINS)',
                                    keyboardType: TextInputType.number)),
                                SpanField(LabeledCheckbox('QUOTATION'),widths: 110),
                                SpanField(LabeledCheckbox('SMS', value: true),widths: 80),
                                SpanField(LabeledCheckbox('EMAIL'),widths: 80),
                                SpanField(ASDF()),
                                // SpanField(LabeledCheckbox('ADD RETURN FARE')),
                              ],
                            ),
                          ),

                          // ---- Fares row ----
                          SectionCard(
                            child: Column(
                              children: [
                                _StatStrip(),
                                SizedBox(height: Density.gridSpacing),
                                ResponsiveGrid(
                                  orderBase: 600,
                                  children: [
                                    SpanField(LabeledInput('FARE (£)',
                                        keyboardType: TextInputType.number)),
                                    SpanField(LabeledInput('R/FARE (£)',
                                        keyboardType: TextInputType.number)),
                                    SpanField(LabeledDropdown('DRV', items: [
                                      'SELECT DRIVER',
                                      'Driver 1',
                                      'Driver 2'
                                    ])),
                                    SpanField(LabeledDropdown('R/DRV', items: [
                                      'SELECT DRIVER',
                                      'Driver 1',
                                      'Driver 2'
                                    ])),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ---- Action buttons ----
                          const _ActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  final String text;
  const _HeaderTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

class _GlowFocus extends StatelessWidget {
  const _GlowFocus({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}

class ASDF extends StatelessWidget {
  const ASDF({super.key});
  static const _border = Colors.black;
  static const _purpleSoft = Color(0xFFEEF2FF);

  @override
  Widget build(BuildContext context) {
    Widget commsAndLuggageRow(bool isMobile) {
      Widget iconBtn(
          IconData icon, {
            VoidCallback? onPressed,
            required int tab,
          }) {
        return FocusTraversalOrder(
          order: NumericFocusOrder(tab.toDouble()),
          child: _GlowFocus(
            child: Focus(
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    (event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.space)) {
                  onPressed?.call();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Container(
                margin: const EdgeInsets.only(left: 6),
                decoration: BoxDecoration(
                  color: _purpleSoft,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _border),
                ),
                child: IconButton(
                  onPressed: onPressed,
                  padding: const EdgeInsets.all(4),
                  visualDensity: VisualDensity.compact,
                  splashRadius: 18,
                  icon: Icon(
                    icon,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      final right = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconBtn(
            Icons.person,
            tab: 24,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => RestrictDriversAlert(),
              );
            },
          ),
          iconBtn(
            Icons.attach_money,
            tab: 25,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ChildSeatsAlert(),
              );
            },
          ),
          iconBtn(
            Icons.note_add,
            tab: 26,
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => ExtraFaresAlert(),
              );
            },
          ),
          iconBtn(
            Icons.calculate,
            tab: 27,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ExtraInfoAlert(),
              );
            },
          ),
        ],
      );

      return right;
    }

    return commsAndLuggageRow(false);
  }
}


class _TopTabs extends StatelessWidget {
  const _TopTabs();
  @override
  Widget build(BuildContext context) {
    Widget tab(String key, String label, {bool active = false}) => Container(
          margin: const EdgeInsets.only(right: 6, bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF312E81) : const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: active ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(key,
                    style: TextStyle(
                        fontSize: 11,
                        color: active ? Colors.white : Colors.black87)),
              ),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : Colors.black87)),
            ],
          ),
        );

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: [
          tab('F1', 'BASE ADDRESS'),
          tab('F2', 'BOOKING FORM', active: true),
          tab('F6', 'QUOTATION'),
        ],
      ),
    );
  }
}

class _StatStrip extends StatelessWidget {
  const _StatStrip();
  @override
  Widget build(BuildContext context) {
    Widget stat(IconData icon, String label) => Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: [
          stat(Icons.info_outline, 'ETA: 0 M'),
          stat(Icons.timer_outlined, 'TIME: 0 M'),
          stat(Icons.route, 'DISTANCE: 0 M'),
          stat(Icons.payments_outlined, 'T/FARES: £ 0'),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= Breakpoints.tablet;
        // 700+ keeps the buttons last in the tab order, after every field.
        final buttons = <Widget>[
          _btn(700, 'MULTI BOOKING [F8]', const Color(0xFFBDBDBD),
              Colors.black87),
          _btn(701, 'MULTI VEHICLE [F9]', const Color(0xFFBDBDBD),
              Colors.black87),
          _btn(702, 'CLEAR [F7]', const Color(0xFFD32F2F), Colors.white),
          _btn(703, 'SAVE [HOME]', const Color(0xFF312E81), Colors.white),
        ];
        return wide
            ? Row(
                children: [
                  for (final b in buttons)
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(3), child: b)),
                ],
              )
            : Column(
                children: [
                  for (final b in buttons)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: SizedBox(width: double.infinity, child: b),
                    ),
                ],
              );
      },
    );
  }

  Widget _btn(int order, String label, Color bg, Color fg) =>
      FocusTraversalOrder(
        order: NumericFocusOrder(order.toDouble()),
        child: _FocusRing(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: fg,
              padding: const EdgeInsets.symmetric(vertical: 10),
              minimumSize: const Size(0, 34),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      );
}
