import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/networks/api.dart';
import '../../administration/model/list_subsDiary.dart';
import '../../dashboard_view/models/account_darshboard_model.dart';
import '../model/account_invoice_booking_model.dart';
import '../model/invoice_number_model.dart';

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









}