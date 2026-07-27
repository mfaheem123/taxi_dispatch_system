// import 'dart:math';
//
// import 'package:dashboard_new1/component/color.dart';
// import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import 'dart:html' as html;
// import '../../../routes/app_pages.dart';
// import '../Controller/dashboard_controller.dart';
//
// class MapViewWidget extends StatefulWidget {
//   MapViewWidget({super.key, this.createBooking = false});
//   bool createBooking = false;
//
//   @override
//   State<MapViewWidget> createState() => _MapViewWidgetState();
// }
//
// class _MapViewWidgetState extends State<MapViewWidget> {
//   final controller = Get.find<DashboardController>();
//
//
//
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   final List<Polygon> zonePolygons = [];
//   poligonFun()async{
//     for (var model in controller.seeZoneOnMapModel!.zones![0].vertices!) {
//       if (model.latitude != null && model.longitude!=null) {
//         zonePolygons.add(
//           Polygon(
//             points: controller.seeZoneOnMapModel!.zones![0].vertices!
//                 .map((v) => LatLng(v.latitude!, v.longitude!))
//                 .toList(),
//             color: DynamicColors.primaryClr.withOpacity(0.2),
//             borderColor: DynamicColors.primaryClr,
//             borderStrokeWidth: 3.0,
//             label:controller.seeZoneOnMapModel!.zones![0].name?? '',
//           ),
//         );
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     final List<LatLng> polylinePoints = controller.polylinePoints.isNotEmpty?controller.polylinePointsCoordinate: [
//       LatLng(50.85496238858419, 0.561166687845978),
//     ];
//
//     // Responsive width calculation
//     double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
//         WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
//     // if (polylinePoints.isEmpty) {
//     //   return Center(child: CircularProgressIndicator());
//     // }
//
//     return SizedBox(
//       width: widget.createBooking == true?Get.width: width >= 1270 ? screenWidth / 2.95 : screenWidth / 1.2,
//       height: widget.createBooking == true?Get.height / 1.4:
//       screenHeight >=940? screenHeight * 0.51:
//       screenHeight * 0.80, /// yaha per aghar create booking per map access karte hu tu map ka height (Get.height / 1.4) our aghar laptop se bara screen hogha tu os ka height (screenHeight >=940? screenHeight * 0.51:) our aghar lap ka screen hogha tu os ka height (screenHeight * 0.80)
//       child: GetBuilder<DashboardController>(
//         initState: (v){
//           poligonFun();
//         },
//         builder: (controller) {
//
//           return Container(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
//               ],
//             ),
//             child: Stack(
//               children: [
//                 /// MAP VIEW
//             Positioned.fill(
//             child: ClipRRect(
//             // borderRadius: BorderRadius.circular(26),
//            child: FlutterMap(
//
//               mapController: controller.mapController,
//               options:MapOptions(
//                 initialCenter: polylinePoints.isEmpty ?LatLng(50.5, 30.51):
//                 polylinePoints.first,
//                 initialZoom: 13.0,
//                 interactionOptions: const InteractionOptions(
//                   flags: InteractiveFlag.all, // drag + zoom + tap + scroll
//                   enableMultiFingerGestureRace: true,
//                 ),
//                 onMapReady: () {
//                   if (polylinePoints.length >= 2) {
//                     final bounds = LatLngBounds.fromPoints(polylinePoints);
//                     controller.mapController.fitCamera(
//                       CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
//                     );
//                   }
//                 },
//               ),
//               children: [
//                 // 🗺️ Background
//                 TileLayer(
//                   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   subdomains: const ['a', 'b', 'c'],
//                 ),
//
//                 // 🧭 Route polyline
//                 polylinePoints.length>1? PolylineLayer(
//                   polylines: [
//                     Polyline(
//                       points: polylinePoints,
//                       color: Colors.blue,
//                       strokeWidth: 4.0,
//                     ),
//                   ],
//                 ):SizedBox.shrink(),
//                 PolygonLayer(
//                   polygons: zonePolygons, // ✅ correct here
//                 ),
//                 // PolylineLayer(polylines: controller.polylines),
//                 MarkerLayer(markers: controller.markers),
//               ],
//             ),
//
//           ),
//           ),
//
//           /// TAB TOGGLE
//                 widget.createBooking == true?SizedBox.shrink():
//                 Positioned(
//                   child: Container(
//                     width: Get.width,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: DynamicColors.secondaryClr),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: RowButtonWidgetMap(
//                                 onTap: () {
//                                   controller.selectedTab.value = "MAPS";
//                                   controller.update();
//                                 },
//                                 color: controller.selectedTab.value == "MAPS"
//                                     ? DynamicColors.primaryClr
//                                     : DynamicColors.secondaryClr,
//                                 textClr: controller.selectedTab.value == "MAPS"
//                                     ? DynamicColors.secondaryClr
//                                     : DynamicColors.primaryClr,
//                               ),
//                             ),
//                             Expanded(
//                               child: RowButtonWidgetMap(
//                                 onTap: () {
//                                   controller.selectedTab.value = "PLOT";
//                                   controller.update();
//                                 },
//                                 color: controller.selectedTab.value != "MAPS"
//                                     ? DynamicColors.primaryClr
//                                     : DynamicColors.secondaryClr,
//                                 text: "PLOT",
//                                 textClr: controller.selectedTab.value != "MAPS"
//                                     ? DynamicColors.secondaryClr
//                                     : DynamicColors.primaryClr,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               color: DynamicColors.whiteClr,
//                               // width: 100,
//                               // height: 40,
//                               padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text("${controller.totalDistance.value} miles"),
//                                   Text(controller.totalTimeDuration.value)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 /// OPEN IN NEW TAB BUTTON
//                 Positioned(
//                   bottom: 0,
//                   child: Padding(
//                     padding: const EdgeInsets.all(7.0),
//                     child: Container(
//                       height: 20,
//                       width: 30,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(6),
//                         color: DynamicColors.secondaryClr,
//                       ),
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         icon: const Icon(Icons.crop_square_outlined),
//                         onPressed: () {
//                           final newTabUrl = Uri.base.origin + '/#' + Routes.viewDriversMap;
//                           html.window.open(
//                             newTabUrl,
//                             '_blank',
//                             'width=1200,height=800,noopener,noreferrer',
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   /// 🧮 Calculate bearing between two points for arrow rotation
//
// }
//
import 'dart:math';
import 'package:dashboard_new1/alert/sub_map_on_iconButton_alert.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:html' as html;
import '../../../component/marker_class.dart';
import '../../../routes/app_pages.dart';
import '../Controller/dashboard_controller.dart';
import 'defult_dashboard_view.dart';



class MapViewWidget extends StatefulWidget {
  MapViewWidget({super.key, this.createBooking = false});
  final bool createBooking;

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  final controller = Get.find<DashboardController>();
  final List<Polygon> zonePolygons = [];

  @override
  void initState() {
    super.initState();
    poligonFun();
    if (controller.seeZoneOnMapModel == null) {
      methodHit();
    }
  }

  Future<void> methodHit() async {
    await controller.seeZoneOnMapp();
    poligonFun();
  }

  Future<void> poligonFun() async {
    zonePolygons.clear();
    final zones = controller.seeZoneOnMapModel?.zones ?? [];
    for (var zone in zones) {
      if (zone.vertices != null && zone.vertices!.isNotEmpty) {
        zonePolygons.add(
          Polygon(
            points: zone.vertices!
                .map((v) => LatLng(v.latitude!, v.longitude!))
                .toList(),
            color: DynamicColors.primaryClr.withOpacity(0.2),
            borderColor: DynamicColors.primaryClr,
            borderStrokeWidth: 3.0,
            label: zone.name ?? '',
          ),
        );
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        final List<LatLng> polylinePoints =  controller.polylinePoints.isNotEmpty
            ? controller.polylinePointsCoordinate
            : [LatLng(51.2709722, 0.1893883)];

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // ── MAP ──
              Positioned.fill(
                child: ClipRRect(
                  child: FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      initialCenter:polylinePoints.isEmpty?LatLng(51.2709722, 0.1893883): polylinePoints.first,
                      initialZoom: 13.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                        enableMultiFingerGestureRace: true,
                      ),
                      onMapReady: () {
                        if (polylinePoints.length >= 2) {
                          final bounds =
                          LatLngBounds.fromPoints(polylinePoints);
                          controller.mapController.fitCamera(
                            CameraFit.bounds(
                              bounds: bounds,
                              padding: const EdgeInsets.all(60),
                            ),
                          );
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      if (polylinePoints.length > 1)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: polylinePoints,
                              color: Colors.blue,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),
                      PolygonLayer(polygons: zonePolygons),
                      MarkerLayer(markers: controller.markers),
                    ],
                  ),
                ),
              ),

              // ── TAB TOGGLE (MAPS / PLOT) ──
              if (!widget.createBooking)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.secondaryClr),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: DynamicColors.whiteClr,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "${controller.totalDistance.value} miles"),
                                  Text(controller.totalTimeDuration.value),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── OPEN-IN-DIALOG BUTTON ──
              Positioned(
                bottom: 7,
                left: 7,
                child: Container(
                  height: 20,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: DynamicColors.secondaryClr,
                    // Keyboard-Tab highlight ring (driven from the driver panel).
                    // Always a 2px border so toggling doesn't shift the child.
                    border: Border.all(
                      color: controller.selectedMapButtonIndex == 0
                          ? DynamicColors.primaryClr
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.crop_square_outlined),
                    onPressed: () {
                      final newTabUrl = Uri.base.origin + '/#' + Routes.viewDriversMap;
                      html.window.open(newTabUrl, '_blank');
                    },
                  ),
                ),
              ),

              ///  ZOOM BUTTONS ON map
              Positioned(
                right: 15,
                bottom: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Zoom (+) Button
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: controller.selectedMapButtonIndex == 1
                              ? DynamicColors.primaryClr
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: FloatingActionButton.small(
                          heroTag: "zoom_in_btn",
                          backgroundColor: Colors.white,

                          onPressed: () {
                            controller.updateZoom(true);
                          },
                          child: const Icon(Icons.add, color: Colors.black87,  size: 20,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Zoom (-) Button
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: controller.selectedMapButtonIndex == 2
                              ? DynamicColors.primaryClr
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: FloatingActionButton.small(
                          heroTag: "zoom_out_btn",
                          backgroundColor: Colors.white,
                          onPressed: () {
                            controller.updateZoom(false);
                          },
                          child: const Icon(Icons.remove, color: Colors.black87, size: 20,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Camera fouces
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: controller.selectedMapButtonIndex == 3
                              ? DynamicColors.primaryClr
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: FloatingActionButton.small(
                          backgroundColor: Colors.black26,
                          onPressed: () {
                            controller.mapController.move(
                              polylinePoints.first,
                              13.0,
                            );
                          },
                          child: const Icon(Icons.center_focus_strong, color: Colors.black87, size: 20,),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


