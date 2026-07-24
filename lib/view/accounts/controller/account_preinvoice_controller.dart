import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:excel/excel.dart';

class AccountPreInvoiceController extends GetxController {
  //==================== Invoice ====================//

  String invoiceDate = DateTime.now().toString().split(" ")[0];

  String invoiceDueDate =
  DateTime.now().add(const Duration(days: 7)).toString().split(" ")[0];

  String invoiceNumber = "kkkkSH2";

  //==================== Customer ====================//

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController telController = TextEditingController();

  //==================== Filter ====================//

  String filterFromDate = DateTime.now().toString().split(" ")[0];
  String filterToDate = DateTime.now().toString().split(" ")[0];

  final GlobalKey exportKey = GlobalKey();

  //==================== Payment ====================//

  final List<Map<String, dynamic>> paymentTypes = [
    {"id": 1, "name": "Cash"},
    {"id": 2, "name": "Credit Card"},
    {"id": 3, "name": "Account"},
    {"id": 4, "name": "Credit Card Paid"},
  ];

  Set<int> selectedPaymentTypeIds = {};

  //==================== Booking ====================//

  List<Map<String, dynamic>> bookings = [
    {
      "id": 1,
      "referenceNumber": "B-1001",
      "pickupDate": "2026-07-21",
      "pickupTime": "10:30",
      "pickup": "123 Main St",
      "dropoff": "Airport",
      "vehicleType": "SALOON",
      "journeyType": "SINGLE",
      "paymentType": "CASH",
      "fares": "45.00",
      "parkingCharges": "0",
      "waitingCharges": "0",
      "extraDropCharges": "0",
      "meetAndGreet": "0",
      "congestionCharges": "0",
      "totalCharges": "45.00",
      "status": "UNPAID",
    },
    {
      "id": 2,
      "referenceNumber": "B-1002",
      "pickupDate": "2026-07-22",
      "pickupTime": "14:00",
      "pickup": "Airport",
      "dropoff": "456 Park Ave",
      "vehicleType": "ESTATE",
      "journeyType": "SINGLE",
      "paymentType": "CARD",
      "fares": "55.00",
      "parkingCharges": "5.00",
      "waitingCharges": "0",
      "extraDropCharges": "0",
      "meetAndGreet": "10.00",
      "congestionCharges": "0",
      "totalCharges": "70.00",
      "status": "PAID",
    },
  ];

  Set<String> selectedIds = {};

  bool isBookingPaid = false;

  void toggleBookingPaid() {
    isBookingPaid = !isBookingPaid;
    update();
  }

  List<Map<String, dynamic>> get filteredBookings {
    return bookings.where((booking) {
      // If status is not provided, default to UNPAID
      final status = booking["status"] ?? "UNPAID";
      if (isBookingPaid) {
        return status == "PAID";
      } else {
        return status == "UNPAID";
      }
    }).toList();
  }

  //==================== Dates ====================//

  void changeInvoiceDate(DateTime date) {
    invoiceDate = "${date.year}-${date.month}-${date.day}";
    update();
  }

  void changeInvoiceDueDate(DateTime date) {
    invoiceDueDate = "${date.year}-${date.month}-${date.day}";
    update();
  }

  void changeFromDate(DateTime date) {
    filterFromDate = date.toIso8601String().split("T").first;
    update();
  }

  void changeToDate(DateTime date) {
    filterToDate = date.toIso8601String().split("T").first;
    update();
  }

  //==================== Payment ====================//

  void togglePayment(int id) {
    if (selectedPaymentTypeIds.contains(id)) {
      selectedPaymentTypeIds.remove(id);
    } else {
      selectedPaymentTypeIds.add(id);
    }
    update();
  }

  //==================== Row Selection ====================//

