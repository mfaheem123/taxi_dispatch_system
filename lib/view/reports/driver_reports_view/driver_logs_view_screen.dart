import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../component/color.dart';
import '../../../../component/textStyle.dart';
import '../controller/report_controller.dart';

class DriverLogsViewWindow extends StatefulWidget {
  const DriverLogsViewWindow({super.key});

  @override
  _DriverLogsViewWindow createState() => _DriverLogsViewWindow();
}

class _DriverLogsViewWindow extends State<DriverLogsViewWindow> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isFullScreen ? Get.width : Get.width * 0.90,
          height: isFullScreen ? Get.height : Get.height * 0.90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isFullScreen ? BorderRadius.zero : BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)],
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
              Expanded(child: DriverLogsReportContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverLogsReportContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();
    // Controller Data
    final bookings = controller.driverLogsData?.bookings ?? [];
    final String driverName = (controller.selectDriverObject?.name)?.toUpperCase() ?? "N/A";
    final String driverEmail = (controller.selectDriverObject?.email)?.toUpperCase() ?? "N/A";
    final String driverMobile = controller.selectDriverObject?.mobile ?? "N/A";
    final String driverPhone = controller.selectDriverObject?.telephone ?? "N/A";
    final int totalBookings = bookings.length;
    final double totalEarnings = bookings.fold(0.0, (sum, item) {
      return sum + (double.tryParse(item.fares.toString()) ?? 0.0);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo.jpeg",
                    height: 80,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.directions_car, size: 50),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "DRIVER LOG",
                    style: mozillaTextSemiBoldText(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("EMAIL: ", driverEmail),
                    const SizedBox(height: 8),
                    _infoRow("MOBILE: ", driverMobile),
                    const SizedBox(height: 8),
                    _infoRow("TELEPHONE: ", driverPhone),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "DRIVER ($driverName)",
                      style: mozillaTextSemiBoldText(fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    _summaryRow("TOTAL BOOKINGS: ", "$totalBookings"),
                    const SizedBox(height: 8),
                    _summaryRow("TOTAL EARNINGS: ", "£${totalEarnings.toStringAsFixed(2)}"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2), // Ref #
                1: FlexColumnWidth(1.8), // DateTime
                2: FlexColumnWidth(1.5), // Vehicle
                3: FlexColumnWidth(2.5), // Pickup
                4: FlexColumnWidth(2.5), // Dropoff
                5: FlexColumnWidth(1),   // Fare
              },
              border: TableBorder.all(
                color: Colors.black.withOpacity(0.2),
                width: 1,
              ),
              children: [
                // Table Header
                TableRow(
                  decoration: BoxDecoration(color: DynamicColors.primaryClr),
                  children: [
                    _buildTableCell("REF #", isHeader: true),
                    _buildTableCell("DATETIME", isHeader: true),
                    _buildTableCell("VEHICLE", isHeader: true),
                    _buildTableCell("PICKUP", isHeader: true),
                    _buildTableCell("DROPOFF", isHeader: true),
                    _buildTableCell("FARES", isHeader: true),
                  ],
                ),
                // Table Data
                ...bookings.map((booking) {
                  return TableRow(
                    children: [
                      _buildTableCell(booking.referenceNumber ?? "-"),
                      _buildTableCell("${booking.pickupDate}\n${booking.pickupTime}"),
                      _buildTableCell(booking.vehicleType?.name?.toUpperCase() ?? "-"),
                      _buildTableCell((booking.pickup ?? "-").toUpperCase(), textAlign: TextAlign.left),
                      _buildTableCell((booking.dropoff ?? "-").toUpperCase(), textAlign: TextAlign.left),
                      _buildTableCell("£${booking.fares ?? "0.00"}"),
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

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.grey.shade700)),
        Text(value, style: mozillaTextRegularText(fontSize: 14)),
      ],
    );
  }
  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.grey.shade600)),
        Text(
          value,
          style: mozillaTextRegularText(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, TextAlign textAlign = TextAlign.center, FontWeight? fontWeight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: isHeader ? 14 : 12,
          fontWeight: isHeader ? FontWeight.bold : (fontWeight ?? FontWeight.normal),
          color: isHeader ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}