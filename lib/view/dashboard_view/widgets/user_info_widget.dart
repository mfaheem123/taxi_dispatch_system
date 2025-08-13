


import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../component/calender.dart';
import '../../../component/color.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';

class UserInfoWidget extends StatelessWidget {
  UserInfoWidget({super.key});

  String? selectedDropDownValue;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return LayoutBuilder(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildResponsiveField(context, AppText.name, isMobile),
                        SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),
                        _buildResponsiveField(context, AppText.email, isMobile),
                        SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),
                        _buildResponsiveField(context, AppText.mobile, isMobile),
                        SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),
                        _buildResponsiveField(context, AppText.tel, isMobile),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isMobile = constraints.maxWidth < 600;

                      return SingleChildScrollView(
                        scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            buildResponsiveField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.date,
                              child: KeyboardDatePicker(),
                            ),

                            buildResponsiveField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.time,
                              child: CustomTimePicker(),
                            ),

                            buildResponsiveField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.lead,
                              child: CustomTextField(
                                hintText: "MINS",
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(),
                                borderRadius: 4,
                              ),
                            ),

                            buildResponsiveField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.jour,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: DynamicColors.primaryClr),
                                ),
                                child:
                                CustomDropdownButton(
                                  itemList: [
                                    "O/W", "R/N", "W/R"
                                  ],
                                  hintText: "O/W",
                                  selectedDropDownValue: selectedDropDownValue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isMobile = constraints.maxWidth < 600;

                      return SingleChildScrollView(
                        scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            buildResponsiveField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.drv,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: DynamicColors.primaryClr,
                                    width: 1.2,
                                  ),
                                ),
                                child: CustomDropdownButton(
                                  itemList: [
                                    "25 GEORGE HAMPTON",
                                    "26 PAUL DOUBLEDAY",
                                    "27 RICHARD HARDWICK",
                                    "28 LANRE OKERJO"
                                  ],
                                  hintText: "Driver",
                                  selectedDropDownValue: selectedDropDownValue,
                                ),
                              ),
                            ),

                            buildResponsiveField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.fare,
                              child: CustomTextField(
                                hintText: "Slugg",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(),
                                borderRadius: 6,
                              ),
                            ),

                            buildResponsiveField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.acc,
                              child: CustomTextField(
                                hintText: "SELECT ACCOUNT",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(),
                                borderRadius: 6,
                              ),
                            ),

                            buildResponsiveField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.pay,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: DynamicColors.primaryClr),
                                ),
                                child:
                                CustomDropdownButton(
                                  itemList: [
                                    "CASH",
                                    "CREDIT CARD",
                                    "ACCOUNT",
                                    "CREDIT CARD PAID"
                                  ],
                                  hintText: "Cash",
                                  selectedDropDownValue: selectedDropDownValue,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 33,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: DynamicColors.secondaryClr,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(Icons.calendar_month, size: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }
        );
      }
    );
  }

  Widget buildResponsiveField({
    required BuildContext context,
    required bool isMobile,
    required String label,
    required Widget child,
    double height = 30,
    double fixedWidth = 150,
  }) {
    return SizedBox(
      height: height,
      child: Row(
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
          if (isMobile)
            Expanded(child: child)
          else
            SizedBox(width: fixedWidth, child: child),
        ],
      ),
    );
  }


  /// Responsive Field Widget
  Widget _buildResponsiveField(BuildContext context, String label, bool isMobile) {
    return SizedBox(
      height: 30, // same height for all
      child: Row(
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
          if (isMobile)
            Expanded(
              child: CustomTextField(
                controller: TextEditingController(),
                borderRadius: 4,
              ),
            )
          else
            SizedBox(
              width: 150,
              child: CustomTextField(
                controller: TextEditingController(),
                borderRadius: 4,
              ),
            )

        ],
      ),
    );
  }

}