  void toggleBookingSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    update();
  }

  void selectAll(bool value) {
    if (value) {
      selectedIds = filteredBookings
          .map((e) => e["id"].toString())
          .toSet();
    } else {
      selectedIds.clear();
    }
    update();
  }

  //==================== Totals ====================//

  double getInvoiceTableColumnTotal(String key) {
    double total = 0;

    for (var booking in filteredBookings) {
      if (selectedIds.isEmpty ||
          selectedIds.contains(booking["id"].toString())) {
        total +=
            double.tryParse(booking[key]?.toString() ?? "0") ??
                0;
      }
    }

    return total;
  }

  void recalculateTotalRow(Map<String, dynamic> booking) {
    double fare =
        double.tryParse(booking["fares"].toString()) ?? 0;

    double parking =
        double.tryParse(booking["parkingCharges"].toString()) ??
            0;

    double waiting =
        double.tryParse(booking["waitingCharges"].toString()) ??
            0;

    double extra =
        double.tryParse(booking["extraDropCharges"].toString()) ??
            0;

    double meet =
        double.tryParse(booking["meetAndGreet"].toString()) ??
            0;

    double congestion =
        double.tryParse(booking["congestionCharges"].toString()) ??
            0;

    booking["totalCharges"] = (fare +
        parking +
        waiting +
        extra +
        meet +
        congestion)
        .toStringAsFixed(2);

    update();
  }

  //==================== Update Cell ====================//

  void updateFare(
      Map<String, dynamic> booking,
      String key,
      String value) {
    booking[key] = value;
    recalculateTotalRow(booking);
  }

  //==================== Actions ====================//

  void filterBookings() {
    // TODO : Filter API
    update();
  }

  void saveInvoice() {
    // TODO : Save Invoice API
  }

  void downloadPdfFile({bool isView = false}) {
    if (filteredBookings.isEmpty) {
      Get.snackbar("ERROR", "NO DATA FOUND TO EXPORT.");
      return;
    }

    double totalFare = 0;
    double totalPC = 0;
    double totalWC = 0;
    double totalEDC = 0;
    double totalMG = 0;
    double totalCC = 0;
    double grandTotal = 0;

    String tableRows = "";

    for (var b in filteredBookings) {
      double fare = double.tryParse(b["fares"]?.toString() ?? "0") ?? 0.0;
      double pc = double.tryParse(b["parkingCharges"]?.toString() ?? "0") ?? 0.0;
      double wc = double.tryParse(b["waitingCharges"]?.toString() ?? "0") ?? 0.0;
      double edc = double.tryParse(b["extraDropCharges"]?.toString() ?? "0") ?? 0.0;
      double mg = double.tryParse(b["meetAndGreet"]?.toString() ?? "0") ?? 0.0;
      double cc = double.tryParse(b["congestionCharges"]?.toString() ?? "0") ?? 0.0;
      double total = double.tryParse(b["totalCharges"]?.toString() ?? "0") ?? 0.0;

      totalFare += fare;
      totalPC += pc;
      totalWC += wc;
      totalEDC += edc;
      totalMG += mg;
      totalCC += cc;
      grandTotal += total;

      String formattedDate = "-";
      if (b["pickupDate"] != null && b["pickupDate"].toString().isNotEmpty) {
        try {
          DateTime parsedDate = DateFormat("yyyy-M-d").parse(b["pickupDate"].toString());
          formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
        } catch (_) {
          formattedDate = b["pickupDate"].toString();
        }
      }

      String formattedTime = "-";
      if (b["pickupTime"] != null && b["pickupTime"].toString().isNotEmpty) {
        formattedTime = b["pickupTime"].toString().split('.')[0].substring(0, 5);
      }

      tableRows += """
      <tr>
        <td>${b["referenceNumber"] ?? ""}</td>
        <td>$formattedDate<br>$formattedTime</td>
        <td>${b["vehicleType"] ?? ""}</td>
        <td>${b["pickup"] ?? ""}</td>
        <td>${b["dropoff"] ?? ""}</td>
        <td>${b["journeyType"] ?? ""}</td>
        <td>${b["paymentType"] ?? ""}</td>
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
th, td { border: 1px solid #ccc; padding: 6px; text-transform: uppercase; text-align: center; }
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

<h2>ACCOUNT PRE INVOICE</h2>

<div class="header">
  <div>
    <b>EMAIL:</b> ${emailController.text}<br>
    <b>MOBILE:</b> ${mobileController.text}<br>
    <b>TELEPHONE:</b> ${telController.text}
  </div>

  <div>
      <b>ACCOUNT:</b> ${nameController.text}<br>
    <b>DATE:</b> ${invoiceDate.toString().split(' ').first}<br>
    <b>DUE DATE:</b> ${invoiceDueDate.toString().split(' ').first}
  </div>
</div>

<p><b>PERIOD:</b> (${filterFromDate.toString().split(' ').first} TO ${filterToDate.toString().split(' ').first})</p>

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
      
      if (isView) {
        html.window.open(url, "_blank");
      } else {
        html.AnchorElement(href: url)
          ..setAttribute("download", "PreInvoice_$invoiceNumber.html")
          ..click();
      }
      
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      debugPrint("Download Error: $e");
    }
  }

  void downloadExel() {
    if (filteredBookings.isEmpty) {
      Get.snackbar("ERROR", "NO DATA FOUND TO EXPORT.");
      return;
    }

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Invoice'];
    excel.delete('Sheet1');

    List<String> headers = [
      "REF #",
      "DATE",
      "TIME",
      "VEHICLE",
      "PICKUP",
      "DROPOFF",
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

    for (var b in filteredBookings) {
      double fare = double.tryParse(b["fares"]?.toString() ?? "0") ?? 0.0;
      double pc = double.tryParse(b["parkingCharges"]?.toString() ?? "0") ?? 0.0;
      double wc = double.tryParse(b["waitingCharges"]?.toString() ?? "0") ?? 0.0;
      double edc = double.tryParse(b["extraDropCharges"]?.toString() ?? "0") ?? 0.0;
      double mg = double.tryParse(b["meetAndGreet"]?.toString() ?? "0") ?? 0.0;
      double cc = double.tryParse(b["congestionCharges"]?.toString() ?? "0") ?? 0.0;
      double total = double.tryParse(b["totalCharges"]?.toString() ?? "0") ?? 0.0;

      sheetObject.appendRow([
        TextCellValue(b["referenceNumber"]?.toString() ?? ""),
        TextCellValue(b["pickupDate"]?.toString() ?? ""),
        TextCellValue(b["pickupTime"]?.toString() ?? ""),
        TextCellValue((b["vehicleType"]?.toString() ?? "").toUpperCase()),
        TextCellValue((b["pickup"]?.toString() ?? "").toUpperCase()),
        TextCellValue((b["dropoff"]?.toString() ?? "").toUpperCase()),
        TextCellValue((b["journeyType"]?.toString() ?? "").toUpperCase()),
        TextCellValue((b["paymentType"]?.toString() ?? "").toUpperCase()),
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
      var fileBytes = excel.save();

      if (fileBytes != null) {
        final blob = html.Blob([
          fileBytes
        ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);

        html.AnchorElement(href: url)
          ..setAttribute(
              "download", "PreInvoice_$invoiceNumber.xlsx")
          ..click();

        html.Url.revokeObjectUrl(url);
      }
    } catch (e) {
      debugPrint("Excel Download Error: $e");
      Get.snackbar("ERROR", "FAILED TO DOWNLOAD EXCEL FILE");
    }
  }

  void saveBookingRow(Map<String, dynamic> booking) {
    // TODO : Save Row API
  }

  //==================== Pre Invoice List ====================//

  bool isPaid = false;
  String searchQuery = "";
  final FocusNode paidNode = FocusNode();

  List<Map<String, dynamic>> preInvoicesList = [
    {
      "invoiceNumber": "kkma890",
      "customer": "NADEEM",
      "date": "2026-07-18",
      "dueDate": "2026-07-23",
      "status": "UNPAID",
      "amount": "4.90",
    },
    {
      "invoiceNumber": "kkkkk999",
      "customer": "AHMED",
      "date": "2026-07-19",
      "dueDate": "2026-07-24",
      "status": "PAID",
      "amount": "12.50",
    },
    {
      "invoiceNumber": "llll453",
      "customer": "NADEEM",
      "date": "2026-07-18",
      "dueDate": "2026-07-23",
      "status": "UNPAID",
      "amount": "4.90",
    }
  ];

  void togglePaid(bool value) {
    isPaid = value;
    update();
  }

  List<Map<String, dynamic>> get filteredPreInvoices {
    return preInvoicesList.where((invoice) {
      if (isPaid) {
        return invoice["status"] == "PAID";
      } else {
        return invoice["status"] == "UNPAID";
      }
    }).toList();
  }

  void setEditData(Map<String, dynamic> invoice) {
    invoiceNumber = invoice["invoiceNumber"] ?? invoiceNumber;
    nameController.text = invoice["customer"] ?? "";
    invoiceDate = invoice["date"] ?? invoiceDate;
    invoiceDueDate = invoice["dueDate"] ?? invoiceDueDate;
    update();
  }

  //==================== Dispose ====================//
// Dispose
//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     mobileController.dispose();
//     telController.dispose();
//     paidNode.dispose();
//     super.onClose();
//   }
}