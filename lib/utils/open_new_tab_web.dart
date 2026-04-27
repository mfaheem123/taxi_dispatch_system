// Web: open URL in a new browser tab using window.open.
import 'dart:html' as html;
Future<void> openInNewTab(String url) async {
  html.window.open(url, '_blank');
}
