



import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ViewDriversMap extends StatelessWidget {
  const ViewDriversMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            width: Get.width,
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
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 250,
              height: Get.height,
              color: DynamicColors.whiteClr,
              child: Column(
                children: [
                  Text(AppText.drivers,
                  style: mozillaTextSemiBoldText(
                    fontSize: 18,
                    fontWeight: FontWeight.w800
                  ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
