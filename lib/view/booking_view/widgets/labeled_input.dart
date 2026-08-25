// labeled_input.dart
//
// Plain single-line text field used across the booking form (NAME, EMAIL,
// notes, numeric fields, ...). See create_new_booking_form.dart for context.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'booking_form_layout.dart';

class LabeledInput extends StatelessWidget implements LabelledField {
  @override
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

  /// Small glyph inside the field, ahead of the text — the car on the notes
  /// fields, the magnifier on a search box. Sized and padded here so every
  /// field that takes one lines up with the ones that don't.
  final IconData? prefixIcon;

  /// Fixed text ahead of the input, for the return leg's 'R/' markers. Shown
  /// after [prefixIcon] when both are set.
  final String? prefixText;

  /// Greys the field out and blocks typing, for values the form derives
  /// rather than accepts.
  final bool readOnly;

  const LabeledInput(this.label,
      {super.key,
      this.hint,
      this.keyboardType,
      this.controller,
      this.uppercase = false,
      this.prefixIcon,
      this.prefixText,
      this.readOnly = false});

  /// The prefix row, or null when this field has neither part of one.
  /// Built as a single widget so the two can share one width constraint.
  Widget? _prefix() {
    if (prefixIcon == null && prefixText == null) return null;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null)
            Icon(prefixIcon, size: 14, color: Colors.grey.shade600),
          if (prefixIcon != null && prefixText != null)
            const SizedBox(width: 3),
          if (prefixText != null)
            Text(prefixText!,
                style: TextStyle(
                    fontSize: Density.fieldFont, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: label,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        textCapitalization:
            uppercase ? TextCapitalization.characters : TextCapitalization.none,
        inputFormatters: uppercase ? const [UpperCaseTextFormatter()] : null,
        style: const TextStyle(fontSize: Density.fieldFont),
        // So the on-screen keyboard's "next" key walks the form too, not
        // just a hardware Tab.
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hint,
          // Overridden because the default 48px minimum would make a field
          // with a prefix taller than its neighbours.
          prefixIconConstraints:
              const BoxConstraints(minWidth: 24, minHeight: 0),
          prefixIcon: _prefix(),
        ),
      ),
    );
  }
}

/// Forces everything typed into a field to upper case, matching the dashboard
/// form's address / notes fields.
class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
