import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../view/dashboard_view/widgets/view_drivers_map.dart';
import 'open_new_tab_web.dart';

/// Opens the live drivers map.
///
/// In a release build it opens in a new browser tab, as before.
///
/// In a debug run (`flutter run`) it opens inside THIS tab instead. The debug
/// tool connects only to the tab `flutter run` opened, so a second tab can't
/// be debugged and its console fills with "Unhandled error detected in the
/// injected client.js script ... WebSocketConnectionClosed". In this tab,
/// breakpoints, logs and hot reload all work on the map and its socket.
/// ViewDriversMap has no back button of its own, so it gets an AppBar here.
/// Leaving disposes it, which closes its driver-tracking socket.
void openDriversMap() {
  if (kDebugMode) {
    Get.to(() => Scaffold(
          appBar: AppBar(
            title: const Text('DRIVERS MAP (DEBUG: OPENED IN THIS TAB)'),
          ),
          body: const ViewDriversMap(),
        ));
    return;
  }
  openInNewTab('${Uri.base.origin}/#${Routes.viewDriversMap}');
}
