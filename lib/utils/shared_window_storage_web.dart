// Web: the popped window is a separate app instance on the SAME ORIGIN, and
// localStorage is the one thing the two share.
//
// Written through dart:html rather than through GetStorage because this write
// has to be SYNCHRONOUS. A browser only honours window.open while it is still
// processing the click that asked for it; awaiting a storage flush first is
// exactly the kind of gap that gets the window silently blocked, or demoted to
// a tab. localStorage's setter returns once the value is stored, so the open
// call that follows is still part of the same user gesture.
import 'dart:html' as html;

String? readSharedValue(String key) => html.window.localStorage[key];

void writeSharedValue(String key, String value) {
  html.window.localStorage[key] = value;
}

void removeSharedValue(String key) {
  html.window.localStorage.remove(key);
}
