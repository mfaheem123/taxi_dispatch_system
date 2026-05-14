import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/networks/api.dart';
import '../../customer/model/restricDriver.dart';
import '../driver_reports_view/models/list_driver_logs_model.dart';
import '../driver_reports_view/models/list_driver_report_login_model.dart';

class ReportController extends GetxController {

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver login functionality

  /// drivers get

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
      }
    } catch (e) {
      print("Error fetching drivers: $e");
    } finally {
      isLoadingDriver = false;
      update();
    }
  }
  /// DRIVER LOGIN LIST
  final loginStartTimeController = TextEditingController();
  final loginEndTimeController = TextEditingController();

  DriverLoginReportListModel? driverLoginReportListModel;
  bool isLoadingShift = false;

  getDriverShiftHistory() async {
    if(selectDriverObject == null) {
      BotToast.showText(text: "PLEASE SELECT A DRIVER");
      return;
    }
    isLoadingShift = true;
    update();

    try{
      var response = await Api().get("driver_shift_history/login",
        queryParameters: {
        "driver_id": selectDriverObject?.id.toString(),
        "from_date": fromDate,
        // "to_date": toDate,
        // "from_time": loginStartTimeController.text,
        // "to_time": loginEndTimeController.text,
        }
      );
      if (response.statusCode == 200) {
        driverLoginReportListModel = DriverLoginReportListModel.fromJson(response.data);
        print("Shift History Data: ${response.data}");
      }
    } catch (e) {
      print("Error fetching shift history: $e");
    } finally {
      isLoadingShift = false;
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver login functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver logs functionality

  // DriverLogsReportListModel? driverLogsData;
  // bool isLoadingLogs = false;
  //
  // getDriverLogs() async {
  //   if(selectDriverObject == null) {
  //     BotToast.showText(text: "PLEASE SELECT A DRIVER");
  //     return;
  //   }
  //   isLoadingLogs = true;
  //   update();
  //
  //   try{
  //     var response = await Api().get("bookings/driver-logs",
  //       queryParameters: {
  //       "driver_id": selectDriverObject?.id.toString(),
  //       "from_date": fromDate,
  //       "to_date": toDate,
  //       }
  //     );
  //   }
  // }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver logs functionality


  var selectedDriver = "Select Driver".obs;
  var fromDate = Rxn<DateTime>();
  var toDate = Rxn<DateTime>();
  var fromTime = Rxn<TimeOfDay>();
  var toTime = Rxn<TimeOfDay>();

  var selectedRowIndex = 0.obs;

  var filteredRows = <Map<String, dynamic>>[].obs;

  void setSelectedDriver(String driver) {
    selectedDriver.value = driver;
    update();
  }
  final logStartTimeController = TextEditingController();
  final logEndTimeController = TextEditingController();

  void applyFilters() {
    if (selectedDriver.value != "Select Driver") {
      filteredRows.add({
        "driver": selectedDriver.value,
        "bookings": 5,
        "loginDate": "11-09-2025",
        "loginTime": "09:08:00",
        "logoutDate": "11-09-2025",
        "logoutTime": "21:43:00",
      });
    }

    filteredRows.add({
      "driver": "Ali",
      "bookings": 3,
      "loginDate": "10-09-2025",
      "loginTime": "10:15:00",
      "logoutDate": "10-09-2025",
      "logoutTime": "18:45:00",
    });

    selectedDriver.value = "Select Driver";
    fromDate.value = null;
    toDate.value = null;
    fromTime.value = null;
    toTime.value = null;

    update();
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report feedback functionality

  String? selectDriver;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report feedback functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report booking functionality

  final bookingStartTimeController = TextEditingController();
  final bookingEndTimeController = TextEditingController();
  // Controller ke andar
  var totalBookings = 0.obs;
  var totalEarnings = 0.0.obs;
  var totalAccountEarnings = 0.0.obs;
  RxBool isFiltered = false.obs;

  int selectedValue = 0; // 👈 groupValue
  RxBool ptValue = false.obs;
  RxBool cashValue = false.obs;
  RxBool accountValue = false.obs;
  RxBool creditCardValue = false.obs;
  RxBool creditCardPaidValue = false.obs;

  ///focusNode value of checkBox

  final FocusNode ptNode = FocusNode();
  final FocusNode cashNode = FocusNode();
  final FocusNode accountNode = FocusNode();
  final FocusNode creditCardPaidNode = FocusNode();
  final FocusNode creditCardNode = FocusNode();

  /// text editing controller
  final customerController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final pickUpController = TextEditingController();
  final dropOffController = TextEditingController();
  final orderNumberController = TextEditingController();
  final bookedByController = TextEditingController();

  /// booking in reports
  String? selectBookingDriver;
  String? selectEmployee;
  String? selectSubsidiary;
  String? selectRefNumber;
  String? selectAscending;
  String? selectAccount;
  String? selectDepartment;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report booking functionality
}
