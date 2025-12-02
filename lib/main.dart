import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:dashboard_new1/view/locations_view/controller/zone_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

import 'package:get_storage/get_storage.dart';

import 'component/networks/Url.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  disableInspect();

  html.document.documentElement?.requestFullscreen();
 Get.put(ZoneController(), permanent: true);
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.production,
  );
  Environment().initConfig(environment);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Nexus Tech",
      theme: ThemeData(
      ),

      initialRoute: AppPages.initial,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        child = ScrollConfiguration(
          behavior: MyBehavior(),
          child: EasyLoading.init(builder: BotToastInit())(context, child),
        );
        // return child;
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      getPages: AppPages.routes,
    );
  }
}


class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}


void disableInspect() {
  // Disable right click
  html.document.onContextMenu.listen((event) => event.preventDefault());

  // Disable specific keys
  html.document.onKeyDown.listen((event) {
    // F12
    if (event.keyCode == 123) {
      event.preventDefault();
    }
    // Ctrl+Shift+I or Ctrl+Shift+J or Ctrl+U
    if (event.ctrlKey && event.shiftKey && (event.keyCode == 73 || event.keyCode == 74)) {
      event.preventDefault();
    }
    if (event.ctrlKey && event.keyCode == 85) {
      event.preventDefault();
    }
  });
}
