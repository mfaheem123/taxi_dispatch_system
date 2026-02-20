import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../component/networks/api.dart';
import '../../administration/model/list_subsDiary.dart';
import '../../dashboard_view/models/account_darshboard_model.dart';
import '../model/account_invoice_booking_model.dart';
import '../model/invoice_number_model.dart';
import '../model/list_of_account_invoice_model.dart';
import '../model/update_account_invoice_model.dart' hide Account;

class InvoiceController extends GetxController {


/// ============================================== Account Invoice ====================================================

  String? invoiceDateController = "2000-01-01";
  String? invoiceDueDateController = "2000-01-01";
  final orderNumber = TextEditingController();

  DateTime? fromDate = DateTime.now();
  DateTime? toDate = DateTime.now();

  InvoiceNumberModel? invoiceNumberModel;
  bool isInvoiceNumber = false;
  getInvoiceNumber() async {
    isInvoiceNumber = true;
    update();
    var response = await Api().get("document/document_numbers/3");
    if (response.statusCode == 200) {
      invoiceNumberModel = InvoiceNumberModel.fromJson(response.data);
      isInvoiceNumber = false;
      update();
    }
  }

  // ============ Subsidiary
  SubsDiaryModel? subsDiaryModel;
  Subsidiaries? subsidiaries;
  bool isSubsidiary = false;
  getSubsidiary() async {
    isSubsidiary = true;
    var response = await Api().get("subsidiaries/get");
    if (response.statusCode == 200) {
      subsDiaryModel = SubsDiaryModel.fromJson(response.data);
      isSubsidiary = false;
      update();
    }
  }

  // ======================= Account ===============
  DashboardAccountModel? dashboardAccountData;
  DashboardAccountObject? selectAccountValue;
  DepartmentObject? selectDepartmentData;
  getAccountData({subsidiariesId}) async {
    var response = await Api().get("accounts/subsidiary/$subsidiariesId");
    if (response.statusCode == 200) {
      selectDepartmentData = null;
      selectAccountValue = null;
      dashboardAccountData = DashboardAccountModel.fromJson(response.data);
      update();
    }
  }

      // ================ Filter Button ====================
  AccountInvoiceBookingModel? accountInvoiceBookingModel;
  bool isLoadingInvoice = false;
  getAccountInvoiceByFilter() async {
      isLoadingInvoice = true;
      var response = await Api().get( "account_invoice/bookings",
        queryParameters: {
          "subsidiary_id": subsidiaries!.id,
          "account_id": selectAccountValue!.id,
          "department": selectDepartmentData!.id,
          "from_date": fromDate?.toIso8601String().split('T').first,
          "to_date": toDate?.toIso8601String().split('T').first,
          "order_number": orderNumber.text,
        },
      );
      if (response.statusCode == 200) {
        accountInvoiceBookingModel =  AccountInvoiceBookingModel.fromJson(response.data);
        BotToast.showText(text: 'Filter Done');
        print('====================================================== Filter Data');
      }
    isLoadingInvoice = false;
    update();
  }

// ============================ Invoice Add

  RxBool addAccountInvoiceLoad = false.obs;
  addAccountInvoice() async {
    addAccountInvoiceLoad(true);
    List<Map<String, dynamic>> lineItems = accountInvoiceBookingModel!.bookings!.map((booking) {
      return {
        "booking_id": booking.id,
        "total_charges": booking.totalCharges ?? "0",
      };
    }).toList();
    var formData = {
      'account_id': selectAccountValue!.id,
      'subsidiary_id': subsidiaries!.id,
      'account_invoice_lineitems': jsonEncode(lineItems),
      'amount': accountInvoiceBookingModel!.total![0].total ?? "0",
      'department_id': selectDepartmentData?.id, // Optional check
      'from_date': fromDate?.toIso8601String().split('T').first,
      'to_date': toDate?.toIso8601String().split('T').first,
      'invoice_number': "${invoiceNumberModel?.documentNumber?.prefix ?? ''}${invoiceNumberModel?.documentNumber?.endNumber ?? ''}",
      'invoice_date': invoiceDateController,
      'invoice_due_date': invoiceDueDateController,
      'invoice_type': 'post',
      'order_number': orderNumber.text,
    };
    print("Payload: $formData");
      var response = await Api().post(
        formData,
        "account_invoice/add",
        auth: true,
      );
      if (response.statusCode == 200) {
        orderNumber.text = updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.orderNumber ?? "";
        BotToast.showText(text: 'Account Invoice Created');
        print('====================================================== Account Invoice Created');
        update();
      }
    addAccountInvoiceLoad(false);
  }





///================================================ list of Account Invoice


  String? listInvoiceFromDate = "2000-01-01";
  String? listInvoiceToDate = "2000-01-01";
 String? status;
  DateTime? invoiceListFromDate = DateTime.now();
  DateTime? invoiceListToDate = DateTime.now();

