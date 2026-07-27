import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../component/color.dart';
import '../controller/preinvoice_controller.dart';

class PreInvoiceViewWindowWrapper extends StatefulWidget {
  final CustomerPreInvoiceController controller;
  
  const PreInvoiceViewWindowWrapper({Key? key, required this.controller}) : super(key: key);
  
  @override
  _PreInvoiceViewWindowWrapperState createState() =>
      _PreInvoiceViewWindowWrapperState();
}

class _PreInvoiceViewWindowWrapperState
    extends State<PreInvoiceViewWindowWrapper> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isFullScreen
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width * 0.9,
          height: isFullScreen
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            isFullScreen ? BorderRadius.zero : BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),
          child: Column(
            children: [
              // Header Bar
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                              isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.crop_square,
                              color: Colors.black,
                              size: 20),
                          onPressed: () =>
                              setState(() => isFullScreen = !isFullScreen),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close,
                              color: Colors.black, size: 20),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(child: CustomerPreInvoiceViewScreen(controller: widget.controller)),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerPreInvoiceViewScreen extends StatelessWidget {
  final CustomerPreInvoiceController controller;
  
  const CustomerPreInvoiceViewScreen({Key? key, required this.controller}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final bookings = controller.filteredBookings;

    // Variables for calculations
    double totalFare = 0,
        totalPC = 0,
        totalWC = 0,
        totalEDC = 0,
        totalMG = 0,
        totalCC = 0,
        grandTotal = 0;

    for (var b in bookings) {
      totalFare += double.tryParse(b["fares"]?.toString() ?? '0') ?? 0.0;
      totalPC += double.tryParse(b["parkingCharges"]?.toString() ?? '0') ?? 0.0;
      totalWC += double.tryParse(b["waitingCharges"]?.toString() ?? '0') ?? 0.0;
      totalEDC += double.tryParse(b["extraDropCharges"]?.toString() ?? '0') ?? 0.0;
      totalMG += double.tryParse(b["meetAndGreet"]?.toString() ?? '0') ?? 0.0;
      totalCC += double.tryParse(b["congestionCharges"]?.toString() ?? '0') ?? 0.0;
      grandTotal += double.tryParse(b["totalCharges"]?.toString() ?? '0') ?? 0.0;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("CUSTOMER PRE INVOICE",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2)),
            ),
            const SizedBox(height: 30),

            // Header Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoColumn([
                    {"EMAIL": controller.emailController.text.toUpperCase()},
                    {"MOBILE": controller.mobileController.text},
                    {"TELEPHONE": controller.telController.text},
                  ]),
                  _infoColumn([
                    {"CUSTOMER": controller.nameController.text.toUpperCase()},
                    {"DATE": controller.invoiceDate.split(' ').first},
                    {"DUE DATE": controller.invoiceDueDate.split(' ').first},
                  ], isRight: true),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                      text: "PERIOD: (",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  TextSpan(
                      text: "${controller.filterFromDate.split(' ').first} TO ${controller.filterToDate.split(' ').first}",
                      style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16)
                  ),
                  const TextSpan(
                      text: ")",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Main Table
            Table(
              border: TableBorder.all(color: Colors.grey.shade400, width: 1),
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.5),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
              },
              children: [
                // 1. HEADER ROW
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  children: [
                    _cell("REF #", isHeader: true),
                    _cell("DATETIME", isHeader: true),
                    _cell("VEH", isHeader: true),
                    _cell("PICKUP", isHeader: true),
                    _cell("DROPOFF", isHeader: true),
                    _cell("J/T", isHeader: true),
                    _cell("P/T", isHeader: true),
                    _cell("FARE", isHeader: true),
                    _cell("PC", isHeader: true),
                    _cell("WC", isHeader: true),
                    _cell("EDC", isHeader: true),
                    _cell("M&G", isHeader: true),
                    _cell("CC", isHeader: true),
                    _cell("TOTAL", isHeader: true),
                  ],
                ),

                ...bookings.map((b) {
                  final fareVal = double.tryParse(b["fares"]?.toString() ?? '0') ?? 0.0;
                  final pcVal = double.tryParse(b["parkingCharges"]?.toString() ?? '0') ?? 0.0;
                  final wcVal = double.tryParse(b["waitingCharges"]?.toString() ?? '0') ?? 0.0;
                  final edcVal = double.tryParse(b["extraDropCharges"]?.toString() ?? '0') ?? 0.0;
                  final mgVal = double.tryParse(b["meetAndGreet"]?.toString() ?? '0') ?? 0.0;
                  final ccVal = double.tryParse(b["congestionCharges"]?.toString() ?? '0') ?? 0.0;
                  final totalVal = double.tryParse(b["totalCharges"]?.toString() ?? '0') ?? 0.0;

                  return TableRow(
                    children: [
                      _cell(b["referenceNumber"]?.toString() ?? ""),
                      _cell("${b["pickupDate"]?.toString() ?? ""}\n${b["pickupTime"]?.toString() ?? ""}"),
                      _cell(b["vehicleType"]?.toString() ?? ""),
                      _cell(b["pickup"]?.toString() ?? ""),
                      _cell(b["dropoff"]?.toString() ?? ""),
                      _cell(b["journeyType"]?.toString() ?? ""),
                      _cell(b["paymentType"]?.toString() ?? ""),
                      _cell("£${fareVal.toStringAsFixed(2)}"),
                      _cell("£${pcVal.toStringAsFixed(2)}"),
                      _cell("£${wcVal.toStringAsFixed(2)}"),
                      _cell("£${edcVal.toStringAsFixed(2)}"),
                      _cell("£${mgVal.toStringAsFixed(2)}"),
                      _cell("£${ccVal.toStringAsFixed(2)}"),
                      _cell("£${totalVal.toStringAsFixed(2)}", isBold: true),
                    ],
                  );
                }).toList(),

                // 1. TOTAL ROW
                TableRow(
                  children: [
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell("TOTAL", isBold: true, align: TextAlign.right),
                    _cell("£${totalFare.toStringAsFixed(2)}", isBold: true),
                    _cell("£${totalPC.toStringAsFixed(2)}", isBold: true),
                    _cell("£${totalWC.toStringAsFixed(2)}", isBold: true),
                    _cell("£${totalEDC.toStringAsFixed(2)}", isBold: true),
                    _cell("£${totalMG.toStringAsFixed(2)}", isBold: true),
                    _cell("£${totalCC.toStringAsFixed(2)}", isBold: true),
                    _cell("£${grandTotal.toStringAsFixed(2)}", isBold: true),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _footer("PC: PARKING CHARGES"),
                    _footer("WC: WAITING CHARGES"),
                    _footer("EDC: EXTRA DROP CHARGES"),
                    _footer("M&G: MEET AND GREET"),
                    _footer("CC: CONGESTION CHARGES"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(List<Map<String, String>> data, {bool isRight = false}) {
    return Column(
      crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: data.map((item) {
        final String key = item.keys.first;
        final String value = item.values.first;
        final String label = value.isEmpty ? key : "$key: ";

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: label,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                if (value.isNotEmpty)
                  TextSpan(
                      text: value,
                      style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16)
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _cell(String text,
      {bool isHeader = false,
        bool isBold = false,
        TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Container(
        alignment: align == TextAlign.center
            ? Alignment.center
            : (align == TextAlign.right ? Alignment.centerRight : Alignment.centerLeft),
        child: Text(
          text.toUpperCase(),
          textAlign: align,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isHeader ? 15 : 14,
            fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
  Widget _footer(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
