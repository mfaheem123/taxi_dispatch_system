import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../administration/model/user_model.dart';

class AuthController extends GetxController {
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
      Employee.selectedEmployee = Employee.fromJson(employeeData);
      Get.toNamed(Routes.myHomePage);
    } else {
      print("Login Failed");
    }
    PostAuthLoader(false);
  }
}
