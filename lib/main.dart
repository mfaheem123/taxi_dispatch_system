//
//
// import 'package:bot_toast/bot_toast.dart';
// import 'package:dashboard_new1/routes/app_pages.dart';
// import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
// import 'package:dashboard_new1/view/locations_view/controller/zone_controller.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'dart:html' as html;
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:get_storage/get_storage.dart';
// // Imports for your components and Panic Alert
// import 'alert/driver_break_alert.dart';
// import 'alert/driver_panic_alert.dart';
// import 'component/networks/Url.dart';
// import 'view/auth/Controller/auth_controller.dart';
//
// // Background message handler (Top-level function)
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//
//   await Firebase.initializeApp();
//
//   print("Handling a background message: ${message.messageId}");
//
// }
//
// void main() async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // URL strategy set karein
//
//   setUrlStrategy(const HashUrlStrategy());
//
//   // 1. Environment Config (Sab se pehle taake API error na aaye)
//
//   const String environment = String.fromEnvironment(
//     'ENVIRONMENT',
//     defaultValue: Environment.production,
//   );
//
//   Environment().initConfig(environment);
//   print("Environment initialized: $environment");
//
//   // 2. Storage aur Firebase Initialization
//   await GetStorage.init();
//
//   try {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyDDxZ8lPfTJ1XcUn_7HpyvExygoWxgQR-A",
//         authDomain: "texidispetchsystem.firebaseapp.com",
//         projectId: "texidispetchsystem",
//         storageBucket: "texidispetchsystem.firebasestorage.app",
//         messagingSenderId: "81697669010",
//         appId: "1:81697669010:web:388758b1deabeb4af60b4b",
//       ),
//     );
//
//     await setupWebNotifications();
//
//   } catch (e) {
//     print("Firebase/Notification Initialization Error: $e");
//   }
//
//   disableInspect();
//
//   // Debugging ke liye isay comment rakhein, production pe on kar dein
//   // disableInspect();
//
//   // 3. Controllers Initialize karein
//   print("Initializing Controllers...");
//   Get.put(ZoneController(), permanent: true);
//   Get.put(AuthController(), permanent: true);
//   Get.put(DashboardController(), permanent: true);
//   runApp(const MyApp());
// }
//
// // Notification Setup Function
// Future<void> setupWebNotifications() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//
//     String? token = await messaging.getToken(
//         vapidKey: "BNc4Q8vMx5Fnne8D5AiO-MX3nNSIdGTZoXn-8TdNYg448Wx32S8SIVIKJcaDMnY9Jy7cOvZ-by_tyZ7X3tdgp2c"
//     );
//
//     print("FCM Token: $token");
//
//     // --- Foreground Messages ---
//     // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     //   print('Got a message in foreground: ${message.data}');
//     //
//     //   // Panic Driver Alert Logic
//     //   if (message.data['type'] == 'PANIC_DRIVER') {
//     //     // Driver ka naam body se nikalna (Example: "Driver: Mark" -> "Mark")
//     //     String driverName = message.notification?.body?.replaceAll('Driver: ', '') ?? "Driver";
//     //
//     //     // Panic Dialog open karein
//     //     Get.dialog(
//     //       DriverPanicAlert(driverName: driverName),
//     //       barrierColor: Colors.black54,
//     //       barrierDismissible: false, // User ko "Close" click karna parega
//     //     );
//     //
//     //     // Sound ya Visual Alert
//     //     BotToast.showSimpleNotification(
//     //       title: "🚨 PANIC ALERT",
//     //       subTitle: message.notification?.body,
//     //       backgroundColor: Colors.red,
//     //       titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//     //       duration: const Duration(seconds: 15),
//     //     );
//     //   } else {
//     //     // Baki aam notifications
//     //     if (message.notification != null) {
//     //       BotToast.showSimpleNotification(
//     //         title: message.notification!.title ?? "Notification",
//     //         subTitle: message.notification!.body,
//     //       );
//     //     }
//     //   }
//     // }
// // Foreground Messages logic inside setupWebNotifications
//     // Foreground Messages logic
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message in foreground: ${message.data}');
//
//       String type = message.data['type'] ?? "";
//       String dName = message.data['driver_name'] ?? "Unknown";
//       String dUser = message.data['driver_username'] ?? "N/A";
//       String dMobile = message.data['driver_mobile'] ?? "N/A";
//       String dID = message.data['driver_id'] ?? "N/A";
//
//       // 1. Check for PANIC_DRIVER
//       if (type == 'PANIC_DRIVER') {
//         Get.dialog(
//           DriverPanicAlert(
//             driverName: dName,
//             driverUsername: dUser,
//             driverMobile: dMobile,
//             driverID: dID,
//           ),
//           barrierColor: Colors.black54,
//           barrierDismissible: false,
//         );
//       }
//
//       // 2. Check for DRIVER_BREAK_WEB
//       else if (type == 'DRIVER_BREAK_WEB') {
//         Get.dialog(
//           DriverActionAlert( // Aapka naya alert class
//             driverName: dName,
//             driverUsername: dUser,
//             driverMobile: dMobile,
//             driverID: dID,
//           ),
//           barrierColor: Colors.black54,
//           barrierDismissible: false,
//         );
//       }
//
//       // Toast Notification (Dono ke liye dikha sakte hain)
//       BotToast.showSimpleNotification(
//         title: type == 'PANIC_DRIVER' ? "🚨 PANIC ALERT" : "☕ BREAK ALERT",
//         subTitle: "Driver: $dName",
//         backgroundColor: type == 'PANIC_DRIVER' ? Colors.red : Colors.orange,
//         titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         duration: const Duration(seconds: 15),
//       );
//     });
//
// // --- Notification Clicked (Background) ---
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       String type = message.data['type'] ?? "";
//       String dName = message.data['driver_name'] ?? "Driver";
//       String dUser = message.data['driver_username'] ?? "N/A";
//       String dMobile = message.data['driver_mobile'] ?? "N/A";
//       String dID = message.data['driver_id'] ?? "N/A";
//
//       if (type == 'PANIC_DRIVER') {
//         Get.dialog(
//           DriverPanicAlert(
//             driverName: dName,
//             driverUsername: dUser,
//             driverMobile: dMobile,
//             driverID: dID,
//           ),
//           barrierColor: Colors.black54,
//           barrierDismissible: false,
//         );
//       }
//       else if (type == 'DRIVER_BREAK_WEB') {
//         Get.dialog(
//           DriverActionAlert(
//             driverName: dName,
//             driverUsername: dUser,
//             driverMobile: dMobile,
//             driverID: dID,
//           ),
//           barrierColor: Colors.black54,
//           barrierDismissible: false,
//         );
//       }
//     });
//
//
//
//
//
//     // --- Notification Clicked (App Background/Terminated) ---
//     // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     //   if (message.data['type'] == 'PANIC_DRIVER') {
//     //     String driverName = message.notification?.body?.replaceAll('Driver: ', '') ?? "Driver";
//     //     Get.dialog(
//     //       DriverPanicAlert(driverName: driverName),
//     //       barrierColor: Colors.black54,
//     //     );
//     //   }
//     // });
// // --- Notification Clicked (App Background/Terminated) ---
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (message.data['type'] == 'PANIC_DRIVER') {
//         // Data map se sari values nikalna zaroori hai
//         String dName = message.data['driver_name'] ?? "Driver";
//         String dUser = message.data['driver_username'] ?? "N/A";
//         String dMobile = message.data['driver_mobile'] ?? "N/A";
//         String dID = message.data['driver_id'] ?? "N/A";
//
//         Get.dialog(
//           DriverPanicAlert(
//             driverName: dName,
//             driverUsername: dUser,
//             driverMobile: dMobile,
//             driverID: dID,
//           ),
//           barrierColor: Colors.black54,
//           barrierDismissible: false,
//         );
//       }
//     });
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
//       theme: ThemeData(
//         useMaterial3: false, // Aapka purana theme style maintain karne ke liye
//       ),
//       initialRoute: AppPages.initial,
//       debugShowCheckedModeBanner: false,
//       builder: (context, child) {
//         return ScrollConfiguration(
//           behavior: MyBehavior(),
//           child: EasyLoading.init(builder: BotToastInit())(context, child),
//         );
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
// // void disableInspect() {
// //   html.document.onContextMenu.listen((event) => event.preventDefault());
// //   html.document.onKeyDown.listen((event) {
// //     if (event.keyCode == 123) event.preventDefault();
// //     if (event.ctrlKey && event.shiftKey && (event.keyCode == 73 || event.keyCode == 74)) {
// //       event.preventDefault();
// //     }
// //     if (event.ctrlKey && event.keyCode == 85) event.preventDefault();
// //   });
// // }
// void disableInspect() {
//   try {
//     // 1. Right Click band karne ke liye
//     html.document.onContextMenu.listen((event) => event.preventDefault());
//
//     // 2. Keyboard Shortcuts block karne ke liye
//     html.document.onKeyDown.listen((event) {
//       // F12 key
//       if (event.keyCode == 123) {
//         event.preventDefault();
//       }
//
//       // Ctrl+Shift+I, Ctrl+Shift+J, Ctrl+Shift+C
//       if (event.ctrlKey && event.shiftKey &&
//           (event.keyCode == 73 || event.keyCode == 74 || event.keyCode == 67)) {
//         event.preventDefault();
//       }
//
//       // Ctrl+U (View Source)
//       if (event.ctrlKey && event.keyCode == 85) {
//         event.preventDefault();
//       }
//
//       // Mac Users ke liye (Command + Option + I/J)
//       if (event.metaKey && event.altKey &&
//           (event.keyCode == 73 || event.keyCode == 74)) {
//         event.preventDefault();
//       }
//     });
//
//     print("Security: Inspect Element features disabled.");
//   } catch (e) {
//     // Agar kisi wajah se error aaye toh app crash nahi hogi
//     print("Error disabling inspect: $e");
//   }
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
import 'package:http/http.dart' as http;
import 'dart:convert';

// Imports for your components and Alerts
import 'alert/driver_break_alert.dart';
import 'alert/driver_panic_alert.dart';
import 'component/networks/Url.dart';
import 'component/networks/api.dart' as Urls;
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

  // 1. Environment Config
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

    // String? token = await messaging.getToken(
    //     vapidKey: "BNc4Q8vMx5Fnne8D5AiO-MX3nNSIdGTZoXn-8TdNYg448Wx32S8SIVIKJcaDMnY9Jy7cOvZ-by_tyZ7X3tdgp2c"
    // );
    // print("FCM Token: $token");

    // Helper function to process notifications and open correct dialogs
    Future<void> handleNotificationTypes(RemoteMessage message, {bool isForeground = false}) async {
      String type = message.data['type'] ?? "";

      // 1. Check for PANIC_DRIVER
      if (type == 'PANIC_DRIVER') {
        String dName = message.data['driver_name'] ?? "Unknown";
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

        if (isForeground) {
          BotToast.showSimpleNotification(
            title: "🚨 PANIC ALERT",
            subTitle: "Driver: $dName",
            backgroundColor: Colors.red,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            duration: const Duration(seconds: 15),
          );
        }
      }

      // 2. Check for DRIVER_BREAK_WEB
      else if (type == 'DRIVER_BREAK_WEB') {
        String dName = message.data['driver_name'] ?? "Unknown";
        String dUser = message.data['driver_username'] ?? "N/A";
        String dMobile = message.data['driver_mobile'] ?? "N/A";
        String dID = message.data['driver_id'] ?? "N/A";

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

        if (isForeground) {
          BotToast.showSimpleNotification(
            title: "☕ BREAK ALERT",
            subTitle: "Driver: $dName",
            backgroundColor: Colors.orange,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            duration: const Duration(seconds: 15),
          );
        }
      }

      // 3. NEW_APP_BOOKING
      else if (type == 'NEW_APP_BOOKING') {
        String bookingId = message.data['booking_id'] ?? "";
        String bookingMode = message.data['booking_mode'] ?? "N/A";

        Get.dialog(
          NewBookingAlert(
            bookingId: bookingId,
            bookingMode: bookingMode,
            bookingType: 'APP', // Pass APP type
          ),
          barrierColor: Colors.black54,
          barrierDismissible: false,
        );

        if (isForeground) {
          BotToast.showSimpleNotification(
            title: message.notification?.title ?? " New Booking Received",
            subTitle: message.notification?.body ?? "Booking ID: $bookingId",
            backgroundColor: Colors.blue,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            duration: const Duration(seconds: 15),
          );
        }
      }
      else if (type == 'NEW_IVR_BOOKING') {
        String bookingId = message.data['booking_id'] ?? "";
        String bookingMode = message.data['booking_mode'] ?? "N/A";

        Get.dialog(
          NewBookingAlert(
            bookingId: bookingId,
            bookingMode: bookingMode,
            bookingType: 'IVR', // Pass APP type
          ),
          barrierColor: Colors.black54,
          barrierDismissible: false,
        );

        if (isForeground) {
          BotToast.showSimpleNotification(
            title: message.notification?.title ?? " New Booking Received",
            subTitle: message.notification?.body ?? "Booking ID: $bookingId",
            backgroundColor: Colors.blue,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            duration: const Duration(seconds: 15),
          );
        }
      }

      // 4. NEW_WEB_BOOKING
      else if (type == 'NEW_WEB_BOOKING') {
        String bookingId = message.data['booking_id'] ?? "";
        String bookingMode = message.data['booking_mode'] ?? "N/A";

        Get.dialog(
          NewBookingAlert(
            bookingId: bookingId,
            bookingMode: bookingMode,
            bookingType: 'WEB', // Pass WEB type
          ),
          barrierColor: Colors.black54,
          barrierDismissible: false,
        );

        if (isForeground) {
          BotToast.showSimpleNotification(
            title: message.notification?.title ?? " New Booking Received",
            subTitle: message.notification?.body ?? "Booking ID: $bookingId",
            backgroundColor: Colors.blue,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            duration: const Duration(seconds: 15),
          );
        }
      }
    }

    // --- Foreground Messages ---
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message in foreground: ${message.data}');
      handleNotificationTypes(message, isForeground: true);
    });

    // --- Notification Clicked (Background) ---
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked in background: ${message.data}');
      handleNotificationTypes(message, isForeground: false);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}


