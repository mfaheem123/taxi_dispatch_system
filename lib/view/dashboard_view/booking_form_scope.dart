// booking_form_scope.dart
//
// Which booking form a widget is sitting inside.
//
// There are two of them. The dashboard's NEW BOOKING form is bound to the
// permanent DashboardController — the one every bare
// `Get.find<DashboardController>()` in the app resolves. The edit screen
// (edit_jobs.dart) runs on a SECOND instance registered under a tag of its
// own, so a job opened for editing gets its own TextEditingControllers, its
// own polylines / markers / via points and its own selections instead of
// overwriting whatever the operator had half typed into the new booking.
//
// Shared widgets that appear under BOTH forms — the map above all — therefore
// cannot resolve the controller globally any more: inside the edit screen they
// have to follow the edit instance, and everywhere else the dashboard one.
// This scope is how they ask.
//
// The fallback is what keeps the change small: every existing call site that
// is NOT under an edit screen finds no scope and gets the permanent instance,
// exactly as it did before.

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'Controller/dashboard_controller.dart';

class BookingFormScope extends InheritedWidget {
  const BookingFormScope({
    super.key,
    required this.controller,
    required super.child,
  });

  /// The DashboardController this subtree's fields, route and map belong to.
  final DashboardController controller;

  /// The form [context] is inside, or the dashboard's permanent instance when
  /// it is inside none.
  static DashboardController of(BuildContext context) =>
      maybeOf(context) ?? Get.find<DashboardController>();

  /// Null when [context] is not under a detached form. Use this (rather than
  /// [of]) where "no scope" has to be told apart from "the dashboard's form".
  static DashboardController? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<BookingFormScope>()
      ?.controller;

  @override
  bool updateShouldNotify(BookingFormScope oldWidget) =>
      oldWidget.controller != controller;
}
