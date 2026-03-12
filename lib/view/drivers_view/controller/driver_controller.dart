import 'dart:convert';
import 'dart:io';
import 'dart:math';

// import 'package:flutter/material.dart' hide Column, Row, Text, EdgeInsets, Alignment, Center, SizedBox, Table, Context;
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/drivers_view/model/driver_commission_filter_model.dart';
import 'package:dashboard_new1/view/drivers_view/model/list_drivers_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:excel/excel.dart';
import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';


import '../../../Model/driver_models/driver_model.dart' hide Driver;
import 'package:file_picker/file_picker.dart';

import '../../../Model/driver_models/single_driver_model.dart' as singleDriver;
import '../../../Model/image_model.dart';
import '../../../component/color.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../driver/create_driver_form/driver_form.dart';
import '../model/create_driver_rent_model.dart';
import '../model/driver_commission_alert_model.dart';
import '../model/driver_commission_payment_model.dart';
import '../model/driver_commission_model.dart';
import '../model/driver_form_model.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;

import '../model/driver_rent_filter_model.dart';
import '../model/list_driver_commission_model.dart';
import '../model/update_driver_commission_model.dart';

class DriverController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create driver form functionality

  /// RxBool variable
  RxBool hasPDA = false.obs;
  RxBool rentPaid = false.obs;
  RxBool isActive = false.obs;
  RxBool vehicleInformation = false.obs;

  String? driverType;
  String? dobDate =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
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
        imageList.insert(
            0,
            ImageModel(
                name: result.files.single.name,
                bytes: result.files.single.bytes!,
                path: result.files.single.path));
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
      if (id != null) {
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

      if (profileImg != null) {
        profileImage = await dio.MultipartFile.fromBytes(
          profileImg!.bytes,
          filename: profileImg!.name,
        );
      }

      if (vehicleInformation.value == false) {
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

      if (imageList.isNotEmpty) {
        docImages = await dio.MultipartFile.fromBytes(
          imageList[0].bytes,
          filename: imageList[0].name,
        );
      }

      // 🧾 Step 2: Prepare base data (normal form fields)
      final Map<String, dynamic> baseData = {
        if (profileImage != null) "image": profileImage,
        if (docImages != null) "log_book_document": docImages,
        "has_pda": hasPDA.value,
        "rent_paid": rentPaid.value,
        "active": isActive.value,
        if (companyType != null) "subsidiary_id": companyType!.id,
        "username": driverUserNameController.text.trim(),
        "password": driverPasswordController.text.trim(),
        "name": driverFullNameController.text.trim(),
        "dob": dobDate,
        "email": driverEmailController.text.trim(),
        "mobile": driverMobileController.text.trim(),
        "telephone": driverTelController.text.trim(),
        if (driverType != null) "driver_type": driverType,
        "driver_commission": driverCommissionController.text.trim(),
        "rent_limit": driverRendLimitController.text.trim(),
        "balance": driverBalanceController.text.trim(),
        "address": driverAddressController.text.trim(),
        "use_company_vehicle": vehicleInformation.value,
        "start_date":
            "${startDate!.year}-${startDate!.month}-${startDate!.day}",
        "end_date": "${endDate!.year}-${endDate!.month}-${endDate!.day}",
        "ni": driverNLController.text.trim(),
        if (noteList.isNotEmpty) "notes": noteList,
        if (vehicleInformation.value == false)
          "vehicle": {
            if (selectCompanyVehicle != null)
              "vehicle_type_id": selectCompanyVehicle!.id,
            "vehicle_number": vehicleNameController.text,
            "make": vehicleMakeController.text,
            "model": vehicleModelController.text,
            "color": vehicleColorController.text,
            "owner": vehicleOwnerController.text,
            "start_date": vehicleStartDate,
            "end_date": vehicleEndeDate,
            "log_book_number": vehicleLogBookController.text
          },
        if (vehicleInformation.value) "company_vehicle_id": vehicleType!.id,
      };

      // 🧠 Step 3: Convert each row into JSON string (to preserve structure)
      if (vehicleInformation.value == false) {
        for (final action in rows) {
          final Map<String, dynamic> rowJson = {
            "${action.paramTitle!.toLowerCase()}_number": action.batchNo.text,
            "${action.paramTitle!.toLowerCase()}_expiry":
                DateFormat("yyyy-MM-dd")
                    .format(DateTime.parse(action.expiryDate.toString())),
            "${action.paramTitle!.toLowerCase()}_expiry_time":
                action.expiryTime!.text,
          };

          // 🔹 Encode to JSON string so it doesn't flatten
          baseData[action.paramTitle.toString()] = jsonEncode(rowJson);
        }

        // 🖼️ Step 4: Merge image files
        baseData.addAll(rowsImageList);
      }

      print(shiftList);
      if (shiftList.isNotEmpty) {
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

      if (noteList.isNotEmpty) {
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
      var response = await Api().post(
          formData,
          singleDriverData != null
              ? "drivers/edit/${singleDriverData!.driver!.id}"
              : "drivers/add",
          multiPart: true);
      if (response.statusCode == 200) {
        clearAddDriverData();
        BotToast.showText(text: response.data['message']);
      }
    } catch (e, stack) {
      print("❌ Error in addDriverFtn: $e");
      print(stack);
    }
  }

  clearAddDriverData() async {
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

  driverDataBinding(id) async {
    driverDataBindingLoading(true);
    var response = await Api().get("drivers/getbyid/$id");
    if (response.statusCode == 200) {
      print(response.data);
      singleDriverData = singleDriver.SingleDriverModel.fromJson(response.data);

      ///todo hit for to assign dropdown data
      ///todo hit for to assign dropdown data
      if (singleDriverData!.driver!.rentLimit != null) {
        driverRendLimitController.text = singleDriverData!.driver!.rentLimit!;
      }

      if (singleDriverData!.driver!.balance != null) {
        driverBalanceController.text =
            singleDriverData!.driver!.balance.toString();
      }

      if (singleDriverData!.driver!.address != null) {
        driverAddressController.text =
            singleDriverData!.driver!.address.toString();
      }

      if (singleDriverData!.driver!.useCompanyVehicle == false) {
        if (singleDriverData!.driver!.vehicle!.vehicleNumber != null) {
          vehicleNameController.text =
              singleDriverData!.driver!.vehicle!.vehicleNumber.toString();
        }

        if (singleDriverData!.driver!.vehicle!.make != null) {
          vehicleMakeController.text =
              singleDriverData!.driver!.vehicle!.make.toString();
        }

        if (singleDriverData!.driver!.vehicle!.model != null) {
          vehicleModelController.text =
              singleDriverData!.driver!.vehicle!.model.toString();
        }

        if (singleDriverData!.driver!.vehicle!.color != null) {
          vehicleColorController.text =
              singleDriverData!.driver!.vehicle!.color.toString();
        }

        if (singleDriverData!.driver!.vehicle!.owner != null) {
          vehicleOwnerController.text =
              singleDriverData!.driver!.vehicle!.owner.toString();
        }

        if (singleDriverData!.driver!.vehicle!.logBook!.logBookNumber != null) {
          vehicleLogBookController.text = singleDriverData!
              .driver!.vehicle!.logBook!.logBookNumber
              .toString();
        }

        int index = getCombineVehicleData!.vehicleTypes!.indexWhere((test) =>
            test.id == singleDriverData!.driver!.vehicle!.vehicleTypeId!);
        selectCompanyVehicle = getCombineVehicleData!.vehicleTypes![index];
        for (var action in rows) {
          if (action.documentTitle == "PHC VEHICLE") {
            action.expiryDate = DateTime.parse(singleDriverData!
                .driver!.vehicle!.phcVehicle!.phcVehicleExpiry!);
            action.expiryTime.text = singleDriverData!
                    .driver!.vehicle!.phcVehicle!.phcVehicleExpiryTime ??
                "";
            action.batchNo.text = singleDriverData!
                    .driver!.vehicle!.phcVehicle!.phcVehicleNumber ??
                "";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.phcVehicle!.phcVehicleDocument!;
          } else if (action.documentTitle == "PHC DRIVER") {
            action.expiryDate = DateTime.parse(
                singleDriverData!.driver!.vehicle!.phcDriver!.phcDriverExpiry!);
            action.expiryTime.text = singleDriverData!
                    .driver!.vehicle!.phcDriver!.phcDriverExpiryTime ??
                "";
            action.batchNo.text =
                singleDriverData!.driver!.vehicle!.phcDriver!.phcDriverNumber ??
                    "";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.phcDriver!.phcDriverDocument!;
          } else if (action.documentTitle == "MOT") {
            action.expiryDate = DateTime.parse(
                singleDriverData!.driver!.vehicle!.mot!.motExpiry!);
            action.expiryTime.text =
                singleDriverData!.driver!.vehicle!.mot!.motExpiryTime ?? "";
            action.batchNo.text =
                singleDriverData!.driver!.vehicle!.mot!.motNumber ?? "";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.mot!.motDocument!;
          } else if (action.documentTitle == "MOT 2") {
            action.expiryDate = DateTime.parse(
                singleDriverData!.driver!.vehicle!.mot2!.mot2Expiry!);
            action.expiryTime.text =
                singleDriverData!.driver!.vehicle!.mot2!.mot2ExpiryTime ?? "";
            action.batchNo.text =
                singleDriverData!.driver!.vehicle!.mot2!.mot2Number ?? "";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.mot2!.mot2Document!;
          } else if (action.documentTitle == "INSURANCE") {
            action.expiryDate = DateTime.parse(
                singleDriverData!.driver!.vehicle!.insurance!.insuranceExpiry!);
            action.expiryTime.text = singleDriverData!
                    .driver!.vehicle!.insurance!.insuranceExpiryTime ??
                "";
            action.batchNo.text =
                singleDriverData!.driver!.vehicle!.insurance!.insuranceNumber ??
                    "";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.insurance!.insuranceDocument!;
          } else if (action.documentTitle == "LICENSE") {
            action.expiryDate = DateTime.parse(
                singleDriverData!.driver!.vehicle!.licence!.licenceExpiry!);
            action.expiryTime.text =
                singleDriverData!.driver!.vehicle!.licence!.licenceExpiryTime ??
                    "";
            action.batchNo.text =
                singleDriverData!.driver!.vehicle!.licence!.licenceNumber ?? "";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.licence!.licenceDocument!;
          } else if (action.documentTitle == "ROAD TAX") {
            action.expiryDate = DateTime.parse(
                singleDriverData!.driver!.vehicle!.roadTax!.roadTaxExpiry!);
            action.expiryTime.text =
                singleDriverData!.driver!.vehicle!.roadTax!.roadTaxExpiryTime ??
                    "";
            action.batchNo.text =
                singleDriverData!.driver!.vehicle!.roadTax!.roadTaxNumber ?? "";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.roadTax!.roadTaxDocument!;
          } else if (action.documentTitle == "V5 REGISTRATION") {
            action.expiryDate = DateTime.parse(singleDriverData!
                .driver!.vehicle!.v5Registration!.v5RegistrationExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!
                    .v5Registration!.v5RegistrationExpiryTime ??
                "";
            action.batchNo.text = singleDriverData!
                    .driver!.vehicle!.v5Registration!.v5RegistrationNumber ??
                "";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.v5Registration!.v5RegistrationDocument!;
          } else {
            action.expiryDate = DateTime.parse(singleDriverData!
                .driver!.vehicle!.rentalAgreement!.rentalAgreementExpiry!);
            action.expiryTime.text = singleDriverData!.driver!.vehicle!
                    .rentalAgreement!.rentalAgreementExpiryTime ??
                "";
            action.batchNo.text = singleDriverData!
                    .driver!.vehicle!.rentalAgreement!.rentalAgreementNumber ??
                "";
            // action.fileName!.name = singleDriverData!.driver!.vehicle!.rentalAgreement!.rentalAgreementDocument!;
          }
        }
      } else {
        // selectCompanyVehicle = null;
        int indexx = getCombineVehicleData!.companyVehicles!.indexWhere(
            (test) => test.id == singleDriverData!.driver!.companyVehicleId);
        vehicleType = getCombineVehicleData!.companyVehicles![indexx];
      }
      if (singleDriverData!.driver!.username != null) {
        driverUserNameController.text =
            singleDriverData!.driver!.username.toString();
      }
      if (singleDriverData!.driver!.password != null) {
        driverPasswordController.text =
            singleDriverData!.driver!.password.toString();
      }
      if (singleDriverData!.driver!.name != null) {
        driverFullNameController.text =
            singleDriverData!.driver!.name.toString();
      }
      if (singleDriverData!.driver!.email != null) {
        driverEmailController.text = singleDriverData!.driver!.email.toString();
      }
      if (singleDriverData!.driver!.mobile != null) {
        driverMobileController.text =
            singleDriverData!.driver!.mobile.toString();
      }
      if (singleDriverData!.driver!.telephone != null) {
        driverTelController.text =
            singleDriverData!.driver!.telephone.toString();
      }
      if (singleDriverData!.driver!.driverCommission != null) {
        driverCommissionController.text =
            singleDriverData!.driver!.driverCommission.toString();
      }
      if (singleDriverData!.driver!.ni != null) {
        driverNLController.text = singleDriverData!.driver!.ni.toString();
      }
      driverType = singleDriverData!.driver!.driverType.toString();
      hasPDA.value = singleDriverData!.driver!.hasPda!;
      rentPaid.value = singleDriverData!.driver!.rentPaid!;
      isActive.value = singleDriverData!.driver!.active!;
      vehicleInformation.value = singleDriverData!.driver!.useCompanyVehicle!;
      int companyTypeIndex = getCombineVehicleData!.subsidiaries!.indexWhere(
          (test) => test.id == singleDriverData!.driver!.subsidiaryId);
      companyType = getCombineVehicleData!.subsidiaries![companyTypeIndex];

      print(singleDriverData!.driver);
      if (singleDriverData!.driver!.shifts!.isNotEmpty) {
        for (var action in singleDriverData!.driver!.shifts!) {
          shiftList.add(ShiftAlertClass(
            startTime: action.startTime,
            endTime: action.endTime,
            shiftTitle: action.name,
          ));
        }
      }

      if (singleDriverData!.driver!.notes!.isNotEmpty) {
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
      int index = _controller.selectedMenuItems
          .indexWhere((element) => element.title == "ADD DRIVER");
      if (index != -1) {
        _controller.selectedMenuItems[index].selectedItem = true;
        _controller.currentPage.value = DriverForm(
          driverUpdateFlow: true,
        );
      } else {
        _controller.currentPage.value = DriverForm(
          driverUpdateFlow: true,
        );
        _controller.menuBarRefresh(title: "ADD DRIVER", pageName: DriverForm());
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
      final response =
          await Api().get(auth: true, 'drivers/get?', queryParameters: {
        'active': activeDrivers.value == true ? false : true,
        'limit': driverLimit,
        "name": searchDriverName.value.toLowerCase(),
        "username": searchDriverUserName.value.toLowerCase(),
        "vehicle_type": searchVehicleName.value.toLowerCase(),
        "driver_end_date": searchDriverExpiry.value.toLowerCase(),
        "vehicle_end_date": searchVehicleExpiry.value.toLowerCase(),
        "mot_expiry": searchMOTExpiry.value.toLowerCase(),
        "mot2_expiry": searchMOT2Expiry.value.toLowerCase(),
        "insurance_expiry": searchInsuranceExpiry.value.toLowerCase(),
        "licence_expiry": searchLicenseExpiry.value.toLowerCase(),
        "mobile": searchMobile.value.toLowerCase(),
        "subsidiary": searchSubsiDiary.value.toLowerCase(),
      });
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
  final UpdateCommissionController = TextEditingController();
  final pdaRentController = TextEditingController();
  final UpdatePdaRentController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  TextEditingController driverSelectionController = TextEditingController();
  TextEditingController updateDriverSelectionController =
      TextEditingController();
  String transactionDate = "";

  Set<String> selectedIds = {};

  @override
  void onInit() {
    super.onInit();
    driverSelectionController.addListener(() {
      autoFillDriverDetails(driverSelectionController.text);
    });
    rentDriverSelectionController.addListener(() {
      fillDriverDetails(rentDriverSelectionController.text);
    });
  }

  /// RxBool variable
  RxBool ptValue = false.obs;
  RxBool cashValue = false.obs;
  RxBool creditCardValue = false.obs;
  RxBool accountValue = false.obs;

  /// drop down API

  ListDriverCommissionModel? listDriverCommission;
  CreateDriverCommission? createDriverCommission;
  bool isCreateDriverCommission = false;

  void resetCreateFields() {
    cashTotalValue = 0.0;
    accountFareTotalVar = 0.0;
    grandTotalVar = 0.0;
    parkingCongestionVar = 0.0;
    totalCommissionVar = 0.0;
    owedVar = 0.0;
    newBalanceVar = 0.0;
    accountWOCmmVar = 0.0;
    oldBalanceVar = 0.0;

    driverSelectionController.clear();
    commissionController.clear();
    pdaRentController.clear();
    fromDateController.clear();
    toDateController.clear();

    selectedIds.clear();
    selectedPaymentTypeIds.clear();
    filterData = null;

    transactionDate = "";
    filterFromDate = "";
    filterToDate = "";

    update();
  }

  getCreateDriverCommission() async {
    resetCreateFields();
    isCreateDriverCommission = true;
    update();
    var response = await Api()
        .get("drivers/commission?active=true&driver_type=Commission");
    if (response.statusCode == 200) {
      print("API Response: ${response.data}");
      listDriverCommission = ListDriverCommissionModel.fromJson(response.data);

      oldBalanceVar = 0.0;
      // driverSelectionController.clear();
      // commissionController.clear();
      // pdaRentController.clear();
    }
    isCreateDriverCommission = false;
    update();
  }

  double oldBalanceVar = 0.0;

  void autoFillDriverDetails(String selectedText) {
    if (selectedText.isEmpty) return;
    final driver = listDriverCommission?.drivers?.firstWhere(
      (d) => "${d.id} ${d.name}".toUpperCase() == selectedText.toUpperCase(),
      // orElse: () => null,
    );

    if (driver != null) {
      commissionController.text = driver.driverCommission ?? "0";
      pdaRentController.text = driver.pdaRent ?? "0";
      oldBalanceVar = double.tryParse(driver.balance?.toString() ?? "0") ?? 0.0;
      update();
    }
  }

  // checkboxes
  DriverCommissionPaymentModel? paymentTypesModel;
  List<int> selectedPaymentTypeIds = [];
  bool isLoadingPayments = false;

  getPaymentTypes() async {
    isLoadingPayments = true;
    update();

    var response = await Api().get("enumerations/payment-types");
    if (response.statusCode == 200) {
      paymentTypesModel = DriverCommissionPaymentModel.fromJson(response.data);
    }
    isLoadingPayments = false;
    update();
  }

  // Filter Button
  DriverCommissionFilterModel? filterData;
  Booking? bookings;
  String filterFromDate = "";
  String filterToDate = "";
  bool isFilterLoading = false;

  getDriverCommissionByFilter() async {
    isFilterLoading = true;
    update();

    String dId = driverSelectionController.text.split(" ").first;
    String pIds = selectedPaymentTypeIds.isNotEmpty
        ? "[${selectedPaymentTypeIds.join(",")}]"
        : "";

    var response = await Api().get(
      "bookings/driver-commission",
      queryParameters: {
        'driver_id': dId,
        'payment_type_id': pIds,
        'from_date': filterFromDate,
        'to_date': filterToDate,
      },
    );
    if (response.statusCode == 200) {
      filterData = DriverCommissionFilterModel.fromJson(response.data);
      if (filterData?.bookings != null) {
        for (var booking in filterData!.bookings!) {
          recalculateDriverCommissionRow(booking);
        }
      }
    }
    isFilterLoading = false;
    update();
  }

  /// Editable cell
  String calculateFinalDriverComm(dynamic booking) {
    if (booking.commission == false) {
      return "0.00";
    }

    double wComm = double.tryParse(calculateWithoutCommission(booking)) ?? 0.0;
    var drPct = booking is CommissionBooking
        ? (updateDriverCommissionByIdModel
                ?.driverCommission?.driver?.driverCommission ??
            0)
        : (booking.driver?.driverCommission ?? 0);

    double drValue = double.tryParse(drPct.toString()) ?? 0.0;
    return ((drValue / 100) * wComm).toStringAsFixed(2);
  }

  void recalculateDriverCommissionRow(dynamic booking) {
    double parse(dynamic value) =>
        double.tryParse(value?.toString() ?? "0") ?? 0.0;

    double f = parse(booking.fares);
    double pc = parse(booking.parkingCharges);
    double wc = parse(booking.waitingCharges);
    double edc = parse(booking.extraDropCharges);
    double cc = parse(booking.congestionCharges);

    double total = f + pc + wc + edc + cc;

    booking.totalCharges = total.toStringAsFixed(2);
    // calculateAllTotals();
    update();
  }

  String calculateWithoutCommission(dynamic booking) {
    double parse(dynamic value) =>
        double.tryParse(value?.toString() ?? "0") ?? 0.0;

    double f = parse(booking.fares);
    double wc = parse(booking.waitingCharges);
    double edc = parse(booking.extraDropCharges);

    double totalWithoutComm = f + wc + edc;
    return totalWithoutComm.toStringAsFixed(2);
  }

  updateBookingCharges(dynamic booking) async {
    var formData = {
      "fares": (booking.fares ?? "0").toString(),
      "parking_charges": (booking.parkingCharges ?? "0").toString(),
      "waiting_charges": (booking.waitingCharges ?? "0").toString(),
      "extra_drop_charges": (booking.extraDropCharges ?? "0").toString(),
      "congestion_charges": (booking.congestionCharges ?? "0").toString(),
      "total_charges": (booking.totalCharges ?? "0").toString(),
      // "meet_and_greet": "",
    };
    print("Sending Data: $formData");
    var response = await Api()
        .post(formData, "bookings/fare-charges/${booking.id}", auth: true);
    if (response.statusCode == 200) {
      calculateUpdateTotals();
      update();
      BotToast.showText(text: "charges Updated Successfully");
    }
  }

  double parseDouble(dynamic value) =>
      double.tryParse(value?.toString() ?? "0") ?? 0.0;

  double getCreateColumnTotal(String field) {
    if (selectedIds.isEmpty) return 0.0;

    final list = filterData?.bookings
            ?.where((b) => selectedIds.contains(b.id.toString()))
            .toList() ??
        [];

    return _calculateListTotal(list, field);
  }

  double getUpdateColumnTotal(String field) {
    final updateItems = updateDriverCommissionByIdModel
        ?.driverCommission?.driverCommissionLineitems;

    if (updateItems == null || updateItems.isEmpty) return 0.0;
    final list =
        updateItems.map((e) => e.booking).where((b) => b != null).toList();

    return _calculateListTotal(list, field);
  }

  double _calculateListTotal(List<dynamic> list, String field) {
    return list.fold(0.0, (sum, item) {
      return sum +
          parseDouble({
            'fare': item.fares,
            'pc': item.parkingCharges,
            'wc': item.waitingCharges,
            'edc': item.extraDropCharges,
            'cc': item.congestionCharges,
            'total': item.totalCharges,
            'wcomm': calculateWithoutCommission(item),
            'finalcomm': calculateFinalDriverComm(item),
          }[field]);
    });
  }

  double cashTotalValue = 0.0;
  double accountFareTotalVar = 0.0;
  double grandTotalVar = 0.0;
  double parkingCongestionVar = 0.0;
  double totalCommissionVar = 0.0;
  double owedVar = 0.0;
  double newBalanceVar = 0.0;
  double accountWOCmmVar = 0.0;

  void calculateAllTotals() {
    if (filterData?.bookings == null || selectedIds.isEmpty) {
      cashTotalValue = 0.0;
      accountFareTotalVar = 0.0;
      grandTotalVar = 0.0;
      parkingCongestionVar = 0.0;
      totalCommissionVar = 0.0;
      owedVar = 0.0;
      newBalanceVar = 0.0;
      accountWOCmmVar = 0.0;
    } else {
      final selectedBookings = filterData!.bookings!
          .where((b) => selectedIds.contains(b.id.toString()));

      // Cash Total
      cashTotalValue = selectedBookings
          .where((b) => b.paymentType?.id == 1)
          .fold(0.0, (sum, b) {
        if (b.commission == false) return sum + 0.0;
        return sum + (double.tryParse(calculateWithoutCommission(b)) ?? 0.0);
      });
      // Account Fare Total
      accountFareTotalVar = selectedBookings
          .where((b) => b.paymentType?.id == 3)
          .fold(0.0, (sum, b) {
        if (b.commission == false) return sum + 0.0;
        return sum + (double.tryParse(b.fares?.toString() ?? "0") ?? 0.0);
      });

      //   par/con Total
      parkingCongestionVar = selectedBookings
          .where((b) => b.paymentType?.id == 3)
          .fold(0.0, (sum, b) {
        double pc = double.tryParse(b.parkingCharges?.toString() ?? "0") ?? 0.0;
        double cc =
            double.tryParse(b.congestionCharges?.toString() ?? "0") ?? 0.0;
        return sum + pc + cc;
      });

      // Total Commission
      totalCommissionVar = selectedBookings.fold(0.0, (sum, b) {
        return sum + (double.tryParse(calculateFinalDriverComm(b)) ?? 0.0);
      });

      //   Total = Cash + Account
      grandTotalVar = cashTotalValue + accountFareTotalVar;
      // Account Wo-Comm
      accountWOCmmVar = selectedBookings
          .where((b) => b.paymentType?.id == 3 && b.commission == false)
          .fold(0.0, (sum, b) {
        double rowWComm = double.tryParse(calculateWithoutCommission(b)) ?? 0.0;
        return sum + rowWComm;
      });
      owedVar = totalCommissionVar - accountFareTotalVar - parkingCongestionVar;

      newBalanceVar = oldBalanceVar + owedVar;
    }
    update();
  }

  // Update Screen specific variables
  double updateCashTotalValue = 0.0;
  double updateAccountFareTotalVar = 0.0;
  double updateGrandTotalVar = 0.0;
  double updateParkingCongestionVar = 0.0;
  double updateTotalCommissionVar = 0.0;
  double updateOwedVar = 0.0;
  double updateNewBalanceVar = 0.0;
  double updateAccountWOCmmVar = 0.0;

  void calculateUpdateTotals() {
    final updateItems = updateDriverCommissionByIdModel
        ?.driverCommission?.driverCommissionLineitems;

    if (updateItems == null || updateItems.isEmpty) {
      _resetTotals();
      return;
    }

    final List<dynamic> activeBookings =
        updateItems.map((e) => e.booking).where((b) => b != null).toList();

    // 1. Cash Total
    updateCashTotalValue = activeBookings.fold(0.0, (sum, b) {
      bool isCash = b?.paymentType?.name?.toString().toLowerCase() == "cash";
      if (isCash && b?.commission == true) {
        return sum + parseDouble(calculateWithoutCommission(b));
      }
      return sum;
    });

    // 2. Account Fare Total
    updateAccountFareTotalVar = activeBookings.fold(0.0, (sum, b) {
      bool isAccount =
          b?.paymentType?.name?.toString().toLowerCase() == "account";
      if (isAccount && b?.commission == true) {
        return sum + parseDouble(b?.fares);
      }
      return sum;
    });

    // 3. Parking/Congestion
    updateParkingCongestionVar = activeBookings.fold(0.0, (sum, b) {
      bool isAccount =
          b?.paymentType?.name?.toString().toLowerCase() == "account";
      if (isAccount) {
        return sum +
            parseDouble(b?.parkingCharges) +
            parseDouble(b?.congestionCharges);
      }
      return sum;
    });

    // 4. Total Commission
    updateTotalCommissionVar = activeBookings.fold(0.0, (sum, b) {
      return sum + parseDouble(calculateFinalDriverComm(b));
    });

    // 5. Account Wo-Comm
    updateAccountWOCmmVar = activeBookings.fold(0.0, (sum, b) {
      bool isAccount =
          b?.paymentType?.name?.toString().toLowerCase() == "account";
      if (isAccount && b?.commission == false) {
        return sum + parseDouble(calculateWithoutCommission(b));
      }
      return sum;
    });

    // 6. Grand Totals Logic
    updateGrandTotalVar = updateCashTotalValue + updateAccountFareTotalVar;
    updateOwedVar = updateTotalCommissionVar -
        updateAccountFareTotalVar -
        updateParkingCongestionVar;
    updateNewBalanceVar = oldBalanceVar + updateOwedVar;
    update();
  }

  void _resetTotals() {
    updateCashTotalValue = 0.0;
    updateAccountFareTotalVar = 0.0;
    updateGrandTotalVar = 0.0;
    updateParkingCongestionVar = 0.0;
    updateTotalCommissionVar = 0.0;
    updateOwedVar = 0.0;
    updateAccountWOCmmVar = 0.0;
    update();
  }

  void updateCommissionOnToggle() {
    final updateItems = updateDriverCommissionByIdModel
        ?.driverCommission?.driverCommissionLineitems;

    if (updateItems == null) return;

    final List<dynamic> activeBookings =
        updateItems.map((e) => e.booking).where((b) => b != null).toList();

    updateTotalCommissionVar = activeBookings.fold(0.0, (sum, b) {
      return sum + double.parse(calculateFinalDriverComm(b));
    });

    updateOwedVar = updateTotalCommissionVar -
        updateAccountFareTotalVar -
        updateParkingCongestionVar;
    updateNewBalanceVar = oldBalanceVar + updateOwedVar;

    update();
  }

  // Save
  bool saveDriverCommissionLoad = false;

  saveDriverCommission() async {
    saveDriverCommissionLoad = true;
    update();

    String finalDate = transactionDate.isEmpty
        ? DateTime.now().toIso8601String().split("T").first
        : transactionDate;

    String dId = driverSelectionController.text.split(" ").first;

    var formData = {
      "transaction_date": finalDate,
      "driver_id": dId,
      "jobs_total": grandTotalVar.toStringAsFixed(2),
      "commission_total": totalCommissionVar.toStringAsFixed(2),
      "cash_jobs_total": cashTotalValue.toStringAsFixed(2),
      "account_jobs_total": accountFareTotalVar.toStringAsFixed(2),
      "owed": owedVar.toStringAsFixed(2),
      "old_balance": oldBalanceVar.toStringAsFixed(2),
      "current_balance": newBalanceVar.toStringAsFixed(2),
      "from_date": filterFromDate,
      "to_date": filterToDate,
      "last_modified": filterToDate,
      "driver_commission_lineitems": selectedIds
          .map((id) => {"booking_id": int.tryParse(id) ?? id})
          .toList(),
    };
    print("Submitting Payload: $formData");
    var response =
        await Api().post(formData, "driver_commission/add", auth: true);
    if (response.statusCode == 200) {
      BotToast.showText(text: "Commission Saved Successfully!");
    }
    saveDriverCommissionLoad = false;
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER Commission screen functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER Commission list functionality

  DriverCommissionModel? driverCommission;
  RxBool isLoading = false.obs;

  getDriverCommission() async {
    isLoading(true);
    var response = await Api().get("driver_commission/distinct");

    if (response.statusCode == 200) {
      driverCommission = DriverCommissionModel.fromJson(response.data);
      print("Error fetching driver commission: $e");
      isLoading(false);
      update();
    }
  }

  // For Alert
  DriverCommissionAlertModel? driverCommissionAlert;
  bool isLoadingDriverCommission = false;

  getDriverCommissionDetails(id) async {
    isLoadingDriverCommission = true;
    update();
    var response = await Api().get(
      "driver_commission/driverid?driver_id=$id",
    );

    if (response.statusCode == 200) {
      // print(response.data);
      driverCommissionAlert =
          DriverCommissionAlertModel.fromJson(response.data);
      isLoadingDriverCommission = false;
      update();
    }
  }

  // Delete
  driverCommissionDelete(int? id) async {
    var response = await Api().delete("driver_commission/delete/$id");
    if (response.statusCode == 200) {
      print("DriverCommission deleted successfully!");
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo DRIVER Commission list functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Update Driver Commission Screen functionality

  String updateTransactionDateController = "2000-01-01";
  String updateFilterFromDate = "";
  String updateFilterToDate = "";

  UpdateDriverCommissionByIdModel? updateDriverCommissionByIdModel;
  UpdateDriverCommission? updateDriverCommission;

  ListDriverCommissionModel? updateDriverCommissionModel;
  CreateDriverCommission? UpdatedDriverCommission;
  bool isLoadingUpdate = false;

  getDriverCommissionData({selectedId}) async {
    isLoadingUpdate = true;
    update();

    var response = await Api().get("driver_commission/getbyid/$selectedId");

    if (response.statusCode == 200) {
      updateDriverCommissionByIdModel =
          UpdateDriverCommissionByIdModel.fromJson(response.data);
      _assignApiResponseToVariables(
          updateDriverCommissionByIdModel?.driverCommission);
    }
    isLoadingUpdate = false;
    update();
  }

// Helper Function
  void _assignApiResponseToVariables(dynamic data) {
    if (data == null) return;

    double parse(String? val) => double.tryParse(val ?? "0") ?? 0.0;

    updateCashTotalValue = parse(data.cashJobsTotal);
    updateGrandTotalVar = parse(data.jobsTotal);
    updateOwedVar = parse(data.owed);
    oldBalanceVar = parse(data.oldBalance);
    updateNewBalanceVar = parse(data.currentBalance);
    updateAccountFareTotalVar = parse(data.accountJobsTotal);
    updateTotalCommissionVar = parse(data.commissionTotal);
    updateDriverSelectionController.text =
        "${data.driver?.id ?? ''} ${data.driver?.name ?? ''}";
    UpdateCommissionController.text =
        (data.driver?.driverCommission ?? "0").toString();
    UpdatePdaRentController.text = (data.driver?.pdaRent ?? "0").toString();
    String formatDate(dynamic date) =>
        date?.toString().split(' ')[0] ?? "2000-01-01";
    updateFilterFromDate = formatDate(data.fromDate);
    updateFilterToDate = formatDate(data.toDate);
    updateTransactionDateController = formatDate(data.transactionDate);
    calculateUpdateTotals();
  }

  // UpdateScreenSave
  bool saveUpdatedCommissionLoad = false;

  saveUpdatedCommission(int selectedId) async {
    try {
      saveUpdatedCommissionLoad = true;
      update();

      String dId = driverSelectionController.text.split(" ").first;
      String todayDate = DateTime.now().toIso8601String().split("T").first;

      final updateItems = updateDriverCommissionByIdModel
          ?.driverCommission?.driverCommissionLineitems
          ?.where((e) => e.booking?.commission == true)
          .toList();

      var formData = {
        "transaction_date": updateTransactionDateController,
        "driver_id": dId,
        "jobs_total": updateGrandTotalVar.toStringAsFixed(2),
        "commission_total": updateTotalCommissionVar.toStringAsFixed(2),
        "cash_jobs_total": updateCashTotalValue.toStringAsFixed(2),
        "account_jobs_total": updateAccountFareTotalVar.toStringAsFixed(2),
        "owed": updateOwedVar.toStringAsFixed(2),
        "old_balance": oldBalanceVar.toStringAsFixed(2),
        "current_balance": updateNewBalanceVar.toStringAsFixed(2),
        "from_date": updateFilterFromDate,
        "to_date": updateFilterToDate,
        "last_modified": todayDate,
        "driver_commission_lineitems":
            updateItems?.map((e) => {"booking_id": e.bookingId}).toList() ?? [],
      };
      print(formData);

      var response = await Api()
          .post(formData, "driver_commission/update/$selectedId", auth: true);

      if (response.statusCode == 200) {
        BotToast.showText(text: "Commission Updated Successfully");
      }
    } catch (err) {
      print("Error: $err");
      BotToast.showText(text: "Update Failed!");
    }
    saveUpdatedCommissionLoad = false;
    update();
  }

  /// Download pdf
  Future<void> exportToPdf() async {
    if (listDriverCommission == null) {
      await getCreateDriverCommission();
    }
    final pdf = pw.Document();
    final items = updateDriverCommissionByIdModel
            ?.driverCommission?.driverCommissionLineitems ??
        [];

    final currentDriverId =
        updateDriverCommissionByIdModel?.driverCommission?.driver?.id;
    final selectedDriverData = listDriverCommission?.drivers?.firstWhere(
      (d) => d.id == currentDriverId,
      orElse: () {
        return CreateDriverCommission();
      },
    );

    final primaryColor = PdfColor.fromInt(DynamicColors.primaryClr.value);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape.copyWith(
            marginLeft: 20, marginRight: 20, marginTop: 20, marginBottom: 20),
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Column(children: [
                pw.SizedBox(height: 50),
                pw.Text("DRIVER COMMISSION",
                    style: pw.TextStyle(
                        fontSize: 22, fontWeight: pw.FontWeight.bold)),
              ]),
            ),
            pw.SizedBox(height: 20),

            // 2. Info Row (From/To)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildInfoColumn(
                    "FROM",
                    [
                      "EMAIL: ${updateDriverCommissionByIdModel?.driverCommission?.driver?.email ?? ""}",
                      "MOBILE: ${selectedDriverData?.mobile ?? ""}",
                      "TELEPHONE: ${selectedDriverData?.telephone ?? ""}",
                      "",
                      "PERIOD: ($updateFilterFromDate - $updateFilterToDate)",
                    ],
                    primaryColor),
                _buildInfoColumn(
                    "TO",
                    [
                      "DRIVER: (${updateDriverCommissionByIdModel?.driverCommission?.driver?.id ?? ""})",
                      "${updateDriverCommissionByIdModel?.driverCommission?.driver?.name ?? ""}",
                      "DATE: ${DateFormat('dd-MM-yy').format(DateTime.now())}",
                      "COMMISSION: ${updateDriverCommissionByIdModel?.driverCommission?.driver?.driverCommission ?? ""}%",
                    ],
                    primaryColor,
                    alignEnd: true),
              ],
            ),
            pw.SizedBox(height: 10),

            // 3. Table
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 7),
              headerDecoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(DynamicColors.primaryClr.value)),
              cellStyle: const pw.TextStyle(fontSize: 7),
              cellPadding:
                  const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              columnWidths: {
                0: const pw.FixedColumnWidth(45), // REF
                1: const pw.FixedColumnWidth(40), // D/T
                2: const pw.FixedColumnWidth(110), // PICKUP
                3: const pw.FixedColumnWidth(110), // DROPOFF
                14: const pw.FixedColumnWidth(30), // COMM
                15: const pw.FixedColumnWidth(40), // TOTAL
              },
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              headers: [
                'REF#',
                'D/T',
                'PICKUP',
                'DROPOFF',
                'VEH',
                'ACC',
                'J/T',
                'P/T',
                'FARE',
                'PC',
                'WC',
                'EDC',
                'CC',
                'W/COMM',
                'COMM',
                'TOTAL'
              ],
              data: items.map((item) {
                final b = item.booking;
                return [
                  b?.referenceNumber ?? "",
                  "${b?.pickupDate}\n${b?.pickupTime}",
                  b?.pickup ?? "",
                  b?.dropoff ?? "",
                  b?.vehicleType?.name ?? "",
                  b?.account?.name ?? "",
                  b?.journeyType?.journeyType ?? "",
                  b?.paymentType?.name ?? "",
                  "£${b?.fares ?? '0'}",
                  "£${b?.parkingCharges ?? '0'}",
                  "£${b?.waitingCharges ?? '0'}",
                  "£${b?.extraDropCharges ?? '0'}",
                  "£${b?.congestionCharges ?? '0'}",
                  "£${calculateWithoutCommission(b)}",
                  "£${calculateFinalDriverComm(b)}",
                  "£${b?.totalCharges ?? '0'}",
                ];
              }).toList(),
            ),
            pw.Table(
              border: pw.TableBorder(
                left: const pw.BorderSide(color: PdfColors.black, width: 0.5),
                right: const pw.BorderSide(color: PdfColors.black, width: 0.5),
                bottom: const pw.BorderSide(color: PdfColors.black, width: 0.5),
                verticalInside:
                    const pw.BorderSide(color: PdfColors.black, width: 0.5),
                horizontalInside:
                    const pw.BorderSide(color: PdfColors.black, width: 0.5),
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FixedColumnWidth(52),
              },
              children: [
                _buildFooterRow("CASH TOTAL", updateCashTotalValue),
                _buildFooterRow("TOTAL", updateGrandTotalVar),
                _buildFooterRow(
                    "ACCOUNT W/COMM TOTAL", updateAccountFareTotalVar),
                _buildFooterRow("ACCOUNT WO/COMM TOTAL", updateAccountWOCmmVar),
                _buildFooterRow(
                    "PARKING/CONGESTION TOTAL", updateParkingCongestionVar),
                _buildFooterRow("COMMISSION TOTAL", updateTotalCommissionVar),
                _buildFooterRow("OWED", updateOwedVar),
              ],
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: 'Driver_Commission.pdf');
  }

  pw.Widget _buildInfoColumn(String label, List<String> lines, PdfColor accent,
      {bool alignEnd = false}) {
    return pw.Column(
      crossAxisAlignment:
          alignEnd ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, fontSize: 10, color: accent)),
        ...lines.map((line) {
          return line.isEmpty
              ? pw.SizedBox(height: 10)
              : pw.Text(line, style: const pw.TextStyle(fontSize: 8));
        }),
      ],
    );
  }

  pw.TableRow _buildFooterRow(String label, double value,
      {bool isBold = false}) {
    return pw.TableRow(
      children: [
        pw.Container(
          alignment: pw.Alignment.centerRight,
          padding: const pw.EdgeInsets.only(right: 5, top: 2, bottom: 2),
          child: pw.Text(label,
              style: pw.TextStyle(
                  fontSize: 7, fontWeight: isBold ? pw.FontWeight.bold : null)),
        ),
        pw.Container(
          alignment: pw.Alignment.center,
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Text("£${value.toStringAsFixed(2)}",
              style: pw.TextStyle(
                  fontSize: 7, fontWeight: isBold ? pw.FontWeight.bold : null)),
        ),
      ],
    );
  }

  ///Download Excel
  Future<void> exportToExcel() async {
    var excel = Excel.createExcel();
    String sheetName = "Driver Commission";
    Sheet sheetObject = excel[sheetName];
    excel.delete('Sheet1');

    //  Headers
    List<String> headers = [
      'REF #', 'DATETIME', 'PICKUP', 'DROPOFF', 'VEH', 'ACC', 'J/T', 'P/T',
      'FARE', 'PC', 'WC', 'EDC', 'CC', 'W/COMM', 'COMM', 'TOTAL'
    ];
    sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

    // 3. Data Rows
    final items = updateDriverCommissionByIdModel?.driverCommission?.driverCommissionLineitems ?? [];
    for (var item in items) {
      final b = item.booking;
      if (b == null) continue;

      sheetObject.appendRow([
        TextCellValue(b.referenceNumber ?? ""),
        TextCellValue("${b.pickupDate ?? ""} ${b.pickupTime ?? ""}"),
        TextCellValue(b.pickup ?? ""),
        TextCellValue(b.dropoff ?? ""),
        TextCellValue(b.vehicleType?.name?.toLowerCase() ?? ""),
        TextCellValue(b.account?.name ?? ""),
        TextCellValue(b.journeyType?.journeyType ?? ""),
        TextCellValue(b.paymentType?.name ?? ""),
        DoubleCellValue(double.tryParse(b.fares?.toString() ?? '0') ?? 0.0),
        DoubleCellValue(double.tryParse(b.parkingCharges?.toString() ?? '0') ?? 0.0),
        DoubleCellValue(double.tryParse(b.waitingCharges?.toString() ?? '0') ?? 0.0),
        DoubleCellValue(double.tryParse(b.extraDropCharges?.toString() ?? '0') ?? 0.0),
        DoubleCellValue(double.tryParse(b.congestionCharges?.toString() ?? '0') ?? 0.0),
        DoubleCellValue(double.tryParse(calculateWithoutCommission(b).toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(calculateFinalDriverComm(b).toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(b.totalCharges?.toString() ?? '0') ?? 0.0),
      ]);
    }

    try {
      var fileBytes = excel.save();
      if (fileBytes != null) {
        final content = base64Encode(fileBytes);
        final anchor = html.AnchorElement(
            href: "data:application/octet-stream;charset=utf-16le;base64,$content")
          ..setAttribute("download", "Driver_Commission_Report.xlsx")
          ..click();
      }
    } catch (e) {
      print("Excel Error: $e");
    }
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Update Driver Commission Screen functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Driver Rent Screen functionality

  final rentWeekController = TextEditingController();
  final pdaRentWeekController = TextEditingController();
  final TextEditingController rentFromDateController = TextEditingController();
  final TextEditingController rentToDateController = TextEditingController();
  TextEditingController rentDriverSelectionController = TextEditingController();
  String rentTransactionDate = "";

  ///drop down API
  DriverRentModel? driverRentModel;
  bool isCreateDriverRent = false;

  getDriver() async {
    // resetCreateFields();
    isCreateDriverRent = true;
    update();
    var response = await Api()
        .get("drivers/commission?active=true&driver_type=Rent/Week");
    if (response.statusCode == 200) {
      print("API Response: ${response.data}");
      driverRentModel = DriverRentModel.fromJson(response.data);

      // oldBalanceVar = 0.0;
    }
    isCreateDriverRent = false;
    update();
  }

  // double oldBalanceVar = 0.0;

  void fillDriverDetails(String selectedText) {
    if (selectedText.isEmpty) return;
    final driver = driverRentModel?.drivers.firstWhere(
          (d) => "${d.id} ${d.name}".toUpperCase() == selectedText.toUpperCase(),
      // orElse: () => null,
    );

    if (driver != null) {
      rentWeekController.text = driver.driverCommission ?? "0";
      pdaRentWeekController.text = driver.pdaRent ?? "0";
      // oldBalanceVar = double.tryParse(driver.balance?.toString() ?? "0") ?? 0.0;
      update();
    }
  }

  // Filter Button
  DriverRentFilterModel? driverRentFilterModel;
  RentBooking? rentBooking;
  String rentFilterFromDate = "";
  String rentFilterToDate = "";
  bool isRentFilterLoading = false;

  getDriverRentByFilter() async {
    isRentFilterLoading = true;
    update();

    String drId = rentDriverSelectionController.text.split(" ").first;
    String pIds = selectedPaymentTypeIds.isNotEmpty
        ? "[${selectedPaymentTypeIds.join(",")}]"
        : "";

    var response = await Api().get(
      "bookings/driver-rent",
      queryParameters: {
        'driver_id': drId,
        'payment_type_id': pIds,
        'from_date': rentFilterFromDate,
        'to_date': rentFilterToDate,
      },
    );
    print("API Response: ${response.data}");
    if (response.statusCode == 200) {
      driverRentFilterModel = DriverRentFilterModel.fromJson(response.data);
    }
    isRentFilterLoading = false;
    update();
  }


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
