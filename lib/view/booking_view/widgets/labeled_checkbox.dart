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
