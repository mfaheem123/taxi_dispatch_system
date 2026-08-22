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
    // return GetBuilder<DashboardController>(builder: (controller) {
    //   return LayoutBuilder(builder: (context, constraints) {
    //     final double maxWidth = constraints.maxWidth;
    //     final bool isMobile = maxWidth < 600;
    //     final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
    //
    //     // Instead of fixed width, we calculate flexible field widths
    //     final double fieldWidth = isMobile
    //         ? maxWidth // full width
    //         : isTablet
    //             ? maxWidth / 2
    //             : maxWidth / 4;
    return GetBuilder<DashboardController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        final bool isHighRes = maxWidth > 1080;

        // Responsive width calculation matching other alert/form components
        double containerWidth = isMobile
            ? maxWidth - 20
            : isTablet
            ? maxWidth * 0.7
            : 550.0;

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              Padding(padding: EdgeInsets.symmetric(
                vertical: 30, horizontal: isMobile ? 10 : 40),
                child: Container(
                  width: containerWidth,
                  decoration: BoxDecoration(
                      color: DynamicColors.whiteClr,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: DynamicColors.secondaryClr,
                      ),
                      boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                      ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: double.infinity,
                          height: kToolbarHeight,
                          decoration: BoxDecoration(
                            color: DynamicColors.secondaryClr,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                                  children: [
                                    Text("MULTI VEHICLE",
                                        style: titleDesign()),
                                    Spacer(),
                                    Focus(
                                      onKeyEvent: (node, event) => KeyEventResult.ignored,
                                      child: Builder(
                                        builder: (context) {
                                          final bool isFocused = Focus.of(context).hasFocus;
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: isFocused
                                                  ? Colors.grey.withOpacity(0.4)
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: IconButton(
                                              onPressed: () => Get.back(),
                                              icon: const Icon(
                                                Icons.cancel_presentation_sharp,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                            ),
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ADD VEHICLE TYPE",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        // width: fieldWidth,
                                        height: 35,
                                        child: DropdownButtonFormField<
                                            DashboardVehicleTypeObject>(
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              borderSide: const BorderSide(color: Colors.blue),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              borderSide: const BorderSide(color: Colors.blue),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                                            ),
                                          ),
                                          value: controller.selectMultiVehicleValue,
                                          items: controller.dashboardAllData!.vehicleTypes!
                                              .map((vehicle) =>
                                                  DropdownMenuItem<DashboardVehicleTypeObject>(
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
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 33,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: DynamicColors.primaryClr,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                        color: DynamicColors.whiteClr,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                                // width: fieldWidth * 1.3,
                                width: double.infinity,
                                child: DatatableWidget(
                                    columns: [
                                  buildHeaderWithSearch(
                                      title: "Vehicle", removeSearching: true),
                                  buildHeaderWithSearch(
                                      title: "Action", removeSearching: true),
                                ], rows: [
                                  // Existing extensions
                                  ...controller.multiVehicleList.map((object) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text(object.name
                                            .toString()
                                            .toUpperCase()))),
                                        DataCell(Center(child:
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
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              controller.multiVehicleList
                                                  .remove(object);
                                              controller.update();
                                            },
                                            icon: Icon(Icons.delete_forever,
                                                color: DynamicColors.redClr,
                                              size: 20,
                                            ),
                                          )),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ]),
                            ),
                        )],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      });
    });
  }
}
