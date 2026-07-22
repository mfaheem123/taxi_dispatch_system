import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Model/driver_earning_model.dart';
import '../view/customer/model/restricDriver.dart';

class DashboardAlertController extends GetxController{

  /// f3 alert

  RestricDriverModel? fetchDriver;
  RxBool isRestrictedDriverLoading = false.obs;
  var selectedDriver = Rxn<DriverObject>();

  fetchRestrictedDrivers() async {
    try{
      isRestrictedDriverLoading(true);
      update();

      var response = await Api().get("drivers/get", sendCompanyId: true);

      if (response.statusCode == 200) {
        fetchDriver = RestricDriverModel.fromJson(response.data);
        if (fetchDriver?.drivers != null && fetchDriver!.drivers!.isNotEmpty) {
          selectedDriver.value = fetchDriver!.drivers!.first;
        }
        update();
      }
    } catch (e) {
      print("Error fetching restricted drivers: $e");
    } finally {
      isRestrictedDriverLoading(false);
    }
  }

  /// f4 Driver Earning
  DriverEarningModel? driverEarningModel;
  bool isDriverEarningLoading = false;

  DriverObject? displayedDriver;

  Rx<DateTime?> fromDate = Rx<DateTime?>(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
  );

  Rx<DateTime?> toDate = Rx<DateTime?>(DateTime.now());

  getDriverEarnings() async {
    if (selectedDriver.value == null) {
      BotToast.showText(text: "PLEASE SELECT A DRIVER FIRST");
      return;
    }

    isDriverEarningLoading = true;
    update();

    try {
      String formattedFromDate = fromDate.value != null
          ? DateFormat('yyyy-MM-dd').format(fromDate.value!)
          : "";
      String formattedToDate = toDate.value != null
          ? DateFormat('yyyy-MM-dd').format(toDate.value!)
          : "";

      var response = await Api().get(
        "bookings/driver-earnings/", sendCompanyId: true,
        queryParameters: {
          "driver_id": selectedDriver.value?.id.toString(),
          "from_date": formattedFromDate,
          "to_date": formattedToDate,
        },
      );

      if (response.statusCode == 200) {
        driverEarningModel = DriverEarningModel.fromJson(response.data);
        displayedDriver = selectedDriver.value;
      }
    } catch (e) {
      print("Error fetching driver earnings: $e");
    } finally {
      isDriverEarningLoading = false;
      update();
    }
  }

  clearEarnings() {
    fromDate.value = DateTime.now();
    toDate.value = DateTime.now();
    selectedDriver.value = null;
    driverEarningModel = null;
    displayedDriver = null;
    update();
  }
}