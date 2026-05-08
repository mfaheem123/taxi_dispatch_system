import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../component/color.dart';
import '../component/marker_class.dart';
import '../component/networks/api.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
    dashBoardCntrl.getAllDriversTracking();
    trackingDriverSocket();
  }

  int? selectTrackingCarId;
  /// 👇 MUST be RxList
  final RxList<CustomMarker> trackingMarkers = <CustomMarker>[].obs;
  WebSocketChannel? _channel;

  void trackingDriverSocket() {
    final url = Uri.parse("$socketUrl/driver-tracking-dashboard");
    try {
      _channel = WebSocketChannel.connect(url);

      _channel!.stream.listen(
            (message) {
          final data = jsonDecode(message);
          if(data['event'] == 'DRIVER_LOCATION_UPDATE'|| data['event']== "DRIVER_BOOKING_STATUS_UPDATE"){
            int indexxx = trackingMarkers.indexWhere((test) => test.id == data['data']['id']);

            if (indexxx == -1) return; // safety

            double lat = double.parse(data['data']['latitude'].toString());
            double lng = double.parse(data['data']['longitude'].toString());
            final target = LatLng(lat, lng);

            final oldMarker = trackingMarkers[indexxx];
            print(oldMarker.point.latitude);
            print(oldMarker.point.longitude);
            print(data['data']['booking_status']);

            int indexes = dashBoardCntrl.onlineBusyDriversList!.trackingDrivers!.indexWhere((test) => test.id == data['data']['id']);

            TrackingDriverObject objectData = dashBoardCntrl.onlineBusyDriversList!.trackingDrivers![indexes];

            objectData.latitude = lat.toString();
            objectData.longitude = lng.toString();
            objectData.bookingStatus = data['data']['booking_status'];
            print(data['data']['id']);
            print(data['data']['username']);

            if(data['event'] == "DRIVER_BOOKING_STATUS_UPDATE"){
              /// ✅ Replace with new updated marker
              trackingMarkers[indexxx] = CustomMarker(
                id: oldMarker.id,
                withReturnType: oldMarker.withReturnType,
                type: oldMarker.type,
                width: oldMarker.width,
                height: oldMarker.height,
                point: target,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.directions_car,
                        // size: 40,
                      color: objectData.bookingStatus == "Accepted"?Colors.orange:
                      objectData.bookingStatus == "Arrived"?Colors.yellow:
                      objectData.bookingStatus == "On Route"?Colors.red:
                      objectData.bookingStatus == "STC"?Colors.blue:
                      Colors.green,
                    ),
                    Container(
                      color: objectData.bookingStatus == "Accepted"?Colors.orange:
                      objectData.bookingStatus == "Arrived"?Colors.yellow:
                      objectData.bookingStatus == "On Route"?Colors.red:
                      objectData.bookingStatus == "STC"?Colors.blue:
                      Colors.green,
                      padding: const EdgeInsets.only(bottom: 10.0,left: 4,right: 4),
                      child: Text(
                        objectData.username ?? "",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }else{

              /// ✅ Replace with new updated marker
              trackingMarkers[indexxx] = CustomMarker(
                id: oldMarker.id,
                withReturnType: oldMarker.withReturnType,
                type: oldMarker.type,
                width: oldMarker.width,
                height: oldMarker.height,
                point: target,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.directions_car,
                      size: 70,
                      color: objectData.bookingStatus == "Accepted"?Colors.orange:
                      objectData.bookingStatus == "Arrived"?Colors.yellow:
                      objectData.bookingStatus == "On Route"?Colors.red:
                      objectData.bookingStatus == "STC"?Colors.blue:
                      Colors.green,
                    ),
                    Container(
                      color: objectData.bookingStatus == "Accepted"?Colors.orange:
                      objectData.bookingStatus == "Arrived"?Colors.yellow:
                      objectData.bookingStatus == "On Route"?Colors.red:
                      objectData.bookingStatus == "STC"?Colors.blue:
                      Colors.green,
                      padding: const EdgeInsets.only(bottom: 10.0,left: 4,right: 4),
                      child: Text(
                        objectData.username ?? "",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            print(trackingMarkers[indexxx].point.latitude);
            print(trackingMarkers[indexxx].point.longitude);
            setState(() {

            });
          }
          print(data['event']);
          print(data['data']['latitude']);
          print(data['data']['longitude']);
          print(data['event']);


        },
        onError: (error) => print("Connection Error: $error"),
        onDone: () {
          trackingDriverSocket();
          print("🔌 Socket Disconnected");
          print("Close Code: ${_channel?.closeCode}");
          print("Close Reason: ${_channel?.closeReason}");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

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
                                trackingMarkers.removeWhere((marker) =>
                                    marker.id.toString() == controller.onlineBusyDriversList!.trackingDrivers![index].id.toString()
                                );

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
                                        Icon(Icons.directions_car,
                                          size: 70,
                                          color: driver.bookingStatus == "Accepted"?Colors.orange:
                                          driver.bookingStatus == "Arrived"?Colors.yellow:
                                          driver.bookingStatus == "On Route"?Colors.red:
                                          driver.bookingStatus == "STC"?Colors.blue:
                                          Colors.green,
                                        ),
                                        Container(
                                          color: driver.bookingStatus == "Accepted"?Colors.orange:
                                          driver.bookingStatus == "Arrived"?Colors.yellow:
                                          driver.bookingStatus == "On Route"?Colors.red:
                                          driver.bookingStatus == "STC"?Colors.blue:
                                          Colors.green,
                                          padding: const EdgeInsets.only(bottom: 10.0,left: 4,right: 4),
                                          child: Text(
                                            driver.username ?? "",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                selectTrackingCarId = driver.id;

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
