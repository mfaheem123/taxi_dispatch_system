


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/color.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../controller/driver_controller.dart';

class DriversListFeature extends StatelessWidget {
  DriversListFeature({super.key});

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());


  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverController>(
      builder: (controller) {
        return DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
            dataRowMinHeight: 48,
            dataRowMaxHeight: 56,
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
            dataTextStyle: TextStyle(
              fontSize: 10,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: DynamicColors.textClr.withOpacity(0.5))
            ),
            columns: [
              buildHeaderWithSearch(
                  widget: Checkbox(value: controller.selectAllDrivers.value,
                      onChanged: (v){
                        controller.selectAllDrivers.value = v!;
                        controller.update();
              })),
              buildHeaderWithSearch(title: "DRIVER"),
              buildHeaderWithSearch(title: "NAME"),
              buildHeaderWithSearch(title: "APP"),
            ],
            rows: List.generate(totalRows, (index) {
              bool isSelected = index == selectedRowIndex;
              return DataRow(
                cells: [
                  DataCell(Checkbox(value: controller.selectAllDrivers.value,
                      onChanged: (v){
                        controller.selectAllDrivers.value = v!;
                        controller.update();
                      })),
                  const DataCell(Text("#PHC VEHICLE")),
                  const DataCell(Text("PHC VEHICLE")),
                  const DataCell(Text("20/10/2025")),
                ],
              );
            })
        );
      }
    );
  }
}
