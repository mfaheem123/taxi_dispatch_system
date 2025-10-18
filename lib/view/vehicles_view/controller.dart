import 'dart:typed_data';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/vehicles_view/model/comapny_vehicle_model.dart';
import 'package:dashboard_new1/view/vehicles_view/model/vehicle_type_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Model/image_model.dart';

class VehicleController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo functionality vehicle type

  /// bool variable
  RxBool defaultVehicleValue = false.obs;
  RxBool minimumMilesValue = false.obs;
  RxBool minimumFaresValue = false.obs;

  /// color pick
  Color pickerColor = Colors.blue;
  Color foregroundColor = Colors.blue;

  ImageModel? profileImg;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.bytes != null) {
      profileImg = ImageModel(
          name: result.files.single.name,
          bytes: result.files.single.bytes!,
          path: result.files.single.path);
    }
    update();
  }

  /// text fields editing
  final vehicleTypeController = TextEditingController();
  final passengersController = TextEditingController();
  final luggagesController = TextEditingController();
  final handLuggagesController = TextEditingController();
  final minimumMilesController = TextEditingController();
  final minimumFaresController = TextEditingController();
  final driverWaitingChargesController = TextEditingController();
  final accountWaitingChargesController = TextEditingController();
  final waitingTimeController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo functionality vehicle type

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo company vehicle

  /// text fields editing
  final colorController = TextEditingController();
  final vehicleMakeController = TextEditingController();
  final vehicleModelController = TextEditingController();
  final logBookingDocController = TextEditingController();
  final phcVehicleNumberController = TextEditingController();
  final motNumberController = TextEditingController();
  final mot2NumberController = TextEditingController();
  final insuranceNumberController = TextEditingController();

  /// store image variable
  Uint8List? phcVehicleDocPic;
  Uint8List? motDocPic;
  Uint8List? insuranceDocPic;
  Uint8List? mot2DocPic;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo company vehicle

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEHICLE TYPES Model

  VehicleTypeModel? vehicleTypeModel;
  RxBool isLoading = false.obs;

  Future<void> getVehicleTypes() async {
    try {
      isLoading.value = true;

      final response = await Api().get('vehicle-type');

      if (response.statusCode == 200) {
        vehicleTypeModel = VehicleTypeModel.fromJson(response.data);
        print("Vehicle types ${vehicleTypeModel?.vehicleTypes?.length}");
      } else {
        print("Status Code Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error in getVehicleTypes(): $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEHICLE TYPES Model

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Company VEHICLE Model

  RxBool isCompanyVehicle = false.obs;

  CompanyVehicleModel? companyVehicleModel;

  Future<void> conpanyVehicleModel() async {
    try {
      isCompanyVehicle.value = true;
      final response = await Api().get('company-vehicles');

      if (response.statusCode == 200) {
        companyVehicleModel = CompanyVehicleModel.fromJson(response.data);
        print('Company ${CompanyVehicleModel}');
      } else {
        print("Status Code Error-------${response.statusCode}");
      }
    } catch (e) {
      print("Error in getVehicleTypes(): $e");
    } finally {
      isCompanyVehicle.value = false;
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEHICLE TYPES Model
}
