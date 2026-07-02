

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../alert/child_seats_alert.dart';
import '../../../alert/send_email_alert.dart';
import '../../../component/marker_class.dart';
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
  // Use the shared focus node from the controller so the Home button's
  // Tab intercept (in dashboard_form_widget.dart) can hand focus directly
  // to this panel without going through FocusTraversalGroup.
  late final FocusNode _focusNode =
      Get.find<DashboardController>().driverPanelFocusNode;

  // Separate focus node for the first icon so it can receive keyboard focus
  // independently and show a visual ring.
  final FocusNode _firstIconFocusNode = FocusNode(debugLabel: 'DriverIcon0');

  final List<IconData> headerIcons = [
    Icons.reset_tv_outlined,
    Icons.refresh,
    Icons.visibility_off_sharp,
    Icons.mail,
    Icons.send,
    Icons.share,
  ];

  int selectedHeaderIndex = 0;
  bool isHeaderMode = true;

  @override
  void initState() {
    super.initState();
    // Do NOT auto-request focus here — focus should arrive only via Tab
    // navigation from the Home button, not on every widget build.
  }

  @override
  void dispose() {
    // _focusNode is owned by DashboardController — do NOT dispose it here.
    _firstIconFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return RawKeyboardListener(
          // Using the shared driverPanelFocusNode lets the Home button hand
          // focus directly here via requestFocus().
          focusNode: _focusNode,
          onKey: (event) {
            if (event is RawKeyDownEvent) {
              shortCutKeyValue.value = "driverIconSelect";
              if (shortCutKeyValue.value == "driverIconSelect") {
                // When the panel first receives focus from the Home button,
                // move focus to the first icon so it is visually highlighted.
                if (!_firstIconFocusNode.hasFocus) {
                  _firstIconFocusNode.requestFocus();
                }
                if (event.logicalKey == LogicalKeyboardKey.tab) {
                  setState(() {
                    isHeaderMode = !isHeaderMode;
                  });
                } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  if (isHeaderMode) {
                    if (selectedHeaderIndex < headerIcons.length - 1) {
                      setState(() => selectedHeaderIndex++);
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
                      setState(() => selectedHeaderIndex--);
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
                  } else {
                    debugPrint(
                        "Enter pressed on Driver ${controller.selectedDriverIndex}");
                  }
                }
              }
            }
          },
          child: Card(
            elevation: 4,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // The driver list uses an Expanded child, which needs a
                // bounded height. Fill the available height when it is
                // bounded; fall back to a fixed height in an unbounded
                // (scrollable) parent so the layout never breaks.
                return SizedBox(
                  height: constraints.maxHeight.isFinite
                      ? constraints.maxHeight
                      : 400,
                  child: Column(
              children: [
                // ----- Header -----
                Container(
                  height: 40,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: DynamicColors.secondaryClr,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Driver".toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: headingText(
                            fontSize: 14,
                            latterSpacing: 1.0,
                            color: DynamicColors.primaryClr,
                          ),
                        ),
                      ),
                      // Icons row — scrolls horizontally if it can't fit
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: headerIcons.asMap().entries.map((entry) {
                              final index = entry.key;
                              final icon = entry.value;
                              final isSelected =
                                  isHeaderMode && selectedHeaderIndex == index;

                              void activate() {
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
                                debugPrint(
                                    "Clicked on header icon index $index");
                              }

                              // The first icon is the keyboard entry-point for
                              // the Driver panel. It owns _firstIconFocusNode so
                              // the panel's RawKeyboardListener can still handle
                              // arrow-key / Enter navigation while _firstIconFocusNode
                              // shows a visual focus ring and accepts Enter/Space.
                              if (index == 0) {
                                return Focus(
                                  focusNode: _firstIconFocusNode,
                                  onKeyEvent: (node, event) {
                                    if (event is KeyDownEvent &&
                                        (event.logicalKey ==
                                                LogicalKeyboardKey.enter ||
                                            event.logicalKey ==
                                                LogicalKeyboardKey.space)) {
                                      activate();
                                      return KeyEventResult.handled;
                                    }
                                    return KeyEventResult.ignored;
                                  },
                                  child: Builder(
                                    builder: (ctx) {
                                      final hasFocus =
                                          Focus.of(ctx).hasFocus;
                                      return GestureDetector(
                                        onTap: activate,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? Colors.blue.shade200
                                                : Colors.transparent,
                                            // Visible focus ring when focused
                                            // via keyboard.
                                            border: hasFocus
                                                ? Border.all(
                                                    color: Colors.blue,
                                                    width: 2,
                                                  )
                                                : null,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Icon(
                                            icon,
                                            size: 18,
                                            color: DynamicColors.primaryClr,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }

                              // All other icons remain plain GestureDetectors.
                              return GestureDetector(
                                onTap: activate,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Colors.blue.shade200
                                        : Colors.transparent,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  margin:
                                  const EdgeInsets.symmetric(horizontal: 2),
                                  child: Icon(
                                    icon,
                                    size: 18,
                                    color: DynamicColors.primaryClr,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ----- Tabs -----
                Container(
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
                                  backgroundColor: DynamicColors.greenClr,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${controller.onlineDriversList.length}",
                                  style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: controller.driverSelectionTab
                                        .value ==
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
                                  backgroundColor: DynamicColors.redClr,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${controller.busyDriversList.length}",
                                  style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: controller.driverSelectionTab
                                        .value !=
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
                    ],
                  ),
                ),

                // ----- Driver List -----
                Expanded(
                  child: Obx(
                        () {
                      final isActive =
                          controller.driverSelectionTab.value == "activeDriver";
                      final list = isActive
                          ? controller.onlineDriversList
                          : controller.busyDriversList;

                      return ListView.builder(
                        itemCount: list.length,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, index) {
                          final driver = list[index];

                          String timeOnline = "";
                          if (driver.lastLoginAt != null) {
                            timeOnline = formatDurationss(
                              DateTime.now().difference(driver.lastLoginAt!),
                            );
                          }

                          return GestureDetector(
                            onSecondaryTapDown: (details) {
                              _showContextMenu(
                                context,
                                details.globalPosition,
                                driver,
                                index: index,
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        driver.username ?? "",
                                        style: mozillaTextRegularText(
                                            fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        driver.vehicleType ?? "",
                                        textAlign: TextAlign.center,
                                        style: mozillaTextRegularText(
                                            fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        timeOnline,
                                        textAlign: TextAlign.right,
                                        style: mozillaTextRegularText(
                                            fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showContextMenu(
      BuildContext context,
      Offset offset,
      DashboardDriverObject? driver, {
        int? index,
      }) async {
    final left = offset.dx;
    final top = offset.dy;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left, top),
      items: const [
        PopupMenuItem(value: 1, height: 12, child: Text("TRACK")),
        PopupMenuItem(value: 2, height: 12, child: Text("SINBIN")),
        PopupMenuItem(value: 3, height: 12, child: Text("FORCE BREAK")),
        PopupMenuItem(value: 4, height: 12, child: Text("LOGOUT")),
        PopupMenuItem(value: 5, height: 12, child: Text("CALL DRIVER")),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 1) {
        final DashboardController _controller = Get.find();

        _controller.markers.add(
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
                  "${driver!.username}",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
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
          double.parse(driver!.latitude!),
          double.parse(driver.longitude!),
        );
        _controller.mapController.move(target, 16);

        setState(() {});
        debugPrint("Tapped on marker ${driver.latitude}, ${driver.longitude}");
      } else if (value == 2) {
        debugPrint("Assigning task...");
      }
    });
  }
}
