import 'dart:math';

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:html' as html;
import '../../../routes/app_pages.dart';
import '../Controller/dashboard_controller.dart';

class MapViewWidget extends StatefulWidget {
  MapViewWidget({super.key, this.createBooking = false});
  bool createBooking = false;

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  final controller = Get.find<DashboardController>();



@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List<Polygon> zonePolygons = [];
  poligonFun()async{
    for (var model in controller.seeZoneOnMapModel!.zones![0].vertices!) {
      if (model.latitude != null && model.longitude!=null) {
        zonePolygons.add(
          Polygon(
            points: controller.seeZoneOnMapModel!.zones![0].vertices!
                .map((v) => LatLng(v.latitude!, v.longitude!))
                .toList(),
            color: DynamicColors.primaryClr.withOpacity(0.2),
            borderColor: DynamicColors.primaryClr,
            borderStrokeWidth: 3.0,
            label:controller.seeZoneOnMapModel!.zones![0].name?? '',
          ),
        );
      }
    }
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
    // if (polylinePoints.isEmpty) {
    //   return Center(child: CircularProgressIndicator());
    // }

    return SizedBox(
      width: widget.createBooking == true?Get.width: width >= 1270 ? screenWidth / 2.95 : screenWidth / 1.2 ,
      height: widget.createBooking == true?Get.height / 1.4:
      screenHeight >=940? screenHeight * 0.51:
      screenHeight * 0.80, /// yaha per aghar create booking per map access karte hu tu map ka height (Get.height / 1.4) our aghar laptop se bara screen hogha tu os ka height (screenHeight >=940? screenHeight * 0.51:) our aghar lap ka screen hogha tu os ka height (screenHeight * 0.80)
      child: GetBuilder<DashboardController>(
        initState: (v){
          poligonFun();
        },
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
            // borderRadius: BorderRadius.circular(26),
           child: FlutterMap(

              mapController: controller.mapController,
              options:MapOptions(
                initialCenter: polylinePoints.isEmpty ?LatLng(50.5, 30.51):
                polylinePoints.first,
                initialZoom: 13.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all, // drag + zoom + tap + scroll
                  enableMultiFingerGestureRace: true,
                ),
                onMapReady: () {
                  if (polylinePoints.length >= 2) {
                    final bounds = LatLngBounds.fromPoints(polylinePoints);
                    controller.mapController.fitCamera(
                      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
                    );
                  }
                },
              ),
              children: [
                // 🗺️ Background
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),

                // 🧭 Route polyline
                polylinePoints.length>1? PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylinePoints,
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                  ],
                ):SizedBox.shrink(),
                PolygonLayer(
                  polygons: zonePolygons, // ✅ correct here
                ),
                // PolylineLayer(polylines: controller.polylines),
                MarkerLayer(markers: controller.markers),
              ],
            ),

          ),
          ),

          /// TAB TOGGLE
                widget.createBooking == true?SizedBox.shrink():
                Positioned(
                  child: Container(
                    width: Get.width,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.secondaryClr),
                    ),
                    child: Column(
                      children: [
                        Row(
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: DynamicColors.whiteClr,
                              // width: 100,
                              // height: 40,
                              padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${controller.totalDistance.value} miles"),
                                  Text(controller.totalTimeDuration.value)
                                ],
                              ),
                            ),
                          ),
                        )
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
                      height: 20,
                      width: 30,
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

  /// 🧮 Calculate bearing between two points for arrow rotation

}





