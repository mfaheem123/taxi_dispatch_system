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
        print('User data ${response.data}');
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

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Subsidiaries Controller

// String?

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create SubsiDiary

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

  Color subsiDiarypickerColor = Colors.blue;
  Color subsiDiaryforegroundColor = Colors.blue;

  RxBool isLoadVehicleType = false.obs;
  createSubsiDiary() async {
    isLoadVehicleType.value = false;

    var formData = {
      'name': nameController.text,
      'background_color':
          subsiDiarypickerColor.value.toRadixString(16).substring(2),
      'foreground_color':
          subsiDiaryforegroundColor.value.toRadixString(16).substring(2),
      'telephone_number': telephoneController.text,
      'emergency_contact_number': emergencyContactController.text,
      'email': emailController.text,
      'fax': faxController.text,
      'website': websiteController.text,
      'address': addressController.text,
      'sort_code': '12-34-56',
      'account_number': '12345678',
      'account_title': 'Demo Company Ltd',
      'bank': 'Demo Bank',
      'company_number': companyController.text,
      'vat_number': 'GB123456789',
      'iban': 'GB29NWBK60161331926819',
      'balance': balanceController.text,
      'currency': currencyController.text,
      'web_access_token': 'web-token-demo-123',
      'mobile_access_token': 'mobile-token-demo-456',
      'maximum_drivers': '50',
      'active_drivers': '10',
      'address_latitude': '51.5074',
      'address_longitude': '-0.1278'
    };

    var response = await Api().post(formData, 'subsidiaries/add', auth: true);
    if (response.statusCode == 200) {
      nameController.clear();
      emailController.clear();
      faxController.clear();
      websiteController.clear();
      telephoneController.clear();
      emergencyContactController.clear();
      backgroundColorrController.clear();
      foregroundColorController.clear();
      companyController.clear();
      currencyController.clear();
      addressController.clear();
      balanceController.clear();
      update();
      Text("Saved Successfully");
      print("response of body -------------------------${response.data}");
    }
  }
}
