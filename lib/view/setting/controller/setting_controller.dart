import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/Model/image_model.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/setting/payment_types_color.dart';
import 'package:dashboard_new1/view/setting/shortcut_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pdf/pdf.dart';
import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import '../../administration/model/list_subsDiary.dart';
import '../../drivers_view/model/driver_commission_payment_model.dart';
import '../model/get_clear_booking_model.dart';
import '../model/get_document_number_model.dart';
import '../model/select_templete_type.dart';
import '../model/templete_HTML_model.dart' hide TemplateType;
import '../model/templete_by_type_model.dart';

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
  final Map<String, List<String>> tableColumnsMap = {
    "booking": ["reference_number"],
    "complaint": ["reference_number"],
    "account_invoice": ["invoice_number"],
    "account_pre_invoice": ["invoice_number"],
    "customer_invoice": ["invoice_number"],
    "customer_pre_invoice": ["invoice_number"],
    "driver_commission": ["transaction_number"],
    "lost_property": ["lost_number"],
  };

  void onTableChanged(String? table) {
    selectedTable = table;
    if (table != null && tableColumnsMap.containsKey(table)) {
      selectedColumn = tableColumnsMap[table]!.first;
    } else {
      selectedColumn = null;
    }
    update();
  }

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

  /// subsidiary api
  SubsDiaryModel? subsDiaryModel;
  // Subsidiaries? subsidiaries;
  String? selectedSubsidiaryId;
  bool isSubsidiary = false;

  getDocumentSubsidiary() async {
    isSubsidiary = true;
    var response = await Api().get("subsidiaries/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      subsDiaryModel = SubsDiaryModel.fromJson(response.data);
      isSubsidiary = false;
      update();
    }
  }

  /// list document number

  GetDocumentNumberModel? getDocumentNumberModel;
  bool isDocumentNumber = false;

  getDocumentNumber() async {
    isDocumentNumber = true;
    update();

    var response = await Api().get("document/document_numbers/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      getDocumentNumberModel = GetDocumentNumberModel.fromJson(response.data);
    }
    isDocumentNumber = false;
    update();
  }

  /// save api

  bool isAddNumber = false;
  saveDocumentNumber() async {
    isAddNumber = true;
    update();

    var formData = {
      "subsidiary_id": int.tryParse(selectedSubsidiaryId!) ?? 0,
      "document_table": selectedTable.toString(),
      "document_column": selectedColumn.toString().trim(),
      "prefix": prefixController.text,
      "start_number": int.tryParse(startNumberController.text) ?? 1,
      "increment_value": int.tryParse(incrementController.text) ?? 1,
      "auto_increment": true,
      "company_id": 1,
    };
    try {
      var response = await Api().post(
          formData,
          updateDocumentNumber.value == false
              ? "document/document_numbers/add"
              : "document/document_numbers/update/${documentUpdateId.value}"
      );

      print("🔴 SERVER RESPONSE: ${response.statusCode} -> ${response.data}");

      if (response.statusCode == 200) {
        BotToast.showText(text: updateDocumentNumber.value == true
            ? "DOCUMENT NUMBER UPDATED SUCCESSFULLY!"
            : "DOCUMENT NUMBER ADDED SUCCESSFULLY!"
        );
        print("API Response: ${response.data}");
        clearFields();
        getDocumentNumber();
        Get.back();
      } else {
        BotToast.showText(text: "Failed to add document number");
      }
    } catch (e) {
      print("❌ CRITICAL API ERROR: $e");
      BotToast.showText(text: "Error: $e");
    } finally {
      isAddNumber = false;
      update();
    }
  }

  /// Edit
  RxBool updateDocumentNumber = false.obs;
  RxInt documentUpdateId = 0.obs;
  bindDocumentNumber(DocumentNumber document) {
    selectedTable = document.documentTable.toString().toLowerCase();
    selectedColumn = document.documentColumn.toString().toLowerCase();
    selectedSubsidiaryId = document.subsidiaryId.toString() ?? "";
    prefixController.text = document.prefix ?? "";
    startNumberController.text = document.startNumber.toString();
    incrementController.text = document.incrementValue.toString();

    updateDocumentNumber(true);
    documentUpdateId(document.id);
  }

  void clearFields() {
    selectedTable = null;
    selectedColumn = null;
    selectedSubsidiaryId = null;
    prefixController.clear();
    startNumberController.text = "0";
    incrementController.text = "0";
    updateDocumentNumber(false);
    documentUpdateId(0);
    update();
  }

  /// delete APi

  documentNumberDelete(int? id) async {
    var response = await Api().delete("document/document_numbers/delete/$id");
    if (response.statusCode == 200) {
      BotToast.showText(text:"DOCUMENT NUMBER DELETED SUCCESSFULLY!");
      getDocumentNumber();
    }
  }
  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo document number functionality
  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo payment type  functionality

  DriverCommissionPaymentModel? driverCommissionPaymentModel;
  bool isLoadingPaymentTypes = false;


  getSettingPaymentTypes() async {
    isLoadingPaymentTypes = true;
    update();

    try {
      var response = await Api().get("enumerations/payment-types");
      if (response.statusCode == 200) {
        driverCommissionPaymentModel = DriverCommissionPaymentModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint("Error fetching payment types: $e");
    } finally {
      isLoadingPaymentTypes = false;
      update();
    }
  }

  Color parseColor(String? hexString, Color defaultColor) {
    if (hexString == null || hexString.isEmpty) return defaultColor;
    try {
      String hex = hexString.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse("FF$hex", radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return defaultColor;
  }


  var isUpdatingPayment = false.obs;
  var paymentBackgroundHex = "".obs;
  var paymentForegroundHex = "".obs;

// Update API function
  updatePaymentTypeColor(int paymentId) async {
    isUpdatingPayment.value = true;
    update();

    var formData = {
      "background_color": paymentBackgroundHex.value,
      "foreground_color": paymentForegroundHex.value,
    };

    try {
      var response = await Api().post(
        formData,
        "enumerations/payment-types/update/$paymentId",
      );

      print("SERVER RESPONSE: ${response.statusCode} -> ${response.data}");

      if (response.statusCode == 200) {
        BotToast.showText(text: "PAYMENT COLOR UPDATED SUCCESSFULLY!");
        getSettingPaymentTypes();
      } else {
        BotToast.showText(text: "FAILED TO UPDATE COLOR!");
      }
    } catch (e) {
      print("Error: $e");
      BotToast.showText(text: "SOMETHING WENT WRONG!");
    } finally {
      isUpdatingPayment.value = false;
      update();
    }
  }
  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo payment type  functionality
  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo clear booking  functionality

  ClearBookingModel? clearBookingModel;
  List<String> selectedBookingIds = [];
  bool isClearingSelected = false;
  bool isLoadingBooking = false;

  void toggleSelection(String id) {
    if (selectedBookingIds.contains(id)) {
      selectedBookingIds.remove(id);
    } else {
      selectedBookingIds.add(id);
    }
    update();
  }

  getBookingsToClear() async {
    isLoadingBooking = true;
    update();

    var response = await Api().get("bookings/clear");
    if (response.statusCode == 200) {
      clearBookingModel = ClearBookingModel.fromJson(response.data);
    }
    isLoadingBooking = false;
    update();
  }

  clearSelectedBookings() async {
    if (selectedBookingIds.isEmpty) return;

    isClearingSelected = true;
    update();

    int? driverId;
    if (clearBookingModel?.bookings != null) {
      final selectedBooking = clearBookingModel!.bookings!.firstWhereOrNull(
            (b) => b.id.toString() == selectedBookingIds.first,
      );
      driverId = selectedBooking?.driverId;
    }

    List<int> parsedIds = selectedBookingIds
        .map((id) => int.tryParse(id))
        .whereType<int>()
        .toList();

    var formData = dio.FormData.fromMap({
      "driver_id": driverId ?? 0,
      "ids[]": parsedIds
    });

    try {
      var response = await Api().post(
        formData,
        "bookings/clear-selected", auth: true,
      );

      print("SERVER RESPONSE STATUS CODE: ${response.statusCode}");
      print("SERVER RESPONSE DATA: ${response.data}");

      if (response.statusCode == 200) {
        BotToast.showText(text: "BOOKINGS CLEARED SUCCESSFULLY!");
        selectedBookingIds.clear();
        await getBookingsToClear();
      } else {
        BotToast.showText(text: "FAILED TO CLEAR BOOKINGS!");
      }
    } catch (e) {
      print("Error: $e");
      BotToast.showText(text: "SOMETHING WENT WRONG!");
    } finally {
      isClearingSelected = false;
      update();
    }
  }

  bool isClearingAll = false;

  clearAllBookings() async {
    isClearingAll = true;
    update();

    try {

      var response = await Api().post(
        {},
        "bookings/clear-all", auth: true,
      );

      print("CLEAR ALL STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        BotToast.showText(text: "ALL BOOKINGS CLEARED SUCCESSFULLY!");
        selectedBookingIds.clear();
        await getBookingsToClear();
      } else {
        BotToast.showText(text: "FAILED TO CLEAR ALL BOOKINGS!");
      }
    } catch (e) {
      print("Error in clear-all: $e");
      BotToast.showText(text: "SOMETHING WENT WRONG!");
    } finally {
      isClearingAll = false;
      update();
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo clear booking  functionality

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
  String? networkLogoUrl;
  final bankController = TextEditingController();
  final accountTitleController = TextEditingController();
  final accountController = TextEditingController();
  final ibanController = TextEditingController();
  final sortCodeController = TextEditingController();
  final vatController = TextEditingController();
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
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo sms tracking Work


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo sms tracking Work
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo call recordings Work

  final mobileController = TextEditingController();
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo call recordings Work

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Chat screen

  String? selectMessageRole;
  RxBool sendToAllValue = false.obs;
  final FocusNode sendToAllNode = FocusNode();
}
