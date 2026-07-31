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

class CreateNewBookingForm extends StatelessWidget {
  const CreateNewBookingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D32),
        inputDecorationTheme: denseInputTheme,
      ),
      home: const BookingFormScreen(),
    );
  }
}

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
// A field that knows how many base columns it wants to occupy.
// span is clamped to the available column count, so a span-2 field
// becomes full-width on a 1-column phone automatically.
// ---------------------------------------------------------------------------
class SpanField {
  final int span;
  final Widget child;
  const SpanField(this.child, {this.span = 1});
}

/// Lays SpanField children out on a base grid of [columns] columns and
/// reflows them with a Wrap. Used for every logical section of the form.
class ResponsiveGrid extends StatelessWidget {
  final List<SpanField> children;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
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
            for (final f in children)
              SizedBox(width: widthForSpan(f.span), child: f.child),
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
  const LabeledInput(this.label, {super.key, this.hint, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return _FieldShell(
      label: label,
      child: TextField(
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: Density.fieldFont),
        decoration: InputDecoration(hintText: hint),
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

class LabeledDatePicker extends StatefulWidget {
  final String label;
  const LabeledDatePicker(this.label, {super.key});

  @override
  State<LabeledDatePicker> createState() => _LabeledDatePickerState();
}

class _LabeledDatePickerState extends State<LabeledDatePicker> {
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final text =
        '${_date.month.toString().padLeft(2, '0')}/${_date.day.toString().padLeft(2, '0')}/${_date.year}';
    return _FieldShell(
      label: widget.label,
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
          );
          if (picked != null) setState(() => _date = picked);
        },
        child: InputDecorator(
          decoration: const InputDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: Density.fieldFont)),
              ),
              const Icon(Icons.calendar_today, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class LabeledTimePicker extends StatefulWidget {
  final String label;
  const LabeledTimePicker(this.label, {super.key});

  @override
  State<LabeledTimePicker> createState() => _LabeledTimePickerState();
}

class _LabeledTimePickerState extends State<LabeledTimePicker> {
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return _FieldShell(
      label: widget.label,
      child: InkWell(
        onTap: () async {
          final picked =
              await showTimePicker(context: context, initialTime: _time);
          if (picked != null) setState(() => _time = picked);
        },
        child: InputDecorator(
          decoration: const InputDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(_time.format(context),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: Density.fieldFont)),
              ),
              const Icon(Icons.access_time, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class LabeledCheckbox extends StatefulWidget {
  final String label;
  final bool value;
  const LabeledCheckbox(this.label, {super.key, this.value = false});

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
        onTap: () => setState(() => _v = !_v),
        child: Row(
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
class BookingFormScreen extends StatelessWidget {
  const BookingFormScreen({super.key});

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
                    child: Column(
                      children: [
                        const _TopTabs(),
                        const SizedBox(height: Density.cardGap),

                        // ---- Booking header: source + sub ----
                        SectionCard(
                          child: ResponsiveGrid(
                            children: const [
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
                            children: const [
                              SpanField(LabeledInput('PICK'), span: 2),
                              SpanField(
                                  LabeledDropdown('PICK ZONE', items: zones)),
                              SpanField(LabeledInput('PICKUP NOTES')),
                              SpanField(LabeledInput('DROP'), span: 2),
                              SpanField(
                                  LabeledDropdown('DROP ZONE', items: zones)),
                              SpanField(LabeledInput('DROPOFF NOTES')),
                              SpanField(LabeledInput('NAME')),
                              SpanField(LabeledInput('EMAIL',
                                  keyboardType: TextInputType.emailAddress)),
                              SpanField(LabeledInput('MOBILE',
                                  keyboardType: TextInputType.phone)),
                              SpanField(LabeledInput('TEL',
                                  keyboardType: TextInputType.phone)),
                            ],
                          ),
                        ),

                        // ---- Dates & times ----
                        SectionCard(
                          child: ResponsiveGrid(
                            children: const [
                              SpanField(LabeledDatePicker('DATE')),
                              SpanField(LabeledTimePicker('TIME')),
                              SpanField(LabeledDatePicker('R/DATE')),
                              SpanField(LabeledTimePicker('R/TIME')),
                              SpanField(LabeledInput('R/PICK'), span: 2),
                              SpanField(
                                  LabeledDropdown('R/PICK ZONE', items: zones)),
                              SpanField(LabeledInput('R/PICK NOTES')),
                              SpanField(LabeledInput('R/DROP'), span: 2),
                              SpanField(
                                  LabeledDropdown('R/DROP ZONE', items: zones)),
                              SpanField(LabeledInput('R/DROP NOTES')),
                            ],
                          ),
                        ),

                        // ---- Journey details ----
                        SectionCard(
                          child: ResponsiveGrid(
                            children: const [
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
                            children: const [
                              SpanField(LabeledDropdown('PAY', items: [
                                'CASH',
                                'CARD',
                                'ACCOUNT',
                                'INVOICE'
                              ])),
                              SpanField(LabeledInput('R/LEAD (MINS)',
                                  keyboardType: TextInputType.number)),
                              SpanField(LabeledCheckbox('QUOTATION')),
                              SpanField(LabeledCheckbox('SMS', value: true)),
                              SpanField(LabeledCheckbox('EMAIL')),
                              SpanField(LabeledCheckbox('ADD RETURN FARE')),
                            ],
                          ),
                        ),

                        // ---- Fares row ----
                        SectionCard(
                          child: Column(
                            children: const [
                              _StatStrip(),
                              SizedBox(height: Density.gridSpacing),
                              ResponsiveGrid(
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

class _TopTabs extends StatelessWidget {
  const _TopTabs();
  @override
  Widget build(BuildContext context) {
    Widget tab(String key, String label, {bool active = false}) => Container(
          margin: const EdgeInsets.only(right: 6, bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2E7D32) : const Color(0xFFEDEDED),
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
        final buttons = <Widget>[
          _btn('MULTI BOOKING [F8]', const Color(0xFFBDBDBD), Colors.black87),
          _btn('MULTI VEHICLE [F9]', const Color(0xFFBDBDBD), Colors.black87),
          _btn('CLEAR [F7]', const Color(0xFFD32F2F), Colors.white),
          _btn('SAVE [HOME]', const Color(0xFF2E7D32), Colors.white),
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

  Widget _btn(String label, Color bg, Color fg) => ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: const EdgeInsets.symmetric(vertical: 10),
          minimumSize: const Size(0, 34),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      );
}
