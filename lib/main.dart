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
// import 'package:bot_toast/bot_toast.dart';
// import 'package:dashboard_new1/routes/app_pages.dart';
// import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
// import 'package:dashboard_new1/view/locations_view/controller/zone_controller.dart';
// import 'package:dashboard_new1/view/notificationServices.dart';
// import 'package:dashboard_new1/view/setting/controller/setting_controller.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart'; // Add kiya
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'dart:html' as html;
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:get_storage/get_storage.dart';
// import 'component/networks/Url.dart';
// import 'view/auth/Controller/auth_controller.dart';
//
// // Background message handler (Top-level function)
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }
//
// // void main() async {
// //   // setUrlStrategy(const HashUrlStrategy());
// //   setUrlStrategy(const HashUrlStrategy());
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await GetStorage.init();
// //
// //   // --- Firebase Web Initialization ---
// //   await Firebase.initializeApp(
// //     options: const FirebaseOptions(
// //       apiKey: "AIzaSyDDxZ8lPfTJ1XcUn_7HpyvExygoWxgQR-A",
// //       authDomain: "texidispetchsystem.firebaseapp.com",
// //       projectId: "texidispetchsystem",
// //       storageBucket: "texidispetchsystem.firebasestorage.app",
// //       messagingSenderId: "81697669010",
// //       appId:"1:81697669010:web:388758b1deabeb4af60b4b",
// //     ),
// //   );
// //
// //   // --- Notification Setup ---
// //   await setupWebNotifications();
// //
// //   disableInspect();
// //
// //   Get.put(ZoneController(), permanent: true);
// //   Get.put(AuthController(), permanent: true);
// //   Get.put(DashboardController(), permanent: true);
// //
// //   const String environment = String.fromEnvironment(
// //     'ENVIRONMENT',
// //     defaultValue: Environment.production,
// //   );
// //   Environment().initConfig(environment);
// //
// //   runApp(const MyApp());
// // }
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // 1. Sab se pehle Environment configure karein taake Config mil jaye
//   const String environment = String.fromEnvironment(
//     'ENVIRONMENT',
//     defaultValue: Environment.production,
//   );
//   Environment().initConfig(environment);
//   print("Environment initialized: $environment");
//
//   await GetStorage.init();
//
//   try {
//     // 2. Phir Firebase aur Notifications initialize karein
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//       apiKey: "AIzaSyDDxZ8lPfTJ1XcUn_7HpyvExygoWxgQR-A",
//       authDomain: "texidispetchsystem.firebaseapp.com",
//       projectId: "texidispetchsystem",
//       storageBucket: "texidispetchsystem.firebasestorage.app",
//       messagingSenderId: "81697669010",
//       appId:"1:81697669010:web:388758b1deabeb4af60b4b",
//       ),
//     );
//     await setupWebNotifications();
//   } catch (e) {
//     print("Firebase/Notification Error: $e");
//   }
//
//   // 3. Controllers load karein
//   print("Initializing Controllers...");
//   Get.put(ZoneController(), permanent: true);
//   Get.put(AuthController(), permanent: true);
//   Get.put(DashboardController(), permanent: true);
//
//   runApp(const MyApp());
// }
// // Separate function for notification logic
// Future<void> setupWebNotifications() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   // 1. Request Permission
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//
//     // 2. Get Token (Web ke liye VAPID key lazmi hai)
//     // Is token ko copy karke aap test notification bhej sakte hain
//     String? token = await messaging.getToken(
//         vapidKey: "BNc4Q8vMx5Fnne8D5AiO-MX3nNSIdGTZoXn-8TdNYg448Wx32S8SIVIKJcaDMnY9Jy7cOvZ-by_tyZ7X3tdgp2c"
//     );
//     print("FCM Token: $token");
//
//     // 3. Listen for Foreground Messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       if (message.notification != null) {
//         // Aap BotToast use kar rahe hain toh yahan toast dikha sakte hain
//         BotToast.showSimpleNotification(
//           title: message.notification!.title ?? "Notification",
//           subTitle: message.notification!.body,
//           duration: const Duration(seconds: 5),
//         );
//       }
//     });
//
//     // 4. Set Background Handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   } else {
//     print('User declined or has not accepted permission');
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: "Nexus Tech",
//       theme: ThemeData(),
//       initialRoute: AppPages.initial,
//       debugShowCheckedModeBanner: false,
//       builder: (context, child) {
//         child = ScrollConfiguration(
//           behavior: MyBehavior(),
//           child: EasyLoading.init(builder: BotToastInit())(context, child),
//         );
//         return child;
//       },
//       navigatorObservers: [BotToastNavigatorObserver()],
//       getPages: AppPages.routes,
//     );
//   }
// }
//
// class MyBehavior extends ScrollBehavior {
//   @override
//   Widget buildOverscrollIndicator(
//       BuildContext context, Widget child, ScrollableDetails details) {
//     return child;
//   }
// }
//
// void disableInspect() {
//   html.document.onContextMenu.listen((event) => event.preventDefault());
//   html.document.onKeyDown.listen((event) {
//     if (event.keyCode == 123) {
//       event.preventDefault();
//     }
//     if (event.ctrlKey && event.shiftKey && (event.keyCode == 73 || event.keyCode == 74)) {
//       event.preventDefault();
//     }
//     if (event.ctrlKey && event.keyCode == 85) {
//       event.preventDefault();
//     }
//   });
// }

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/locations_view/controller/zone_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get_storage/get_storage.dart';
// Imports for your components and Panic Alert
import 'alert/driver_break_alert.dart';
import 'alert/driver_panic_alert.dart';
import 'component/networks/Url.dart';
import 'view/auth/Controller/auth_controller.dart';

