import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/shortcut_key_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../component/calender.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../Controller/dashboard_controller.dart';
import '../widgets/pickup_widget.dart';
import '../widgets/time_picker_widget.dart';
import '../widgets/user_info_widget.dart';
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

  final dashboardController = Get.find<DashboardController>();
  String selectedMenu = "";
  String selectedDropdownItem = "";


  String? selectedDropDownValue;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<DashboardController>(builder: (controller) {
      return Container(
          width: width >= 1900 ? screenWidth * 0.45:screenWidth,
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
              ///todo pick and drop widget
              PickupWidget(),
              ///todo pick and drop widget
              SizedBox(
                height: screenHeight * 0.01,
              ),
              if (dashboardController.selectedJourneyType ==
                  'Two Way') ...[
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: Column(
                        children: [
                          RawKeyboardListener(
                            focusNode: controller.via1KeyboardFocusNode,
                            onKey: (event) {
                              if (event is RawKeyDownEvent) {
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.arrowDown) {
                                  if (controller
                                      .highlightedIndex.value <
                                      controller.suggestions.length -
                                          1) {
                                    controller.highlightedIndex.value++;
                                  }
                                } else if (event.logicalKey ==
                                    LogicalKeyboardKey.arrowUp) {
                                  if (controller
                                      .highlightedIndex.value >
                                      0) {
                                    controller.highlightedIndex.value--;
                                  }
                                } else if (event.logicalKey ==
                                    LogicalKeyboardKey.enter) {
                                  final selected =
                                  controller.suggestions[
                                  controller
                                      .highlightedIndex.value];
                                  controller.selectSuggestion(selected);
                                }
                              }
                            },
                            child: Focus(
                              focusNode: controller.via1FocusNode,
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                  controller.activeFieldKey.value =
                                      controller.via1FieldKey;
                                }
                              },
                              child: SizedBox(
                                height: screenHeight * 0.05,
                                child: TextFormField(
                                  key: controller.via1FieldKey,
                                  controller:
                                  controller.ViaLocation1Controller,
                                  focusNode:
                                  controller.via1TextFieldFocusNode,
                                  onChanged: controller.onInputChanged,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 1, vertical: 10),
                                    filled: true,
                                    fillColor: Color(0xFFEFF0F2),
                                    prefixIcon: Icon(Icons.alt_route,
                                        color: Color(0xFF43489A)),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        controller
                                            .ViaLocation1Controller
                                            .clear();
                                        controller.suggestions.clear();
                                      },
                                      child: Icon(Icons.cancel,
                                          color: Color(0xFF575797),
                                          size: 16),
                                    ),
                                    labelText: 'Via Location 1',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
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
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: Column(
                        children: [
                          RawKeyboardListener(
                            focusNode: controller.via2KeyboardFocusNode,
                            onKey: (event) {
                              if (event is RawKeyDownEvent) {
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.arrowDown) {
                                  if (controller
                                      .highlightedIndex.value <
                                      controller.suggestions.length -
                                          1) {
                                    controller.highlightedIndex.value++;
                                  }
                                } else if (event.logicalKey ==
                                    LogicalKeyboardKey.arrowUp) {
                                  if (controller
                                      .highlightedIndex.value >
                                      0) {
                                    controller.highlightedIndex.value--;
                                  }
                                } else if (event.logicalKey ==
                                    LogicalKeyboardKey.enter) {
                                  final selected =
                                  controller.suggestions[
                                  controller
                                      .highlightedIndex.value];
                                  controller.selectSuggestion(selected);
                                }
                              }
                            },
                            child: Focus(
                              focusNode: controller.via2FocusNode,
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                  controller.activeFieldKey.value =
                                      controller.via2FieldKey;
                                }
                              },
                              child: SizedBox(
                                height: screenHeight * 0.05,
                                child: TextFormField(
                                  key: controller.via2FieldKey,
                                  controller:
                                  controller.ViaLocation2Controller,
                                  focusNode:
                                  controller.via2TextFieldFocusNode,
                                  onChanged: controller.onInputChanged,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 1, vertical: 10),
                                    filled: true,
                                    fillColor: Color(0xFFEFF0F2),
                                    prefixIcon: Icon(Icons.alt_route,
                                        color: Color(0xFF43489A)),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        controller
                                            .ViaLocation2Controller
                                            .clear();
                                        controller.suggestions.clear();
                                      },
                                      child: Icon(Icons.cancel,
                                          color: Color(0xFF575797),
                                          size: 16),
                                    ),
                                    labelText: 'Via Location 2',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
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
              ///todo user info widget
              UserInfoWidget(),
              ///todo user info widget
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Wrap(
                spacing: 10, // horizontal gap
                runSpacing: 8, // vertical gap
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
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ///todo Time widget
                      SizedBox(
                          width: 180, // fixed width per field
                          height: 30,
                          child:  CustomTimePicker()),
                      ///todo Time widget
                    ],
                  ),
                  _buildFielddd(
                    context,
                    AppText.lead,
                    SizedBox(
                      height: 30,
                      child: CustomTextField(
                        hintText: "MINS",
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 4),
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
                        border:
                        Border.all(color: DynamicColors.primaryClr),
                      ),
                      child: buildMenuTab(
                        Icons.book_online,
                        "O/W",
                        "Select Plot",
                        ["O/W", "R/N", "W/R"],
                        controller.jourKey,
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
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        width: 160,
                        height: 30,
                        // Fixed for better alignment
                        padding: EdgeInsets.symmetric(
                            horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: DynamicColors.primaryClr,
                              width: 1.2),
                        ),
                        child: CustomDropdownButton(
                          itemList:   [
                            "25 GEORGE HAMPTON",
                            "26 PAUL DOUBLEDAY",
                            "27 RICHARD HARDWICK",
                            "28 LANRE OKERJO"
                          ],
                          hintText: "Driver",
                          selectedDropDownValue: selectedDropDownValue,
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
                          fontSize: 13,
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 6, vertical: 8),
                          controller: TextEditingController(),
                          borderRadius: 6,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppText.acc,
                        style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 15),
                      SizedBox(
                        height: 33,
                        width: 150,
                        child: CustomTextField(
                          hintText: "SELECT ACCOUNT",
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          keyboardType: TextInputType.number,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 6, vertical: 8),
                          controller: TextEditingController(),
                          borderRadius: 6,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppText.pay,
                        style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        child: Container(
                          width: Get.width / 13,
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: DynamicColors.primaryClr),
                          ),
                          child: buildMenuTab(
                            Icons.book_online,
                            "Cash",
                            "Select Account",
                            [
                              "CASH",
                              "CREDIT CARD",
                              "ACCOUNT",
                              "CREDIT CARD PAID"
                            ],
                            controller.payKey,
                          ),
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
                    child: Icon(Icons.calendar_month, size: 20),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Wrap(
                spacing: 38, // Horizontal gap
                runSpacing: 10, // Vertical gap when wrapping
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppText.veh,
                        style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 25),
                      GestureDetector(
                        child: Container(
                          width: Get.width / 13,
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: DynamicColors.primaryClr),
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
                            controller.vehKey,
                          ),
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
                        style: mozillaTextSemiBoldText(
                            context: context, fontSize: 13),
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
                        style: mozillaTextSemiBoldText(
                            context: context, fontSize: 13),
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
                        style: mozillaTextSemiBoldText(
                            context: context, fontSize: 13),
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
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 4),
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
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 4),
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
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 4),
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
              Wrap(
                spacing: 85, // Horizontal gap between items
                runSpacing: 15, // Vertical gap between rows
                alignment: WrapAlignment.spaceBetween,
                children: [
                  // Pay Dropdown


                  // VEH Dropdown


                  // Icon Buttons Section
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: DynamicColors.secondaryClr,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.person, size: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                              Icons.shopping_cart_checkout_outlined,
                              size: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.attach_money, size: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.note_add_sharp, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: DynamicColors.secondaryClr,
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 8,
                  spacing: 20,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time_filled_outlined,
                                color: DynamicColors.textClr, size: 18),
                            SizedBox(width: 4),
                            Text("ETA : 0.0 mins",
                                style: TextStyle(
                                    color: DynamicColors.textClr,
                                    fontSize: 13)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time_filled_outlined,
                                color: DynamicColors.textClr, size: 18),
                            SizedBox(width: 4),
                            Text("JOURNEY : 0.0 mins",
                                style: TextStyle(
                                    color: DynamicColors.textClr,
                                    fontSize: 13)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on,
                                color: DynamicColors.textClr, size: 18),
                            SizedBox(width: 4),
                            Text("DISTANCE : 0.0 miles",
                                style: TextStyle(
                                    color: DynamicColors.textClr,
                                    fontSize: 13)),
                          ],
                        ),
                        Container(
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
                    Wrap(
                      spacing: 10,
                      children: [
                        CustomButton(
                          width: 90,
                          height: 30,
                          btnColor: DynamicColors.redClr,
                          borderRadius: 3,
                          verticalPadding: 0,
                          style: mozillaTextSemiBoldText(
                            context: context,
                            color: DynamicColors.whiteClr,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                          onTap: () {},
                          btnText: "CLEAR [F7]",
                        ),
                        CustomButton(
                          width: 130,
                          height: 30,
                          borderRadius: 3,
                          verticalPadding: 0,
                          style: mozillaTextSemiBoldText(
                            context: context,
                            color: DynamicColors.whiteClr,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                          onTap: () {},
                          btnText: "SAVE [HOME]",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
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
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 150, // field width
          child: fieldWidget,
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