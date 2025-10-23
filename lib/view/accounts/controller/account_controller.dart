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

  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 2;

  RxBool isLoadingListOfAccount = false.obs;

  ListOfAccountModel? listofAccount;

  Future<void> listOFAccount() async {
    try {
      isLoadingListOfAccount.value = true;
      var response = await Api().get(
        'accounts/get',
        queryParameters: {
          'page': currentPage.value,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        listofAccount = ListOfAccountModel.fromJson(response.data);

        totalPages.value = listofAccount?.totalPages ?? 1;
        print("Response data: ${response.data}");

        print(
            'List of Account Error ------------------------------ ${listofAccount}');
      } else {
        print("Status Code Error-------${response.statusCode}");
      }
    } catch (e) {
      print("Error in List of Account: $e");
    } finally {
      isLoadingListOfAccount.value = false;
      update();
    }
  }

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
