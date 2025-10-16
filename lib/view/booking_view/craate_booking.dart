import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/pickup_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/quotation_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart'
    hide KbdActivatable;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_fake.dart' as html;
import 'package:latlong2/latlong.dart';

import '../../alert/child_seats_alert.dart';
import '../../alert/extra_fares_alert.dart';
import '../../alert/extra_info_alert.dart';
import '../../alert/restrict_drivers_alert.dart';
import '../../component/dropdown_button.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../../routes/app_pages.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/dashboard/booking_form_widget.dart';
import '../dashboard_view/dashboard/map_view_widget.dart';
import '../dashboard_view/dashboard/shortcut_key_widget.dart';
import '../dashboard_view/models/all_addresses_model.dart';

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
  final FocusNode calendarFN = FocusNode();
  final FocusNode checkboxFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode dropdownFocusNode = FocusNode();
  final FocusNode clearPic = FocusNode();
  final FocusNode clearDrop = FocusNode();

  final List<FocusNode> _focusNodes =
      List.generate(4, (index) => FocusNode()); // 4 icons

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
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(dropdownFocusNode);
    });
  }

  @override
  void dispose() {
    super.dispose();
    calendarFN.dispose();
    dropdownFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
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
                  width: Get.width / 1.5,
                  height: Get.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: DynamicColors.textClr),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Shortcut Keys Row
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ShortcutKeyWidget(
                                    keyss: "F1", valuess: "BASE ADDRESS"),
                                const SizedBox(width: 10),
                                ShortcutKeyWidget(
                                    keyss: "F2", valuess: "BOOKING FORM"),
                                const SizedBox(width: 10),
                                ShortcutKeyWidget(
                                    keyss: "F6", valuess: "QUOTATION"),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          decoration:
                              BoxDecoration(color: DynamicColors.secondaryClr),
                          child: Wrap(
                            children: [
                              Text(
                                AppText.booking,
                                style: mozillaTextSemiBoldText(fontSize: 17),
                              ),
                              SizedBox(
                                width: fieldWidth / 3,
                              ),
                              Container(
                                width: fieldWidth / 1.5,
                                height: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: DynamicColors.primaryClr),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: RestrictedDrivers(
                                  width: fieldWidth / 1.5,
                                  // border: Border(
                                  //   bottom: BorderSide(
                                  //     color: DynamicColors.gryClr, // border color
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

                        Stack(key: controller.stackKey, children: [
                          Column(
                            children: [
                              Column(
                                children: [
                                  // ================= PICKUP ROW =================
                                  Wrap(
                                    runSpacing: 10,
                                    spacing: 16,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          AppText.pick,
                                          style: mozillaTextSemiBoldText(
                                            context: context,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => controller
                                                .getPickupAddressesLoader.value
                                            ? SizedBox.shrink()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      // (1) Pickup textfield
                                      FocusTraversalOrder(
                                        order: NumericFocusOrder(1),
                                        child: SizedBox(
                                          width: fieldWidth,
                                          height: 30,
                                          child: RawKeyboardListener(
                                            focusNode: controller
                                                .pickupKeyboardFocusNode,
                                            // onKey: (event) {
                                            //   if (event is RawKeyDownEvent) {
                                            //     if (event.logicalKey ==
                                            //             LogicalKeyboardKey.arrowDown &&
                                            //         controller.highlightedIndex.value <
                                            //             controller.suggestions.length -
                                            //                 1) {
                                            //       controller.highlightedIndex.value++;
                                            //     } else if (event.logicalKey ==
                                            //             LogicalKeyboardKey.arrowUp &&
                                            //         controller.highlightedIndex.value >
                                            //             0) {
                                            //       controller.highlightedIndex.value--;
                                            //     } else if (event.logicalKey ==
                                            //         LogicalKeyboardKey.enter) {
                                            //       final selected =
                                            //           controller.suggestions[controller.highlightedIndex.value].name;
                                            //       controller.selectSuggestion(selected);
                                            //     }
                                            //   }
                                            // },
                                            onKey: (event) {
                                              if (event is RawKeyDownEvent) {
                                                if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowDown &&
                                                    controller.highlightedIndex
                                                            .value <
                                                        controller.suggestions
                                                                .length -
                                                            1) {
                                                  controller
                                                      .highlightedIndex.value++;
                                                } else if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowUp &&
                                                    controller.highlightedIndex
                                                            .value >
                                                        0) {
                                                  controller
                                                      .highlightedIndex.value--;
                                                } else if (event.logicalKey ==
                                                    LogicalKeyboardKey.enter) {
                                                  final selected = controller
                                                      .suggestions[controller
                                                          .highlightedIndex
                                                          .value]
                                                      .name;
                                                  controller.selectSuggestion(
                                                      selected);
                                                }
                                              }
                                            },
                                            child: CustomTextField(
                                              key: controller.pickupFieldKey,
                                              controller:
                                                  controller.pickupController,
                                              focusNode: controller
                                                  .pickupTextFieldFocusNode,
                                              hintText: 'PICKUP LOCATION',
                                              borderRadius: 4,
                                              prefixIcon: const Icon(
                                                Icons.location_pin,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              textInputAction:
                                                  TextInputAction.next,
                                              onChanged: (v) {
                                                controller.onChangeHandler(
                                                    fieldName:
                                                        "Create Booking PICKUP",
                                                    searchingText: v);
                                              },
                                              onTap: () {
                                                shortCutKeyValue.value =
                                                    "Create Booking PICKUP";
                                              },
                                              onSubmitted: (_) =>
                                                  FocusScope.of(context)
                                                      .nextFocus(),
                                              suffixIcon: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  controller.pickupController
                                                          .text.isEmpty
                                                      ? SizedBox.shrink()
                                                      : KbdActivatable(
                                                          focusNode: clearPic,
                                                          onActivate: () {
                                                            int index = controller.markers.indexWhere((test) => test.type == "Create Booking PICKUP");
                                                            controller.markers
                                                                .remove(controller.markers[index]);
                                                            controller.pickupController.clear();
                                                            controller.update();
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            color: DynamicColors
                                                                .redClr,
                                                            size: 15,
                                                          ),
                                                        ),
                                                  KbdActivatable(
                                                    focusNode: swap1FN,
                                                    onActivate: () {
                                                      String tempPic =
                                                          controller
                                                              .pickupController
                                                              .text;
                                                      String tempDrop =
                                                          controller
                                                              .dropOffController
                                                              .text;
                                                      controller
                                                          .pickupController
                                                          .text = tempDrop;
                                                      controller
                                                          .dropOffController
                                                          .text = tempPic;
                                                      controller.update();
                                                    },
                                                    child: const Icon(
                                                        Icons.swap_vert,
                                                        color:
                                                            Color(0xFF575797),
                                                        size: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // child: Focus(
                                            //   focusNode: dropdownFocusNode,
                                            //   onFocusChange: (hasFocus) {
                                            //     if (hasFocus) {
                                            //       print("Dropdown focused!");
                                            //     }
                                            //   },
                                            //   child: GestureDetector(
                                            //     onTap: () {
                                            //       // Step 3: Manually open dropdown on focus
                                            //       FocusScope.of(context).requestFocus(dropdownFocusNode);
                                            //       // You can also trigger your dropdown opening logic here if needed
                                            //     },
                                            //     child: DropdownFlutter<String>.searchRequest(
                                            //       futureRequest: controller.getNamesRequest,
                                            //       hintText: 'Search location',
                                            //       items: controller.allAddressesData.map((m) => m.name ?? '').toList(),
                                            //       onChanged: (selectedName) {
                                            //         for (final m in controller.allAddressesData) {
                                            //           if ("${m.name!} ${m.postcode!}"  == selectedName) {
                                            //             controller.selectedModel = m;
                                            //             break;
                                            //           }
                                            //         }
                                            //         if (controller.selectedModel != null) {
                                            //         }
                                            //       },
                                            //       decoration: CustomDropdownDecoration(
                                            //         closedBorder: Border.all(color: Colors.grey),
                                            //         closedBorderRadius: BorderRadius.circular(8),
                                            //       ),
                                            //       closedHeaderPadding: EdgeInsets.all(6),
                                            //     ),
                                            //   ),
                                            // ),
                                          ),
                                        ),
                                      ),
                                      FocusTraversalOrder(
                                        order: const NumericFocusOrder(2),
                                        child: RestrictedDrivers(
                                          width: fieldWidth / 2.5,
                                          height: 30,
                                          padding: 0.0,
                                          titleText: "SELECT PLOT",
                                          driversList: [
                                            "BASE NE7",
                                            "WILLESDEN"
                                          ],
                                        ),
                                      ),

                                      // (3) Pickup notes
                                      FocusTraversalOrder(
                                        order: const NumericFocusOrder(3),
                                        child: SizedBox(
                                          width: fieldWidth / 2,
                                          height: 30,
                                          child: CustomTextField(
                                            controller: TextEditingController(),
                                            hintText: "PICKUP NOTES",
                                            borderRadius: 6,
                                            textInputAction:
                                                TextInputAction.next,
                                            onSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
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
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          AppText.drop,
                                          style: mozillaTextSemiBoldText(
                                            context: context,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                      Obx(
                                        () => controller
                                                .getDropAddressesLoader.value
                                            ? SizedBox.shrink()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
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
                                            focusNode: controller
                                                .dropOffKeyboardFocusNode,
                                            // onKey: (event) {
                                            //   if (event is RawKeyDownEvent) {
                                            //     if (event.logicalKey ==
                                            //             LogicalKeyboardKey.arrowDown &&
                                            //         controller.highlightedIndex.value <
                                            //             controller.suggestions.length -
                                            //                 1) {
                                            //       controller.highlightedIndex.value++;
                                            //     } else if (event.logicalKey ==
                                            //             LogicalKeyboardKey.arrowUp &&
                                            //         controller.highlightedIndex.value >
                                            //             0) {
                                            //       controller.highlightedIndex.value--;
                                            //     } else if (event.logicalKey ==
                                            //         LogicalKeyboardKey.enter) {
                                            //       final selected =
                                            //           controller.suggestions[controller
                                            //               .highlightedIndex.value];
                                            //       // controller.selectSuggestion(selected);
                                            //     }
                                            //   }
                                            // },
                                            onKey: (event) {
                                              if (event is RawKeyDownEvent) {
                                                if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowDown &&
                                                    controller.highlightedIndex
                                                            .value <
                                                        controller.suggestions
                                                                .length -
                                                            1) {
                                                  controller
                                                      .highlightedIndex.value++;
                                                } else if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowUp &&
                                                    controller.highlightedIndex
                                                            .value >
                                                        0) {
                                                  controller
                                                      .highlightedIndex.value--;
                                                } else if (event.logicalKey ==
                                                    LogicalKeyboardKey.enter) {
                                                  final selected = controller
                                                      .suggestions[controller
                                                          .highlightedIndex
                                                          .value]
                                                      .name;
                                                  controller.selectSuggestion(
                                                      selected);
                                                }
                                              }
                                            },
                                            child: CustomTextField(
                                              key: controller.dropOffFieldKey,
                                              controller:
                                                  controller.dropOffController,
                                              focusNode: controller
                                                  .dropOffTextFieldFocusNode,
                                              hintText: 'DROP LOCATION',
                                              borderRadius: 4,
                                              prefixIcon: const Icon(
                                                Icons.location_pin,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              onTap: () {
                                                shortCutKeyValue.value = "Create Booking DROP LOCATION";
                                              },
                                              onChanged: (v) {
                                                controller.onChangeHandler(
                                                    fieldName: "Create Booking DROP LOCATION",
                                                    searchingText: v);
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              onSubmitted: (_) =>
                                                  FocusScope.of(context)
                                                      .nextFocus(),
                                              suffixIcon: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  controller.dropOffController
                                                          .text.isEmpty
                                                      ? SizedBox.shrink()
                                                      : KbdActivatable(
                                                          focusNode: clearDrop,
                                                          onActivate: () {
                                                            int index = controller
                                                                .markers
                                                                .indexWhere((test) =>
                                                                    test.type ==
                                                                    "Create Booking DROP LOCATION");
                                                            controller.markers
                                                                .remove(controller
                                                                        .markers[
                                                                    index]);
                                                            controller
                                                                .dropOffController
                                                                .clear();
                                                            controller.update();
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            color: DynamicColors
                                                                .redClr,
                                                            size: 15,
                                                          ),
                                                        ),
                                                  KbdActivatable(
                                                    focusNode: swap2FN,
                                                    onActivate: () {
                                                      String tempPic =
                                                          controller.pickupController.text;
                                                      String tempDrop =
                                                          controller.dropOffController
                                                              .text;
                                                      controller
                                                          .pickupController
                                                          .text = tempDrop;
                                                      controller
                                                          .dropOffController
                                                          .text = tempPic;
                                                      controller.update();
                                                    },
                                                    child: const Icon(
                                                        Icons.swap_vert,
                                                        color:
                                                            Color(0xFF575797),
                                                        size: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      FocusTraversalOrder(
                                        order: const NumericFocusOrder(2),
                                        child: RestrictedDrivers(
                                          width: fieldWidth / 2.5,
                                          height: 30,
                                          padding: 0.0,
                                          titleText: "SELECT PLOT",
                                          driversList: [
                                            "BASE NE7",
                                            "WILLESDEN"
                                          ],
                                        ),
                                      ),

                                      // (3) Pickup notes
                                      FocusTraversalOrder(
                                        order: const NumericFocusOrder(3),
                                        child: SizedBox(
                                          width: fieldWidth / 2,
                                          height: 30,
                                          child: CustomTextField(
                                            controller: TextEditingController(),
                                            hintText: "DROP NOTES",
                                            borderRadius: 6,
                                            textInputAction:
                                                TextInputAction.next,
                                            onSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (controller.jourValue == 'W/R') ...[
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: isMobile
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                      child: Flex(
                                        direction: isMobile
                                            ? Axis.vertical
                                            : Axis.horizontal,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
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
                                                focusNode: controller
                                                    .via1KeyboardFocusNode,
                                                onKey: (event) {
                                                  if (event
                                                      is RawKeyDownEvent) {
                                                    if (event.logicalKey ==
                                                            LogicalKeyboardKey
                                                                .arrowDown &&
                                                        controller
                                                                .highlightedIndex
                                                                .value <
                                                            controller
                                                                    .suggestions
                                                                    .length -
                                                                1) {
                                                      controller
                                                          .highlightedIndex
                                                          .value++;
                                                    } else if (event
                                                                .logicalKey ==
                                                            LogicalKeyboardKey
                                                                .arrowUp &&
                                                        controller
                                                                .highlightedIndex
                                                                .value >
                                                            0) {
                                                      controller
                                                          .highlightedIndex
                                                          .value--;
                                                    } else if (event
                                                            .logicalKey ==
                                                        LogicalKeyboardKey
                                                            .enter) {
                                                      final selected = controller
                                                              .suggestions[
                                                          controller
                                                              .highlightedIndex
                                                              .value];
                                                      // controller
                                                      //     .selectSuggestion(selected);
                                                    }
                                                  }
                                                },
                                                child: CustomTextField(
                                                  key: controller.via1FieldKey,
                                                  controller: controller
                                                      .viaLocation1Controller,
                                                  focusNode: controller
                                                      .via1TextFieldFocusNode,
                                                  hintText: 'PICKUP LOCATION',
                                                  borderRadius: 4,
                                                  prefixIcon: const Icon(
                                                    Icons.location_pin,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onTap: () {
                                                    shortCutKeyValue.value =
                                                        "formKey";
                                                  },
                                                  onSubmitted: (_) =>
                                                      FocusScope.of(context)
                                                          .nextFocus(),
                                                  suffixIcon: KbdActivatable(
                                                    focusNode: swap1FN,
                                                    onActivate: () {
                                                      String tempPic = controller
                                                          .viaLocation1Controller
                                                          .text;
                                                      String tempDrop = controller
                                                          .viaLocation2Controller
                                                          .text;
                                                      controller
                                                          .viaLocation1Controller
                                                          .text = tempDrop;
                                                      controller
                                                          .viaLocation2Controller
                                                          .text = tempPic;
                                                      controller.update();
                                                    },
                                                    child: const Icon(
                                                        Icons.swap_vert,
                                                        color:
                                                            Color(0xFF575797),
                                                        size: 20),
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
                                                "BASE NE7",
                                                "WILLESDEN"
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
                                                controller:
                                                    TextEditingController(),
                                                hintText: "PICKUP NOTES",
                                                borderRadius: 6,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onSubmitted: (_) =>
                                                    FocusScope.of(context)
                                                        .nextFocus(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.019),

                                    // ================= DROPOFF ROW =================
                                    SingleChildScrollView(
                                      scrollDirection: isMobile
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                      child: Flex(
                                        direction: isMobile
                                            ? Axis.vertical
                                            : Axis.horizontal,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
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
                                                focusNode: controller
                                                    .via2KeyboardFocusNode,
                                                onKey: (event) {
                                                  if (event
                                                      is RawKeyDownEvent) {
                                                    if (event.logicalKey ==
                                                            LogicalKeyboardKey
                                                                .arrowDown &&
                                                        controller
                                                                .highlightedIndex
                                                                .value <
                                                            controller
                                                                    .suggestions
                                                                    .length -
                                                                1) {
                                                      controller
                                                          .highlightedIndex
                                                          .value++;
                                                    } else if (event
                                                                .logicalKey ==
                                                            LogicalKeyboardKey
                                                                .arrowUp &&
                                                        controller
                                                                .highlightedIndex
                                                                .value >
                                                            0) {
                                                      controller
                                                          .highlightedIndex
                                                          .value--;
                                                    } else if (event
                                                            .logicalKey ==
                                                        LogicalKeyboardKey
                                                            .enter) {
                                                      final selected = controller
                                                          .suggestions[controller
                                                              .highlightedIndex
                                                              .value]
                                                          .name;
                                                      controller
                                                          .selectSuggestion(
                                                              selected);
                                                    }
                                                  }
                                                },
                                                child: CustomTextField(
                                                  key: controller.via2FieldKey,
                                                  controller: controller
                                                      .viaLocation2Controller,
                                                  focusNode: controller
                                                      .dropOffTextFieldFocusNode,
                                                  hintText: 'DROP LOCATION',
                                                  borderRadius: 4,
                                                  prefixIcon: const Icon(
                                                    Icons.location_pin,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onSubmitted: (_) =>
                                                      FocusScope.of(context)
                                                          .nextFocus(),
                                                  suffixIcon: KbdActivatable(
                                                    focusNode: swap2FN,
                                                    onActivate: () {
                                                      String tempPic = controller
                                                          .viaLocation1Controller
                                                          .text;
                                                      String tempDrop = controller
                                                          .viaLocation2Controller
                                                          .text;
                                                      controller
                                                          .viaLocation1Controller
                                                          .text = tempDrop;
                                                      controller
                                                          .viaLocation2Controller
                                                          .text = tempPic;
                                                      controller.update();
                                                    },
                                                    child: const Icon(
                                                        Icons.swap_vert,
                                                        color:
                                                            Color(0xFF575797),
                                                        size: 20),
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
                                                "BASE NE7",
                                                "WILLESDEN"
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
                                                controller:
                                                    TextEditingController(),
                                                hintText: "DROP NOTES",
                                                borderRadius: 6,
                                                textInputAction:
                                                    TextInputAction.done,
                                                onSubmitted: (_) =>
                                                    FocusScope.of(context)
                                                        .unfocus(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),

                              ///todo pickup fields widget
                              // Fields Row / Column Responsive
                              /*PickupWidget(),*/
                              ///todo pickup fields widget

                              Wrap(
                                spacing: 10,
                                runSpacing: 16,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.start,
                                children: [
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(1),
                                    child: labeledTextField(context, isMobile,
                                        AppText.name, controller.nameController,
                                        width: fieldWidth / 2.3,
                                        textInputAction: TextInputAction.next),
                                  ),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(2),
                                    child: labeledTextField(
                                        context,
                                        isMobile,
                                        AppText.email,
                                        controller.emailController,
                                        width: fieldWidth / 2.3,
                                        textInputAction: TextInputAction.next),
                                  ),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(3),
                                    child: labeledTextField(
                                        context,
                                        isMobile,
                                        AppText.mobile,
                                        controller.mobileController,
                                        width: fieldWidth / 2.3,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.phone,
                                        formatDigitsOnly: false),
                                  ),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(4),
                                    child: labeledTextField(context, isMobile,
                                        AppText.tel, controller.telController,
                                        width: fieldWidth / 2.3,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.phone,
                                        formatDigitsOnly: false),
                                  ),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(5),
                                    child: labeledField(
                                      context: context,
                                      isMobile: isMobile,
                                      label: AppText.date,
                                      width: fieldWidth / 2.3,
                                      child: SizedBox(
                                          height: 30,
                                          child: KeyboardDatePicker()),
                                    ),
                                  ),
                                  // (6) Time
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(6),
                                    child: labeledField(
                                      context: context,
                                      isMobile: isMobile,
                                      label: AppText.time,
                                      width: fieldWidth / 2.3,
                                      child: SizedBox(
                                          height: 30,
                                          child: CustomTimePicker()),
                                    ),
                                  ),
                                  // (7) Lead (mins)
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(7),
                                    child: labeledField(
                                      context: context,
                                      isMobile: isMobile,
                                      label: AppText.lead,
                                      width: fieldWidth / 2.3,
                                      child: SizedBox(
                                        height: 30,
                                        child: CustomTextField(
                                          hintText: "MINS",
                                          controller: controller.minController,
                                          borderRadius: 4,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          onSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // (8) Journey dropdown (O/W, R/N, W/R)
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(8),
                                    child: RestrictedDrivers(
                                      width: fieldWidth / 2.3,
                                      height: 30,
                                      padding: 0.0,
                                      titleText: "SELECT PLOT",
                                      driversList: [
                                        'DEMO COMPANY 01',
                                        'DEMO COMPANY 02'
                                      ],
                                    ),
                                  ),

                                  // (9) Driver dropdown
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(9),
                                    child: labeledField(
                                      context: context,
                                      isMobile: isMobile,
                                      label: AppText.drv,
                                      width: fieldWidth / 2.3,
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: DynamicColors.primaryClr,
                                              width: 1.2),
                                        ),
                                        child: // (8) Journey dropdown (O/W, R/N, W/R)
                                            RestrictedDrivers(
                                          width: fieldWidth / 2.3,
                                          height: 30,
                                          padding: 0.0,
                                          titleText: controller.drvValue,
                                          driversList: [
                                            "25 GEORGE HAMPTON",
                                            "26 PAUL DOUBLEDAY",
                                            "27 RICHARD HARDWICK",
                                            "28 LANRE OKERJO",
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // (10) Fare (Slugg)
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(10),
                                    child: labeledField(
                                      context: context,
                                      isMobile: isMobile,
                                      label: AppText.fare,
                                      width: fieldWidth / 2.3,
                                      child: SizedBox(
                                        height: 30,
                                        child: CustomTextField(
                                          hintText: "Slugg",
                                          controller: controller.slugController,
                                          borderRadius: 6,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          onSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // (11) Account
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(11),
                                    child: labeledField(
                                      context: context,
                                      isMobile: isMobile,
                                      label: AppText.acc,
                                      width: fieldWidth / 2.3,
                                      child: SizedBox(
                                        height: 30,
                                        child: CustomTextField(
                                          hintText: "SELECT ACCOUNT",
                                          controller:
                                              controller.accountNoController,
                                          borderRadius: 6,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          onSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // (12) Pay dropdown
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(12),
                                    child: labeledField(
                                      context: context,
                                      isMobile: isMobile,
                                      label: AppText.pay,
                                      width: fieldWidth / 2.3,
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: DynamicColors.primaryClr),
                                        ),
                                        child: RestrictedDrivers(
                                          width: fieldWidth / 2.3,
                                          height: 30,
                                          padding: 0.0,
                                          titleText: controller.payValue,
                                          driversList: [
                                            "CASH",
                                            "CREDIT CARD",
                                            "ACCOUNT",
                                            "CREDIT CARD PAID"
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // (13) Calendar icon (keyboard clickable)
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(13),
                                    child: SizedBox(
                                      height: 33,
                                      child: KbdActivatable(
                                        focusNode: calendarFN,
                                        onActivate: () {
                                          // TODO: open your calendar modal/sheet
                                          // For demo:
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Calendar icon activated")),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Icon(Icons.calculate,
                                              size: 20),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // (12) Pay dropdown
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(9),
                                    child: labeledField(
                                      context: context,
                                      isMobile: isMobile,
                                      label: AppText.veh,
                                      width: fieldWidth / 2.3,
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: DynamicColors.primaryClr,
                                              width: 1.2),
                                        ),
                                        child: // (8) Journey dropdown (O/W, R/N, W/R)
                                            RestrictedDrivers(
                                          width: fieldWidth / 2.3,
                                          height: 30,
                                          padding: 0.0,
                                          titleText: controller.vehKey,
                                          driversList: [
                                            "SALOON",
                                            "ESTATE",
                                            "MPV6",
                                            "MPV PLUS",
                                            "MPV7",
                                            "MPV EXECUTIVE",
                                            "MINI BUS"
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Switch + Quotation
                                  DynamicSwitch(
                                    controller: controller.switchController,
                                    activeColor: DynamicColors.primaryClr,
                                    inactiveColor: DynamicColors.gryClr,
                                    focusScale: 1.5,
                                    onToggle: () {
                                      print(
                                          "Switch toggled: ${controller.switchController.value}");
                                    },
                                  ),
                                  Text(
                                    AppText.quotation,
                                    style: mozillaTextSemiBoldText(
                                        context: context, fontSize: 13),
                                  ),

                                  // SMS Checkbox
                                  SizedBox(
                                    // width: fieldWidth/6,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RawKeyboardListener(
                                          focusNode: checkboxFocus,
                                          onKey: (event) {
                                            if (event is RawKeyDownEvent &&
                                                (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .enter ||
                                                    event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .space)) {
                                              setState(() {
                                                controller.smsCheckbox.value =
                                                    !controller.smsCheckbox
                                                        .value; // ✅ toggle
                                              });
                                            }
                                          },
                                          child: Checkbox(
                                            activeColor:
                                                DynamicColors.primaryClr,
                                            value: controller.smsCheckbox.value,
                                            onChanged: (v) {
                                              controller.smsCheckbox.value = v!;
                                              controller.update();
                                            },
                                          ),
                                        ),
                                        Text(
                                          AppText.sms,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Email Checkbox
                                  SizedBox(
                                    // width: fieldWidth/5,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RawKeyboardListener(
                                          focusNode: emailFocus,
                                          onKey: (event) {
                                            if (event is RawKeyDownEvent &&
                                                (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .enter ||
                                                    event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .space)) {
                                              setState(() {
                                                controller.emailCheckbox.value =
                                                    !controller.emailCheckbox
                                                        .value; // ✅ toggle
                                              });
                                            }
                                          },
                                          child: Checkbox(
                                            activeColor:
                                                DynamicColors.primaryClr,
                                            value:
                                                controller.emailCheckbox.value,
                                            onChanged: (v) {
                                              controller.emailCheckbox.value =
                                                  v!;
                                              controller.update();
                                            },
                                          ),
                                        ),
                                        Text(
                                          AppText.email,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Pass, Lugg, Slugg fields
                                  SizedBox(
                                    // width: fieldWidth/2.0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          height: 30,
                                          child: CustomTextField(
                                            hintText: "Pass",
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  2),
                                            ],
                                            keyboardType: TextInputType.number,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 4),
                                            controller: TextEditingController(),
                                            borderRadius: 4,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(
                                          width: 60,
                                          height: 30,
                                          child: CustomTextField(
                                            hintText: "Lugg",
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  2),
                                            ],
                                            keyboardType: TextInputType.number,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 4),
                                            controller: TextEditingController(),
                                            borderRadius: 4,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(
                                          width: 60,
                                          height: 30,
                                          child: CustomTextField(
                                            hintText: "Slugg",
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  2),
                                            ],
                                            keyboardType: TextInputType.number,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 4),
                                            controller: TextEditingController(),
                                            borderRadius: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  FocusTraversalGroup(
                                    policy: OrderedTraversalPolicy(),
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          buildFocusableIcon(
                                            icon: Icons.person,
                                            focusNode: _focusNodes[0],
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      RestrictDriversAlert());
                                            },
                                          ),
                                          buildFocusableIcon(
                                            icon: Icons
                                                .shopping_cart_checkout_outlined,
                                            focusNode: _focusNodes[1],
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    ChildSeatsAlert(),
                                              );
                                            },
                                          ),
                                          buildFocusableIcon(
                                            icon: Icons.attach_money,
                                            focusNode: _focusNodes[2],
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    ExtraFaresAlert(),
                                              );
                                            },
                                          ),
                                          buildFocusableIcon(
                                            icon: Icons.note_add_sharp,
                                            focusNode: _focusNodes[3],
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    ExtraInfoAlert(),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: Get.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: DynamicColors.secondaryClr),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 16,
                                  children: [
                                    Icon(Icons.access_time_filled_outlined,
                                        color: DynamicColors.textClr, size: 18),
                                    SizedBox(width: 4),
                                    Text("ETA : 0.0 mins",
                                        style: TextStyle(
                                            color: DynamicColors.textClr,
                                            fontSize: 13)),
                                    Icon(Icons.access_time_filled_outlined,
                                        color: DynamicColors.textClr, size: 18),
                                    SizedBox(width: 4),
                                    Text("JOURNEY : 0.0 mins",
                                        style: TextStyle(
                                            color: DynamicColors.textClr,
                                            fontSize: 13)),
                                    Icon(Icons.location_on,
                                        color: DynamicColors.textClr, size: 18),
                                    SizedBox(width: 4),
                                    Text("DISTANCE : 0.0 miles",
                                        style: TextStyle(
                                            color: DynamicColors.textClr,
                                            fontSize: 13)),
                                    Container(
                                      width: fieldWidth / 3.5,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "PR: \$ 4.90",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: Get.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: DynamicColors.secondaryClr),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 16,
                                  children: [
                                    FocusTraversalOrder(
                                      order: const NumericFocusOrder(12),
                                      child: labeledField(
                                        context: context,
                                        isMobile: isMobile,
                                        label: AppText.driver,
                                        width: fieldWidth / 2.3,
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color:
                                                    DynamicColors.primaryClr),
                                          ),
                                          child: RestrictedDrivers(
                                            width: fieldWidth / 2.3,
                                            height: 30,
                                            padding: 0.0,
                                            titleText:
                                                controller.selectedDriver,
                                            driversList: [
                                              "Driver 01",
                                              "Driver 02",
                                              "Driver 03",
                                              "Driver 04"
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    CustomButton(
                                      btnText: "MULTI BOOKING [F8]",
                                      width: 150,
                                      height: 30,
                                      fontSize: 11,
                                      verticalPadding: 0.0,
                                      borderRadius: 4,
                                    ),
                                    CustomButton(
                                      btnText: "MULTI VEHICLE [F9]",
                                      width: 150,
                                      height: 30,
                                      fontSize: 11,
                                      verticalPadding: 0.0,
                                      borderRadius: 4,
                                    ),
                                    CustomButton(
                                      btnText: "CLEAR [F7]",
                                      width: 110,
                                      height: 30,
                                      fontSize: 11,
                                      btnColor: DynamicColors.redClr,
                                      verticalPadding: 0.0,
                                      borderRadius: 4,
                                    ),
                                    CustomButton(
                                      btnText: "SAVE[HOME]",
                                      width: 110,
                                      height: 30,
                                      fontSize: 11,
                                      verticalPadding: 0.0,
                                      borderRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Get.height / 2.1,
                      child: MapViewWidget(createBooking: true,),
                      //           child: Stack(
                      //             children: [
                      //               Positioned.fill(
                      //                 child: FlutterMap(
                      //                   options: MapOptions(
                      //                     initialCenter:
                      //                         LatLng(33.6844, 73.0479),
                      //                     initialZoom: 13.0,
                      //                   ),
                      //                   children: [
                      //                     TileLayer(
                      //                       urlTemplate:
                      //                           'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      //                       subdomains: ['a', 'b', 'c'],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               Positioned(
                      //                   bottom: 0,
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(7.0),
                      //                     child: Container(
                      //                         decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(6),
                      //                             color: DynamicColors
                      //                                 .secondaryClr),
                      //                         child: IconButton(
                      //                             padding: EdgeInsets.zero,
                      //                             onPressed: () {
                      //                               final newTabUrll = Uri
                      //                                       .base.origin +
                      //                                   '/#' +
                      //                                   Routes.viewDriversMap;
                      //                               html.window.open(
                      //                                 newTabUrll,
                      //                                 '_blank', // "_blank" nayi window/tab me open karega
                      //                                 'width=1200,height=800,noopener,noreferrer', // Optional: size aur options
                      //                               );
                      //                             },
                      //                             icon: Icon(Icons
                      //                                 .crop_square_outlined))),
                      //                   ))
                      //
                      //               ///todo Duration Info
                      //               /*Positioned(
                      // top: 90,
                      // left: 10,
                      // child: Obx(() {
                      //   final controller = Get.find<
                      //       DashboardController>();
                      //   return Container(
                      //     padding:
                      //     const EdgeInsets.symmetric(
                      //         horizontal: 17,
                      //         vertical: 8),
                      //     decoration: BoxDecoration(
                      //       color: Color(0xFF3CC2C1)
                      //           .withOpacity(0.7),
                      //       borderRadius:
                      //       BorderRadius.circular(12),
                      //     ),
                      //     child: Column(
                      //       crossAxisAlignment:
                      //       CrossAxisAlignment.start,
                      //       children: [
                      //         const Text("MILES:",
                      //             style: TextStyle(
                      //                 fontWeight:
                      //                 FontWeight.bold,
                      //                 fontSize: 12,
                      //                 color:
                      //                 Colors.white)),
                      //         Text(controller.miles.value,
                      //             style: const TextStyle(
                      //                 fontSize: 10,
                      //                 color:
                      //                 Colors.white)),
                      //         SizedBox(
                      //             height: screenHeight *
                      //                 0.0075),
                      //         const Text("DURATION:",
                      //             style: TextStyle(
                      //                 fontWeight:
                      //                 FontWeight.bold,
                      //                 fontSize: 12,
                      //                 color:
                      //                 Colors.white)),
                      //         Text(
                      //             controller
                      //                 .duration.value,
                      //             style: const TextStyle(
                      //                 fontSize: 10,
                      //                 color:
                      //                 Colors.white)),
                      //       ],
                      //     ),
                      //   );
                      // }),
                      //                 ),*/
                      //               ///todo Duration Info
                      //             ],
                      //           ),
                              )
                            ],
                          ),
                          Obx(() {
                            if (controller.selectedTextFieldsValue.value ==
                                "VIA") return SizedBox();
                            if (controller.allAddressesData.isEmpty)
                              return const SizedBox();
                            final GlobalKey<State<StatefulWidget>>? activeKey =
                                controller.activeFieldKey.value;
                            final RenderBox? fieldBox =
                                activeKey?.currentContext?.findRenderObject()
                                    as RenderBox?;
                            final RenderBox? stackBox = controller
                                .stackKey.currentContext
                                ?.findRenderObject() as RenderBox?;

                            double top = 0.0;
                            double left = 0.0;
                            double width = screenWidth;

                            if (fieldBox != null && stackBox != null) {
                              final Offset localOffset = fieldBox.localToGlobal(
                                  Offset.zero,
                                  ancestor: stackBox);
                              final double fieldHeight = fieldBox.size.height;
                              width = fieldBox.size.width;
                              top = localOffset.dy + fieldHeight;
                              left = localOffset.dx;
                            }

                            // ensure RawKeyboardListener gets focus when suggestions appear
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (controller.allAddressesData.isNotEmpty &&
                                  !controller.suggestionFocusNode.hasFocus) {
                                // FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                // FocusScope.of(context).requestFocus(controller.pickupTextFieldFocusNode);
                              }
                            });

                            return Positioned(
                              top: top,
                              left: left,
                              width: fieldWidth,
                              child: RawKeyboardListener(
                                focusNode: controller.suggestionFocusNode,
                                autofocus: true,
                                onKey: (RawKeyEvent event) {
                                  if (event is RawKeyDownEvent) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowDown) {
                                      controller.moveHighlightDown();
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowUp) {
                                      controller.moveHighlightUp();
                                    }
                                    // Enter intentionally ignored so it does not select anything
                                  }
                                },
                                child: Container(
                                  height: screenHeight * 0.3,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF0F2),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 2)),
                                    ],
                                  ),

                                  // Rebuild list when highlightedIndex or data changes
                                  child: Obx(() => ListView.builder(
                                        controller: controller
                                            .suggestionScrollController,
                                        itemCount:
                                            controller.allAddressesData.length,
                                        itemBuilder: (context, index) {
                                          final item = controller
                                              .allAddressesData[index];
                                          final isHighlighted = index ==
                                              controller.highlightedIndex.value;

                                          return Container(
                                            // optional background highlight
                                            color: isHighlighted
                                                ? const Color(0xffA0DCFF)
                                                : Colors.transparent,
                                            child: ListTile(
                                              dense: true,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              // Animated text style so color/weight changes step-by-step
                                              title: AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                    milliseconds: 120),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: isHighlighted
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: isHighlighted
                                                      ? Colors.blue
                                                      : Colors.black,
                                                ),
                                                child: Text(
                                                    "${item.name} ${item.postcode}"),
                                              ),
                                              onTap: () =>
                                                  controller.tapSelect(index),
                                            ),
                                          );
                                        },
                                      )),
                                ),
                              ),
                            );
                          }),
                        ]),
                      ],
                    ),
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
