import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../component/datatable_widget.dart';
import '../view/drivers_view/controller/driver_controller.dart';

class DriverCommissionAlt {
  static void show({required int id}) async {
    final controller = Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : Get.put(DriverController());

    // var transactions = controller.getDriverCommissionDetails(id);

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: Get.width * 0.95,
            // width: 500,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DRIVER COMMISSION OF DRIVER (${controller.driverCommissionAlert!.count})",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child:
                          const Icon(Icons.close, size: 20, color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(height: 30),
                SingleChildScrollView(
                  // scrollDirection: Axis.horizontal,
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: Get.width,
                    child: DatatableWidget(
                      columns: [
                        DataColumn(
                            label: Text("    TRANSACTION #",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        DataColumn(
                            label: Text("    TRANSACTION DATE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        DataColumn(
                            label: Text("    DRIVER",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        DataColumn(
                            label: Text("    JOB TOTAL",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        DataColumn(
                            label: Text("    COMMISSION TOTAL",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        DataColumn(
                            label: Text("    PREVIOUS BALANCE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        DataColumn(
                            label: Text("    CURRENT BALANCE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        DataColumn(
                            label: Text("    ACTIONS",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                      ],
                      totalRow: controller
                          .driverCommissionAlert!.driverCommissions?.length,
                      rows: controller.driverCommissionAlert!.driverCommissions
                          ?.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Center( child:Text(item.transactionNumber ?? "-"))),
                            DataCell(Center( child:Text(item.transactionDate
                                    ?.toIso8601String()
                                    .split('T')[0] ??
                                "-"))),
                            DataCell(Center(
                                child: Text(item.driver?.username ?? "-"))),
                            DataCell(
                                Center(child: Text("£${item.jobsTotal ?? "0"}"))),
                            DataCell(Center(
                                child: Text("£${item.commissionTotal ?? "0"}"))),
                            DataCell(
                                Center(child: Text("£${item.oldBalance ?? "0"}"))),
                            DataCell(Center(
                                child: Text("£${item.currentBalance ?? "0"}"))),
                            DataCell(Center(
                                child: Row(
                              children: [
                                Icon(Icons.edit,
                                    size: 18, color: Color(0xFF43489A)),
                                SizedBox(width: 8),
                                Icon(Icons.delete, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Icon(Icons.picture_as_pdf,
                                    size: 18, color: Colors.blue),
                                SizedBox(width: 8),
                                Icon(Icons.mail,
                                    size: 18, color: Colors.black87),
                              ],
                            ))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
