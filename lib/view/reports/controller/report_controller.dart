import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
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
}
