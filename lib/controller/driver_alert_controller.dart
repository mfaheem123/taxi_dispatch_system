import 'package:get/get.dart';

import '../Model/driver_models/single_driver_model.dart';
import '../component/networks/api.dart';

class DriverAlertController extends GetxController{

  /// driver break alert

  var isDriverLoading = false.obs;
  var driverData = Rxn<Driver>();

  getDriverById(int driverId) async {
    try {
      isDriverLoading(true);
      var response = await Api().get("drivers/getbyid/$driverId");

      if (response.statusCode == 200) {
        var result = SingleDriverModel.fromJson(response.data);
        if (result.status == true) {
          driverData.value = result.driver;
        }
      }
    } catch (e) {
      print("Error fetching driver: $e");
    } finally {
      isDriverLoading(false);
    }
  }
}