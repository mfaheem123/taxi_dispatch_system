import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
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

