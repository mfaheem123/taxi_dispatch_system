import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:dashboard_new1/view/dashboard_view/models/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'component/color.dart';
import 'component/datatable_widget.dart';
import 'component/dropdown_button.dart';
import 'component/textStyle.dart';
import 'component/text_widget.dart';

class MultiVehiclePage extends StatefulWidget {
  MultiVehiclePage({super.key});

  @override
  State<MultiVehiclePage> createState() => _MultiVehiclePageState();
}

class _MultiVehiclePageState extends State<MultiVehiclePage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 80),
                child: Container(
                  width: fieldWidth * 1.3,
                  decoration: BoxDecoration(
                      color: DynamicColors.whiteClr,
                      border: Border.all(
                        color: DynamicColors.secondaryClr,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: fieldWidth * 1.5,
                          height: kToolbarHeight,
                          color: DynamicColors.secondaryClr,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text("MULTI VEHICLE",
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.black)),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Icon(
                                            Icons.cancel_presentation_sharp))
                                  ],
                                )),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(
                            12.0), // Andar ki spacing ke liye
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Multi Vehicle",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width: fieldWidth,
                                        height: 35,
                                        child: DropdownButtonFormField<
                                            DashboardVehicleTypeObject>(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            isDense: true,
                                          ),
                                          value: controller
                                              .selectMultiVehicleValue,
                                          items: controller
                                              .dashboardAllData!.vehicleTypes!
                                              .map((vehicle) =>
                                                  DropdownMenuItem<
                                                      DashboardVehicleTypeObject>(
                                                    value: vehicle,
                                                    child: Text(
                                                      vehicle.name ?? "",
                                                      style:
                                                          mozillaTextRegularText(
                                                        fontSize: 12,
                                                        color: DynamicColors
                                                            .textClr,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (v) {
                                            controller.selectMultiVehicleValue =
                                                v;
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 35,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: DynamicColors.primaryClr,
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.multiVehicleList.add(
                                          controller.selectMultiVehicleValue!);
                                      controller.selectMultiVehicleValue = null;
                                      controller.update();
                                    },
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                        color: DynamicColors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                                // width: fieldWidth * 1.3,
                                width: double.infinity,
                                child: DatatableWidget(columns: [
                                  buildHeaderWithSearch(
                                      title: "Vehicle", removeSearching: true),
                                  buildHeaderWithSearch(
                                      title: "Action", removeSearching: true),
                                ], rows: [
                                  // Existing extensions
                                  ...controller.multiVehicleList.map((object) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(object.name
                                            .toString()
                                            .toUpperCase())),
                                        DataCell(
                                          // OutlinedButton(
                                          //   style: OutlinedButton.styleFrom(
                                          //     padding: EdgeInsets.zero,
                                          //     minimumSize: Size.zero,
                                          //     tapTargetSize:
                                          //         MaterialTapTargetSize.shrinkWrap,
                                          //     side: BorderSide.none,
                                          //   ),
                                          //   onPressed: () {
                                          //     controller.multiVehicleList
                                          //         .remove(object);
                                          //     controller.update();
                                          //   },
                                          //   child: Icon(
                                          //     Icons.delete_forever,
                                          //     color: DynamicColors.redClr,
                                          //   ),
                                          // ),
                                          IconButton(
                                            onPressed: () {
                                              controller.multiVehicleList
                                                  .remove(object);
                                              controller.update();
                                            },
                                            icon: Icon(Icons.delete_forever,
                                                color: DynamicColors.redClr),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      });
    });
  }
}
