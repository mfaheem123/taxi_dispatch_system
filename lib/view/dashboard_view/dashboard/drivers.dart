import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/test_icons.dart';

import '../../../alert/child_seats_alert.dart';
import '../../../alert/send_email_alert.dart';
import '../../../component/marker_class.dart';
import '../../../component/short_text.dart';
import '../../../component/textStyle.dart';
import '../../../component/time_duration_method.dart';
import '../Controller/dashboard_controller.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models/dashboard_model.dart';
import 'defult_dashboard_view.dart';

class DriversView extends StatefulWidget {
  const DriversView({super.key});

  @override
  State<DriversView> createState() => _DriversViewState();
}

class _DriversViewState extends State<DriversView> {
  final FocusNode _focusNode = FocusNode();

  // Header icons list
  final List<IconData> headerIcons = [
    Icons.reset_tv_outlined,
    Icons.refresh,
    Icons.visibility_off_sharp,
    Icons.mail,
    Icons.send,
    Icons.share
  ];

  int selectedHeaderIndex = 0; // upar icons ke liye
  bool isHeaderMode =
      true; // true = header select ho raha hai, false = driver list

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return RawKeyboardListener(
          focusNode: _focusNode,
          onKey: (event) {
            // if(shortCutKeyValue.value == ""){
            if (event is RawKeyDownEvent) {
              shortCutKeyValue.value = "driverIconSelect";
              if (shortCutKeyValue.value == "driverIconSelect") {
                if (event.logicalKey == LogicalKeyboardKey.tab) {
                  // Tab dabane se Header <-> Driver list toggle ho jaye
                  setState(() {
                    isHeaderMode = !isHeaderMode;
                  });
                } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  if (isHeaderMode) {
                    if (selectedHeaderIndex < headerIcons.length - 1) {
                      setState(() {
                        selectedHeaderIndex++;
                      });
                    }
                  } else {
                    if (controller.selectedDriverIndex < 3) {
                      controller.selectedDriverIndex++;
                      controller.update();
                    }
                  }
                } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                  if (isHeaderMode) {
                    if (selectedHeaderIndex > 0) {
                      setState(() {
                        selectedHeaderIndex--;
                      });
                    }
                  } else {
                    if (controller.selectedDriverIndex > 0) {
                      controller.selectedDriverIndex--;
                      controller.update();
                    }
                  }
                } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                  if (isHeaderMode) {
                    debugPrint(
                        "Header Icon Selected: ${headerIcons[selectedHeaderIndex]}");
                    // yahan aap har icon ka specific action karwa sakte ho
                  } else {
                    debugPrint(
                        "Enter pressed on Driver ${controller.selectedDriverIndex}");
                    // driver list action
                  }
                }
              }
            }
            // }
          },
          child: SizedBox(
            width: screenWidth >= 1270 ? screenWidth / 5 : screenWidth / 4.8,
            height: containerFormHeight,
            // height: screenHeight >=940? screenHeight * 0.51: screenHeight * 0.80,
            child: Card(
              elevation: 4,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(16),
              // ),
              child: Column(
                children: [
                  // ----- Header -----
                  Container(
                    height: 40,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: DynamicColors.secondaryClr,
                      // borderRadius:
                      // const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Driver".toUpperCase(),
                            style: headingText(
                              fontSize: 14,
                              latterSpacing: 1.0,
                              color: DynamicColors.primaryClr,
                            ),
                          ),
                        ),
                        ...headerIcons.asMap().entries.map((entry) {
                          final index = entry.key;
                          final icon = entry.value;
                          final isSelected =
                              isHeaderMode && selectedHeaderIndex == index;

                          return GestureDetector(
                            onTap: () {
                              if (index == 3) {
                                showDialog(
                                  context: context,
                                  builder: (_) => SendEmailAlert(),
                                );
                              } else if (index == 4) {
                                showDialog(
                                  context: context,
                                  builder: (_) => SendMessageAlert(),
                                );
                              }
                              debugPrint("Clicked on header icon index $index");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Colors.blue.shade200
                                    : Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                icon,
                                size: 18,
                                color: DynamicColors.primaryClr,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // ----- Tabs -----
                  Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: DynamicColors.secondaryClr),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.driverSelectionTab.value =
                                  "activeDriver";
                              controller.update();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              color: controller.driverSelectionTab.value ==
                                      "activeDriver"
                                  ? DynamicColors.primaryClr
                                  : DynamicColors.secondaryClr,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      radius: 6,
                                      backgroundColor: DynamicColors.greenClr),
                                  const SizedBox(width: 6),
                                  // NAME HADER
                                  Text(
                                    "AVAILABLE",
                                    style: mozillaTextRegularText(
                                      fontSize: 13,
                                      color:
                                          controller.driverSelectionTab.value ==
                                                  "activeDriver"
                                              ? DynamicColors.whiteClr
                                              : DynamicColors.primaryClr,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${controller.onlineDriversList.length}",
                                    style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color:
                                          controller.driverSelectionTab.value ==
                                                  "activeDriver"
                                              ? DynamicColors.whiteClr
                                              : DynamicColors.primaryClr,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.driverSelectionTab.value =
                                  "offlineDriver";
                              controller.update();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              color: controller.driverSelectionTab.value !=
                                      "activeDriver"
                                  ? DynamicColors.primaryClr
                                  : DynamicColors.secondaryClr,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      radius: 6,
                                      backgroundColor: DynamicColors.redClr),
                                  const SizedBox(width: 6),
                                  Text(
                                    "BUSY",
                                    style: mozillaTextRegularText(
                                      fontSize: 13,
                                      color:
                                          controller.driverSelectionTab.value !=
                                                  "activeDriver"
                                              ? DynamicColors.whiteClr
                                              : DynamicColors.primaryClr,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${controller.busyDriversList.length}",
                                    style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color:
                                          controller.driverSelectionTab.value !=
                                                  "activeDriver"
                                              ? DynamicColors.whiteClr
                                              : DynamicColors.primaryClr,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: InkWell(
                        //     onTap: () {
                        //     print("AVAILABLE (5)");
                        //
                        //     },
                        //     child: Container(
                        //       padding: const EdgeInsets.symmetric(vertical: 8),
                        //       color:  DynamicColors.secondaryClr,
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           CircleAvatar(
                        //               radius: 6,
                        //               backgroundColor: DynamicColors.redClr),
                        //           const SizedBox(width: 6),
                        //           Text(
                        //             "AVAILABLE (5)",
                        //             style: mozillaTextRegularText(
                        //               fontSize: 10,
                        //               color:
                        //                   DynamicColors.black,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Expanded(
                        //   child: InkWell(
                        //     onTap: () {
                        //       print("BUSY (0)");
                        //     },
                        //     child: Container(
                        //       padding: const EdgeInsets.symmetric(vertical: 8),
                        //       color:   DynamicColors.secondaryClr,
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           CircleAvatar(
                        //               radius: 6,
                        //               backgroundColor: DynamicColors.redClr),
                        //           const SizedBox(width: 6),
                        //           Text(
                        //             "BUSY (0)",
                        //             style: mozillaTextRegularText(
                        //               fontSize: 10,
                        //               color:  DynamicColors.black,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // ----- Driver List -----
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: controller.driverSelectionTab.value !=
                                "activeDriver"
                            ? controller.busyDriversList.length
                            : controller.onlineDriversList.length,
                        padding: EdgeInsets.zero,
                        // padding: const EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, index) {
                          final driver = controller.driverSelectionTab.value !=
                                  "activeDriver"
                              ? controller.busyDriversList[index]
                              : controller.onlineDriversList[index];

                          String timeOnline = "";

                          if (driver.lastLoginAt != null) {
                            timeOnline = formatDurationss(
                              DateTime.now().difference(driver.lastLoginAt!),
                            );
                          }

                          return GestureDetector(
                            onSecondaryTapDown: (details) {
                              _showContextMenu(
                                  context, details.globalPosition, driver,
                                  index: index);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 50,
                                      // height: 20,
                                      decoration: BoxDecoration(
                                        color: DynamicColors.primaryClr,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          (driver.username ?? "").maxLength(6),
                                          style:

                                          mozillaTextRegularText(fontSize: 10, color: DynamicColors.whiteClr, fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      (driver.vehicleType ?? "").maxLength(6),
                                      style:
                                          mozillaTextRegularText(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    IconButton(
                                        padding: EdgeInsets.zero,       // Removes internal padding
                                        constraints: BoxConstraints(),
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.mobile_screen_share,
                                          size: 15,
                                        )),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      (timeOnline ?? ""),
                                      style:
                                          mozillaTextRegularText(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Container(
                                      width: 50,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: DynamicColors.secondaryClr,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child:      Text(
                                                ("POSTCODE").maxLength(6),
                                                style:

                                                mozillaTextRegularText(fontSize: 10, color: DynamicColors.primaryClr, fontWeight: FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //     SizedBox(
                                    //       width: 50,
                                    //       child: Container(
                                    //         height: 32,
                                    //         decoration: BoxDecoration(
                                    //           borderRadius: BorderRadius.circular(4),
                                    //           color: DynamicColors.primaryClr
                                    //         ),
                                    //         child: Center(
                                    //           child: Text("X1",
                                    //             style: mozillaTextRegularText(
                                    //               fontSize: 14,
                                    //               color: DynamicColors.whiteClr,
                                    //             ),
                                    //
                                    //           ),
                                    //         ),
                                    //       ),
                                    //
                                    //
                                    //       // CustomButton(
                                    //       //   height: 28,
                                    //       //   borderRadius: 4,
                                    //       //   verticalPadding: 0,
                                    //       //   btnText: "X1",
                                    //       //   style: mozillaTextRegularText(
                                    //       //     fontSize: 14,
                                    //       //     color: DynamicColors.whiteClr,
                                    //       //   ),
                                    //       // ),
                                    //     ),
                                    //     const SizedBox(width: 10),
                                    //     Expanded(
                                    //       child: Text(
                                    //         "SALOON",
                                    //         style:
                                    //         mozillaTextRegularText(fontSize: 13),
                                    //         overflow: TextOverflow.ellipsis,
                                    //       ),
                                    //     ),
                                    //     const SizedBox(width: 10),
                                    //     const Icon(Icons.phone_android_rounded,
                                    //         size: 18),
                                    //     const SizedBox(width: 10),
                                    //     Expanded(
                                    //       child: Text(
                                    //         "1133Hr 01Min -",
                                    //         style:
                                    //         mozillaTextRegularText(fontSize: 13),
                                    //         overflow: TextOverflow.ellipsis,
                                    //         maxLines: 1,
                                    //       ),
                                    //     ),
                                    //     const SizedBox(width: 10),
                                    // SizedBox(
                                    //   width: 48,
                                    //   child: Container(
                                    //     height: 32,
                                    //     decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.circular(4),
                                    //         color: DynamicColors.secondaryClr
                                    //     ),
                                    //     child: Center(
                                    //       child: Text("-",
                                    //         style: mozillaTextRegularText(
                                    //           fontSize: 14,
                                    //           color: DynamicColors.whiteClr,
                                    //         ),
                                    //
                                    //       ),
                                    //     ),
                                    //   ),
                                    //
                                    //     ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showContextMenu(
      BuildContext context, Offset offset, DashboardDriverObject? driver,
      {index}) async {
    double left = offset.dx;
    double top = offset.dy;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left, top),
      items: [
        PopupMenuItem(
          value: 1,
          height: 12,
          child: Text("TRACK"),
        ),
        PopupMenuItem(
          value: 2,
          height: 12,
          child: Text("SINBIN"),
        ),
        PopupMenuItem(
          value: 3,
          height: 12,
          child: Text("FORCE BREAK"),
        ),
        PopupMenuItem(
          value: 4,
          height: 12,
          child: Text("LOGOUT"),
        ),
        PopupMenuItem(
          value: 5,
          height: 12,
          child: Text("CALL DRIVER"),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      // Handle the action based on the value selected
      if (value == 1) {
        DashboardController _controller = Get.find();

        print(index);
        _controller.markers.add(
          CustomMarker(
            withReturnType: "driverMarker",
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ImageIcon(AssetImage("assets/sedan.png"),
                // color: DynamicColors.greenClr,
                //   size: 65,
                // ),
                Image(
                  image: AssetImage("assets/car3.png"),
                  width: 70,
                  height: 70,
                ),
                Text(
                  "${driver!.username}",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                )
              ],
            ),
            type: "driverMarker",
            point: LatLng(double.parse(driver.latitude!),
                double.parse(driver.longitude!)),
            width: 70,
            height: 70,
          ),
        );

        final target = LatLng(
            double.parse(driver.latitude!), double.parse(driver.longitude!));

        _controller.mapController
            .move(target, 16); // 16 = zoom level (you can adjust)

        debugPrint("Tapped on marker ${driver.latitude}");
        debugPrint("Tapped on marker ${driver.longitude}");
        setState(() {});

        print("Viewing profile of ${driver.username}");
      } else if (value == 2) {
        print("Assigning task...");
      }
    });
  }
}
