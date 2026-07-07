import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/Model/image_model.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/setting/shortcut_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pdf/pdf.dart';

import 'model/select_templete_type.dart';
import 'model/templete_HTML_model.dart' hide TemplateType;
import 'model/templete_by_type_model.dart';

import 'dart:typed_data';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;

class SettingController extends GetxController {
  // Add your methods and properties here

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Template Settings functionality

  /// String variable
  String? selectedTemplateTitle;
  String? selectedTemplate;
  String? tagAssigned;

  // RxBool showDownloadButtons = false.obs;

  /// text field controllers
  final templateTitleController = HtmlEditorController();
  final emailController = TextEditingController();

  void insertTagValue({value, bool temFormate = false}) async {
    String currentText = await templateTitleController.getText();
    String valueAdding = value.toString().replaceAll(" ", "_");
    if (currentText.trim().isEmpty || currentText.trim() == "<p></p>") {
      // 👇 Agar text empty hai
      if (temFormate == false) {
        templateTitleController.setText("<p>{{$valueAdding}}</p>");
      } else {
        templateTitleController.setText("<p>$value</p>");
      }
    } else {
      // 👇 Agar text already hai
      templateTitleController.insertHtml("{{$valueAdding}}");
    }
    update();
  }

  TempTypeModel? selectTempleteType;
  TemplateType? selectedTemplateType;
  bool templateTypeLoad = false;

  getTemplateTypes() async {
    templateTypeLoad = true;
    var response = await Api().get("templates/template_types", sendCompanyId: true,);
    if (response.statusCode == 200) {
      selectTempleteType = TempTypeModel.fromJson(response.data);
      selectedTemplateType = selectTempleteType!.templateTypes![1];
      templateTypeLoad = false;
      update();
    }
  }

  TempleteByTypeMOdel? templeteByTypeMOdel;
  Template? template;
  bool templatebyTypeLoad = false;

  getTemplateByTypes({selectedTempId}) async {
    if (selectTempleteType == null) {
      BotToast.showText(text: "Please select template type first");
      return;

    }
    templatebyTypeLoad = true;
    var response = await Api().get(
        "templates/get_templates_by_types?template_type_id=$selectedTempId", sendCompanyId: true,);
    if (response.statusCode == 200) {
      templeteByTypeMOdel = TempleteByTypeMOdel.fromJson(response.data);
      templatebyTypeLoad = false;
  update();
    }
  }

  HtmlTempleteModel? templeteHtmlModel;
  bool loadHtml = false;
  getTemplateHtmlText({selectedTempId}) async {
    if (template == null) return;
    loadHtml = true;
    var response =
        await Api().get("templates/template_setting?id=$selectedTempId");
    if (response.statusCode == 200) {
      templeteHtmlModel = HtmlTempleteModel.fromJson(response.data);
      templateTitleController.setText(templeteHtmlModel?.templates?.content ?? "");
      loadHtml = false;
      update();
    }
  }


  bool loadingtemp = false;
  updateTemplateHtml({required int templateId}) async {
    loadingtemp = true;
    String htmlText = await templateTitleController.getText();
    update();
    var  formData= {
      "content": htmlText, // edited text
    };
    var response = await Api().post(
      formData,
      "templates/edit_templates/$templateId",
    );
    if (response.statusCode == 200) {
      getTemplateHtmlText(selectedTempId: "$templateId");
      BotToast.showText(text: "Successfully UPDATE ");
    } else {
      BotToast.showText(text: "Error, Update failed");
    }
    loadingtemp = false;
    update();
  }


//// Template setting download function
  //
  // Future<void> downloadPdfWebDynamic() async {
  //   try {
  //     final list = await getTemplateHtmlText(selectedTempId: templeteHtmlModel!.templates!.id!);
  //     if (list.isEmpty) return;
  //
  //     final pdf = pw.Document();
  //
  //     // headers = API keys
  //     final headers = list.first.keys.toList();
  //     // rows = API values
  //     final data = list.map((row) {
  //       return headers.map((key) {
  //         final value = row[key];
  //         return value == null ? '' : value.toString();
  //       }).toList();
  //     }).toList();
  //
  //     pdf.addPage(
  //       pw.Page(
  //         build: (context) {
  //           return pw.Table.fromTextArray(
  //             headers: headers,
  //             data: data,
  //             border: pw.TableBorder.all(),
  //             headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //           );
  //         },
  //       ),
  //     );
  //
  //     final pdfData = await pdf.save();
  //     final bytes = Uint8List.fromList(pdfData);
  //
  //     final blob = html.Blob([bytes], 'application/pdf');
  //     final url = html.Url.createObjectUrlFromBlob(blob);
  //
  //     html.AnchorElement(href: url)
  //       ..setAttribute("download", "invoice.pdf")
  //       ..click();
  //
  //     html.Url.revokeObjectUrl(url);
  //   } catch (e) {
  //     print("PDF Error: $e");
  //   }
  // }

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
  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo document number functionality
  final TextEditingController prefixController = TextEditingController();
  final TextEditingController startNumberController = TextEditingController(text: "0");
  final TextEditingController incrementController = TextEditingController(text: "0");

  String? selectedTable;
  String? selectedColumn;
  String? selectedSubsidiary;


  void changeCounterValue(TextEditingController textController, bool isIncrement) {
    int val = int.tryParse(textController.text) ?? 0;
    if (isIncrement) {
      val++;
    } else {
      val--;
    }
    textController.text = val.toString();
    update();
  }
  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo document number functionality

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Company Information

  /// color pick
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

  final nameController = TextEditingController();
  final emailCompanyController = TextEditingController();
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
  final abbreviationController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Company Information

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo LocationShortcuts Work

  LocationShortCutModel? locationShortCut;
  RxBool getShortCutLoader = false.obs;
  getShortCut() async {
    getShortCutLoader(true);
    var response = await Api().get("location-types");
    if (response.statusCode == 200) {
      locationShortCut = LocationShortCutModel.fromJson(response.data);
      getShortCutLoader(false);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo LocationShortcuts Work

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Chat screen

  String? selectMessageRole;
  RxBool sendToAllValue = false.obs;
  final FocusNode sendToAllNode = FocusNode();
}
