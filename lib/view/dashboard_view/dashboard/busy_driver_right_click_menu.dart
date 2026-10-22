import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Model/driver_models/single_driver_model.dart';
import '../../../component/color.dart';
import '../../../component/marker_class.dart';
import '../../../component/networks/api.dart';
import '../../../utils/open_edit_booking_tab.dart';
import '../../administration/model/user_model.dart';
import '../../setting/model/getManageExtrntionModel.dart' hide Employee;
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
    /// Tracking
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
    /// RECOVER
    else if (value == 3) {
      if (driver?.id != null) {
        controller.checkAndRecoverActiveBooking(driver!.id);
      }
      debugPrint("RECOVER tapped for busy driver: ${driver?.username}");
    }
    /// COMPLETE
    else if (value == 4) {
      if (driver?.id != null) {
        controller.checkCompleteActiveBooking(driver!.id);
      }
      debugPrint("COMPLETE tapped for busy driver: ${driver?.username}");
    }
    /// NO SHOW
    else if (value == 5) {
      if (driver?.id != null) {
        controller.checkNoShowActiveBooking(driver!.id);
      }
      debugPrint("NO SHOW tapped for busy driver: ${driver?.username}");
    }
    /// NO PICKUP
    else if (value == 6) {
      if (driver?.id != null) {
        controller.checkNoPickupActiveBooking(driver!.id);
      }
      debugPrint("NO PICKUP tapped for busy driver: ${driver?.username}");
    }
    /// No active
    else if (value == 7) {
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
    /// CALL DRIVER
    else if (value == 9) {
      if (context.mounted) {
        // showDriverCallExtensionDialog(context, driver: driver);
      }
      debugPrint("CALL DRIVER tapped for busy driver: ${driver?.username}");
    }
  });
}

