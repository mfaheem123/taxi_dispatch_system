//
// import 'package:bot_toast/bot_toast.dart';
// import 'package:dashboard_new1/routes/app_pages.dart';
// import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
// import 'package:dashboard_new1/view/locations_view/controller/zone_controller.dart';
// import 'package:dashboard_new1/view/notificationServices.dart';
// import 'package:dashboard_new1/view/setting/controller/setting_controller.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'dart:html' as html;
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:get_storage/get_storage.dart';
// import 'component/networks/Url.dart';
// import 'view/auth/Controller/auth_controller.dart';
//
//
// void main() async{
//
//   // usePathUrlStrategy(); // removes # from URL
//   setUrlStrategy(const HashUrlStrategy());
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();
//
//   /// 🔑 READ TOKEN BEFORE APP START
//    // final String? token = GetStorage().read('token');
//   //
//   // /// 🔑 DECIDE INITIAL ROUTE
//   // final String initialRoute =
//   // token == null ? Routes.loginScreen : Routes.myHomePage;
//
//   disableInspect();
//   //
//   // html.document.documentElement?.requestFullscreen();
//  Get.put(ZoneController(), permanent: true);
//   Get.put(AuthController(), permanent: true);
//   Get.put(DashboardController(), permanent: true);
//
//   const String environment = String.fromEnvironment(
//     'ENVIRONMENT',
//     defaultValue: Environment.production,
//   );
//   Environment().initConfig(environment);
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: "Nexus Tech",
//       theme: ThemeData(
//       ),
//
//       initialRoute: AppPages.initial,
//       debugShowCheckedModeBanner: false,
//       builder: (context, child) {
//         child = ScrollConfiguration(
//           behavior: MyBehavior(),
//           child: EasyLoading.init(builder: BotToastInit())(context, child),
//         );
//         // return child;
//         return child;
//
//       },
//       navigatorObservers: [BotToastNavigatorObserver()],
//       getPages: AppPages.routes,
//     );
//   }
// }
//
//
// class MyBehavior extends ScrollBehavior {
//   @override
//   Widget buildOverscrollIndicator(
//       BuildContext context, Widget child, ScrollableDetails details) {
//     return child;
//   }
// }
//
//
// void disableInspect() {
//   // Disable right click
//   html.document.onContextMenu.listen((event) => event.preventDefault());
//
//   // Disable specific keys
//   html.document.onKeyDown.listen((event) {
//     // F12
//     if (event.keyCode == 123) {
//       event.preventDefault();
//     }
//     // Ctrl+Shift+I or Ctrl+Shift+J or Ctrl+U
//     if (event.ctrlKey && event.shiftKey && (event.keyCode == 73 || event.keyCode == 74)) {
//       event.preventDefault();
//     }
//     if (event.ctrlKey && event.keyCode == 85) {
//       event.preventDefault();
//     }
//   });
// }
///======================================================
// import 'package:bot_toast/bot_toast.dart';
// import 'package:dashboard_new1/routes/app_pages.dart';
// import 'package:dashboard_new1/view/locations_view/controller/zone_controller.dart';
// import 'package:dashboard_new1/view/notificationServices.dart';
// import 'package:dashboard_new1/view/setting/controller/setting_controller.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'dart:html' as html;
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:get_storage/get_storage.dart';
// import 'component/networks/Url.dart';
// import 'view/auth/Controller/auth_controller.dart';
//
//
// void main() async{
//
//   // usePathUrlStrategy(); // removes # from URL
//   setUrlStrategy(const HashUrlStrategy());
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();
//
//   /// 🔑 READ TOKEN BEFORE APP START
//    // final String? token = GetStorage().read('token');
//   //
//   // /// 🔑 DECIDE INITIAL ROUTE
//   // final String initialRoute =
//   // token == null ? Routes.loginScreen : Routes.myHomePage;
//
//   disableInspect();
//   //
//   // html.document.documentElement?.requestFullscreen();
//  Get.put(ZoneController(), permanent: true);
//
//  Get.put(AuthController(), permanent: true);
//   const String environment = String.fromEnvironment(
//     'ENVIRONMENT',
//     defaultValue: Environment.production,
//   );
//   Environment().initConfig(environment);
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: "Nexus Tech",
//       theme: ThemeData(
//       ),
//
//       initialRoute: AppPages.initial,
//       debugShowCheckedModeBanner: false,
//       builder: (context, child) {
//         child = ScrollConfiguration(
//           behavior: MyBehavior(),
//           child: EasyLoading.init(builder: BotToastInit())(context, child),
//         );
//         // return child;
//         return child;
//
//       },
//       navigatorObservers: [BotToastNavigatorObserver()],
//       getPages: AppPages.routes,
//     );
//   }
// }
//
//
// class MyBehavior extends ScrollBehavior {
//   @override
//   Widget buildOverscrollIndicator(
//       BuildContext context, Widget child, ScrollableDetails details) {
//     return child;
//   }
// }
//
//
// void disableInspect() {
//   // Disable right click
//   html.document.onContextMenu.listen((event) => event.preventDefault());
//
//   // Disable specific keys
//   html.document.onKeyDown.listen((event) {
//     // F12
//     if (event.keyCode == 123) {
//       event.preventDefault();
//     }
//     // Ctrl+Shift+I or Ctrl+Shift+J or Ctrl+U
//     if (event.ctrlKey && event.shiftKey && (event.keyCode == 73 || event.keyCode == 74)) {
//       event.preventDefault();
//     }
//     if (event.ctrlKey && event.keyCode == 85) {
//       event.preventDefault();
//     }
//   });
// }
///======================================================
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/locations_view/controller/zone_controller.dart';
import 'package:dashboard_new1/view/notificationServices.dart';
import 'package:dashboard_new1/view/setting/controller/setting_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Add kiya
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get_storage/get_storage.dart';
import 'component/networks/Url.dart';
import 'view/auth/Controller/auth_controller.dart';

