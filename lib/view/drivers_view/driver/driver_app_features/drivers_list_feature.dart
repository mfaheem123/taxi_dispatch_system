import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/color.dart';
import '../../../../component/responsive_datatable_widget.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../controller/driver_controller.dart';

class DriversListFeature extends StatelessWidget {
  final double availableWidth;
  DriversListFeature({super.key, required this.availableWidth});

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverController>(builder: (controller) {
      // return DataTable(
      //   headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
      //   dataRowMinHeight: 48,
      //   dataRowMaxHeight: 56,
      //   headingTextStyle: const TextStyle(
      //     fontWeight: FontWeight.w800,
      //     fontSize: 13,
      //   ),
      //   dataTextStyle: TextStyle(
      //     fontSize: 10,
      //   ),
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(4),
      //       border: Border.all(color: DynamicColors.textClr.withOpacity(0.5))),
      //   columns: [
      //     buildHeaderWithSearch(
      //         widget: Checkbox(
      //             value: controller.selectAllDrivers.value,
      //             onChanged: (v) {
      //               controller.selectAllDrivers.value = v!;
      //               controller.update();
      //             })),
      //     buildHeaderWithSearch(title: "DRIVER"),
      //     buildHeaderWithSearch(title: "NAME"),
      //     buildHeaderWithSearch(title: "APP"),
      //   ],
      //   rows: controller.driverAll.map((driver) {
      //     // List.generate(totalRows, (index) {
      //     //   bool isSelected = index == selectedRowIndex;
      //     return DataRow(
      //       cells: [
      //         DataCell(Checkbox(
      //             value: controller.selectAllDrivers.value,
      //             onChanged: (v) {
      //               controller.selectAllDrivers.value = v!;
      //               controller.update();
      //             })),
      //         DataCell(Padding(
      //             padding: const EdgeInsets.only(left: 20),
      //             child: Text(driver.username ?? "-"))),
      //         DataCell(Padding(
      //             padding: const EdgeInsetsGeometry.only(left: 20),
      //             child: Text(driver.name ?? "-"))),
      //         DataCell(Padding(
      //             padding: const EdgeInsetsGeometry.only(left: 20),
      //             child: Text(driver.version ?? "-"))),
      //       ],
      //     );
      //   }).toList(),
      // );
      return ResponsiveDataTableWidget(
        totalWidth: availableWidth,
        columnConfigs: [
          TableColumnConfig(
            title: "CHECKBOX",
            sizeType: ColumnSizeType.fixed,
            fixedWidth: 35.0,
            removeSearching: true,
            customHeader: Checkbox(
              value: controller.selectAllDrivers.value,
              onChanged: (v) {
                controller.selectAllDrivers.value = v!;
                controller.update();
              },
            ),
          ),
          TableColumnConfig(
            title: "DRIVER",
            sizeType: ColumnSizeType.small,
          ),
          TableColumnConfig(
            title: "NAME",
            sizeType: ColumnSizeType.medium,
          ),
          TableColumnConfig(
            title: "APP",
            sizeType: ColumnSizeType.small,
          ),
        ],
        items: controller.driverAll,
        rowBuilder: (item, widths) {
          final driver = item;
          return [
            // 1. Checkbox Widget
            SizedBox(
              width: widths["CHECKBOX"],
              child: Checkbox(
                value: controller.selectAllDrivers.value,
                onChanged: (v) {
                  controller.selectAllDrivers.value = v!;
                  controller.update();
                },
              ),
            ),
            driver.username ?? "-",
            driver.name ?? "-",
            driver.version ?? "-",
          ];
        },
      );
    });
  }
}
