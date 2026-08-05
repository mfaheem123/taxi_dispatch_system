// Temporary check: selecting ONE WAY in JOUR must drop the return fields
// without handing their State to the fields that follow.
//
// Has to run with --platform chrome (the app reaches dart:html through the
// alert imports), and that means compiling the whole app to JS first.
@Timeout(Duration(minutes: 40))
library;

import 'package:dashboard_new1/view/booking_view/create_new_booking_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ONE WAY hides the return fields', (tester) async {
    tester.view.physicalSize = const Size(1400, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: CreateNewBookingForm()));
    await tester.pumpAndSettle();

    expect(find.text('R/VEH'), findsOneWidget);
    expect(find.text('R/DATE'), findsOneWidget);
    expect(find.text('R/FARE (£)'), findsOneWidget);
    expect(find.text('R/LEAD (MINS)'), findsOneWidget);

    // Open JOUR and pick ONE WAY.
    await tester.tap(find.text('R/N').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('ONE WAY').last);
    await tester.pumpAndSettle();

    for (final label in [
      'R/DATE',
      'R/TIME',
      'R/PICK',
      'R/PICK ZONE',
      'R/PICK NOTES',
      'R/DROP',
      'R/DROP ZONE',
      'R/DROP NOTES',
      'R/VEH',
      'R/LEAD (MINS)',
      'R/FARE (£)',
      'R/DRV',
    ]) {
      expect(find.text(label), findsNothing, reason: '$label should be hidden');
    }

    // The fields that shifted up must have kept their own selections.
    expect(find.text('SALOON'), findsOneWidget); // VEH only, not ACC
    expect(find.text('SELECT ACCOUNT'), findsOneWidget);
    expect(find.text('SELECT DRIVER'), findsOneWidget); // DRV only

    // And back again.
    await tester.tap(find.text('ONE WAY').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('R/N').last);
    await tester.pumpAndSettle();
    expect(find.text('R/VEH'), findsOneWidget);
    expect(find.text('R/FARE (£)'), findsOneWidget);
  });
}
