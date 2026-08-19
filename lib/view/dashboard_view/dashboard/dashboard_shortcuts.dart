import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../alert/back_slash_alert.dart';
import '../../../alert/f3_alert.dart';
import '../../../alert/f4_alert.dart';
import '../Controller/dashboard_controller.dart';
import '../utils/page_arrow_scroll.dart';
import 'F8_widget_alert.dart';
import 'F9_widget_alert.dart';

/// Keyboard shortcuts for the whole dispatch dashboard (F1-F12, "/", HOME).
///
/// These bindings used to live inside BookingFormScreen, which meant they only
/// fired while focus sat inside the booking form: click a booking table row,
/// the drivers panel, the map or any other widget on the screen and every
/// F-key went dead. [CallbackShortcuts] only sees key events that bubble up
/// from whichever node currently has focus, so the bindings have to be an
/// ancestor of EVERY focusable widget on the screen — which is what this
/// wrapper is. Put it around the dashboard body and the keys keep working no
/// matter which field, row or button holds focus.
class DashboardShortcuts extends StatefulWidget {
  const DashboardShortcuts({super.key, required this.child});

  final Widget child;

  @override
  State<DashboardShortcuts> createState() => _DashboardShortcutsState();
}

class _DashboardShortcutsState extends State<DashboardShortcuts> {
  /// Focusable — so there is always a node inside this subtree holding focus
  /// and key events have a path up to the bindings — but never a Tab stop:
  /// otherwise Tab / Shift+Tab lands on this invisible full-screen node and
  /// the focus ring appears to vanish.
  final FocusNode _focusNode = FocusNode(
    debugLabel: 'DashboardShortcuts',
    skipTraversal: true,
  );

  final DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // ────────── guards

  /// True when keyboard focus sits inside a text field, so printable keys
  /// ("/") and caret keys (HOME) can keep their normal meaning while typing.
  /// The F-keys need no such guard — a text field ignores those.
  bool get _isTypingInTextField {
    final ctx = FocusManager.instance.primaryFocus?.context;
    return ctx != null &&
        (ctx.widget is EditableText ||
            ctx.findAncestorWidgetOfExactType<EditableText>() != null);
  }

  /// A modal (F8 / F9 / help sheet ...) is already on screen. Its route owns
  /// the keyboard, and re-firing a shortcut behind it would stack a second copy
  /// of the same dialog.
  bool get _isDialogOpen => Get.isDialogOpen ?? false;

  /// Most actions describe an existing journey, so they need both ends of it —
  /// the same condition the form's own buttons check.
  bool get _hasJourney =>
      controller.pickupController.text.trim().isNotEmpty &&
      controller.dropOffController.text.trim().isNotEmpty;

  /// Wraps [action] in the guards every binding shares.
  VoidCallback _guard(
    VoidCallback action, {
    bool needsJourney = false,
    bool blockedWhileTyping = false,
  }) {
    return () {
      if (_isDialogOpen) return;
      if (blockedWhileTyping && _isTypingInTextField) return;
      if (needsJourney && !_hasJourney) {
        // The form used to fail silently here, which reads as a dead key.
        BotToast.showText(text: 'Please enter a pickup and a drop off first');
        return;
      }
      action();
    };
  }

  // ────────── actions

