// Non-web: fallback using url_launcher (new window or external app).
import 'package:url_launcher/url_launcher.dart';

Future<void> openInNewTab(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
