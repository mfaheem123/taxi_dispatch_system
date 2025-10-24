import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/accounts/model/list_escort_model.dart';
import 'package:dashboard_new1/view/accounts/model/listof_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create account form functionality
  /// RxBool variable
  RxBool activeDrivers = false.obs;

  final accountNameController = TextEditingController();
  final accountCodeController = TextEditingController();
  final accountEmailController = TextEditingController();
  final accountPasswordController = TextEditingController();
  final accountMobileController = TextEditingController();
  final accountTelController = TextEditingController();
  final accountFaxController = TextEditingController();
  final accountWebSiteController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountCreditCardController = TextEditingController();
  final accountAddressController = TextEditingController();
  final accountInformationController = TextEditingController();
  final accountContactNameController = TextEditingController();

  ///====FeeSection

  final accountAdminFeeController = TextEditingController();
  final accountAccountFeeController = TextEditingController();

  ///====Agent Commission

  final accountAgentCommissionController = TextEditingController();
  ///====WebLogin
  final webLoginaccountCtrl = TextEditingController();
  final webLoginusernameCtrl = TextEditingController();
  final webLoginpasswordCtrl = TextEditingController();
  final webLoginmobileCtrl = TextEditingController();
  final webLogintelephoneCtrl = TextEditingController();
  ///====ContactAlert
  final contactAlertNameCtrl = TextEditingController();
  final contactAlertEmailCtrl = TextEditingController();
  final contactAlertPasswordCtrl = TextEditingController();
  final contactAlertMobileCtrl = TextEditingController();
  final contactAlertTelephoneCtrl = TextEditingController();
  ///DepartmentAlert
  final dpartmentCtrl = TextEditingController();
  ///OderAlert
  final orderCtrl = TextEditingController();
  ///CompanyAddressAlert
  final addressCtrl = TextEditingController();


  ///Information Control
  RxBool orderCheckBox = false.obs;
  RxBool bookedByCheckBox = false.obs;
  RxBool escoptCheckBox = false.obs;
  RxBool fareControllerCheckBox = false.obs;
  RxBool bankInfoCheckBox = false.obs;
  ///Charges Control
  RxBool adminFeeCheckBox = false.obs;
  RxBool accountFeeCheckBox = false.obs;
  RxBool vatCheckBox = false.obs;
  ///SMS Control
  RxBool dispatchSmsCheckBox = false.obs;
  RxBool confirmSmsCheckBox = false.obs;
  RxBool arrivalSmsCheckBox = false.obs;
  RxBool clearJobSmsCheckBox = false.obs;
  ///====String
  String? bankAccount;
  String? AccountType;




  RxBool postAccountDetailsLoader = false.obs;

  postAccount() async {
    postAccountDetailsLoader(true);

    var response = await Api().post(
      {
        "subsidiary_id": 1,
        "account_type": AccountType,
        "closed": false,
        "name": accountNameController.text,
        "code": accountCodeController.text,
        "email": accountEmailController.text,
        "password": accountPasswordController.text,
        "mobile": accountMobileController.text,
        "telephone": accountTelController.text,
        "fax": accountFaxController.text,
        "website": accountWebSiteController.text,
        "account_number": accountNumberController.text,
        "credit_card": accountCreditCardController.text,
        "address": accountAddressController.text,
        // "payment_types": paymentTypeValue,
        "information": accountInformationController.text,
        "contact_name": accountContactNameController.text,
        "background_color": null,
        "foreground_color": null,
        // "agent_commission_type": agentCommissionTypeValue,
        "agent_commission": accountAgentCommissionController.text,
        // "admin_fees_type": adminFeesTypeValue,
        "admin_fees": accountAdminFeeController.text,
        // "account_fees_type": accountFeesTypeValue,
        "account_fees": accountAccountFeeController.text,
        "has_booked_by": bookedByCheckBox.value,
        "fare_controller": fareControllerCheckBox.value,
        "has_escort": escoptCheckBox.value,
        "has_vat": vatCheckBox.value,
        "admin_fees_vat": adminFeeCheckBox.value,
        "account_fees_vat": accountFeeCheckBox.value,
        "has_order_number": orderCheckBox.value,
        "dispatch_customer_text": dispatchSmsCheckBox.value,
        "confirmation_text": confirmSmsCheckBox.value,
        "arrival_text": arrivalSmsCheckBox.value,
        "clear_job_text": clearJobSmsCheckBox.value,
        "bank_information": bankInfoCheckBox.value,

        "web_logins": [
          {
            "account_number": webLoginaccountCtrl.text,
            "username": webLoginusernameCtrl.text,
            "password": webLoginpasswordCtrl.text,
            "mobile": webLoginmobileCtrl.text,
            "telephone": webLogintelephoneCtrl.text,
          }
        ],


        "departments": [
          {
            "name": dpartmentCtrl.text
          },
        ],
        "contacts": [
          {
            "name": contactAlertNameCtrl.text,
            "email": contactAlertEmailCtrl.text,
            "password": contactAlertPasswordCtrl.text,
            "mobile": contactAlertMobileCtrl.text,
            "telephone": contactAlertTelephoneCtrl.text,
          }
        ],

        "order_numbers": [
          { "order_number": orderCtrl.text, },

        ],

        "company_addresses": [
          { "address":addressCtrl.text, }
        ]
      },
      'accounts/add',
      auth: true,
    );

    if (response.statusCode == 200) {
      print("✅ Account Created Successfully");
      print(response.data);
      accountNameController.clear();
      accountCodeController.clear();
      accountEmailController.clear();
      accountPasswordController.clear();
      accountMobileController.clear();
      accountTelController.clear();
      accountFaxController.clear();
      accountWebSiteController.clear();
      accountNumberController.clear();
      accountCreditCardController.clear();
      accountAddressController.clear();
      accountInformationController.clear();
      accountContactNameController.clear();
      accountAdminFeeController.clear();
      accountAccountFeeController.clear();
      webLoginaccountCtrl.clear();
      webLoginusernameCtrl.clear();
      webLoginpasswordCtrl.clear();
      webLoginmobileCtrl.clear();
      webLogintelephoneCtrl.clear();
      orderCheckBox=false.obs;

      update();
    } else {
      print("❌ Error Creating Account");
      print(response);
    }
  }



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
  // RxBool orderCheckBox = false.obs;
  // RxBool bookedByCheckBox = false.obs;
  // RxBool escoptCheckBox = false.obs;
  // RxBool fareControllerCheckBox = false.obs;
  // RxBool bankInfoCheckBox = false.obs;
  // RxBool adminFeeCheckBox = false.obs;
  // RxBool accountFeeCheckBox = false.obs;
  // RxBool vatCheckBox = false.obs;
  // RxBool dispatchSmsCheckBox = false.obs;
  // RxBool confirmSmsCheckBox = false.obs;
  // RxBool arrivalSmsCheckBox = false.obs;
  // RxBool clearJobSmsCheckBox = false.obs;
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
