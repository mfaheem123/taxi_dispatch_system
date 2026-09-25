// Web: open the URL in a standalone browser window instead of a tab.
//
// A bare window.open(url, '_blank') is what every browser turns into a TAB.
// Passing a feature string — and `popup=yes` in particular — is what asks for
// a real window, so the size/position arguments below are not cosmetic: drop
// them and the call silently goes back to opening a tab.
import 'dart:html' as html;

Future<void> openInNewWindow(String url,
    {int width = 1200, int height = 850}) async {
  // Never ask for a window larger than the screen it has to fit on, or the
  // browser clamps it and the centring maths lands the frame off-screen.
  final screen = html.window.screen;
  final availWidth = screen?.available.width.toInt() ?? width;
  final availHeight = screen?.available.height.toInt() ?? height;
  final w = width < availWidth ? width : availWidth;
  final h = height < availHeight ? height : availHeight;
  // Centre on the screen the user is actually looking at, not on screen 0 of a
  // multi-monitor setup: window.screenX/Y is where the current window sits.
  final left = (html.window.screenX ?? 0) + ((html.window.outerWidth - w) ~/ 2);
  final top = (html.window.screenY ?? 0) + ((html.window.outerHeight - h) ~/ 2);

  final features = 'popup=yes,width=$w,height=$h,left=$left,top=$top,'
      'menubar=no,toolbar=no,location=no,status=no,resizable=yes,scrollbars=yes';

  // A blocked popup returns null here despite the non-nullable static type, so
  // the result is read dynamically and the user still gets the page — in a tab
  // — rather than a click that does nothing.
  final dynamic opened = html.window.open(url, '_blank', features);
  if (opened == null) html.window.open(url, '_blank');
}
