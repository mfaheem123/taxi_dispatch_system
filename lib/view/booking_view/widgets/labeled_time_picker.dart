// labeled_time_picker.dart
//
// Time field backed by the shared `TimePickerField` (HOURS / MINUTES dropdown
// panel, `HH:mm` 24-hour value) — the same widget the dashboard form uses.
// See create_new_booking_form.dart for how this fits into the wider form.

import 'package:flutter/material.dart';
import 'package:timepickerfield/timepickerfield.dart';

import 'booking_form_layout.dart';

class LabeledTimePicker extends StatefulWidget implements LabelledField {
  @override
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
    return FieldShell(
      label: widget.label,
      child: TimePickerField(
        controller: _controller,
        accent: fieldFocusColor,
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
