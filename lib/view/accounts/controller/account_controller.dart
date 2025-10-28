import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/accounts/model/get_subsidiary_bank.dart';
import 'package:dashboard_new1/view/accounts/model/list_escort_model.dart';
import 'package:dashboard_new1/view/accounts/model/listof_account.dart'
    hide Subsidiary;
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
  Color pickerColor = Colors.blue; // currently selected color inside picker
  Color foregroundClr = Colors.blue;

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

  List<WebLoginClass> webLoginDataList = [];

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
  String? accountType;
  String? paymentType;
  String? adminFeesDropDown;
  String? accountTypeDropDown;
  String? commissionDropDown;

  RxBool postAccountDetailsLoader = false.obs;

  postAccount() async {
    postAccountDetailsLoader(true);

    List webLoginsTemp = [];

    for (var action in webLoginDataList) {
      webLoginsTemp.add({
        "account_number": action.account,
        "username": action.userName,
        "password": action.password,
        "mobile": action.mobile,
        "telephone": action.telphone,
      });
    }

    var formData = {
      "subsidiary_id": subsidiaryStoreValue!.id,
      "account_type": accountType,
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
      "payment_types": paymentType,
      "information": accountInformationController.text,
      "contact_name": accountContactNameController.text,
      "background_color": pickerColor,
      "foreground_color": foregroundClr,
      "agent_commission_type": commissionDropDown,
      "agent_commission": accountAgentCommissionController.text,
      "admin_fees_type": adminFeesDropDown,
      "admin_fees": accountAdminFeeController.text,
      "account_fees_type": accountTypeDropDown,
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
      "web_logins": webLoginsTemp,
      "departments": [
        {"name": dpartmentCtrl.text},
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
        {
          "order_number": orderCtrl.text,
        },
      ],
      "company_addresses": [
        {
          "address": addressCtrl.text,
        }
      ]
    };
    print(formData);

    var response = await Api().post(
      formData,
      accountObjectData != null ? "url add" : 'accounts/add',
      auth: true,
    );

    if (response.statusCode == 200) {
      print("✅ Account Created Successfully");
      accountObjectData = null;
      escoptCheckBox.value = false;
      arrivalSmsCheckBox.value = false;
      clearJobSmsCheckBox.value = false;
      bankInfoCheckBox.value = false;
      dpartmentCtrl.clear();
      contactAlertNameCtrl.clear();
      contactAlertEmailCtrl.clear();
      contactAlertPasswordCtrl.clear();
      contactAlertMobileCtrl.clear();
      contactAlertTelephoneCtrl.clear();
      orderCtrl.clear();
      accountType = null;
      subsidiaryStoreValue = null;
      addressCtrl.clear();
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
      // orderCheckBox = false.obs;

      update();
    } else {
      print("❌ Error Creating Account");
      print(response);
    }
  }

  SubsidairyBankModel? subsidairyBankModel;
  Subsidiary? subsidiaryStoreValue;

  RxBool SubsdairyBankLoader = false.obs;

  getSubsdairyBank() async {
    SubsdairyBankLoader(true);
    var response = await Api().get("subsidiaries/with-bank-details");
    if (response.statusCode == 200) {
      subsidairyBankModel = SubsidairyBankModel.fromJson(response.data);

      if (accountObjectData != null) {
        int index = subsidairyBankModel!.subsidiariesList!
            .indexWhere((test) => test.id == accountObjectData!.subsidiaryId);
        subsidiaryStoreValue = subsidairyBankModel!.subsidiariesList![index];
      }
      SubsdairyBankLoader(false);
      update();
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
  // currently selected color inside picker
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

  RxList<AccountObject> AccountList = <AccountObject>[].obs;
  RxList<AccountObject> filteredAccount = <AccountObject>[].obs;
  // search fields
  RxString searchName = ''.obs;
  RxString searchAccountType = ''.obs;
  RxString searchAddress = ''.obs;
  RxString searchEmail = ''.obs;
  RxString searchMobile = ''.obs;
  RxString searchTelephone = ''.obs;
  RxString searchcontactName = ''.obs;
  RxString searchSubsiDiary = ''.obs;

  AccountObject? accountObjectData;

  Future<void> listOFAccount() async {
    try {
      isLoadingListOfAccount.value = true;

      String query = 'page=${currentPage.value}&limit=$limit';
      if (searchName.value.isNotEmpty) query += '&name=${searchName.value}';
      if (searchAccountType.value.isNotEmpty)
        query += '&accountType=${searchAccountType.value}';
      if (searchAddress.value.isNotEmpty)
        query += '&address=${searchAddress.value}';
      if (searchEmail.value.isNotEmpty) query += '&email=${searchEmail.value}';
      if (searchMobile.value.isNotEmpty)
        query += '&mobile=${searchMobile.value}';
      if (searchTelephone.value.isNotEmpty)
        query += '&telephone=${searchTelephone.value}';
      if (searchcontactName.value.isNotEmpty)
        query += '&contact_name=${searchcontactName.value}';
      if (searchSubsiDiary.value.isNotEmpty)
        query += '&subsidiary=${searchSubsiDiary.value}';
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

  bindAccountUpdateValue({AccountObject? data}) async {
    accountObjectData = data;
    accountType = data!.accountType!.toString().capitalize;
    accountNameController.text = data.name.toString();
    accountCodeController.text = data.code.toString();
    accountEmailController.text = data.email.toString();
    accountPasswordController.text = data.password.toString();
    accountMobileController.text = data.mobile.toString();
    accountTelController.text = data.telephone.toString();
    accountFaxController.text = data.fax.toString();
    accountWebSiteController.text = data.website.toString();
    accountNumberController.text = data.accountNumber.toString();
    accountCreditCardController.text = data.creditCard.toString();
    accountAddressController.text = data.address.toString();
    paymentType = data.paymentTypes.toString().capitalize;
    accountInformationController.text = data.information.toString();
    accountContactNameController.text = data.contactName.toString();

    commissionDropDown = data.agentCommissionType!.toUpperCase().toString();
    accountAgentCommissionController.text = data.agentCommission.toString();
    adminFeesDropDown = data.adminFeesType!.toUpperCase().toString();
    accountAdminFeeController.text = data.adminFees.toString();
    accountTypeDropDown = data.accountFeesType!.toUpperCase().toString();
    accountAccountFeeController.text = data.accountFees.toString();
    bookedByCheckBox.value = data.hasBookedBy!;
    fareControllerCheckBox.value = data.fareController!;
    escoptCheckBox.value = data.hasEscort!;
    vatCheckBox.value = data.hasVat!;
    adminFeeCheckBox.value = data.adminFeesVat!;
    accountFeeCheckBox.value = data.accountFeesVat!;
    orderCheckBox.value = data.hasOrderNumber!;
    dispatchSmsCheckBox.value = data.dispatchCustomerText!;
    confirmSmsCheckBox.value = data.confirmationText!;
    arrivalSmsCheckBox.value = data.arrivalText!;
    clearJobSmsCheckBox.value = data.clearJobText!;
    bankInfoCheckBox.value = data.bankInformation!;
    // webLoginDataList.addAll(data.web_logins)
    update();
  }

// -----------Search changes function
  void onSearchChanged() {
    currentPage.value = 1;
    listOFAccount();
  }

  /// ------- pagination function
  void onPageChange(int page) {
    currentPage.value = page;
    listOFAccount();
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  List Escort Model
  EscortModel? listEscortModel;
  RxBool listEscortLoding = false.obs;
  RxList<Escorts> escortAll = <Escorts>[].obs;
  RxList<Escorts> escortFiltered = <Escorts>[].obs;
  // ye search fields hain
  RxString searchEscortName = ''.obs;
  RxString searchEscortSafeguarding = ''.obs;
  RxString searchEscortPAT = ''.obs;
  RxString searchEscortFirstAid = ''.obs;
  RxString searchEscortDBS = ''.obs;

//   ///------------------------- Pagination
  var escortCurrentPage = 1.obs;
  var escortTotalPages = 1.obs;
  final int escortLimit = 20;
  Future<void> listEscort() async {
    try {
      String query = 'page=${escortCurrentPage.value}&limit=${escortLimit}';
      if (searchEscortName.value.isNotEmpty)
        query += '&name=${searchEscortName.value}';
      if (searchEscortSafeguarding.value.isNotEmpty)
        query += '&safeguarding_expiry=${searchEscortSafeguarding.value}';
      if (searchEscortPAT.value.isNotEmpty)
        query += '&pat_expiry=${searchEscortPAT.value}';
      if (searchEscortFirstAid.value.isNotEmpty)
        query += '&firstaid_expiry=${searchEscortFirstAid.value}';
      if (searchEscortDBS.value.isNotEmpty)
        query += '&dbs_expiry=${searchEscortDBS.value}';
      print("API Query: escorts/get?$query");

      listEscortLoding.value = true;
      final response = await Api().get('escorts/get?$query');
      if (response.statusCode == 200) {
        listEscortModel = EscortModel.fromJson(response.data);
        escortTotalPages.value = listEscortModel?.totalPages ?? 1;
        escortAll.value = listEscortModel?.escorts ?? [];
        escortFiltered.value = escortAll;
        print('escorts: ${listEscortModel?.escorts?.length ?? 0}');
      }
    } catch (e) {
      print("Error in escorts: $e");
    } finally {
      listEscortLoding.value = false;
      update();
    }
  }

// // --------Search changes function
  void SearchEscort() {
    escortCurrentPage.value = 1;
    listEscort();
  }

//   /// ---------- pagination function
  void PageEscort(int page) {
    escortCurrentPage.value = page;
    listEscort();
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  create account invoice

  String? account;
  String? department;
  String? subDiary;
  String? status;
}

class WebLoginClass {
  String? account;
  String? userName;
  String? password;
  String? mobile;
  String? telphone;

  WebLoginClass(
      {this.mobile, this.password, this.account, this.telphone, this.userName});
}
