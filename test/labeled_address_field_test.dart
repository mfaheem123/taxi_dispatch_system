// Checks on the two things view/auth/edit_jobs.dart needs from
// LabeledAddressField to drive DashboardController's location plumbing:
//
//   * it accepts an external FocusNode (the controller keeps one per location
//     field, and the × buttons hand focus back to the field they emptied) and
//     does NOT dispose a node it did not create;
//   * picking a suggestion does not re-open the panel even when the onPicked
//     handler writes the field again — which is exactly what
//     DashboardController.tapSelect does.
//
// Pure Flutter widgets, so this runs on the VM; see booking_form_widgets_test
// for why the screen itself cannot be imported here.

import 'package:dashboard_new1/view/booking_view/widgets/booking_form_layout.dart';
import 'package:dashboard_new1/view/booking_view/widgets/labeled_address_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _suggestions = [
  AddressSuggestion(name: 'Baker Street', postcode: 'NW1 6XE'),
  AddressSuggestion(name: 'Green Park Way', postcode: 'UB6 0AD'),
];

/// 'Baker Street, NW1 6XE' — shown in the panel row verbatim, while the field
/// itself gets an upper-cased version. Keeping the two different is what lets a
/// text search tell an open panel from a filled field.
const _panelRow = 'Baker Street, NW1 6XE';

Widget _host({
  required TextEditingController controller,
  FocusNode? focusNode,
  ValueChanged<AddressSuggestion>? onPicked,
  List<AddressSuggestion> addresses = _suggestions,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Theme(
        data: ThemeData(
            useMaterial3: false, inputDecorationTheme: denseInputTheme),
        child: FormLayout(
          inlineLabels: true,
          child: LabeledAddressField(
            'PICK',
            controller: controller,
            focusNode: focusNode,
            addresses: addresses,
            onPicked: onPicked,
          ),
        ),
      ),
    ),
  );
}

/// True while the suggestion panel is on screen.
///
/// Keyed off the elevation-6 Material that only `_buildPanel` builds. Checking
/// for a particular suggestion row instead would miss a panel that reopened
/// showing 'No data', and CompositedTransformFollower is no good either — the
/// TextField builds one of its own, so there is always a baseline of one.
bool _panelOpen() => find
    .byWidgetPredicate((w) => w is Material && w.elevation == 6)
    .evaluate()
    .isNotEmpty;

void main() {
  testWidgets('drives an external FocusNode and does not dispose it',
      (tester) async {
    final controller = TextEditingController();
    final node = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(node.dispose);

    await tester.pumpWidget(_host(controller: controller, focusNode: node));
    await tester.pumpAndSettle();

    // The supplied node is the one the field actually wires to its TextField.
    expect(tester.widget<TextField>(find.byType(TextField)).focusNode, node);

    // Focusing it from outside — as the × buttons do — focuses the field.
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(node.hasFocus, isTrue);

    // Tear the field down; the node belongs to the caller, so it must survive.
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();
    expect(() => node.addListener(() {}), returnsNormally,
        reason: 'an externally supplied node must not be disposed');
  });

  testWidgets('owns and disposes a node when none is supplied', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller: controller));
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(find.byType(TextField)).focusNode,
        isNotNull);

    // Disposing its own node must not throw on teardown.
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();
  });

  testWidgets('typing opens the suggestion panel', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller: controller));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'baker');
    await tester.pumpAndSettle();

    expect(find.text(_panelRow), findsOneWidget);
    expect(_panelOpen(), isTrue);
  });

  testWidgets('opens the panel when backend results arrive after typing',
      (tester) async {
    // The real sequence on the update form: DashboardController debounces its
    // lookup by 800ms, so the candidate list is EMPTY while the user types and
    // only refills — via a GetBuilder rebuild — once the API answers.
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester
        .pumpWidget(_host(controller: controller, addresses: const []));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'baker');
    await tester.pumpAndSettle();

    // Nothing to show yet, and deliberately no 'No data' flash.
    expect(_panelOpen(), isFalse);
    expect(find.text('No data'), findsNothing);

    // The lookup resolves and the parent rebuilds with the results.
    await tester.pumpWidget(
        _host(controller: controller, addresses: _suggestions));
    await tester.pumpAndSettle();

    expect(_panelOpen(), isTrue,
        reason: 'late results must open the panel');
    expect(find.text(_panelRow), findsOneWidget);
  });

  testWidgets('reports a genuine miss once a list has loaded', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller: controller));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'nowhere at all');
    await tester.pumpAndSettle();

    // A list IS loaded and nothing matched, so say so rather than going quiet.
    expect(_panelOpen(), isTrue);
    expect(find.text('No data'), findsOneWidget);
  });

  testWidgets('clearing the text closes the panel again', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller: controller));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'baker');
    await tester.pumpAndSettle();
    expect(_panelOpen(), isTrue);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(_panelOpen(), isFalse);
  });

  testWidgets('picking does not re-open the panel when onPicked rewrites '
      'the field, as tapSelect does', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    var picks = 0;
    await tester.pumpWidget(_host(
      controller: controller,
      onPicked: (a) {
        picks++;
        // Exactly what DashboardController.tapSelect does: write the address
        // into the bound controller itself, in its own format.
        controller.text = '${a.name} ${a.postcode}'.toUpperCase();
      },
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'baker');
    await tester.pumpAndSettle();
    expect(_panelOpen(), isTrue, reason: 'panel should be open');

    await tester.tap(find.text(_panelRow));
    await tester.pumpAndSettle();

    expect(picks, 1);
    // tapSelect's write won: the field holds its format, not the panel's.
    expect(controller.text, 'BAKER STREET NW1 6XE');
    // The panel must be gone outright. Without the suppression spanning
    // onPicked it reopens on that write — and because the full address matches
    // no suggestion, it reopens as a 'No data' box, which is why this asserts
    // on the panel itself rather than on any particular row.
    expect(find.text('No data'), findsNothing);
    expect(_panelOpen(), isFalse,
        reason: 'the onPicked write must not re-open the panel');
  });
}
