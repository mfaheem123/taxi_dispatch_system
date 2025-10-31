import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/drivers_view/model/list_drivers_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:intl/intl.dart';

import '../../../Model/driver_model.dart' hide Driver;
import 'package:file_picker/file_picker.dart';

import '../../../Model/image_model.dart';
import '../driver/create_driver_form/driver_form.dart';
import '../model/driver_form_model.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;

class DriverController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create driver form functionality

  /// RxBool variable
  RxBool hasPDA = false.obs;
  RxBool rentPaid = false.obs;
  RxBool isActive = false.obs;
  RxBool vehicleInformation = false.obs;

  String? driverType;
  String? dobDate = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? vehicleStartDate;
  String? vehicleEndeDate;
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  /// text editing controller
  final driverUserNameController = TextEditingController();
  final driverPasswordController = TextEditingController();
  final driverFullNameController = TextEditingController();
  final driverEmailController = TextEditingController();
  final driverMobileController = TextEditingController();
  final driverTelController = TextEditingController();
  final driverNLController = TextEditingController();
  final driverCommissionController = TextEditingController();
  final driverRendLimitController = TextEditingController();
  final driverBalanceController = TextEditingController();
  final driverAddressController = TextEditingController();
  final vehicleNameController = TextEditingController();
  final vehicleMakeController = TextEditingController();
  final vehicleModelController = TextEditingController();
  final vehicleColorController = TextEditingController();
  final vehicleOwnerController = TextEditingController();
  final vehicleLogBookController = TextEditingController();

  String formatted = DateFormat("yyyy-MM-dd").format(DateTime.now());

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>table data
  var rows = <DocumentRow>[
    DocumentRow(
        batchNo: "",
        documentTitle: "PHC VEHICLE",
        paramTitle: "PHC_VEHICLE",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: "",
        documentTitle: "PHC DRIVER",
        paramTitle: "PHC_DRIVER",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: "",
        documentTitle: "MOT",
        paramTitle: "MOT",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: "",
        documentTitle: "MOT 2",
        paramTitle: "MOT2",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: "",
        documentTitle: "INSURANCE",
        paramTitle: "INSURANCE",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: "",
        documentTitle: "LICENSE",
        paramTitle: "LICENCE",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: "",
        documentTitle: "ROAD TAX",
        paramTitle: "ROAD_TAX",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: "",
        documentTitle: "V5 REGISTRATION",
        paramTitle: "V5_REGISTRATION",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: "",
        documentTitle: "RENTAL AGREEMENT",
        paramTitle: "RENTAL_AGREEMENT",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
  ].obs;

  void addEmptyRow() {
    rows.add(DocumentRow());
  }

  void updateExpiryDate(int index, DateTime date) {
    rows[index].expiryDate = date;
    rows.refresh();
  }

  void updateExpiryTime(int index, time) {
    rows[index].expiryTime = time;
    rows.refresh();
  }

  void addDocument(int index) async {
    await pickImage(singleImg: "profileImg", docImg: "docImg");
    rows[index].fileName = docImgg;
    rows.refresh();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>shift alert controllers
  List shiftList = <ShiftAlertClass>[].obs;
  List noteList = <NoteAlertClass>[].obs;
  final notesCtrl = TextEditingController();

  /// Rx String variable
  RxString? fileName;
  ImageModel? profileImg;
  ImageModel? docImgg;

  /// List variables
  List<ImageModel> imageList = [];

  Uint8List? imageBytes;

  Future<void> pickImage({singleImg, docImg}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.bytes != null) {
      if (singleImg == null) {
        imageList.clear();
        imageList.insert(0, ImageModel(
            name: result.files.single.name,
            bytes: result.files.single.bytes!,
            path: result.files.single.path)
        );
        // imageList.add(ImageModel(
        //     name: result.files.single.name,
        //     bytes: result.files.single.bytes!,
        //     path: result.files.single.path));
      } else {
        if (docImg == "docImg") {
          docImgg = ImageModel(
              name: result.files.single.name,
              bytes: result.files.single.bytes!,
              path: result.files.single.path);
        } else {
          profileImg = ImageModel(
              name: result.files.single.name,
              bytes: result.files.single.bytes!,
              path: result.files.single.path);
        }
      }
    }
    update();
  }

  DriverFormModel? getCombineVehicleData;
  SubsidiaryObject? companyType;
  SubsidiaryObject? selectCompanyVehicle;
  CompanyVehicleObject? vehicleType;

  RxBool getCombineVehicleLoading = false.obs;
  getCombineVehicle() async {
    getCombineVehicleLoading(true);
    var response = await Api().get("driver-combine/get");
    if (response.statusCode == 200) {
      getCombineVehicleData = DriverFormModel.fromJson(response.data);
      getCombineVehicleLoading(false);
      update();
    }
  }

  addDriverFtn() async {
    try {
      // 🧩 Step 1: Prepare multipart image files
      final Map<String, dio.MultipartFile> rowsImageList = {};

      var profileImage;
      var docImages;

      if(profileImg != null){
        profileImage = await dio.MultipartFile.fromBytes(
          profileImg!.bytes,
          filename: profileImg!.name,
        );
      }

      if(vehicleInformation.value == false){
        for (final action in rows) {
          if (action.fileName != null) {
            rowsImageList["${action.paramTitle}_DOCUMENT"] =
            await dio.MultipartFile.fromBytes(
              action.fileName!.bytes,
              filename: action.fileName!.name,
            );
          }
        }
      }

      if(imageList.isNotEmpty){
        docImages = await dio.MultipartFile.fromBytes(
          imageList[0].bytes,
          filename: imageList[0].name,
        );
      }

      // 🧾 Step 2: Prepare base data (normal form fields)
      final Map<String, dynamic> baseData = {
        "image": profileImage,
        "log_book_document": docImages,
        "has_pda": hasPDA.value,
        "rent_paid": rentPaid.value,
        "active": isActive.value,
        if(companyType != null)"subsidiary_id": companyType!.id,
        "username": driverUserNameController.text.trim(),
        "password": driverPasswordController.text.trim(),
        "name": driverFullNameController.text.trim(),
        "dob": dobDate,
        "email": driverEmailController.text.trim(),
        "mobile": driverMobileController.text.trim(),
        "telephone": driverTelController.text.trim(),
        if(driverType != null)"driver_type": driverType,
        "driver_commission": driverCommissionController.text.trim(),
        "rent_limit": driverRendLimitController.text.trim(),
        "balance": driverBalanceController.text.trim(),
        "address": driverAddressController.text.trim(),
        "use_company_vehicle": vehicleInformation.value,
        "start_date": "${startDate!.year}-${startDate!.month}-${startDate!.day}",
        "end_date": "${endDate!.year}-${endDate!.month}-${endDate!.day}",
        "ni": driverNLController.text.trim(),
        if (noteList.isNotEmpty) "notes": noteList,
       if(vehicleInformation.value == false) "vehicle": {
         if(selectCompanyVehicle != null) "vehicle_type_id": selectCompanyVehicle!.id,
          "vehicle_number": vehicleNameController.text,
          "make": vehicleMakeController.text,
          "model": vehicleModelController.text,
          "color": vehicleColorController.text,
          "owner": vehicleOwnerController.text,
          "start_date": vehicleStartDate,
          "end_date": vehicleEndeDate,
          "log_book_number": vehicleLogBookController.text
        },
        if(vehicleInformation.value)"company_vehicle_id": vehicleType!.id,
      };

      // 🧠 Step 3: Convert each row into JSON string (to preserve structure)
         if(vehicleInformation.value == false) {
        for (final action in rows) {
          final Map<String, dynamic> rowJson = {
            "${action.paramTitle!.toLowerCase()}_number": action.batchNo,
            "${action.paramTitle!.toLowerCase()}_expiry":
                DateFormat("yyyy-MM-dd")
                    .format(DateTime.parse(action.expiryDate.toString())),
            "${action.paramTitle!.toLowerCase()}_expiry_time": action.expiryTime!.text,
          };

          // 🔹 Encode to JSON string so it doesn't flatten
          baseData[action.paramTitle.toString()] = jsonEncode(rowJson);
        }

        // 🖼️ Step 4: Merge image files
        baseData.addAll(rowsImageList);
      }


         print(shiftList);
      if(shiftList.isNotEmpty){
        List<Map<String, dynamic>> allShifts = [];

        for (final action in shiftList) {
          final Map<String, dynamic> rowJson = {
            "name": action.shiftTitle,
            "start_time": action.startTime,
            "end_time": action.endTime,
          };

          allShifts.add(rowJson);
        }
        baseData["shifts"] = jsonEncode(allShifts);
      }

      if(noteList.isNotEmpty){
        List<Map<String, dynamic>> allNotes = [];

        for (final action in noteList) {
          final Map<String, dynamic> rowJson = {
            "note": action.notesTitle,
            "created_at": action.createdItTime,
            "created_by": action.createdByTime,
          };

          allNotes.add(rowJson);
        }

        baseData["notes"] = jsonEncode(allNotes);
      }

      // 📦 Step 5: Create FormData
      final formData = dio.FormData.fromMap(baseData);

      // 🧭 Debug log
      print("✅ Final FormData:");
      formData.fields.forEach((field) {
        print("${field.key}: ${field.value}");
      });

      var response = await Api().post(formData, "drivers/add", multiPart: true);
      if (response.statusCode == 200) {
        clearAddDriverData();
        BotToast.showText(text: response.data['message']);
      }
    } catch (e, stack) {
      print("❌ Error in addDriverFtn: $e");
      print(stack);
    }
  }


  clearAddDriverData() async{
    driverRendLimitController.clear();
    driverBalanceController.clear();
    driverAddressController.clear();
    vehicleNameController.clear();
    vehicleMakeController.clear();
    vehicleModelController.clear();
    vehicleColorController.clear();
    vehicleOwnerController.clear();
    driverUserNameController.clear();
    driverPasswordController.clear();
    driverFullNameController.clear();
    driverEmailController.clear();
    driverMobileController.clear();
    driverTelController.clear();
    driverCommissionController.clear();
    driverNLController.clear();
    hasPDA.value = false;
    rentPaid.value = false;
    isActive.value = false;
    vehicleInformation.value = false;
    shiftList.clear();
    noteList.clear();
    companyType = null;
    driverType = null;
    vehicleType = null;
    profileImg = null;
    vehicleInformation.value = false;
    imageList.clear();
    for (var action in rows) {
      action.fileName = null;
    }
    update();
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create driver form functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver list screen

  /// ye bool batata hai ke active drivers chahiye ya nahi
  RxBool activeDrivers = false.obs;
  GetDriverModel? listDriverModel;
  RxBool driverLoading = false.obs;
  var driverCurrentPage = 1.obs;
  var driverTotalPage = 1.obs;
  final int driverLimit = 15;

  RxList<Driver> driverAll = <Driver>[].obs;
  RxList<Driver> driverFilter = <Driver>[].obs;
  RxString searchDriverName = ''.obs;
  RxString searchDriverUserName = ''.obs;
  RxString searchVehicleName = ''.obs;
  RxString searchDriverExpiry = ''.obs;
  RxString searchVehicleExpiry = ''.obs;
  RxString searchMOTExpiry = ''.obs;
  RxString searchMOT2Expiry = ''.obs;
  RxString searchInsuranceExpiry = ''.obs;
  RxString searchLicenseExpiry = ''.obs;
  RxString searchMobile = ''.obs;
  RxString searchSubsiDiary = ''.obs;

  Future<void> getDriverList() async {
    try {
      driverLoading.value = true;

   

      final response = await Api().get('drivers/get?',
      queryParameters: {
        'active': activeDrivers.value,
        'limit': driverLimit,
        "name" : searchDriverName.value.toLowerCase(),
        "username" : searchDriverUserName.value.toLowerCase(),
        "vehicle_type" : searchVehicleName.value.toLowerCase(),
        "driver_end_date" : searchDriverExpiry.value.toLowerCase(),
        "vehicle_end_date" : searchVehicleExpiry.value.toLowerCase(),
        "mot_expiry" : searchMOTExpiry.value.toLowerCase(),
        "mot2_expiry" : searchMOT2Expiry.value.toLowerCase(),
        "insurance_expiry" : searchInsuranceExpiry.value.toLowerCase(),
        "licence_expiry" : searchLicenseExpiry.value.toLowerCase(),
        "mobile" : searchMobile.value.toLowerCase(),
        "subsidiary" : searchSubsiDiary.value.toLowerCase(),
      }
      );
      if (response.statusCode == 200) {
        listDriverModel = GetDriverModel.fromJson(response.data);
        driverTotalPage.value = listDriverModel?.totalPages ?? 1;
        driverAll.value = listDriverModel?.drivers ?? [];
        driverFilter.value = driverAll;
        print('✅ Driver Data Loaded Successfully');
        print('API  ${response.statusCode}');
      } 
    } catch (e) {
      print("⚠️ Error in getDriverList : $e");
    } finally {
      driverLoading.value = false;
      update(); 
    }
  }
  void driverSearch() {
    driverCurrentPage.value = 1;
    getDriverList();
  }
  void driverPage(int page) {
    driverCurrentPage.value = page;
    getDriverList();
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver list screen

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver list screen and login drivers screen functionality
  RxBool loggedOut = false.obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver list screen and login drivers screen functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER APP FEATURES screen functionality

  /// RxBool variable
  RxBool selectAllDrivers = false.obs;
  RxBool showCustomerValue = false.obs;
  RxBool enableCustomerValue = false.obs;
  RxBool enableFlagDownValue = false.obs;
  RxBool showAccountFareValue = false.obs;
  RxBool hideBreakValue = false.obs;
  RxBool hideDeclineValue = false.obs;
  RxBool hideRecoverValue = false.obs;
  RxBool hideNoPickUpValue = false.obs;
  RxBool hidePickUpValue = false.obs;
  RxBool hideDropOffValue = false.obs;
  RxBool fareMeterValue = false.obs;
  RxBool diableFareMeterValue = false.obs;
  RxBool fareMeterWaitingValue = false.obs;
  RxBool payByCardValue = false.obs;
  RxBool waitingAfterArrivalValue = false.obs;
  RxBool disablePanicButtonValue = false.obs;
  RxBool showCompleteJobValue = false.obs;
  RxBool showNavigationValue = false.obs;
  RxBool showSwipeArriveValue = false.obs;
  RxBool shawFareValue = false.obs;
  RxBool hasCompanyCarValue = false.obs;
  RxBool hidePaymentTypeValue = false.obs;
  RxBool enableTollChargesValue = false.obs;

  /// TextEditingControllers
  final bookingTimerController = TextEditingController();
  final imeController = TextEditingController();
  final modelController = TextEditingController();
  final makeController = TextEditingController();
  final simNetworkController = TextEditingController();
  final simNumberController = TextEditingController();
  final networkProviderController = TextEditingController();
  final dataAllowanceController = TextEditingController();
  final pdaDepositController = TextEditingController();
  final commentsController = TextEditingController();
  final breakController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER APP FEATURES screen functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER Commission screen functionality

  /// TextEditingControllers
  final commissionController = TextEditingController();
  final pdaRentController = TextEditingController();

  /// RxBool variable
  RxBool ptValue = false.obs;
  RxBool cashValue = false.obs;
  RxBool creditCardValue = false.obs;
  RxBool accountValue = false.obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER Commission screen functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo BULK DRIVER COMMISSION functionality
  /// TextEditingControllers
  final emailSubjectController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo BULK DRIVER COMMISSION functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER COMMISSION PAY functionality

  /// RxBool variable
  final creditValue = ValueNotifier<bool>(false);
  final debitValue = ValueNotifier<bool>(false);

  /// TextEditingControllers
  final commissionDueController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER COMMISSION PAY functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER SIN BIN SETTINGS functionality

  /// TextEditingControllers
  final recoverJobController = TextEditingController();
  final rejectJobController = TextEditingController();
  final ignoreJobController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER SIN BIN SETTINGS functionality
}

// class DriverBindings implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<DriverController>(() => DriverController());
//   }
// }
