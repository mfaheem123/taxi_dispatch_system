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
      final String baseUrl = socketUrl;
      final String fullUrl = "$baseUrl/company-subscription?company_id=$companyId";

      print("Connecting to WebSocket: $fullUrl");

      _channel = WebSocketChannel.connect(Uri.parse(fullUrl));

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

  ///  (Cancel / OK )
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

  /// 3: Force Logout
  static void _showForceLogoutDialog(String title, String message) {
    if (getx.Get.context != null) {
      showDialog(
        context: getx.Get.context!,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
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

  /// Storage clear
  static void _performLogout() {
    // 1. Socket connection close karein
    closeSocket();

    // 2. Clear storage
    Api.singleton.sp.erase();

    // 3. Clear session count if used
    count = 0;

    // 4. Login screen
    getx.Get.offAllNamed(Routes.loginScreen);
  }

  /// Socket manually disconnect
  static void closeSocket() {
    _channel?.sink.close();
    _channel = null;
  }
}