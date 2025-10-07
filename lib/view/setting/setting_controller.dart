


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class SettingController  extends GetxController{
  // Add your methods and properties here


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Template Settings functionality

  /// String variable
  String? selectedTemplateTitle;
  String? selectedTemplate;
  String? tagAssigned;

  /// text field controllers
   final templateTitleController = HtmlEditorController();
   final emailController = TextEditingController();

  void insertTagValue({value,bool temFormate = false}) async {
    String currentText = await templateTitleController.getText();
    String valueAdding = value.toString().replaceAll(" ", "_");
    if (currentText.trim().isEmpty || currentText.trim() == "<p></p>") {
      // 👇 Agar text empty hai
      if(temFormate == false){
        templateTitleController.setText("<p>{{$valueAdding}}</p>");
      }else{
        templateTitleController.setText("<p>$value</p>");
      }
    } else {
      // 👇 Agar text already hai
      templateTitleController.insertHtml("{{$valueAdding}}");
    }
    update();
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Template Settings functionality

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo company configuration functionality

  String? selectSubsidiaryValue;
  String? serviceValue;
  String? dateFormate;
  String? timeFormate;
  String? zoneFormate;
  String? typeAmount;
  String? deadMileageMethods;

/// text field controllers
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final hostController = TextEditingController();
  final portController = TextEditingController();
  final ccController = TextEditingController();
  final smsServiceIpController = TextEditingController();
  final smsHostController = TextEditingController();
  final smsPortController = TextEditingController();
  final smsUserNameController = TextEditingController();
  final smsPasswordController = TextEditingController();
  final serviceApiKeyController = TextEditingController();
  final mapApiKeyController = TextEditingController();
  final distanceFactorController = TextEditingController();
  final timeFactorController = TextEditingController();
  final tabbookingInHouss = TextEditingController();
  final tabBooksinday = TextEditingController();
  final tabrecentBooksinday = TextEditingController();
  final tabBooksAfterminuts = TextEditingController();
  final bookingExpiryNoties = TextEditingController();
  final airportBookingExpiryNotice = TextEditingController();
  final accountBookingExpiry = TextEditingController();
  final driverExpiryNotice = TextEditingController();
  final flightTrackerAPI = TextEditingController();
  final creditCardCharges = TextEditingController();
  final roundOffFares = TextEditingController();
  final discountOneWay = TextEditingController();
  final discountReturn = TextEditingController();
  final discountWaitAndReturn = TextEditingController();
  final huntGroup = TextEditingController();
  final baseAddress = TextEditingController();
  final deadMileageMiles = TextEditingController();



  /// bool
  RxBool secureConnectionValue = false.obs;
  final FocusNode secureConnectionNode = FocusNode();
  RxBool toggleAcceptEmailValue = false.obs;
  final FocusNode toggleAcceptEmailNode = FocusNode();
  RxBool toggleDeclineEmailValue = false.obs;
  final FocusNode toggleDeclineEmailNode = FocusNode();
  RxBool enableIncomingMessagesValue = false.obs;
  final FocusNode enableIncomingMessagesNode = FocusNode();
  RxBool toggleMapControlsValue = false.obs;
  final FocusNode toggleMapControlsNode = FocusNode();
  RxBool bookingQuotationSMSValue = false.obs;
  final FocusNode bookingQuotationSMSNode = FocusNode();
    RxBool enableBookingTextValue = false.obs;
  final FocusNode enableBookingTextNode = FocusNode();
    RxBool peakFactorsValue = false.obs;
  final FocusNode peakFactorsNode = FocusNode();
    RxBool webBookerConfValue = false.obs;
  final FocusNode webBookerConfNode = FocusNode();
    RxBool bookingDueNotiValue = false.obs;
  final FocusNode bookingDueNotiNode = FocusNode();
    RxBool enableCustomerValue = false.obs;
  final FocusNode enableCustomerNode = FocusNode();
    RxBool notificationValue = false.obs;
  final FocusNode notificationNode = FocusNode();
    RxBool deadMileageValue = false.obs;
  final FocusNode deadMileageNode = FocusNode();
    

/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo company configuration functionality

}