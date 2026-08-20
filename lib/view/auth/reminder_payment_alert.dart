import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../component/networks/api.dart';
import '../../routes/app_pages.dart'; // Apni Api class ka correct path yahan dein

class SubscriptionSocketService {
  static WebSocketChannel? _channel;

  /// WebSocket connect karne aur listen karne ka main function
  static void initSocket() {
    try {
      final String companyId = Api.singleton.globalCompanyId;
      final String baseUrl = socketUrl; // Api.dart se `socketUrl` use ho raha hai

      // Construct Full Socket URL
      final String fullUrl = "ws://158.220.92.206:5000/websocket/company-subscription?company_id=3";

      print("Connecting to WebSocket: $fullUrl");

      _channel = IOWebSocketChannel.connect(Uri.parse(fullUrl));

      _channel!.stream.listen(
            (message) {
          print("Socket Message Received: $message");
          _handleSocketMessage(message);
        },
        onError: (error) {
          print("WebSocket Error: $error");
        },
        onDone: () {
          print("WebSocket Connection Closed");
        },
      );
    } catch (e) {
      print("WebSocket Connection Exception: $e");
    }
  }

  /// Event handle karne ka function
  static void _handleSocketMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final String eventName = data['event'] ?? '';
      final String msgText = data['message'] ?? '';

      switch (eventName) {
        case 'SUBSCRIPTION_PRE_EXPIRY_WARNING':
          _showWarningDialog("Subscription Warning", msgText);
          break;

        case 'SUBSCRIPTION_GRACE_DAYS_LEFT':
          _showWarningDialog("Grace Period Notice", msgText);
          break;

        case 'FORCE_LOGOUT':
          _showForceLogoutDialog("Subscription Expired", msgText);
          break;

        default:
          print("Unhandled event: $eventName");
      }
    } catch (e) {
      print("Error parsing socket JSON: $e");
    }
  }

  /// 1 & 2: Warning and Grace Days Dialog (Cancel / OK normal dialog)
  static void _showWarningDialog(String title, String message) {
    if (getx.Get.context != null) {
      showDialog(
        context: getx.Get.context!,
        builder: (context) => AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  /// 3: Force Logout Dialog (Blocking Dialog with single OK button)
  static void _showForceLogoutDialog(String title, String message) {
    if (getx.Get.context != null) {
      showDialog(
        context: getx.Get.context!,
        barrierDismissible: false, // User screen ke bahar click karke close na kar sake
        builder: (context) => WillPopScope(
          onWillPop: () async => false, // Back button disable karne ke liye
          child: AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            content: Text(message),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _performLogout(); // OK click hone par logout call karen
                },
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Storage clear karne aur Login screen par redirect karne ka logic
  static void _performLogout() {
    // 1. Socket connection close karein
    closeSocket();

    // 2. Clear storage (GetStorage)
    Api.singleton.sp.erase();

    // 3. Clear session count if used
    count = 0;

    // 4. Login screen par navigate karein
    getx.Get.offAllNamed(Routes.loginScreen);
  }

  /// Socket manually disconnect karne ke liye
  static void closeSocket() {
    _channel?.sink.close();
    _channel = null;
  }
}