// Background message handler (Top-level function)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // URL strategy set karein
  setUrlStrategy(const HashUrlStrategy());

  // 1. Environment Config (Sab se pehle taake API error na aaye)
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.production,
  );
  Environment().initConfig(environment);
  print("Environment initialized: $environment");

  // 2. Storage aur Firebase Initialization
  await GetStorage.init();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDDxZ8lPfTJ1XcUn_7HpyvExygoWxgQR-A",
        authDomain: "texidispetchsystem.firebaseapp.com",
        projectId: "texidispetchsystem",
        storageBucket: "texidispetchsystem.firebasestorage.app",
        messagingSenderId: "81697669010",
        appId: "1:81697669010:web:388758b1deabeb4af60b4b",
      ),
    );
    await setupWebNotifications();
  } catch (e) {
    print("Firebase/Notification Initialization Error: $e");
  }
  disableInspect();
  // Debugging ke liye isay comment rakhein, production pe on kar dein
  // disableInspect();

  // 3. Controllers Initialize karein
  print("Initializing Controllers...");
  Get.put(ZoneController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(DashboardController(), permanent: true);

  runApp(const MyApp());
}

// Notification Setup Function
Future<void> setupWebNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');

    String? token = await messaging.getToken(
        vapidKey: "BNc4Q8vMx5Fnne8D5AiO-MX3nNSIdGTZoXn-8TdNYg448Wx32S8SIVIKJcaDMnY9Jy7cOvZ-by_tyZ7X3tdgp2c"
    );
    print("FCM Token: $token");

    // --- Foreground Messages ---
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message in foreground: ${message.data}');
    //
    //   // Panic Driver Alert Logic
    //   if (message.data['type'] == 'PANIC_DRIVER') {
    //     // Driver ka naam body se nikalna (Example: "Driver: Mark" -> "Mark")
    //     String driverName = message.notification?.body?.replaceAll('Driver: ', '') ?? "Driver";
    //
    //     // Panic Dialog open karein
    //     Get.dialog(
    //       DriverPanicAlert(driverName: driverName),
    //       barrierColor: Colors.black54,
    //       barrierDismissible: false, // User ko "Close" click karna parega
    //     );
    //
    //     // Sound ya Visual Alert
    //     BotToast.showSimpleNotification(
    //       title: "🚨 PANIC ALERT",
    //       subTitle: message.notification?.body,
    //       backgroundColor: Colors.red,
    //       titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    //       duration: const Duration(seconds: 15),
    //     );
    //   } else {
    //     // Baki aam notifications
    //     if (message.notification != null) {
    //       BotToast.showSimpleNotification(
    //         title: message.notification!.title ?? "Notification",
    //         subTitle: message.notification!.body,
    //       );
    //     }
    //   }
    // }
// Foreground Messages logic inside setupWebNotifications
    // Foreground Messages logic
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message in foreground: ${message.data}');

      String type = message.data['type'] ?? "";
      String dName = message.data['driver_name'] ?? "Unknown";
      String dUser = message.data['driver_username'] ?? "N/A";
      String dMobile = message.data['driver_mobile'] ?? "N/A";
      String dID = message.data['driver_id'] ?? "N/A";

      // 1. Check for PANIC_DRIVER
      if (type == 'PANIC_DRIVER') {
        Get.dialog(
          DriverPanicAlert(
            driverName: dName,
            driverUsername: dUser,
            driverMobile: dMobile,
            driverID: dID,
          ),
          barrierColor: Colors.black54,
          barrierDismissible: false,
        );
      }
      // 2. Check for DRIVER_BREAK_WEB
      else if (type == 'DRIVER_BREAK_WEB') {
        Get.dialog(
          DriverActionAlert( // Aapka naya alert class
            driverName: dName,
            driverUsername: dUser,
            driverMobile: dMobile,
            driverID: dID,
          ),
          barrierColor: Colors.black54,
          barrierDismissible: false,
        );
      }

      // Toast Notification (Dono ke liye dikha sakte hain)
      BotToast.showSimpleNotification(
        title: type == 'PANIC_DRIVER' ? "🚨 PANIC ALERT" : "☕ BREAK ALERT",
        subTitle: "Driver: $dName",
        backgroundColor: type == 'PANIC_DRIVER' ? Colors.red : Colors.orange,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        duration: const Duration(seconds: 15),
      );
    });

