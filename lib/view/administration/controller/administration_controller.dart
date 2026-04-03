import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/Model/image_model.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/administration/model/list_subsDiary.dart';
import 'package:dashboard_new1/view/administration/model/user_model.dart' hide Role;
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../User/create_subsiDiary.dart';
import '../model/get_role.dart';

class AdministrationController extends GetxController {
  /// RxBool variable
  RxBool subsDiarySelection = false.obs;
  RxBool subsDiaryAllSelection = false.obs;

//// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get  List subsDiary api
  RxSet<int> selectedSubsDiaryIds = <int>{}.obs;
  SubsDiaryModel? subsDiaryModel;
  RxBool subsDiaryLoading = false.obs;
  var subsiCurrentPage = 1.obs;
  var subsiTotalPages = 1.obs;
  final int subsiiLimit = 20;
  RxList<Subsidiaries> subsiDiaryAll = <Subsidiaries>[].obs;
  RxList<Subsidiaries> filteredSubsiDiary = <Subsidiaries>[].obs;
  RxString searchSubsiDiaryName = ''.obs;
  RxString searchSubsiDiaryEmail = ''.obs;
  RxString searchSubsiDiaryTelephone = ''.obs;
  RxString searchSubsiDiaryAddress = ''.obs;
  RxString searchSibsiDiaryFax = ''.obs;
  Subsidiaries? selectedSubsidiary;

 listSubsDiary() async {
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
        subsDiaryLoading.value = false;
        update();
      }
  }
  // -----------Search changes function
  void subsiDiarySearchChanged() {
    subsiCurrentPage.value = 1;
    listSubsDiary();
  }
  // ------- pagination function
  void onPageChange(int page) {
    subsiCurrentPage.value = page;
    listSubsDiary();
  }

/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Edit SubsDiary

  RxBool isSubsiDiaryUpdating = false.obs;
  Subsidiaries? subsidiaryToUpdate;

  subsidiaryUpdate({Subsidiaries? data}) async {
    if (data == null) return;
    isSubsiDiaryUpdating.value = true;
    subsidiaryToUpdate = data;
    nameController.text = data.name ?? "";
    emailController.text = data.email ?? "";
    faxController.text = data.fax ?? "";
    websiteController.text = data.website ?? "";
    telephoneController.text = data.telephoneNumber ?? "";
    emergencyContactController.text = data.emergencyContactNumber ?? "";
    companyController.text = data.companyNumber ?? "";
    currencyController.text = data.currency ?? "";
    addressController.text = data.address ?? "";
    balanceController.text = data.balance?.toString() ?? "";
    // --- 2. Color Binding (Hex to Color) ---
    if (data.backgroundColor != null && data.backgroundColor!.isNotEmpty) {
      // Remove '#' and parse
      String bgHex = data.backgroundColor!.replaceAll('#', '');
      subsiDiarypickerColor = Color(int.parse("0xFF$bgHex"));
    }
    if (data.foregroundColor != null && data.foregroundColor!.isNotEmpty) {
      // Remove '#' and parse
      String fgHex = data.foregroundColor!.replaceAll('#', '');
      subsiDiaryforegroundColor = Color(int.parse("0xFF$fgHex"));
    }
    if (subsiDiaryAll.isNotEmpty) {
      selectedSubsidiary = subsiDiaryAll.firstWhere(
            (sub) => sub.id == data.id,
        orElse: () => subsiDiaryAll.first,
      );
    }

    update();
  }

