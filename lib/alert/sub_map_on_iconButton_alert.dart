import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../component/color.dart';
import '../component/marker_class.dart';
import '../component/textStyle.dart';
import '../component/text_widget.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../view/dashboard_view/models/tracking_drivers_model.dart';

class DriversMapAlert extends StatefulWidget {
  const DriversMapAlert({super.key});

  @override
  State<DriversMapAlert> createState() => _DriversMapAlertState();
}

class _DriversMapAlertState extends State<DriversMapAlert> {
  final dashBoardCntrl = Get.find<DashboardController>();

  // Boolean variable to track state
  bool isFullScreen = false;
  late final MapController mapController;

  /// 👇 MUST be RxList
  final RxList<CustomMarker> trackingMarkers = <CustomMarker>[].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
    dashBoardCntrl.getAllDriversTracking();
  }

  List<String> driverLocationHistory = [
    "24.909889, 67.106173",
    "24.9109147, 67.1059215",
    "24.9115094, 67.105151",
    "24.9120991, 67.1043783",
    "24.9113895, 67.1055239",
    "24.9104233, 67.1067902",
    "24.9100975, 67.1072872",
    "24.909889, 67.106174",
    "24.9097128, 67.1077684",
    "24.909890, 67.106167",
    "24.909890, 67.106167",
    "24.909890, 67.106167",
    "24.909890, 67.106167",
    "24.9084417, 67.1092331",
    "24.9078434, 67.1099769",
    "24.9067876, 67.1113991",
    "24.9059671, 67.1123048",
    "24.9045838, 67.1135057",
    "24.9029529, 67.1149134",
    "24.9019996, 67.1157195",
    "24.901137, 67.1163152",
    "24.900352, 67.1164471",
    "24.8991878, 67.1169969",
    "24.8981947, 67.1176861",
    "24.896762, 67.1187551",
    "24.8950935, 67.1198867",
    "24.8939085, 67.120719",
    "24.8927398, 67.1215323",
    "24.8917472, 67.1222442",
    "24.890704, 67.1229451",
    "24.8888685, 67.1242575",
    "24.8875499, 67.1252398",
    "24.8869557, 67.1247261",
    "24.8867062, 67.1239379",
    "24.8860716, 67.121655",
    "24.8857308, 67.1203653",
    "24.8849748, 67.1181545",
    "24.8841344, 67.1162239",
    "24.8835274, 67.1149183",
    "24.8823875, 67.1127445",
    "24.8815327, 67.1112582",
    "24.8804619, 67.1094201",
    "24.8798028, 67.1082343",
    "24.8787762, 67.1063233",
    "24.8780628, 67.1049535",
    "24.8769302, 67.1026747",
    "24.8763638, 67.101371",
    "24.8758901, 67.0996081",
    "24.8754906, 67.0982251",
    "24.8751276, 67.0971151",
    "24.8747247, 67.0959027",
    "24.8743961, 67.0951499",
    "24.8743348, 67.0959812",
    "24.8737473, 67.0962205",
    "24.8735642, 67.0970089",
    "24.8743665, 67.0972417",
    "24.8748212, 67.0970329",
    "24.8753574, 67.0983971"
  ];

  int? iddd;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: isFullScreen ? EdgeInsets.zero : const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isFullScreen ? 0 : 8),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isFullScreen ? Get.width : Get.width * 0.9,
        height: isFullScreen ? Get.height : Get.height * 0.85,
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DRIVERS MAP",
                    style: mozillaTextSemiBoldText(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFullScreen = !isFullScreen;
                          });
                        },
                        child: Icon(
                          isFullScreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          color: DynamicColors.textClr,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(Icons.close,
                            color: DynamicColors.textClr, size: 20),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const Divider(height: 1),

            /// 🔥 MAP (NOT inside GetBuilder)
            Expanded(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  ClipRRect(
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: LatLng(50.5, 30.51),
                        initialZoom: 13.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                          enableMultiFingerGestureRace: true,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),

                        /// ✅ Reactive markers (NO rebuild crash)
                        MarkerLayer(
                          markers: trackingMarkers,
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: Get.height,
                      width: 150,
                      color: DynamicColors.whiteClr,
                      child: ListView.builder(
                        itemCount: driverLocationHistory.length,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context,index){
                        return ListTile(
                            onTap: () {
                              int indexxx = trackingMarkers.indexWhere((test) => test.id == iddd);

                              if (indexxx == -1) return; // safety

                              List<String> parts = driverLocationHistory[index].split(',');

                              double lat = double.parse(parts[0].trim());
                              double lng = double.parse(parts[1].trim());
                              final target = LatLng(lat, lng);

                              final oldMarker = trackingMarkers[indexxx];

                              /// ✅ Replace with new updated marker
                              trackingMarkers[indexxx] = CustomMarker(
                                id: oldMarker.id,
                                withReturnType: oldMarker.withReturnType,
                                type: oldMarker.type,
                                width: oldMarker.width,
                                height: oldMarker.height,
                                point: target,
                                child: oldMarker.child,
                              );

                              setState(() {});
                            },
                          title: Text(driverLocationHistory[index]),
                        );
                      }),
                    ),
                  ),

                  /// 🔥 DRIVER LIST (ONLY THIS uses GetBuilder)
                  Container(
                    height: Get.height,
                    width: 250,
                    color: DynamicColors.whiteClr,
                    child: GetBuilder<DashboardController>(
                      builder: (controller) {
                        if (controller.onlineBusyDriversList == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return ListView.builder(
                          itemCount: controller.onlineBusyDriversList
                                  ?.trackingDrivers?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final driver = controller
                                .onlineBusyDriversList!.trackingDrivers![index];

                            return GestureDetector(
                              onTap: () {
                                final lat = double.parse(driver.latitude!);
                                final lng = double.parse(driver.longitude!);
                                final target = LatLng(lat, lng);

                                /// 🔥 Update markers safely
                                trackingMarkers.removeWhere((m) =>
                                    m is CustomMarker &&
                                    m.withReturnType == "driverMarker");

                                trackingMarkers.add(
                                  CustomMarker(
                                    withReturnType: "driverMarker",
                                    type: "driverMarker",
                                    point: target,
                                    width: 70,
                                    height: 70,
                                    id: driver.id,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Image(
                                          image: AssetImage("assets/car3.png"),
                                          width: 70,
                                          height: 70,
                                        ),
                                        Text(
                                          driver.username ?? "",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                iddd = driver.id;

                                /// 🔥 Move map safely
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  mapController.move(target, 16);
                                });
                                setState(() {});
                              },
                              child: _driverTile(
                                driver.username ?? "",
                                driver.bookingStatus ?? "",
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // return Dialog(
    //   insetPadding: isFullScreen ? EdgeInsets.zero : const EdgeInsets.all(20),
    //   backgroundColor: Colors.white,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(isFullScreen ? 0 : 8),
    //   ),
    //   child: AnimatedContainer(
    //     duration: const Duration(milliseconds: 300),
    //     width: isFullScreen ? Get.width : Get.width * 0.9,
    //     height: isFullScreen ? Get.height : Get.height * 0.85,
    //     child: GetBuilder<DashboardController>(
    //       builder: (controller) {
    //         return controller.onlineBusyDriversList == null?Center(
    //           child: CircularProgressIndicator(),
    //         ): Column(
    //           children: [
    //             /// HEADER
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     "DRIVERS MAP",
    //                     style: mozillaTextSemiBoldText(
    //                       fontWeight: FontWeight.w700,
    //                       fontSize: 14,
    //                     ),
    //                   ),
    //                   Row(
    //                     children: [
    //                       GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             isFullScreen = !isFullScreen;
    //                           });
    //                         },
    //                         child: Icon(
    //                           isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
    //                           color: DynamicColors.textClr,
    //                           size: 24,
    //                         ),
    //                       ),
    //                       const SizedBox(width: 15),
    //                       GestureDetector(
    //                         onTap: () => Get.back(),
    //                         child: Icon(Icons.close, color: DynamicColors.textClr, size: 20),
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             ),
    //             const Divider(height: 1),
    //             ClipRRect(
    //               child: FlutterMap(
    //                 mapController: controller.mapController,
    //                 options: MapOptions(
    //                   initialCenter: LatLng(50.5, 30.51),
    //                   initialZoom: 13.0,
    //                   interactionOptions: const InteractionOptions(
    //                     flags: InteractiveFlag.all,
    //                     enableMultiFingerGestureRace: true,
    //                   ),
    //                   onMapReady: () {},
    //                 ),
    //                 children: [
    //                   /// 🗺️ Base map
    //                   TileLayer(
    //                     urlTemplate:
    //                     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    //                     subdomains: const ['a', 'b', 'c'],
    //                   ),
    //
    //                   /// 📌 Markers
    //                   MarkerLayer(markers: controller.markers),
    //                 ],
    //               ),
    //             ),
    //             // Row(
    //             //   children: [
    //             //     /// LEFT SIDE: MAP
    //             //     Expanded(
    //             //       flex: 3,
    //             //       child: ClipRRect(
    //             //         child: FlutterMap(
    //             //           mapController: controller.mapController,
    //             //           options: MapOptions(
    //             //             initialCenter: LatLng(50.5, 30.51),
    //             //             initialZoom: 13.0,
    //             //             interactionOptions: const InteractionOptions(
    //             //               flags: InteractiveFlag.all,
    //             //               enableMultiFingerGestureRace: true,
    //             //             ),
    //             //             onMapReady: () {},
    //             //           ),
    //             //           children: [
    //             //             /// 🗺️ Base map
    //             //             TileLayer(
    //             //               urlTemplate:
    //             //               'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    //             //               subdomains: const ['a', 'b', 'c'],
    //             //             ),
    //             //
    //             //             /// 📌 Markers
    //             //             MarkerLayer(markers: controller.markers),
    //             //           ],
    //             //         ),
    //             //       ),
    //             //     ),
    //             //
    //             //     /// RIGHT SIDE: SIDEBAR
    //             //     Container(
    //             //       width: 300,
    //             //       decoration: BoxDecoration(
    //             //         color: Colors.white,
    //             //         border: Border(
    //             //           left: BorderSide(color: Colors.grey.shade300),
    //             //         ),
    //             //       ),
    //             //       child: Column(
    //             //         children: [
    //             //           /// HEADER
    //             //           Padding(
    //             //             padding: const EdgeInsets.all(10.0),
    //             //             child: Row(
    //             //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //               children: [
    //             //                 Text(
    //             //                   AppText.drivers.toUpperCase(),
    //             //                   style: mozillaTextSemiBoldText(
    //             //                     fontSize: 16,
    //             //                     fontWeight: FontWeight.w800,
    //             //                   ),
    //             //                 ),
    //             //                 Row(
    //             //                   children: [
    //             //                     _actionButton("SHOW ZONES", Color(0xff424899)),
    //             //                     const SizedBox(width: 5),
    //             //                     _actionButton("CLEAR", Color(0xff424899)),
    //             //                   ],
    //             //                 )
    //             //               ],
    //             //             ),
    //             //           ),
    //             //
    //             //           const Divider(),
    //             //
    //             //           /// DRIVER LIST
    //             //           Expanded(
    //             //             child: ListView.builder(
    //             //               itemCount: controller
    //             //                   .onlineBusyDriversList?.trackingDrivers?.length ??
    //             //                   0,
    //             //               itemBuilder: (context, index) {
    //             //                 final driver = controller
    //             //                     .onlineBusyDriversList!.trackingDrivers![index];
    //             //
    //             //                 return GestureDetector(
    //             //                   onTap: () {
    //             //                     WidgetsBinding.instance
    //             //                         .addPostFrameCallback((_) {
    //             //                       final lat = double.parse(driver.latitude!);
    //             //                       final lng = double.parse(driver.longitude!);
    //             //
    //             //                       final target = LatLng(lat, lng);
    //             //
    //             //                       /// Remove old marker of this driver
    //             //                       controller.markers.removeWhere((marker) {
    //             //                         return marker is CustomMarker &&
    //             //                             marker.withReturnType == "driverMarker" &&
    //             //                             marker.child is Stack &&
    //             //                             (marker.child as Stack)
    //             //                                 .children
    //             //                                 .any((widget) =>
    //             //                             widget is Text &&
    //             //                                 widget.data ==
    //             //                                     driver.username);
    //             //                       });
    //             //
    //             //                       /// Add updated marker
    //             //                       controller.markers.add(
    //             //                         CustomMarker(
    //             //                           withReturnType: "driverMarker",
    //             //                           type: "driverMarker",
    //             //                           point: target,
    //             //                           width: 70,
    //             //                           height: 70,
    //             //                           child: Stack(
    //             //                             alignment: Alignment.center,
    //             //                             children: [
    //             //                               const Image(
    //             //                                 image: AssetImage(
    //             //                                     "assets/car3.png"),
    //             //                                 width: 70,
    //             //                                 height: 70,
    //             //                               ),
    //             //                               Text(
    //             //                                 driver.username ?? "",
    //             //                                 style: const TextStyle(
    //             //                                   fontSize: 12,
    //             //                                   color: Colors.white,
    //             //                                 ),
    //             //                               )
    //             //                             ],
    //             //                           ),
    //             //                         ),
    //             //                       );
    //             //
    //             //                       /// Move camera
    //             //                       Future.microtask(() {
    //             //                         controller.mapController.move(target, 16);
    //             //                       });
    //             //
    //             //                       /// Update UI
    //             //                       controller.update();
    //             //                     });
    //             //                   },
    //             //                   child: _driverTile(
    //             //                     driver.username ?? "",
    //             //                     driver.bookingStatus ?? "",
    //             //                   ),
    //             //                 );
    //             //               },
    //             //             ),
    //             //           ),
    //             //         ],
    //             //       ),
    //             //     ),
    //             //   ],
    //             // )
    //
    //
    //
    //             // Expanded(
    //             //   child: Row(
    //             //     children: [
    //             //       Expanded(
    //             //         flex: 3,
    //             //         child:
    //             //         Positioned.fill(
    //             //           child: ClipRRect(
    //             //             child: FlutterMap(
    //             //               mapController: controller.mapController,
    //             //               options: MapOptions(
    //             //                 initialCenter: LatLng(50.5, 30.51),
    //             //                 initialZoom: 13.0,
    //             //                 interactionOptions: const InteractionOptions(
    //             //                   flags: InteractiveFlag.all,
    //             //                   enableMultiFingerGestureRace: true,
    //             //                 ),
    //             //                 onMapReady: () {
    //             //                   // if (controller.onlineBusyDriversList.length >= 2) {
    //             //                   //   final bounds =
    //             //                   //   LatLngBounds.fromPoints(polylinePoints);
    //             //                   //   controller.mapController.fitCamera(
    //             //                   //     CameraFit.bounds(
    //             //                   //         bounds: bounds,
    //             //                   //         padding: const EdgeInsets.all(60)),
    //             //                   //   );
    //             //                   // }
    //             //                 },
    //             //               ),
    //             //
    //             //               children: [
    //             //                 /// 🗺️ Base map
    //             //                 TileLayer(
    //             //                   urlTemplate:
    //             //                   'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    //             //                   subdomains: const ['a', 'b', 'c'],
    //             //                 ),
    //             //
    //             //                 /// 📌 Markers
    //             //                 MarkerLayer(markers: controller.markers),
    //             //               ],
    //             //             ),
    //             //           ),
    //             //         ),
    //             //         // Stack(
    //             //         //   children: [
    //             //         //     FlutterMap(
    //             //         //       options: const MapOptions(
    //             //         //         initialCenter: LatLng(51.5862, -0.1983),
    //             //         //         initialZoom: 13.0,
    //             //         //       ),
    //             //         //       children: [
    //             //         //         TileLayer(
    //             //         //           urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    //             //         //           subdomains: const ['a', 'b', 'c'],
    //             //         //         ),
    //             //         //         MarkerLayer(markers: controller.markers),
    //             //         //       ],
    //             //         //     ),
    //             //         //   ],
    //             //         // ),
    //             //       ),
    //             //
    //             //       ///  RIGHT SIDE: (Sidebar)
    //             //       Container(
    //             //         width: 300,
    //             //         decoration: BoxDecoration(
    //             //           color: Colors.white,
    //             //           border: Border(left: BorderSide(color: Colors.grey.shade300)),
    //             //         ),
    //             //         child: Column(
    //             //           children: [
    //             //             Padding(
    //             //               padding: const EdgeInsets.all(10.0),
    //             //               child: Row(
    //             //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //                 children: [
    //             //                   Text(
    //             //                     AppText.drivers.toUpperCase(),
    //             //                     style: mozillaTextSemiBoldText(fontSize: 16, fontWeight: FontWeight.w800),
    //             //                   ),
    //             //                   Row(
    //             //                     children: [
    //             //                       _actionButton("SHOW ZONES", Color(0xff424899)),
    //             //                       const SizedBox(width: 5),
    //             //                       _actionButton("CLEAR", Color(0xff424899)),
    //             //                     ],
    //             //                   )
    //             //                 ],
    //             //               ),
    //             //             ),
    //             //             const Divider(),
    //             //             Expanded(
    //             //               child: ListView.builder(
    //             //                 itemCount: controller.onlineBusyDriversList!.trackingDrivers!.length,
    //             //                 itemBuilder: (context, index) {
    //             //                   TrackingDriverObject driverIndex = controller.onlineBusyDriversList!.trackingDrivers![index];
    //             //
    //             //                   return GestureDetector(
    //             //                       onTap: () {
    //             //                         // Wrap the logic in a post-frame callback to avoid the build collision
    //             //                         WidgetsBinding.instance.addPostFrameCallback((_) {
    //             //
    //             //                           // 1. Remove the existing marker
    //             //                           controller.markers.removeWhere((marker) {
    //             //                             return marker is CustomMarker &&
    //             //                                 marker.withReturnType == "driverMarker" &&
    //             //                                 marker.child is Stack &&
    //             //                                 (marker.child as Stack).children.any((widget) =>
    //             //                                 widget is Text && widget.data == driverIndex.username);
    //             //                           });
    //             //
    //             //                           // 2. Add the new updated marker
    //             //                           controller.markers.add(
    //             //                             CustomMarker(
    //             //                               withReturnType: "driverMarker",
    //             //                               child: Stack(
    //             //                                 alignment: Alignment.center,
    //             //                                 children: [
    //             //                                   const Image(
    //             //                                     image: AssetImage("assets/car3.png"),
    //             //                                     width: 70,
    //             //                                     height: 70,
    //             //                                   ),
    //             //                                   Text(
    //             //                                     "${driverIndex.username}",
    //             //                                     style: const TextStyle(fontSize: 12, color: Colors.white),
    //             //                                   )
    //             //                                 ],
    //             //                               ),
    //             //                               type: "driverMarker",
    //             //                               point: LatLng(
    //             //                                 double.parse(driverIndex.latitude!),
    //             //                                 double.parse(driverIndex.longitude!),
    //             //                               ),
    //             //                               width: 70,
    //             //                               height: 70,
    //             //                             ),
    //             //                           );
    //             //
    //             //                           final target = LatLng(
    //             //                             double.parse(driverIndex.latitude!),
    //             //                             double.parse(driverIndex.longitude!),
    //             //                           );
    //             //
    //             //                           controller.mapController.move(target, 16);
    //             //
    //             //                           // Now it is safe to update the state
    //             //                           controller.update();
    //             //                           if (mounted) {
    //             //                             setState(() {});
    //             //                           }
    //             //                         });
    //             //                       },
    //             //                       child: _driverTile(driverIndex.username!, driverIndex.bookingStatus!));
    //             //                 },
    //             //               ),
    //             //             ),
    //             //           ],
    //             //         ),
    //             //       ),
    //             //     ],
    //             //   ),
    //             // ),
    //           ],
    //         );
    //       }
    //     ),
    //   ),
    // );
  }

  // Baki widgets (_actionButton, _driverTile) wese hi rahen ge...
  Widget _actionButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _driverTile(String name, String status) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: mozillaTextSemiBoldText(
                  fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xff424899),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.send_outlined, size: 16, color: Color(0xff424899)),
        ],
      ),
    );
  }
}
