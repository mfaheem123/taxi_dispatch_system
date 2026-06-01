import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../component/color.dart'; // Apna path check karlein
import '../../../../component/textStyle.dart';
import '../controller/report_controller.dart';

class DriverLoginViewWindow extends StatefulWidget {
  @override
  _DriverLoginViewWindow createState() => _DriverLoginViewWindow();
}

class _DriverLoginViewWindow extends State<DriverLoginViewWindow> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isFullScreen ? Get.width : Get.width * 0.85,
          height: isFullScreen ? Get.height : Get.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isFullScreen ? BorderRadius.zero : BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: DynamicColors.primaryClr,
                  borderRadius: isFullScreen ? BorderRadius.zero : const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white, size: 22),
                          onPressed: () => setState(() => isFullScreen = !isFullScreen),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 22),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(child: DriverLoginReportContent()),
            ],
          ),
        ),
      ),
    );
  }
}
class DriverLoginReportContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();
    final reportData = controller.driverLoginReportListModel?.driverShiftHistories ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/logo.jpeg",
                height: 80,
                errorBuilder: (context, error, stackTrace) => const FlutterLogo(size: 60),
              ),
            ),

            const SizedBox(height: 40),
            Center(
              child: Text(
                "DRIVER LOGIN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 30),
            Table(
              border: TableBorder.all(
                color: Colors.black.withOpacity(0.2),
                width: 1,
              ),
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: DynamicColors.primaryClr),
                  children: [
                    _buildTableCell("DRIVER", isHeader: true),
                    _buildTableCell("BOOKINGS", isHeader: true),
                    _buildTableCell("LOGIN DATE", isHeader: true),
                    _buildTableCell("LOGIN TIME", isHeader: true),
                    _buildTableCell("LOGOUT DATE", isHeader: true),
                    _buildTableCell("LOGOUT TIME", isHeader: true),
                  ],
                ),
                // Data Rows
                ...reportData.map((item) {
                  return TableRow(
                    children: [
                      _buildTableCell((item.driver?.username ?? "").toUpperCase()),
                      _buildTableCell(item.booking?.length.toString() ?? "0"),
                      _buildTableCell(item.loginDate != null
                          ? DateFormat('dd-MM-yyyy').format(item.loginDate!)
                          : "-"),
                      _buildTableCell(item.loginTime ?? "-"),
                      _buildTableCell(item.logoutDate != null
                          ? DateFormat('dd-MM-yyyy').format(item.logoutDate!)
                          : "-"),
                      _buildTableCell(item.logoutTime ?? "-"),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isHeader ? 14 : 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}