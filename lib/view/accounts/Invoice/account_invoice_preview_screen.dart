import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../controller/invoice_controller.dart';

class InvoicePreviewWindowWrapper extends StatefulWidget {
  @override
  _InvoicePreviewWindowWrapperState createState() =>
      _InvoicePreviewWindowWrapperState();
}

class _InvoicePreviewWindowWrapperState
    extends State<InvoicePreviewWindowWrapper> {
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
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),
          child: Column(
            children: [
              // Header Bar
              Container(
                height: 45,
                color: const Color(0xFF003366),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Account Invoice Preview",
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
                              color: Colors.white,
                              size: 20),
                          onPressed: () =>
                              setState(() => isFullScreen = !isFullScreen),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(child: AccountInvoiceViewScreen()),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountInvoiceViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InvoiceController>();
    final mainData =
        controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice;

    if (mainData == null) {
      return const Center(child: Text("No Invoice Data Found"));
    }

    final accountData = mainData.account;
    final subsidiaryData = accountData?.subsidiary;
    final List lineItems = mainData.accountInvoiceLineitems ?? [];

    // Variables for calculations
    double totalFare = 0,
        totalPC = 0,
        totalWC = 0,
        totalEDC = 0,
        totalMG = 0,
        totalCC = 0,
        grandTotal = 0;

    for (var item in lineItems) {
      final b = item.booking;
      if (b == null) continue;
      totalFare += (b.companyPrice ?? 0).toDouble();
      totalPC += (b.parkingCharges ?? 0).toDouble();
      totalWC += (b.waitingCharges ?? 0).toDouble();
      totalEDC += (b.extraDropCharges ?? 0).toDouble();
      totalMG += (b.meetAndGreet ?? 0).toDouble();
      totalCC += (b.congestionCharges ?? 0).toDouble();
      grandTotal += (b.totalCharges ?? 0).toDouble();
    }

    // Admin Fees Calculation
    double adminFees = 0;
    if (accountData?.adminFeesType == "AMOUNT") {
      adminFees = (accountData?.adminFees ?? 0).toDouble();
    } else if (accountData?.adminFeesType == "PERCENTAGE") {
      adminFees = (grandTotal * (accountData?.adminFees ?? 0) / 100);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("ACCOUNT INVOICE",
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
                    {"EMAIL": "${subsidiaryData?.email ?? ""}"},
                    {"MOBILE": "${accountData?.mobile ?? ""}"},
                    {"TELEPHONE": "${subsidiaryData?.telephoneNumber ?? ""}"},
                  ]),
                  _infoColumn([
                    {"ACCOUNT": "${accountData?.name ?? ""}"},
                    {"ORDER #": "${mainData.orderNumber ?? "-"}"},
                    {"DATE": "${mainData.invoiceDate ?? ""}"},
                    {"DUE DATE": "${mainData.invoiceDueDate ?? ""}"},
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
                      text: "${mainData.fromDate ?? ""} TO ${mainData.toDate ?? ""}",
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
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.5),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
              },
              children: [
                // 1. HEADER ROW
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: [
                    _cell("REF #", isHeader: true),
                    _cell("DATETIME", isHeader: true),
                    _cell("VEH", isHeader: true),
                    _cell("CUSTOMER", isHeader: true),
                    _cell("PICKUP", isHeader: true),
                    _cell("DROPOFF", isHeader: true),
                    _cell("FARE", isHeader: true),
                    _cell("PC", isHeader: true),
                    _cell("WC", isHeader: true),
                    _cell("EDC", isHeader: true),
                    _cell("M&G", isHeader: true),
                    _cell("CC", isHeader: true),
                    _cell("TOTAL", isHeader: true),
                  ],
                ),

                ...lineItems.map((item) {
                  final b = item.booking;
                  return TableRow(
                    children: [
                      _cell(b?.referenceNumber ?? ""),
                      _cell("${b?.pickupDate ?? ""}\n${b?.pickupTime ?? ""}"),
                      _cell(b?.vehicleType?.name ?? ""),
                      _cell(b?.name ?? ""),
                      _cell(b?.pickup ?? ""),
                      _cell(b?.dropoff ?? ""),
                      _cell("£${(b?.companyPrice ?? 0).toStringAsFixed(2)}"),
                      _cell("£${(b?.parkingCharges ?? 0).toStringAsFixed(2)}"),
                      _cell("£${(b?.waitingCharges ?? 0).toStringAsFixed(2)}"),
                      _cell(
                          "£${(b?.extraDropCharges ?? 0).toStringAsFixed(2)}"),
                      _cell("£${(b?.meetAndGreet ?? 0).toStringAsFixed(2)}"),
                      _cell(
                          "£${(b?.congestionCharges ?? 0).toStringAsFixed(2)}"),
                      _cell("£${(b?.totalCharges ?? 0).toStringAsFixed(2)}",
                          isBold: true),
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

                // 2. ADMIN FEES ROW
                TableRow(
                  children: [
                    _cell(""), _cell(""), _cell(""), _cell(""), _cell(""),
                    _cell("ADMIN FEES",
                        isBold: true, align: TextAlign.right),
                    _cell(""), _cell(""), _cell(""), _cell(""), _cell(""),
                    _cell(""),
                    _cell("£${adminFees.toStringAsFixed(2)}", isBold: true),
                  ],
                ),

                // 3. GRAND TOTAL ROW
                TableRow(
                  children: [
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell("GRAND TOTAL", isBold: true, align: TextAlign.right),
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell(""),
                    _cell("£${mainData.amount}", isBold: true),
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
      children: data.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: "${item.keys.first}: ",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
              TextSpan(
                  text: item.values.first,
                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16)
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _cell(String text,
      {bool isHeader = false,
      bool isBold = false,
      TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(text,
          textAlign: align,
          style: TextStyle(
            fontSize: isHeader ? 15 : 14,
            fontWeight:
                (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
          )),
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
