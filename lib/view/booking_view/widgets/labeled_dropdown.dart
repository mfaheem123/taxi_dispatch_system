// labeled_dropdown.dart
//
// Plain string dropdown (SOURCE, SUB, VEH, ACC, ...) and the zone dropdown
// bound to the dashboard's ZoneObject list (PICK ZONE, DROP ZONE, ...).
// See create_new_booking_form.dart for how these fit into the wider form.

import 'package:flutter/material.dart';

import '../../locations_view/Model/location_types_zoneModel.dart'
    show ZoneObject;
import 'booking_form_layout.dart';

class LabeledDropdown extends StatefulWidget implements LabelledField {
  @override
  final String label;
  final List<String> items;
  final String? value;

  /// Fired with the new selection. Optional, so the dropdowns nobody listens to
  /// can keep their own state and nothing else — JOUR needs it to tell the form
  /// whether the booking has a return leg.
  final ValueChanged<String?>? onChanged;

  const LabeledDropdown(this.label,
      {super.key, required this.items, this.value, this.onChanged});

  @override
  State<LabeledDropdown> createState() => _LabeledDropdownState();
}

class _LabeledDropdownState extends State<LabeledDropdown> {
  late String? _value = widget.value ?? widget.items.first;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LabeledDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Belt and braces for a State that ends up paired with a different item
    // list — an unkeyed cell moving position, or an items list fed from a
    // future backend call. DropdownButtonFormField asserts that its value
    // appears exactly once among its items, so re-seed instead of crashing.
    if (!widget.items.contains(_value)) {
      _value = widget.items.contains(widget.value)
          ? widget.value
          : (widget.items.isEmpty ? null : widget.items.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: widget.label,
      child: _FocusOnPress(
        node: _focusNode,
        child: DropdownButtonFormField<String>(
          focusNode: _focusNode,
          initialValue: _value,
          isExpanded: true,
          isDense: true,
          // null -> the button hugs the text instead of the 48px tap target,
          // which is what makes the dropdowns line up with the text fields.
          itemHeight: null,
          // 16 keeps the icon from becoming the tallest thing in the row.
          iconSize: 16,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: Density.fieldPadX, vertical: Density.dropPadY),
          ),
          style: kFormValueStyle,
          items: [
            for (final i in widget.items)
              DropdownMenuItem(
                value: i,
                child: Text(i, overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: (v) {
            setState(() => _value = v);
            widget.onChanged?.call(v);
          },
        ),
      ),
    );
  }
}

/// Zone dropdown bound straight to a [ZoneObject] — the same dynamic list the
/// dashboard form's PICKUP/DROP zone dropdowns read from
/// (`LocationController.locationtypezoneModel.zonesList`), fed by whichever
/// controller field this instance is wired to (`dashboardZoneValue`,
/// `dashboardDZoneValue`, `RNzoneValue`, `RN1zoneValue`).
///
/// Deliberately stateless: unlike [LabeledDropdown] it must always show
/// whatever the bound controller field currently holds (that field can be
/// reset from outside — cleared, swapped, reloaded), so there is no internal
/// `_value` to fall out of sync. `initialValue` still reacts to changes
/// because DropdownButtonFormField re-seeds itself whenever `initialValue`
/// differs from the previous build (see Flutter's dropdown.dart).
class LabeledZoneDropdown extends StatefulWidget implements LabelledField {
  @override
  final String label;
  final List<ZoneObject> items;
  final ZoneObject? value;
  final ValueChanged<ZoneObject?>? onChanged;

  const LabeledZoneDropdown(this.label,
      {super.key, required this.items, this.value, this.onChanged});

