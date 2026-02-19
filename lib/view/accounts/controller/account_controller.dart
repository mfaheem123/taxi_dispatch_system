import 'dart:convert';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/accounts/model/get_subsidiary_bank.dart';
import 'package:dashboard_new1/view/accounts/model/list_escort_model.dart';
import 'package:dashboard_new1/view/accounts/model/listof_account.dart'
    hide Subsidiary;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart' as dio
    hide MultipartFile;
import 'package:dio/dio.dart' as dio_package;
import 'dart:html' as html;
import '../../../Model/image_model.dart';
import '../../administration/model/list_subsDiary.dart';
import '../../setting/model/templete_HTML_model.dart';
import '../Invoice/create_customer_invoice.dart';
import 'package:file_picker/file_picker.dart';
import '../../../Model/image_model.dart';
import 'package:dio/dio.dart' as dio;

import '../model/account_invoice_booking_model.dart';
import '../model/account_invoice_model.dart';
import '../model/list_of_account_invoice_model.dart' hide Subsidiary;

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
  Color pickerColor = Color(0xFF2196F3); // Initial value
  Color foregroundClr = Color(0xFF2196F3); // Initial value

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

  ///list of departments
  final List<String> accountDepartmentList = [];
  final List contactsList = [];
  final List orderAccountList = [];
  final List companyAddressesList = [];

  RxBool postAccountDetailsLoader = false.obs;

  postAccount() async {
    postAccountDetailsLoader(true);

    List webLoginsTemp = [];
    List accountDepartmentPostList = [];

    if (accountDepartmentList.isNotEmpty) {
      for (var action in accountDepartmentList) {
        accountDepartmentPostList.add({"name": action});
      }
    }

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
      "background_color": pickerColor.value.toRadixString(16).substring(2),
      "foreground_color": foregroundClr.value.toRadixString(16).substring(2),
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
      if (accountDepartmentList.isNotEmpty)
        "departments": accountDepartmentPostList,
      if (contactsList.isNotEmpty) "contacts": contactsList,
      if (orderAccountList.isNotEmpty) "order_numbers": orderAccountList,
      if (companyAddressesList.isNotEmpty)
        "company_addresses": companyAddressesList
    };

    var response = await Api().post(
      formData,
      accountObjectData != null
          ? "accounts/edit/${accountObjectData!.id}"
          : 'accounts/add',
      auth: true,
    );

    if (response.statusCode == 200) {
      print("✅ Account Created Successfully");
      accountObjectData = null;
      escoptCheckBox.value = false;
      arrivalSmsCheckBox.value = false;
      clearJobSmsCheckBox.value = false;
      bankInfoCheckBox.value = false;

      orderCheckBox.value = false;
      bookedByCheckBox.value = false;
      fareControllerCheckBox.value = false;
      adminFeeCheckBox.value = false;
      accountFeeCheckBox.value = false;
      vatCheckBox.value = false;
      dispatchSmsCheckBox.value = false;
      confirmSmsCheckBox.value = false;

      dpartmentCtrl.clear();
      contactAlertNameCtrl.clear();
      contactAlertEmailCtrl.clear();
      contactAlertPasswordCtrl.clear();
      contactAlertMobileCtrl.clear();
      accountDepartmentList.clear();
      contactsList.clear();
      orderAccountList.clear();
      companyAddressesList.clear();
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
        subsidiaryStoreValue =
        subsidairyBankModel!.subsidiariesList![index] as Subsidiary?;
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

  @override
  void onInit() {
    super.onInit();
    // Template fetch
    getTemplateHtmlText();
  }

  HtmlTempleteModel? templeteHtmlModel;
  bool loadHtml = false;
  getTemplateHtmlText() async {
    loadHtml = true;
    var response = await Api().get("templates/template_setting?id=16");
    if (response.statusCode == 200) {
      templeteHtmlModel = HtmlTempleteModel.fromJson(response.data);
      loadHtml = false;
      update();
    }
  }

  Future<void> downloadApiContentAsFile() async {
    final String htmlContent = templeteHtmlModel?.templates?.content ?? '';

    if (htmlContent.isEmpty) {
      print('No content to download');
      return;
    }
    final bytes = utf8.encode(htmlContent);
    final blob = html.Blob([bytes], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "invoice.html")
      ..click();

    html.Url.revokeObjectUrl(url);
  }

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
  RxBool showDownloadButtons = false.obs;

  List<InvoiceRow> invoiceList = [
    InvoiceRow(
      ref: "REF001",
      datetime: "12-09-2025",
      pickup: "Heathrow",
      dropoff: "NW7",
      fare: "£55.00",
      pickup1: "Heathrow",
      dropoff2: "NW7",
      fare3: "£55.00",
    ),
  ];

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  List OF Account Api controller

  ListOfAccountModel? listofAccount;

  ///--------------------- Pagination
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
  listOFAccount() async {
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
    accountDepartmentList.clear();
    for (var action in data.departments!) {
      accountDepartmentList.add(action.name!);
    }
    for (var action in data.contacts!) {
      contactsList.add({
        "name": action.name,
        "email": action.email,
        "password": action.password,
        "mobile": action.mobile,
        "telephone": action.telephone,
      });
    }
    for (var action in data.orderNumbers!) {
      orderAccountList.add({
        "order_number": action.orderNumber,
      });
    }
    for (var action in data.companyAddresses!) {
      companyAddressesList.add({
        "address": action.address,
      });
    }

    // webLoginDataList.addAll(data.web_logins)
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create escort

  final escortName = TextEditingController();
  final escortEmail = TextEditingController();
  final escortMobile = TextEditingController();
  final escortAddress = TextEditingController();
  String? dobDate = "2000-01-01";
  String? safeguardingExpiryExpireDate = "2000-01-01";
  String? patExpiryDate = "2000-01-01";
  String? firstAidDate = "2000-01-01";
  final dbsExpireTime = TextEditingController();
  final safeguardingBatch = TextEditingController();
  final PATBatch = TextEditingController();
  final firstAidBatch = TextEditingController();
  final DBSBatch = TextEditingController();

  Uint8List? safeguardingDocPic;
  Uint8List? patDocPic;
  Uint8List? firstAidDocPic;
  Uint8List? dbsDocPic;

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

  RxBool isEscortUpdating = false.obs;
  createEscort() async {
    isEscortUpdating.value = true;
    update();

    dio.MultipartFile? profileFile;
    dio.MultipartFile? safeguardingFile;
    dio.MultipartFile? patFile;
    dio.MultipartFile? firstAidFile;
    dio.MultipartFile? dbsFile;
    if (profileImg != null) {
      profileFile = dio.MultipartFile.fromBytes(
        profileImg!.bytes,
        filename: profileImg!.name,
      );
    }
    if (safeguardingDocPic != null) {
      safeguardingFile = dio.MultipartFile.fromBytes(
        safeguardingDocPic!,
        filename: "safeguarding.png",
      );
    }
    if (patDocPic != null) {
      patFile = dio.MultipartFile.fromBytes(
        patDocPic!,
        filename: "pat.png",
      );
    }
    if (firstAidDocPic != null) {
      firstAidFile = dio.MultipartFile.fromBytes(
        firstAidDocPic!,
        filename: "firstaid.png",
      );
    }
    if (dbsDocPic != null) {
      dbsFile = dio.MultipartFile.fromBytes(
        dbsDocPic!,
        filename: "dbs.png",
      );
    }
    final Map<String, dynamic> baseData = {
      if (profileFile != null) "image": profileFile,
      if (safeguardingFile != null) "safeguarding_document": safeguardingFile,
      if (patFile != null) "pat_document": patFile,
      if (firstAidFile != null) "firstaid_document": firstAidFile,
      if (dbsFile != null) "dbs_document": dbsFile,
      "name": escortName.text,
      "email": escortEmail.text,
      "mobile": escortMobile.text,
      "address": escortAddress.text,
      "dob": dobDate,
      "safeguarding_number": safeguardingBatch.text,
      "pat_number": PATBatch.text,
      "firstaid_number": firstAidBatch.text,
      "dbs_number": DBSBatch.text,
      "safeguarding_expiry": safeguardingExpiryExpireDate,
      "pat_expiry": patExpiryDate,
      "firstaid_expiry": firstAidDate,
      "dbs_expiry": dbsExpireTime.text,
      "active": "false",
    };
    var formData = dio.FormData.fromMap(baseData);
    var response =
    await Api().post(formData, 'escorts/add', auth: true, multiPart: true);
    if (response.statusCode == 200) {
      escortName.clear();
      escortEmail.clear();
      escortMobile.clear();
      escortAddress.clear();
      safeguardingBatch.clear();
      PATBatch.clear();
      firstAidBatch.clear();
      DBSBatch.clear();
      profileImg = null;
      safeguardingDocPic = null;
      patDocPic = null;
      firstAidDocPic = null;
      dbsDocPic = null;
      BotToast.showText(text: "Success, Escort Created Successfully");
      isEscortUpdating.value = false;
      update();
    }
  }

  escortDelete(int? id) async {
    var response = await Api().delete("escorts/delete/$id");
    if (response.statusCode == 200) {
      listOFAccount();
      BotToast.showText(text: "Success, Escort Deleted Successfully");
      print("Escort deleted successfully!");
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  List Escort Model
  // selected items
  Set<String> selectedIds = {};
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
  final int escortLimit = 10;
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

  // create controller


  // update controller
  TextEditingController updateCustomerTelephoneController = TextEditingController();


  var invoiceNumber = ''.obs; //create
  var updateInvoiceNumber = ''.obs; // update



  // for update screen


  // dropdown API's:
  SubsDiaryModel? subsDiaryModel;
  // update invoice
  Rx<Subsidiaries?> updateSelectedSubsidiary = Rx<Subsidiaries?>(null);

  bool isSubsidiary = false;

  // ===== UPDATE FUNCTION =====
  getUpdateSubsidiary() async {
    isSubsidiary = true;
    update();

    var response = await Api().get("subsidiaries/get");
    if (response.statusCode == 200) {
      subsDiaryModel = SubsDiaryModel.fromJson(response.data);
      if (subsDiaryModel!.subsidiaries!.isNotEmpty) {
        // update ke liye selected value
        // if (updateSelectedSubsidiary.value?.id != null) {
        //   await getAccountsBySubsidiary(updateSelectedSubsidiary.value!.id!);
        // }
      }
      isSubsidiary = false;
      update();
    }
  }
  //
  // AccountInvoiceModel? accountInvoiceModel;
  // // create invoice
  // Rx<Account?> selectedAccount = Rx<Account?>(null);
  // // update invoice
  // Rx<Account?> updateSelectedAccount = Rx<Account?>(null);
  //
  // List<Account> accountList = [];
  // bool isAccountLoading = false;
  //
  //
  //
  // //for update screen
  // getUpdateAccountsBySubsidiary(int subsidiaryId) async {
  //   isAccountLoading = true;
  //   update();
  //
  //   var response = await Api().get("accounts/subsidiary/$subsidiaryId");
  //   if (response.statusCode == 200) {
  //     accountInvoiceModel = AccountInvoiceModel.fromJson(response.data);
  //     accountList = accountInvoiceModel?.accounts ?? [];
  //   } else {
  //     accountInvoiceModel = null;
  //     accountList = [];
  //   }
  //   updateSelectedAccount.value = null;
  //   isAccountLoading = false;
  //   update();
  // }
  //
  // department dropdown
  RxList<String> departmentList = RxList<String>([]);
  // create invoice
  Rx<String?> selectedDepartment = Rx<String?>(null);
  // update invoice
  Rx<String?> updateSelectedDepartment = Rx<String?>(null);

  // void updateDepartmentsForSelectedAccount() {
  //   if (selectedAccount.value != null) {
  //     departmentList.value = selectedAccount.value!.departments
  //         ?.where((d) => d.name != null)
  //         .map((d) => d.name!)
  //         .toList() ??
  //         [];
  //   } else {
  //     departmentList.clear();
  //   }
  //   selectedDepartment.value = null;
  //   update();
  // }

  // // for update screen
  // void updateDepartmentsForSelectedAccountUpdate() {
  //   if (updateSelectedAccount.value != null) {
  //     departmentList.value = updateSelectedAccount.value!.departments
  //         ?.where((d) => d.name != null)
  //         .map((d) => d.name!)
  //         .toList() ??
  //         [];
  //   } else {
  //     departmentList.clear();
  //   }
  //   updateSelectedDepartment.value = null;
  //   update();
  // }







  // String? account;
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