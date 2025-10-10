

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
  Color pickerColor = Colors.blue;   // currently selected color inside picker
  Color foregroundClr = Colors.blue;   // currently selected color inside picker
  Color currentColor = Colors.blue;  // applied color on the UI
  Color foregroundCurrentColor = Colors.blue;  // applied color on the UI

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



/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  create account invoice

  String? account;
  String? department;
  String? subDiary;
  String? status;

}