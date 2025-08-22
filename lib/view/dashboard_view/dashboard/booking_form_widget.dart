import 'package:dashboard_new1/component/child_seats_alert.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/restrict_drivers_alert.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../Controller/dashboard_controller.dart';
import '../widgets/pickup_widget.dart';
import '../widgets/quotation_widget.dart';
import '../widgets/user_info_widget.dart';
import '../widgets/via_location.dart';
import 'F3_alert.dart';
import 'form_short_cut_key.dart';


class BookingFormWidget extends StatefulWidget {
  BookingFormWidget({super.key});


  @override
  State<BookingFormWidget> createState() => _BookingFormWidgetState();
}

class _BookingFormWidgetState extends State<BookingFormWidget> {

  final dashboardController = Get.find<DashboardController>();
  String selectedMenu = "";
  String selectedDropdownItem = "";

  // FocusNodes
  final FocusNode vehFocus = FocusNode();
  final List<FocusNode> _focusNodes =
  List.generate(4, (index) => FocusNode()); // 4 icons


  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  final FocusNode luggFocus = FocusNode();
  final FocusNode sluggFocus = FocusNode();
  final FocusNode checkboxFocus = FocusNode();

  // Controllers

  // State variables
  bool switchValue = false;
  bool smsChecked = false;
  bool emailChecked = false;

  @override
  void dispose() {
    // vehFocus.dispose();
    // emailFocus.dispose();
    // passFocus.dispose();
    // luggFocus.dispose();
    // sluggFocus.dispose();
    // checkboxFocus.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<DashboardController>(
        builder: (controller) {
      return Container(
          width: width >= 1900 ? screenWidth * 0.45: screenWidth,
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

              ///todo user info widget
              UserInfoWidget(),
              ///todo user info widget

                /*  Wrap(
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
              ),*/
              SizedBox(
                height: screenHeight * 0.01,
              ),
              FocusTraversalGroup(
                policy: WidgetOrderTraversalPolicy(),
                child: Wrap(
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
                            height: 30,
                            width: Get.width / 13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: DynamicColors.primaryClr),
                            ),
                            child:
                            CustomDropdownButton(
                              itemList: ["SALOON",
                                "ESTATE",
                                "MPV6",
                                "MPV PLUS",
                                "MPV7",
                                "MPV EXECUTIVE",
                                "MINI BUS"],
                              hintText: "VEH",
                              selectedDropDownValue: controller.vehKey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Switch + Quotation
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QuotationWidget(),
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
                        RawKeyboardListener(
                          focusNode: checkboxFocus,
                          onKey: (event) {
                            if (event is RawKeyDownEvent &&
                                (event.logicalKey == LogicalKeyboardKey.enter ||
                                    event.logicalKey == LogicalKeyboardKey.space)) {
                              setState(() {
                                controller.smsCheckbox.value = !controller.smsCheckbox.value; // ✅ toggle
                              });
                            }
                          },
                          child: Checkbox(
                            activeColor: DynamicColors.primaryClr,
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

                    // Email Checkbox
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RawKeyboardListener(
                          focusNode: emailFocus,
                          onKey: (event) {
                            if (event is RawKeyDownEvent &&
                                (event.logicalKey == LogicalKeyboardKey.enter ||
                                    event.logicalKey == LogicalKeyboardKey.space)) {
                              setState(() {
                                controller.emailCheckbox.value = !controller.emailCheckbox.value; // ✅ toggle
                              });
                            }
                          },
                          child: Checkbox(
                            activeColor: DynamicColors.primaryClr,
                            value: controller.emailCheckbox.value,
                            onChanged: (v) {
                              controller.emailCheckbox.value = v!;
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
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFocusableIcon(
                        icon: Icons.person,
                        focusNode: _focusNodes[0],
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  RestrictDriversAlert());
                        },
                      ),
                      _buildFocusableIcon(
                        icon: Icons.shopping_cart_checkout_outlined,
                        focusNode: _focusNodes[1],
                        onPressed: () {

                          showDialog(
                              context: context,
                              builder: (_) =>
                                  ChildSeatsAlert(),
                          );
                        },
                      ),
                      _buildFocusableIcon(
                        icon: Icons.attach_money,
                        focusNode: _focusNodes[2],
                        onPressed: () => print("Money clicked"),
                      ),
                      _buildFocusableIcon(
                        icon: Icons.note_add_sharp,
                        focusNode: _focusNodes[3],
                        onPressed: () => print("Note clicked"),
                      ),
                    ],
                  ),
                ),
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
                          onTap: () {
                            controller.shortCutKeyValue.value ="shortCutKey";
                            controller.update();
                          },
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


  Widget _buildFocusableIcon({
    required IconData icon,
    required VoidCallback onPressed,
    required FocusNode focusNode,
  }) {
    return Focus(
      focusNode: focusNode,
      onKey: (node, event) {
        if (event is RawKeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: onPressed,
        child: Builder(
          builder: (context) {
            final isFocused = Focus.of(context).hasFocus; // 👈 direct focus check
            return AnimatedScale(
              scale: isFocused ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isFocused
                      ? DynamicColors.primaryClr.withOpacity(0.2)
                      : Colors.transparent,
                  // border: isFocused
                  //     ? Border.all(color: Colors.orange, width: 2)
                  //     : null,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 20),
              ),
            );
          },
        ),
      ),
    );
  }
}

///todo calender widget

///todo calender widget