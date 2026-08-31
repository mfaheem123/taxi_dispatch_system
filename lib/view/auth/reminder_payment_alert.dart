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


  ///  Warning Dialog
  static void _showWarningDialog(String title, String message) {
    if (getx.Get.context != null) {
      showDialog(
        context: getx.Get.context!,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400), // Dialog size Control
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.warning_rounded, size: 40, color: Colors.red.shade800),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.black, height: 1.4),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  ///   Force Logout Dialog
  static void _showForceLogoutDialog(String title, String message) {
    if (getx.Get.context != null) {
      showDialog(
        context: getx.Get.context!,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false, // Prevents back button dismiss
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.logout_rounded, size: 40, color: Colors.red.shade600),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Colors.grey.shade700, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _performLogout();
                      },
                      child: const Text("Log Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
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