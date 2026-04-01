import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import '../../../alert/cli_extention_alert.dart';
import '../../administration/model/user_model.dart';

class AuthController extends GetxController {

  final sp = GetStorage(); // Ensure GetStorage is initialized
  RxString currentExtension = "".obs;
  // Refresh par data lane wala function
  checkUserStatus() async {
    String? token = sp.read('token');

    if (token != null) {
      // Yahan hum wahi login wali API ya koi profile API hit kar sakte hain
      // Agar backend pe alag profile API nahi hai, toh local storage best hai
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

  postLoginDetails() async {
    PostAuthLoader(true);
    var formData = {
      "username": usernameController.text,
      "password": passwordController.text,
    };
    var response = await Api().post(formData, 'employees/login', auth: false);
    if (response.statusCode == 200) {
      var employeeData = response.data['employee'];
      var token = response.data['token'];
      sp.write('token', token);
      sp.write('userData', employeeData);
      Employee.selectedEmployee = Employee.fromJson(employeeData);
      List extensions = employeeData['employee_extensions'] ?? [];
      if (extensions.isEmpty) {
        Get.offAllNamed(Routes.myHomePage);
        Future.delayed(const Duration(milliseconds: 800), () {
          ExtensionAlert.show();
        });
      } else {
        String latestExtension = extensions.last['extension_number'].toString();
        Employee.selectedEmployee!.extensionNumber = latestExtension;
        print("Extension Found: $latestExtension");
        Get.offAllNamed(Routes.myHomePage);
      }
    } else {
      BotToast.showText(text: "Login failed!");
    }
    PostAuthLoader(false);
  }

  Future<void> logout() async {
    try {
      var rawId = Employee.selectedEmployee?.id;

      if (rawId != null) {
        String empId = rawId.toString();

        // POST request with empty map as formData
        // Note: Maine 'auth: false' rakha hai kyunke aapke method mein
        // auth: false hone par hi Authorization header add ho raha hai.
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
      // Local cleanup hamesha hona chahiye
      sp.remove('token');
      sp.remove('userData');

      Employee.selectedEmployee = null;
      currentExtension.value = "---";

      Get.offAllNamed(Routes.loginScreen);
    }
  }










}
