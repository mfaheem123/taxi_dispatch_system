import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/networks/api.dart';
import '../../customer/model/search_customer_by_mobile.dart';
import '../../drivers_view/model/driver_commission_payment_model.dart';
import '../model/customer_invoice_filter_model.dart';
import '../model/customer_invoice_number_model.dart';
import '../model/list_of_customer_invoice_model.dart';
import '../model/update_customer_invoice_model.dart';

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
  CustomerInvoiceModel? customerInvoiceModel;
  bool isCustomerInvoiceNumber = false;
  
  getCustomerInvoiceNumber() async {
    isCustomerInvoiceNumber = true;
    update();
    var response = await Api().get("customer-invoice/invoice-number");
    if(response.statusCode == 200) {
      customerInvoiceModel = CustomerInvoiceModel.fromJson(response.data);
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
  double getUpdateColumnTotal(String field) {
    final updateItems = customerInvoiceByIdModel
        ?.customerInvoice?.customerInvoiceLineitems;

    if (updateItems == null || updateItems.isEmpty) return 0.0;
    final list =
    updateItems.map((e) => e.booking).where((b) => b != null).toList();

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
      "invoice_number": customerInvoiceModel?.invoiceNumber ?? "",
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

  RxString searchQuery = "".obs;
  List<CustomerInvoice> get filteredInvoices {
    final allInvoices = listOfCustomerInvoiceModel?.customerInvoices ?? [];
    if (searchQuery.isEmpty) {
      return allInvoices;
    }
    final query = searchQuery.value.toLowerCase();

    return allInvoices.where((invoice) {
      final invNumber = (invoice.invoiceNumber ?? "").toLowerCase();
      final custName = (invoice.customer?.name ?? "").toLowerCase();
      final status = (invoice.status ?? "").toLowerCase();
      // final date = (invoice.invoiceDate ?? "").toLowerCase();
      final amount = (invoice.amount ?? "").toLowerCase();

      String dateStr = "";
      if (invoice.invoiceDate != null) {
        dateStr = DateFormat("yyyy-MM-dd").format(invoice.invoiceDate!).toLowerCase();
      }

      return invNumber.contains(query) ||
          custName.contains(query) ||
          status.contains(query) ||
          dateStr.contains(query) ||
          amount.contains(query);
    }).toList();
  }
  getCustomerInvoice() async {
    isLoadingList = true;
    update();

    String statusParam = paid.value == true ? "paid" : "unpaid";
    var response = await Api().get("customer-invoice/get", queryParameters: {
      "status": statusParam,
    });
    if (response.statusCode == 200) {
      listOfCustomerInvoiceModel = ListOfCustomerInvoiceModel.fromJson(response.data);
    }
    isLoadingList = false;
    update();
  }
///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo LIST OF CUSTOMER INVOICE functionality
///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo UPDATE CUSTOMER INVOICE functionality

  var isPaid = false.obs;

  void togglePaidStatus() {
    isPaid.value = !isPaid.value;
  }

  CustomerInvoiceByIdModel? customerInvoiceByIdModel;
  bool isLoadingUpdate = false;

  getUpdateCustomerInvoice({selectedId}) async {
    isLoadingUpdate = true;
    update();

    var response = await Api().get("customer-invoice/getbyid/$selectedId");

    if (response.statusCode == 200) {
      customerInvoiceByIdModel = CustomerInvoiceByIdModel.fromJson(response.data);
      var data = customerInvoiceByIdModel?.customerInvoice;
      isPaid.value = (data?.status?.toLowerCase() == "paid");
      if (data?.customerInvoiceLineitems != null) {
        for (var item in data!.customerInvoiceLineitems!) {
          // recalculateRowTotal(item);
        }
      }
      customerInvoiceDateController =
      "${data?.invoiceDate?.year}-${data?.invoiceDate?.month}-${data?.invoiceDate?.day}";
      customerInvoiceDueDateController =
      "${data?.invoiceDueDate?.year}-${data?.invoiceDueDate?.month}-${data?.invoiceDueDate?.day}";
      customerNameController.text = data?.customer?.name ?? "";
      customerEmailController.text = data?.customer?.email ?? "";
      customerMobileController.text = data?.customer?.mobile ?? "";
      customerTelephoneController.text = data?.customer?.telephone ?? "";

    }
    isLoadingUpdate = false;
    update();
  }

  /// Save Update customer Invoice


  updateBooking(UpdateCustomerInvoice invoice) async {
    final updateItems = customerInvoiceByIdModel
        ?.customerInvoice?.customerInvoiceLineitems;

    List<Map<String, dynamic>> lineItems = [];
    if (updateItems != null && updateItems.isNotEmpty) {
      lineItems = updateItems
          .where((item) => item.booking?.id != null)
          .map((item) => {"booking_id": item.booking!.id})
          .toList();
    }
    double updatedTotalAmount = getUpdateColumnTotal('total');

    var formData = {
      if (invoice.customerId != null) "customer_id": invoice.customerId,
      "invoice_number": customerInvoiceByIdModel?.customerInvoice?.invoiceNumber ?? "",
      if (customerInvoiceDateController != null) "invoice_date": customerInvoiceDateController,
      if (customerInvoiceDueDateController != null) "invoice_due_date": customerInvoiceDueDateController,
      if (invoice.invoiceType != null) "invoice_type": invoice.invoiceType,
      "status": isPaid.value ? "paid" : "unpaid",
      "amount": updatedTotalAmount.toStringAsFixed(2),
      if (invoice.fromDate != null)
        "from_date":
        "${invoice.fromDate!.year}-${invoice.fromDate!.month}-${invoice.fromDate!.day}",
      if (invoice.toDate != null)
        "to_date":
        "${invoice.toDate!.year}-${invoice.toDate!.month}-${invoice.toDate!.day}",
      "customer_invoice_lineitems": lineItems,
    };
    print("Submitting Update Payload: $formData");

    var response = await Api()
        .post(formData, "customer-invoice/update/${invoice.id}", auth: true);

    if (response.statusCode == 200) {
      BotToast.showText(text: "CUSTOMER INVOICE UPDATED SUCCESSFULLY!");

      clearUpdateData();

      getCustomerInvoice();
    }
  }

  void clearUpdateData() {
    customerInvoiceByIdModel = null;
    customerInvoiceDateController = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    customerInvoiceDueDateController = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    customerNameController.clear();
    customerEmailController.clear();
    customerMobileController.clear();
    customerTelephoneController.clear();
    update();
  }
}