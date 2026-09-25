// Opens a URL in a SEPARATE BROWSER WINDOW rather than a tab.
//
// The conditional export keeps `dart:html` out of the mobile/desktop builds:
// only the web compilation sees the popup implementation, everything else
// falls back to url_launcher.
export 'open_new_window_stub.dart'
    if (dart.library.html) 'open_new_window_web.dart';
