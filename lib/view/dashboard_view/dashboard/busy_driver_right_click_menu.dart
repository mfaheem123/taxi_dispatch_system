import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../component/marker_class.dart';
import '../../../controller/fob_controller.dart';
import '../../../utils/open_edit_booking_tab.dart';
import '../Controller/dashboard_controller.dart';
import '../models/dashboard_model.dart';

String _statusCarImage(String status) {
  switch (status) {
    case "Accepted":
      return "assets/c.png";
    case "Arrived":
      return "assets/d.png";
    case "On Route":
      return "assets/tracking_car.png";
    case "STC":
      return "assets/a.png";
    default:
      return "assets/green.jpeg";
  }
}

void showContextMenuOnBusyDriver(
  BuildContext context,
  Offset offset, {
  DashboardDriverObject? driver,
  int? index,
}) {
  final DashboardController controller = Get.find<DashboardController>();
  final fobController = Get.isRegistered<FobController>()
      ? Get.find<FobController>()
      : Get.put(FobController());
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
    color: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    items: [
      _buildMenuItem(1, Icons.near_me_outlined, "TRACK"),
      // _buildMenuItem(2, Icons.person_off_outlined, "SINBIN"),
      _buildMenuItem(3, Icons.refresh_rounded, "RECOVER"),
      _buildMenuItem(4, Icons.check_circle_outline, "COMPLETE"),
      _buildMenuItem(5, Icons.person_remove_outlined, "NO SHOW"),
      _buildMenuItem(6, Icons.signpost_outlined, "NO PICKUP"),
      _buildMenuItem(7, Icons.search_outlined, "VIEW JOB"),
      // _buildMenuItem(8, Icons.logout_outlined, "LOGOUT"),
      _buildMenuItem(9, Icons.phone_in_talk_outlined, "CALL DRIVER"),
    ],
  ).then((value) async {
    if (value == 1) {
      if (driver?.latitude != null && driver?.longitude != null) {
        controller.markers.removeWhere((m) => m.type == "driverMarker");
        controller.markers.add(
          CustomMarker(
            withReturnType: "driverMarker",
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  _statusCarImage(driver?.bookingStatus ?? ""),
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
                Text(
                  "${driver!.username}",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                )
              ],
            ),
            type: "driverMarker",
            point: LatLng(
              double.parse(driver.latitude!),
              double.parse(driver.longitude!),
            ),
            width: 70,
            height: 70,
          ),
        );

        final target = LatLng(
          double.parse(driver.latitude!),
          double.parse(driver.longitude!),
        );
        controller.mapController.move(target, 16);
      }
      debugPrint("TRACK tapped for busy driver: ${driver?.username}");
    }
    // else if (value == 2) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => SinbinDriverAlert(driver: driver),
    //   );
    // }
    else if (value == 3) {
      if (driver?.id != null) {
        controller.checkAndRecoverActiveBooking(driver!.id);
      }
      debugPrint("RECOVER tapped for busy driver: ${driver?.username}");
    } else if (value == 4) {
      if (driver?.id != null) {
        controller.checkCompleteActiveBooking(driver!.id);
      }
      debugPrint("COMPLETE tapped for busy driver: ${driver?.username}");
    } else if (value == 5) {

      if (driver?.id != null) {
        controller.checkNoShowActiveBooking(driver!.id);
      }
      debugPrint("NO SHOW tapped for busy driver: ${driver?.username}");
    } else if (value == 6) {

      if (driver?.id != null) {
        controller.checkNoPickupActiveBooking(driver!.id);
      }
      debugPrint("NO PICKUP tapped for busy driver: ${driver?.username}");
    } else if (value == 7) {
      if (driver?.id != null) {
        final bookingId = await controller.getActiveBookingId(driver!.id);
        if (bookingId != null) {
          openEditBookingTab(bookingId.toString());
        } else {
          BotToast.showText(text: "No active booking found for this driver");
        }
      }
      debugPrint("VIEW JOB tapped for busy driver: ${driver?.username}");
    }
    // else if (value == 8) {
    //   if (driver?.id != null) {
    //     await controller.forceLogoutDriver(driver!.id!);
    //   }
    // }
    else if (value == 9) {

      debugPrint("CALL DRIVER tapped for busy driver: ${driver?.username}");
    }
  });
}

// Helper Widget Item
PopupMenuItem _buildMenuItem(int value, IconData icon, String title) {
  return PopupMenuItem(
    value: value,
    height: 38,
    child: Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1E293B)),
        const SizedBox(width: 10),
        Text(
          title,
          style: outFitRegular(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    ),
  );
}
