


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController{

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo adding customer functionality
  RxBool enableSms = false.obs;

  /// text fields controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final telController = TextEditingController();
  final doorController = TextEditingController();
  final noteController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo adding customer functionality

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality
  String? selectFilterType;
  RxBool blackList = false.obs;

  /// text fields controllers
  final keyWordsController = TextEditingController();

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

  /// text fields controllers
  final detailOfPropertyController = TextEditingController();
  final methodOfDespositionController = TextEditingController();
  final checkedByController = TextEditingController();
  final enquiryController = TextEditingController();
  final resultController = TextEditingController();

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

  /// int variables
  int bookingRadio = 0;

  /// String variables
  String? selectDriver;



  /// text fields controllers
  final refNoController = TextEditingController();
  final regController = TextEditingController();
  final complaintController = TextEditingController();
  final howDealWithController = TextEditingController();

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

}