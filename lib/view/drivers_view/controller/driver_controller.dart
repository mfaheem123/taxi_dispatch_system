import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/drivers_view/model/list_drivers_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:intl/intl.dart';

import '../../../Model/driver_models/driver_model.dart' hide Driver;
import 'package:file_picker/file_picker.dart';

import '../../../Model/driver_models/single_driver_model.dart' as singleDriver;
import '../../../Model/image_model.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
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
        batchNo: TextEditingController(),
        documentTitle: "PHC VEHICLE",
        paramTitle: "PHC_VEHICLE",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: TextEditingController(),
        documentTitle: "PHC DRIVER",
        paramTitle: "PHC_DRIVER",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: TextEditingController(),
        documentTitle: "MOT",
        paramTitle: "MOT",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: TextEditingController(),
        documentTitle: "MOT 2",
        paramTitle: "MOT2",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: TextEditingController(),
        documentTitle: "INSURANCE",
        paramTitle: "INSURANCE",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: TextEditingController(),
        documentTitle: "LICENSE",
        paramTitle: "LICENCE",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: TextEditingController(),
        documentTitle: "ROAD TAX",
        paramTitle: "ROAD_TAX",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: TextEditingController(),
        documentTitle: "V5 REGISTRATION",
        paramTitle: "V5_REGISTRATION",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
    DocumentRow(
        batchNo: TextEditingController(),
        documentTitle: "RENTAL AGREEMENT",
        paramTitle: "RENTAL_AGREEMENT",
        expiryDate: DateFormat("yyyy-MM-dd")
            .parse(DateFormat("yyyy-MM-dd").format(DateTime.now())),
        expiryTime: TextEditingController(text: "09:08 AM")),
  ].obs;

  // void addEmptyRow() {
  //   rows.add(DocumentRow());
  // }

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
  getCombineVehicle({id}) async {
    getCombineVehicleLoading(true);
    var response = await Api().get("driver-combine/get");
    if (response.statusCode == 200) {
      getCombineVehicleData = DriverFormModel.fromJson(response.data);
      if(id != null){
        driverDataBinding(id);
      }
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
          if (action.fileName != null && action.fileName!.bytes.isNotEmpty) {
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
       if(profileImage != null) "image": profileImage,
       if(docImages != null) "log_book_document": docImages,
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
            "${action.paramTitle!.toLowerCase()}_number": action.batchNo.text,
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
      var response = await Api().post(formData,
          singleDriverData != null?
         "drivers/edit/${singleDriverData!.driver!.id}":
          "drivers/add", multiPart: true);
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
    singleDriverData = null;
    driverType = null;
    vehicleType = null;
    profileImg = null;
    selectCompanyVehicle = null;
    vehicleInformation.value = false;
    imageList.clear();
    for (var action in rows) {
      action.fileName = null;
    }
    update();
  }


  singleDriver.SingleDriverModel? singleDriverData;
  RxBool driverDataBindingLoading = false.obs;
  driverDataBinding(id) async{
    driverDataBindingLoading(true);
    var response = await Api().get("drivers/getbyid/$id");
    if(response.statusCode == 200){
      print(response.data);
      singleDriverData = singleDriver.SingleDriverModel.fromJson(response.data);
      ///todo hit for to assign dropdown data
      ///todo hit for to assign dropdown data
      if(singleDriverData!.driver!.rentLimit != null){
        driverRendLimitController.text = singleDriverData!.driver!.rentLimit!;
      }

      if(singleDriverData!.driver!.balance != null){
        driverBalanceController.text =
            singleDriverData!.driver!.balance.toString();
      }

     if(singleDriverData!.driver!.address != null) {
        driverAddressController.text =
            singleDriverData!.driver!.address.toString();
      }

      if(singleDriverData!.driver!.useCompanyVehicle == false){
        if(singleDriverData!.driver!.vehicle!.vehicleNumber != null){
          vehicleNameController.text =
              singleDriverData!.driver!.vehicle!.vehicleNumber.toString();
        }

        if(singleDriverData!.driver!.vehicle!.make != null){
          vehicleMakeController.text =
              singleDriverData!.driver!.vehicle!.make.toString();
        }

        if(singleDriverData!.driver!.vehicle!.model != null){
        vehicleModelController.text =
            singleDriverData!.driver!.vehicle!.model.toString();
        }

        if(singleDriverData!.driver!.vehicle!.color != null){
        vehicleColorController.text =
            singleDriverData!.driver!.vehicle!.color.toString();
        }

        if(singleDriverData!.driver!.vehicle!.owner != null){
        vehicleOwnerController.text =
            singleDriverData!.driver!.vehicle!.owner.toString();
        }

        if( singleDriverData!.driver!.vehicle!.logBook!.logBookNumber != null){
          vehicleLogBookController.text = singleDriverData!
              .driver!.vehicle!.logBook!.logBookNumber
              .toString();
        }

        int index = getCombineVehicleData!.vehicleTypes!.indexWhere((test) => test.id == singleDriverData!.driver!.vehicle!.vehicleTypeId!);
        selectCompanyVehicle = getCombineVehicleData!.vehicleTypes![index];
        for (var action in rows) {
          if(action.documentTitle == "PHC VEHICLE"){
            action.expiryDate = DateTime.parse(singleDriverData!.driver!.vehicle!.phcVehicle!.phcVehicleExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!.phcVehicle!.phcVehicleExpiryTime ?? "";
            action.batchNo.text = singleDriverData!.driver!.vehicle!.phcVehicle!.phcVehicleNumber??"";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.phcVehicle!.phcVehicleDocument!;
          }else if (action.documentTitle == "PHC DRIVER"){
            action.expiryDate = DateTime.parse(singleDriverData!.driver!.vehicle!.phcDriver!.phcDriverExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!.phcDriver!.phcDriverExpiryTime ?? "";
            action.batchNo.text = singleDriverData!.driver!.vehicle!.phcDriver!.phcDriverNumber??"";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.phcDriver!.phcDriverDocument!;
          }else if (action.documentTitle == "MOT"){
            action.expiryDate = DateTime.parse(singleDriverData!.driver!.vehicle!.mot!.motExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!.mot!.motExpiryTime ?? "";
            action.batchNo.text = singleDriverData!.driver!.vehicle!.mot!.motNumber??"";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.mot!.motDocument!;
          }else if (action.documentTitle == "MOT 2"){
            action.expiryDate = DateTime.parse(singleDriverData!.driver!.vehicle!.mot2!.mot2Expiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!.mot2!.mot2ExpiryTime ?? "";
            action.batchNo.text = singleDriverData!.driver!.vehicle!.mot2!.mot2Number??"";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.mot2!.mot2Document!;
          }else if (action.documentTitle == "INSURANCE"){
            action.expiryDate = DateTime.parse(singleDriverData!.driver!.vehicle!.insurance!.insuranceExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!.insurance!.insuranceExpiryTime ?? "";
            action.batchNo.text = singleDriverData!.driver!.vehicle!.insurance!.insuranceNumber??"";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.insurance!.insuranceDocument!;
          }else if (action.documentTitle == "LICENSE"){
            action.expiryDate = DateTime.parse(singleDriverData!.driver!.vehicle!.licence!.licenceExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!.licence!.licenceExpiryTime ?? "";
            action.batchNo.text = singleDriverData!.driver!.vehicle!.licence!.licenceNumber??"";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.licence!.licenceDocument!;
          }else if (action.documentTitle == "ROAD TAX"){
            action.expiryDate = DateTime.parse(singleDriverData!.driver!.vehicle!.roadTax!.roadTaxExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!.roadTax!.roadTaxExpiryTime ?? "";
            action.batchNo.text = singleDriverData!.driver!.vehicle!.roadTax!.roadTaxNumber??"";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.roadTax!.roadTaxDocument!;
          }else if (action.documentTitle == "V5 REGISTRATION"){
            action.expiryDate = DateTime.parse(singleDriverData!.driver!.vehicle!.v5Registration!.v5RegistrationExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!.v5Registration!.v5RegistrationExpiryTime ?? "";
            action.batchNo.text = singleDriverData!.driver!.vehicle!.v5Registration!.v5RegistrationNumber??"";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.v5Registration!.v5RegistrationDocument!;
          }else{
            action.expiryDate = DateTime.parse(singleDriverData!.driver!.vehicle!.rentalAgreement!.rentalAgreementExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!.rentalAgreement!.rentalAgreementExpiryTime ?? "";
            action.batchNo.text = singleDriverData!.driver!.vehicle!.rentalAgreement!.rentalAgreementNumber??"";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.rentalAgreement!.rentalAgreementDocument!;
          }
        }
      }else{
        // selectCompanyVehicle = null;
        int indexx = getCombineVehicleData!.companyVehicles!.indexWhere((test) => test.id == singleDriverData!.driver!.companyVehicleId);
        vehicleType = getCombineVehicleData!.companyVehicles![indexx];
      }
      if(singleDriverData!.driver!.username != null){
        driverUserNameController.text =
            singleDriverData!.driver!.username.toString();
      }
      if(singleDriverData!.driver!.password != null){
        driverPasswordController.text =
            singleDriverData!.driver!.password.toString();
      }
      if(singleDriverData!.driver!.name != null){
        driverFullNameController.text =
            singleDriverData!.driver!.name.toString();
      }
      if(singleDriverData!.driver!.email != null){
        driverEmailController.text = singleDriverData!.driver!.email.toString();
      }
      if(singleDriverData!.driver!.mobile != null){
        driverMobileController.text =
            singleDriverData!.driver!.mobile.toString();
      }
      if(singleDriverData!.driver!.telephone != null){
        driverTelController.text =
            singleDriverData!.driver!.telephone.toString();
      }
      if(singleDriverData!.driver!.driverCommission !=null){
        driverCommissionController.text =
            singleDriverData!.driver!.driverCommission.toString();
      }
      if(singleDriverData!.driver!.ni !=null){
        driverNLController.text = singleDriverData!.driver!.ni.toString();
      }
      driverType = singleDriverData!.driver!.driverType.toString();
      hasPDA.value = singleDriverData!.driver!.hasPda!;
      rentPaid.value = singleDriverData!.driver!.rentPaid!;
      isActive.value = singleDriverData!.driver!.active!;
      vehicleInformation.value = singleDriverData!.driver!.useCompanyVehicle!;
      int companyTypeIndex = getCombineVehicleData!.subsidiaries!.indexWhere((test) => test.id == singleDriverData!.driver!.subsidiaryId);
      companyType = getCombineVehicleData!.subsidiaries![companyTypeIndex];

      print(singleDriverData!.driver);
      if(singleDriverData!.driver!.shifts!.isNotEmpty){
        for (var action in singleDriverData!.driver!.shifts!) {
          shiftList.add(ShiftAlertClass(
            startTime: action.startTime,
            endTime: action.endTime,
            shiftTitle: action.name,
          ));
        }
      }

      if(singleDriverData!.driver!.notes!.isNotEmpty){
        for (var action in singleDriverData!.driver!.notes!) {
          noteList.add(NoteAlertClass(
            notesTitle: action.note,
            createdByTime:
                "${action.createdAt!.day}-${action.createdAt!.month}-${action.createdAt!.year}",
            createdItTime: action.createdBy,
          ));
        }
      }

      final DashboardController _controller = Get.find();
      int index = _controller
          .selectedMenuItems
          .indexWhere((element) =>
      element.title ==
          "ADD DRIVER");
      if (index != -1) {
        _controller
            .selectedMenuItems[index]
            .selectedItem = true;
        _controller.currentPage.value =
            DriverForm(driverUpdateFlow: true,);
      } else {
        _controller.currentPage.value =
            DriverForm(driverUpdateFlow: true,);
        _controller.menuBarRefresh(
            title: "ADD DRIVER",
            pageName: DriverForm());
      }

      driverDataBindingLoading(false);
      update();
    }
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create driver form functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver list screen

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
      final response = await Api().get(auth: true, 'drivers/get?',
      queryParameters: {
        'active': activeDrivers.value == true?false:true,
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
        print('Driver Data Loaded Successfully');
        print('API  ${response.statusCode}');
      } 
    } catch (e) {
      print("Error in getDriverList : $e");
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


//------------------------------------------------------------------------- Delete

  deleteDriver(int? id) async {
    var response = await Api().delete("drivers/delete/$id");
    if (response.statusCode == 200) {
      getDriverList();
      print("Driver deleted successfully!");
      print(json.encode(response.data));
    }
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
