

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' as material;

import '../../component/suggestion_widget/suggestion_controller.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/dashboard/drivers.dart';
import '../dashboard_view/dashboard/map_view_widget.dart';
import '../locations_view/controller/locations_controller.dart';
import 'dashboard_form_widget.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  final LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());
  DashboardController controller = Get.find();

  SuggestionController suggestion_controller =
  Get.isRegistered<SuggestionController>()
      ? Get.find<SuggestionController>()
      : Get.put(SuggestionController());

  @override
  void initState() {
    // TODO: implement initState
    controller = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());
    super.initState();
    if (controller.dashboardAllData == null) {
      controller.dashboardData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1024;
    final isTablet  = w >= 640 && w < 1024;

    return GetBuilder<DashboardController>(initState: (v) {

      controller.seeZoneOnMapp();
      // controller.getMobileNumberWithName();
      if (_controller.locationtypezoneModel == null) {
        _controller.getLocationTypeZone();
      }
    }, builder: (controller) {
      return controller.dashboardAllData == null
          ? material.Center(child: CircularProgressIndicator())
          : SafeArea(
        child: isDesktop
        // ── DESKTOP: booking 50% | drivers 20% | map 30% ──
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: BookingFormScreen()),
            Expanded(flex: 2, child: DriversView()),
            Expanded(flex: 3, child: MapViewWidget()),
          ],
        )

        // ── TABLET / iPAD: booking full width, others stacked below ──
            : isTablet
            ? SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                child: BookingFormScreen(),
              ),
              SizedBox(height: 320, child: DriversView()),
              SizedBox(height: 420, child: MapViewWidget()),
            ],
          ),
        )

        // ── MOBILE: everything stacked in a column ──
            : SingleChildScrollView(
          child: Column(
            children: [
              const BookingFormScreen(),
              SizedBox(height: 300, child: DriversView()),
              SizedBox(height: 380, child: MapViewWidget()),
            ],
          ),
        ),
      );
    });
  }
}
