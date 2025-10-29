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
  var subsiCurrentPage = 1.obs;
  var subsiTotalPages = 1.obs;
  final int subsiiLimit = 20;
  RxList<Subsidiaries> subsiDiaryAll = <Subsidiaries>[].obs;
  RxList<Subsidiaries> filteredSubsiDiary = <Subsidiaries>[].obs;
  // search fields
  RxString searchSubsiDiaryName = ''.obs;
  RxString searchSubsiDiaryEmail = ''.obs;
  RxString searchSubsiDiaryTelephone = ''.obs;
  RxString searchSubsiDiaryAddress = ''.obs;
  RxString searchSibsiDiaryFax = ''.obs;

  Future<void> listSubsDiary() async {
    try {
      subsDiaryLoading.value = true;
      String query = 'page=${subsiCurrentPage.value}&limit=$subsiiLimit';
      if (searchSubsiDiaryName.value.isNotEmpty)
        query += '&name=${searchSubsiDiaryName.value}';
      if (searchSubsiDiaryEmail.value.isNotEmpty)
        query += '&email=${searchSubsiDiaryEmail.value}';
      if (searchSubsiDiaryTelephone.value.isNotEmpty)
        query += '&telephone_number=${searchSubsiDiaryTelephone.value}';
      if (searchSubsiDiaryAddress.value.isNotEmpty)
        query += '&address=${searchSubsiDiaryAddress.value}';
      if (searchSibsiDiaryFax.value.isNotEmpty)
        query += '&fax=${searchSibsiDiaryFax.value}';
      print("API Query: subsidiaries/get?$query");
      final response = await Api().get('subsidiaries/get?$query');
      if (response.statusCode == 200) {
        subsDiaryModel = SubsDiaryModel.fromJson(response.data);
        subsiTotalPages.value = subsDiaryModel?.totalPages ?? 1;
        subsiDiaryAll.value = subsDiaryModel?.subsidiaries ?? [];
        filteredSubsiDiary.value = subsiDiaryAll;
        print('SubsiDiary ${SubsDiaryModel}');
      }
    } catch (e) {
      print("Error in subsDiary: $e");
    } finally {
      subsDiaryLoading.value = false;
      update();
    }
  }

// -----------Search changes function
  void subsiDiarySearchChanged() {
    subsiCurrentPage.value = 1;
    listSubsDiary();
  }

  /// ------- pagination function
  void onPageChange(int page) {
    subsiCurrentPage.value = page;
    listSubsDiary();
  }

//// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  User  api

  UserModel? userModel;
  RxBool userLoading = false.obs;
  var userCurrentPage = 1.obs;
  var userTotalPage = 1.obs;
  final int userLlimit = 20;
  RxList<Employees> userAll = <Employees>[].obs;
  RxList<Employees> userFliter = <Employees>[].obs;
  RxString searchUserName = ''.obs;
  RxString searchUserEmail = ''.obs;
  RxString searchUserPhone = ''.obs;
  RxString searchUserFax = ''.obs;
  RxString searchUserRole = ''.obs;
  RxString searchUserSubsiDiary = ''.obs;
  Future<void> userData() async {
    try {
      userLoading.value = true;
      String query = 'page=${userCurrentPage.value}&limit=$userLlimit';
      if (searchUserName.value.isNotEmpty)
        query += '&username=${searchUserName.value}';
      if (searchUserEmail.value.isNotEmpty)
        query += '&email=${searchUserEmail.value}';
      if (searchUserPhone.value.isNotEmpty)
        query += '&phone=${searchUserPhone.value}';
      if (searchUserFax.value.isNotEmpty)
        query += '&fax=${searchUserFax.value}';
      if (searchUserRole.value.isNotEmpty)
        query += '&role=${searchUserRole.value}';
      if (searchUserSubsiDiary.value.isNotEmpty)
        query += '&subsidiary=${searchUserSubsiDiary.value}';
      print("API Query: employees/get?$query");
      final response = await Api().get('employees/get?$query');
      if (response.statusCode == 200) {
        userModel = UserModel.fromJson(response.data);
        userTotalPage.value = userModel?.totalPages ?? 1;
        userAll.value = userModel?.employees ?? [];
        userFliter.value = userAll;
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
  void userSearch() {
    userCurrentPage.value = 1;
    userData();
  }
  void userPage(int page) {
    userCurrentPage.value = page;
    userData();
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
