import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../component/color.dart';
import '../../../component/marker_class.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../Controller/dashboard_controller.dart';
import '../models/tracking_drivers_model.dart';

class ViewDriversMap extends StatefulWidget {
  const ViewDriversMap({super.key});

  @override
  State<ViewDriversMap> createState() => _ViewDriversMapState();
}

class _ViewDriversMapState extends State<ViewDriversMap> {
  final dashBoardCntrl = Get.find<DashboardController>();

  late final MapController mapController;
  int? selectTrackingCarId;

  /// Reactive marker list
  final RxList<CustomMarker> trackingMarkers = <CustomMarker>[].obs;
  WebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    dashBoardCntrl.getAllDriversTracking();
    trackingDriverSocket();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  void trackingDriverSocket() {
    final url = Uri.parse("$socketUrl/driver-tracking-dashboard");
    try {
      _channel = WebSocketChannel.connect(url);

      _channel!.stream.listen(
            (message) {
          final data = jsonDecode(message);
          if (data['event'] == 'DRIVER_LOCATION_UPDATE' ||
              data['event'] == "DRIVER_BOOKING_STATUS_UPDATE") {
            int indexxx = trackingMarkers
                .indexWhere((test) => test.id == data['data']['id']);

            if (indexxx == -1) return;

            double lat = double.parse(data['data']['latitude'].toString());
            double lng = double.parse(data['data']['longitude'].toString());
            final target = LatLng(lat, lng);

            final oldMarker = trackingMarkers[indexxx];

            int indexes = dashBoardCntrl
                .onlineBusyDriversList!.trackingDrivers!
                .indexWhere((test) => test.id == data['data']['id']);

            TrackingDriverObject objectData =
            dashBoardCntrl.onlineBusyDriversList!.trackingDrivers![indexes];

            objectData.latitude = lat.toString();
            objectData.longitude = lng.toString();
            objectData.bookingStatus = data['data']['booking_status'];

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
                  Icon(
                    Icons.directions_car,
                    size: 70,
                    color: _statusColor(objectData.bookingStatus),
                  ),
                  Container(
                    color: _statusColor(objectData.bookingStatus),
                    padding: const EdgeInsets.only(
                        bottom: 10.0, left: 4, right: 4),
                    child: Text(
                      objectData.username ?? "",
                      style: const TextStyle(
                          fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );

            setState(() {});
          }
        },
        onError: (error) => print("Connection Error: $error"),
        onDone: () {
          trackingDriverSocket();
          print("🔌 Socket Disconnected");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case "Accepted":
        return Colors.orange;
      case "Arrived":
        return Colors.yellow;
      case "On Route":
        return Colors.red;
      case "STC":
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAP
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(51.2709722, 0.1893883),
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

                /// Reactive markers
                MarkerLayer(
                  markers: trackingMarkers,
                ),
              ],
            ),
          ),

          /// DRIVER LIST SIDEBAR
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 250,
              height: Get.height,
              color: DynamicColors.whiteClr,
              child: Column(
                children: [
                  /// Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppText.drivers.toUpperCase(),
                          style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  /// Driver list
                  Expanded(
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
                            final driver = controller.onlineBusyDriversList!
                                .trackingDrivers![index];

                            return GestureDetector(
                              onTap: () {
                                final lat = double.parse(driver.latitude!);
                                final lng = double.parse(driver.longitude!);
                                final target = LatLng(lat, lng);

                                /// Remove old marker for this driver
                                trackingMarkers.removeWhere((marker) =>
                                marker.id.toString() ==
                                    controller.onlineBusyDriversList!
                                        .trackingDrivers![index].id
                                        .toString());

                                /// Add updated marker
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
                                        Icon(
                                          Icons.directions_car,
                                          size: 70,
                                          color: _statusColor(
                                              driver.bookingStatus),
                                        ),
                                        Container(
                                          color: _statusColor(
                                              driver.bookingStatus),
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0,
                                              left: 4,
                                              right: 4),
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

                                /// Move map
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
          ),
        ],
      ),
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
              color: const Color(0xff424899),
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
          const Icon(Icons.send_outlined,
              size: 16, color: Color(0xff424899)),
        ],
      ),
    );
  }
}