  /// F2 — BOOKING FORM. The F12 toggle can replace the form with the
  /// full-width booking table, so bring the form back before dropping the
  /// caret into its first field (PICKUP).
  void _createBooking() {
    if (!controller.hideDashBoard.value) {
      controller.hideDashBoard.value = true;
      controller.update();
    }
    // The form may only be mounted from this frame on.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.focusBookingFormFirstField?.call();
    });
  }

  /// F12 — HIDE / SHOW DASHBOARD, same action as the header button.
  /// `update()` (not setState) because the dashboard body is rebuilt by a
  /// `GetBuilder<DashboardController>` that this widget sits outside of.
  void _toggleDashboard() {
    controller.hideDashBoard.value = !controller.hideDashBoard.value;
    controller.update();
  }

  /// HOME — SAVE BOOKING. Mirrors the form's `SAVE [HOME]` button, including
  /// its waiting-return check.
  void _saveBooking() {
    if (!controller.hideDashBoard.value) return; // form not on screen
    if (controller.jourValue == 'W/R' &&
        controller.pickupTwoWayController.text.isEmpty &&
        controller.dropOffTwoWayController.text.isEmpty) {
      BotToast.showText(text: "Please chose waiting return");
      return;
    }
    controller.dashBoardApiValidation(
      id: controller.jobDetails == null
          ? null
          : controller.cliJobHit == true
              ? null
              : int.parse(controller.jobDetails!.id!),
    );
  }

  // ────────── bindings
  //
  // Built per frame so each callback reads the controller state as it is at
  // press time, not as it was when this widget was first built.
  Map<ShortcutActivator, VoidCallback> get _bindings {
    // TODO(shortcuts): F1 is BASE ADDRESS and F6 is SAVE QUOTATION in the
    // app's own shortcut sheet (back_slash_alert.dart). Both were pointed at
    // the multi-vehicles alert in the booking form; that placeholder is kept
    // here so no key silently stops working, but they need their real screens.
    final baseAddress = _guard(DashboardF9Alert.show);
    final saveQuotation = _guard(DashboardF9Alert.show);

    final driverVehicle = _guard(showDriverInfoAlert);
    final driverEarning = _guard(showDriverEarningsAlert);
    final clearBooking = _guard(() => controller.refreshPostAllFields());
    final multiBookings = _guard(DashboardF8Alert.show, needsJourney: true);
    final multiVehicles = _guard(DashboardF9Alert.show, needsJourney: true);
    // "/" and HOME are keys a text field wants for itself, so they stand aside
    // while the user is typing.
    final helpMenu = _guard(showSystemShortcutsAlert, blockedWhileTyping: true);
    final saveBooking = _guard(
      _saveBooking,
      needsJourney: true,
      blockedWhileTyping: true,
    );

    return <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.f1): baseAddress,
      const SingleActivator(LogicalKeyboardKey.f2): _guard(_createBooking),
      const SingleActivator(LogicalKeyboardKey.f3): driverVehicle,
      const SingleActivator(LogicalKeyboardKey.keyV, alt: true): driverVehicle,
      const SingleActivator(LogicalKeyboardKey.f4): driverEarning,
      const SingleActivator(LogicalKeyboardKey.keyE, alt: true): driverEarning,
      const SingleActivator(LogicalKeyboardKey.f6): saveQuotation,
      const SingleActivator(LogicalKeyboardKey.f7): clearBooking,
      const SingleActivator(LogicalKeyboardKey.keyX, alt: true): clearBooking,
      const SingleActivator(LogicalKeyboardKey.f8): multiBookings,
      const SingleActivator(LogicalKeyboardKey.f9): multiVehicles,
      const SingleActivator(LogicalKeyboardKey.f12): _guard(_toggleDashboard),
      const SingleActivator(LogicalKeyboardKey.slash): helpMenu,
      // Dispatchers work on the numpad; its "/" is a different logical key.
      const SingleActivator(LogicalKeyboardKey.numpadDivide): helpMenu,
      const SingleActivator(LogicalKeyboardKey.home): saveBooking,
    };
  }

  /// A tap that lands on something unfocusable (the map, a plain container, the
  /// gaps between panels) can leave the screen with no focused node at all, and
  /// key events would then never reach the bindings. Take focus back in that
  /// case so the next keypress still works.
  void _reclaimFocus(PointerDownEvent _) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // hasFocus covers this node AND any descendant, so a tap that focused a
      // text field or a table row is left alone.
      if (!mounted || _focusNode.hasFocus || _isDialogOpen) return;
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: _bindings,
      child: Listener(
        // translucent: children are hit-tested first and still get the event,
        // but taps on empty space reach this listener too.
        behavior: HitTestBehavior.translucent,
        onPointerDown: _reclaimFocus,
        child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          // Arrow up / down scrolls the page from anywhere on the dashboard.
          // A raw key handler, not a binding, so a held key repeats smoothly.
          // Inner panels (booking table rows, suggestion lists, the calendar)
          // are nearer the focused node and still claim the arrows first.
          onKeyEvent: (node, event) => handlePageArrowScroll(context, event),
          child: widget.child,
        ),
      ),
    );
  }
}
