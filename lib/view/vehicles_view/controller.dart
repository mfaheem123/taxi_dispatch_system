
import 'dart:typed_data';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Model/image_model.dart';

class VehicleController extends GetxController{


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
          path: result.files.single.path
      );
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

  RxBool CompanyVehicleLoader = false.obs;
  postCompanyVehicle()async{
    CompanyVehicleLoader(false);
    var formData = {

      'vehicle_number': 'DSA-781',
      'make': 'mehran Boss',
      'model': '2015',
      'color': 'Black',
      'owner': 'company',
      'company': 'true',
      'assigned': 'false',
      'vehicle_type_id': '1',
      'log_book_number': 'LB1234',
      'phc_vehicle_expiry': '2025-12-01',
      'mot_expiry': '2025-12-01',
      'mot2_expiry': '2025-12-01',
      'insurance_expiry': '2025-12-01',
      'phc_vehicle_number': 'PHC5678',
      'mot_number': 'MOT9012',
      'mot2_number': 'MOT2134',
      'insurance_number': 'INS5678',
      'start_date': '2024-01-10',
      'end_date': '2025-01-10'

    };

    var response = await Api().post(formData, 'company-vehicles/add', auth: true);
    if (response.statusCode == 200) {
      // Get.toNamed(Routes.myHomePage);
    }else{
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrr");
    }



  }


///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo company vehicle

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo VEHICLE TYPES


///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo VEHICLE TYPES

}