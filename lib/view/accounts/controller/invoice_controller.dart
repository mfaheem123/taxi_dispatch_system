import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:html' as html;
import '../../../component/networks/api.dart';
import '../../administration/model/list_subsDiary.dart';
import '../../dashboard_view/models/account_darshboard_model.dart';
import '../model/account_invoice_booking_model.dart';
import '../model/invoice_number_model.dart' hide Subsidiary;
import '../model/list_of_account_invoice_model.dart';
import '../model/update_account_invoice_model.dart' hide Account, Subsidiary;

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
    var response = await Api().get(
      "account_invoice/bookings",
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
      accountInvoiceBookingModel =
          AccountInvoiceBookingModel.fromJson(response.data);
      BotToast.showText(text: 'Filter Done');
      print(
          '====================================================== Filter Data');
    }
    isLoadingInvoice = false;
    update();
  }

// ============================ Invoice Add

  RxBool addAccountInvoiceLoad = false.obs;

  addAccountInvoice() async {
    addAccountInvoiceLoad(true);
    List<Map<String, dynamic>> lineItems =
        accountInvoiceBookingModel!.bookings!.map((booking) {
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
      'invoice_number':
          "${invoiceNumberModel?.documentNumber?.prefix ?? ''}${invoiceNumberModel?.documentNumber?.endNumber ?? ''}",
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
      orderNumber.text =
          updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.orderNumber ??
              "";
      BotToast.showText(text: 'Account Invoice Created');
      print(
          ' Account Invoice Created');
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
    String? fromDateStr = isFirstTime
        ? null
        : invoiceListFromDate?.toIso8601String().split('T').first;
    String? toDateStr = isFirstTime
        ? null
        : invoiceListToDate?.toIso8601String().split('T').first;

    var response = await Api().get("account_invoice/get", queryParameters: {
      "limit": limit,
      "invoice_number":
          activeFilter == "invoice" ? invoiceNumber.value.toLowerCase() : null,
      "account_name":
          activeFilter == "account" ? searchAccount.value.toLowerCase() : null,
      "department_name": activeFilter == "department"
          ? searchDepartment.value.toLowerCase()
          : null,
      "order_number":
          activeFilter == "order" ? searchOrder.value.toLowerCase() : null,
      "amount": activeFilter == "amount" ? searchAmount.value.toLowerCase() : null,
      "subsidiary_name": activeFilter == "subsidiary"
          ? searchSubsidiary.value.toLowerCase()
          : null,
      "invoice_date": activeFilter == "invoicedate" ? searchDate.value : null,
      "invoice_due_date":
          activeFilter == "duedate" ? searchDueDate.value : null,
      "status": activeFilter == "status"
          ? (status == null || status == "all")
              ? null
              : status
          : null,
      "from_date": fromDateStr,
      "to_date": toDateStr,
    });
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
  ///================================================ list of Account Invoice END

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

  getAccountInvoice({selectedInvoiceId}) async {
    isLoadingUpdate = true;
    var response = await Api().get("account_invoice/getid/$selectedInvoiceId");
    if (response.statusCode == 200) {
      updateInvoiceByIdModel = UpdateInvoiceByIdModel.fromJson(response.data);

      if (updateInvoiceByIdModel?.accountInvoice?.accountInvoice != null) {
        var data = updateInvoiceByIdModel!.accountInvoice!.accountInvoice!;
        orderNumber.text = data.orderNumber ?? "";

        print("Invoice Number: ${data.invoiceNumber}");
        print("Total Line Items: ${data.accountInvoiceLineitems?.length}");
      }
      BotToast.showText(text: 'Filter Done');
    }
    isLoadingUpdate = false;
    update();
  }

  ///  UPDATE SCREEN VARIABLES

  SubsDiaryModel? updateSubsidiaryModel;
  Subsidiaries? selectedUpdateSubsidiary;
  DashboardAccountModel? updateAccountModel;
  DashboardAccountObject? selectedUpdateAccount;

  UpdateInvoiceByIdModel? invoiceData;
  Subsidiary? selectedSubsidiary;

  void loadInvoiceData(String jsonString) {
    invoiceData = updateInvoiceByIdModelFromJson(jsonString);
    if (invoiceData?.accountInvoice?.accountInvoice?.account != null) {
      selectedSubsidiary = invoiceData!
          .accountInvoice!.accountInvoice!.account!.subsidiary as Subsidiary?;
    } else {
      print("Data incomplete hai: Account null mila");
    }

    update();
  }

  getUpdateAccounts(int subsidiaryId) async {
    var response = await Api().get("accounts/subsidiary/$subsidiaryId");
    if (response.statusCode == 200) {
      updateAccountModel = DashboardAccountModel.fromJson(response.data);
      update();
    }
  }

  /// Download PDF
  Future<void> downloadApiContentAsFile() async {
    if (updateInvoiceByIdModel?.accountInvoice?.accountInvoice == null) {
      Get.snackbar("Error", "No invoice data found to export.");
      return;
    }

    final mainData = updateInvoiceByIdModel!.accountInvoice!.accountInvoice!;
    final accountData = mainData.account;
    final subsidiaryData = accountData?.subsidiary;
    final List lineItems = mainData.accountInvoiceLineitems ?? [];

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

      double fare = (b.companyPrice ?? 0).toDouble();
      double pc = (b.parkingCharges ?? 0).toDouble();
      double wc = (b.waitingCharges ?? 0).toDouble();
      double edc = (b.extraDropCharges ?? 0).toDouble();
      double mg = (b.meetAndGreet ?? 0).toDouble();
      double cc = (b.congestionCharges ?? 0).toDouble();
      double total = (b.totalCharges ?? 0).toDouble();

      totalFare += fare;
      totalPC += pc;
      totalWC += wc;
      totalEDC += edc;
      totalMG += mg;
      totalCC += cc;
      grandTotal += total;

      tableRows += """
      <tr>
        <td>${b.referenceNumber ?? ""}</td>
        <td>${b.pickupDate ?? ""}<br>${b.pickupTime ?? ""}</td>
        <td>${b.vehicleType?.name ?? ""}</td>
        <td>${b.name ?? ""}</td>
        <td>${b.pickup ?? ""}</td>
        <td>${b.dropoff ?? ""}</td>
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

    // Admin fees from API (agar amount type AMOUNT hai)
    double adminFees = 0;
    if (accountData?.adminFeesType == "AMOUNT") {
      adminFees = (accountData?.adminFees ?? 0).toDouble();
    } else if (accountData?.adminFeesType == "PERCENTAGE") {
      adminFees = (grandTotal * (accountData?.adminFees ?? 0) / 100);
    }

    double finalTotal = grandTotal + adminFees;

    final String finalHtml = """
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
body { font-family: Arial; padding: 30px; font-size: 12px; }
h2 { text-align: center; margin-bottom: 20px; }
table { width: 100%; border-collapse: collapse; margin-top: 15px; }
th, td { border: 1px solid #ccc; padding: 6px; }
th { background-color: #f2f2f2; }
.right { text-align: right; }
.no-border td { border: none; }
.header { display: flex; justify-content: space-between; margin-bottom: 20px; }
.footer-note { font-size: 11px; text-align: right; margin-top: 30px; }
</style>
</head>
<body>

<h2>ACCOUNT INVOICE</h2>

<div class="header">
  <div>
    <b>EMAIL:</b> ${subsidiaryData?.email ?? ""}<br>
    <b>MOBILE:</b> ${accountData?.mobile ?? ""}<br>
    <b>TELEPHONE:</b> ${subsidiaryData?.telephoneNumber ?? ""}
  </div>

  <div>
    <b>ACCOUNT:</b> ${accountData?.name ?? ""}<br>
    <b>ORDER #:</b> ${mainData.orderNumber ?? "-"}<br>
    <b>DATE:</b> ${mainData.invoiceDate ?? ""}<br>
    <b>DUE DATE:</b> ${mainData.invoiceDueDate ?? ""}
  </div>
</div>

<p><b>PERIOD:</b> (${mainData.fromDate ?? ""} TO ${mainData.toDate ?? ""})</p>

<table>
<thead>
<tr>
  <th>REF #</th>
  <th>DATETIME</th>
  <th>VEHICLE</th>
  <th>CUSTOMER</th>
  <th>PICKUP</th>
  <th>DROPOFF</th>
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
  <td colspan="6" class="right">TOTAL</td>
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
<tr>
  <td class="right">ADMIN FEES</td>
  <td class="right">£${adminFees.toStringAsFixed(2)}</td>
</tr>
<tr>
  <td class="right"><b>GRAND TOTAL</b></td>
  <td class="right"><b>£${mainData.amount}</b></td>
</tr>
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

  ///  Download Excel
  Future<void> downloadApiContentAsExcel() async {
    if (updateInvoiceByIdModel?.accountInvoice?.accountInvoice == null) {
      Get.snackbar("Error", "No invoice data found to export.");
      return;
    }

    final mainData = updateInvoiceByIdModel!.accountInvoice!.accountInvoice!;
    final lineItems = mainData.accountInvoiceLineitems ?? [];

    // 1. Create Excel Object
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Invoice'];
    excel.delete('Sheet1'); // Default sheet delete karein

    // 2. Add Header Row
    List<String> headers = [
      "REF #",
      "DATE",
      "TIME",
      "VEHICLE",
      "CUSTOMER",
      "PICKUP",
      "DROPOFF",
      "FARE",
      "PC",
      "WC",
      "EDC",
      "M&G",
      "CC",
      "TOTAL"
    ];
    sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

    double grandTotal = 0;

    // 3. Add Data Rows
    for (var item in lineItems) {
      final b = item.booking;
      if (b == null) continue;

      double fare = (b.companyPrice ?? 0).toDouble();
      double pc = (b.parkingCharges ?? 0).toDouble();
      double wc = (b.waitingCharges ?? 0).toDouble();
      double edc = (b.extraDropCharges ?? 0).toDouble();
      double mg = (b.meetAndGreet ?? 0).toDouble();
      double cc = (b.congestionCharges ?? 0).toDouble();
      double total = (b.totalCharges ?? 0).toDouble();
      grandTotal += total;

      sheetObject.appendRow([
        TextCellValue(b.referenceNumber ?? ""),
        TextCellValue(b.pickupDate ?? ""),
        TextCellValue(b.pickupTime ?? ""),
        TextCellValue(b.vehicleType?.name ?? ""),
        TextCellValue(b.name ?? ""),
        TextCellValue(b.pickup ?? ""),
        TextCellValue(b.dropoff ?? ""),
        DoubleCellValue(fare),
        DoubleCellValue(pc),
        DoubleCellValue(wc),
        DoubleCellValue(edc),
        DoubleCellValue(mg),
        DoubleCellValue(cc),
        DoubleCellValue(total),
      ]);
    }

    // 4. Add Summary Row (Grand Total)
    sheetObject.appendRow([TextCellValue("")]); // Khali row gap ke liye
    sheetObject.appendRow([
      TextCellValue("GRAND TOTAL"),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      TextCellValue(""),
      DoubleCellValue(grandTotal),
    ]);

    // 5. Download for Web
    try {
      var fileBytes = excel.save();
      if (fileBytes != null) {
        final content = base64Encode(fileBytes);
        final anchor = html.AnchorElement(
            href:
                "data:application/octet-stream;charset=utf-16le;base64,$content")
          ..setAttribute("download", "Invoice_${mainData.invoiceNumber}.xlsx")
          ..click();
      }
    } catch (e) {
      print("Excel Download Error: $e");
    }
  }

  /// Edit Charges Function
  void recalculateRowTotal(dynamic lineItem) {
    final booking = lineItem.booking;
    if (booking != null) {
      // Sab fields ka sum nikalna
      int fare = int.tryParse(booking.companyPrice?.toString() ?? "0") ?? 0;
      int pc = int.tryParse(booking.parkingCharges?.toString() ?? "0") ?? 0;
      int wc = int.tryParse(booking.waitingCharges?.toString() ?? "0") ?? 0;
      int edc = int.tryParse(booking.extraDropCharges?.toString() ?? "0") ?? 0;
      int mg = int.tryParse(booking.meetAndGreet?.toString() ?? "0") ?? 0;
      int cc = int.tryParse(booking.congestionCharges?.toString() ?? "0") ?? 0;
      // Row ka total update karna
      booking.totalCharges = fare + pc + wc + edc + mg + cc;
      // Pura Grand Total bhi recalculate karein
      double tempGrandTotal = 0;
      for (var item in (updateInvoiceByIdModel
              ?.accountInvoice?.accountInvoice?.accountInvoiceLineitems ??
          [])) {
        tempGrandTotal += (item.booking?.totalCharges ?? 0);
      }
      // Admin fees add karke final amount set karein
      double adminFees = double.tryParse(updateInvoiceByIdModel
                  ?.accountInvoice?.accountInvoice?.account?.adminFees
                  ?.toString() ??
              "0") ??
          0.0;
      updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.amount =
          (tempGrandTotal + adminFees).toString();

      update();
    }
  }
}
