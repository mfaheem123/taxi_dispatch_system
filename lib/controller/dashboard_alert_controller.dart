import 'package:dashboard_new1/component/networks/api.dart';
import 'package:get/get.dart';

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
}