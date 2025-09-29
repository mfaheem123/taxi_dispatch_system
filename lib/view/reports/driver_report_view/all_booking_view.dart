


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/radio_button_widget.dart';
import '../../../component/text_field.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class AllBookingView extends StatefulWidget {
  const AllBookingView({super.key});

  @override
  State<AllBookingView> createState() => _AllBookingViewState();
}

class _AllBookingViewState extends State<AllBookingView> {

  int selectedRowIndex = 0;
  final int totalRows = 5;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());



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
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppText.status,
                      style: mozillaTextRegularText(fontSize: 12),
                    ),
                    StatusRadioGroup(
                      options: [
                        "All",
                        "Completed",
                        "Incomplete",
                        "Missed",
                        "Declined",
                        "Cancelled",
                      ],
                      onChanged: (index, value) {
                        debugPrint("Selected index: $index, value: $value");
                        // controller.selectedValue = index;  // 👈 yahan apne controller me update karlo
                      },
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    KeyboardCheckbox(
                      focusNode: controller.ptNode,
                      value: controller.ptValue.value,
                      label: AppText.pt,
                      width: 60,
                      onChanged: (val) {
                        controller.ptValue.value = val;
                        controller.update();
                      },
                    ),
                    KeyboardCheckbox(
                      focusNode: controller.cashNode,
                      value: controller.cashValue.value,
                      label: AppText.cash,
                      width: 90,
                      onChanged: (val) {
                        controller.cashValue.value = val;
                        controller.update();
                      },
                    ),
                    KeyboardCheckbox(
                      focusNode: controller.accountNode,
                      value: controller.accountValue.value,
                      label: AppText.account,
                      width: 100,
                      onChanged: (val) {
                        controller.accountValue.value = val;
                        controller.update();
                      },
                    ),
                    KeyboardCheckbox(
                      focusNode: controller.creditCardPaidNode,
                      value: controller.creditCardPaidValue.value,
                      label: AppText.creditCardPaid,
                      width: 160,
                      onChanged: (val) {
                        controller.creditCardPaidValue.value = val;
                        controller.update();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 16,
                  children: [
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      width: fieldWidth/1.5,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: "",
                      width: fieldWidth/1.5,
                      child: SizedBox(height: 30, child: CustomTimePicker()),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.to,
                      width: fieldWidth/1.5,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: "",
                      width: fieldWidth/1.5,
                      child: SizedBox(height: 30, child: CustomTimePicker()),
                    ),
                    CustomTextField(
                      borderRadius: 4,
                      controller: controller.customerController,
                      width: fieldWidth/1.5,
                      hintText: AppText.customer,
                    ),
                    CustomTextField(
                      borderRadius: 4,
                      controller: controller.nameController,
                      width: fieldWidth/1.5,
                      hintText: AppText.name,
                    ),
                    CustomTextField(
                      borderRadius: 4,
                      controller: controller.phoneController,
                      width: fieldWidth/1.5,
                      hintText: AppText.tel,
                    ),
                    CustomTextField(
                      borderRadius: 4,
                      controller: controller.pickUpController,
                      width: fieldWidth/1.5,
                      hintText: AppText.pick,
                    ),
                    CustomTextField(
                      borderRadius: 4,
                      controller: controller.dropUpController,
                      width: fieldWidth/1.5,
                      hintText: AppText.drop,
                    ),
                    CustomTextField(
                      borderRadius: 4,
                      controller: controller.orderNumberController,
                      width: fieldWidth/1.5,
                      hintText: AppText.orderNumber,
                    ),
                    CustomTextField(
                      borderRadius: 4,
                      controller: controller.bookedByController,
                      width: fieldWidth/1.5,
                      hintText: AppText.bookedBy,
                    ),
                  ],
                )
              ],
            );
          }
        );
      }
    );
  }
}