/// Call Driver Extension Alert for VipVoip Companion
void showDriverCallExtensionDialog(
  BuildContext context, {
  DashboardDriverObject? driver,
}) {
  final TextEditingController phoneController = TextEditingController(text: "");
  bool isFetchingNumber = true;
  bool isFetchingExtensions = true;

  final String activeExtension = Employee.selectedEmployee?.extensionNumber ?? "";
  String selectedExtension = activeExtension;

  List<String> availableExtensions = activeExtension.isNotEmpty ? [activeExtension] : [];

  // Fetch driver phone number from `drivers/getbyid/$driverId` API
   fetchDriverPhone(void Function(void Function()) setDialogState) async {
    if (driver?.id == null) {
      setDialogState(() => isFetchingNumber = false);
      return;
    }
    try {
      final response = await Api().get("drivers/getbyid/${driver!.id}");
      if (response != null && response.statusCode == 200) {
        final result = SingleDriverModel.fromJson(response.data);
        if (result.status == true && result.driver != null) {
          final number = result.driver!.mobile ?? result.driver!.telephone ?? "";
          phoneController.text = number;
        }
      }
    } catch (e) {
      debugPrint("Error fetching driver phone from drivers/getbyid: $e");
    } finally {
      setDialogState(() => isFetchingNumber = false);
    }
  }

  // Fetch extensions from `employeeextension/get` API
   fetchExtensions(void Function(void Function()) setDialogState) async {
    try {
      final response = await Api().get("employeeextension/get", sendCompanyId: true);
      if (response != null && response.statusCode == 200) {
        final model = GetManageExtentionModel.fromJson(response.data);
        if (model.status == true && model.employeeExtensions != null) {
          final currentEmpId = Employee.selectedEmployee?.id;
          final list = model.employeeExtensions!;

          // Filter extensions for current logged-in employee if available
          final empExts = list
              .where((e) => currentEmpId == null || e.employeeId == currentEmpId || e.employee?.id == currentEmpId)
              .map((e) => e.extensionNumber?.trim() ?? "")
              .where((ext) => ext.isNotEmpty)
              .toList();

          final allExts = list
              .map((e) => e.extensionNumber?.trim() ?? "")
              .where((ext) => ext.isNotEmpty)
              .toList();

          final fetchedList = (empExts.isNotEmpty ? empExts : allExts).toSet().toList();

          if (fetchedList.isNotEmpty) {
            setDialogState(() {
              availableExtensions = fetchedList;
              if (selectedExtension.isEmpty || !availableExtensions.contains(selectedExtension)) {
                selectedExtension = availableExtensions.first;
              }
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching extensions: $e");
    } finally {
      setDialogState(() {
        isFetchingExtensions = false;
        if (availableExtensions.isEmpty) {
          if (activeExtension.isNotEmpty) {
            availableExtensions = [activeExtension];
            selectedExtension = activeExtension;
          } else {
            availableExtensions = ["---"];
            selectedExtension = "---";
          }
        }
      });
    }
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: StatefulBuilder(
        builder: (context, setState) {
          // Trigger API fetches once on dialog initialization
          if (isFetchingNumber && phoneController.text.isEmpty) {
            fetchDriverPhone(setState);
          }
          if (isFetchingExtensions) {
            fetchExtensions(setState);
          }

          return Container(
            width: 420,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone_in_talk_rounded, color: DynamicColors.primaryClr, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          "CHOOSE EXTENSION",
                          style: mozillaTextSemiBoldText(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, size: 20, color: Color(
                          0xFF580404)),
                    ),
                  ],
                ),
                const Divider(height: 20, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 10),

                // Driver Details
                if (driver?.username != null || driver?.name != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, size: 18, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(
                            "DRIVER: ${driver?.name ?? driver?.username ?? ''}",
                            style: outFitRegular(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Select Extension
                Text(
                  "SELECT EXTENSION",
                  style: outFitRegular(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                isFetchingExtensions
                    ? Container(
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Loading extension...",
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: availableExtensions.contains(selectedExtension)
                                ? selectedExtension
                                : (availableExtensions.isNotEmpty ? availableExtensions.first : null),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                            items: availableExtensions.map((ext) {
                              return DropdownMenuItem<String>(
                                value: ext,
                                child: Text(
                                  ext,
                                  style: outFitRegular(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  selectedExtension = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                const SizedBox(height: 16),

                // Driver Phone / Mobile Number
                Text(
                  "DRIVER PHONE NUMBER",
                  style: outFitRegular(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                isFetchingNumber
                    ? Container(
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Fetching driver phone number...",
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      )
                    : TextField(
                        controller: phoneController,
                        readOnly: true,
                        keyboardType: TextInputType.phone,
                        style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: "ENTER PHONE / MOBILE NUMBER",
                          hintStyle: outFitRegular(fontSize: 13, color: const Color(0xFF94A3B8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          prefixIcon: const Icon(Icons.phone_android, size: 18, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: DynamicColors.primaryClr, width: 2),
                          ),
                        ),
                      ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DynamicColors.greenClr,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DynamicColors.primaryClr,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () async {
                        final phoneNum = phoneController.text.trim();
                        if (phoneNum.isEmpty) {
                          BotToast.showText(text: "PLEASE ENTER DRIVER PHONE NUMBER");
                          return;
                        }

                        Get.back();

                        // Trigger Direct Call and bring VipVoip Companion window to the top
                        final cleanNumber = phoneNum.replaceAll(RegExp(r'[^\d+]'), '');
                        final vipVoipUri = Uri.parse("vipvoip:$cleanNumber");
                        final v4voipUri = Uri.parse("v4voip:$cleanNumber");
                        final telUri = Uri.parse("tel:$cleanNumber");

                        try {
                          if (await canLaunchUrl(vipVoipUri)) {
                            await launchUrl(
                              vipVoipUri,
                              mode: LaunchMode.externalNonBrowserApplication,
                            );
                          } else if (await canLaunchUrl(v4voipUri)) {
                            await launchUrl(
                              v4voipUri,
                              mode: LaunchMode.externalNonBrowserApplication,
                            );
                          } else if (await canLaunchUrl(telUri)) {
                            await launchUrl(
                              telUri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            await launchUrl(
                              vipVoipUri,
                              mode: LaunchMode.externalNonBrowserApplication,
                            );
                          }
                          BotToast.showText(
                            text: "VIPVOIP CALL STARTED: $cleanNumber (EXT: $selectedExtension)",
                          );
                        } catch (e) {
                          debugPrint("Error launching VipVoip app: $e");
                          try {
                            await launchUrl(vipVoipUri, mode: LaunchMode.externalApplication);
                          } catch (_) {}
                          BotToast.showText(
                            text: "VIPVOIP CALL INITIATED FOR $cleanNumber (EXT: $selectedExtension)",
                          );
                        }
                      },
                      child: const Text(
                        "CALL NOW",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
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