  @override
  State<LabeledZoneDropdown> createState() => _LabeledZoneDropdownState();
}

/// Holds nothing but the focus node — the selection still comes straight
/// from [LabeledZoneDropdown.value] on every build.
class _LabeledZoneDropdownState extends State<LabeledZoneDropdown> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final value = widget.value;
    // A value that no longer appears in `items` (list just reloaded, or
    // nothing loaded yet) would make DropdownButtonFormField assert — show no
    // selection instead of crashing, exactly like LabeledDropdown does.
    final selected = value != null && items.contains(value) ? value : null;
    return FieldShell(
      label: widget.label,
      child: _FocusOnPress(
        node: _focusNode,
        child: DropdownButtonFormField<ZoneObject?>(
          focusNode: _focusNode,
          initialValue: selected,
          isExpanded: true,
          isDense: true,
          itemHeight: null,
          iconSize: 16,
          hint: const Text('SELECT ZONE', style: kFormDropdownHintStyle),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: Density.fieldPadX, vertical: Density.dropPadY),
          ),
          style: kFormValueStyle,
          items: [
            const DropdownMenuItem<ZoneObject?>(
              value: null,
              child: _UnselectEntry('SELECT ZONE'),
            ),
            for (final z in items)
              DropdownMenuItem(
                value: z,
                child: Text(z.name ?? '', overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

/// Dropdown bound to a list of model objects (vehicle types, accounts,
/// drivers, ...) and to whichever controller field holds the selection.
///
/// Always shows what the bound field currently holds, since that field is also
/// changed from outside (CLEAR, a booking being loaded, a journey-type reset).
///
/// That includes a pick the parent REFUSES — JOUR before PICK and DROP are
/// filled. DropdownButtonFormField stores the picked item in its own state and
/// only re-seeds when `initialValue` changes, which a refusal never does, so
/// the rejected item stayed on screen. After each pick this checks whether the
/// parent took it and, if not, rebuilds the field from the bound value.
class LabeledObjectDropdown<T> extends StatefulWidget implements LabelledField {
  @override
  final String label;
  final List<T> items;
  final T? value;
  final String Function(T item) itemLabel;
  final ValueChanged<T?>? onChanged;

  /// Shown while nothing is selected.
  final String? hint;

  /// Puts the [hint] at the top of the open menu as an entry of its own, so
  /// the user can clear the selection — the dashboard form's `allowUnselect`.
  /// Off for the fields a booking can't be without (journey type, vehicle,
  /// payment).
  final bool allowUnselect;

  const LabeledObjectDropdown(this.label,
      {super.key,
      required this.items,
      required this.itemLabel,
      this.value,
      this.onChanged,
      this.hint,
      this.allowUnselect = true});

  @override
  State<LabeledObjectDropdown<T>> createState() =>
      _LabeledObjectDropdownState<T>();
}

class _LabeledObjectDropdownState<T> extends State<LabeledObjectDropdown<T>> {
  /// Bumped to throw away the field's internal state after a refused pick.
  int _generation = 0;

  /// Kept across those rebuilds so a keyboard user stays on the field.
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<T> get _uniqueItems {
    final list = <T>[];
    for (final item in widget.items) {
      if (!list.contains(item)) {
        list.add(item);
      }
    }
    return list;
  }

  // A value missing from `items` (list reloading, nothing loaded yet) or having
  // duplicate instances would make DropdownButtonFormField assert — show no
  // selection instead.
  T? get _selected {
    if (widget.value == null) return null;
    final matches = _uniqueItems.where((i) => i == widget.value).toList();
    return matches.length == 1 ? matches.first : null;
  }

  void _onChanged(T? picked) {
    widget.onChanged?.call(picked);
    // The parent applies the pick with setState, so its answer is only
    // visible in the next build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_selected == picked) {
        // A pick leaves the keyboard user on this field, so Tab carries on to
        // the next one. The parent's handler can pull focus elsewhere first —
        // JOUR's DashboardController.changeJourneyFtn() requests focus on the
        // dashboard's return-address nodes — so take it back.
        if (!_focusNode.hasFocus) _focusNode.requestFocus();
        return;
      }
      setState(() => _generation++);
      // Refused pick: the field is rebuilt, so focus goes back to it on the
      // frame after.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _uniqueItems;
    final itemLabel = widget.itemLabel;
    final hint = widget.hint ?? 'SELECT';
    return FieldShell(
      label: widget.label,
      child: _FocusOnPress(
        node: _focusNode,
        child: DropdownButtonFormField<T?>(
          key: ValueKey(_generation),
          focusNode: _focusNode,
          initialValue: _selected,
          isExpanded: true,
          isDense: true,
          itemHeight: null,
          iconSize: 16,
          hint: Text(hint, style: kFormDropdownHintStyle),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: Density.fieldPadX, vertical: Density.dropPadY),
          ),
          style: kFormValueStyle,
          items: [
            if (widget.allowUnselect)
              DropdownMenuItem<T?>(value: null, child: _UnselectEntry(hint)),
            for (final i in items)
              DropdownMenuItem<T?>(
                value: i,
                child: Text(itemLabel(i), overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: widget.onChanged == null ? null : _onChanged,
        ),
      ),
    );
  }
}

/// The "SELECT …" entry at the top of an open menu, as on the dashboard form.
/// Styled as the placeholder, so the closed field still reads as empty once
/// it is picked.
class _UnselectEntry extends StatelessWidget {
  final String text;
  const _UnselectEntry(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      overflow: TextOverflow.ellipsis, style: kFormDropdownHintStyle);
}

/// Focuses the dropdown as soon as the pointer goes down on it — before the
/// tap opens its menu. A mouse click doesn't focus a DropdownButton by itself,
/// so the menu would close back onto whichever field had focus before; with
/// the dropdown focused first, closing the menu (pick, Esc or click outside)
/// leaves focus on it and Tab carries on from here.
class _FocusOnPress extends StatelessWidget {
  final FocusNode node;
  final Widget child;
  const _FocusOnPress({required this.node, required this.child});

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: (_) {
          if (!node.hasFocus) node.requestFocus();
        },
        child: child,
      );
}
