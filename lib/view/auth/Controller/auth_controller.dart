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
      await addData();
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
        update();
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






  addData() async{

    List<String> allPermissions = [
      "create_user",
      "read_company_information",
      "update_company_information",
      "read_company_configuration",
      "update_company_configuration",
      "read_voip_settings",
      "create_template_type",
      "read_template_types",
      "read_template_type",
      "update_template_type",
      "delete_template_type",
      "create_template",
      "read_templates",
      "read_template",
      "update_template",
      "delete_template",
      "create_sms_template",
      "create_document_number",
      "read_document_number",
      "read_document_numbers",
      "update_document_number",
      "delete_document_number",
      "create_feedback",
      "read_feedback",
      "read_feedbacks",
      "update_feedback",
      "delete_feedback",
      "create_lost_property",
      "read_lost_property",
      "read_lost_properties",
      "update_lost_property",
      "delete_lost_property",
      "create_subsidiary",
      "read_subsidiaries",
      "read_subsidiary",
      "update_subsidiary",
      "delete_subsidiary",
      "read_role",
      "read_roles",
      "update_role",
      "create_employee",
      "read_employee",
      "read_employees",
      "update_employee",
      "delete_employee",
      "create_vehicle_type",
      "read_vehicle_types",
      "read_vehicle_type",
      "update_vehicle_type",
      "delete_vehicle_type",
      "create_company_vehicle",
      "read_company_vehicles",
      "read_company_vehicle",
      "update_company_vehicle",
      "delete_company_vehicle",
      "create_vehicle",
      "read_vehicles",
      "read_vehicle",
      "update_vehicle",
      "delete_vehicle",
      "create_end_vehicle",
      "create_customer",
      "read_customers",
      "read_customer",
      "update_customer",
      "delete_customer",
      "create_complaint",
      "read_complaint",
      "read_complaints",
      "update_complaint",
      "delete_complaint",
      "create_driver",
      "read_drivers",
      "read_driver",
      "update_driver",
      "update_driver_zone",
      "delete_driver",
      "create_end_driver",
      "create_driver_shift",
      "read_driver_shift",
      "read_driver_shifts",
      "update_driver_shift",
      "delete_driver_shift",
      "create_driver_availability",
      "read_driver_availability",
      "read_driver_availabilities",
      "update_driver_availability",
      "delete_driver_availability",
      "create_driver_booking",
      "read_driver_booking",
      "read_driver_bookings",
      "update_driver_booking",
      "delete_driver_booking",
      "create_driver_commission",
      "read_driver_commission",
      "read_driver_commissions",
      "update_driver_commission",
      "delete_driver_commission",
      "create_driver_commission_account",
      "read_driver_commission_account",
      "read_driver_commission_accounts",
      "update_driver_commission_account",
      "delete_driver_commission_account",
      "create_driver_commission_lineitem",
      "read_driver_commission_lineitem",
      "read_driver_commission_lineitems",
      "update_driver_commission_lineitem",
      "delete_driver_commission_lineitem",
      "create_driver_shift_history",
      "read_driver_shift_history",
      "read_driver_shift_histories",
      "update_driver_shift_history",
      "delete_driver_shift_history",
      "create_account",
      "read_accounts",
      "read_account",
      "update_account",
      "delete_account",
      "create_message",
      "read_message",
      "read_messages",
      "update_message",
      "delete_message",
      "create_notification",
      "read_notification",
      "read_notifications",
      "update_notification",
      "delete_notification",
      "create_audit",
      "read_audit",
      "read_audits",
      "update_audit",
      "delete_audit",
      "read_app_feature",
      "read_app_features",
      "update_app_feature",
      "create_escort",
      "update_escort",
      "delete_escort",
      "read_escort",
      "read_escorts",
      "update_app_version",
      "create_employee_shift_history",
      "read_employee_shift_history",
      "update_employee_shift_history",
      "create_account_web_login",
      "read_account_web_login",
      "update_account_web_login",
      "delete_account_web_login",
      "create_account_order_number",
      "read_account_order_number",
      "update_account_order_number",
      "delete_account_order_number",
      "create_account_department",
      "read_account_department",
      "update_account_department",
      "delete_account_department",
      "create_account_contact",
      "read_account_contact",
      "update_account_contact",
      "delete_account_contact",
      "create_account_company_address",
      "read_account_company_address",
      "update_account_company_address",
      "delete_account_company_address",
      "create_fare_configuration",
      "read_fare_configuration",
      "update_fare_configuration",
      "delete_fare_configuration",
      "create_fixed_fare",
      "read_fixed_fare",
      "update_fixed_fare",
      "delete_fixed_fare",
      "create_fare_by_vehicle",
      "read_fare_by_vehicle",
      "update_fare_by_vehicle",
      "delete_fare_by_vehicle",
      "create_fare_configuration_mileage",
      "read_fare_configuration_mileage",
      "update_fare_configuration_mileage",
      "delete_fare_configuration_mileage",
      "create_location_type",
      "read_location_type",
      "update_location_type",
      "delete_location_type",
      "create_location",
      "read_location",
      "update_location",
      "delete_location",
      "create_localization_detail",
      "read_localization_detail",
      "update_localization_detail",
      "delete_localization_detail",
      "create_main_data",
      "read_main_data",
      "update_main_data",
      "delete_main_data",
      "create_detail_data",
      "read_detail_data",
      "update_detail_data",
      "delete_detail_data",
      "create_zone",
      "read_zone",
      "update_zone",
      "delete_zone",
      "create_journey_type",
      "read_journey_type",
      "update_journey_type",
      "delete_journey_type",
      "create_payment_type",
      "read_payment_type",
      "update_payment_type",
      "delete_payment_type",
      "create_booking",
      "read_booking",
      "update_booking",
      "delete_booking",
      "create_booking_route",
      "read_booking_route",
      "update_booking_route",
      "delete_booking_route",
      "create_trash_booking",
      "read_trash_booking",
      "update_trash_booking",
      "delete_trash_booking",
      "create_booking_audit",
      "read_booking_audit",
      "update_booking_audit",
      "delete_booking_audit",
      "create_customer_invoice",
      "read_customer_invoice",
      "update_customer_invoice",
      "delete_customer_invoice",
      "create_customer_invoice_lineitem",
      "read_customer_invoice_lineitem",
      "update_customer_invoice_lineitem",
      "delete_customer_invoice_lineitem",
      "create_account_invoice",
      "read_account_invoice",
      "update_account_invoice",
      "delete_account_invoice",
      "create_account_invoice_lineitem",
      "read_account_invoice_lineitem",
      "update_account_invoice_lineitem",
      "delete_account_invoice_lineitem",
    ];

    final box = GetStorage();

    box.write('all_permissions', allPermissions);

    List permissions = box.read('all_permissions') ?? [];

    print(permissions);

  }





}
