

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../alert/child_seats_alert.dart';
import '../../../alert/send_email_alert.dart';
import '../../../component/textStyle.dart';
import '../Controller/dashboard_controller.dart';

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
  bool isHeaderMode = true; // true = header select ho raha hai, false = driver list

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
            // if(controller.shortCutKeyValue.value == ""){
              if (event is RawKeyDownEvent) {
                controller.shortCutKeyValue.value = "driverIconSelect";
                if(controller.shortCutKeyValue.value == "driverIconSelect"){
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
            width: screenWidth >= 1900 ? screenWidth * 0.2 : screenWidth / 2,
            height: screenHeight * 0.465,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // ----- Header -----
                  Container(
                    height: 40,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: DynamicColors.secondaryClr,
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child:  Row(
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
                          final isSelected = isHeaderMode && selectedHeaderIndex == index;

                          return GestureDetector(
                            onTap: () {
                              if(index == 3){
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      SendEmailAlert(),
                                );
                              }else if(index == 4){
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      SendMessageAlert(),
                                );
                              }
                              debugPrint("Clicked on header icon index $index");
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // ----- Tabs -----
                  Container(
                    width: double.infinity,
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
                                      backgroundColor:
                                      DynamicColors.greenClr),
                                  const SizedBox(width: 6),
                                  Text(
                                    "(3)",
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
                                      backgroundColor: DynamicColors.redClr),
                                  const SizedBox(width: 6),
                                  Text(
                                    "(0)",
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
                    child: ListView.builder(
                      itemCount: 4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemBuilder: (context, index) {
                        final isSelected =
                            !isHeaderMode && controller.selectedDriverIndex == index;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: isSelected
                              ? Colors.blue.shade100
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: CustomButton(
                                    height: 28,
                                    borderRadius: 4,
                                    verticalPadding: 0,
                                    btnText: "X1",
                                    style: mozillaTextRegularText(
                                      fontSize: 14,
                                      color: DynamicColors.whiteClr,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "SALOON",
                                    style:
                                    mozillaTextRegularText(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.phone_android_rounded,
                                    size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "1133Hr 01Min -",
                                    style:
                                    mozillaTextRegularText(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 40,
                                  child: CustomButton(
                                    height: 28,
                                    btnColor: DynamicColors.secondaryClr,
                                    borderRadius: 4,
                                    verticalPadding: 0,
                                    btnText: "-",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
}
