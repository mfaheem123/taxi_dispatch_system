import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/driver_controller.dart';

import '../../../../component/color.dart';
import '../../../../component/textStyle.dart';


class AuditReportScreen extends StatefulWidget {
  const AuditReportScreen({Key? key}) : super(key: key);

  @override
  State<AuditReportScreen> createState() => _AuditReportScreenState();
}

class _AuditReportScreenState extends State<AuditReportScreen> {
  String driverId = '';
  final DriverController driverController = Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    driverId = Get.parameters['id'] ?? '';
    if (driverId.isNotEmpty) {
      driverController.fetchAuditDriverData(driverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (driverController.isAuditDriverLoading.value) {
          return Center(child: CircularProgressIndicator(color: DynamicColors.primaryClr));
        }
        return _buildBody();
      }),
    );
  }

  Widget _buildBody() {
    var driverData = driverController.auditDriverData;
    String name = (driverData?['name']?.toString() ?? "N/A").toUpperCase();
    String username = driverData?['username']?.toString() ?? "N/A";
    String mobile = driverData?['mobile']?.toString() ?? "N/A";
    String email = (driverData?['email']?.toString() ?? "N/A").toUpperCase();
    String telephone = driverData?['telephone']?.toString() ?? "N/A";

    return SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Replace with actual logo if available
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: DynamicColors.primaryClr, // placeholder
                      ),
                      child: const Center(
                        child: Text(
                          "Nexus Tech",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "DRIVER AUDIT REPORT",
                      style: mozillaTextSemiBoldText(
                          fontSize: 24, color: DynamicColors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email,
                      style: mozillaTextRegularText(
                          fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      telephone,
                      style: mozillaTextRegularText(
                          fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.primaryClr),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildInfoText("DRIVER: ", name),
                          const SizedBox(width: 30),
                          _buildInfoText("USERNAME: ", username),
                          const SizedBox(width: 30),
                          _buildInfoText("MOBILE: ", mobile),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Audit Logs Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "AUDIT LOGS",
                      style: mozillaTextSemiBoldText(
                          fontSize: 16, color: DynamicColors.black),
                    ),
                    const SizedBox(height: 20),
                    // Table Header
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          _buildTableHeader("EMPLOYEE", flex: 2),
                          _buildTableHeader("OPERATION", flex: 2),
                          _buildTableHeader("PREVIOUS STATE", flex: 4),
                          _buildTableHeader("NEW STATE", flex: 4),
                          _buildTableHeader("DATE", flex: 2),
                          _buildTableHeader("TIME", flex: 2),
                        ],
                      ),
                    ),
                    // Table Rows (Mock Data based on screenshot)
                    _buildTableRow(
                      employee: name,
                      operation: "UPDATE",
                      prevState: "MOBILE: -",
                      newState: "MOBILE: $mobile",
                      date: "02-08-25",
                      time: "19:15...",
                      isNewStateGreen: true,
                    ),
                    const Divider(height: 1),
                    _buildTableRow(
                      employee: name,
                      operation: "UPDATE",
                      prevState: "RENT PAID: -",
                      newState: "RENT PAID: TRUE",
                      date: "23-04-25",
                      time: "23:42...",
                      isNewStateGreen: true,
                    ),
                    const Divider(height: 1),
                    _buildTableRow(
                      employee: name,
                      operation: "CREATE",
                      prevState: "",
                      newState: "",
                      date: "23-04-25",
                      time: "23:39...",
                      isNewStateGreen: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  }

  Widget _buildInfoText(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: mozillaTextSemiBoldText(
                fontSize: 14, color: DynamicColors.primaryClr),
          ),
          TextSpan(
            text: value,
            style: mozillaTextSemiBoldText(
                fontSize: 14, color: DynamicColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          style: mozillaTextSemiBoldText(
              fontSize: 12, color: DynamicColors.black),
        ),
      ),
    );
  }

  Widget _buildTableRow({
    required String employee,
    required String operation,
    required String prevState,
    required String newState,
    required String date,
    required String time,
    required bool isNewStateGreen,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                employee,
                style: mozillaTextSemiBoldText(
                    fontSize: 12, color: DynamicColors.black),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  operation,
                  style: mozillaTextRegularText(
                      fontSize: 12, color: DynamicColors.black),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                prevState,
                style: mozillaTextRegularText(
                    fontSize: 12, color: Colors.grey[700]!),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: isNewStateGreen ? DynamicColors.primaryClr.withOpacity(0.1) : Colors.transparent,
              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
              child: Text(
                newState,
                style: mozillaTextRegularText(
                    fontSize: 12,
                    color: isNewStateGreen ? DynamicColors.primaryClr : Colors.grey[700]!),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                date,
                style: mozillaTextSemiBoldText(
                    fontSize: 12, color: DynamicColors.black),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                time,
                style: mozillaTextRegularText(
                    fontSize: 12, color: DynamicColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
