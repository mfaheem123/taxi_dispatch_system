import 'package:dashboard_new1/Model/image_model.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/administration/model/list_subsDiary.dart';
import 'package:dashboard_new1/view/administration/model/user_model.dart' hide Role;
import 'package:dio/dio.dart' as dio show MultipartFile;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../User/create_subsiDiary.dart';
import '../model/get_role.dart';

class AdministrationController extends GetxController {
  /// RxBool variable
  RxBool inActive = false.obs;
  RxBool subsDiarySelection = false.obs;
  RxBool subsDiaryAllSelection = false.obs;



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


  Subsidiaries? selectedSubsidiary;

  Future<void> listSubsDiary() async {
    try {
      subsDiaryLoading.value = true;
      final response = await Api().get('subsidiaries/get?', queryParameters: {
        "page" : subsiCurrentPage.value,
        '&limit' : subsiiLimit,
        "name" :searchSubsiDiaryName.value.toLowerCase(),
        "email" : searchSubsiDiaryEmail.value.toLowerCase(),
        "telephone_number" : searchSubsiDiaryTelephone.value.toLowerCase(),
        "address" : searchSubsiDiaryAddress.value.toLowerCase(),
        "fax" : searchSibsiDiaryFax.value.toLowerCase(),
      }
      );
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
  final int userLlimit = 5;
  RxList<Employees> userAll = <Employees>[].obs;
  RxList<Employees> userFliter = <Employees>[].obs;
  RxString searchUserName = ''.obs;
  RxString searchUserEmail = ''.obs;
  RxString searchUserPhone = ''.obs;

  RxString searchUserFax = ''.obs;
  RxString searchUserRole = ''.obs;
  RxString searchUserSubsiDiary = ''.obs;
  userData() async {

      userLoading.value = true;

      final response = await Api().get('employees/get?',
          queryParameters: {
        'page' : userCurrentPage.value,
        'limit': userLlimit,
        'username' : searchUserName.value.toLowerCase(),
        'email' : searchUserEmail.value.toLowerCase(),
        'phone' : searchUserPhone.value.toLowerCase(),
        'fax' : searchUserFax.value.toLowerCase(),
        'role' : searchUserRole.value.toLowerCase(),
        'subsidiary' : searchUserSubsiDiary.value.toLowerCase(),

      });
      if (response.statusCode == 200) {
        userModel = UserModel.fromJson(response.data);
        userTotalPage.value = userModel?.totalPages ?? 1;
        userAll.value = userModel?.employees ?? [];
        userFliter.value = userAll;
        print('User data ${UserModel}');
        print('User data ${response.data}');
      }
      userLoading.value = false;
      update();

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

  List bankDetailList = <BankDetailsAlertClass>[].obs;



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
    var multipartFile;
    if (profileImg != null) {
      multipartFile = dio.MultipartFile.fromBytes(
        profileImg!.bytes,
        filename: profileImg!.name,
      );
    }

    var formData = {
      'name': nameController.text,
      'background_color': subsiDiarypickerColor.value.toRadixString(16).substring(2),
      'foreground_color': subsiDiaryforegroundColor.value.toRadixString(16).substring(2),
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
      'address_longitude': '-0.1278',
      if (multipartFile != null) "image": multipartFile!
    };

    var response = await Api().post(formData, 'subsidiaries/add', auth: true);
    if (response.statusCode == 200) {
      profileImg = null;
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
      profileImg = null;
      update();
      Text("Saved Successfully");
      print("response of body -------------------------${response.data}");
    }
  }


//// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create User

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

  RxBool userRoleLoading = false.obs;
  GetRole? getRole;
  Role? selectedRole;

  @override
  void onInit() {
    super.onInit();
    getRoleUser();   // <--- API call yahan se hoga
    listSubsDiary();
  }
  getRoleUser() async {
    userRoleLoading.value = true;   // <-- IMPORTANT
      final response = await Api().get('roles');
      if (response.statusCode == 200) {
        getRole = GetRole.fromJson(response.data);
        print("Response of dropdown: $getRole");
      }
    userRoleLoading.value = false;
    update();
  }

  String? selectRoleUser = "SELECT ROLE";
  final userNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final phoneController = TextEditingController();
  final faxUserController = TextEditingController();


  ImageModel? profileImage;

  Future<void> pickImageCreate() async {
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



  RxBool isLoadUser = false.obs;
  createUser() async {
    isLoadVehicleType.value = true;

    var multipartFile;
    if (profileImg != null) {
      multipartFile = dio.MultipartFile.fromBytes(
        profileImg!.bytes,
        filename: profileImg!.name,
      );
    }

    var formData = {
      'subsidiary_id': selectedSubsidiary!.id,
      'role_id': selectedRole!.id,
      'username': userNameController.text,
      'password': passwordController.text,
      'confirmpassword': confirmController.text,
      'email': userEmailController.text,
      'phone': phoneController.text,
      'fax': faxUserController.text,
      'release_note_viewed': 'true',
      'active': activeValue.value,
      'alldrivers': alldriversValue.value,
      'allbookings': allbookingValue.value,
      'allaccounts': accuntValue.value,
      'callreceiver': receviverValue.value,
      'allowtransferbookings': transferValue.value,
      if (multipartFile != null) "image": multipartFile!,
    };
    var response = await Api().post(formData, 'employees/add', auth : true);
    if (response.statusCode == 200) {
      userNameController.clear();
      passwordController.clear();
      confirmController.clear();
      userEmailController.clear();
      phoneController.clear();
      faxUserController.clear();
      activeValue.value = false;
      alldriversValue.value = false;
      allbookingValue.value = false;
      accuntValue.value = false;
      receviverValue.value = false;
      transferValue.value = false;
      profileImage = null;

      update();
      Text("Saved Successfully");
      print("response of body -------------------------${response.data}");
    }

    isLoadVehicleType.value = false;
  }


}
