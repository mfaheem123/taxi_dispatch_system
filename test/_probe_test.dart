// Probe: can a VM test import DashboardController, or does the import chain
// drag in dart:html (which would force --platform chrome)?
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('controller is importable on the VM', () {
    final c = DashboardController();
    expect(c.selectedMenuItems, isEmpty);
  });
}
