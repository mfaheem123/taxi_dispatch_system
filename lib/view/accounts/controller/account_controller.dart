import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/accounts/model/list_escort_model.dart';
import 'package:dashboard_new1/view/accounts/model/listof_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create account form functionality
  /// RxBool variable
  RxBool activeDrivers = false.obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create account form functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo CUSTOMER INVOICE functionality
  /// RxBool variable

  /// controllers for text fields
  ///
  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerMobileController = TextEditingController();
  final customerTelephoneController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo CUSTOMER INVOICE functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo AccountView functionality
  /// RxBool variable
  RxBool orderCheckBox = false.obs;
  RxBool bookedByCheckBox = false.obs;
  RxBool escoptCheckBox = false.obs;
  RxBool fareControllerCheckBox = false.obs;
  RxBool bankInfoCheckBox = false.obs;
  RxBool adminFeeCheckBox = false.obs;
  RxBool accountFeeCheckBox = false.obs;
  RxBool vatCheckBox = false.obs;
  RxBool dispatchSmsCheckBox = false.obs;
  RxBool confirmSmsCheckBox = false.obs;
  RxBool arrivalSmsCheckBox = false.obs;
  RxBool clearJobSmsCheckBox = false.obs;

  /// controllers for text fields
  final customerCodeController = TextEditingController();
  final customerPasswordController = TextEditingController();
  final customerFaxController = TextEditingController();
  final customerWebsiteController = TextEditingController();
  final customerAccountNumberController = TextEditingController();
  final customerCreditCardController = TextEditingController();
  final customerAddressController = TextEditingController();
  final customerInformationController = TextEditingController();
  final customerContactNameController = TextEditingController();
  final customerAdminFeeController = TextEditingController();
  final customerAccountFeeController = TextEditingController();
  final customerAgentCommissionController = TextEditingController();

  // Initialize both variables so "pickerColor" is defined
  Color pickerColor = Colors.blue; // currently selected color inside picker
  Color foregroundClr = Colors.blue; // currently selected color inside picker
  Color currentColor = Colors.blue; // applied color on the UI
  Color foregroundCurrentColor = Colors.blue; // applied color on the UI

  void changeColor(Color color) {
    pickerColor = color;
  }

  void foregroundColor(Color color) {
    foregroundClr = color;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo AccountView functionality

  /// ...............>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  List of customer invoice

  RxBool paid = false.obs;
  final FocusNode paidNode = FocusNode();

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  create Customer invoice

  RxBool P_T_Value = false.obs;
  RxBool cashValue = false.obs;
  RxBool creditValue = false.obs;
  RxBool account_Value = false.obs;
  RxBool creditCardPaid_Value = false.obs;

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  List OF Account Api controller

/// ........................................ model object
ListOfAccountModel? listofAccount;
///------------------------------------------- Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 5; 
  RxBool isLoadingListOfAccount = false.obs;

/// >>>>>>>>>>>>>>>>>>>>> Search Work

  RxList<Account> AccountList = <Account>[].obs;
  RxList<Account> filteredAccount = <Account>[].obs;
  // search fields
  RxString searchName = ''.obs;
  RxString searchAccountType = ''.obs;
  RxString searchAddress = ''.obs;
  RxString searchEmail = ''.obs;
  RxString searchMobile = ''.obs;
  RxString searchTelephone = ''.obs;
  RxString searchcontactName = ''.obs;
  RxString searchSubsiDiary = ''.obs;

 Future<void> listOFAccount() async {
  try {
    isLoadingListOfAccount.value = true;

    String query = 'page=${currentPage.value}&limit=$limit';
    if (searchName.value.isNotEmpty) query += '&name=${searchName.value}';
    if (searchAccountType.value.isNotEmpty) query += '&accountType=${searchAccountType.value}';
    if (searchAddress.value.isNotEmpty) query += '&address=${searchAddress.value}';
    if (searchEmail.value.isNotEmpty) query += '&email=${searchEmail.value}';
    if (searchMobile.value.isNotEmpty) query += '&mobile=${searchMobile.value}';
    if (searchTelephone.value.isNotEmpty) query += '&telephone=${searchTelephone.value}';
    if (searchcontactName.value.isNotEmpty) query += '&contact_name=${searchcontactName.value}';
    if (searchSubsiDiary.value.isNotEmpty) query += '&subsidiary=${searchSubsiDiary.value}';
    print("API Query: accounts/get?$query");

    /// --------------------- Api Hit
    var response = await Api().get('accounts/get?$query');
    if (response.statusCode == 200) {
      listofAccount = ListOfAccountModel.fromJson(response.data);
      totalPages.value = listofAccount?.totalPages ?? 1;
      AccountList.value = listofAccount?.accounts ?? [];
      filteredAccount.value = AccountList;
    }
  } catch (e) {
    print("Error in List of Account: $e");
  } finally {
    isLoadingListOfAccount.value = false;
    update();
  }
}

// --------------------------------Search changes function
void onSearchChanged() {
  currentPage.value = 1; 
  listOFAccount();
}


/// ------------------------------------- pagination function
  void onPageChange(int page) {
    currentPage.value = page;
    listOFAccount(); 
  }



  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  List Escort Model

  ListEscortModel? listEscortModel;
  RxBool listEscortLoding = false.obs;
  Future<void> listEscort() async {
    try {
      listEscortLoding.value = true;
      var response = await Api().get('escorts/get');

      if (response.statusCode == 200) {
        listEscortModel = ListEscortModel.fromJson(response.data);

        print(
            'List of Account Error ------------------------------ $listEscortModel');
      } else {
        print("Status Code Error-------${response.statusCode}");
      }
    } catch (e) {
      print("Error in List of Account: $e");
    } finally {
      listEscortLoding.value = false;
      update();
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  create account invoice

  String? account;
  String? department;
  String? subDiary;
  String? status;
}
