import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:get/get.dart';
import '../Model/fob_alert_model.dart';
import '../view/customer/model/restricDriver.dart';

class FobController extends GetxController {
  /// FOB ALERT
  GetFobModel? getFobModel;
  var drivers = <Driver>[].obs;
  var isLoading = false.obs;
  var assignDriver = false.obs;

  getDispatchFob() async {
    try {
      isLoading(true);
      var response = await Api().get("drivers/fob-drivers");
      if (response.statusCode == 200) {
        getFobModel = GetFobModel.fromJson(response.data);
        drivers.value = getFobModel?.drivers ?? [];
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fobBooking(dynamic bookingId, dynamic driverId) async {
    if (bookingId == null || driverId == null) {
      BotToast.showText(text: 'Booking or Driver ID is missing');
      return;
    }
    try {
      assignDriver(true);
      var formData = {
        "booking_id": bookingId.toString(),
        "driver_id": driverId,
      };
      var response =
          await Api().post(formData, "bookings/fob-driver", auth: true);
      if (response.statusCode == 200) {
        BotToast.showText(text: 'Driver Assigned Successfully');
        Get.back();
      } else {
        BotToast.showText(text: response.data['message']);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      assignDriver(false);
    }
  }

  /// COMPLETE ALERT

  RestricDriverModel? allDriverData;
  DriverObject? selectDriverObject;
  bool isLoadingDriver = false;
  getAllDrivers() async {
    isLoadingDriver = true;
    update();
    try {
      var response = await Api().get("drivers/get");
      if (response.statusCode == 200) {
        allDriverData = RestricDriverModel.fromJson(response.data);

        if (allDriverData?.drivers != null && allDriverData!.drivers!.isNotEmpty) {
          selectDriverObject = allDriverData!.drivers![0];
        }
      }
    } catch (e) {
      print("Error fetching drivers: $e");
    } finally {
      isLoadingDriver = false;
      update();
    }
  }

  bool isCompleteStatus = false;
  postCompleteBooking(dynamic bookingId) async {
    isCompleteStatus = true;
    update();

    try {
      var formData = {
        "driver_id": selectDriverObject?.id,
      };
      var response =
          await Api().post(formData, "bookings/completed-booking/$bookingId", auth: true);
      if (response.statusCode == 200) {
        BotToast.showText(text: "BOOKING COMPLETED SUCCESSFULLY");
      } else {
        BotToast.showText(text: "FAILED TO COMPLETE BOOKING");
        print("Error: ${response.statusCode} - ${response.data}");
      }
    } catch (e) {
      print("Error updating booking status: $e");
    } finally {
      isCompleteStatus = false;
      update();
    }
  }

  /// CANCEL ALERT
  bool isCancelLoading = false;

  Future<void> postCancelBooking(dynamic bookingId) async {
    isCancelLoading = true;
    update();

    try{
      var formData = {
        "booking_status_id": 12,
      };

      var response = await Api().post(formData,
          "bookings/status/$bookingId",
        auth: true,
      );
      if (response.statusCode == 200) {
        BotToast.showText(text: "BOOKING CANCELLED SUCCESSFULLY");
        Get.back();
      } else {
        BotToast.showText(text: "FAILED TO CANCEL BOOKING");
      }
    } catch (e) {
      print("Error cancelling booking: $e");
      BotToast.showText(text: "SOMETHING WENT WRONG");
    } finally {
      isCancelLoading = false;
      update();
    }
  }

  /// EDIT FARE
  bool isFareLoading = false;

  updateBookingFare(dynamic bookingId, String fare) async {
    if (fare.isEmpty) {
      BotToast.showText(text: "PLEASE ENTER FARE AMOUNT");
      return;
    }
    isFareLoading = true;
    update();

    try{
      var formData = {
        "total_charges": fare,
      };
      var response = await Api().post(
          formData,
        "bookings/dashboard-fares/$bookingId",
        auth: true,
      );
      if (response.statusCode == 200) {
        BotToast.showText(text: "FARE UPDATED SUCCESSFULLY");
        Get.back();
      } else {
        BotToast.showText(text: "FAILED TO UPDATE FARE");
      }
    } catch (e) {
      print("Error updating fare: $e");
      BotToast.showText(text: "SOMETHING WENT WRONG");
    } finally {
      isFareLoading = false;
      update();
    }
  }
}