class NewBookingAlert extends StatefulWidget {
  final String bookingId;
  final String bookingMode;
  final String bookingType; // Naya parameter (APP ya WEB save karne k liye)

  const NewBookingAlert({
    super.key,
    required this.bookingId,
    required this.bookingMode,
    required this.bookingType, // Required parameter
  });

  @override
  State<NewBookingAlert> createState() => _NewBookingAlertState();
}

class _NewBookingAlertState extends State<NewBookingAlert> {
  bool isLoading = true;
  bool isDriversLoading = false;
  bool isDispatching = false;
  Map<String, dynamic>? booking;
  String? errorMessage;

  List<dynamic> activeDrivers = [];
  String? selectedDriverId;

  @override
  void initState() {
    super.initState();
    getBookingDetails();
    if (widget.bookingMode.toUpperCase() == 'ASAP') {
      fetchActiveDrivers();
    }
  }

  Future<void> getBookingDetails() async {
    try {
      final String apiUrl = "${Urls.baseUrl}bookings/getbyid/${widget.bookingId}";

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          booking = decodedData['booking'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load data (Status: ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error connecting to server";
        isLoading = false;
      });
    }
  }

  Future<void> fetchActiveDrivers() async {
    setState(() {
      isDriversLoading = true;
    });
    try {
      final String driversApiUrl = "${Urls.baseUrl}drivers/login-busy";
      final response = await http.get(
        Uri.parse(driversApiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          activeDrivers = data['login_drivers'] ?? [];
          isDriversLoading = false;
        });
      } else {
        print("Drivers API error status code: ${response.statusCode}");
        setState(() => isDriversLoading = false);
      }
    } catch (e) {
      print("Exception while fetching drivers: $e");
      setState(() => isDriversLoading = false);
    }
  }

  Future<void> dispatchBooking() async {
    if (selectedDriverId == null) {
      BotToast.showText(text: "Please select a driver first!");
      return;
    }

    setState(() {
      isDispatching = true;
    });
    EasyLoading.show(status: 'Dispatching booking...');

    try {
      final String dispatchUrl = "${Urls.baseUrl}bookings/assign-driver";

      var request = http.MultipartRequest('POST', Uri.parse(dispatchUrl));
      request.fields['booking_id'] = widget.bookingId;
      request.fields['driver_id'] = selectedDriverId!;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        BotToast.showText(
          text: responseData['message'] ?? "Booking Dispatched Successfully",
          // backgroundColor: Colors.green,
        );
        Get.back();
      } else {
        final responseData = json.decode(response.body);
        BotToast.showText(
          text: responseData['message'] ?? "Failed to dispatch booking (${response.statusCode})",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception during dispatch: $e");
      BotToast.showText(text: "Connection error while dispatching");
    } finally {
      setState(() {
        isDispatching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String referenceNumber = booking?['reference_number'] ?? "N/A";
    String pickup = booking?['pickup'] ?? "Unknown Pickup";
    String dropoff = booking?['dropoff'] ?? "Unknown Dropoff";
    String journeyType = booking?['journey_type']?['journey_type'] ?? "N/A";
    String pickupDate = booking?['pickup_date'] ?? "N/A";
    String pickupTime = booking?['pickup_time'] ?? "N/A";
    String fares = booking?['fares']?.toString() ?? "0.00";

    bool isAsapMode = widget.bookingMode.toUpperCase() == 'ASAP';

    // Title ko dynamic karne ke liye string check lagayi hai
    // String alertTitle = widget.bookingType == 'WEB'
    //     ? "New WEB Booking Alert ($referenceNumber)"
    //     : "New APP Booking Alert ($referenceNumber)";
    String alertTitle = widget.bookingType == 'WEB'
        ? "New WEB Booking Alert ($referenceNumber)"
        : widget.bookingType == 'IVR'
        ? "New IVR Booking Alert ($referenceNumber)"
        : "New APP Booking Alert ($referenceNumber)";

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          const Icon(Icons.local_taxi, color: Colors.blue, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              alertTitle, // Dynamic Title call ho raha hai yahan
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 450,
        child: isLoading
            ? const SizedBox(
          height: 150,
          child: Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        )
            : errorMessage != null
            ? SizedBox(
          height: 100,
          child: Center(
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isAsapMode ? Colors.red.shade50 : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Mode: ${widget.bookingMode}",
                      style: TextStyle(
                          color: isAsapMode ? Colors.red : Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Journey: ${journeyType.toUpperCase()}",
                      style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Date & Time
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    "$pickupDate at $pickupTime",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(),
              ),

              // Locations
              const Text("📍 PICKUP LOCATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
              const SizedBox(height: 4),
              Text(pickup, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
              const SizedBox(height: 15),

              const Text("🏁 DROPOFF LOCATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
              const SizedBox(height: 4),
              Text(dropoff, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),

              // Driver Dropdown
              if (isAsapMode) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(),
                ),
                const Text(
                    "🚖 SELECT LOGIN DRIVER",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedDriverId,
                  hint: Text(isDriversLoading ? "Refreshing drivers list..." : "Choose Active Driver"),
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    suffixIcon: isDriversLoading
                        ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                        : null,
                  ),
                  onTap: () => fetchActiveDrivers(),
                  items: activeDrivers.map<DropdownMenuItem<String>>((driver) {
                    return DropdownMenuItem<String>(
                      value: driver['id'].toString(),
                      child: Text("${driver['name']} (${driver['username']})"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDriverId = value;
                    });
                  },
                ),
              ],

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),

              // Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Fare: £$fares", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isDispatching ? null : () => Get.back(),
          child: const Text("CLOSE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        if (!isLoading && errorMessage == null)
          isAsapMode
              ? ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: isDispatching ? null : () => dispatchBooking(),
            child: isDispatching
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("DISPATCH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
              : ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Get.back();
              BotToast.showText(text: "Booking Accepted");
            },
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }
}

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
      theme: ThemeData(
        useMaterial3: false,
      ),
      initialRoute: _getInitialRoute(),
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

void disableInspect() {
  try {
    html.document.onContextMenu.listen((event) => event.preventDefault());
    html.document.onKeyDown.listen((event) {
      if (event.keyCode == 123) event.preventDefault();
      if (event.ctrlKey && event.shiftKey &&
          (event.keyCode == 73 || event.keyCode == 74 || event.keyCode == 67)) {
        event.preventDefault();
      }
      if (event.ctrlKey && event.keyCode == 85) event.preventDefault();
      if (event.metaKey && event.altKey &&
          (event.keyCode == 73 || event.keyCode == 74)) {
        event.preventDefault();
      }
    });
    print("Security: Inspect Element features disabled.");
  } catch (e) {
    print("Error disabling inspect: $e");
  }
}



// --- Stateful Custom Dialog with Dynamic Driver List ---
// class NewBookingAlert extends StatefulWidget {
//   final String bookingId;
//   final String bookingMode;
//
//   const NewBookingAlert({
//     super.key,
//     required this.bookingId,
//     required this.bookingMode,
//   });
//
//   @override
//   State<NewBookingAlert> createState() => _NewBookingAlertState();
// }
//
// class _NewBookingAlertState extends State<NewBookingAlert> {
//   bool isLoading = true;
//   bool isDriversLoading = false;
//   Map<String, dynamic>? booking;
//   String? errorMessage;
//
//   // Driver states
//   List<dynamic> activeDrivers = [];
//   String? selectedDriverId;
//
//   @override
//   void initState() {
//     super.initState();
//     getBookingDetails();
//     // Agar mode ASAP hai to initial level par bhi list fetch karwa dete hain
//     if (widget.bookingMode.toUpperCase() == 'ASAP') {
//       fetchActiveDrivers();
//     }
//   }
//
//   Future<void> getBookingDetails() async {
//     try {
//       final String apiUrl = "${Urls.baseUrl}bookings/getbyid/${widget.bookingId}";
//
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200) {
//         final decodedData = json.decode(response.body) as Map<String, dynamic>;
//         setState(() {
//           booking = decodedData['booking'];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = "Failed to load data (Status: ${response.statusCode})";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = "Error connecting to server";
//         isLoading = false;
//       });
//     }
//   }
//
//   // Real-time Drivers load karne ki API call
//   Future<void> fetchActiveDrivers() async {
//     setState(() {
//       isDriversLoading = true;
//     });
//     try {
//       final String driversApiUrl = "${Urls.baseUrl}drivers/login-busy";
//       final response = await http.get(
//         Uri.parse(driversApiUrl),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body) as Map<String, dynamic>;
//         setState(() {
//           // Khali login_drivers ki list filter out karni thi
//           activeDrivers = data['login_drivers'] ?? [];
//           isDriversLoading = false;
//         });
//       } else {
//         print("Drivers API error status code: ${response.statusCode}");
//         setState(() => isDriversLoading = false);
//       }
//     } catch (e) {
//       print("Exception while fetching drivers: $e");
//       setState(() => isDriversLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // API data extraction mapping
//     String referenceNumber = booking?['reference_number'] ?? "N/A";
//     String pickup = booking?['pickup'] ?? "Unknown Pickup";
//     String dropoff = booking?['dropoff'] ?? "Unknown Dropoff";
//     String journeyType = booking?['journey_type']?['journey_type'] ?? "N/A";
//     String pickupDate = booking?['pickup_date'] ?? "N/A";
//     String pickupTime = booking?['pickup_time'] ?? "N/A";
//     String fares = booking?['fares']?.toString() ?? "0.00";
//
//     // Dynamic mode conditions check
//     bool isAsapMode = widget.bookingMode.toUpperCase() == 'ASAP';
//
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       title: Row(
//         children: [
//           const Icon(Icons.local_taxi, color: Colors.blue, size: 28),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               "New APP Booking Alert ($referenceNumber)",
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//       content: SizedBox(
//         width: 450,
//         child: isLoading
//             ? const SizedBox(
//           height: 150,
//           child: Center(
//             child: CircularProgressIndicator(color: Colors.blue),
//           ),
//         )
//             : errorMessage != null
//             ? SizedBox(
//           height: 100,
//           child: Center(
//             child: Text(
//               errorMessage!,
//               style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//           ),
//         )
//             : SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: isAsapMode ? Colors.red.shade50 : Colors.blue.shade50,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Text(
//                       "Mode: ${widget.bookingMode}",
//                       style: TextStyle(
//                           color: isAsapMode ? Colors.red : Colors.blue,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.purple.shade50,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Text(
//                       "Journey: ${journeyType.toUpperCase()}",
//                       style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 12),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15),
//
//               // Date & Time Row
//               Row(
//                 children: [
//                   const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                   const SizedBox(width: 5),
//                   Text(
//                     "$pickupDate at $pickupTime",
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
//                   ),
//                 ],
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: Divider(),
//               ),
//
//               // Pickup Info
//               const Text("📍 PICKUP LOCATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
//               const SizedBox(height: 4),
//               Text(pickup, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
//               const SizedBox(height: 15),
//
//               // Dropoff Info
//               const Text("🏁 DROPOFF LOCATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
//               const SizedBox(height: 4),
//               Text(dropoff, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
//
//               // --- ASAP Dynamic Dropdown Widget Placement ---
//               if (isAsapMode) ...[
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8.0),
//                   child: Divider(),
//                 ),
//                 const Text(
//                     "🚖 SELECT LOGIN DRIVER",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)
//                 ),
//                 const SizedBox(height: 6),
//                 DropdownButtonFormField<String>(
//                   value: selectedDriverId,
//                   hint: Text(isDriversLoading ? "Refreshing drivers list..." : "Choose Active Driver"),
//                   isExpanded: true,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     suffixIcon: isDriversLoading
//                         ? const Padding(
//                       padding: EdgeInsets.all(12.0),
//                       child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
//                     )
//                         : null,
//                   ),
//                   // Tap Event: Dropdown open hotay waqt real-time data fetch karega
//                   onTap: () => fetchActiveDrivers(),
//                   items: activeDrivers.map<DropdownMenuItem<String>>((driver) {
//                     return DropdownMenuItem<String>(
//                       value: driver['id'].toString(),
//                       child: Text("${driver['name']} (${driver['username']})"),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedDriverId = value;
//                     });
//                   },
//                 ),
//               ],
//
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 child: Divider(),
//               ),
//
//               // Price Details
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Fare: £$fares", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Get.back(),
//           child: const Text("CLOSE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
//         ),
//         if (!isLoading && errorMessage == null)
//           isAsapMode
//               ? ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//             onPressed: () {
//               if (selectedDriverId == null) {
//                 BotToast.showText(text: "Please select a driver first!");
//                 return;
//               }
//               Get.back();
//               // Yahan aap accept aur dispatch dono handles trigger karwa sakte hain
//               BotToast.showText(text: "Booking #${widget.bookingId} Dispatched Successfully");
//             },
//             child: const Text("DISPATCH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           )
//               : ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//             onPressed: () {
//               Get.back();
//               BotToast.showText(text: "Booking Accepted");
//             },
//             child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           ),
//       ],
//     );
//   }
// }
// --- Stateful Custom Dialog with Dynamic Driver List & Dispatch API ---