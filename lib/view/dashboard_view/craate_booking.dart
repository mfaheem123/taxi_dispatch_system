


import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/pickup_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart' hide KbdActivatable;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/dropdown_button.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import 'Controller/dashboard_controller.dart';
import 'dashboard/shortcut_key_widget.dart';

class CreateBooking extends StatefulWidget {
  const CreateBooking({super.key});

  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {

  String selectedMenu = "";
  String selectedDropdownItem = "";
  DateTime selected = DateTime.now();

  final FocusNode swap1FN = FocusNode();
  final FocusNode swap2FN = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
      print("Controller initialized ✅");
    } else {
      print("Controller already exists, not re-initializing ♻️");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    // Controller initialize only if not already put
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }

    return Scaffold(
      backgroundColor: DynamicColors.whiteClr,
      body: GetBuilder<DashboardController>(
        builder: (controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final bool isMobile = maxWidth < 600;
              final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

              // Instead of fixed width, we calculate flexible field widths
              final double fieldWidth = isMobile
                  ? maxWidth // full width
                  : isTablet
                  ? maxWidth / 2
                  : maxWidth / 4;

              return Center(
                child: Container(
                  width: Get.width/1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: DynamicColors.textClr),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      // Shortcut Keys Row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ShortcutKeyWidget(keyss: "F1", valuess: "BASE ADDRESS"),
                              const SizedBox(width: 10),
                              ShortcutKeyWidget(keyss: "F2", valuess: "BOOKING FORM"),
                              const SizedBox(width: 10),
                              ShortcutKeyWidget(keyss: "F6", valuess: "QUOTATION"),
                              const SizedBox(width: 10),
                              // Add more shortcut buttons here if needed
                            ],
                          ),
                        ),
                      ),

