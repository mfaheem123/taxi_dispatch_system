import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/networks/api.dart';
import '../../administration/model/list_subsDiary.dart';
import '../../dashboard_view/models/account_darshboard_model.dart';
import '../model/account_invoice_booking_model.dart';
import '../model/invoice_number_model.dart';
import '../model/list_of_account_invoice_model.dart';

class InvoiceController extends GetxController {


/// ============================================== Account Invoice ====================================================


  // =================== Invoice Number Api
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
      if (response.statusCode == 200) {}
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
  listAccountInvoice() async {
    isLoadingListOfAccountInvoice.value = true;

    var response = await Api().get("account_invoice/get",
    queryParameters: {
      "invoice_number": invoiceNumber.value.toLowerCase(),
      "account_name": searchAccount.value.toLowerCase(),
      "department_name": searchDepartment.value.toLowerCase(),
      "order_number": searchOrder.value.toLowerCase(),
      "invoice_date": searchDate.value.toString(),
      "invoice_due_date": searchDueDate.value.toString(),
      "status": status,
      "amount": searchAmount.value.toLowerCase(),
      "subsidiary_name": searchSubsidiary.value.toLowerCase(),
      "to_date": invoiceListToDate?.toIso8601String().split('T').first,
      "from_date": invoiceListFromDate?.toIso8601String().split('T').first,
    }
    );
    if (response.statusCode == 200) {
      listOfAccountInvoice = ListOfAccountInvoiceModel.fromJson(response.data);
      accountInvoiceListAll.value = listOfAccountInvoice?.accountInvoices ?? [];
      filteredAccountInvoice.value = accountInvoiceListAll;
      isLoadingListOfAccountInvoice.value = false;
      update();
    }
  }

  // Delete
  accountInvoiceDelete(int? id) async {
    var response = await Api().delete("account_invoice/delete/$id");
    if (response.statusCode == 200) {
      listAccountInvoice();
      print("AccountInvoice deleted successfully!");
    }
  }


















}