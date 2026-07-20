import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../controller/report_controller.dart';
class AllBookingViewWindow extends StatefulWidget {
  const AllBookingViewWindow({super.key});

  @override
  _AllBookingViewWindow createState() => _AllBookingViewWindow();
}

class _AllBookingViewWindow extends State<AllBookingViewWindow> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isFullScreen ? Get.width : Get.width * 0.9,
          height: isFullScreen ? Get.height : Get.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isFullScreen ? BorderRadius.zero : BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: DynamicColors.primaryClr,
                  borderRadius: isFullScreen ? BorderRadius.zero : const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white, size: 20),
                      onPressed: () => setState(() => isFullScreen = !isFullScreen),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              const Expanded(child: AllBookingReportContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class AllBookingReportContent extends StatelessWidget {
  const AllBookingReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    ReportController controller = Get.isRegistered<ReportController>()
        ? Get.find<ReportController>()
        : Get.put(ReportController());

    var dataList = controller.bookingStatisticsModel?.data ?? [];
    var totalsData = controller.bookingStatisticsModel?.totals;

    String topMobile = dataList.isNotEmpty ? (dataList.first.mobile ?? "-") : "-";
    String topEmail = dataList.isNotEmpty ? (dataList.first.email ?? "-").toUpperCase() : "-";
    String topTelephone = dataList.isNotEmpty ? (dataList.first.telephone ?? "-") : "-";

    String totalBookingsCount = totalsData?.totalBookings?.toString() ?? "${dataList.length}";
    String totalFaresSum = totalsData?.totalEarnings != null
        ? totalsData!.totalEarnings!.toStringAsFixed(2)
        : "0.00";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/logo.jpeg",
                height: 70,
                errorBuilder: (context, e, s) => const Icon(Icons.business, size: 70),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "BOOKINGS REPORT",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoText("MOBILE", topMobile),
                      const SizedBox(height: 5),
                      const Divider(thickness: 1, color: Colors.black26),
                      _infoText("TOTAL BOOKINGS", totalBookingsCount),
                    ],
                  ),
                ),
                const SizedBox(width: 100),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoText("EMAIL", topEmail),
                      _infoText("TELEPHONE", topTelephone),
                      const SizedBox(height: 5),
                      const Divider(thickness: 1, color: Colors.black26),
                      _infoText("TOTAL FARES", "£ $totalFaresSum"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Table(
              border: TableBorder.all(color: Colors.black.withOpacity(0.2)),
              columnWidths: const {
                0: FlexColumnWidth(1.2), // REF #
                1: FlexColumnWidth(1.2), // INVOICE #
                2: FlexColumnWidth(1.5), // DATETIME
                3: FlexColumnWidth(1), // CUSTOMER
                4: FlexColumnWidth(2.5), // PICKUP
                5: FlexColumnWidth(2.5), // DROPOFF
                6: FlexColumnWidth(1),   // FARE
                7: FlexColumnWidth(1),   // ACC FARE
                8: FlexColumnWidth(1),   // ACC
                9: FlexColumnWidth(1.2), // ORDER #
                10: FlexColumnWidth(0.8),// P/T
                11: FlexColumnWidth(0.8),// J/T
                12: FlexColumnWidth(1),  // DRV
                13: FlexColumnWidth(1),  // VEH
                14: FlexColumnWidth(1),  // SUBS
                15: FlexColumnWidth(1.2),// STATUS
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: DynamicColors.primaryClr),
                  children: [
                    _tableCell("REF #", isHeader: true),
                    _tableCell("INV #", isHeader: true),
                    _tableCell("D/T", isHeader: true),
                    _tableCell("CUST", isHeader: true),
                    _tableCell("PICKUP", isHeader: true),
                    _tableCell("DROPOFF", isHeader: true),
                    _tableCell("FARE", isHeader: true),
                    _tableCell("ACC FARE", isHeader: true),
                    _tableCell("ACC", isHeader: true),
                    _tableCell("ORDER #", isHeader: true),
                    _tableCell("P/T", isHeader: true),
                    _tableCell("J/T", isHeader: true),
                    _tableCell("DRV", isHeader: true),
                    _tableCell("VEH", isHeader: true),
                    _tableCell("SUBS", isHeader: true),
                    _tableCell("STATUS", isHeader: true),
                  ],
                ),
                // Data Rows
                ...dataList.map((item) {
                  // Date Time format handle
                  String formattedDateTime = "-";
                  if (item.pickupDate != null) {
                    String date = DateFormat('dd-MM-yyyy').format(item.pickupDate!);
                    String time = item.pickupTime ?? "";
                    formattedDateTime = "$date\n$time".trim();
                  }

                  // Fare String empty checks
                  String currentFare = (item.fares == null || item.fares!.trim().isEmpty)
                      ? "£0.00"
                      : "£${item.fares}";

                  return TableRow(
                    children: [
                      _tableCell(item.referenceNumber ?? "-"),
                      _tableCell(item.invoiceNumber?.toString() ?? "-"),
                      _tableCell(formattedDateTime),
                      _tableCell((item.name ?? "-").toUpperCase()),
                      _tableCell((item.pickup ?? "-").toUpperCase()),
                      _tableCell((item.dropoff ?? "-").toUpperCase()),
                      _tableCell(currentFare),
                      _tableCell("£ ${item.companyPrice ?? '0.00'}"),
                      _tableCell((item.account?.name ?? "-").toUpperCase()),
                      _tableCell(item.orderNumber?.toString() ?? "-"),
                      _tableCell((item.paymentType?.name ?? "-").toUpperCase()),
                      _tableCell((item.journeyType?.journeyType ?? "-").toUpperCase()),
                      _tableCell((item.driver?.name ?? "-").toUpperCase()),
                      _tableCell((item.vehicleType?.name ?? "-").toUpperCase()),
                      _tableCell((item.subsidiary?.name ?? "-").toUpperCase()),
                      _tableCell((item.bookingStatus?.bookingStatus ?? "-").toUpperCase()),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isHeader ? 14 : 13,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}