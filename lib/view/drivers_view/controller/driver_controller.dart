
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../Model/driver_model.dart';
import 'package:file_picker/file_picker.dart';

import '../../../Model/image_model.dart';
import '../driver/create_driver_form/driver_form.dart';
import '../model/driver_form_model.dart';


class DriverController extends GetxController {

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create driver form functionality

  /// RxBool variable
  RxBool hasPDA = false.obs;
  RxBool rentPaid = false.obs;
  RxBool isActive = false.obs;
  RxBool vehicleInformation = false.obs;

  String? driverType;
  String? dobDate;
  String? startDate;
  String? endDate;



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

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>table data
  var rows = <DocumentRow>[
    DocumentRow(
      batchNo: "PHC VEHICLE",
      documentTitle: "PHC VEHICLE"
    ),
    DocumentRow(
      batchNo: "PHC DRIVER",
      documentTitle: "PHC DRIVER",

    ),
    DocumentRow(
      batchNo: "MOT",
      documentTitle: "MOT",

    ),
    DocumentRow(
      batchNo: "MOT 2",
      documentTitle: "MOT 2",

    ),
    DocumentRow(
      batchNo: "INSURANCE",
      documentTitle: "INSURANCE",

    ),
    DocumentRow(
      batchNo: "LICENSE",
      documentTitle: "LICENSE",


    ),
    DocumentRow(
      batchNo: "ROAD TAX",
      documentTitle: "ROAD TAX",

    ),
    DocumentRow(
      batchNo: "V5 REGISTRATION",
      documentTitle: "V5 REGISTRATION",

    ),
    DocumentRow(
      batchNo: "RENTAL AGREEMENT",
      documentTitle: "RENTAL AGREEMENT",

    ),
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

  void addDocument(int index) async{
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
        if(singleImg ==null){
          imageList.add(
              ImageModel(
                  name: result.files.single.name,
                  bytes: result.files.single.bytes!,
                  path: result.files.single.path
              )
          );
        }else{
          if(docImg == "docImg"){
            docImgg = ImageModel(
                name: result.files.single.name,
                bytes: result.files.single.bytes!,
                path: result.files.single.path
            );
          }else{
            profileImg = ImageModel(
                name: result.files.single.name,
                bytes: result.files.single.bytes!,
                path: result.files.single.path
            );
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
    if(response.statusCode == 200){
      getCombineVehicleData = DriverFormModel.fromJson(response.data);
      getCombineVehicleLoading(false);
      update();
    }
  }


  addDriverFtn() async {
    var formData = {
      "has_pda": hasPDA.value,
      "rent_paid": rentPaid.value,
      "active": isActive.value,
      "subsidiary_id": companyType,
      "username": driverUserNameController.text,
      "password": driverPasswordController.text,
      "name": driverFullNameController.text,
      "dob": dobDate,
      "email": driverEmailController.text,
      "mobile": driverMobileController.text,
      "telephone": driverTelController.text,
      "driver_type": driverType,
      "driver_commission": driverCommissionController.text,
      "rent_limit": driverRendLimitController.text,
      "balance": driverBalanceController.text,
      "address": driverAddressController.text,
      "use_company_vehicle": vehicleInformation.value,
      "SELECT COMPANY VEHICLE": selectCompanyVehicle,
      "start_date": startDate,
      "end_date": endDate,
      "vehicle_name": vehicleNameController.text,
      // "make": vehicleMakeController.text,
      // "model": vehicleModelController.text,
      // "vehicle_Color": vehicleColorController.text,
      // "owner": vehicleOwnerController.text,
      // "log_book": vehicleLogBookController.text,
      // "vehicle type": vehicleType,

      "ni": driverNLController.text,
      "notes": noteList,
      "shifts": shiftList,

      "licence_number": rows[5].batchNo,
      "licence_expiry": rows[5].expiryDate,
      "phc_driver_number": rows[1].batchNo,
      "phc_driver_expiry": rows[1].expiryDate,
      "insurance_number": rows[4].batchNo,
      "insurance_expiry": rows[4].expiryDate,
      "rental_agreement_number": rows[8].batchNo,
      "rental_agreement_expiry": rows[8].expiryDate,
      "road_tax_number": rows[6].batchNo,
      "road_tax_expiry": rows[6].expiryDate,
      "v5_registration_number": rows[7].batchNo,
      "v5_registration_expiry": rows[7].expiryDate,
      "mot_number": rows[2].batchNo,
      "mot_expiry": rows[2].expiryDate,
      "mot2_number": rows[3].batchNo,
      "mot2_expiry": rows[3].expiryDate,
      "phc_vehicle_number": rows[0].batchNo,
      "phc_vehicle_expiry": rows[0].expiryDate,
    };
  }




  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create driver form functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver list screen and login drivers screen functionality

  /// RxBool variable
  RxBool activeDrivers = false.obs;
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
