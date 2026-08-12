// The booking form's icon-button alerts (RESTRICT DRIVERS, CHILD SEATS, EXTRA
// FARES, EXTRA INFO) would not close on Escape. These cover the wrapper that
// makes them, including the one opened with barrierDismissible: false.
import 'package:dashboard_new1/component/escape_dismissible.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Opens the dialog the way the booking form opens its alerts.
Future<void> _openDialog(WidgetTester tester, [String label = 'ALERT']) async {
  await tester.tap(find.text('open $label'));
  await tester.pumpAndSettle();
}

Widget _host({
  required bool barrierDismissible,
  String label = 'ALERT',
  VoidCallback? onDismiss,
  bool nested = false,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showDialog<void>(
            context: context,
            barrierDismissible: barrierDismissible,
            builder: (_) => EscapeDismissible(
              onDismiss: onDismiss,
              child: Dialog(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Builder(
                    builder: (dialogContext) => Column(
                      children: [
                        Text(label),
                        if (nested)
                          TextButton(
                            onPressed: () => showDialog<void>(
                              context: dialogContext,
                              barrierDismissible: false,
                              builder: (_) => const EscapeDismissible(
                                child: Dialog(
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Text('TOP'),
                                  ),
                                ),
                              ),
                            ),
                            child: const Text('open TOP'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: Text('open $label'),
        ),
      ),
    ),
  );
}

Future<void> _pressEscape(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Escape closes a dialog opened with barrierDismissible: false',
      (tester) async {
    // ExtraFaresAlert's case: Flutter's built-in DismissIntent is disabled for
    // this route, so before the wrapper the keyboard could not close it at all.
    await tester.pumpWidget(_host(barrierDismissible: false));
    await _openDialog(tester);
    expect(find.text('ALERT'), findsOneWidget);

    await _pressEscape(tester);
    expect(find.text('ALERT'), findsNothing);
  });

  testWidgets('Escape closes a dialog opened with barrierDismissible: true',
      (tester) async {
    await tester.pumpWidget(_host(barrierDismissible: true));
    await _openDialog(tester);
    expect(find.text('ALERT'), findsOneWidget);

    await _pressEscape(tester);
    expect(find.text('ALERT'), findsNothing);
  });

  testWidgets('Escape closes the dialog even when a text field holds focus',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) => EscapeDismissible(
                  child: Dialog(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Column(
                        children: const [
                          Text('ALERT'),
                          TextField(autofocus: true),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child: const Text('open ALERT'),
            ),
          ),
        ),
      ),
    );
    await _openDialog(tester);
    expect(find.text('ALERT'), findsOneWidget);

    await _pressEscape(tester);
    expect(find.text('ALERT'), findsNothing);
  });

  testWidgets('Escape closes only the top-most of two stacked dialogs',
      (tester) async {
    await tester.pumpWidget(_host(barrierDismissible: false, nested: true));
    await _openDialog(tester);
    await tester.tap(find.text('open TOP'));
    await tester.pumpAndSettle();
    expect(find.text('TOP'), findsOneWidget);

    await _pressEscape(tester);
    expect(find.text('TOP'), findsNothing);
    expect(find.text('ALERT'), findsOneWidget);

    await _pressEscape(tester);
    expect(find.text('ALERT'), findsNothing);
  });

  testWidgets('onDismiss replaces the pop when supplied', (tester) async {
    var dismissed = 0;
    await tester.pumpWidget(
      _host(barrierDismissible: false, onDismiss: () => dismissed++),
    );
    await _openDialog(tester);

    await _pressEscape(tester);
    expect(dismissed, 1);
    expect(find.text('ALERT'), findsOneWidget, reason: 'onDismiss owns closing');
  });

  testWidgets('the handler is removed when the dialog closes', (tester) async {
    await tester.pumpWidget(_host(barrierDismissible: true));
    await _openDialog(tester);
    await _pressEscape(tester);
    expect(find.text('ALERT'), findsNothing);

    // A stale HardwareKeyboard handler on a disposed State would throw here.
    await _pressEscape(tester);
    expect(tester.takeException(), isNull);
  });
}
