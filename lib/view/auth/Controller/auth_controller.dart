import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import '../../../alert/cli_extention_alert.dart';
import '../../administration/model/user_model.dart';

class AuthController extends GetxController {

  final sp = GetStorage();
  RxString currentExtension = "".obs;
  checkUserStatus() async {
    String? token = sp.read('token');
    if (token != null) {
      var storedUser = sp.read('userData');
      if (storedUser != null) {
        Employee.selectedEmployee = Employee.fromJson(storedUser);
        update();
      }
    }
  }




  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool PostAuthLoader = false.obs;

  // postLoginDetails() async {
  //   PostAuthLoader(true);
  //   var formData = {
  //     "username": usernameController.text,
  //     "password": passwordController.text,
  //     "web_device_id": passwordController.text,
  //
  //   };
  //   var response = await Api().post(formData, 'employees/login', auth: false);
  //   if (response.statusCode == 200) {
  //     var employeeData = response.data['employee'];
  //     var token = response.data['token'];
  //     sp.write('userRole', employeeData['role']['name']);
  //     sp.write('token', token);
  //     sp.write('userData', employeeData);
  //     await getRole(id: employeeData['role_id']);
  //     Employee.selectedEmployee = Employee.fromJson(employeeData);
  //     List extensions = employeeData['employee_extensions'] ?? [];
  //     // await addData();
  //     if (extensions.isEmpty) {
  //       Get.offAllNamed(Routes.myHomePage);
  //       Future.delayed(const Duration(milliseconds: 800), () {
  //         ExtensionAlert.show();
  //       });
  //     } else {
  //       String latestExtension = extensions.last['extension_number'].toString();
  //       Employee.selectedEmployee!.extensionNumber = latestExtension;
  //       print("Extension Found: $latestExtension");
  //       Get.offAllNamed(Routes.myHomePage);
  //       update();
  //     }
  //   } else {
  //     BotToast.showText(text: "Login failed!");
  //   }
  //   PostAuthLoader(false);
  // }
  postLoginDetails() async {
    PostAuthLoader(true);

    // 1. FCM Token fetch karein
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");

    var formData = {
      "username": usernameController.text,
      "password": passwordController.text,
      // 2. web_device_id mein fcmToken pass karein
      "web_device_id": fcmToken ?? "",
    };

    var response = await Api().post(formData, 'employees/login',sendCompanyId: true, auth: false);

    if (response.statusCode == 200) {
      var employeeData = response.data['employee'];
      var token = response.data['token'];
      usernameController.clear();
      passwordController.clear();
      sp.write('userRole', employeeData['role']['name']);
      sp.write('token', token);
      sp.write('userData', employeeData);

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
        String latestExtension = extensions.last['extension_number'].toString();
        Employee.selectedEmployee!.extensionNumber = latestExtension;
        print("Extension Found: $latestExtension");
        Get.offAllNamed(Routes.myHomePage);
        PostAuthLoader(false);
        update();
      }
    } else {
      PostAuthLoader(false);
      // Error handling behtar karne ke liye response message bhi dikha sakte hain
      BotToast.showText(text: response.data['message'] ?? "Login failed!");
    }
    PostAuthLoader(false);
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
      sp.remove('token');
      sp.remove('userData');
      Employee.selectedEmployee = null;
      currentExtension.value = "---";
      Get.offAllNamed(Routes.loginScreen);
    }
  }

}
