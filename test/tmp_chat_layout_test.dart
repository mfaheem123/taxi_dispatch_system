import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:dashboard_new1/view/setting/chat_with_driver_passenger.dart';

Widget host(Widget child) => GetMaterialApp(home: Scaffold(body: child));

void main() {
  for (final size in [const Size(700, 500), const Size(420, 500)]) {
    testWidgets('bounded ${size.width}x${size.height}', (t) async {
      await t.pumpWidget(host(Center(child: SizedBox.fromSize(size: size,
          child: const ChatWithDriverAndPassenger()))));
      await t.pump();
      expect(t.takeException(), isNull);
      expect(find.text('NO MESSAGES YET'), findsOneWidget);
    });
  }
  testWidgets('unbounded (settings page)', (t) async {
    await t.pumpWidget(host(const SingleChildScrollView(
        child: Column(children: [ChatWithDriverAndPassenger()]))));
    await t.pump();
    expect(t.takeException(), isNull);
  });
}
