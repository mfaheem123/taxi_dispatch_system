import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerPreInvoiceController extends GetxController {
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
    },
  ];

  Set<String> selectedIds = {};

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
      selectedIds = bookings
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

    for (var booking in bookings) {
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