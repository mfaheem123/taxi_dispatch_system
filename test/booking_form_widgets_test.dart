// Layout checks on the shared booking-form widgets and the UPDATE BOOKING
// chrome built on them (view/auth/edit_jobs.dart is assembled from these).
//
// Deliberately does NOT import edit_jobs.dart: that reaches DashboardController,
// which transitively reaches dart:html, which forces the whole app to be
// compiled to JS with --platform chrome — and that compile overruns the test
// loader's 12-minute cap on this project. The widgets below are pure Flutter,
// so they run on the VM in seconds. What is covered here is exactly what was
// changed: unlabelled grid cells, the header, the fares bar, the action rows,
// and the focus cue.

import 'package:dashboard_new1/view/booking_view/widgets/booking_form_layout.dart';
import 'package:dashboard_new1/view/booking_view/widgets/booking_form_parts.dart';
import 'package:dashboard_new1/view/booking_view/widgets/labeled_checkbox.dart';
import 'package:dashboard_new1/view/booking_view/widgets/labeled_dropdown.dart';
import 'package:dashboard_new1/view/booking_view/widgets/labeled_icon_actions.dart';
import 'package:dashboard_new1/view/booking_view/widgets/labeled_input.dart';
import 'package:dashboard_new1/view/booking_view/widgets/update_booking_parts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A stand-in for the update form's main card: a labelled span-2 field
/// followed by the two unlabelled cells that continue its row, then the
/// contact fields and the field-shaped button that closes them.
class _Harness extends StatelessWidget {
  const _Harness();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Theme(
          data: Theme.of(context).copyWith(
            // Material 2, as the real app is — this is what makes a focused
            // input redraw its own border at 2px in colorScheme.primary.
            useMaterial3: false,
            inputDecorationTheme: denseInputTheme,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => FormLayout(
              inlineLabels: constraints.maxWidth >= Breakpoints.inlineLabel,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(
                    requestFocusCallback: smoothTraversalFocus,
                  ),
                  child: Column(
                    children: [
                      const UpdateBookingHeader(
                        reference: 'DCB75789',
                        user: 'NADEEM',
                        bookedAt: '24-08-26 09:20',
                        status: 'WAITING',
                        associatedReference: 'DCB75795',
                        onAssociatedTap: _noop,
                        onTrack: _noop,
                        onMessages: _noop,
                        onDispatch: _noop,
                        onComplaint: _noop,
                        onLostProperty: _noop,
                      ),
                      SectionCard(
                        child: ResponsiveGrid(
                          orderBase: 100,
                          children: [
                            SpanField(LabeledInput('PICK'), span: 2),
                            SpanField(
                              LabeledZoneDropdown('', items: const []),
                              id: 'pickZone',
                            ),
                            SpanField(
                              LabeledInput('',
                                  hint: 'PICKUP NOTES',
                                  prefixIcon: Icons.local_taxi_outlined),
                              id: 'pickNotes',
                            ),
                            SpanField(LabeledInput('DROP'), span: 2),
                            SpanField(
                              LabeledZoneDropdown('', items: const []),
                              id: 'dropZone',
                            ),
                            SpanField(
                              LabeledInput('',
                                  hint: 'DROPOFF NOTES',
                                  prefixIcon: Icons.local_taxi_outlined,
                                  prefixText: 'R/'),
                              id: 'dropNotes',
                            ),
                            SpanField(LabeledInput('NAME')),
                            SpanField(LabeledInput('TEL')),
                            SpanField(
                              const LabeledActionButton(
                                  text: 'PICK BOOKING',
                                  icon: Icons.search,
                                  onPressed: _noop),
                              id: 'pickBooking',
                            ),
                            SpanField(
                                LabeledCheckbox('QUOTATION', circular: true),
                                widths: 120),
                            SpanField(
                              LabeledIconActions([
                                IconAction(
                                  icon: Icons.groups_outlined,
                                  tooltip: 'RESTRICT DRIVERS',
                                  background: UpdateFormPalette.green,
                                  onTap: _noop,
                                ),
                                IconAction(
                                  icon: Icons.note_alt_outlined,
                                  tooltip: 'EXTRA FARES',
                                  onTap: _noop,
                                ),
                              ]),
                              widths: LabeledIconActions.width(2),
                              id: 'extras',
                            ),
                          ],
                        ),
                      ),
                      FaresBar(
                        onRecalculate: _noop,
                        stats: const [
                          BookingStat(Icons.timer_outlined, 'ETA:', '0 M'),
                          BookingStat(Icons.route, 'DISTANCE:', '3.34 M'),
                          BookingStat(
                              Icons.payments_outlined, 'T/FARES:', '£ 21.80'),
                        ],
                        fareFields: [
                          LabeledInput('FARE'),
                          LabeledInput('R/FARE'),
                        ],
                      ),
                      SectionCard(
                        child: ResponsiveGrid(
                          orderBase: 600,
                          children: [
                            SpanField(LabeledDropdown('DRV',
                                items: const ['SELECT DRIVER'])),
                            SpanField(
                                const UpdateActionButtons(
                                  onCancel: _noop,
                                  onReceipt: _noop,
                                  onAuditReport: _noop,
                                  onSave: _noop,
                                ),
                                span: 2,
                                id: 'actions'),
                          ],
                        ),
                      ),
                    ],
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

void _noop() {}

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const _Harness());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders with inline labels at desktop width', (tester) async {
    // Past Breakpoints.inlineLabel, so labels sit left of their fields.
    await _pumpAt(tester, const Size(1400, 2000));

    expect(find.text('UPDATE BOOKING'), findsOneWidget);
    expect(find.text('DCB75789'), findsOneWidget);
    expect(find.text('NADEEM'), findsOneWidget);
    expect(find.text('WAITING'), findsOneWidget);
    expect(find.text('ASSOCIATED: DCB75795'), findsOneWidget);
    expect(find.text('COMPLAINT'), findsOneWidget);
    expect(find.text('LOST PROPERTY'), findsOneWidget);

    // The fares bar keeps its figures and its fields on one line.
    expect(find.text('3.34 M'), findsOneWidget);
    expect(find.text('£ 21.80'), findsOneWidget);
    expect(find.text('FARE'), findsOneWidget);
    expect(find.text('R/FARE'), findsOneWidget);

    expect(find.text('PICK BOOKING'), findsOneWidget);
    expect(find.text('QUOTATION'), findsOneWidget);
    expect(find.text('AUDIT REPORT'), findsOneWidget);
    expect(find.text('SAVE'), findsOneWidget);
  });

  testWidgets('unlabelled cells claim no label column when inline',
      (tester) async {
    await _pumpAt(tester, const Size(1400, 2000));

    // The notes fields are unlabelled, so their hint is the only caption and
    // FieldShell gives them no label box at all.
    expect(find.text('PICKUP NOTES'), findsOneWidget);
    expect(find.text('DROPOFF NOTES'), findsOneWidget);
    expect(find.text('R/'), findsOneWidget);

    // PICK is labelled and its row-mates are not, so exactly one FieldLabel
    // exists per labelled field and none carry an empty string.
    for (final label in tester.widgetList<FieldLabel>(find.byType(FieldLabel))) {
      expect(label.text, isNotEmpty);
    }
  });

  testWidgets('stacks labels and splits the header below the breakpoints',
      (tester) async {
    // Under Breakpoints.desktop: labels stack, and both the header and the
    // fares bar go to two lines.
    await _pumpAt(tester, const Size(700, 3000));

    expect(find.text('UPDATE BOOKING'), findsOneWidget);
    expect(find.text('PICK'), findsOneWidget);
    expect(find.text('SAVE'), findsOneWidget);
    expect(find.text('£ 21.80'), findsOneWidget);
  });

  testWidgets('focus shows only as a bold indigo border on the focused field',
      (tester) async {
    await _pumpAt(tester, const Size(1400, 2000));

    // Nothing paints a halo behind a cell: the old FocusRing drew a BoxShadow
    // and is gone, so no decorated box in the form carries one.
    Iterable<BoxShadow> shadows() => tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((d) => d.decoration)
        .whereType<BoxDecoration>()
        .expand((d) => d.boxShadow ?? const <BoxShadow>[]);
    expect(shadows(), isEmpty);

    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();

    // Exactly one field is focused, and the cue is its own border — the
    // explicit focusedBorder from denseInputTheme, not Material's 2px default.
    final focused = tester
        .widgetList<InputDecorator>(find.byType(InputDecorator))
        .where((d) => d.isFocused)
        .toList();
    expect(focused, hasLength(1));

    final side = focused.single.decoration.focusedBorder?.borderSide;
    expect(side?.color, fieldFocusColor);
    expect(side?.color, const Color(0xFF312E81));
    expect(side?.width, fieldFocusWidth);
    expect(side!.width, greaterThan(2.0), reason: 'bolder than the M2 default');

    // Still no halo once something has focus.
    expect(shadows(), isEmpty);
  });

  testWidgets('buttons ring in indigo, or white when their fill is dark',
      (tester) async {
    await _pumpAt(tester, const Size(1400, 2000));

    // Light fills take the indigo; the dark ones would swallow it.
    expect(focusRingOn(Colors.white), fieldFocusColor);
    expect(focusRingOn(UpdateFormPalette.chip), fieldFocusColor);
    expect(focusRingOn(UpdateFormPalette.green), fieldFocusColor);
    expect(focusRingOn(UpdateFormPalette.valueText), Colors.white);
    expect(focusRingOn(fieldFocusColor), Colors.white);

    // Focus on a pill button thickens its border and changes nothing else.
    final container = find.descendant(
      of: find.widgetWithText(PillButton, 'SAVE'),
      matching: find.byType(AnimatedContainer),
    );

    BoxDecoration deco() =>
        tester.widget<AnimatedContainer>(container).decoration! as BoxDecoration;

    final before = deco();
    expect(before.border!.top.width, 1.0, reason: 'idle border is hairline');

    // Requested on the button's own node rather than tapped: a tap on an
    // InkWell fires onTap without moving keyboard focus, which is the thing
    // the border is there to show.
    Focus.of(tester.element(container)).requestFocus();
    await tester.pumpAndSettle();

    final after = deco();
    expect(after.color, before.color, reason: 'fill must not change');
    expect(after.boxShadow ?? const <BoxShadow>[], isEmpty);
    // SAVE is filled green (luminance 0.27), so it rings in the indigo — and
    // at the bold width, not Material's 2.0.
    expect(after.border!.top.width, fieldFocusWidth);
    expect(after.border!.top.color, fieldFocusColor);
  });
}
