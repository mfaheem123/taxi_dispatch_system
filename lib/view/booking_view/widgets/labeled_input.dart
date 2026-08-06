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

  const LabeledInput(this.label,
      {super.key,
      this.hint,
      this.keyboardType,
      this.controller,
      this.uppercase = false});

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: label,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization:
            uppercase ? TextCapitalization.characters : TextCapitalization.none,
        inputFormatters: uppercase ? const [UpperCaseTextFormatter()] : null,
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
