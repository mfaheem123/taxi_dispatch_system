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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashBoardCntrl.getAllDriversTracking();
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
        child: GetBuilder<DashboardController>(
          builder: (controller) {
            return controller.onlineBusyDriversList == null?Center(
              child: CircularProgressIndicator(),
            ): Column(
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
                              isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                              color: DynamicColors.textClr,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Icon(Icons.close, color: DynamicColors.textClr, size: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child:
                        Positioned.fill(
                          child: ClipRRect(
                            child: FlutterMap(
                              mapController: controller.mapController,
                              options: MapOptions(
                                initialCenter: LatLng(50.5, 30.51),
                                initialZoom: 13.0,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all,
                                  enableMultiFingerGestureRace: true,
                                ),
                                onMapReady: () {
                                  // if (controller.onlineBusyDriversList.length >= 2) {
                                  //   final bounds =
                                  //   LatLngBounds.fromPoints(polylinePoints);
                                  //   controller.mapController.fitCamera(
                                  //     CameraFit.bounds(
                                  //         bounds: bounds,
                                  //         padding: const EdgeInsets.all(60)),
                                  //   );
                                  // }
                                },
                              ),

                              children: [
                                /// 🗺️ Base map
                                TileLayer(
                                  urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: const ['a', 'b', 'c'],
                                ),

                                /// 📌 Markers
                                MarkerLayer(markers: controller.markers),
                              ],
                            ),
                          ),
                        ),
                        // Stack(
                        //   children: [
                        //     FlutterMap(
                        //       options: const MapOptions(
                        //         initialCenter: LatLng(51.5862, -0.1983),
                        //         initialZoom: 13.0,
                        //       ),
                        //       children: [
                        //         TileLayer(
                        //           urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        //           subdomains: const ['a', 'b', 'c'],
                        //         ),
                        //         MarkerLayer(markers: controller.markers),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ),

                      ///  RIGHT SIDE: (Sidebar)
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(left: BorderSide(color: Colors.grey.shade300)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppText.drivers.toUpperCase(),
                                    style: mozillaTextSemiBoldText(fontSize: 16, fontWeight: FontWeight.w800),
                                  ),
                                  Row(
                                    children: [
                                      _actionButton("SHOW ZONES", Color(0xff424899)),
                                      const SizedBox(width: 5),
                                      _actionButton("CLEAR", Color(0xff424899)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: controller.onlineBusyDriversList!.trackingDrivers!.length,
                                itemBuilder: (context, index) {
                                  TrackingDriverObject driverIndex = controller.onlineBusyDriversList!.trackingDrivers![index];

                                  return GestureDetector(
                                      onTap: () {
                                        // Wrap the logic in a post-frame callback to avoid the build collision
                                        WidgetsBinding.instance.addPostFrameCallback((_) {

                                          // 1. Remove the existing marker
                                          controller.markers.removeWhere((marker) {
                                            return marker is CustomMarker &&
                                                marker.withReturnType == "driverMarker" &&
                                                marker.child is Stack &&
                                                (marker.child as Stack).children.any((widget) =>
                                                widget is Text && widget.data == driverIndex.username);
                                          });

                                          // 2. Add the new updated marker
                                          controller.markers.add(
                                            CustomMarker(
                                              withReturnType: "driverMarker",
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  const Image(
                                                    image: AssetImage("assets/car3.png"),
                                                    width: 70,
                                                    height: 70,
                                                  ),
                                                  Text(
                                                    "${driverIndex.username}",
                                                    style: const TextStyle(fontSize: 12, color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              type: "driverMarker",
                                              point: LatLng(
                                                double.parse(driverIndex.latitude!),
                                                double.parse(driverIndex.longitude!),
                                              ),
                                              width: 70,
                                              height: 70,
                                            ),
                                          );

                                          final target = LatLng(
                                            double.parse(driverIndex.latitude!),
                                            double.parse(driverIndex.longitude!),
                                          );

                                          controller.mapController.move(target, 16);

                                          // Now it is safe to update the state
                                          controller.update();
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        });
                                      },
                                      child: _driverTile(driverIndex.username!, driverIndex.bookingStatus!));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  // Baki widgets (_actionButton, _driverTile) wese hi rahen ge...
  Widget _actionButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
              style: mozillaTextSemiBoldText(fontSize: 14, fontWeight: FontWeight.w700),
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
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.send_outlined, size: 16, color: Color(0xff424899)),
        ],
      ),
    );
  }
}