// Background message handler (Top-level function)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // setUrlStrategy(const HashUrlStrategy());
 // setUrlStrategy(const HashUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  if (!kIsWeb) {
    // --- Firebase Web Initialization ---
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDDxZ8lPfTJ1XcUn_7HpyvExygoWxgQR-A",
        authDomain: "texidispetchsystem.firebaseapp.com",
        projectId: "texidispetchsystem",
        storageBucket: "texidispetchsystem.firebasestorage.app",
        messagingSenderId: "81697669010",
        appId:"1:81697669010:web:388758b1deabeb4af60b4b",
      ),
    );

    // --- Notification Setup ---
    await setupWebNotifications();
  }

  disableInspect();

  Get.put(ZoneController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(DashboardController(), permanent: true);

  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.production,
  );
  Environment().initConfig(environment);

  runApp(const MyApp());
}

// Separate function for notification logic
Future<void> setupWebNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 1. Request Permission
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');

    // 2. Get Token (Web ke liye VAPID key lazmi hai)
    // Is token ko copy karke aap test notification bhej sakte hain
    String? token = await messaging.getToken(
        vapidKey: "BNc4Q8vMx5Fnne8D5AiO-MX3nNSIdGTZoXn-8TdNYg448Wx32S8SIVIKJcaDMnY9Jy7cOvZ-by_tyZ7X3tdgp2c"
    );
    print("FCM Token: $token");

    // 3. Listen for Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        // Aap BotToast use kar rahe hain toh yahan toast dikha sakte hain
        BotToast.showSimpleNotification(
          title: message.notification!.title ?? "Notification",
          subTitle: message.notification!.body,
          duration: const Duration(seconds: 5),
        );
      }
    });

    // 4. Set Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } else {
    print('User declined or has not accepted permission');
  }
}

/// Checks the browser URL hash for a valid deep link route.
/// If the URL is e.g. http://localhost/#/ViewDriversMap, returns '/ViewDriversMap'.
/// Otherwise falls back to the default login screen.
String _getInitialRoute() {
  final fragment = Uri.base.fragment; // everything after '#'
  if (fragment.isNotEmpty) {
    // Check if this hash matches any registered GetX route
    final isValidRoute = AppPages.routes.any((page) => page.name == fragment);
    if (isValidRoute) {
      return fragment;
    }
  }
  return AppPages.initial;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Nexus Tech",
      theme: ThemeData(),
      initialRoute: _getInitialRoute(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        child = BotToastInit()(context, child);     // bot_toast overlay
        child = EasyLoading.init()(context, child); // easy_loading overlay
        return ScrollConfiguration(behavior: MyBehavior(), child: child);
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
  html.document.onContextMenu.listen((event) => event.preventDefault());
  html.document.onKeyDown.listen((event) {
    if (event.keyCode == 123) {
      event.preventDefault();
    }
    if (event.ctrlKey && event.shiftKey && (event.keyCode == 73 || event.keyCode == 74)) {
      event.preventDefault();
    }
    if (event.ctrlKey && event.keyCode == 85) {
      event.preventDefault();
    }
  });
}