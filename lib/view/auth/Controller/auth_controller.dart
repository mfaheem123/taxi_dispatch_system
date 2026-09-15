import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import 'package:get_storage/get_storage.dart';
import '../../../alert/cli_extention_alert.dart';
import '../../../alert/driver_login_alert.dart';
import '../../administration/model/user_model.dart';

import '../reminder_payment_alert.dart';

// SOCKET SERVICE IMPORT

class AuthController extends GetxController {
  bool isExpiryAlertShown = false; // Add this line
  final sp = GetStorage();
  RxString currentExtension = "".obs;
  checkUserStatus() async {
    String? token = sp.read('token');
    if (token != null) {
      var storedUser = sp.read('userData');
      if (storedUser != null) {
        Employee.selectedEmployee = Employee.fromJson(storedUser);
        update();

        SubscriptionSocketService.initSocket();
      }
    }
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool PostAuthLoader = false.obs;

  postLoginDetails() async {
    PostAuthLoader(true);
    try {
      //  FCM Token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $fcmToken");

      var formData = {
        "username": usernameController.text,
        "password": passwordController.text,
        "web_device_id": fcmToken ?? "",
      };

      var response = await Api()
          .post(formData, 'employees/login', sendCompanyId: true, auth: false, isProgressShow: true);

      if (response.statusCode == 200) {
        var employeeData = response.data['employee'];
        var token = response.data['token'];
        usernameController.clear();
        passwordController.clear();
        sp.write('userRole', employeeData['role']['name']);
        sp.write('token', token);
        sp.write('userData', employeeData);

        // --- COMPANY ID SAVE & SOCKET CONNECT ---
        if (employeeData['company_id'] != null) {
          sp.write('company_id', employeeData['company_id'].toString());
        }
        SubscriptionSocketService.initSocket();

        await getRole(id: employeeData['role_id']);
        Employee.selectedEmployee = Employee.fromJson(employeeData);

        List extensions = employeeData['employee_extensions'] ?? [];

        if (extensions.isEmpty) {
          Get.offAllNamed(Routes.myHomePage);
          PostAuthLoader(false);
          Future.delayed(const Duration(milliseconds: 800), () {
            ExtensionAlert.show();
          });
        } else {
          String latestExtension =
          extensions.last['extension_number'].toString();
          Employee.selectedEmployee!.extensionNumber = latestExtension;
          print("Extension Found: $latestExtension");
          Get.offAllNamed(Routes.myHomePage);
          PostAuthLoader(false);
          update();

        }
        // Naya Code:
        Future.delayed(const Duration(milliseconds: 600), () {
          checkExpiryDocumentsOnLogin();
        });
      } else {
        PostAuthLoader(false);
        // Error handling behtar karne ke liye response message bhi dikha sakte hain
        BotToast.showText(text: response.data['message'] ?? "Login failed!");
      }
    } catch (e) {
      PostAuthLoader(false);
      debugPrint("Unknown error: $e");
    }

  }
  /// get role
  getRole({id}) async{
    var response = await Api().get('authorizations/role/$id');
    if(response.statusCode == 200){
      Map<String, dynamic> permissionsMap = response.data['permissions'];

      List<String> permissionList = permissionsMap.entries
          .where((entry) => entry.value == true).map((entry) => entry.key).toList();
      sp.write('all_permissions', permissionList);
      List permissions = sp.read('all_permissions') ?? [];
      print(permissions);
      update();
    }
  }

  Future<void> logout() async {
    try {
      var rawId = Employee.selectedEmployee?.id;
      if (rawId != null) {
        String empId = rawId.toString();
        var response = await Api().post(
            {},
            'employees/logout/$empId',
            auth: false
        );
        if (response.statusCode == 200) {
          BotToast.showText(text: "Logged out successfully");
        }
      }
    } catch (e) {
      print("Logout API Error: $e");
    } finally {
      // --- SOCKET CLOSE ---
      SubscriptionSocketService.closeSocket();

      // The dashboard's own sockets and pollers. They live on the
      // DashboardController, which is put with Get.put and therefore survives
      // Get.offAllNamed below — without this its CLI / driver-login /
      // driver-busy sockets and its 5-second table poll keep running against
      // a token that is about to be erased.
      //
      // Guarded by isRegistered: logging out from the login screen, or before
      // the dashboard has ever been opened, means there is nothing to close.
      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().disposeSockets();
      }

      sp.remove('token');
      sp.remove('userData');
      sp.remove('company_id');
      Employee.selectedEmployee = null;
      currentExtension.value = "---";
      isExpiryAlertShown = false;
      Get.offAllNamed(Routes.loginScreen);
    }
  }



  DriverExpiryResponse? driverExpiryResponse;

  checkExpiryDocumentsOnLogin() async {
    if (isExpiryAlertShown) return;
    var response = await Api().get("drivers/driver-expiry-documents",
      sendCompanyId: true,
    );
    if (response.statusCode == 200 ) {
      final expiryData = DriverExpiryResponse.fromJson(response.data);
      print("${response.data} driver API Response API1111111111111111111111111111111111111111111111111111");
      // Condition: Agar Drivers list me items hon to alert show karo
      if (expiryData.status && expiryData.drivers.isNotEmpty) {
        // Safe check: Ensure context exists before showing alert
        if (Get.context != null) {
          DriverExpiryDocumentsAlert.show(Get.context!, expiryData.drivers);
        }
        // DriverExpiryDocumentsAlert.show(Get.context!, expiryData.drivers);
      }
      print("${response.data} driver API Response 22222222222222222222222222222222222222222222");
    }else{
      print("Expiry API Error: $response");

    }
  }


}
