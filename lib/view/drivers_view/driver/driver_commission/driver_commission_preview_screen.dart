
import 'package:dashboard_new1/view/drivers_view/controller/driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/color.dart';
import '../../../../component/textStyle.dart';
import '../../model/list_driver_commission_model.dart';

class DriverComissionWindowWrapper extends StatefulWidget {
  @override
  _DriverComissionWindowWrapper createState() => _DriverComissionWindowWrapper();
}

class _DriverComissionWindowWrapper extends State<DriverComissionWindowWrapper> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          // Size toggle logic
          width: isFullScreen ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8,
          height: isFullScreen ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isFullScreen ? BorderRadius.zero : BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                color: DynamicColors.primaryClr,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.crop_square, color: Colors.white, size: 20),
                          onPressed: () => setState(() => isFullScreen = !isFullScreen),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(child: DriverCommissionViewScreen(isPopup: true)),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverCommissionViewScreen extends StatelessWidget {
  final bool isPopup;
  DriverCommissionViewScreen({this.isPopup = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverController>();
    final data = controller.updateDriverCommissionByIdModel?.driverCommission;
    final items = data?.driverCommissionLineitems ?? [];

    final currentDriverId = data?.driver?.id;
    final selectedDriverData = controller.listDriverCommission?.drivers?.firstWhere(
          (d) => d.id == currentDriverId,
      orElse: () => CreateDriverCommission(),
    );

    const tableBorder = TableBorder(
      verticalInside: BorderSide(color: Colors.black, width: 0.5),
      horizontalInside: BorderSide(color: Colors.black, width: 0.5),
      top: BorderSide(color: Colors.black, width: 0.5),
      left: BorderSide(color: Colors.black, width: 0.5),
      right: BorderSide(color: Colors.black, width: 0.5),
      bottom: BorderSide(color: Colors.black, width: 0.5),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isPopup ? null : AppBar(
        title: Text("", style: mozillaTextSemiBoldText(color: Colors.white, fontSize: 20)),
        backgroundColor: DynamicColors.primaryClr,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Center(
              child: Text("DRIVER COMMISSION", style: mozillaTextSemiBoldText(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildUIInfoColumn("", [
                  "PERIOD: (${controller.updateFilterFromDate} - ${controller.updateFilterToDate})",
                ]),
                const Spacer(flex: 1),
                Expanded(
                  flex: 5,
                  child: _buildUIInfoColumn("", [
                    "EMAIL: ${(data?.driver?.email ?? "").toUpperCase()}",
                    "MOBILE: ${selectedDriverData?.mobile ?? ""}",
                    "TELEPHONE: ${selectedDriverData?.telephone ?? ""}",
                  ]),
                ),
                Expanded(
                  flex: 3,
                  child: _buildUIInfoColumn("", [
                    "DRIVER: (${data?.driver?.id ?? ""})",
                    ((data?.driver?.name ?? "").toUpperCase()),
                    "COMMISSION: ${data?.driver?.driverCommission ?? ""}%",
                    "DATE: ${controller.updateTransactionDateController}",
                  ], ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Table(
              border: tableBorder,
              columnWidths: const {
                0: FlexColumnWidth(1.2), 1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(3), 3: FlexColumnWidth(3),
                13: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: DynamicColors.primaryClr),
                  children: [
                    _buildTableCell("REF#", isHeader: true), _buildTableCell("D/T", isHeader: true),
                    _buildTableCell("PICKUP", isHeader: true), _buildTableCell("DROPOFF", isHeader: true),
                    _buildTableCell("VEH", isHeader: true), _buildTableCell("ACC", isHeader: true),
                    _buildTableCell("J/T", isHeader: true), _buildTableCell("P/T", isHeader: true),
                    _buildTableCell("FARE", isHeader: true), _buildTableCell("PC", isHeader: true),
                    _buildTableCell("WC", isHeader: true), _buildTableCell("EDC", isHeader: true),
                    _buildTableCell("CC", isHeader: true), _buildTableCell("W/COMM", isHeader: true),
                    _buildTableCell("COMM", isHeader: true), _buildTableCell("TOTAL", isHeader: true),
                  ],
                ),
                ...items.map((item) {
                  final b = item.booking;
                  String cleanDate = (b?.pickupDate ?? "").toString().split(' ')[0];
                  String cleanTime = (b?.pickupTime ?? "").toString().split('.')[0];
                  if (cleanTime.contains(":")) {
                    var parts = cleanTime.split(":");
                    cleanTime = "${parts[0]}:${parts[1]}";
                  }
                  String formattedDateTime = "$cleanDate\n$cleanTime".trim();
                  return TableRow(
                    children: [
                      _buildTableCell(b?.referenceNumber ?? "", hasEllipsis: true), _buildTableCell(formattedDateTime.isEmpty ? "-" : formattedDateTime),
                      _buildTableCell((b?.pickup ?? "").toUpperCase(), hasEllipsis: true), _buildTableCell((b?.dropoff ?? "").toUpperCase(), hasEllipsis: true),
                      _buildTableCell((b?.vehicleType?.name ?? "").toUpperCase(), hasEllipsis: true), _buildTableCell((b?.account?.name ?? "").toUpperCase(), hasEllipsis: true),
                      _buildTableCell((b?.journeyType?.journeyType ?? "").toUpperCase(), hasEllipsis: true), _buildTableCell((b?.paymentType?.name ?? "").toUpperCase(), hasEllipsis: true),
                      _buildTableCell("£${b?.fares ?? '0'}"), _buildTableCell("£${b?.parkingCharges ?? '0'}"),
                      _buildTableCell("£${b?.waitingCharges ?? '0'}"), _buildTableCell("£${b?.extraDropCharges ?? '0'}"),
                      _buildTableCell("£${b?.congestionCharges ?? '0'}"),
                      _buildTableCell("£${controller.calculateWithoutCommission(b)}"),
                      _buildTableCell("£${controller.calculateFinalDriverComm(b)}"),
                      _buildTableCell("£${b?.totalCharges ?? '0'}", isBold: true),
                    ],
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 8),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildFooterRowPlain("CASH TOTAL:", controller.updateCashTotalValue),
                      _buildFooterRowPlain("COMMISSION TOTAL:", controller.updateTotalCommissionVar),
                      _buildFooterRowPlain("OWED:", controller.updateOwedVar),
                      _buildFooterRowPlain("TOTAL:", controller.updateGrandTotalVar, isBold: true),
                    ],
                  ),
                ),

                const SizedBox(width: 50),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildFooterRowPlain("ACCOUNT W/COMM TOTAL:", controller.updateAccountFareTotalVar),
                      _buildFooterRowPlain("ACCOUNT WO/COMM TOTAL:", controller.updateAccountWOCmmVar),
                      _buildFooterRowPlain("PARKING & CONGESTION CHARGES:", controller.updateParkingCongestionVar),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Helper for footer row
  // Widget _buildFooterRowPlain(String label, double value, {bool isBold = false}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 2,
  //           child: Text(label, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.w600)),
  //         ),
  //         Text("£${value.toStringAsFixed(2)}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildFooterRowPlain(String label, double value, {bool isBold = false}) {
    return Builder(
        builder: (context) {
          bool isLaptop = MediaQuery.of(context).size.width <= 1366;

          double labelFontSize = isBold ? (isLaptop ? 12.0 : 15.0) : (isLaptop ? 11.0 : 14.0);
          double valueFontSize = isLaptop ? 11.0 : 14.0;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: isBold ? FontWeight.bold : FontWeight.w600
                      )
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                    "£${value.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.bold
                    )
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, bool isBold = false, bool hasEllipsis = false}) {
    return Builder(
        builder: (context) {
          bool isLaptop = MediaQuery.of(context).size.width <= 1366;

          double finalFontSize = isHeader ? (isLaptop ? 11.0 : 14.0) : (isLaptop ? 10.0 : 12.0);
          double vPadding = isLaptop ? 4.0 : 8.0;
          double hPadding = isLaptop ? 2.0 : 4.0;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: isHeader ? 2 : (hasEllipsis ? 1 : 3),
              overflow: hasEllipsis ? TextOverflow.ellipsis : TextOverflow.clip,
              style: TextStyle(
                  fontSize: finalFontSize,
                  fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
                  color: isHeader ? Colors.white : Colors.black
              ),
            ),
          );
        }
    );
  }
  // Widget _buildTableCell(String text, {bool isHeader = false, bool isBold = false, bool hasEllipsis = false}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  //     child: Text(text, textAlign: TextAlign.center,
  //         maxLines: isHeader ? 2 : (hasEllipsis ? 1 : 3),
  //         overflow: hasEllipsis ? TextOverflow.ellipsis : TextOverflow.clip,
  //         style: TextStyle(fontSize: isHeader ? 15 : 13, fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal, color: isHeader ? Colors.white : Colors.black)),
  //   );
  // }

  Widget _buildUIInfoColumn(String title, List<String> lines, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DynamicColors.primaryClr)),
        const SizedBox(height: 5),
        ...lines.map((line) {
          if (line.isEmpty) return const SizedBox(height: 10);
          if (line.contains(":")) {
            final parts = line.split(":");
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text.rich(TextSpan(children: [
                TextSpan(text: "${parts[0]}: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                TextSpan(text: parts.sublist(1).join(":"), style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black87)),
              ]), textAlign: alignEnd ? TextAlign.right : TextAlign.left),
            );
          }
          return Text(line, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500));
        }),
      ],
    );
  }
}