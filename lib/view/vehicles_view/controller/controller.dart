import 'dart:convert';
import 'dart:typed_data';
import 'package:dashboard_new1/component/networks/api.dart';

import 'package:dashboard_new1/view/vehicles_view/model/comapny_vehicle_model.dart'
    hide VehicleType;
import 'package:dashboard_new1/view/vehicles_view/model/vehicle_type_model.dart';
import 'package:dashboard_new1/view/vehicles_view/model/vehicle_type_model.dart'
    as type;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Model/image_model.dart';
import 'package:dio/dio.dart' as dio;

class VehicleController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo functionality vehicle type

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
  RxBool CompanyVehicleLoader = false.obs;
  postCompanyVehicle() async {
    CompanyVehicleLoader(false);
    var formData = {
      'vehicle_number': 'DSA-798',
      'make': vehicleMakeController.text,
      'model': vehicleModelController.text,
      'color': colorController.text,
      'owner': 'company',
      'company': 'true',
      'assigned': 'false',
      'vehicle_type_id': '1',
      'log_book_number': logBookingDocController.text,
      'phc_vehicle_expiry': '2025-12-01',
      'mot_expiry': '2025-12-01',
      'mot2_expiry': '2025-12-01',
      'insurance_expiry': '2025-12-01',
      'phc_vehicle_number': phcVehicleNumberController.text,
      'mot_number': motNumberController.text,
      'mot2_number': mot2NumberController.text,
      'insurance_number': insuranceNumberController.text,
      'start_date': '2024-01-10',
      'end_date': '2025-01-10',
      'phc_vehicle_document':phcVehicleDocPic,
      'mot_document':motDocPic,
      'mot2_document':mot2DocPic,
      'insurance_document':insuranceDocPic,



    };

    var response =
        await Api().post(formData, 'company-vehicles/add', auth: true);
    if (response.statusCode == 200) {
      // Get.toNamed(Routes.myHomePage);
    } else {
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrr");
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo company vehicle

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEHICLE TYPES Model

  VehicleTypeModel? vehicleTypeModel;

  RxList<VehicleType> allVehicleTypes = <VehicleType>[].obs;
  RxList<VehicleType> filteredVehicleTypes = <VehicleType>[].obs;

  RxBool isLoading = false.obs;

// ye search fields hain
  RxString searchName = ''.obs;
  RxString searchPassengers = ''.obs;
  RxString searchLuggages = ''.obs;
  RxString searchHandLuggages = ''.obs;
  RxString searchMinFare = ''.obs;
  RxString searchMinMiles = ''.obs;

  getVehicleTypes() async {
    try {
      isLoading.value = true;
      final response = await Api().get('vehicle-type');

      if (response.statusCode == 200) {
        vehicleTypeModel = VehicleTypeModel.fromJson(response.data);
        allVehicleTypes.value = vehicleTypeModel?.vehicleTypes ?? [];
        filteredVehicleTypes.value = allVehicleTypes;
      }
    } catch (e) {
      print("Error in getVehicleTypes(): $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

// ye function filter lagayega
  void applyFilter() {
    if (searchName.value.isEmpty &&
        searchPassengers.value.isEmpty &&
        searchLuggages.value.isEmpty &&
        searchHandLuggages.value.isEmpty &&
        searchMinFare.value.isEmpty &&
        searchMinMiles.value.isEmpty) {
      filteredVehicleTypes.clear(); // koi filter nahi
      update();
      return;
    }

    filteredVehicleTypes.value = allVehicleTypes.where((item) {
      final name = item.name?.toLowerCase() ?? '';
      final passengers = item.passengers?.toString() ?? '';
      final luggages = item.luggages?.toString() ?? '';
      final handLuggages = item.handLuggages?.toString() ?? '';
      final minFare = item.minimumFares?.toString() ?? '';
      final minMiles = item.minimumMiles?.toString() ?? '';

      return name.contains(searchName.value.toLowerCase()) &&
          passengers.contains(searchPassengers.value) &&
          luggages.contains(searchLuggages.value) &&
          handLuggages.contains(searchHandLuggages.value) &&
          minFare.contains(searchMinFare.value) &&
          minMiles.contains(searchMinMiles.value);
    }).toList();

    print("filter chal rha hai");
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEHICLE TYPES Model

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Company VEHICLE Model

  RxBool isCompanyVehicle = false.obs;

  CompanyVehicleModel? companyVehicleModel;
  RxList<CompanyVehicleModel> companyallVehicleTypes = <CompanyVehicleModel>[].obs;
  RxList<CompanyVehicleModel> companyfilteredVehicleTypes = <CompanyVehicleModel>[].obs;
// ye search fields hain
  RxString searchVehicle = ''.obs;
  RxString searchVehicleType = ''.obs;
  RxString searchOwner = ''.obs;
  RxString searchMake = ''.obs;
  RxString searchModel = ''.obs;
  RxString searchColor = ''.obs;

  Future<void> companyVehicle() async {
    try {
      isCompanyVehicle.value = true;
      final response = await Api().get('company-vehicles');

      if (response.statusCode == 200) {
        companyVehicleModel = CompanyVehicleModel.fromJson(response.data);
                allVehicleTypes.value = vehicleTypeModel?.vehicleTypes ?? [];
        filteredVehicleTypes.value = allVehicleTypes;
        print('Company ${CompanyVehicleModel}');
      }
    } catch (e) {
      print("Error in getVehicleTypes(): $e");
    } finally {
      isCompanyVehicle.value = false;
      update();
    }
  }

// ye function filter lagayega
  void companyApplyFilter() {
    if (searchVehicle.value.isEmpty &&
        searchVehicleType.value.isEmpty &&
        searchOwner.value.isEmpty &&
        searchMake.value.isEmpty &&
        searchModel.value.isEmpty &&
        searchColor.value.isEmpty) {
      filteredVehicleTypes.clear(); // koi filter nahi
      update();
      return;
    }

    filteredVehicleTypes.value = allVehicleTypes.where((item) {
      final vehicle = item.name?.toLowerCase() ?? '';
      final passengers = item.passengers?.toString() ?? '';
      final luggages = item.luggages?.toString() ?? '';
      final handLuggages = item.handLuggages?.toString() ?? '';
      final minFare = item.minimumFares?.toString() ?? '';
      final minMiles = item.minimumMiles?.toString() ?? '';

      return vehicle.contains(searchName.value.toLowerCase()) &&
          passengers.contains(searchPassengers.value) &&
          luggages.contains(searchLuggages.value) &&
          handLuggages.contains(searchHandLuggages.value) &&
          minFare.contains(searchMinFare.value) &&
          minMiles.contains(searchMinMiles.value);
    }).toList();

    print("filter chal rha hai");
    update();
  }

















  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Create Vehicle type
  /// bool variable
  RxBool defaultVehicleValue = false.obs;
  RxBool minimumMilesValue = false.obs;
  RxBool minimumFaresValue = false.obs;

  /// color pick
  Color pickerColor = Colors.blue;
  Color foregroundColor = Colors.blue;

  RxBool isLoadVehicleType = false.obs;

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

  createVehicleType() async {
    isLoadVehicleType.value = false;

    var multipartFile;
    if(profileImg !=null){
      multipartFile = dio.MultipartFile.fromBytes(
        profileImg!.bytes,
        filename: profileImg!.name,
      );
    }
    final formData = dio.FormData.fromMap({
      'name': vehicleTypeController.text,
      'passengers': passengersController.text,
      'luggages': luggagesController.text,
      'hand_luggages': handLuggagesController.text,
      'minimum_fares': minimumFaresController.text,
      'minimum_miles': minimumMilesController.text,
      'waiting_time': waitingTimeController.text,
      'waiting_time_duration': '45',
      'default_vehicle': defaultVehicleValue.value,
      'vehicle_type_minimum_fares': minimumFaresValue.value,
      'background_color': pickerColor.value.toRadixString(16).substring(2),
      'foreground_color': foregroundColor.value.toRadixString(16).substring(2),
      'driver_waiting_charges': driverWaitingChargesController.text,
      'account_waiting_charges': accountWaitingChargesController.text,
     if(multipartFile != null) "image": multipartFile!
    });

    var response = await Api().post(formData, singleVehicle !=null ? "vehicle-type/edit/${singleVehicle!.id}" : 'vehicle-type/add', auth: true, multiPart: multipartFile != null?true: false);
    if (response.statusCode == 200) {
      vehicleTypeController.clear();
      passengersController.clear();
      luggagesController.clear();
      handLuggagesController.clear();
      minimumFaresController.clear();
      minimumMilesController.clear();
      waitingTimeController.clear();
      driverWaitingChargesController.clear();
      accountWaitingChargesController.clear();
      defaultVehicleValue.value = false;
      minimumMilesValue.value = false;
      minimumFaresValue.value = false;
      profileImg = null;
      singleVehicle = null;
      update();
      print("response of body -------------------------${response.data}");
    } else {
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrr");
    }
  }

  /// bind data to edit vehicle
  VehicleType? singleVehicle;
  vehicleDataBinding({item}) async{
    singleVehicle = item;
    vehicleTypeController.text = singleVehicle!.name!;
    passengersController.text = singleVehicle!.passengers!.toString();
    luggagesController.text = singleVehicle!.luggages.toString();
    handLuggagesController.text = singleVehicle!.handLuggages.toString();
    minimumFaresController.text = singleVehicle!.minimumFares.toString();
    minimumMilesController.text = singleVehicle!.minimumMiles.toString();
    waitingTimeController.text = singleVehicle!.waitingTime.toString();
    driverWaitingChargesController.text = singleVehicle!.driverWaitingCharges.toString();
    accountWaitingChargesController.text = singleVehicle!.accountWaitingCharges.toString();
    update();
  }

}
