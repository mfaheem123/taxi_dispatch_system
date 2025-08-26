

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/driver_controller.dart';

class DriverListScreen extends StatelessWidget {
  DriverListScreen({super.key});

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: GetBuilder<DriverController>(
          builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(AppText.drivers+" (10)",
                    style: mozillaTextSemiBoldText(
                      fontWeight: FontWeight.w800,
                      fontSize: 17
                    ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                        value: controller.activeDrivers.value,
                        onChanged: (v){
                          controller.activeDrivers.value = v!;
                          controller.update();
                        }),
                    Text(AppText.inactive,
                      style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        color: DynamicColors.redClr
                      ),
                    ),

                    SizedBox(
                      width: 60,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: DynamicColors.primaryClr,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: IconButton(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                          onPressed: (){

                          }, icon: Icon(Icons.refresh,
                      color: DynamicColors.whiteClr,
                        size: 25,
                      )),
                    )
                  ],
                ),
                DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 56,
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  columns: const [
                    DataColumn(label: Text("USERNAME")),
                    DataColumn(label: Text("NAME")),
                    DataColumn(label: Text("VEHICLE #")),
                    DataColumn(label: Text("VEHICLE")),
                    DataColumn(label: Text("VEHICLE\nEXPIRY")),
                    DataColumn(label: Text("DRIVER\nEXPIRY")),
                    DataColumn(label: Text("MOT\nEXPIRY")),
                    DataColumn(label: Text("MOT2\nEXPIRY")),
                    DataColumn(label: Text("INSURANCE\nEXPIRY")),
                    DataColumn(label: Text("LICENSE\nEXPIRY")),
                    DataColumn(label: Text("MOBILE #")),
                    DataColumn(label: Text("SUBSIDIARY")),
                    DataColumn(label: Text("ACTIONS")),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text("20/10/2025")),
                        const DataCell(Text("#PHC VEHICLE")),
                        const DataCell(Text("PHC VEHICLE")),
                        const DataCell(Text("20/10/2025")),
                        const DataCell(Text("#PHC VEHICLE")),
                        const DataCell(Text("PHC VEHICLE")),
                        const DataCell(Text("20/10/2025")),
                        const DataCell(Text("#PHC VEHICLE")),
                        const DataCell(Text("PHC VEHICLE")),
                        const DataCell(Text("20/10/2025")),
                        const DataCell(Text("#PHC VEHICLE")),
                        const DataCell(Text("PHC VEHICLE")),
                        DataCell(
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.transparent,), // border color & thickness
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Icon(Icons.search),
                                Text("|"),
                                Icon(Icons.delete_forever),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("20/10/2025")),
                        const DataCell(Text("#PHC VEHICLE")),
                        const DataCell(Text("PHC VEHICLE")),
                        const DataCell(Text("20/10/2025")),
                        const DataCell(Text("#PHC VEHICLE")),
                        const DataCell(Text("PHC VEHICLE")),
                        const DataCell(Text("20/10/2025")),
                        const DataCell(Text("#PHC VEHICLE")),
                        const DataCell(Text("PHC VEHICLE")),
                        const DataCell(Text("20/10/2025")),
                        const DataCell(Text("#PHC VEHICLE")),
                        const DataCell(Text("PHC VEHICLE")),
                        DataCell(
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.transparent,), // border color & thickness
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Icon(Icons.search),
                                Text("|"),
                                Icon(Icons.delete_forever),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        }
      ), // ensures NumericFocusOrder works globally
    );
  }
}
