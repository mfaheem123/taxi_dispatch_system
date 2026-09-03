// labeled_checkbox.dart
//
// Inline checkbox field (QUOTATION, SMS, EMAIL, ...).
// See create_new_booking_form.dart for how this fits into the wider form.

import 'package:flutter/material.dart';

import 'booking_form_layout.dart';

class LabeledCheckbox extends StatefulWidget implements LabelledField {
  @override
  final String label;
  final bool value;
  final MainAxisAlignment mainAxisAlignment;

  /// Draws a round tick box instead of a square one, for the update form's
  /// QUOTATION / ADD RETURN FARE options. Still a checkbox in behaviour —
  /// each one toggles on its own, they are not a radio group.
  final bool circular;

  final ValueChanged<bool>? onChanged;

  const LabeledCheckbox(this.label, {super.key, this.value = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.circular = false,
    this.onChanged});

  @override
  State<LabeledCheckbox> createState() => _LabeledCheckboxState();
}

class _LabeledCheckboxState extends State<LabeledCheckbox> {
  late bool _v = widget.value;

  void _set(bool v) {
    setState(() => _v = v);
    widget.onChanged?.call(v);
  }

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
        onTap: () => _set(!_v),
        child: Row(
          // mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _v,
              onChanged: (x) => _set(x ?? false),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: widget.circular ? const CircleBorder() : null,
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
