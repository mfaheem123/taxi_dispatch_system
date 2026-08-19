import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/reports/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class EmployeeActivityReportWindow extends StatefulWidget {
  const EmployeeActivityReportWindow({super.key});

  @override
  State<EmployeeActivityReportWindow> createState() =>
      _EmployeeActivityReportWindowState();
}

class _EmployeeActivityReportWindowState
    extends State<EmployeeActivityReportWindow> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: isFullScreen ? Get.width : Get.width * 0.85,
          height: isFullScreen ? Get.width : Get.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            isFullScreen ? BorderRadius.zero : BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: DynamicColors.primaryClr,
                  borderRadius: isFullScreen
                      ? BorderRadius.zero
                      : const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ),
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                              isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                              size: 22),
                          onPressed: () =>
                              setState(() => isFullScreen = !isFullScreen),
                        ),
                        IconButton(
                          icon:
                          Icon(Icons.clear, color: Colors.white, size: 22),
                          onPressed: () => Get.back(),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(child: EmployeeActivityReportContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeActivityReportContent extends StatelessWidget {
  const EmployeeActivityReportContent({super.key});

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return "-";
    DateTime? parsed = DateTime.tryParse(dateTimeStr);
    if (parsed == null) return "-";

    String date =
        "${parsed.day.toString().padLeft(2, '0')}-${parsed.month.toString().padLeft(2, "0")}-${parsed.year.toString().substring(2)}";
    String time =
        "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}";
    return "$date $time";
  }

  String _formatWorkingHours(String? workingHoursStr) {
    if (workingHoursStr == null || workingHoursStr.isEmpty) return "-";
    double milliSeconds = double.tryParse(workingHoursStr) ?? 0;

    double seconds = milliSeconds / 1000;
    int hours = seconds ~/ 3600;
    int minutes = ((seconds % 3600) ~/ 60).toInt();

    if (hours > 0 && minutes > 0) {
      return "$hours hours $minutes minutes";
    } else if (hours > 0) {
      return "$hours hours";
    } else {
      return "$minutes minutes";
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();
    final reportData = controller.employeeShiftHistoryAll;
    final bool showTotalRow = reportData.isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding:
        const EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 30),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/logo.jpeg",
                height: 80,
                errorBuilder: (context, error, stackTrace) =>
                const FlutterLogo(size: 60),
              ),
            ),
            SizedBox(height: 40),
            const Center(
              child: Text("EMPLOYEE ACTIVITY",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
            SizedBox(height: 30),
            Table(
              border: TableBorder.all(
                  color: Colors.black.withOpacity(0.2), width: 1),
              columnWidths: const {
                0: FlexColumnWidth(1.2), // LoginDatetime
                1: FlexColumnWidth(1.2), // Logout Datetime
                2: FlexColumnWidth(1.0), // Bookings Created
                3: FlexColumnWidth(1.0), // Bookings Dispatched
                4: FlexColumnWidth(1.0), // Bookings Cancelled
                5: FlexColumnWidth(0.9), // Calls Answered
                6: FlexColumnWidth(1.1), // Working Hours
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: DynamicColors.primaryClr),
                  children: [
                    _buildTableCell("LOGIN DATETIME", isHeader: true),
                    _buildTableCell("LOGOUT DATETIME", isHeader: true),
                    _buildTableCell("BOOKINGS CREATED", isHeader: true),
                    _buildTableCell("BOOKINGS DISPATCHED", isHeader: true),
                    _buildTableCell("BOOKINGS CANCELLED", isHeader: true),
                    _buildTableCell("CALLS ANSWERED", isHeader: true),
                    _buildTableCell("WORKING HOURS", isHeader: true),
                  ],
                ),
                ...reportData.map((item) {
                  return TableRow(
                    children: [
                      _buildTableCell(_formatDateTime(item.loginDatetime)),
                      _buildTableCell(_formatDateTime(item.logoutDatetime)),
                      _buildTableCell((item.bookingsCreated ?? 0).toString()),
                      _buildTableCell(
                          (item.bookingsDispatched ?? 0).toString()),
                      _buildTableCell((item.bookingsCancelled ?? 0).toString()),
                      _buildTableCell((item.callsAnswered ?? 0).toString()),
                      _buildTableCell((_formatWorkingHours(item.workingHours).toUpperCase())),
                    ],
                  );
                }).toList(),
                if (showTotalRow)
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    children: [
                      _buildTableCell("TOTAL",
                          isHeader: true, customColor: Colors.black),
                      _buildTableCell(""),
                      _buildTableCell(controller.totalCreated.toString(),
                          isHeader: true, customColor: Colors.black),
                      _buildTableCell(controller.totalDispatched.toString(),
                          isHeader: true, customColor: Colors.black),
                      _buildTableCell(controller.totalCancelled.toString(),
                          isHeader: true, customColor: Colors.black),
                      _buildTableCell(controller.totalCalls.toString(),
                          isHeader: true, customColor: Colors.black),
                      _buildTableCell((controller.totalWorkingHours).toUpperCase(),
                          isHeader: true, customColor: Colors.black),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text,
      {bool isHeader = false, Color? customColor}) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 4),
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isHeader ? 12 : 11,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: customColor ?? (isHeader ? Colors.white : Colors.black),
          )),
    );
  }
}