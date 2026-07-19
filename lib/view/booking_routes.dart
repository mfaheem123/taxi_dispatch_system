import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingRoutesAlert {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 1000,
            height: 600,
            padding: const EdgeInsets.all(24.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "BOOKING ROUTES",
                  style: mozillaTextSemiBoldText(
                    fontSize: 28,
                    color: const Color(0xFF101B2E),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Panel
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F9F5), // Light mint color
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                child: Text(
                                  "NORMAL ROUTES",
                                  style: mozillaTextSemiBoldText(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Route Items
                              Expanded(
                                child: ListView(
                                  children: [
                                    _buildRouteItem(
                                      routeNum: "1",
                                      pickup: "CAMBRIDGE RD, HASTINGS, UK",
                                      dropoff: "FORTRESS RD, LONDON NW5 1AA, UK",
                                      time: "128 MIN",
                                      distance: "73.1 MI",
                                      fare: "149.28",
                                    ),
                                    Divider(height: 1, color: Colors.grey.shade300),
                                    _buildRouteItem(
                                      routeNum: "2",
                                      pickup: "CAMBRIDGE RD, HASTINGS, UK",
                                      dropoff: "FORTRESS RD, LONDON NW5 1AA, UK",
                                      time: "138 MIN",
                                      distance: "84.0 MI",
                                      fare: "171.08",
                                    ),
                                    Divider(height: 1, color: Colors.grey.shade300),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Right Panel (Map)
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(51.5074, -0.1278), // London coordinates
                              zoom: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildRouteItem({
    required String routeNum,
    required String pickup,
    required String dropoff,
    required String time,
    required String distance,
    required String fare,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Info
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.directions, Colors.green, "ROUTE #: $routeNum", isBold: true),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on_outlined, Colors.green, pickup),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on_outlined, Colors.red, dropoff),
              ],
            ),
          ),
          // Right Info
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildInfoRow(Icons.access_time, Colors.orange, "TIME: $time", alignRight: true, isBold: true),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.straighten, Colors.orange, "DISTANCE: $distance", alignRight: true, isBold: true),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.currency_pound, Colors.purple, "FARES: $fare", alignRight: true, isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(IconData icon, Color iconColor, String text, {bool alignRight = false, bool isBold = false}) {
    final textWidget = Text(
      text,
      style: mozillaTextSemiBoldText(
        fontSize: 12,
        color: Colors.grey.shade800,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
      ),
    );

    if (alignRight) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 8),
          textWidget,
        ],
      );
    } else {
      return Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 8),
          Expanded(child: textWidget),
        ],
      );
    }
  }
}
