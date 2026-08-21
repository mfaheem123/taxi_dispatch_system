import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../controller/report_controller.dart';

class IncomeReportViewWindow extends StatefulWidget {
  const IncomeReportViewWindow({super.key});

  @override
  _IncomeReportViewWindow createState() => _IncomeReportViewWindow();
}

class _IncomeReportViewWindow extends State<IncomeReportViewWindow> {
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
              // Top Bar with Maximize and Close Buttons
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: DynamicColors.primaryClr,
                  borderRadius: isFullScreen
                      ? BorderRadius.zero
                      : const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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
              const Expanded(child: IncomeReportContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class IncomeReportContent extends StatelessWidget {
  const IncomeReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    ReportController controller = Get.isRegistered<ReportController>()
        ? Get.find<ReportController>()
        : Get.put(ReportController());

    var dataList = controller.incomeModel?.bookings ?? [];

    String totalBookingsCount = controller.incomeModel?.totalBookings?.toString() ?? "${dataList.length}";
    String totalEarningSum = controller.incomeModel?.totalEarnings != null
        ? controller.incomeModel!.totalEarnings!.toStringAsFixed(2)
        : "0.00";
    // final currentSubsidiary = controller.apiSelectedSubsidiary;
    // String subEmail = currentSubsidiary?.email ?? "N/A";
    // String subPhone = currentSubsidiary?.telephoneNumber ?? "N/A";
    // String subMobile = currentSubsidiary?.emergencyContactNumber ?? "N/A";
    final currentSubsidiary = controller.apiSelectedIncomeSubsidiary;

    String subEmail = currentSubsidiary?.email ?? "N/A";
    String subPhone = currentSubsidiary?.telephoneNumber ?? "N/A";
    String subMobile = currentSubsidiary?.emergencyContactNumber ?? "N/A";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo section
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
                "INCOME",
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
                      _infoText("MOBILE", subPhone.toUpperCase()),
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
                      _infoText("EMAIL", subEmail.toUpperCase()),
                      const SizedBox(height: 5),
                      _infoText("TELEPHONE", subMobile.toUpperCase()),
                      const SizedBox(height: 5),
                      const Divider(thickness: 1, color: Colors.black26),
                      _infoText("TOTAL FARES", "£ $totalEarningSum"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Filtered Data Table (Sirf 6 columns jo aapne bole)
            Table(
              border: TableBorder.all(color: Colors.black.withOpacity(0.2)),
              columnWidths: const {
                0: FlexColumnWidth(1.2), // REF #
                1: FlexColumnWidth(1.5), // DATETIME
                2: FlexColumnWidth(1.2), // VEHICLE
                3: FlexColumnWidth(3.0), // PICKUP
                4: FlexColumnWidth(3.0), // DROPOFF
                5: FlexColumnWidth(1.2), // FARES
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: DynamicColors.primaryClr),
                  children: [
                    _tableCell("REF #", isHeader: true),
                    _tableCell("DATETIME", isHeader: true),
                    _tableCell("VEHICLE", isHeader: true),
                    _tableCell("PICKUP", isHeader: true),
                    _tableCell("DROPOFF", isHeader: true),
                    _tableCell("FARES", isHeader: true),
                  ],
                ),

                // Data Rows
                ...dataList.map((item) {
                  // Datetime formatting
                  String formattedDateTime = "-";
                  if (item.pickupDate != null) {
                    String date = DateFormat('dd-MM-yyyy').format(item.pickupDate!);
                    String time = item.pickupTime ?? "";
                    formattedDateTime = "$date\n$time".trim();
                  }

                  // Fare handling
                  String currentFare = (item.fares == null || item.fares!.trim().isEmpty)
                      ? "£0.00"
                      : "£${item.fares}";

                  return TableRow(
                    children: [
                      _tableCell(item.referenceNumber ?? "-"),
                      _tableCell(formattedDateTime),
                      _tableCell((item.vehicle ?? "-").toUpperCase()),
                      _tableCell((item.pickup ?? "-").toUpperCase()),
                      _tableCell((item.dropoff ?? "-").toUpperCase()),
                      _tableCell(currentFare),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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