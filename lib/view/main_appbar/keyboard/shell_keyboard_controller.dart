import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../routes/app_pages.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import 'arrow_scroll_pages.dart';

/// Keyboard and focus behaviour of the shell, kept out of the widget.
///
/// It owns the body's scroll controller, decides whether the arrow keys belong
/// to the page or to the field the user is in, and handles the shell's global
/// shortcuts (Escape, F2).
///
/// Call [attach] from `initState` and [dispose] from the state's `dispose`.
class ShellKeyboardController {
  ShellKeyboardController({
    required this.controller,
    required this.fallbackViewportHeight,
  });

  /// The shell's controller — its `currentPage` says which page is on screen.
  final DashboardController controller;

  /// Height to measure a focused widget against before the scroll view has been
  /// laid out.
  final double Function() fallbackViewportHeight;

  /// Scrolls the shell body, which is the scroll view every page is hosted in
  /// — a page's own SingleChildScrollView sits inside this one, gets unbounded
  /// height, and so never scrolls on its own.
  final ScrollController bodyScrollController = ScrollController();

  /// Pixels moved per arrow key press / repeat.
  static const double _arrowScrollStep = 60;

  /// How long after a tap / a traversal key a focus change still counts as the
  /// user's doing.
  static const Duration _userIntentWindow = Duration(milliseconds: 400);

  /// Where and when the user last pressed a pointer down anywhere in the shell.
  Offset? _lastPointerDownPosition;
  DateTime _lastPointerDownAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// When the user last pressed a key that moves the focus (Tab / Enter).
  DateTime _lastTraversalKeyAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// Whether the widget holding the primary focus got it because the user asked
  /// for it — tapped it, or moved into it from the keyboard — and not because it
  /// autofocused itself while the page was building.
  bool _focusIsUserDriven = false;

  /// The page [_focusIsUserDriven] was decided on. Switching pages voids the
  /// verdict: the new page autofocuses its own widgets, which is never the user
  /// reaching for a field.
  Object? _focusPage;

  /// Starts listening for keys and for focus moves.
  void attach() {
    // Prevent the browser UI (like the URL bar) from receiving focus when
    // pressing Tab.
    html.window.onKeyDown.listen((html.KeyboardEvent e) {
      if (e.key == 'Tab') {
        e.preventDefault();
      }
    });

    RawKeyboard.instance.addListener(handleKey);
    FocusManager.instance.addListener(_handleFocusChanged);
  }

  void dispose() {
    RawKeyboard.instance.removeListener(handleKey);
    FocusManager.instance.removeListener(_handleFocusChanged);
    bodyScrollController.dispose();
  }

  /// Notes every tap in the shell, so [_handleFocusChanged] can tell later
  /// whether the user gave the focus away or a widget took it.
  void handlePointerDown(PointerDownEvent event) {
    _lastPointerDownPosition = event.position;
    _lastPointerDownAt = DateTime.now();
  }

  /// Records, every time the focus moves, whether the user is the one who moved
  /// it. Reading this back later is what keeps an `autofocus: true` widget from
  /// silently claiming the arrow keys.
  void _handleFocusChanged() {
    final now = DateTime.now();
    _focusPage = controller.currentPage.value;
    _focusIsUserDriven = _tapLandedOnFocusedWidget(now) ||
        now.difference(_lastTraversalKeyAt) < _userIntentWindow;
  }

