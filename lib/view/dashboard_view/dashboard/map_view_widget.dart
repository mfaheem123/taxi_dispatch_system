import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:html' as html;
import '../../../routes/app_pages.dart';
import '../Controller/dashboard_controller.dart';

class MapViewWidget extends StatefulWidget {
  MapViewWidget({super.key});

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  final controller = Get.find<DashboardController>();



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.mapController = MapController(); // ✅ Initialize here
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<LatLng> polylinePoints = controller.polylinePoints.isNotEmpty?controller.polylinePointsCoordinate: [
      LatLng(50.85496238858419, 0.561166687845978),
    ];

    // Responsive width calculation
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    if (polylinePoints.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
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
             mapController: controller.mapController,
             options: MapOptions(
               initialCenter: polylinePoints[0],
                 initialZoom: 12.5,
               onMapReady: () {
                 // ✅ This runs when map is fully ready
                 if (controller.polylinePointsCoordinate.isNotEmpty && controller.polylinePointsCoordinate.length >=2) {
                   final bounds = LatLngBounds.fromPoints(controller.polylinePointsCoordinate);
                   controller.mapController.fitCamera(
                     CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(2)),
                   );
                 }
               },
             ),
             children: [
               // 🗺️ Map background tiles
               TileLayer(
                 urlTemplate:
                 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                 subdomains: const ['a', 'b', 'c'],
               ),

               // 📍 Marker layer
               MarkerLayer(
                 markers: [
                   for (int i = 0; i < polylinePoints.length; i++)
                     Marker(
                       point: polylinePoints[i],
                       width: 30,
                       height: 40,
                       child: Icon(
                         i == 0
                             ? Icons.location_pin // start marker
                             : i == polylinePoints.length - 1
                             ? Icons.flag // end marker
                             : Icons.circle, // middle points
                         color: i == 0
                             ? DynamicColors.primaryClr
                             : i == polylinePoints.length - 1
                             ? Colors.red
                             : Colors.blue,
                         size: 40,
                       ),
                     ),
                 ],
               ),

               // ➿ Polyline layer (route)
               PolylineLayer(
                 polylines: [
                   Polyline(
                     points: polylinePoints,
                     color: Colors.blue,
                     strokeWidth: 2.0,
                   ),
                 ],
               ),
               /// 🕓 Show loader when no polyline
               // if (controller.polylinePoints.isEmpty)
               //   const Center(child: CircularProgressIndicator()),
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
