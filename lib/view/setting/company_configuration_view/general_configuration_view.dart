import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../controller/setting_controller.dart';

class GeneralConfigurationView extends StatefulWidget {
  const GeneralConfigurationView({super.key});

  @override
  State<GeneralConfigurationView> createState() =>
      _GeneralConfigurationViewState();
}

class _GeneralConfigurationViewState extends State<GeneralConfigurationView> {
  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      builder: (controller) {
        return LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isMobile = maxWidth < 750;

          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: DynamicColors.secondaryClr,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Container(
                      width: Get.width,
                      height: kToolbarHeight,
                      color: DynamicColors.secondaryClr,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: Text(
                          AppText.generalConfiguration,
                          style: titleDesign(),
                        ),
                      ),
                    ),

                    // const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: isMobile
                          ? Column(
                        children: [
                          buildLeftFields(),
                          const Divider(height: 30, thickness: 1),
                          buildRightCheckboxes(),
                        ],
                      )

                          : IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 7,
                              child: buildLeftFields(),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0),
                              child: VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: Colors.grey.shade400,
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: buildRightCheckboxes(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          );
        });
      },
    );
  }


  // LEFT SIDE: INPUT FIELDS

  Widget buildLeftFields() {
    const double horizontalSpacing = 16.0;
    const double runSpacing = 26.0;

    return Column(
      children: [
        // ROW 1
        Row(
          children: [
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.tabbookingInHouss, hintText: AppText.tabBooksinHours, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.tabBooksinday, hintText: AppText.tabBooksinday, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.tabrecentBooksinday, hintText: AppText.tabrecentBooksinday, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.tabBooksAfterminuts, hintText: AppText.tabBooksAfterminuts, columnText: true)),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 2
        Row(
          children: [
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.bookingExpiryNoties, hintText: AppText.bookingExpiryNoties, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.airportBookingExpiryNotice, hintText: AppText.airportBookingExpiryNotice, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.accountBookingExpiry, hintText: AppText.accountBookingExpiry, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.driverExpiryNotice, hintText: AppText.driverExpiryNotice, columnText: true)),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 3
        Row(
          children: [
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.flightTrackerAPI, hintText: AppText.flightTrackerAPI, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(
              child: CustomDropdownField<String>(
                text: AppText.type,
                label: AppText.amount,
                items: const ["AMOUNT", "PERCENTAGE"],
                value: controller.typeAmount,
                itemLabel: (val) => val,
                onChanged: (val) {
                  controller.typeAmount = val!;
                  controller.update();
                },
              ),
            ),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.creditCardCharges, hintText: AppText.creditCardCharges, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.roundOffFares, hintText: AppText.roundOffFares, columnText: true)),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 4 (3 Fields)
        Row(
          children: [
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.discountOneWay, hintText: AppText.discountOneWay, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.discountReturn, hintText: AppText.discountReturn, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.discountWaitAndReturn, hintText: AppText.discountWaitAndReturn, columnText: true)),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 5
        Row(
          children: [
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.huntGroup, hintText: AppText.huntGroup, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.baseAddress, hintText: AppText.baseAddress, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.deadMileageMiles, hintText: AppText.deadMileageMiles, columnText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(borderRadius: 4, controller: controller.deadMileageMethods, hintText: AppText.deadMileageMethods, columnText: true)),
          ],
        ),
      ],
    );
  }

  // RIGHT SIDE: CHECKBOXES

  Widget buildRightCheckboxes() {
    const double checkboxSpacing = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KeyboardCheckbox(
          onChanged: (v) { controller.bookingQuotationSMSValue.value = v; controller.update(); },
          label: AppText.bookingQuotationSMS,
          value: controller.bookingQuotationSMSValue.value,
          focusNode: controller.bookingQuotationSMSNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) { controller.enableBookingTextValue.value = v; controller.update(); },
          label: AppText.enableBookingText,
          value: controller.enableBookingTextValue.value,
          focusNode: controller.enableBookingTextNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) { controller.peakFactorsValue.value = v; controller.update(); },
          label: AppText.peakFactor,
          value: controller.peakFactorsValue.value,
          focusNode: controller.peakFactorsNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) { controller.webBookerConfValue.value = v; controller.update(); },
          label: AppText.webBookerConfiguration,
          value: controller.webBookerConfValue.value,
          focusNode: controller.webBookerConfNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) { controller.customerAppConfValue.value = v; controller.update(); },
          label: AppText.customerAppConfirmation,
          value: controller.customerAppConfValue.value,
          focusNode: controller.customerAppConfNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) { controller.bookingDueNotiValue.value = v; controller.update(); },
          label: AppText.bookingDueNotification,
          value: controller.bookingDueNotiValue.value,
          focusNode: controller.bookingDueNotiNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) { controller.enableCustomerValue.value = v; controller.update(); },
          label: AppText.enableCustomText,
          value: controller.enableCustomerValue.value,
          focusNode: controller.enableCustomerNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) { controller.notificationValue.value = v; controller.update(); },
          label: AppText.notifictaion,
          value: controller.notificationValue.value,
          focusNode: controller.notificationNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) { controller.deadMileageValue.value = v; controller.update(); },
          label: AppText.deadMileage,
          value: controller.deadMileageValue.value,
          focusNode: controller.deadMileageNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) { controller.callFeaturesValue.value = v; controller.update(); },
          label: AppText.callFeatures,
          value: controller.callFeaturesValue.value,
          focusNode: controller.callFeaturesNode,
          width: double.infinity,
        ),
      ],
    );
  }
}