import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

void showFutureBookingAlert() {
  Get.dialog(
    FutureBookingAlert(),
    barrierColor: Colors.black54,
  );
}

class FutureBookingAlert extends StatefulWidget {
  const FutureBookingAlert({super.key});

  @override
  State<FutureBookingAlert> createState() => _FutureBookingAlertState();
}

class _FutureBookingAlertState extends State<FutureBookingAlert> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 650,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsetsGeometry.all(16.0),
              child: Row(
                children: [
                  Text("DISPATCH FB ()",
                    style: mozillaTextSemiBoldText(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 22, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(padding: EdgeInsetsGeometry.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsetsGeometry.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsetsGeometry.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.person_outline, color: Colors.black54),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SELECT DRIVER TO DISPATCH",
                            style: mozillaTextSemiBoldText(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("FUTURE BOOKING DISPATCH LIST",
                              style: mozillaTextRegularText(
                                fontSize: 13, color: Colors.grey
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        headingRowHeight: 45,
                        columnSpacing: 45,
                        headingRowColor: WidgetStateProperty.all(Colors.grey
                            .shade50),
                        border: TableBorder.all(color: Colors.grey.shade300,
                            width: 1),
                        columns: [
                          _buildDataColumn("ID"),
                          _buildDataColumn("DRIVER"),
                          _buildDataColumn("ATTRIBUTES"),
                          _buildDataColumn("STATUS"),
                          _buildDataColumn("ACTION"),
                        ],
                         rows: [
                           _buildStaticRow("101", "John Doe", "Saloon, AC", "Available"),
                           _buildStaticRow("102", "Ali Khan", "SUV, 7 Seater", "Available"),
                           _buildStaticRow("103", "David Smith", "Executive", "Busy"),
                         ],
                    ),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),

    );
  }
  DataRow _buildStaticRow(String id, String driver, String attr, String status) {
    return DataRow(cells: [
      DataCell(Text(id)),
      DataCell(Text(driver, style: const TextStyle(fontWeight: FontWeight.w600))),
      DataCell(Text(attr)),
      DataCell(
          Text(status,
              style: TextStyle(color: status == "Available" ? Colors.green : Colors.red, fontWeight: FontWeight.bold)
          )
      ),
      DataCell(
        ElevatedButton(
          onPressed: () {
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: DynamicColors.primaryClr,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: const Text("DISPATCH", style: TextStyle(fontSize: 11)),
        ),
      ),
    ]);
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(label, style: mozillaTextSemiBoldText(
          fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