// class MapViewWidget extends StatefulWidget {
//   final bool createBooking;
//   const MapViewWidget({super.key, this.createBooking = false});
//
//   @override
//   State<MapViewWidget> createState() => _MapViewWidgetState();
// }
//
// class _MapViewWidgetState extends State<MapViewWidget> {
//   final controller = Get.find<DashboardController>();
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     final List<LatLng> polylinePoints = controller.polylinePointsCoordinate.isNotEmpty
//         ? controller.polylinePointsCoordinate
//         : [LatLng(50.85496238858419, 0.561166687845978)];
//
//     double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
//         WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
//
//     return SizedBox(
//       width: widget.createBooking
//           ? Get.width
//           : width >= 1270
//           ? screenWidth / 2.95
//           : screenWidth / 1.2,
//       height: widget.createBooking
//           ? Get.height / 1.4
//           : screenHeight >= 940
//           ? screenHeight * 0.51
//           : screenHeight * 0.80,
//       child: GetBuilder<DashboardController>(
//         builder: (controller) {
//           /// 🟩 Convert all zone vertices to FlutterMap polygons
//           final List<Polygon> zonePolygons = [];
//
//           for (var model in controller.seeZoneOnMapModel) {
//             if (model.zones != null && model.zones!.isNotEmpty) {
//               for (var zone in model.zones!) {
//                 if (zone.vertices != null && zone.vertices!.isNotEmpty) {
//                   print('🟢 Zone Found: ${zone.name}');
//                   print('📍 Vertices count: ${zone.vertices!.length}');
//                   print('➡️ First vertex: '
//                       '${zone.vertices!.first.latitude}, ${zone.vertices!.first.longitude}');
//
//                   zonePolygons.add(
//                     Polygon(
//                       points: zone.vertices!
//                           .map((v) => LatLng(v.latitude!, v.longitude!))
//                           .toList(),
//                       color: DynamicColors.primaryClr.withOpacity(0.2),
//                       borderColor: DynamicColors.primaryClr,
//                       borderStrokeWidth: 3.0,
//                       label: zone.name ?? '',
//                     ),
//                   );
//                 }
//               }
//             }
//           }
//
//           print("✅ Total polygons on map: ${zonePolygons.length}");
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
//                 /// 🌍 MAP VIEW
//                 Positioned.fill(
//                   child: ClipRRect(
//                     child: FlutterMap(
//                       mapController: controller.mapController,
//                       options: MapOptions(
//                         initialCenter: polylinePoints.isEmpty
//                             ? LatLng(50.5, 30.51)
//                             : polylinePoints.first,
//                         initialZoom: 11.5,
//                         onMapReady: () {
//                           print("🗺️ Map is ready!");
//                           if (polylinePoints.length >= 2) {
//                             final bounds = LatLngBounds.fromPoints(polylinePoints);
//                             controller.mapController.fitCamera(
//                               CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
//                             );
//                           }
//                         },
//                       ),
//                       children: [
//                         /// 🗺️ Base map
//                         TileLayer(
//                           urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                           subdomains: const ['a', 'b', 'c'],
//                         ),
//
//                         /// 🟢 Zone polygons
//                         if (zonePolygons.isNotEmpty)
//                           PolygonLayer(polygons: zonePolygons)
//                         else
//                           const SizedBox.shrink(),
//
//                         /// 🔵 Route line
//                         if (polylinePoints.length > 1)
//                           PolylineLayer(
//                             polylines: [
//                               Polyline(
//                                 points: polylinePoints,
//                                 color: Colors.blue,
//                                 strokeWidth: 4.0,
//                               ),
//                             ],
//                           ),
//
//                         /// 📍 Pickup/Drop markers
//                         MarkerLayer(markers: controller.markers),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 /// 🔘 MAP / PLOT TABS
//                 if (!widget.createBooking)
//                   Positioned(
//                     top: 0,
//                     child: Container(
//                       width: Get.width,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: DynamicColors.secondaryClr),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: RowButtonWidgetMap(
//                                   onTap: () {
//                                     controller.selectedTab.value = "MAPS";
//                                     controller.update();
//                                   },
//                                   color: controller.selectedTab.value == "MAPS"
//                                       ? DynamicColors.primaryClr
//                                       : DynamicColors.secondaryClr,
//                                   textClr: controller.selectedTab.value == "MAPS"
//                                       ? DynamicColors.secondaryClr
//                                       : DynamicColors.primaryClr,
//                                 ),
//                               ),
//                               Expanded(
//                                 child: RowButtonWidgetMap(
//                                   onTap: () {
//                                     controller.selectedTab.value = "PLOT";
//                                     controller.update();
//                                   },
//                                   color: controller.selectedTab.value != "MAPS"
//                                       ? DynamicColors.primaryClr
//                                       : DynamicColors.secondaryClr,
//                                   text: "PLOT",
//                                   textClr: controller.selectedTab.value != "MAPS"
//                                       ? DynamicColors.secondaryClr
//                                       : DynamicColors.primaryClr,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 /// 🪟 OPEN MAP IN NEW TAB
//                 Positioned(
//                   bottom: 0,
//                   child: Padding(
//                     padding: const EdgeInsets.all(7.0),
//                     child: Container(
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
// }

