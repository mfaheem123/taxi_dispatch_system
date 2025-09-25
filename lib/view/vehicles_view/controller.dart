
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
      profileImg; /*= asd.ImageModel(
          name: result.files.single.name,
          bytes: result.files.single.bytes!,
          path: result.files.single.path
      );*/
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
  // Uint8List? bytes;

  // Future<void> selectProfileImage() async {
  // /*  final image = await ImagePickerHelper.pickImage();
  //
  //   if (image != null) {
  //     // yahan apni logic lagao
  //     print("Image Name: ${image.name}");
  //     print("Image Path: ${image.path}");
  //   }*/
  // }


///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo company vehicle

}