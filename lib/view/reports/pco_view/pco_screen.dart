


import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../component/customButton.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/radio_button_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class PcoScreen extends StatefulWidget {
  const PcoScreen({super.key});

  @override
  State<PcoScreen> createState() => _PcoScreenState();
}

class _PcoScreenState extends State<PcoScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (controller) {

      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
            ? maxWidth / 2
            : maxWidth / 4;

            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  runAlignment: WrapAlignment.start,
                  spacing: 10,
                  runSpacing: 16,
                  children: [
                    Text(AppText.creditCardPayment,
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      width: fieldWidth/1.5,
                      column: true,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      column: true,
                      label: AppText.to,
                      width: fieldWidth/1.5,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),

                    StatusRadioGroup(
                      options: [
                        "All",
                        "Completed",
                        "Cancelled",
                      ],
                      onChanged: (index, value) {
                        debugPrint("Selected index: $index, value: $value");
                        // controller.selectedValue = index;  // 👈 yahan apne controller me update karlo
                      },
                    ),
                    CustomDropdownField<String>(
                      text: AppText.selectDriver,
                      width: fieldWidth/1.5,
                      label: AppText.selectDriver,
                      items:[
                        "25 GEORGE HAMPTON1",
                        "25 GEORGE HAMPTON2",
                        "25 GEORGE HAMPTON3",
                        "25 GEORGE HAMPTON4",
                        "25 GEORGE HAMPTON5",
                        "25 GEORGE HAMPTON6",],
                      value: controller.selectBookingDriver,
                      itemLabel: (val) => val, // just show the string
                      onChanged: (val) {
                        controller.selectBookingDriver = val!;
                        controller.update();
                      },
                    ),
                    SizedBox(width: 20,),

                    SizedBox(width: 20,),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.driver,
                      fontSize: 12,
                    ),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.vehicle,
                      fontSize: 12,
                    ),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.view,
                      fontSize: 12,
                    ),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.generate,
                      fontSize: 12,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          }
        );
      }
    );
  }
}