                      // Booking Title
                      // Top Row aligned with fields
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: DynamicColors.gryClr
                        ),
                        child: Wrap(
                          children: [
                            Text(
                              AppText.booking,
                              style: mozillaTextSemiBoldText(fontSize: 17),
                            ),
                            SizedBox(
                              width: fieldWidth/3,
                            ),
                            Container(
                              width: fieldWidth/1.5,
                              height: 35,
                              decoration: BoxDecoration(
                                border:Border.all(color: DynamicColors.primaryClr),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: RestrictedDrivers(
                                width: fieldWidth/1.5,
                                // border: Border(
                                //   bottom: BorderSide(
                                //     color: Colors.grey, // border color
                                //     width: 2.0,        // border thickness
                                //   ),
                                // ),
                                titleText: "SELECT PLOT",
                                driversList: [
                                  "DEMO COMPANY 01",
                                  "DEMO COMPANY 02",
                                  "DEMO COMPANY 03",
                                  "DEMO COMPANY 04",
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      Column(
                        children: [
                          // ================= PICKUP ROW =================
                          Wrap(
                            runSpacing: 10,
                            spacing: 16,
                            children: [
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

                              // (1) Pickup textfield
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(1),
                                child: SizedBox(
                                  width: fieldWidth,
                                  height: 30,
                                  child: RawKeyboardListener(
                                    focusNode: controller.pickupKeyboardFocusNode,
                                    onKey: (event) {
                                      if (event is RawKeyDownEvent) {
                                        if (event.logicalKey ==
                                            LogicalKeyboardKey.arrowDown &&
                                            controller.highlightedIndex.value <
                                                controller.suggestions.length - 1) {
                                          controller.highlightedIndex.value++;
                                        } else if (event.logicalKey ==
                                            LogicalKeyboardKey.arrowUp &&
                                            controller.highlightedIndex.value > 0) {
                                          controller.highlightedIndex.value--;
                                        } else if (event.logicalKey ==
                                            LogicalKeyboardKey.enter) {
                                          final selected = controller.suggestions[
                                          controller.highlightedIndex.value];
                                          controller.selectSuggestion(selected);
                                        }
                                      }
                                    },
                                    child: CustomTextField(
                                      key: controller.pickupFieldKey,
                                      controller: controller.PickupController,
                                      focusNode:
                                      controller.pickupTextFieldFocusNode,
                                      hintText: 'PICKUP LOCATION',
                                      borderRadius: 4,
                                      prefixIcon: const Icon(Icons.location_pin,
                                        color: Colors.red,size: 20,),
                                      textInputAction: TextInputAction.next,
                                      onTap: (){
                                        shortCutKeyValue.value = "formKey";
                                      },
                                      onSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      suffixIcon: KbdActivatable(
                                        focusNode: swap1FN,
                                        onActivate: () {
                                          String tempPic =
                                              controller.PickupController.text;
                                          String tempDrop =
                                              controller.DropoffController.text;
                                          controller.PickupController.text =
                                              tempDrop;
                                          controller.DropoffController.text =
                                              tempPic;
                                          controller.update();
                                        },
                                        child: const Icon(Icons.swap_vert,
                                            color: Color(0xFF575797), size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(2),
                                child: RestrictedDrivers(
                                  width: fieldWidth/2.5,
                                  height: 30,
                                  padding: 0.0,
                                  titleText: "SELECT PLOT",
                                  driversList: [
                                    "BASE NE7", "WILLESDEN"
                                  ],
                                ),
                              ),

                              // (3) Pickup notes
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(3),
                                child: SizedBox(
                                  width: fieldWidth/2,
                                  height: 30,
                                  child: CustomTextField(
                                    controller: TextEditingController(),
                                    hintText: "PICKUP NOTES",
                                    borderRadius: 6,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.019),

                          // ================= DROPOFF ROW =================

                          Wrap(
                            runSpacing: 10,
                            spacing: 16,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
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

                              // (1) Pickup textfield

                              // (4) Dropoff textfield
                              FocusTraversalOrder(
                              order: const NumericFocusOrder(4),
                              child: SizedBox(
                              width: fieldWidth,
                              height: 30,
                              child: RawKeyboardListener(
                              focusNode: controller.dropOffKeyboardFocusNode,
                              onKey: (event) {
                              if (event is RawKeyDownEvent) {
                              if (event.logicalKey ==
                              LogicalKeyboardKey.arrowDown &&
                              controller.highlightedIndex.value <
                              controller.suggestions.length - 1) {
                              controller.highlightedIndex.value++;
                              } else if (event.logicalKey ==
                              LogicalKeyboardKey.arrowUp &&
                              controller.highlightedIndex.value > 0) {
                              controller.highlightedIndex.value--;
                              } else if (event.logicalKey ==
                              LogicalKeyboardKey.enter) {
                              final selected = controller.suggestions[
                              controller.highlightedIndex.value];
                              controller.selectSuggestion(selected);
                              }
                              }
                              },
                              child: CustomTextField(
                              key: controller.dropOffFieldKey,
                              controller: controller.DropoffController,
                              focusNode:
                              controller.dropOffTextFieldFocusNode,
                              hintText: 'DROP LOCATION',
                              borderRadius: 4,
                              prefixIcon: const Icon(Icons.location_pin,
                              color: Colors.red,size: 20,),
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                              suffixIcon: KbdActivatable(
                              focusNode: swap2FN,
                              onActivate: () {
                              String tempPic =
                              controller.PickupController.text;
                              String tempDrop =
                              controller.DropoffController.text;
                              controller.PickupController.text =
                              tempDrop;
                              controller.DropoffController.text =
                              tempPic;
                              controller.update();
                              },
                              child: const Icon(Icons.swap_vert,
                              color: Color(0xFF575797), size: 20),
                              ),
                              ),
                              ),
                              ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(2),
                                child: RestrictedDrivers(
                                  width: fieldWidth/2.5,
                                  height: 30,
                                  padding: 0.0,
                                  titleText: "SELECT PLOT",
                                  driversList: [
                                    "BASE NE7", "WILLESDEN"
                                  ],
                                ),
                              ),

                              // (3) Pickup notes
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(3),
                                child: SizedBox(
                                  width: fieldWidth/2,
                                  height: 30,
                                  child: CustomTextField(
                                    controller: TextEditingController(),
                                    hintText: "DROP NOTES",
                                    borderRadius: 6,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (controller.jourValue ==
                              'W/R') ...[
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            SingleChildScrollView(
                              scrollDirection:
                              isMobile ? Axis.vertical : Axis.horizontal,
                              child: Flex(
                                direction: isMobile ? Axis.vertical : Axis.horizontal,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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

                                  // (1) Pickup textfield
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(1),
                                    child: SizedBox(
                                      width: fieldWidth,
                                      height: 30,
                                      child: RawKeyboardListener(
                                        focusNode: controller.via1KeyboardFocusNode,
                                        onKey: (event) {
                                          if (event is RawKeyDownEvent) {
                                            if (event.logicalKey ==
                                                LogicalKeyboardKey.arrowDown &&
                                                controller.highlightedIndex.value <
                                                    controller.suggestions.length - 1) {
                                              controller.highlightedIndex.value++;
                                            } else if (event.logicalKey ==
                                                LogicalKeyboardKey.arrowUp &&
                                                controller.highlightedIndex.value > 0) {
                                              controller.highlightedIndex.value--;
                                            } else if (event.logicalKey ==
                                                LogicalKeyboardKey.enter) {
                                              final selected = controller.suggestions[
                                              controller.highlightedIndex.value];
                                              controller.selectSuggestion(selected);
                                            }
                                          }
                                        },
                                        child: CustomTextField(
                                          key: controller.via1FieldKey,
                                          controller: controller.viaLocation1Controller,
                                          focusNode:
                                          controller.via1TextFieldFocusNode,
                                          hintText: 'PICKUP LOCATION',
                                          borderRadius: 4,
                                          prefixIcon: const Icon(Icons.location_pin,
                                            color: Colors.red,size: 20,),
                                          textInputAction: TextInputAction.next,
                                          onTap: (){
                                            shortCutKeyValue.value = "formKey";
                                          },
                                          onSubmitted: (_) =>
                                              FocusScope.of(context).nextFocus(),
                                          suffixIcon: KbdActivatable(
                                            focusNode: swap1FN,
                                            onActivate: () {
                                              String tempPic =
                                                  controller.viaLocation1Controller.text;
                                              String tempDrop =
                                                  controller.viaLocation2Controller.text;
                                              controller.viaLocation1Controller.text =
                                                  tempDrop;
                                              controller.viaLocation2Controller.text =
                                                  tempPic;
                                              controller.update();
                                            },
                                            child: const Icon(Icons.swap_vert,
                                                color: Color(0xFF575797), size: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                      width: isMobile ? 0 : 10,
                                      height: isMobile ? 10 : 0),

                                  // (2) Select plot button
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(2),
                                    child: RestrictedDrivers(
                                      width: fieldWidth,
                                      height: 30,
                                      padding: 0.0,
                                      titleText: "SELECT PLOT",
                                      driversList: [
                                        "BASE NE7", "WILLESDEN"
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                      width: isMobile ? 0 : 10,
                                      height: isMobile ? 10 : 0),

                                  // (3) Pickup notes
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(3),
                                    child: SizedBox(
                                      width: fieldWidth,
                                      height: 30,
                                      child: CustomTextField(
                                        controller: TextEditingController(),
                                        hintText: "PICKUP NOTES",
                                        borderRadius: 6,
                                        textInputAction: TextInputAction.next,
                                        onSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.019),

                            // ================= DROPOFF ROW =================
                            SingleChildScrollView(
                              scrollDirection:
                              isMobile ? Axis.vertical : Axis.horizontal,
                              child: Flex(
                                direction: isMobile ? Axis.vertical : Axis.horizontal,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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

                                  // (4) Dropoff textfield
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(4),
                                    child: SizedBox(
                                      width: fieldWidth,
                                      height: 30,
                                      child: RawKeyboardListener(
                                        focusNode: controller.via2KeyboardFocusNode,
                                        onKey: (event) {
                                          if (event is RawKeyDownEvent) {
                                            if (event.logicalKey ==
                                                LogicalKeyboardKey.arrowDown &&
                                                controller.highlightedIndex.value <
                                                    controller.suggestions.length - 1) {
                                              controller.highlightedIndex.value++;
                                            } else if (event.logicalKey ==
                                                LogicalKeyboardKey.arrowUp &&
                                                controller.highlightedIndex.value > 0) {
                                              controller.highlightedIndex.value--;
                                            } else if (event.logicalKey ==
                                                LogicalKeyboardKey.enter) {
                                              final selected = controller.suggestions[
                                              controller.highlightedIndex.value];
                                              controller.selectSuggestion(selected);
                                            }
                                          }
                                        },
                                        child: CustomTextField(
                                          key: controller.via2FieldKey,
                                          controller: controller.viaLocation2Controller,
                                          focusNode: controller.dropOffTextFieldFocusNode,
                                          hintText: 'DROP LOCATION',
                                          borderRadius: 4,
                                          prefixIcon: const Icon(Icons.location_pin,
                                            color: Colors.red,size: 20,),
                                          textInputAction: TextInputAction.next,
                                          onSubmitted: (_) =>
                                              FocusScope.of(context).nextFocus(),
                                          suffixIcon: KbdActivatable(
                                            focusNode: swap2FN,
                                            onActivate: () {
                                              String tempPic =
                                                  controller.viaLocation1Controller.text;
                                              String tempDrop =
                                                  controller.viaLocation2Controller.text;
                                              controller.viaLocation1Controller.text =
                                                  tempDrop;
                                              controller.viaLocation2Controller.text =
                                                  tempPic;
                                              controller.update();
                                            },
                                            child: const Icon(Icons.swap_vert,
                                                color: Color(0xFF575797), size: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                      width: isMobile ? 0 : 10,
                                      height: isMobile ? 10 : 0),
                                  // (5) Select plot button
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(5),
                                    child: RestrictedDrivers(
                                      width: fieldWidth,
                                      height: 30,
                                      padding: 0.0,
                                      titleText: "SELECT PLOT",
                                      driversList: [
                                        "BASE NE7", "WILLESDEN"
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                      width: isMobile ? 0 : 10,
                                      height: isMobile ? 10 : 0),

                                  // (6) Drop notes
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(6),
                                    child: SizedBox(
                                      width: fieldWidth,
                                      height: 30,
                                      child: CustomTextField(
                                        controller: TextEditingController(),
                                        hintText: "DROP NOTES",
                                        borderRadius: 6,
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (_) =>
                                            FocusScope.of(context).unfocus(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                        ],
                      ),

                      ///todo pickup fields widget
                      // Fields Row / Column Responsive
                      /*PickupWidget(),*/
                      ///todo pickup fields widget
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      ///todo pick and drop widget
                      UserInfoWidget(),
                      ///todo pick and drop widget
                      KeyboardDatePicker(
                        initialDate: selected,
                        onChanged: (dt) {
                          // called whenever value changes
                          print('changed: $dt');
                        },
                        onSubmitted: (dt) {
                          print('submitted: $dt');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
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
