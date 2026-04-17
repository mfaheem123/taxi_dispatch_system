import 'dart:convert';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
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

import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/models/dashboard_model.dart';

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

  VehicleType? allVehicleTypeData;
  RxBool getAllVehicleTypeLoader = false.obs;
  getAllVehicleType() async {
    getAllVehicleTypeLoader(true);
    var response = await Api().get("vehicle-type");
    if (response.statusCode == 200) {
      allVehicleTypeData =
          VehicleType.fromJson(response.data['vehicle_types']);
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
  DashboardDataModel? dashboardAllData;
  DashboardVehicleTypeObject? selectVehicleValue;
  postCompanyVehicle() async {
    companyVehicleLoader(true);
    update();
    dio.MultipartFile? phcFile;
    dio.MultipartFile? motFile;
    dio.MultipartFile? mot2File;
    dio.MultipartFile? insuranceFile;
    if (phcVehicleDocPic != null) {
      phcFile = dio.MultipartFile.fromBytes(phcVehicleDocPic!, filename: "phc.png");
    }
    if (motDocPic != null) {
      motFile = dio.MultipartFile.fromBytes(motDocPic!, filename: "mot.png");
    }
    if (mot2DocPic != null) {
      mot2File = dio.MultipartFile.fromBytes(mot2DocPic!, filename: "mot2.png");
    }
    if (insuranceDocPic != null) {
      insuranceFile = dio.MultipartFile.fromBytes(insuranceDocPic!, filename: "insurance.png");
    }

    if (vehicleNumberController.text.isEmpty  ) {
      BotToast.showText(text: "Please Fill Vehicle Number");
      companyVehicleLoader(false);
      update();
      return;
    }

    var formData = dio.FormData.fromMap({
      "vehicle_type_id": selectVehicleValue!.id,
      'vehicle_number': vehicleNumberController.text,
      'make': vehicleMakeController.text,
      'model': vehicleModelController.text,
      'color': colorController.text,
      'log_book_number': logBookingDocController.text,
      'phc_vehicle_expiry': phcVehicleExpireDate,
      'mot_expiry': motExpiryExpireDate,
      'mot2_expiry': mot2ExpiryExpireDate,
      'insurance_expiry': insuranceExpiryDate,
      'phc_vehicle_number': phcVehicleNumberController.text,
      'mot_number': motNumberController.text,
      'mot2_number': mot2NumberController.text,
      'insurance_number': insuranceNumberController.text,
      if (phcFile != null) 'phc_vehicle_document': phcFile,
      if (motFile != null) 'mot_document': motFile,
      if (mot2File != null) 'mot2_document': mot2File,
      if (insuranceFile != null) 'insurance_document': insuranceFile,
      "phc_vehicle_expiry_time": phcVehicleExpireTimeController.text,
      "mot_expiry_time": motExpiryExpireTimeController.text,
      "mot2_expiry_time": mot2ExpiryExpireTimeController.text,
      "insurance_expiry_time": insuranceExpiryTimeController.text,
    });
      var response = await Api().post(
          formData,
          singleVehicleData !=null?
           "company-vehicles/update/${singleVehicleData!.id}" :
          'company-vehicles/add',
          auth: true,
          multiPart: true,
      );
      if (response.statusCode == 200) {
        String message = singleVehicleData != null
            ? "Company Vehicle Update Successfully"
            : "Company Vehicle Added Successfully";
        _clearAllFields();
        singleVehicleData = null;
        BotToast.showText(text: message);
      }
      companyVehicleLoader(false);
      update();
  }

  _clearAllFields() {
    colorController.clear();
    vehicleMakeController.clear();
    vehicleModelController.clear();
    logBookingDocController.clear();
    phcVehicleNumberController.clear();
    motNumberController.clear();
    mot2NumberController.clear();
    vehicleNumberController.clear();
    insuranceNumberController.clear();
    phcVehicleDocPic = null;
    motDocPic = null;
    mot2DocPic = null;
    insuranceDocPic = null;
  }
  List<VehicleType> vehicleTypeList = [];
  VehicleType? selectVehicleValue1;
  Vehicles? singleVehicleData;
  companyDataBinding({Vehicles? data}) async {
    if (data == null) return;
    if (data.vehicleTypeId != null) {
      selectVehicleValue1 = vehicleTypeList.firstWhereOrNull(
              (element) => element.id == data.vehicleTypeId
      );
    }
    vehicleMakeController.text = data.make?.toString() ?? '';
    vehicleModelController.text = data.model?.toString() ?? '';
    colorController.text = data.color?.toString() ?? '';
    logBookingDocController.text = data.logBookNumber?.toString() ?? '';
    phcVehicleNumberController.text = data.phcVehicleNumber?.toString() ?? '';
    motNumberController.text = data.motNumber?.toString() ?? '';
    mot2NumberController.text = data.mot2Number?.toString() ?? '';
    insuranceNumberController.text = data.insuranceNumber?.toString() ?? '';
    vehicleNumberController.text = data.vehicleNumber?.toString() ?? '';
    phcVehicleExpireTimeController.text = data.phcVehicleExpiryTime?.toString() ?? '';
    motExpiryExpireTimeController.text = data.motExpiryTime?.toString() ?? '';
    mot2ExpiryExpireTimeController.text = data.mot2ExpiryTime?.toString() ?? '';
    insuranceExpiryTimeController.text = data.insuranceExpiryTime?.toString() ?? '';
    phcVehicleExpireDate = data.phcVehicleExpiry;
    motExpiryExpireDate = data.motExpiry;
    mot2ExpiryExpireDate = data.mot2Expiry;
    insuranceExpiryDate = data.insuranceExpiry;
    phcVehicleDocPic = null;
    motDocPic = null;
    mot2DocPic = null;
    insuranceDocPic = null;
    singleVehicleData = data;
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo company vehicle

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEHICLE TYPES Model

  VehicleTypeModel? vehicleTypeModel;
  RxBool isLoading = false.obs;
  RxList<VehicleType> allVehicleTypes = <VehicleType>[].obs;
  RxList<VehicleType> filteredVehicleTypes = <VehicleType>[].obs;

//  ye search fields hain
  RxString searchName = ''.obs;
  RxString searchPassengers = ''.obs;
  RxString searchLuggages = ''.obs;
  RxString searchHandLuggages = ''.obs;
  RxString searchMinFare = ''.obs;
  RxString searchMinMiles = ''.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 20;
  getVehicleTypes() async {
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
      final response = await Api().get('vehicle-type/get',queryParameters: query , sendCompanyId: true,);
      if (response.statusCode == 200) {
        vehicleTypeModel = VehicleTypeModel.fromJson(response.data);
        totalPages.value = vehicleTypeModel?.totalPages ?? 1;
        allVehicleTypes.value = vehicleTypeModel?.vehicleTypes ?? [];
        filteredVehicleTypes.value = allVehicleTypes;
      isLoading.value = false;
      print(response);
      update();
      }
  }
// Search changes function
  void onSearchChanged() {
    currentPage.value = 1;
    getVehicleTypes();
  }
  //  pagination function
  void onPageChange(int page) {
    currentPage.value = page;
    getVehicleTypes();
  }

  deleteVehicleType(int? id) async {
    var response = await Api().delete('vehicle-type/delete/$id');
    if (response.statusCode == 200) {
      getVehicleTypes();
      print(" VehicleType deleted successfully!");
      BotToast.showText(text: "VehicleType deleted successfully!" );
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEHICLE TYPES Model

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Company VEHICLE Model
  RxBool isCompanyVehicle = false.obs;
  CompanyVehicleModel? companyVehicleModel;
  RxList<Vehicles> companyAllVehicle = <Vehicles>[].obs;
  RxList<Vehicles> filteredCompanyVehicle = <Vehicles>[].obs;
  final searchVehicle = TextEditingController();
  final searchVehicleType = TextEditingController();
  final searchOwner = TextEditingController();
  final searchMake = TextEditingController();
  final searchModel = TextEditingController();
  final searchColor = TextEditingController();
  var companycurrentPage = 1.obs;
  var companytotalPages = 1.obs;
  final int companylimit = 20;
 companyVehicle() async {
      isCompanyVehicle.value = true;
      final response = await Api().get('company-vehicles/get?',
      queryParameters: {
          "page": companycurrentPage.value,
          "limit": companylimit,
          "vehicle_number" : searchVehicle.text,
          "vehicle_type" : searchVehicleType.text,
          "owner" : searchOwner.text,
          "make" : searchMake.text,
          "model" : searchModel.text,
          "color" : searchColor.text,
      }, auth: true,
      );
      if (response.statusCode == 200) {
        companyVehicleModel = CompanyVehicleModel.fromJson(response.data);
        companytotalPages.value = companyVehicleModel?.totalPages ?? 1;
        companyAllVehicle.value = companyVehicleModel?.vehicles ?? [];
        filteredCompanyVehicle.value = companyAllVehicle;
        print('Company Vehicles: ${companyVehicleModel?.vehicles?.length}');
      isCompanyVehicle.value = false;
      update();
      }
  }

  void SearchingOnCompany() {
    companycurrentPage.value = 1;
    companyVehicle();
  }
  ///  pagination function
  void PageOnCompany(int page) {
    companycurrentPage.value = page;
    companyVehicle();
  }
  deleteCompanyVehicle(int? id) async {
    var response = await Api().delete('company-vehicles/delete/$id');
    if (response.statusCode == 200) {
      companyVehicle();
      BotToast.showText(text: "Company Vehicle deleted successfully!");
      print(json.encode(response.data));
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Create Vehicle type

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
      String message = singleVehicle != null
          ? "Vehicle Updated Successfully"
          : "Vehicle Created Successfully";
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
      BotToast.showText(text: message);
      update();
      print("response of body -------------------------${response.data}");
    } else {
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrr");
    }
  }

  /// bind data to edit vehicle
  VehicleType? singleVehicle;
  vehicleDataBinding({item}) async {
    singleVehicle = item;
    // Text Fields
    vehicleTypeController.text = singleVehicle!.name ?? '';
    passengersController.text = singleVehicle!.passengers?.toString() ?? '0';
    luggagesController.text = singleVehicle!.luggages?.toString() ?? '0';
    handLuggagesController.text = singleVehicle!.handLuggages?.toString() ?? '0';
    minimumFaresController.text = singleVehicle!.minimumFares?.toString() ?? '0.0';
    minimumMilesController.text = singleVehicle!.minimumMiles?.toString() ?? '0';
    waitingTimeController.text = singleVehicle!.waitingTime?.toString() ?? '0';
    driverWaitingChargesController.text = singleVehicle!.driverWaitingCharges?.toString() ?? '0';
    accountWaitingChargesController.text = singleVehicle!.accountWaitingCharges?.toString() ?? '0';
    // Booleans
    defaultVehicleValue.value = singleVehicle!.defaultVehicle ?? false;
    minimumFaresValue.value = singleVehicle!.vehicleTypeMinimumFares ?? false;
    // Colors (Hex String to Color conversion)
    if (singleVehicle!.backgroundColor != null) {
      pickerColor = Color(int.parse("0xFF${singleVehicle!.backgroundColor!}"));
    }
    if (singleVehicle!.foregroundColor != null) {
      foregroundColor = Color(int.parse("0xFF${singleVehicle!.foregroundColor!}"));
    }
    // Reset local image bytes to null so UI uses singleVehicle!.image
    profileImg = null;
    update();
  }
}
