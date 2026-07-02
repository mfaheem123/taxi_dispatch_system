import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/networks/api.dart';
import '../../customer/model/search_customer_by_mobile.dart';
import '../../drivers_view/model/driver_commission_payment_model.dart';
import '../model/customer_invoice_filter_model.dart';
import '../model/customer_invoice_number_model.dart';
import '../model/list_of_customer_invoice_model.dart';

class CustomerInvoiceController extends GetxController{

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo CREATE CUSTOMER INVOICE functionality
  String? customerInvoiceDateController =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? customerInvoiceDueDateController =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerMobileController = TextEditingController();
  final customerTelephoneController = TextEditingController();

  DriverCommissionPaymentModel? paymentTypeModel;
  List<int> selectedPaymentTypeIds = [];
  bool isLoadingPayments = false;

  getPaymentTypes() async {
    isLoadingPayments = true;
    update();

    var response = await Api().get("enumerations/payment-types");
    if (response.statusCode == 200) {
      paymentTypeModel = DriverCommissionPaymentModel.fromJson(response.data);
      print("PAYMENT API DATA: ${response.data}");
    }
    isLoadingPayments = false;
    update();
  }

  /// todo mobile search api

  SearchCustomerByMobileModel? searchCustomerByMobileModel;
  bool isSearchingCustomer = false;

  getCustomer(String mobile) async {
    isSearchingCustomer = true;
    var response = await Api().get("customers/search-data?mobile=$mobile",sendCompanyId: true,);
    if (response.statusCode == 200) {
      searchCustomerByMobileModel =
          SearchCustomerByMobileModel.fromJson(response.data);
      isSearchingCustomer = false;
      update();
    }
  }
  
  /// todo invoice number
  CustomerInvoiceModel? customerInvoice;
  bool isCustomerInvoiceNumber = false;
  
  getCustomerInvoiceNumber() async {
    isCustomerInvoiceNumber = true;
    update();
    var response = await Api().get("customer-invoice/invoice-number");
    if(response.statusCode == 200) {
      customerInvoice = CustomerInvoiceModel.fromJson(response.data);
      isCustomerInvoiceNumber = false;
      update();
    }
  }

  /// todo filter Api
  int? selectedCustomerId;
  Set<String> selectedIds = {};
  String filterFromDate = "";
  String filterToDate = "";
  bool isFilteredLoading = false;
  CustomerInvoiceFilterModel? customerInvoiceFilterModel;

  getCustomerInvoiceByFilter() async {
    if (selectedCustomerId == null) {
      BotToast.showText(text: "PLEASE SELECT A CUSTOMER FIRST");
      return;
    }
    isFilteredLoading = true;
    update();

    String pTIds = selectedPaymentTypeIds.isNotEmpty
        ? "[${selectedPaymentTypeIds.join(",")}]"
        : "";
    
    var response = await Api().get("bookings/customer-invoice-bookings",
      queryParameters: {
      "customer_id": selectedCustomerId.toString(),
      "from_date": filterFromDate,
      "to_date": filterToDate,
      "payment_type_ids": pTIds,
      },
    );
    if (response.statusCode == 200){
      customerInvoiceFilterModel = CustomerInvoiceFilterModel.fromJson(response.data);
      print("API Response: ${response.data}");
    }
    isFilteredLoading = false;
    update();
  }

  /// editable cell
  void recalculateTotalRow(dynamic booking) {
    double parse(dynamic value) =>
        double.tryParse(value?.toString() ?? "0") ?? 0.0;

    double f = parse(booking.fares);
    double pc = parse(booking.parkingCharges);
    double wc = parse(booking.waitingCharges);
    double edc = parse(booking.extraDropCharges);
    double mg = parse(booking.meetAndGreet);
    double cc = parse(booking.congestionCharges);

    double total = f + pc + wc + edc + cc;

    booking.totalCharges = total.toStringAsFixed(2);
    update();
  }
  /// total row

  double parseDouble(dynamic value) =>
      double.tryParse(value?.toString() ?? "0") ?? 0.0;

  double getInvoiceTableColumnTotal(String field) {
    if (selectedIds.isEmpty) return 0.0;

    final list = customerInvoiceFilterModel?.bookings
        ?.where((b) => selectedIds.contains(b.id.toString()))
        .toList() ??
        [];

    return _calculateInvoiceListTotal(list, field);
  }

  double _calculateInvoiceListTotal(List<dynamic> list, String field) {
    return list.fold(0.0, (sum, item) {
      return sum +
          parseDouble({
            'fare': item.fares,
            'pc': item.parkingCharges,
            'wc': item.waitingCharges,
            'edc': item.extraDropCharges,
            'mg': item.meetAndGreet,
            'cc': item.congestionCharges,
            'total': item.totalCharges,
          }[field]);
    });
  }

  updateBookingCharges(dynamic booking) async {
    var formData = {
      "fares": (booking.fares ?? "0").toString(),
      "parking_charges": (booking.parkingCharges ?? "0").toString(),
      "waiting_charges": (booking.waitingCharges ?? "0").toString(),
      "extra_drop_charges": (booking.extraDropCharges ?? "0").toString(),
      "congestion_charges": (booking.congestionCharges ?? "0").toString(),
      "total_charges": (booking.totalCharges ?? "0").toString(),
      "meet_and_greet": (booking.meetAndGreet ?? "0").toString(),
    };
    print("Sending Data: $formData");
    var response = await Api()
        .post(formData, "bookings/fare-charges/${booking.id}", auth: true);
    if (response.statusCode == 200) {
      update();
      BotToast.showText(text: "CHARGES UPDATED SUCCESSFULLY");
    }
  }

  /// todo save Api
 bool isCustomerInvoiceLoad = false;

  saveCustomerInvoice() async {
    isCustomerInvoiceLoad = true;
    update();

    double totalAmount = getInvoiceTableColumnTotal('total');

    var formData = {
      "customer_id": selectedCustomerId,
      "invoice_number": customerInvoice?.invoiceNumber ?? "",
      "invoice_date": customerInvoiceDateController,
      "invoice_due_date": customerInvoiceDueDateController,
      "from_date": filterFromDate,
      "to_date": filterToDate,
      "invoice_type": "post",
      "amount": totalAmount.toStringAsFixed(2),
      "customer_invoice_lineitems":  selectedIds
          .map((id) => {"booking_id": int.tryParse(id) ?? id})
          .toList(),
    };
    print("Submitting Payload: $formData");
    var response = await Api().post(formData, "customer-invoice/add", auth: true);
    if (response.statusCode == 200) {
      print("Response Data: ${response.data}");
      BotToast.showText(text: "CUSTOMER INVOICE ADDED SUCCESSFULLY!");

      selectedIds.clear();
      customerInvoiceFilterModel?.bookings?.clear();
      getCustomerInvoiceNumber();
    }
    isCustomerInvoiceLoad = false;
    update();
  }
///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo CREATE CUSTOMER INVOICE functionality
///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo LIST OF CUSTOMER INVOICE functionality

  RxBool paid = false.obs;
  final FocusNode paidNode = FocusNode();

  ListOfCustomerInvoiceModel? listOfCustomerInvoiceModel;
  bool isLoadingList = false;

  getCustomerInvoice() async {
    isLoadingList = true;
    update();

    var response = await Api().get("customer-invoice/get");
    if (response.statusCode == 200) {
      listOfCustomerInvoiceModel = ListOfCustomerInvoiceModel.fromJson(response.data);
    }
    isLoadingList = false;
    update();
  }
}