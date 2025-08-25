import 'package:get/get.dart';

import '../../../Model/driver_model.dart';


class DriverController extends GetxController {
  var driver = Driver().obs;
  var documents = <Map<String, String>>[].obs;
  var validities = <Map<String, String>>[].obs;


  void updateField(String key, dynamic value) {
    final updatedDriver = driver.value;

    switch (key) {
      case "fullName":
        updatedDriver.fullName = value;
        break;
      case "email":
        updatedDriver.email = value;
        break;
      case "dob":
        updatedDriver.dob = value;
        break;
      case "mobile":
        updatedDriver.mobile = value;
        break;
      case "username":
        updatedDriver.username = value;
        break;
      case "password":
        updatedDriver.password = value;
        break;
      case "company":
        updatedDriver.company = value;
        break;
      case "driverType":
        updatedDriver.driverType = value;
        break;
      case "vehicleNo":
        updatedDriver.vehicleNo = value;
        break;
      case "make":
        updatedDriver.make = value;
        break;
      case "model":
        updatedDriver.model = value;
        break;
      case "color":
        updatedDriver.color = value;
        break;
      case "owner":
        updatedDriver.owner = value;
        break;
      case "address":
        updatedDriver.address = value;
        break;
    }

    driver.value = updatedDriver;
    driver.refresh();
  }

  void updateDriver(Driver newDriver) {
    driver.value = newDriver;
    driver.refresh();
  }

  // Document Table
  void addDocument({required String expiry, required String batch, required String title}) {
    documents.add({"expiry": expiry, "batch": batch, "title": title});
  }

  void deleteDocument(int index) {
    if (index >= 0 && index < documents.length) {
      documents.removeAt(index);
    }
  }

  // Validity Table
  void addValidity({required String start, required String end}) {
    validities.add({"start": start, "end": end});
  }

  void deleteValidity(int index) {
    if (index >= 0 && index < validities.length) {
      validities.removeAt(index);
    }
  }

  void editValidity(int index, String start, String end) {
    if (index >= 0 && index < validities.length) {
      validities[index] = {"start": start, "end": end};
    }
  }


  void saveDriver() {
    final jsonData = driver.value.toJson();
    print("Driver Saved => $jsonData");
  }
}

// class DriverBindings implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<DriverController>(() => DriverController());
//   }
// }
