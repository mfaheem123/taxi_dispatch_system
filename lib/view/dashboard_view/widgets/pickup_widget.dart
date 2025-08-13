


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../Controller/dashboard_controller.dart';

class PickupWidget extends StatefulWidget {
  PickupWidget({super.key});

  @override
  State<PickupWidget> createState() => _PickupWidgetState();
}

class _PickupWidgetState extends State<PickupWidget> {
  String selectedMenu = "";
  String selectedDropdownItem = "";

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;


    return GetBuilder<DashboardController>(
      builder: (controller) {
        return  LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
              bool isWeb = constraints.maxWidth >= 1024;

              double pickupWidth = isMobile
                  ? constraints.maxWidth * 0.9
                  : isTablet
                  ? constraints.maxWidth / 2.5
                  : constraints.maxWidth / 3.5;

              double notesWidth = isMobile
                  ? constraints.maxWidth * 0.9
                  : isTablet
                  ? constraints.maxWidth / 4
                  : constraints.maxWidth / 8;
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                  child: Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center, // ✅ match alignment
                    children: [
                      // Label
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          AppText.pick,
                          style: mozillaTextSemiBoldText(
                            context: context,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Pickup Field
                      SizedBox(
                        width: pickupWidth,
                        height: 30, // ✅ same height
                        child: RawKeyboardListener(
                          focusNode: controller.pickupKeyboardFocusNode,
                          onKey: (event) {
                            if (event is RawKeyDownEvent) {
                              if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                                  controller.highlightedIndex.value <
                                      controller.suggestions.length - 1) {
                                controller.highlightedIndex.value++;
                              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                                  controller.highlightedIndex.value > 0) {
                                controller.highlightedIndex.value--;
                              } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                final selected = controller
                                    .suggestions[controller.highlightedIndex.value];
                                controller.selectSuggestion(selected);
                              }
                            }
                          },
                          child: Focus(
                            focusNode: controller.pickupFocusNode,
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                controller.activeFieldKey.value =
                                    controller.pickupFieldKey;
                              }
                            },
                            child: CustomTextField(
                              key: controller.pickupFieldKey,
                              borderRadius: 6,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              controller: controller.PickupController,
                              focusNode: controller.pickupTextFieldFocusNode,
                              onChanged: controller.onInputChanged,
                              prefixIcon: const Icon(Icons.location_pin, color: Colors.red),
                              hintText: 'PICKUP LOCATION',
                      suffixIcon: IconButton(

                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.grey.shade100),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        onPressed: () {
                          String temPic = controller.PickupController.text;
                          String temDrop = controller.DropoffController.text;
                          controller.PickupController.text = temDrop;
                          controller.DropoffController.text = temPic;
                          controller.update();
                        },
                        icon: const Icon(Icons.swap_vert,
                            color: Color(0xFF575797), size: 20),
                      ),
                            ),
                          ),
                        ),
                      ),

                      // Swap Button


                      SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),

                      // Select Plot Button
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              width: notesWidth,
                            height: 30, // ✅ match field height
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: DynamicColors.primaryClr, width: 1.2),
                            ),
                            child:CustomDropdownButton(
                              itemList: ["BASE NE7", "WILLESDEN"],
                              hintText: "SELECT PLOT",
                            )
                          ),
                        ),
                      ),

                      SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),

                      // Extra Text Field
                      SizedBox(
                        width: notesWidth,
                        height: 30, // ✅ match height
                        child: CustomTextField(
                          hintText: "PICKUP NOTES",
                          borderRadius: 6,
                          controller: TextEditingController(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                SingleChildScrollView(
                  scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                  child: Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center, // ✅ match alignment
                    children: [
                      // Label
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          AppText.drop,
                          style: mozillaTextSemiBoldText(
                            context: context,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Pickup Field
                      SizedBox(
                        width: pickupWidth,
                        height: 30, // ✅ same height
                        child: RawKeyboardListener(
                          focusNode: controller.pickupKeyboardFocusNode,
                          onKey: (event) {
                            if (event is RawKeyDownEvent) {
                              if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                                  controller.highlightedIndex.value <
                                      controller.suggestions.length - 1) {
                                controller.highlightedIndex.value++;
                              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                                  controller.highlightedIndex.value > 0) {
                                controller.highlightedIndex.value--;
                              } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                final selected = controller
                                    .suggestions[controller.highlightedIndex.value];
                                controller.selectSuggestion(selected);
                              }
                            }
                          },
                          child: Focus(
                            focusNode: controller.dropoffFocusNode,
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                controller.activeFieldKey.value =
                                    controller.dropoffFieldKey;
                              }
                            },
                            child: CustomTextField(
                              key: controller.dropoffFieldKey,
                              borderRadius: 6,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              controller: controller.DropoffController,
                              focusNode: controller.dropoffTextFieldFocusNode,
                              onChanged: controller.onInputChanged,
                              prefixIcon: const Icon(Icons.location_pin, color: Colors.red),
                              hintText: 'Drop Location',
                          suffixIcon: IconButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.grey.shade100),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            onPressed: () {
                              String temPic = controller.PickupController.text;
                              String temDrop = controller.DropoffController.text;
                              controller.PickupController.text = temDrop;
                              controller.DropoffController.text = temPic;
                              controller.update();
                            },
                            icon: const Icon(Icons.swap_vert,
                                color: Color(0xFF575797), size: 20),
                          ),
                            ),
                          ),
                        ),
                      ),


                      SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),

                      // Select Plot Button
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              width: notesWidth,
                              height: 30, // ✅ match field height
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: DynamicColors.primaryClr, width: 1.2),
                              ),
                              child:CustomDropdownButton(
                                itemList: ["BASE NE7", "WILLESDEN"],
                                hintText: "SELECT PLOT",
                              )
                          ),
                        ),
                      ),

                      SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),

                      // Extra Text Field
                      SizedBox(
                        width: notesWidth,
                        height: 30, // ✅ match height
                        child: CustomTextField(
                          hintText: "DROP NOTES",
                          borderRadius: 6,
                          controller: TextEditingController(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        );
      }
    );
  }

  Widget buildMenuTab(IconData icon, String label, String menuKey,
      List<String> items, GlobalKey key) {
    return GestureDetector(
      key: key,
      onTap: () async {
        setState(() {
          selectedMenu = menuKey;
        });

        final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final Size size = renderBox.size;

        final selected = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            offset.dx,
            offset.dy + size.height,
            offset.dx + size.width,
            offset.dy,
          ),
          items: items
              .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          elevation: 8.0,
        );

        if (selected != null) {
          setState(() {
            selectedDropdownItem = selected;
          });
          // if (onMenuSelect != null) {
          //   onMenuSelect!(selected);
          // }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          // color: selectedMenu == menuKey
          //     ? Colors.cyanAccent.shade400
          //     : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: DynamicColors.textClr,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
