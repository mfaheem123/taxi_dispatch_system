// labeled_date_picker.dart
//
// Date field for the booking forms, backed by the SAME widget the dashboard
// booking form uses: `CalendarDropdownField` out of flutter_web_date_picker.
// dashboard_form_widget.dart reaches it through the package's `WebDateField`
// wrapper (which draws its own floating label); this form draws its captions
// with [FieldShell], so it uses the field directly and leaves the package
// label off.
//
// Behaviour, unchanged from the local copy this replaces:
//   * a single Tab stop — icon, border and value take the accent color;
//   * Enter / Space / Down (or a click) opens an Overlay panel under the field,
//     NOT a modal dialog;
//   * inside the panel: ‹ › page the month, the title toggles the month / year
//     grids, arrows move the selection, PageUp/PageDown page, Enter confirms,
//     Esc closes.
//
// See create_new_booking_form.dart for how this fits into the wider form.

import 'package:flutter/material.dart';
import 'package:flutter_web_date_picker/flutter_web_date_picker.dart';

import 'booking_form_layout.dart';

/// Date field backed by the dashboard's dropdown calendar.
///
/// Two ways to drive it:
///
///   * **Controlled** — pass [value] and [onChanged]. The field renders exactly
///     what it is given and keeps no date of its own, so a
///     `DashboardController` (or anything else holding the booking) stays the
///     single source of truth and a job loaded by
///     `DashboardController.dashBoardDataBinding` shows up here. This is what
///     edit_jobs.dart does.
///   * **Uncontrolled** — pass nothing, or just [initialDate], and the field
///     keeps its own date, starting at today. What the create form does while
///     its fields are still being wired up.
class LabeledDatePicker extends StatefulWidget implements LabelledField {
  @override
  final String label;

  /// The date to show, in controlled mode. Non-null hands ownership of the
  /// value to the caller: [onChanged] fires and nothing changes on screen
  /// until the caller rebuilds with a new [value].
  final DateTime? value;

  /// Where the uncontrolled field starts. Ignored once [value] is non-null.
  final DateTime? initialDate;

  final ValueChanged<DateTime>? onChanged;

  /// Greys the field out and drops it from the Tab order.
  final bool enabled;

  const LabeledDatePicker(
    this.label, {
    super.key,
    this.value,
    this.initialDate,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<LabeledDatePicker> createState() => _LabeledDatePickerState();
}

class _LabeledDatePickerState extends State<LabeledDatePicker> {
  /// Only ever read in uncontrolled mode — see [LabeledDatePicker.value].
  late DateTime _date = widget.initialDate ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    // The same indigo the focused field border uses, so the icon, the arrow
    // and the calendar's own accents all match the ring around the field.
    const accent = fieldFocusColor;
    return FieldShell(
      label: widget.label,
      child: CalendarDropdownField(
        value: widget.value ?? _date,
        enabled: widget.enabled,
        // FieldShell already renders the caption above or beside the field,
        // exactly like every other field in this form, so the package's own
        // floating label stays off.
        label: null,
        style: WebDatePickerStyle.of(context).copyWith(
          accent: accent,
          accentSoft: accent.withValues(alpha: 0.12),
        ),
        // The borders, the fill and the dense content padding all come from
        // the form's own denseInputTheme. InputDecorator takes the decoration
        // exactly as given — unlike TextField it does NOT merge the ambient
        // theme — so without applyDefaults the field falls back to Material's
        // 1.0 underline however bold the theme's outline gets.
        decoration:
            const InputDecoration().applyDefaults(Theme.of(context).inputDecorationTheme),
        textStyle: const TextStyle(
            fontSize: Density.fieldFont, color: Colors.black87),
        onChanged: (d) {
          // Controlled: whoever owns the value rebuilds us with it. Keeping a
          // copy here as well would only go stale the moment they change it
          // from somewhere else — a booking being loaded, say.
          if (widget.value == null) setState(() => _date = d);
          widget.onChanged?.call(d);
        },
      ),
    );
  }
}
