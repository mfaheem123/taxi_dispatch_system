// Non-web: there is no browser window to pop, so hand the URL to the platform
// (which opens it in the default browser — its own window already).
import 'package:url_launcher/url_launcher.dart';

Future<void> openInNewWindow(String url, {int width = 1200, int height = 850}) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