/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Delete SubsDiary

  subsidiariesDelete(int? id) async {
    var response = await Api().delete("subsidiaries/delete/$id");
    if (response.statusCode == 200) {
      listSubsDiary();
      print("Subsidiaries deleted successfully!");
      BotToast.showText(text: "Subsidiaries Deleted Successfully!");
    }
  }


  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get User

  UserModel? userModel;
  Employee? employee;
  RxBool userLoading = false.obs;
  RxBool inActive = false.obs;
  var userCurrentPage = 1.obs;
  var userTotalPage = 1.obs;
  final int userLlimit = 15;
  RxList<Employee> userAll = <Employee>[].obs;
  RxList<Employee> userFliter = <Employee>[].obs;
  RxString searchUserName = ''.obs;
  RxString searchUserEmail = ''.obs;
  RxString searchUserPhone = ''.obs;
  RxString searchUserFax = ''.obs;
  RxString searchUserRole = ''.obs;
  RxString searchUserSubsiDiary = ''.obs;
  userData() async {
      userLoading.value = true;
      final response = await Api().get('employees/get',
          queryParameters: {
        'page' : userCurrentPage.value,
        'limit': userLlimit,
        'active': inActive.value,
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

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  User  Delete

  userDelete(int? id) async {
    var response = await Api().delete("employees/delete/$id");
    if (response.statusCode == 200) {
      BotToast.showText(text: "User deleted successfully!");
      userData();
       }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  User  Update

  RxBool isUpdating = false.obs;
  userUpdate({Employee? userUpdate}) async {
    if (userUpdate == null) return;
    isUpdating.value = true;
    employee = userUpdate;
// --- 1. Subsidiary Match Logic ---
    if (subsiDiaryAll.isNotEmpty) {
      selectedSubsidiary = subsiDiaryAll.firstWhere(
            (sub) => sub.id == userUpdate.subsidiaryId,
        orElse: () => subsiDiaryAll.first, // Agar na mile toh pehla select karle
      );
    }
    // --- 2. Role Match Logic ---
    if (getRole?.roles != null && getRole!.roles!.isNotEmpty) {
      selectedRole = getRole!.roles!.firstWhere(
            (role) => role.id == userUpdate.roleId,
        orElse: () => getRole!.roles!.first,
      );
    }
    userNameController.text = userUpdate.username ?? "";
    passwordController.text = userUpdate.password ?? "";
    confirmController.text = userUpdate.confirmpassword ?? "";
    userEmailController.text = userUpdate.email ?? "";
    phoneController.text = userUpdate.phone ?? "";
    faxUserController.text = userUpdate.fax ?? "";
    activeValue.value = userUpdate.active ?? false;
    alldriversValue.value = userUpdate.alldrivers ?? false;
    allbookingValue.value = userUpdate.allbookings ?? false;
    accuntValue.value = userUpdate.allaccounts ?? false;
    receviverValue.value = userUpdate.callreceiver ?? false;
    transferValue.value = userUpdate.allowtransferbookings ?? false;
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create SubsiDiary

  Color pickerColor = Colors.blue;
  Color foregroundColor = Colors.blue;
  ImageModel? subsidiaryImg;
  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.bytes != null) {
      subsidiaryImg = ImageModel(
          name: result.files.single.name,
          bytes: result.files.single.bytes!,
          path: result.files.single.path);
    }
    update();
  }
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
    if (subsidiaryImg != null) {
      multipartFile = dio.MultipartFile.fromBytes(
        subsidiaryImg!.bytes,
        filename: subsidiaryImg!.name,
      );
    }
    final formData = dio.FormData.fromMap({
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
      if (multipartFile != null) "logo": multipartFile
    });
    var response = await Api().post(
        formData,
        isSubsiDiaryUpdating.value
            ? "subsidiaries/edit/${subsidiaryToUpdate!.id}"
            : 'subsidiaries/add',
        auth: true,
        multiPart: multipartFile != null ? true : false
    );
    if (response.statusCode == 200) {
      subsidiaryImg = null;
      nameController.clear();
      emailController.clear();
      faxController.clear();
      websiteController.clear();
      telephoneController.clear();
      emergencyContactController.clear();
      subsiDiarypickerColor = Colors.blue;
      subsiDiaryforegroundColor = Colors.blue;
      companyController.clear();
      currencyController.clear();
      addressController.clear();
      balanceController.clear();
      isSubsiDiaryUpdating.value = false;
      BotToast.showText(
          text: isSubsiDiaryUpdating.value
              ? "Subsidiary Update Successfully"
              : "Subsidiary Add Successfully"
      );
      update();
      print(response.data);
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
    getRoleUser();
    listSubsDiary();
  }
  getRoleUser() async {
    userRoleLoading.value = true;
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
  ImageModel? userProfileImg;

  Future<void> pickImageCreate() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.bytes != null) {
      userProfileImg = ImageModel(
          name: result.files.single.name,
          bytes: result.files.single.bytes!,
          path: result.files.single.path);
    }
    update();
  }
  RxBool isLoadUser = false.obs;
  createUser() async {
    isLoadUser(true);
    var multipartFile;
    if (userProfileImg != null) {
      multipartFile = dio.MultipartFile.fromBytes(
        userProfileImg!.bytes,
        filename: userProfileImg!.name,
      );
    }
    final formData = dio.FormData.fromMap({
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
      if (multipartFile != null) "image": multipartFile,
    });
    var response = await Api().post(
      formData,
      employee != null ? "employees/update/${employee!.id}" : "employees/add",
      auth: true,
      multiPart: multipartFile != null ? true : false,
    );
    if (response.statusCode == 200) {
      String message = employee != null
          ? "User Update Successfully"
          : "User Added Successfully";
      print(response);
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
      userProfileImg = null;
      employee = null;
      isLoadUser(false);
      BotToast.showText(text: message);
      update();
      isLoadUser(false);
    }
  }
}