  RxList<AccountInvoice> accountInvoiceListAll = <AccountInvoice>[].obs;
  RxList<AccountInvoice> filteredAccountInvoice = <AccountInvoice>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 10;
  RxString invoiceNumber = ''.obs;
  RxString searchAccount = ''.obs;
  RxString searchDepartment = ''.obs;
  RxString searchOrder = ''.obs;
  RxString searchStatus = ''.obs;
  RxString searchAmount = ''.obs;
  RxString searchSubsidiary = ''.obs;
  RxString searchDate = ''.obs;
  RxString searchDueDate = ''.obs;

  ListOfAccountInvoiceModel? listOfAccountInvoice;
  RxBool isLoadingListOfAccountInvoice = false.obs;
  AccountInvoice? accountInvoiceData;
  listAccountInvoice({bool isFirstTime = false, String? activeFilter}) async {
    isLoadingListOfAccountInvoice.value = true;
    String? fromDateStr = isFirstTime ? null : invoiceListFromDate?.toIso8601String().split('T').first;
    String? toDateStr = isFirstTime ? null : invoiceListToDate?.toIso8601String().split('T').first;

      var response = await Api().get("account_invoice/get", queryParameters: {
        "limit" : limit,
        "invoice_number": activeFilter == "invoice" ? invoiceNumber.value.toLowerCase() : null,
        "account_name": activeFilter == "account" ? searchAccount.value.toLowerCase(): null,
        "department_name": activeFilter == "department" ? searchDepartment.value.toLowerCase(): null,
        "order_number": activeFilter == "order" ? searchOrder.value.toLowerCase(): null,
        "amount": activeFilter == "amount" ? searchAmount.value.toLowerCase(): null,
        "subsidiary_name": activeFilter == "subsidiary" ?   searchSubsidiary.value.toLowerCase(): null,
        "invoice_date": activeFilter == "invoicedate" ? searchDate.value : null,
        "invoice_due_date": activeFilter == "duedate" ? searchDueDate.value : null,
        "status": activeFilter == "status" ?(status == null || status == "all") ? null : status : null,
        "from_date": fromDateStr,
        "to_date": toDateStr,
      }
      );
      if (response.statusCode == 200) {
        listOfAccountInvoice = ListOfAccountInvoiceModel.fromJson(response.data);
        totalPages.value = listOfAccountInvoice?.totalPages ?? 1;
        accountInvoiceListAll.value = listOfAccountInvoice?.accountInvoices ?? [];
        filteredAccountInvoice = accountInvoiceListAll;
      }
      isLoadingListOfAccountInvoice.value = false;
      update();
  }

  // -----------Search changes function
  void onSearchAccountInvoice() {
    currentPage.value = 1;
    listAccountInvoice(isFirstTime: true);
  }

  /// ------- pagination function
  void onPageAccountInvoice(int page) {
    currentPage.value = page;
    listAccountInvoice(isFirstTime: true);
  }




  // Delete
  accountInvoiceDelete(int? id) async {
    var response = await Api().delete("account_invoice/delete/$id");
    if (response.statusCode == 200) {
      listAccountInvoice(isFirstTime: true);
      print("AccountInvoice deleted successfully!");
    }
  }

  ///================================================ Update Invoice Screen
  var isLoading = false.obs;

  var isPaid = false.obs;

  void togglePaidStatus() {
    isPaid.value = !isPaid.value;
  }



  String updateInvoiceDateController = "2000-01-01";
  String updateInvoiceDueDateController = "2000-01-01";



  UpdateInvoiceByIdModel? updateInvoiceByIdModel;
  AccountInvoiceAccountInvoice? accountInvoiceAccountInvoice;
  Account? account;
  bool isLoadingUpdate = false;
  getAccountInvoice() async {
    isLoadingUpdate = true;
    var response = await Api().get( "account_invoice/getid/55"
      // ,
      // queryParameters: {
      //   "subsidiary_id": subsidiaries!.id,
      //   "account_id": selectAccountValue!.id,
      //   "department": selectDepartmentData!.id,
      //   "from_date": fromDate?.toIso8601String().split('T').first,
      //   "to_date": toDate?.toIso8601String().split('T').first,
      //   "order_number": orderNumber.text,
      // },
    );
    if (response.statusCode == 200) {
      accountInvoiceBookingModel =  AccountInvoiceBookingModel.fromJson(response.data);
      // API Success ke baad controller mein:
      if (updateInvoiceByIdModel?.accountInvoice?.accountInvoice != null) {
        var data = updateInvoiceByIdModel!.accountInvoice!.accountInvoice!;
        // Is line se TextField mein purana Order Number likha hua aa jayega
        orderNumber.text = data.orderNumber ?? "";
      }
      BotToast.showText(text: 'Filter Done');
      print('====================================================== Filter Data');
    }
    isLoadingUpdate = false;
    update();
  }















}