import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pixels the page moves per arrow key press / repeat.
const double _arrowScrollStep = 60;

/// The scroll view the arrow keys should move — normally the app shell's body
/// scroller in main_appbar.dart, which is what actually moves the page on
/// screen.
///
/// Any scroll view BELOW [context] is never a candidate (the walk only goes
/// outward), and the search keeps walking past any scroll view that has nothing
/// to scroll: in the shell an inner scroll view gets unbounded height, so
/// ByDefaultDashboard's own one (used by the stacked iPad / mobile layout) sits
/// at maxScrollExtent 0 and stopping there would leave the arrows doing nothing.
ScrollPosition? _scrollablePosition(BuildContext context) {
  if (!context.mounted) return null;
  BuildContext ctx = context;
  // findAncestorStateOfType (not Scrollable.maybeOf) so the walk stays a plain
  // lookup and registers no inherited-widget dependencies on the scroll views
  // it passes through.
  for (var depth = 0; depth < 8; depth++) {
    final scrollable = ctx.findAncestorStateOfType<ScrollableState>();
    if (scrollable == null) return null;
    final position = scrollable.position;
    if (position.hasContentDimensions &&
        position.maxScrollExtent > position.minScrollExtent) {
      return position;
    }
    ctx = scrollable.context;
  }
  return null;
}

/// Moves [position] by [delta] pixels, clamped to its scroll extent.
/// [animate] is off while a key repeats so a held arrow scrolls smoothly
/// instead of restarting a short animation on every repeat.
void _scrollPage(ScrollPosition position, double delta,
    {required bool animate}) {
  final target = (position.pixels + delta)
      .clamp(position.minScrollExtent, position.maxScrollExtent);
  if (target == position.pixels) return;
  if (animate) {
    position.animateTo(
      target,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
    );
  } else {
    position.jumpTo(target);
  }
}

/// Arrow up / down scrolls the page hosting [context] — including while focus
/// is inside a text field, where the keys would otherwise only jump the caret
/// to the start / end of a single line.
///
/// Wire it to the `onKeyEvent` of a Focus node that is an ANCESTOR of the
/// widgets it should serve, so it only sees the event after the focused control
/// has passed on it: suggestion panels, the open calendar and the booking
/// table's row navigation still own the arrows and return `handled` before it
/// ever gets here.
KeyEventResult handlePageArrowScroll(BuildContext context, KeyEvent event) {
  if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
    return KeyEventResult.ignored;
  }
  final key = event.logicalKey;
  final isDown = key == LogicalKeyboardKey.arrowDown;
  if (!isDown && key != LogicalKeyboardKey.arrowUp) {
    return KeyEventResult.ignored;
  }
  // Nothing to scroll (the page fits on screen): stand aside so the key keeps
  // its default meaning instead of being silently swallowed.
  final position = _scrollablePosition(context);
  if (position == null) return KeyEventResult.ignored;
  _scrollPage(
    position,
    isDown ? _arrowScrollStep : -_arrowScrollStep,
    animate: event is KeyDownEvent,
  );
  return KeyEventResult.handled;
}
