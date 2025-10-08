import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:html' as html;
import '../../../routes/app_pages.dart';
import '../Controller/dashboard_controller.dart';

class MapViewWidget extends StatelessWidget {
  MapViewWidget({super.key});

  final controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive width calculation
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return SizedBox(
      width: width >= 1270 ? screenWidth / 3.6 : screenWidth / 2.1,
      height: screenHeight * 0.465,
      child: GetBuilder<DashboardController>(
        builder: (controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
              ],
            ),
            child: Stack(
              children: [
                /// MAP VIEW
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: controller.viaPoints.isNotEmpty
                            ? LatLng(controller.viaPoints.first.lat, controller.viaPoints.first.lng)
                            : LatLng(33.6844, 73.0479), // fallback center
                        initialZoom: 10,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),

                        /// ✅ POLYLINE LAYER (Route Path)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: controller.viaPoints
                                  .map((p) => LatLng(p.lat, p.lng))
                                  .toList(),
                              color: DynamicColors.primaryClr,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),


                        /// ✅ Optional: Marker Layer (if needed)
                        if (controller.viaPoints.isNotEmpty)
                          MarkerLayer(
                            markers: controller.viaPoints.map((v) {
                              return Marker(
                                width: 40,
                                height: 40,
                                point: LatLng(v.lat, v.lng),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 32,
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ),

                /// TAB TOGGLE
                Positioned(
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.secondaryClr),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RowButtonWidgetMap(
                            onTap: () {
                              controller.selectedTab.value = "MAPS";
                              controller.update();
                            },
                            color: controller.selectedTab.value == "MAPS"
                                ? DynamicColors.primaryClr
                                : DynamicColors.secondaryClr,
                            textClr: controller.selectedTab.value == "MAPS"
                                ? DynamicColors.secondaryClr
                                : DynamicColors.primaryClr,
                          ),
                        ),
                        Expanded(
                          child: RowButtonWidgetMap(
                            onTap: () {
                              controller.selectedTab.value = "PLOT";
                              controller.update();
                            },
                            color: controller.selectedTab.value != "MAPS"
                                ? DynamicColors.primaryClr
                                : DynamicColors.secondaryClr,
                            text: "PLOT",
                            textClr: controller.selectedTab.value != "MAPS"
                                ? DynamicColors.secondaryClr
                                : DynamicColors.primaryClr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// OPEN IN NEW TAB BUTTON
                Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: DynamicColors.secondaryClr,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.crop_square_outlined),
                        onPressed: () {
                          final newTabUrl = Uri.base.origin + '/#' + Routes.viewDriversMap;
                          html.window.open(
                            newTabUrl,
                            '_blank',
                            'width=1200,height=800,noopener,noreferrer',
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