  /// Whether the user's last tap landed on the widget that just took the focus.
  /// A tap anywhere else — a menu, a page chip, a button that moved the focus on
  /// its own — is not the user reaching for that widget.
  bool _tapLandedOnFocusedWidget(DateTime now) {
    final at = _lastPointerDownPosition;
    if (at == null || now.difference(_lastPointerDownAt) >= _userIntentWindow) {
      return false;
    }
    final renderObject =
        FocusManager.instance.primaryFocus?.context?.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.hasSize ||
        !renderObject.attached) {
      return false;
    }
    return renderObject.size.contains(renderObject.globalToLocal(at));
  }

  /// Typing counts as being in the focused field, even when the field
  /// autofocused itself and the user never tapped it.
  void _markFocusUserDriven() {
    _focusIsUserDriven = true;
    _focusPage = controller.currentPage.value;
  }

  /// Moves the body by [delta] pixels, clamped to the scroll extent.
  /// [animate] is off while a key repeats so held arrows scroll smoothly
  /// instead of restarting a 120ms animation on every repeat.
  void _scrollBody(double delta, {required bool animate}) {
    if (!bodyScrollController.hasClients) return;
    final position = bodyScrollController.position;
    final target = (position.pixels + delta)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
    if (target == position.pixels) return;
    if (animate) {
      bodyScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    } else {
      bodyScrollController.jumpTo(target);
    }
  }

  /// Whether arrow up / down should scroll the page right now.
  bool get _arrowKeysScrollBody {
    if (!kArrowScrollPages.contains(controller.currentPage.value.runtimeType)) {
      return false;
    }

    if (shortCutKeyValue.value == "alert") {
      return false;
    }

    // Koi bhi field focused ho to scroll nahi karna — woh field khud arrow
    // keys use kar raha hota hai.
    return !isFieldFocused;
  }

  /// Whether the user is currently inside a field — a text field, a keyboard
  /// dropdown, a checkbox, a date picker, a suggestion list, anything that took
  /// focus from its own onTap. Those widgets drive themselves with the arrow
  /// keys, so the shell must keep its hands off the scroll view until the field
  /// is unfocused again.
  bool get isFieldFocused {
    // `KeyboardDatePicker.isAnyDatePickerFocused` ki zaroorat nahi rahi: woh
    // picker khud `autofocus: true` hai aur 40+ screens par baitha hai, to us
    // flag se un tamam pages ka scroll band ho jata tha. Picker ka apna focus
    // node primary focus hota hai, so neeche wali general jaanch use bhi cover
    // kar leti hai.
    final focus = FocusManager.instance.primaryFocus;
    // A scope node means the focus never landed on a widget — nothing to guard.
    if (focus == null || focus is FocusScopeNode) return false;

    final focusContext = focus.context;
    if (focusContext == null) return false;

    // A text field is a field whatever it measures. Everything else has to be
    // field-sized first: plenty of pages wrap their whole body in
    // `RawKeyboardListener(autofocus: true, focusNode: FocusNode())` only to
    // catch shortcuts (DriverListScreen, LocationListScreen, ListOfAccountScreen,
    // …) and that node holds the primary focus for as long as the page is open.
    // Such a catcher wraps the page, so it is at least as tall as the visible
    // area, which no real field ever is.
    if (focusContext.findAncestorStateOfType<EditableTextState>() == null) {
      final renderObject = focusContext.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) return false;
      if (renderObject.size.height >= _viewportHeight) return false;
    }

    // A field only owns the arrow keys once the user is actually in it — tapped
    // it, tabbed into it, or is typing in it. Half of these widgets autofocus
    // themselves as the page builds (calender.dart, radio_button_widget.dart,
    // KeyboardDatePicker, the search boxes, the suggestion overlays), and a
    // widget grabbing the focus by itself must not cost the user page scrolling.
    return _focusIsUserDriven &&
        identical(_focusPage, controller.currentPage.value);
  }

  /// Height of the shell's visible area — the yardstick a focused node is
  /// measured against in [isFieldFocused].
  double get _viewportHeight => bodyScrollController.hasClients
      ? bodyScrollController.position.viewportDimension
      : fallbackViewportHeight();

  void handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Tab aur Enter se user khud focus aage barhata hai — jo field un se
      // focus hoti hai woh arrow keys ki haqdaar hai.
      if (event.logicalKey == LogicalKeyboardKey.tab ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        _lastTraversalKeyAt = DateTime.now();
      }

      // Field mein type karna bhi user ka usi field mein hona hai.
      final character = event.character;
      if ((character != null && character.isNotEmpty) ||
          event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.delete) {
        _markFocusUserDriven();
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_arrowKeysScrollBody) {
          _scrollBody(
            event.logicalKey == LogicalKeyboardKey.arrowDown
                ? _arrowScrollStep
                : -_arrowScrollStep,
            animate: !event.repeat,
          );
        }
        return;
      }

      if (event.logicalKey.keyLabel == "F#") {
        shortCutKeyValue.value = "alert";
      }
      if (event.logicalKey.keyLabel == "/") {
        // DashboardSlashAlert.show();
      }
      if (event.logicalKey.keyLabel == "Escape") {
        if (shortCutKeyValue.value == "alert") {
          shortCutKeyValue.value = "shortCutKey";
        } else if (isFieldFocused) {
          // Escape se field chhoot jati hai, taake arrow keys wapas page ko
          // scroll karne lagen.
          FocusManager.instance.primaryFocus?.unfocus();
        }
      } else if (event.logicalKey.keyLabel == "F2") {
        final newTabUrl = Uri.base.origin + Routes.createBooking;
        html.window.open(newTabUrl, '_blank');
      }
    }
  }
}
