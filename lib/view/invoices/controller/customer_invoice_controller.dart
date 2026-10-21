import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import '../../../component/networks/api.dart';
import '../../customer/model/search_customer_by_mobile.dart';
import '../../drivers_view/model/driver_commission_payment_model.dart';
import '../model/customer_invoice_filter_model.dart';
import '../model/customer_invoice_number_model.dart';
import '../model/list_of_customer_invoice_model.dart';
import '../model/update_customer_invoice_model.dart';

class CustomerInvoiceController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo CREATE CUSTOMER INVOICE functionality
  String? customerInvoiceDateController =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? customerInvoiceDueDateController =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerMobileController = TextEditingController();
  final customerTelephoneController = TextEditingController();
  final updateNameController = TextEditingController();
  final updateEmailController = TextEditingController();
  final updateMobileController = TextEditingController();
  final updateTelephoneController = TextEditingController();

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
    var response = await Api().get(
      "customers/search-data?mobile=$mobile",
      sendCompanyId: true,
    );
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
    if (response.statusCode == 200) {
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

  void setDefaultDates() {
    DateTime now = DateTime.now();
    filterFromDate = DateTime(now.year, now.month, 1).toIso8601String().split("T").first;
    filterToDate = now.toIso8601String().split("T").first;
  }
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

    var response = await Api().get(
      "bookings/customer-invoice-bookings",
      queryParameters: {
        "customer_id": selectedCustomerId.toString(),
        "from_date": filterFromDate,
        "to_date": filterToDate,
        "payment_type_ids": pTIds,
      },
    );
    if (response.statusCode == 200) {
      customerInvoiceFilterModel =
          CustomerInvoiceFilterModel.fromJson(response.data);
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
    final updateItems =
        customerInvoiceByIdModel?.customerInvoice?.customerInvoiceLineitems;

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

    String currentDate = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0 ')}".trim();
    String finalInvoiceDate = (customerInvoiceDateController == null || customerInvoiceDateController!.isEmpty)
        ? currentDate
        : customerInvoiceDateController!;

    String finalDueDate = (customerInvoiceDueDateController == null || customerInvoiceDueDateController!.isEmpty)
        ? currentDate
        : customerInvoiceDueDateController!;

    double totalAmount = getInvoiceTableColumnTotal('total');

    var formData = {
      "customer_id": selectedCustomerId,
      "invoice_number": customerInvoiceModel?.invoiceNumber ?? "",
      "invoice_date": finalInvoiceDate,
      "invoice_due_date": finalDueDate,
      "from_date": filterFromDate,
      "to_date": filterToDate,
      "invoice_type": "post",
      "amount": totalAmount.toStringAsFixed(2),
      "customer_invoice_lineitems": selectedIds
          .map((id) => {"booking_id": int.tryParse(id) ?? id})
          .toList(),
    };
    print("Submitting Payload: $formData");
    var response =
    await Api().post(formData, "customer-invoice/add",sendCompanyId: true, auth: true);
    if (response.statusCode == 200) {
      print("Response Data: ${response.data}");
      BotToast.showText(text: "CUSTOMER INVOICE ADDED SUCCESSFULLY!");
      clearCustomerInvoice();

      // selectedIds.clear();
      // customerInvoiceFilterModel?.bookings?.clear();
      getCustomerInvoiceNumber();
    }
    isCustomerInvoiceLoad = false;
    update();
  }

  var datePickerKey = 0;

  void clearCustomerInvoice() {
    selectedIds.clear();
    selectedPaymentTypeIds.clear();
    customerNameController.clear();
    customerEmailController.clear();
    customerMobileController.clear();
    customerTelephoneController.clear();
    selectedCustomerId = null;
    customerInvoiceFilterModel = null;
    datePickerKey++;
    customerInvoiceDateController = "";
    customerInvoiceDueDateController = "";
    filterFromDate = "";
    filterToDate = "";
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
        dateStr =
            DateFormat("yyyy-MM-dd").format(invoice.invoiceDate!).toLowerCase();
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
    var response = await Api().get("customer-invoice/get", sendCompanyId: true, queryParameters: {
      "status": statusParam,
    });
    if (response.statusCode == 200) {
      listOfCustomerInvoiceModel =
          ListOfCustomerInvoiceModel.fromJson(response.data);
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
      customerInvoiceByIdModel =
          CustomerInvoiceByIdModel.fromJson(response.data);
      var data = customerInvoiceByIdModel?.customerInvoice;
      isPaid.value = (data?.status?.toLowerCase() == "paid");
      if (data?.customerInvoiceLineitems != null) {
        for (var item in data!.customerInvoiceLineitems!) {
          // recalculateRowTotal(item);
        }
      }
      // customerInvoiceDateController =
      // "${data?.invoiceDate?.year}-${data?.invoiceDate?.month}-${data?.invoiceDate?.day}";
      // customerInvoiceDueDateController =
      // "${data?.invoiceDueDate?.year}-${data?.invoiceDueDate?.month}-${data?.invoiceDueDate?.day}";
      if (data?.invoiceDate != null) {
        customerInvoiceDateController =
        "${data!.invoiceDate!.year}-${data.invoiceDate!.month.toString().padLeft(2, '0')}-${data.invoiceDate!.day.toString().padLeft(2, '0')}";
      } else {
        customerInvoiceDateController = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
      }

      if (data?.invoiceDueDate != null) {
        customerInvoiceDueDateController =
        "${data!.invoiceDueDate!.year}-${data.invoiceDueDate!.month.toString().padLeft(2, '0')}-${data.invoiceDueDate!.day.toString().padLeft(2, '0')}";
      } else {
        customerInvoiceDueDateController = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
      }
      updateNameController.text = data?.customer?.name ?? "";
      updateEmailController.text = data?.customer?.email ?? "";
      updateMobileController.text = data?.customer?.mobile ?? "";
      updateTelephoneController.text = data?.customer?.telephone ?? "";
    }
    isLoadingUpdate = false;
    update();
  }

  /// Save Update customer Invoice

  updateBooking(UpdateCustomerInvoice invoice) async {
    final updateItems =
        customerInvoiceByIdModel?.customerInvoice?.customerInvoiceLineitems;

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
      "invoice_number":
      customerInvoiceByIdModel?.customerInvoice?.invoiceNumber ?? "",
      if (customerInvoiceDateController != null)
        "invoice_date": customerInvoiceDateController,
      if (customerInvoiceDueDateController != null)
        "invoice_due_date": customerInvoiceDueDateController,
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
    customerInvoiceDateController = "";
    customerInvoiceDueDateController =
    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    updateNameController.clear();
    updateEmailController.clear();
    updateMobileController.clear();
    updateTelephoneController.clear();
    update();
  }

  /// Download PDF
  Future<void> downloadPdfFile() async {
    if (customerInvoiceByIdModel?.customerInvoice == null) {
      Get.snackbar("ERROR", "NO INVOICE DATA FOUND TO EXPORT.");
      return;
    }

    final mainData = customerInvoiceByIdModel!.customerInvoice!;
    final accountData = mainData.customer;
    final List lineItems = mainData.customerInvoiceLineitems ?? [];

    double totalFare = 0;
    double totalPC = 0;
    double totalWC = 0;
    double totalEDC = 0;
    double totalMG = 0;
    double totalCC = 0;
    double grandTotal = 0;

    String tableRows = "";

    for (var item in lineItems) {
      final b = item.booking;
      if (b == null) continue;

      double fare = double.tryParse(b.fares?.toString() ?? "0") ?? 0.0;
      double pc = double.tryParse(b.parkingCharges?.toString() ?? "0") ?? 0.0;
      double wc = double.tryParse(b.waitingCharges?.toString() ?? "0") ?? 0.0;
      double edc =
          double.tryParse(b.extraDropCharges?.toString() ?? "0") ?? 0.0;
      double mg = double.tryParse(b.meetAndGreet?.toString() ?? "0") ?? 0.0;
      double cc =
          double.tryParse(b.congestionCharges?.toString() ?? "0") ?? 0.0;
      double total = double.tryParse(b.totalCharges?.toString() ?? "0") ?? 0.0;

      totalFare += fare;
      totalPC += pc;
      totalWC += wc;
      totalEDC += edc;
      totalMG += mg;
      totalCC += cc;
      grandTotal += total;

      String formattedDate = "-";
      if (b.pickupDate != null && b.pickupDate.toString().isNotEmpty) {
        try {
          DateTime parsedDate =
          DateFormat("yyyy-M-d").parse(b.pickupDate.toString());
          formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
        } catch (_) {
          formattedDate = b.pickupDate.toString();
        }
      }

      String formattedTime = "-";
      if (b.pickupTime != null && b.pickupTime.toString().isNotEmpty) {
        formattedTime = b.pickupTime.toString().split('.')[0].substring(0, 5);
      }

      tableRows += """
      <tr>
        <td>${b.referenceNumber ?? ""}</td>
        <td>$formattedDate<br>$formattedTime</td>
        <td>${b.vehicleType?.name ?? ""}</td>
        <td>${b.pickup ?? ""}</td>
        <td>${b.dropoff ?? ""}</td>
        <td>${b.journeyType?.journeyType ?? ""}</td>
        <td>${b.paymentType?.name ?? ""}</td>
        <td>£${fare.toStringAsFixed(2)}</td>
        <td>£${pc.toStringAsFixed(2)}</td>
        <td>£${wc.toStringAsFixed(2)}</td>
        <td>£${edc.toStringAsFixed(2)}</td>
        <td>£${mg.toStringAsFixed(2)}</td>
        <td>£${cc.toStringAsFixed(2)}</td>
        <td>£${total.toStringAsFixed(2)}</td>
      </tr>
    """;
    }

    final String finalHtml = """
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
body { font-family: Arial; padding: 30px; font-size: 12px; }
h2 { text-align: center; margin-bottom: 20px; }
table { width: 100%; border-collapse: collapse; margin-top: 15px; }
th, td { border: 1px solid #ccc; padding: 6px; text-transform: uppercase; }
th { background-color: #f2f2f2; }
.right { text-align: right; }
.no-border td { border: none; }
.header { display: flex; justify-content: space-between; margin-bottom: 20px; }
.footer-note { font-size: 11px; text-align: right; margin-top: 30px; }
.header div, p b { 
  text-transform: uppercase; 
}
</style>
</head>
<body>

<h2>CUSTOMER INVOICE</h2>

<div class="header">
  <div>
    <b>EMAIL:</b> ${accountData?.email ?? ""}<br>
    <b>MOBILE:</b> ${accountData?.mobile ?? ""}<br>
    <b>TELEPHONE:</b> ${accountData?.telephone ?? ""}
  </div>

  <div>
      <b>CUSTOMER</b> ${accountData?.name ?? ""}<br>
    <b>DATE:</b> ${mainData.invoiceDate.toString().split(' ').first}<br>
    <b>DUE DATE:</b> ${mainData.invoiceDueDate.toString().split(' ').first}
  </div>
</div>

<p><b>PERIOD:</b> (${mainData.fromDate.toString().split(' ').first} TO ${mainData.toDate.toString().split(' ').first})</p>

<table>
<thead>
<tr>
  <th>REF #</th>
  <th>DATETIME</th>
  <th>VEHICLE</th>
  <th>PICKUP</th>
  <th>DROPOFF</th>
  <th>J/T</th>
  <th>P/T</th>
  <th>FARE</th>
  <th>PC</th>
  <th>WC</th>
  <th>EDC</th>
  <th>M&G</th>
  <th>CC</th>
  <th>TOTAL</th>
</tr>
</thead>
<tbody>

$tableRows

<tr style="font-weight:bold;">
  <td colspan="7" class="right">TOTAL</td>
  <td>£${totalFare.toStringAsFixed(2)}</td>
  <td>£${totalPC.toStringAsFixed(2)}</td>
  <td>£${totalWC.toStringAsFixed(2)}</td>
  <td>£${totalEDC.toStringAsFixed(2)}</td>
  <td>£${totalMG.toStringAsFixed(2)}</td>
  <td>£${totalCC.toStringAsFixed(2)}</td>
  <td>£${grandTotal.toStringAsFixed(2)}</td>
</tr>

</tbody>
</table>

<table class="no-border">
</table>

<div class="footer-note">
PC: PARKING CHARGES<br>
WC: WAITING CHARGES<br>
EDC: EXTRA DROP CHARGES<br>
M&G: MEET AND GREET<br>
CC: CONGESTION CHARGES
</div>

</body>
</html>
""";

    try {
      final bytes = utf8.encode(finalHtml);
      final blob = html.Blob([bytes], 'text/html');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "Invoice_${mainData.invoiceNumber}.html")
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print("Download Error: $e");
    }
  }

  /// Download Excel
  Future<void> downloadExel() async {
    if (customerInvoiceByIdModel?.customerInvoice == null) {
      BotToast.showText(text: "NO INVOICE DATA FOUND TO EXPORT");
      return;
    }

    final mainData = customerInvoiceByIdModel?.customerInvoice;
    final lineItems = mainData?.customerInvoiceLineitems ?? [];

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Invoice'];
    excel.delete('Sheet1');

    List<String> headers = [
      "REF #",
      "DATETIME",
      "VEHICLE",
      "PICKUP",
      "DROPOFF",
      "",
      "J/T",
      "P/T",
      "FARE",
      "PC",
      "WC",
      "EDC",
      "M&G",
      "CC",
      "TOTAL",
    ];
    sheetObject
        .appendRow(headers.map((e) => TextCellValue(e.toUpperCase())).toList());

    double grandTotal = 0;

    for (var item in lineItems) {
      final b = item.booking;
      if (b == null) continue;
      double fare = double.tryParse(b.fares?.toString() ?? "0") ?? 0.0;
      double pc = double.tryParse(b.parkingCharges?.toString() ?? "0") ?? 0.0;
      double wc = double.tryParse(b.waitingCharges?.toString() ?? "0") ?? 0.0;
      double edc =
          double.tryParse(b.extraDropCharges?.toString() ?? "0") ?? 0.0;
      double mg = double.tryParse(b.meetAndGreet?.toString() ?? "0") ?? 0.0;
      double cc =
          double.tryParse(b.congestionCharges?.toString() ?? "0") ?? 0.0;
      double total = double.tryParse(b.totalCharges?.toString() ?? "0") ?? 0.0;
      grandTotal += total;

      sheetObject.appendRow([
        TextCellValue(b.referenceNumber ?? ""),
        TextCellValue(b.pickupDate ?? ""),
        TextCellValue(b.pickupTime ?? ""),
        TextCellValue((b.vehicleType?.name ?? "").toUpperCase()),
        TextCellValue((b.pickup ?? "").toUpperCase()),
        TextCellValue((b.dropoff ?? "").toUpperCase()),
        TextCellValue((b.journeyType?.journeyType ?? "").toUpperCase()),
        TextCellValue((b.paymentType?.name ?? "").toUpperCase()),
        DoubleCellValue(fare),
        DoubleCellValue(pc),
        DoubleCellValue(wc),
        DoubleCellValue(edc),
        DoubleCellValue(mg),
        DoubleCellValue(cc),
        DoubleCellValue(total),
      ]);
    }

    try {
      var fileBytes = excel.encode();
      if (fileBytes != null) {
        final content = base64Encode(fileBytes);
        final anchor = html.AnchorElement(
            href:
            "data:application/octet-stream;charset=utf-16le;base64,$content")
          ..setAttribute("download", "Customer_Invoice_Report.xlsx")
          ..click();
      }
    } catch (e) {
      print("Excel Error: $e");
    }
  }

  /// Delete
  customerInvoiceDelete(int? id) async {
    var response = await Api().delete("customer-invoice/delete/$id");
    if (response.statusCode == 200) {
      getCustomerInvoice();
      BotToast.showText(text: "CUSTOMER INVOICE DELETED SUCCESSFULLY!");
    }
  }
}