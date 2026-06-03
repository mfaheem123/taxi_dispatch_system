import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../controller/report_controller.dart';

class CompanyIncomeViewWindow extends StatefulWidget {
  const CompanyIncomeViewWindow({super.key});

  @override
  State<CompanyIncomeViewWindow> createState() =>
      _CompanyIncomeViewWindowState();
}

class _CompanyIncomeViewWindowState extends State<CompanyIncomeViewWindow> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
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
              const Expanded(child: CompanyIncomeContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyIncomeContent extends StatelessWidget {
  const CompanyIncomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    ReportController controller = Get.isRegistered<ReportController>()
        ? Get.find<ReportController>()
        : Get.put(ReportController());

    var dataList = controller.companyIncomeModel?.data ?? [];
    String totalBookingsCount = controller.companyIncomeModel?.totals?.totalBookings?.toString() ?? "${dataList.length}";
    String totalEarningSum = controller.companyIncomeModel?.totals?.totalEarnings != null
        ? controller.companyIncomeModel!.totals!.totalEarnings!.toStringAsFixed(2)
        : "0.00";
    String email = dataList.isNotEmpty ? (dataList.first.email ?? "-").toUpperCase() : "-";
    String mobile = dataList.isNotEmpty ? (dataList.first.mobile ?? "-") : "-";
    String telephone = dataList.isNotEmpty ? (dataList.first.telephone ?? "-") : "-";
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
                "COMPANY INCOME",
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
                      _infoText("MOBILE", mobile.toUpperCase()),
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
                      _infoText("EMAIL", email.toUpperCase()),
                      const SizedBox(height: 5),
                      _infoText("TELEPHONE", telephone.toUpperCase()),
                      const SizedBox(height: 5),
                      const Divider(thickness: 1, color: Colors.black26),
                      _infoText("TOTAL FARES", "£ $totalEarningSum"),
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
                1: FlexColumnWidth(1.5), // DATETIME
                2: FlexColumnWidth(2.5), // PICKUP
                3: FlexColumnWidth(2.5), // DROPOFF
                4: FlexColumnWidth(1),  // VEH
                5: FlexColumnWidth(1),  // DRV
                6: FlexColumnWidth(1),   // ACC
                7: FlexColumnWidth(1),   // FARE
                8: FlexColumnWidth(1),   // PC
                9: FlexColumnWidth(1), // WC
                10: FlexColumnWidth(1),// EDC
                11: FlexColumnWidth(1),// MG
                12: FlexColumnWidth(1),  // CC
                13: FlexColumnWidth(1),  // TOTAL
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: DynamicColors.primaryClr),
                  children: [
                    _tableCell("REF #", isHeader: true),
                    _tableCell("DATETIME", isHeader: true),
                    _tableCell("PICKUP", isHeader: true),
                    _tableCell("DROPOFF", isHeader: true),
                    _tableCell("VEHICLE", isHeader: true),
                    _tableCell("DRIVER", isHeader: true),
                    _tableCell("ACCOUNT", isHeader: true),
                    _tableCell("FARE", isHeader: true),
                    _tableCell("PC", isHeader: true),
                    _tableCell("WC", isHeader: true),
                    _tableCell("EDC", isHeader: true),
                    _tableCell("M&G", isHeader: true),
                    _tableCell("CC", isHeader: true),
                    _tableCell("TOTAL", isHeader: true),
                  ],
                ),

                // Data Rows
                ...dataList.map((item) {

                  String formattedDateTime = "-";
                  if (item.pickupDate != null) {
                    String date = DateFormat('dd-MM-yyyy').format(item.pickupDate!);
                    String time = item.pickupTime ?? "";
                    formattedDateTime = "$date\n$time".trim();
                  }

                  String currentFare = (item.fares == null || item.fares!.trim().isEmpty)
                      ? "£0.00"
                      : "£${item.fares}";

                  return TableRow(
                    children: [
                      _tableCell(item.referenceNumber ?? "-"),
                      _tableCell(formattedDateTime),
                      _tableCell((item.pickup ?? "-").toUpperCase()),
                      _tableCell((item.dropoff ?? "-").toUpperCase()),
                      _tableCell((item.vehicleType?.name ?? "-").toUpperCase()),
                      _tableCell((item.driver?.name ?? "-").toUpperCase()),
                      _tableCell((item.account?.name ?? "-").toUpperCase()),
                      _tableCell("£${item.fares?.toString() ?? ''}"),
                      _tableCell("£${item.parkingCharges?.toString() ?? ''}"),
                      _tableCell("£${item.waitingCharges?.toString() ?? ''}"),
                      _tableCell("£${item.extraDropCharges?.toString() ?? ''}"),
                      _tableCell("£${item.meetAndGreet?.toString() ?? ''}"),
                      _tableCell("£${item.congestionCharges?.toString() ?? ''}"),
                      _tableCell("£${item.totalCharges?.toString() ?? ''}"),
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

