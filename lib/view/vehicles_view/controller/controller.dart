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

  VehicleTypes? allVehicleTypeData;
  RxBool getAllVehicleTypeLoader = false.obs;
  getAllVehicleType() async {
    getAllVehicleTypeLoader(true);
    var response = await Api().get("vehicle-type");
    if (response.statusCode == 200) {
      allVehicleTypeData =
          VehicleTypes.fromJson(response.data['vehicle_types']);
      getAllVehicleTypeLoader(false);
      update();
    }
  }

  /// text fields editing
  final colorController = TextEditingController();
  final vehicleMakeController = TextEditingController();
  final vehicleModelController = TextEditingController();
  final logBookingDocController = TextEditingController();
  final phcVehicleNumberController = TextEditingController();
  final motNumberController = TextEditingController();
  final mot2NumberController = TextEditingController();
  final insuranceNumberController = TextEditingController();
  final vehicleNumberController = TextEditingController();

  /// store image variable
  Uint8List? phcVehicleDocPic;
  Uint8List? motDocPic;
  Uint8List? insuranceDocPic;
  Uint8List? mot2DocPic;
  RxBool companyVehicleLoader = false.obs;
  String? phcVehicleExpireDate = "2000-01-01";
  String? motExpiryExpireDate = "2000-01-01";
  String? mot2ExpiryExpireDate = "2000-01-01";
  String? insuranceExpiryDate = "2000-01-01";
  final phcVehicleExpireTimeController = TextEditingController();
  final motExpiryExpireTimeController = TextEditingController();
  final mot2ExpiryExpireTimeController = TextEditingController();
  final insuranceExpiryTimeController = TextEditingController();

  postCompanyVehicle() async {
    companyVehicleLoader(false);
    var formData = {
      'vehicle_number': vehicleNumberController.text,
      'make': vehicleMakeController.text,
      'model': vehicleModelController.text,
      'color': colorController.text,
      'owner': 'company',
      'company': 'true',
      'assigned': 'false',
      'vehicle_type_id': '68',
      'log_book_number': logBookingDocController.text,
      'phc_vehicle_expiry': phcVehicleExpireDate,
      'mot_expiry': motExpiryExpireDate,
      'mot2_expiry': mot2ExpiryExpireDate,
      'insurance_expiry': insuranceExpiryDate,
      'phc_vehicle_number': phcVehicleNumberController.text,
      'mot_number': motNumberController.text,
      'mot2_number': mot2NumberController.text,
      'insurance_number': insuranceNumberController.text,
      'start_date': '2024-01-10',
      'end_date': '2025-01-10',
      'phc_vehicle_document': phcVehicleDocPic,
      'mot_document': motDocPic,
      'mot2_document': mot2DocPic,
      'insurance_document': insuranceDocPic,
      "phc_vehicle_expiry_time": phcVehicleExpireTimeController.text,
      "mot_expiry_time": motExpiryExpireTimeController.text,
      "mot2_expiry_time": mot2ExpiryExpireTimeController.text,
      "insurance_expiry_time": insuranceExpiryTimeController.text,
    };

    var response =
        await Api().post(formData, 'company-vehicles/add', auth: true);
    if (response.statusCode == 200) {
      colorController.clear();
      vehicleMakeController.clear();
      vehicleModelController.clear();
      logBookingDocController.clear();
      phcVehicleNumberController.clear();
      motNumberController.clear();
      mot2NumberController.clear();

      insuranceNumberController.clear();
    } else {
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrr");
    }
  }

  Vehicles? singleVehicleData;
  companyDataBinding({Vehicles? data}) async {
    vehicleMakeController.text = data!.make.toString();
    vehicleModelController.text = data.model.toString();
    colorController.text = data.color.toString();
    logBookingDocController.text = data.logBookDocument.toString();
    phcVehicleNumberController.text = data.phcVehicleNumber.toString();
    motNumberController.text = data.motNumber.toString();
    mot2NumberController.text = data.mot2Number.toString();
    insuranceNumberController.text = data.insuranceNumber.toString();
    vehicleNumberController.text = data.vehicleNumber.toString();
    phcVehicleExpireTimeController.text = data.phcVehicleExpiryTime.toString();
    motExpiryExpireTimeController.text = data.motExpiryTime.toString();
    mot2ExpiryExpireTimeController.text = data.mot2ExpiryTime.toString();
    insuranceExpiryTimeController.text = data.insuranceExpiryTime.toString();
    singleVehicleData = data;
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo company vehicle

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEHICLE TYPES Model

  VehicleTypeModel? vehicleTypeModel;
  RxBool isLoading = false.obs;

  RxList<VehicleTypes> allVehicleTypes = <VehicleTypes>[].obs;
  RxList<VehicleTypes> filteredVehicleTypes = <VehicleTypes>[].obs;

// // ye search fields hain
  RxString searchName = ''.obs;
  RxString searchPassengers = ''.obs;
  RxString searchLuggages = ''.obs;
  RxString searchHandLuggages = ''.obs;
  RxString searchMinFare = ''.obs;
  RxString searchMinMiles = ''.obs;

  ///------------------------------------------- Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 5;

  getVehicleTypes() async {
    try {
      isLoading.value = true;

      String query = 'page=${currentPage.value}&limit=$limit';
      if (searchName.value.isNotEmpty) query += '&name=${searchName.value}';
      if (searchPassengers.value.isNotEmpty)
        query += '&passengers=${searchPassengers.value}';
      if (searchLuggages.value.isNotEmpty)
        query += '&luggages=${searchLuggages.value}';
      if (searchHandLuggages.value.isNotEmpty)
        query += '&hand_luggages=${searchHandLuggages.value}';
      if (searchMinFare.value.isNotEmpty)
        query += '&minimum_fares=${searchMinFare.value}';
      if (searchMinMiles.value.isNotEmpty)
        query += '&minimum_miles=${searchMinMiles.value}';

      print("API Query: vehicle-type/ge?$query");

      final response = await Api().get('vehicle-type/get?$query');

      if (response.statusCode == 200) {
        vehicleTypeModel = VehicleTypeModel.fromJson(response.data);
        totalPages.value = vehicleTypeModel?.totalPages ?? 1;
        allVehicleTypes.value = vehicleTypeModel?.vehicleTypes ?? [];
        filteredVehicleTypes.value = allVehicleTypes;
      }
    } catch (e) {
      print("Error in getVehicleType: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

// --------------------------------Search changes function
  void onSearchChanged() {
    currentPage.value = 1;
    getVehicleTypes();
  }

  /// ------------------------------------- pagination function
  void onPageChange(int page) {
    currentPage.value = page;
    getVehicleTypes();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEHICLE TYPES Model

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Company VEHICLE Model
  RxBool isCompanyVehicle = false.obs;
  CompanyVehicleModel? companyVehicleModel;
  // Fetch company vehicles
  RxList<Vehicles> companyAllVehicle = <Vehicles>[].obs;
  RxList<Vehicles> filteredCompanyVehicle = <Vehicles>[].obs;
  // ye search fields hain
  RxString searchVehicle = ''.obs;
  RxString searchVehicleType = ''.obs;
  RxString searchOwner = ''.obs;
  RxString searchMake = ''.obs;
  RxString searchModel = ''.obs;
  RxString searchColor = ''.obs;
//   ///------------------------- Pagination
  var companycurrentPage = 1.obs;
  var companytotalPages = 1.obs;
  final int companylimit = 20;
  Future<void> companyVehicle() async {
    try {
      String query = 'page=${companycurrentPage.value}&limit=${companylimit}';
      if (searchVehicle.value.isNotEmpty)
        query += '&vehicle_number=${searchVehicle.value}';
      if (searchVehicleType.value.isNotEmpty)
        query += '&vehicle_type=${searchVehicleType.value}';
      if (searchOwner.value.isNotEmpty) query += '&owner=${searchOwner.value}';
      if (searchMake.value.isNotEmpty) query += '&make=${searchMake.value}';
      if (searchModel.value.isNotEmpty) query += '&model=${searchModel.value}';
      if (searchColor.value.isNotEmpty) query += '&color=${searchColor.value}';
      print("API Query: company-vehicles/ge?$query");
      isCompanyVehicle.value = true;
      final response = await Api().get('company-vehicles/get?$query');
      if (response.statusCode == 200) {
        companyVehicleModel = CompanyVehicleModel.fromJson(response.data);
        companytotalPages.value = companyVehicleModel?.totalPages ?? 1;
        companyAllVehicle.value = companyVehicleModel?.vehicles ?? [];
        filteredCompanyVehicle.value = companyAllVehicle;
        print(
            'Company Vehicles: ${companyVehicleModel?.vehicles?.length ?? 0}');
      }
    } catch (e) {
      print("Error in companyVehicle: $e");
    } finally {
      isCompanyVehicle.value = false;
      update();
    }
  }

// // --------------------------------Search changes function
  void SearchingOnCompany() {
    companycurrentPage.value = 1;
    companyVehicle();
  }

//   /// ------------------------------------- pagination function
  void PageOnCompany(int page) {
    companycurrentPage.value = page;
    companyVehicle();
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
    if (profileImg != null) {
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
      if (multipartFile != null) "image": multipartFile!
    });

    var response = await Api().post(
        formData,
        singleVehicle != null
            ? "vehicle-type/edit/${singleVehicle!.id}"
            : 'vehicle-type/add',
        auth: true,
        multiPart: multipartFile != null ? true : false);
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
  VehicleTypes? singleVehicle;
  vehicleDataBinding({item}) async {
    singleVehicle = item;
    vehicleTypeController.text = singleVehicle!.name!;
    passengersController.text = singleVehicle!.passengers!.toString();
    luggagesController.text = singleVehicle!.luggages.toString();
    handLuggagesController.text = singleVehicle!.handLuggages.toString();
    minimumFaresController.text = singleVehicle!.minimumFares.toString();
    minimumMilesController.text = singleVehicle!.minimumMiles.toString();
    waitingTimeController.text = singleVehicle!.waitingTime.toString();
    driverWaitingChargesController.text =
        singleVehicle!.driverWaitingCharges.toString();
    accountWaitingChargesController.text =
        singleVehicle!.accountWaitingCharges.toString();
    update();
  }
}