// --- Notification Clicked (Background) ---
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String type = message.data['type'] ?? "";
      String dName = message.data['driver_name'] ?? "Driver";
      String dUser = message.data['driver_username'] ?? "N/A";
      String dMobile = message.data['driver_mobile'] ?? "N/A";
      String dID = message.data['driver_id'] ?? "N/A";

      if (type == 'PANIC_DRIVER') {
        Get.dialog(
          DriverPanicAlert(
            driverName: dName,
            driverUsername: dUser,
            driverMobile: dMobile,
            driverID: dID,
          ),
          barrierColor: Colors.black54,
          barrierDismissible: false,
        );
      }
      else if (type == 'DRIVER_BREAK_WEB') {
        Get.dialog(
          DriverActionAlert(
            driverName: dName,
            driverUsername: dUser,
            driverMobile: dMobile,
            driverID: dID,
          ),
          barrierColor: Colors.black54,
          barrierDismissible: false,
        );
      }
    });





    // --- Notification Clicked (App Background/Terminated) ---
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (message.data['type'] == 'PANIC_DRIVER') {
    //     String driverName = message.notification?.body?.replaceAll('Driver: ', '') ?? "Driver";
    //     Get.dialog(
    //       DriverPanicAlert(driverName: driverName),
    //       barrierColor: Colors.black54,
    //     );
    //   }
    // });
// --- Notification Clicked (App Background/Terminated) ---
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'PANIC_DRIVER') {
        // Data map se sari values nikalna zaroori hai
        String dName = message.data['driver_name'] ?? "Driver";
        String dUser = message.data['driver_username'] ?? "N/A";
        String dMobile = message.data['driver_mobile'] ?? "N/A";
        String dID = message.data['driver_id'] ?? "N/A";

        Get.dialog(
          DriverPanicAlert(
            driverName: dName,
            driverUsername: dUser,
            driverMobile: dMobile,
            driverID: dID,
          ),
          barrierColor: Colors.black54,
          barrierDismissible: false,
        );
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Nexus Tech",
      theme: ThemeData(
        useMaterial3: false, // Aapka purana theme style maintain karne ke liye
      ),
      initialRoute: AppPages.initial,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: EasyLoading.init(builder: BotToastInit())(context, child),
        );
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

// void disableInspect() {
//   html.document.onContextMenu.listen((event) => event.preventDefault());
//   html.document.onKeyDown.listen((event) {
//     if (event.keyCode == 123) event.preventDefault();
//     if (event.ctrlKey && event.shiftKey && (event.keyCode == 73 || event.keyCode == 74)) {
//       event.preventDefault();
//     }
//     if (event.ctrlKey && event.keyCode == 85) event.preventDefault();
//   });
// }
void disableInspect() {
  try {
    // 1. Right Click band karne ke liye
    html.document.onContextMenu.listen((event) => event.preventDefault());

    // 2. Keyboard Shortcuts block karne ke liye
    html.document.onKeyDown.listen((event) {
      // F12 key
      if (event.keyCode == 123) {
        event.preventDefault();
      }

      // Ctrl+Shift+I, Ctrl+Shift+J, Ctrl+Shift+C
      if (event.ctrlKey && event.shiftKey &&
          (event.keyCode == 73 || event.keyCode == 74 || event.keyCode == 67)) {
        event.preventDefault();
      }

      // Ctrl+U (View Source)
      if (event.ctrlKey && event.keyCode == 85) {
        event.preventDefault();
      }

      // Mac Users ke liye (Command + Option + I/J)
      if (event.metaKey && event.altKey &&
          (event.keyCode == 73 || event.keyCode == 74)) {
        event.preventDefault();
      }
    });

    print("Security: Inspect Element features disabled.");
  } catch (e) {
    // Agar kisi wajah se error aaye toh app crash nahi hogi
    print("Error disabling inspect: $e");
  }
}