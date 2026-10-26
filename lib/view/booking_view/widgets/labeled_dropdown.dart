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
class LabeledZoneDropdown extends StatelessWidget implements LabelledField {
  @override
  final String label;
  final List<ZoneObject> items;
  final ZoneObject? value;
  final ValueChanged<ZoneObject?>? onChanged;

  const LabeledZoneDropdown(this.label,
      {super.key, required this.items, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    // A value that no longer appears in `items` (list just reloaded, or
    // nothing loaded yet) would make DropdownButtonFormField assert — show no
    // selection instead of crashing, exactly like LabeledDropdown does.
    final selected = value != null && items.contains(value) ? value : null;
    return FieldShell(
      label: label,
      child: DropdownButtonFormField<ZoneObject>(
        initialValue: selected,
        isExpanded: true,
        isDense: true,
        itemHeight: null,
        iconSize: 16,
        hint: const Text('SELECT ZONE', style: kFormDropdownHintStyle),
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 8, vertical: Density.dropPadY),
        ),
        style: kFormValueStyle,
        items: [
          for (final z in items)
            DropdownMenuItem(
              value: z,
              child: Text(z.name ?? '', overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: onChanged,
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

  const LabeledObjectDropdown(this.label,
      {super.key,
      required this.items,
      required this.itemLabel,
      this.value,
      this.onChanged,
      this.hint});

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

  // A value missing from `items` (list reloading, nothing loaded yet) would
  // make DropdownButtonFormField assert — show no selection instead.
  T? get _selected =>
      widget.value != null && widget.items.contains(widget.value)
          ? widget.value
          : null;

  void _onChanged(T? picked) {
    widget.onChanged?.call(picked);
    // The parent applies the pick with setState, so its answer is only
    // visible in the next build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selected == picked) return;
      final hadFocus = _focusNode.hasFocus;
      setState(() => _generation++);
      if (hadFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _focusNode.requestFocus();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final itemLabel = widget.itemLabel;
    return FieldShell(
      label: widget.label,
      child: DropdownButtonFormField<T>(
        key: ValueKey(_generation),
        focusNode: _focusNode,
        initialValue: _selected,
        isExpanded: true,
        isDense: true,
        itemHeight: null,
        iconSize: 16,
        hint: Text(widget.hint ?? 'SELECT', style: kFormDropdownHintStyle),
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 8, vertical: Density.dropPadY),
        ),
        style: kFormValueStyle,
        items: [
          for (final i in items)
            DropdownMenuItem<T>(
              value: i,
              child: Text(itemLabel(i), overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: widget.onChanged == null ? null : _onChanged,
      ),
    );
  }
}
