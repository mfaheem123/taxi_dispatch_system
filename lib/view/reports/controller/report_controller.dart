import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/networks/api.dart';
import '../../customer/model/restricDriver.dart';
import '../driver_reports_view/models/earning_and_info_model.dart';
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
  var fromDate = Rxn<DateTime>(DateTime(DateTime.now().year, DateTime.now().month, 1));
  var toDate = Rxn<DateTime>(DateTime.now());
  final logStartTimeController = TextEditingController();
  final logEndTimeController = TextEditingController();

  DriverLogsReportListModel? driverLogsData;
  bool isLoadingLogs = false;

  final refSearch = TextEditingController();
  final vehicleSearch = TextEditingController();
  final pickupSearch = TextEditingController();
  final dropoffSearch = TextEditingController();
  final faresSearch = TextEditingController();

  getDriverLogs() async {
    if(selectDriverObject == null) {
      BotToast.showText(text: "PLEASE SELECT A DRIVER");
      return;
    }
    isLoadingLogs = true;
    update();

    try{
      String formattedFromDate = fromDate.value != null
          ? DateFormat('yyyy-MM-dd').format(fromDate.value!)
          : "";

      String formattedToDate = toDate.value != null
          ? DateFormat('yyyy-MM-dd').format(toDate.value!)
          : "";
      var response = await Api().get("bookings/driver-logs",
        queryParameters: {
        "driver_id": selectDriverObject?.id.toString(),
        "from_date": formattedFromDate,
        "to_date": formattedToDate,
        "from_time": logStartTimeController.text,
        "to_time": logEndTimeController.text,

          "ref": refSearch.text,
          "vehicle": vehicleSearch.text,
          "pickup": pickupSearch.text,
          "dropoff": dropoffSearch.text,
          "fares": faresSearch.text,
        }
      );
      if (response.statusCode == 200) {
        driverLogsData = DriverLogsReportListModel.fromJson(response.data);
        // print("Driver Logs Data Fetched: ${driverLogsData?.count}");
        print("Driver Logs Data: ${response.data}");
      }
    } catch (e) {
      debugPrint("Error fetching driver logs: $e");
    } finally {
      isLoadingLogs = false;
      update();
    }
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver logs functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver earning and info functionality

  List<DriverObject> filteredDriverList = [];
  String selectedStatus = "all";
  getFilteredDrivers({String status = "all"}) async {
    isLoadingDriver = true;
    selectedStatus = status;
    selectDriverObject = null;
    update();

    try{
      // String url = "drivers/get";
      // if (status == "active") {
      //   url = "drivers/get?active=true";
      // } else if (status == "inactive"){
      //   url = "drivers/get?active=false";
      // }
      // var response = await Api().get(url);
      var response = await Api().get(
        "drivers/get",
        queryParameters: {
          if (status == "active") "active": "true",
          if (status == "inactive") "active": "false",
        },
      );
      if (response.statusCode == 200) {
        var data = RestricDriverModel.fromJson(response.data);
        filteredDriverList = data.drivers ?? [];
      }
    } catch (e) {
      print("Error fetching filtered drivers: $e");
    } finally {
      isLoadingDriver = false;
      update();
    }
  }

  String selectedDriverType = "all";

  EarningInfoListModel? earningInfoListModel;
  bool isLoadingEarning = false;

  getAllDriverEarnings() async {
    isLoadingEarning = true;
    update();

    try{
        String formattedFromDate = fromDate.value != null
            ? DateFormat('yyyy-MM-dd').format(fromDate.value!)
            : "";

        String formattedToDate = toDate.value != null
            ? DateFormat('yyyy-MM-dd').format(toDate.value!)
            : "";

    var response = await Api().get("bookings/booking-driver-statistics",
      queryParameters: {
        "from_date": formattedFromDate,
        "to_date": formattedToDate,
        "driver_type": selectedDriverType,
        if (selectDriverObject != null) "driver_id": selectDriverObject?.id.toString(),
      },
    );
    if (response.statusCode == 200) {
      earningInfoListModel = EarningInfoListModel.fromJson(response.data);
      print("Driver Earning Data: ${response.data}");
    }
  } catch (e) {
      print("Error: $e");
    } finally {
      isLoadingEarning = false;
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver earning and info functionality


  var selectedDriver = "Select Driver".obs;
  // var fromDate = Rxn<DateTime>();
  // var toDate = Rxn<DateTime>();
  var fromTime = Rxn<TimeOfDay>();
  var toTime = Rxn<TimeOfDay>();

  var selectedRowIndex = 0.obs;

  var filteredRows = <Map<String, dynamic>>[].obs;

  void setSelectedDriver(String driver) {
    selectedDriver.value = driver;
    update();
  }


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
  Rx<DateTime> bookingFromDate = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  Rx<DateTime> bookingToDate = DateTime.now().obs;


  bool isLoadingPostcodes = false;

  Future<List<String>> getSearchPostcodes(String query) async {
    if (query.isEmpty || query.length < 3) return [];

    try {
      var response = await Api().get(
        "services/search",
        queryParameters: {
          "search": query,
        },
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData is Map && responseData.containsKey('result')) {
          List<dynamic> list = responseData['result'];

          return list.map((item) {
            String name = item['name'] ?? '';
            String postcode = item['postcode'] ?? '';
            return "$name - $postcode";
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error Searching Postcode: $e");
      return [];
    }
  }











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
  final mobileController = TextEditingController();
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
