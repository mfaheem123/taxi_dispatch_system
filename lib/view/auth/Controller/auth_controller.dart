import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../alert/cli_extention_alert.dart';
import '../../administration/model/user_model.dart';

class AuthController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool PostAuthLoader = false.obs;
// AuthController.dart
  // AuthController.dart

  postLoginDetails() async {
    PostAuthLoader(true);
    var formData = {
      "username": usernameController.text,
      "password": passwordController.text,
    };
    var response = await Api().post(formData, 'employees/login', auth: false);
    if (response.statusCode == 200) {
      var employeeData = response.data['employee'];
      Employee.selectedEmployee = Employee.fromJson(employeeData);
      List extensions = employeeData['employee_extensions'] ?? [];
      Get.offAllNamed(Routes.myHomePage);
      if (extensions.isEmpty) {
        Future.delayed(const Duration(milliseconds: 800), () {
          ExtensionAlert.show();
        });
      } else {
        String latestExtension = extensions.last['extension_number'].toString();
        Employee.selectedEmployee!.extensionNumber = latestExtension;
        print("Latest Extension Found: $latestExtension");
      }
    } else {
      BotToast.showText(text: "Login failed!");
    }
    PostAuthLoader(false);
  }
}
