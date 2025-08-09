

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/shortcut_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../component/calender.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../Controller/dashboard_controller.dart';
import '../widgets/via_location.dart';
import 'focusable_text_button.dart';
import 'form_short_cut_key.dart';

import 'package:table_calendar/table_calendar.dart';

class BookingFormWidget extends StatefulWidget {
  BookingFormWidget({super.key});

  @override
  State<BookingFormWidget> createState() => _BookingFormWidgetState();
}

class _BookingFormWidgetState extends State<BookingFormWidget> {
  final DashboardController locationCtrl = Get.put(DashboardController());


  final dashboardController = Get.find<DashboardController>();
  String selectedMenu = "";
  String selectedDropdownItem = "";
  final GlobalKey bookingKey = GlobalKey();
  final GlobalKey bookingDropKey = GlobalKey();
  final GlobalKey jourKey = GlobalKey();
  final GlobalKey accKey = GlobalKey();
  final GlobalKey payKey = GlobalKey();
  final GlobalKey vehKey = GlobalKey();
  final GlobalKey dRVKey = GlobalKey();



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Container(
            width: screenWidth * 0.45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                FormShortCutKey(),
                SizedBox(
                  height: screenHeight * 0.018,
                ),
                FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(),
                  child: Column(
                    children: [
                    SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Label
                        Text(
                          AppText.pick,
                          style: mozillaTextSemiBoldText(
                            context: context,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Pickup Location Input with Keyboard Support
                        SizedBox(
                          width: Get.width / 4.5,
                          height: 40,
                          child: RawKeyboardListener(
                            focusNode: locationCtrl.pickupKeyboardFocusNode,
                            onKey: (event) {
                              if (event is RawKeyDownEvent) {
                                if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                                    locationCtrl.highlightedIndex.value <
                                        locationCtrl.suggestions.length - 1) {
                                  locationCtrl.highlightedIndex.value++;
                                } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                                    locationCtrl.highlightedIndex.value > 0) {
                                  locationCtrl.highlightedIndex.value--;
                                } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                  final selected = locationCtrl
                                      .suggestions[locationCtrl.highlightedIndex.value];
                                  locationCtrl.selectSuggestion(selected);
                                }
                              }
                            },
                            child: Focus(
                              focusNode: locationCtrl.pickupFocusNode,
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                  locationCtrl.activeFieldKey.value =
                                      locationCtrl.pickupFieldKey;
                                }
                              },
                              child: CustomTextField(
                                key: locationCtrl.pickupFieldKey,
                                borderRadius: 6,
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                controller: controller.PickupController,
                                focusNode: locationCtrl.pickupTextFieldFocusNode,
                                onChanged: locationCtrl.onInputChanged,
                                prefixIcon: const Icon(Icons.location_pin, color: Colors.red),
                                labelText: 'PickUP Location',
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Swap Button
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.grey.shade100),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            )),
                          ),
                          onPressed: () {
                            String temPic = controller.PickupController.text;
                            String temDrop = locationCtrl.DropoffController.text;
                            controller.PickupController.text = temDrop;
                            locationCtrl.DropoffController.text = temPic;
                            controller.update();
                          },
                          icon: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 21),
                        ),

                        const SizedBox(width: 10),

                        // Select Plot Button
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                              ),
                              child: Center(
                                child: buildMenuTab(Icons.book_online, "Select Plot", "Select Plot",
                                    ["BASE NE7", "WILLESDEN"], bookingKey),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Extra Text Field
                        SizedBox(
                          width: Get.width / 13,
                          height: 40,
                          child: CustomTextField(
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
                      /*SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Text(AppText.drop,
                              style: mozillaTextSemiBoldText(context: context,
                                  fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            SizedBox(
                              width: Get.width/4.5,
                              height: 35,
                              child: RawKeyboardListener(
                                focusNode: locationCtrl
                                    .dropoffKeyboardFocusNode, // For key events
                                onKey: (event) {
                                  if (event
                                  is RawKeyDownEvent) {
                                    if (event
                                        .logicalKey ==
                                        LogicalKeyboardKey
                                            .arrowDown) {
                                      if (locationCtrl
                                          .highlightedIndex
                                          .value <
                                          locationCtrl
                                              .suggestions
                                              .length -
                                              1) {
                                        locationCtrl
                                            .highlightedIndex
                                            .value++;
                                      }
                                    } else if (event
                                        .logicalKey ==
                                        LogicalKeyboardKey
                                            .arrowUp) {
                                      if (locationCtrl
                                          .highlightedIndex
                                          .value >
                                          0) {
                                        locationCtrl
                                            .highlightedIndex
                                            .value--;
                                      }
                                    } else if (event
                                        .logicalKey ==
                                        LogicalKeyboardKey
                                            .enter) {
                                      final selected =
                                      locationCtrl
                                          .suggestions[
                                      locationCtrl
                                          .highlightedIndex
                                          .value];
                                      locationCtrl
                                          .selectSuggestion(
                                          selected);
                                    }
                                  }
                                },
                                child: Focus(
                                  focusNode: locationCtrl
                                      .dropoffFocusNode,
                                  onFocusChange:
                                      (hasFocus) {
                                    if (hasFocus) {
                                      locationCtrl
                                          .activeFieldKey
                                          .value =
                                          locationCtrl
                                              .dropoffFieldKey;
                                    }
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    child: CustomTextField(
                                      key: locationCtrl
                                          .dropoffFieldKey,
                                      borderRadius: 4,
                                      controller: controller
                                          .DropoffController,
                                      focusNode: locationCtrl
                                          .dropoffTextFieldFocusNode, // <- This is NEW
                                      onChanged: locationCtrl
                                          .onInputChanged,
                                      prefixIcon: Icon(
                                          Icons
                                              .location_pin,
                                          color: Colors
                                              .red),
                                      labelText:
                                      'Drop Location',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  String temPic = controller
                                      .PickupController.text;
                                  String temDrop = locationCtrl
                                      .DropoffController.text;
                                  controller
                                      .PickupController.text = temDrop;
                                  locationCtrl
                                      .DropoffController.text = temPic;
                                  controller.update();
                                },
                                icon: Icon(
                                    Icons
                                        .swap_vert,
                                    color: Color(
                                        0xFF575797),
                                    size: 21)),
                            // ),
                            GestureDetector(
                              onTap: (){

                              },
                              child: SizedBox(
                                width: Get.width/13,
                                height: 35,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: DynamicColors.primaryClr)
                                  ),
                                  child: buildMenuTab(Icons.book_online, "Select Plot", "Select Plot",
                                      ["BASE NE7", "WILLESDEN",], bookingDropKey),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: Get.width/13,
                                height: 35,
                                child: CustomTextField(
                                  borderRadius: 4,
                                  controller: TextEditingController(),
                                ),
                              ),
                            ),

                            // ),
                          ],
                        ),
                      ),*/
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Label
                        Text(
                          AppText.drop,
                          style: mozillaTextSemiBoldText(
                            context: context,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Dropoff Location Input with Keyboard Support
                        SizedBox(
                          width: Get.width / 4.5,
                          height: 40,
                          child: RawKeyboardListener(
                            focusNode: locationCtrl.dropoffKeyboardFocusNode,
                            onKey: (event) {
                              if (event is RawKeyDownEvent) {
                                if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                                    locationCtrl.highlightedIndex.value <
                                        locationCtrl.suggestions.length - 1) {
                                  locationCtrl.highlightedIndex.value++;
                                } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                                    locationCtrl.highlightedIndex.value > 0) {
                                  locationCtrl.highlightedIndex.value--;
                                } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                  final selected = locationCtrl
                                      .suggestions[locationCtrl.highlightedIndex.value];
                                  locationCtrl.selectSuggestion(selected);
                                }
                              }
                            },
                            child: Focus(
                              focusNode: locationCtrl.dropoffFocusNode,
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                  locationCtrl.activeFieldKey.value =
                                      locationCtrl.dropoffFieldKey;
                                }
                              },
                              child: CustomTextField(
                                key: locationCtrl.dropoffFieldKey,
                                borderRadius: 6,
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                controller: controller.DropoffController,
                                focusNode: locationCtrl.dropoffTextFieldFocusNode,
                                onChanged: locationCtrl.onInputChanged,
                                prefixIcon: const Icon(Icons.location_pin, color: Colors.red),
                                labelText: 'Drop Location',
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Swap Button
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.grey.shade100),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                          onPressed: () {
                            String temPic = controller.PickupController.text;
                            String temDrop = locationCtrl.DropoffController.text;
                            controller.PickupController.text = temDrop;
                            locationCtrl.DropoffController.text = temPic;
                            controller.update();
                          },
                          icon: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 21),
                        ),

                        const SizedBox(width: 10),

                        // Select Plot Button
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                              ),
                              child: Center(
                                child: buildMenuTab(Icons.book_online, "Select Plot", "Select Plot",
                                    ["BASE NE7", "WILLESDEN"], bookingDropKey),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Extra Text Field
                        SizedBox(
                          width: Get.width / 13,
                          height: 40,
                          child: CustomTextField(
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
                      if (dashboardController.selectedJourneyType ==
                          'Two Way') ...[
                        SizedBox(
                            height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              fit: FlexFit.loose,
                              child: Column(
                                children: [
                                  RawKeyboardListener(
                                    focusNode: locationCtrl
                                        .via1KeyboardFocusNode,
                                    onKey: (event) {
                                      if (event
                                      is RawKeyDownEvent) {
                                        if (event
                                            .logicalKey ==
                                            LogicalKeyboardKey
                                                .arrowDown) {
                                          if (locationCtrl
                                              .highlightedIndex
                                              .value <
                                              locationCtrl
                                                  .suggestions
                                                  .length -
                                                  1) {
                                            locationCtrl
                                                .highlightedIndex
                                                .value++;
                                          }
                                        } else if (event
                                            .logicalKey ==
                                            LogicalKeyboardKey
                                                .arrowUp) {
                                          if (locationCtrl
                                              .highlightedIndex
                                              .value >
                                              0) {
                                            locationCtrl
                                                .highlightedIndex
                                                .value--;
                                          }
                                        } else if (event
                                            .logicalKey ==
                                            LogicalKeyboardKey
                                                .enter) {
                                          final selected = locationCtrl
                                              .suggestions[
                                          locationCtrl
                                              .highlightedIndex
                                              .value];
                                          locationCtrl
                                              .selectSuggestion(
                                              selected);
                                        }
                                      }
                                    },
                                    child: Focus(
                                      focusNode: locationCtrl
                                          .via1FocusNode,
                                      onFocusChange:
                                          (hasFocus) {
                                        if (hasFocus) {
                                          locationCtrl
                                              .activeFieldKey
                                              .value =
                                              locationCtrl
                                                  .via1FieldKey;
                                        }
                                      },
                                      child: SizedBox(
                                        height:
                                        screenHeight *
                                            0.05,
                                        child:
                                        TextFormField(
                                          key: locationCtrl
                                              .via1FieldKey,
                                          controller:
                                          locationCtrl
                                              .ViaLocation1Controller,
                                          focusNode:
                                          locationCtrl
                                              .via1TextFieldFocusNode,
                                          onChanged:
                                          locationCtrl
                                              .onInputChanged,
                                          decoration:
                                          InputDecoration(
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                1,
                                                vertical:
                                                10),
                                            filled: true,
                                            fillColor: Color(
                                                0xFFEFF0F2),
                                            prefixIcon: Icon(
                                                Icons
                                                    .alt_route,
                                                color: Color(
                                                    0xFF43489A)),
                                            suffixIcon:
                                            GestureDetector(
                                              onTap: () {
                                                locationCtrl
                                                    .ViaLocation1Controller
                                                    .clear();
                                                locationCtrl
                                                    .suggestions
                                                    .clear();
                                              },
                                              child: Icon(
                                                  Icons
                                                      .cancel,
                                                  color: Color(
                                                      0xFF575797),
                                                  size: 16),
                                            ),
                                            labelText:
                                            'Via Location 1',
                                            labelStyle:
                                            TextStyle(
                                              color: Colors
                                                  .grey,
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                            ),
                                            border:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  5),
                                              borderSide:
                                              BorderSide
                                                  .none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: screenHeight * 0.01),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              fit: FlexFit.loose,
                              child: Column(
                                children: [
                                  RawKeyboardListener(
                                    focusNode: locationCtrl
                                        .via2KeyboardFocusNode,
                                    onKey: (event) {
                                      if (event
                                      is RawKeyDownEvent) {
                                        if (event
                                            .logicalKey ==
                                            LogicalKeyboardKey
                                                .arrowDown) {
                                          if (locationCtrl
                                              .highlightedIndex
                                              .value <
                                              locationCtrl
                                                  .suggestions
                                                  .length -
                                                  1) {
                                            locationCtrl
                                                .highlightedIndex
                                                .value++;
                                          }
                                        } else if (event
                                            .logicalKey ==
                                            LogicalKeyboardKey
                                                .arrowUp) {
                                          if (locationCtrl
                                              .highlightedIndex
                                              .value >
                                              0) {
                                            locationCtrl
                                                .highlightedIndex
                                                .value--;
                                          }
                                        } else if (event
                                            .logicalKey ==
                                            LogicalKeyboardKey
                                                .enter) {
                                          final selected = locationCtrl
                                              .suggestions[
                                          locationCtrl
                                              .highlightedIndex
                                              .value];
                                          locationCtrl
                                              .selectSuggestion(
                                              selected);
                                        }
                                      }
                                    },
                                    child: Focus(
                                      focusNode: locationCtrl
                                          .via2FocusNode,
                                      onFocusChange:
                                          (hasFocus) {
                                        if (hasFocus) {
                                          locationCtrl
                                              .activeFieldKey
                                              .value =
                                              locationCtrl
                                                  .via2FieldKey;
                                        }
                                      },
                                      child: SizedBox(
                                        height:
                                        screenHeight *
                                            0.05,
                                        child:
                                        TextFormField(
                                          key: locationCtrl
                                              .via2FieldKey,
                                          controller:
                                          locationCtrl
                                              .ViaLocation2Controller,
                                          focusNode:
                                          locationCtrl
                                              .via2TextFieldFocusNode,
                                          onChanged:
                                          locationCtrl
                                              .onInputChanged,
                                          decoration:
                                          InputDecoration(
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                1,
                                                vertical:
                                                10),
                                            filled: true,
                                            fillColor: Color(
                                                0xFFEFF0F2),
                                            prefixIcon: Icon(
                                                Icons
                                                    .alt_route,
                                                color: Color(
                                                    0xFF43489A)),
                                            suffixIcon:
                                            GestureDetector(
                                              onTap: () {
                                                locationCtrl
                                                    .ViaLocation2Controller
                                                    .clear();
                                                locationCtrl
                                                    .suggestions
                                                    .clear();
                                              },
                                              child: Icon(
                                                  Icons
                                                      .cancel,
                                                  color: Color(
                                                      0xFF575797),
                                                  size: 16),
                                            ),
                                            labelText:
                                            'Via Location 2',
                                            labelStyle:
                                            TextStyle(
                                              color: Colors
                                                  .grey,
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                            ),
                                            border:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  5),
                                              borderSide:
                                              BorderSide
                                                  .none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),


                   /*   Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                         Expanded(
                           child: Row(
                             children: [
                               Text(AppText.name,
                                 style: mozillaTextSemiBoldText( context: context,
                                     fontSize: 16,
                                 ),
                               ),
                               SizedBox(
                                 width: 25,
                               ),
                               Flexible(
                                 flex: 1,

                                 fit: FlexFit.loose,
                                 child: SizedBox(
                                   width: Get.width/13,
                                   height: 30,
                                   child: CustomTextField(
                                     controller: TextEditingController(),
                                     borderRadius: 4,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                          Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              Text(AppText.email,
                                style: mozillaTextSemiBoldText( context: context,
                                    fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Flexible(
                                flex: 1,

                                fit: FlexFit.loose,
                                child: SizedBox(
                                  width: Get.width/13,
                                  height: 30,
                                  child: CustomTextField(
                                    controller: TextEditingController(),
                                    borderRadius: 4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                          Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              Text(AppText.mobile,
                                style: mozillaTextSemiBoldText( context: context,
                                    fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Flexible(
                                flex: 1,

                                fit: FlexFit.loose,
                                child: SizedBox(
                                  width: Get.width/13,
                                  height: 30,
                                  child: CustomTextField(
                                    controller: TextEditingController(),
                                    borderRadius: 4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                          Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Text(AppText.tel,
                              style: mozillaTextSemiBoldText( context: context,
                                  fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Flexible(
                              flex: 1,

                              fit: FlexFit.loose,
                              child: SizedBox(
                                width: Get.width/13,
                                height: 35,
                                child: CustomTextField(
                                  controller: TextEditingController(),
                                  borderRadius: 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                        ],
                      ),*/

                      Wrap(
                        spacing: 25, // horizontal gap
                        runSpacing: 15, // vertical gap when wrapped
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _buildField(context, AppText.name),
                          _buildField(context, AppText.email),
                          _buildField(context, AppText.mobile),
                          _buildField(context, AppText.tel),
                        ],
                      ),

                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                  /*    Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          ///todo calender view
                         Expanded(
                           child: Row(
                             children: [
                               Text(AppText.date,
                                 style: mozillaTextSemiBoldText( context: context,
                                     fontSize: 16,
                                 ),
                               ),
                               SizedBox(
                                 width: 25,
                               ),
                               Flexible(
                                 flex: 1,
                                 child: CalendarDropdown(),
                               ),
                             ],
                           ),
                         ),
                          ///todo calender view
                       Expanded(
                         child: Row(
                           children: [
                             SizedBox(
                               width: 25,
                             ),
                             Text(AppText.time,
                               style: mozillaTextSemiBoldText( context: context,
                                   fontSize: 16,
                               ),
                             ),
                             SizedBox(
                               width: 25,
                             ),

                             Flexible(
                               flex: 1,
                               child: CustomTimePicker(),
                             ),
                           ],
                         ),
                       ),
                         Expanded(
                           child: Row(
                             children: [
                               SizedBox(
                                 width: 25,
                               ),
                               Text(AppText.lead,
                                 style: mozillaTextSemiBoldText( context: context,
                                     fontSize: 16,
                                 ),
                               ),
                               SizedBox(
                                 width: 25,
                               ),
                               Flexible(
                                 flex: 1,
                                 child: SizedBox(
                                   height: 30,
                                   child: CustomTextField(
                                     hintText: "MINS",
                                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                     keyboardType: TextInputType.number,
                                     contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                     controller: TextEditingController(),
                                     borderRadius: 4,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                         Expanded(
                           child: Row(
                             children: [
                               SizedBox(
                                 width: 25,
                               ),
                               Text(AppText.jour,
                                 style: mozillaTextSemiBoldText( context: context,
                                     fontSize: 16,
                                 ),
                               ),
                               SizedBox(
                                 width: 25,
                               ),
                               Flexible(
                                 flex: 1,
                                 child: GestureDetector(

                                   child: Container(
                                       height:30,
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(4),
                                         border: Border.all(color: DynamicColors.primaryClr)
                                     ),
                                     child: buildMenuTab(Icons.book_online, "O/W", "Select Plot",
                                         ["O/W", "R/N", "W/R",], jourKey),
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),

                        ],
                      ),*/
        Wrap(
        spacing: 25, // horizontal gap
        runSpacing: 15, // vertical gap
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
        _buildFielddd(
        context,
        AppText.date,
        CalendarDropdown(),
        ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppText.time,
                style: mozillaTextSemiBoldText(
                  context: context,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 200, // fixed width per field
                height: 35,
                child: CustomTimePicker()
              ),
            ],
          ),
          _buildFielddd(
        context,
        AppText.lead,
        SizedBox(
        height: 30,
        child: CustomTextField(
        hintText: "MINS",
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        controller: TextEditingController(),
        borderRadius: 4,
        ),
        ),
        ),
          _buildFielddd(
        context,
        AppText.jour,
        Container(
        height: 30,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: DynamicColors.primaryClr),
        ),
        child: buildMenuTab(
        Icons.book_online,
        "O/W",
        "Select Plot",
        ["O/W", "R/N", "W/R"],
        jourKey,
        ),
        ),
        ),

          // DRIVER Dropdown
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppText.drv,
                style: mozillaTextSemiBoldText(
                  context: context,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 12),
              Container(
                width: 160, // Fixed for better alignment
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                ),
                child: buildMenuTab(
                  Icons.book_online,
                  "DIRVER",
                  "Select Account",
                  ["CASH", "CREDIT CARD", "ACCOUNT", "CREDIT CARD PAID"],
                  dRVKey,
                ),
              ),
            ],
          ),

          // Fare Input
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppText.fare,
                style: mozillaTextSemiBoldText(
                  context: context,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 12),
              SizedBox(
                height: 33,
                width: 120,
                child: CustomTextField(
                  hintText: "Slugg",
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  keyboardType: TextInputType.number,
                  contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  controller: TextEditingController(),
                  borderRadius: 6,
                ),
              ),
            ],
          ),

          // Calendar Button
          Container(
            height: 33,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: DynamicColors.secondaryClr,
              borderRadius: BorderRadius.circular(6),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.calendar_month, size: 20),
              splashRadius: 20,
            ),
          ),
        ],
        ),

                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                  ///todo select two ways
                  /*    Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          // Saloon Field
                          GetBuilder<DashboardController>(
                            builder: (controller) {
                              return Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: SizedBox(
                                  height:
                                  screenHeight * 0.05,
                                  child: TextFormField(
                                    controller: controller
                                        .dateController,
                                    readOnly: true,
                                    onTap: () => controller
                                        .pickDate(context),
                                    decoration:
                                    InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                      EdgeInsets
                                          .symmetric(
                                          horizontal:
                                          16,
                                          vertical:
                                          8),
                                      filled: true,
                                      fillColor:
                                      Color(0xFFEFF0F2),
                                      prefixIcon: Icon(
                                          Icons
                                              .calendar_month_outlined,
                                          color: Color(
                                              0xFF43489A)),
                                      border:
                                      OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            5),
                                        borderSide:
                                        BorderSide.none,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(width: 5),
                          GetBuilder<DashboardController>(
                            builder: (controller) {
                              return Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: SizedBox(
                                  height:
                                  screenHeight * 0.05,
                                  child: TextFormField(
                                    controller: controller
                                        .timeController,
                                    readOnly: true,
                                    onTap: () => controller
                                        .pickTime(context),
                                    decoration:
                                    InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                      EdgeInsets
                                          .symmetric(
                                          horizontal:
                                          16,
                                          vertical:
                                          8),
                                      filled: true,
                                      fillColor:
                                      Color(0xFFEFF0F2),
                                      prefixIcon: Icon(
                                          Icons
                                              .access_time_filled_outlined,
                                          color: Color(
                                              0xFF43489A)),
                                      border:
                                      OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            5),
                                        borderSide:
                                        BorderSide.none,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(width: 5),

                          Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: SizedBox(
                              height: screenHeight * 0.05,
                              child:
                              DropdownButtonFormField<
                                  String>(
                                value: dashboardController.selectedJourneyType,
                                onChanged: (newValue) {
                                  setState(() {
                                    dashboardController.selectedJourneyType =
                                    newValue!;
                                  });
                                },
                                items: [
                                  'Journey Type',
                                  'One Way',
                                  'Two Way'
                                ]
                                    .map((type) =>
                                    DropdownMenuItem(
                                      value: type,
                                      child: Text(
                                        type,
                                        style:
                                        TextStyle(
                                          color: Colors
                                              .black,
                                          fontSize: 13,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),
                                    ))
                                    .toList(),
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8),
                                  filled: true,
                                  fillColor:
                                  Color(0xFFEFF0F2),
                                  suffixIcon: Icon(
                                      Icons
                                          .keyboard_arrow_down_outlined,
                                      color: Color(
                                          0xFF43489A)),
                                  border:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(5),
                                    borderSide:
                                    BorderSide.none,
                                  ),
                                ),
                                icon: SizedBox.shrink(),
                                dropdownColor:
                                Color(0xFFEFF0F2),
                              ),
                            ),
                          ),
                        ],
                      ),*/
                      ///todo select two ways

                 /*     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(AppText.jour,
                                  style: mozillaTextSemiBoldText( context: context,
                                      fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: DynamicColors.primaryClr)
                                      ),
                                      child: buildMenuTab(Icons.book_online, "Select Account", "Select Account",
                                          ["O/W", "R/N", "W/R",], accKey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 25,
                                ),
                                AdvancedSwitch(
                                  controller: controller.switchController,
                                  activeColor: Colors.green,
                                  inactiveColor: Colors.grey,
                                  borderRadius: BorderRadius.all(const Radius.circular(15)),
                                  width: 30.0,
                                  height: 15.0,
                                  enabled: true,
                                  disabledOpacity: 0.5,
                                  onChanged: (v){
                                    // ;
                                    // controller.switchController = ValueNotifier<bool>(false);
                                    // controller.update();
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(AppText.quotation,
                                  style: mozillaTextSemiBoldText( context: context,
                                      fontSize: 16,
                                  ),
                                ),
                              ],
                            ),),
                          Row(
                            children: [
                              Checkbox(
                                  activeColor: DynamicColors.primaryClr,
                                  value: controller.smsCheckbox.value, onChanged: (v){
                                controller.smsCheckbox.value = v!;
                                controller.update();
                              }
                              ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              Text(AppText.sms,
                                style: mozillaTextSemiBoldText( context: context,
                                    fontSize: 16,
                                ),
                              ),

                              SizedBox(width: 35,)
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  activeColor: DynamicColors.primaryClr,
                                  value: controller.emailCheckbox.value, onChanged: (v){
                                controller.emailCheckbox.value = v!;
                                controller.update();
                              }
                              ),
                              Text(AppText.email,
                                style: mozillaTextSemiBoldText( context: context,
                                    fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 35,)
                            ],
                          ),
                          Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 30,
                                      child: CustomTextField(
                                        hintText: "Pass",
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(2),
                                        ],
                                        keyboardType: TextInputType.number,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                        controller: TextEditingController(),
                                        borderRadius: 4,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: SizedBox(
                                        height: 30,
                                        child: CustomTextField(
                                          hintText: "Lugg",
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(2),
                                          ],
                                          keyboardType: TextInputType.number,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                          controller: TextEditingController(),
                                          borderRadius: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 30,
                                      child: CustomTextField(
                                        hintText: "Slugg",
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(2),
                                        ],
                                        keyboardType: TextInputType.number,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                        controller: TextEditingController(),
                                        borderRadius: 4,
                                      ),
                                    ),
                                  ),
                                ],
                              ))

                        ],
                      ),*/
                      Wrap(
                        spacing: 38, // Horizontal gap
                        runSpacing: 10, // Vertical gap when wrapping
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Journey Type + Dropdown
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppText.jour,
                                style: mozillaTextSemiBoldText(
                                  context: context,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 15),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: DynamicColors.primaryClr),
                                ),
                                child: buildMenuTab(
                                  Icons.book_online,
                                  "Select Account",
                                  "Select Account",
                                  ["O/W", "R/N", "W/R"],
                                  accKey,
                                ),
                              ),
                            ],
                          ),

                          // Switch + Quotation
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AdvancedSwitch(
                                controller: controller.switchController,
                                activeColor: Colors.green,
                                inactiveColor: Colors.grey,
                                borderRadius: BorderRadius.circular(15),
                                width: 30,
                                height: 15,
                                onChanged: (v) {},
                              ),
                              SizedBox(width: 10),
                              Text(
                                AppText.quotation,
                                style: mozillaTextSemiBoldText(context: context, fontSize: 16),
                              ),
                            ],
                          ),

                          // SMS Checkbox
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                activeColor: DynamicColors.primaryClr,
                                value: controller.smsCheckbox.value,
                                onChanged: (v) {
                                  controller.smsCheckbox.value = v!;
                                  controller.update();
                                },
                              ),
                              Text(
                                AppText.sms,
                                style: mozillaTextSemiBoldText(context: context, fontSize: 16),
                              ),
                            ],
                          ),

                          // Email Checkbox
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                activeColor: DynamicColors.primaryClr,
                                value: controller.emailCheckbox.value,
                                onChanged: (v) {
                                  controller.emailCheckbox.value = v!;
                                  controller.update();
                                },
                              ),
                              Text(
                                AppText.email,
                                style: mozillaTextSemiBoldText(context: context, fontSize: 16),
                              ),
                            ],
                          ),

                          // Pass, Lugg, Slugg fields
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 30,
                                child: CustomTextField(
                                  hintText: "Pass",
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  keyboardType: TextInputType.number,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
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
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  keyboardType: TextInputType.number,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
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
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  keyboardType: TextInputType.number,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                  controller: TextEditingController(),
                                  borderRadius: 4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(AppText.pay,
                                  style: mozillaTextSemiBoldText( context: context,
                                      fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: Container(
                                      width: Get.width/13,
                                      padding: EdgeInsets.symmetric(horizontal: 6),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: DynamicColors.primaryClr)
                                      ),
                                      child: buildMenuTab(Icons.book_online,
                                          "Cash", "Select Account",
                                          ["CASH", "CREDIT CARD", "ACCOUNT", "CREDIT CARD PAID",],
                                          payKey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Row(
                              children: [
                                Text(AppText.pay,
                                  style: mozillaTextSemiBoldText( context: context,
                                      fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: Container(

                                      width: Get.width/13,
                                      padding: EdgeInsets.symmetric(horizontal: 6),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: DynamicColors.primaryClr)
                                      ),
                                      child: buildMenuTab(Icons.book_online,
                                          "VEH", "Select Account",
                                          ["SALOON", "ESTATE", "MPV6", "MPV PLUS", "MPV7", "MPV EXECUTIVE" , "MINI BUS",],
                                          vehKey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: DynamicColors.secondaryClr,
                              borderRadius: BorderRadius.circular(4)
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                 IconButton(onPressed: (){

                                 }, icon: Icon(Icons.person,
                                 size: 20,
                                 )),
                                 IconButton(onPressed: (){

                                 }, icon: Icon(Icons.shopping_cart_checkout_outlined,
                                   size: 20,
                                 ),
                                 ),
                                 IconButton(onPressed: (){

                                 }, icon: Icon(Icons.attach_money,
                                                         size: 20,
                                 ),
                                 ),
                                 IconButton(onPressed: (){
                                 }, icon: Icon(Icons.note_add_sharp,
                                                         size: 20,
                                 ),
                                 ),
                                ],
                              ),
                            ),
                          )

                        ],
                      ),*/
                      Wrap(
                        spacing: 85, // Horizontal gap between items
                        runSpacing: 15, // Vertical gap between rows
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          // Pay Dropdown
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppText.pay,
                                style: mozillaTextSemiBoldText(
                                  context: context,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 25),
                              GestureDetector(
                                child: Container(
                                  width: Get.width / 13,
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: DynamicColors.primaryClr),
                                  ),
                                  child: buildMenuTab(
                                    Icons.book_online,
                                    "Cash",
                                    "Select Account",
                                    ["CASH", "CREDIT CARD", "ACCOUNT", "CREDIT CARD PAID"],
                                    payKey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // VEH Dropdown
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppText.pay,
                                style: mozillaTextSemiBoldText(
                                  context: context,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 25),
                              GestureDetector(
                                child: Container(
                                  width: Get.width / 13,
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: DynamicColors.primaryClr),
                                  ),
                                  child: buildMenuTab(
                                    Icons.book_online,
                                    "VEH",
                                    "Select Account",
                                    [
                                      "SALOON",
                                      "ESTATE",
                                      "MPV6",
                                      "MPV PLUS",
                                      "MPV7",
                                      "MPV EXECUTIVE",
                                      "MINI BUS"
                                    ],
                                    vehKey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Icon Buttons Section
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: DynamicColors.secondaryClr,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.person, size: 20),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.shopping_cart_checkout_outlined, size: 20),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.attach_money, size: 20),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.note_add_sharp, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
        SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Container(
                        // width: Get.width,
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: DynamicColors.secondaryClr,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // SizedBox(width: 30),
                                // ETA
                                Icon(
                                    Icons
                                        .access_time_filled_outlined,
                                    color: DynamicColors.textClr,
                                    size: 18),
                                // SizedBox(width: 11),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text("ETA : 0.0 mins",
                                      style: TextStyle(
                                          color: DynamicColors.textClr,
                                          fontSize: 13)),
                                ),
                                // SizedBox(width: 40),

                                // JOURNEY
                                Icon(
                                    Icons
                                        .access_time_filled_outlined,
                                    color: DynamicColors.textClr,
                                    size: 18),
                                // SizedBox(width: 11),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text("JOURNEY : 0.0 mins",
                                      style: TextStyle(
                                          color: DynamicColors.textClr,
                                          fontSize: 13)),
                                ),

                                // SizedBox(width: 40),

                                // DISTANCE
                                Icon(Icons.location_on,
                                    color: DynamicColors.textClr,
                                    size: 18),
                                // SizedBox(width: 11),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text("DISTANCE : 0.0 miles",
                                      style: TextStyle(
                                          color: DynamicColors.textClr,
                                          fontSize: 13)),
                                ),

                                // Spacer(),

                                // PR Box
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "PR: \$ 4.90",
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: CustomButton(
                                    width: 90,
                                      height: 30,
                                    btnColor: DynamicColors.redClr,
                                    borderRadius: 3,
                                    verticalPadding: 0,
                                    style: mozillaTextSemiBoldText( context: context,
                                      color: DynamicColors.whiteClr,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800
                                    ),
                                    onTap: (){

                                    },
                                    btnText: "CLEAR [F7]",
                                  ),
                                ),
                                CustomButton(
                                  width: 130,
                                    height: 30,
                                  borderRadius: 3,
                                  verticalPadding: 0,
                                  style: mozillaTextSemiBoldText( context: context,
                                    color: DynamicColors.whiteClr,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800
                                  ),
                                  onTap: (){

                                  },
                                  btnText: "SAVE [HOME]",
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                      /*Container(
                        padding: EdgeInsets.only(
                            top: 10,
                            bottom: 4,
                            right: 10,
                            left: 10),
                        decoration: BoxDecoration(
                          color: DynamicColors.primaryClr,
                          borderRadius:
                          BorderRadius.vertical(
                              bottom:
                              Radius.circular(6)),
                        ),
                        child: Row(
                          children: [
                            // DRIVERS label
                            Text(
                              "DRIVERS",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),

                            SizedBox(width: 10),

                            SizedBox(
                              width: 250,
                              height: screenHeight * 0.05,
                              child:
                              DropdownButtonFormField<
                                  String>(
                                value: dashboardController.selectedDriver,
                                onChanged: (newValue) {
                                  setState(() {
                                    dashboardController.selectedDriver =
                                    newValue!;
                                  });
                                },
                                items: ['Select Driver',"text 1", "text 2"]
                                    .map((type) =>
                                    DropdownMenuItem(
                                      value: type,
                                      child: Text(
                                        type,
                                        style:
                                        TextStyle(
                                          color: Colors
                                              .black,
                                          fontSize: 13,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),
                                    ))
                                    .toList(),
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8),
                                  filled: true,
                                  fillColor:
                                  Color(0xFFEFF0F2),
                                  suffixIcon: Icon(
                                      Icons
                                          .keyboard_arrow_down_outlined,
                                      color: Color(
                                          0xFF43489A)),
                                  border:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(5),
                                    borderSide:
                                    BorderSide.none,
                                  ),
                                ),
                                icon: SizedBox.shrink(),
                                dropdownColor:
                                Color(0xFFEFF0F2),
                              ),
                            ),

                            // SizedBox(width: 8),

                            Spacer(),

                            Row(
                              children: [
                                focusableTextButton("Clear",
                                        () {
                                      print(
                                          "Clear button tapped");
                                      // logic
                                    }),
                                SizedBox(width: 10),
                                focusableTextButton("Quote",
                                        () {
                                      print(
                                          "Quote button tapped");
                                      // logic
                                    }),
                                SizedBox(width: 10),
                                focusableTextButton("Save",
                                        () {
                                      print(
                                          "Save button tapped");
                                      // logic
                                    }),
                              ],
                            )

                            // Buttons
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 28, vertical: 6),
                            //   decoration: BoxDecoration(
                            //     color: Color(0xFF43489A),
                            //     borderRadius:
                            //         BorderRadius.circular(3),
                            //   ),
                            //   child: Text("CLEAR",
                            //       style: TextStyle(
                            //           fontSize: 11,
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.bold)),
                            // ),
                            // SizedBox(width: 29),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 28, vertical: 6),
                            //   decoration: BoxDecoration(
                            //     color: Color(0xFF43489A),
                            //     borderRadius:
                            //         BorderRadius.circular(3),
                            //   ),
                            //   child: Text("QUOTE",
                            //       style: TextStyle(
                            //           fontSize: 11,
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.bold)),
                            // ),
                            // SizedBox(width: 29),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 28, vertical: 6),
                            //   decoration: BoxDecoration(
                            //     color: Color(0xFF43489A),
                            //     borderRadius:
                            //         BorderRadius.circular(3),
                            //   ),
                            //   child: Text("SAVE",
                            //       style: TextStyle(
                            //           fontSize: 11,
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.bold)),
                            // ),
                          ],
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ));
      }
    );
  }

  /// Reusable Field Builder
  Widget _buildFielddd(BuildContext context, String label, Widget fieldWidget) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: mozillaTextSemiBoldText(
            context: context,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 200, // field width
          child: fieldWidget,
        ),
      ],
    );
  }

  /// Reusable Field Widget
  Widget _buildField(BuildContext context, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: mozillaTextSemiBoldText(
            context: context,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 200, // fixed width per field
          height: 35,
          child: CustomTextField(
            controller: TextEditingController(),
            borderRadius: 4,
          ),
        ),
      ],
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


///todo calender widget




///todo calender widget

///todo Time widget

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({Key? key}) : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  final TextEditingController _timeController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  int selectedHour = 9;
  int selectedMinute = 8;
  String selectedPeriod = "AM";

  @override
  void initState() {
    super.initState();
    _updateTimeText();
  }

  void _updateTimeText() {
    final hourStr = selectedHour.toString().padLeft(2, '0');
    final minuteStr = selectedMinute.toString().padLeft(2, '0');
    _timeController.text = "$hourStr:$minuteStr $selectedPeriod";
  }

  void _toggleTimeDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _closeDropdown();
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectAndClose({int? hour, int? minute, String? period}) {
    setState(() {
      if (hour != null) selectedHour = hour;
      if (minute != null) selectedMinute = minute;
      if (period != null) selectedPeriod = period;
      _updateTimeText();
    });
    _closeDropdown();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + 80,
        width: 260,
        height: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            child: Row(
              children: [
                _buildScrollColumn(
                  1,
                  12,
                  selectedHour,
                      (value) => _selectAndClose(hour: value),
                ),
                _buildScrollColumn(
                  0,
                  59,
                  selectedMinute,
                      (value) => _selectAndClose(minute: value),
                ),
                _buildAmPmColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollColumn(int start, int end, int selected, Function(int) onSelect) {
    return Expanded(
      child: ListView.builder(
        itemCount: end - start + 1,
        itemBuilder: (context, index) {
          int value = start + index;
          final valueStr = value.toString().padLeft(2, '0');
          final isSelected = value == selected;

          return InkWell(
            onTap: () => onSelect(value),
            child: Container(
              padding: const EdgeInsets.all(12),
              color: isSelected ? Colors.blue : null,
              child: Center(
                child: Text(
                  valueStr,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmPmColumn() {
    return Expanded(
      child: Column(
        children: ['AM', 'PM'].map((period) {
          final isSelected = period == selectedPeriod;
          return InkWell(
            onTap: () => _selectAndClose(period: period),
            child: Container(
              padding: const EdgeInsets.all(12),
              color: isSelected ? Colors.blue : null,
              child: Center(
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CompositedTransformTarget(
        link: _layerLink,
        child: SizedBox(
          height: 30,
          child: TextFormField(
            controller: _timeController,
            readOnly: true,
            onTap: _toggleTimeDropdown,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 6),
              hintText: "TIME",
              suffixIcon: Icon(Icons.access_time,
              size: 18,
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}


///todo Time widget

