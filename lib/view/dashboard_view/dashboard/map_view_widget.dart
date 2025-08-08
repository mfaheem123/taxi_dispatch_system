


import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../component/textStyle.dart';
import '../Controller/dashboard_controller.dart';

class MapViewWidget extends StatelessWidget {
  MapViewWidget({super.key});

  final controller = Get.find<DashboardController>();


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double leftPadding = screenWidth < 768
        ? 20
        : screenWidth < 1024
        ? 40
        : 80;

    final double rightPadding = screenWidth < 768
        ? 20
        : screenWidth < 1024
        ? 30
        : 10;

    return SizedBox(
      width: screenWidth * 0.3,
      height: screenHeight * 0.465,
      child: GetBuilder<DashboardController>(
        builder: (controller) {
          return Container(
            // height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4))
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(26),
                    ),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(26),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                              33.6844, 73.0479),
                          initialZoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: [
                              'a',
                              'b',
                              'c'
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Toggle
                // Toggle (inline MapToggle code)
                Positioned(
                  // left: leftPadding,
                  // right: rightPadding,
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.secondaryClr)
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child:  RowButtonWidgetMap(
                              onTap: (){
                                controller
                                    .selectedTab.value = "MAPS";
                                controller.update();
                              },
                              color: controller
                                  .selectedTab.value == "MAPS"?DynamicColors.primaryClr:DynamicColors.secondaryClr,
                              textClr: controller
                                  .selectedTab.value == "MAPS"?DynamicColors.secondaryClr:DynamicColors.primaryClr,
                              //     .value = "MAPS",
                            ),
                        ),
                        Expanded(
                          child:  RowButtonWidgetMap(
                            onTap: (){
                              controller
                                  .selectedTab.value = "PLOT";
                              controller.update();
                            },
                            color: controller
                                .selectedTab.value != "MAPS"?DynamicColors.primaryClr:DynamicColors.secondaryClr,
                            text: "PLOT",

                            textClr: controller
                                .selectedTab.value != "MAPS"?DynamicColors.secondaryClr:DynamicColors.primaryClr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: DynamicColors.secondaryClr
                          ),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: (){

                              }, icon: Icon(Icons.crop_square_outlined))),
                    ))
                ///todo Duration Info
                /*Positioned(
                  top: 90,
                  left: 10,
                  child: Obx(() {
                    final controller = Get.find<
                        DashboardController>();
                    return Container(
                      padding:
                      const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFF3CC2C1)
                            .withOpacity(0.7),
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text("MILES:",
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 12,
                                  color:
                                  Colors.white)),
                          Text(controller.miles.value,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color:
                                  Colors.white)),
                          SizedBox(
                              height: screenHeight *
                                  0.0075),
                          const Text("DURATION:",
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 12,
                                  color:
                                  Colors.white)),
                          Text(
                              controller
                                  .duration.value,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color:
                                  Colors.white)),
                        ],
                      ),
                    );
                  }),
                ),*/
                ///todo Duration Info
              ],
            ),
          );
        },
      ),
    );
  }
}
