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
        style:
            const TextStyle(fontSize: Density.fieldFont, color: Colors.black87),
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
        hint: const Text('SELECT ZONE',
            style: TextStyle(fontSize: Density.fieldFont, color: Colors.black45)),
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 8, vertical: Density.dropPadY),
        ),
        style:
            const TextStyle(fontSize: Density.fieldFont, color: Colors.black87),
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
