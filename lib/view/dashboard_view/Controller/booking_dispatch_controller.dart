import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/networks/api.dart';
import '../../drivers_view/controller/driver_sin_bin_controller.dart';
import '../../drivers_view/driver/login_drivers/driver_login_logout_model.dart';
import '../models/dashboard_table_model.dart' hide Driver;
import 'dashboard_controller.dart';

class DispatchController extends GetxController {
  var drivers = <Driver>[].obs;
  var isFutureAssigning = false.obs;
  var isLoading = false.obs;
  var isAssigning = false.obs;

  // SinBin Controller ko initialize karein
  final DriverSinBinController sinBinController = Get.put(DriverSinBinController());

  @override
  void onInit() {
    super.onInit();
    // SinBin list fetch karein
    sinBinController.getDriverSinBin();
  }

  void getDispatchDrivers() async {
    try {
      isLoading(true);
      var response = await Api().get("drivers/session?session_status=logged_in", sendCompanyId: true);
      if (response.statusCode == 200) {
        var model = DriverLoginLogoutModel.fromJson(response.data);
        drivers.value = model.drivers ?? [];
      }
    } finally {
      isLoading(false);
    }
  }

  ///======================================
  assignFutureDriverToBooking(dynamic bookingId, dynamic driverId) async {
    if (bookingId == null || driverId == null) {
      BotToast.showText(text: 'Booking or Driver ID is missing');
      return;
    }
      isFutureAssigning(true);
      var formData = {
        "booking_id": bookingId.toString(),
        "driver_id": driverId,
      };
      print("Sending Data: $formData");
      var response = await Api().post(formData,
        "bookings/assign-future-booking",
        auth: true,
        sendCompanyId: true,
      );
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          BotToast.showText(text: response.data['message'] ?? 'Driver Assigned Successfully');
          if (Get.isRegistered<DashboardController>()) {
            DashboardController dashCtrl = Get.find<DashboardController>();
            dashCtrl.getDashboardTableData(tableId: dashCtrl.selectedTabId);
          }
          Get.back();
        } else {
          BotToast.showText(text: response.data['message'] ?? 'Failed to assign driver');
        }
      } else {
        BotToast.showText(text: response.data['message']);
        print("Error: ${response.data['message']}");
      }
    }






  assignDriverToBooking(dynamic bookingId, dynamic driverId, {bool isForce = false}) async {
    if (bookingId == null || driverId == null) {
      BotToast.showText(text: 'Booking or Driver ID is missing');
      return;
    }

    // 1. Check karein ki Driver ID SinBin List me exist karti hai ya nahi
    bool isDriverInSinBin = sinBinController.sinBinDriversList.any(
          (sinBinDriver) => sinBinDriver.id.toString() == driverId.toString(),
    );

    // Agar driver SinBin me hai aur force dispatch nahi hai, to alert dikhayen (API hit NAHI hogi)
    if (isDriverInSinBin && !isForce) {
      _showSinBinDialog(bookingId, driverId);
      return; // Code yahan ruk jayega
    }

    // 2. Agar SinBin me nahi hai YA Yes click ho chuka hai (isForce = true), tab API hit hogi:
    try {
      isAssigning(true);
      var formData = {
        "booking_id": bookingId.toString(),
        "driver_id": driverId.toString(),
        if (isForce) "force_dispatch": true,
      };
      print("Sending Data: $formData");

      var response = await Api().post(
        formData,
        "bookings/assign-driver",
        auth: true,
        sendCompanyId: true,
      );

      if (response.statusCode == 200) {
        var data = response.data;
        if (data['sin_bin'] == true && !isForce) {
          _showSinBinDialog(bookingId, driverId);
          return;
        }
        if (data['status'] == true) {
          BotToast.showText(text: data['message'] ?? 'Driver Assigned Successfully');
          Get.back();

          if (Get.isRegistered<DashboardController>()) {
            DashboardController dashCtrl = Get.find<DashboardController>();
            dashCtrl.getDashboardTableData(tableId: dashCtrl.selectedTabId);
          }
        } else {
          BotToast.showText(text: data['message'] ?? '');
        }
      } else {
        BotToast.showText(text: response.data['message'] ?? 'Failed to assign driver');
      }
    } catch (e) {
      print("Assign Driver Error: $e");
      BotToast.showText(text: "Something went wrong!");
    } finally {
      isAssigning(false);
    }
  }

// Alert Dialog Function
  void _showSinBinDialog(dynamic bookingId, dynamic driverId) {
    Get.defaultDialog(
      title: "Driver in Sin Bin",
      middleText: "Driver is in Sin Bin, do you still want to send the job?",
      textConfirm: "Yes",
      textCancel: "No",
      buttonColor: Colors.blue,
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      onConfirm: () {
        Get.back();
        assignDriverToBooking(bookingId, driverId, isForce: true);
      },
      onCancel: () {
        Get.back();
      },
    );
  }
  }
