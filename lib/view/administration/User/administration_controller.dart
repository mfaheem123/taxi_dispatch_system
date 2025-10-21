import 'package:dashboard_new1/Model/image_model.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/administration/model/list_subsDiary.dart';
import 'package:dashboard_new1/view/administration/model/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdministrationController extends GetxController {
  

  
  /// RxBool variable
  RxBool inActive = false.obs;
  RxBool subsDiarySelection = false.obs;
  RxBool subsDiaryAllSelection = false.obs;


  RxBool activeValue = false.obs;
  final FocusNode activeNode = FocusNode();
  RxBool alldriversValue = false.obs;
  final FocusNode alldriversNode = FocusNode();
  RxBool allbookingValue = false.obs;
  final FocusNode allbookingNode = FocusNode();
  RxBool accuntValue = false.obs;
  final FocusNode accuntNode = FocusNode();
  RxBool receviverValue = false.obs;
  final FocusNode receviverNode = FocusNode();
  RxBool transferValue = false.obs;
  final FocusNode transferNode = FocusNode();

//// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  List subsDiary api

  SubsDiaryModel? subsDiaryModel;
  RxBool subsDiaryLoading = false.obs;

  Future<void> listSubsDiary() async {
    try {
      subsDiaryLoading.value = true;
      final response = await Api().get('subsidiaries/get');

      if (response.statusCode == 200) {
        subsDiaryModel = SubsDiaryModel.fromJson(response.data);
        print('Company ${SubsDiaryModel}');
      } else {
        print("Status Code Error-------${response.statusCode}");
      }
    } catch (e) {
      print("Error in subsDiary: $e");
    } finally {
      subsDiaryLoading.value = false;
      update();
    }
  }


//// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  User subsDiary api


UserModel? userModel;
 RxBool userLoading = false.obs;

  Future<void> userData() async {
    try {
      userLoading.value = true;
      final response = await Api().get('employees/get');

      if (response.statusCode == 200) {
        userModel = UserModel.fromJson(response.data);
        print('User data ${UserModel}');
      } else {
        print("Status Code Error-------${response.statusCode}");
      }
    } catch (e) {
      print("Error in User: $e");
    } finally {
      userLoading.value = false;
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create SubsiDiary Controller

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

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final faxController = TextEditingController();
  final websiteController = TextEditingController();
  final telephoneController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final backgroundColorrController = TextEditingController();
  final foregroundColorController = TextEditingController();
  final companyController = TextEditingController();
  final currencyController = TextEditingController();
  final addressController = TextEditingController();
  final balanceController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Subsidiaries Controller

// String?
}
