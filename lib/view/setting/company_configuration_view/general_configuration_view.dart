import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                              child: FocusTraversalGroup(
                                policy: OrderedTraversalPolicy(),
                                  child: buildLeftFields(),
                                )),
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
                                  child: FocusTraversalGroup(
                                    policy: OrderedTraversalPolicy(),
                                  child: buildRightCheckboxes(),
                                )),
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
            // Expanded(child: CustomTextField(borderRadius: 4, controller: controller.tabbookingInHouss, hintText: AppText.tabBooksinHours, columnText: true)),
            buildNumberField(controller.tabbookingInHouss, AppText.tabBooksinHours),
            const SizedBox(width: horizontalSpacing),
            buildNumberField(controller.tabBooksinday, AppText.tabBooksinday),
            const SizedBox(width: horizontalSpacing),
            buildNumberField(controller.tabrecentBooksinday, AppText.tabrecentBooksinday),
            const SizedBox(width: horizontalSpacing),
            buildNumberField(controller.tabBooksAfterminuts, AppText.tabBooksAfterminuts),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 2
        Row(
          children: [
            buildNumberField(controller.bookingExpiryNoties, AppText.bookingExpiryNoties),
            const SizedBox(width: horizontalSpacing),
            buildNumberField(controller.airportBookingExpiryNotice, AppText.airportBookingExpiryNotice),
            const SizedBox(width: horizontalSpacing),
            buildNumberField(controller.accountBookingExpiry, AppText.accountBookingExpiry),
            const SizedBox(width: horizontalSpacing),
            buildNumberField(controller.driverExpiryNotice, AppText.driverExpiryNotice),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 3
        Row(
          children: [
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.flightTrackerAPI,
              hintText: AppText.flightTrackerAPI,
              columnText: true,
              obscureText: true,
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(
              child: CustomDropdownField<String>(
                text: AppText.type,
                label: "SELECT TYPE",
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
            buildNumberField(
                controller.creditCardCharges, AppText.creditCardCharges),
            const SizedBox(width: horizontalSpacing),
            buildNumberField(controller.roundOffFares, AppText.roundOffFares),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 4
        Row(
          children: [
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.discountOneWay,
              hintText: AppText.discountOneWay,
              columnText: true,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]*')),
                UpperCaseTextFormatter()],
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.discountReturn,
              hintText: AppText.discountReturn,
              columnText: true,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]*')),
                UpperCaseTextFormatter()],)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.discountWaitAndReturn,
              hintText: AppText.discountWaitAndReturn,
              columnText: true,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]*')),
                UpperCaseTextFormatter()],)),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 5
        Row(
          children: [
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.huntGroup,
              hintText: AppText.huntGroup,
              columnText: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.baseAddress,
              hintText: AppText.baseAddress,
              columnText: true,
              inputFormatters: [UpperCaseTextFormatter()],
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.deadMileageMiles,
              hintText: AppText.deadMileageMiles,
              columnText: true,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]*')),
                UpperCaseTextFormatter()],
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.deadMileageMethods,
              hintText: AppText.deadMileageMethods,
              columnText: true,
              inputFormatters: [
                UpperCaseTextFormatter()],
            )),
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
          onChanged: (v) {
            controller.bookingQuotationSMSValue.value = v;
            controller.update();
          },
          label: AppText.bookingQuotationSMS,
          value: controller.bookingQuotationSMSValue.value,
          focusNode: controller.bookingQuotationSMSNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.enableBookingTextValue.value = v;
            controller.update();
          },
          label: AppText.enableBookingText,
          value: controller.enableBookingTextValue.value,
          focusNode: controller.enableBookingTextNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.peakFactorsValue.value = v;
            controller.update();
          },
          label: AppText.peakFactor,
          value: controller.peakFactorsValue.value,
          focusNode: controller.peakFactorsNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.webBookerConfValue.value = v;
            controller.update();
          },
          label: AppText.webBookerConfiguration,
          value: controller.webBookerConfValue.value,
          focusNode: controller.webBookerConfNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.customerAppConfValue.value = v;
            controller.update();
          },
          label: AppText.customerAppConfirmation,
          value: controller.customerAppConfValue.value,
          focusNode: controller.customerAppConfNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.bookingDueNotiValue.value = v;
            controller.update();
          },
          label: AppText.bookingDueNotification,
          value: controller.bookingDueNotiValue.value,
          focusNode: controller.bookingDueNotiNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.enableCustomerValue.value = v;
            controller.update();
          },
          label: AppText.enableCustomText,
          value: controller.enableCustomerValue.value,
          focusNode: controller.enableCustomerNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.notificationValue.value = v;
            controller.update();
          },
          label: AppText.notifictaion,
          value: controller.notificationValue.value,
          focusNode: controller.notificationNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.deadMileageValue.value = v;
            controller.update();
          },
          label: AppText.deadMileage,
          value: controller.deadMileageValue.value,
          focusNode: controller.deadMileageNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.callFeaturesValue.value = v;
            controller.update();
          },
          label: AppText.callFeatures,
          value: controller.callFeaturesValue.value,
          focusNode: controller.callFeaturesNode,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget buildNumberField(TextEditingController textCtrl, String hintText) {
    return Expanded(
      child: Focus(
        onKeyEvent: (node, event) {
          // Check key press event 'KeyDownEvent' or 'KeyRepeatEvent'
          if (event is KeyDownEvent || event is KeyRepeatEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              controller.updateValue(textCtrl, 1);
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              controller.updateValue(textCtrl, -1);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
      child: CustomTextField(
        borderRadius: 4,
        controller: textCtrl,
        hintText: hintText,
        columnText: true,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]*'))],
        suffixIcon: FocusScope(
          canRequestFocus: false,
          skipTraversal: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                focusNode: FocusNode(canRequestFocus: false),
                onTap: () => controller.updateValue(textCtrl, 1),
                child: const Icon(Icons.arrow_drop_up, size: 15)),
            InkWell(
                focusNode: FocusNode(canRequestFocus: false),
                onTap: () => controller.updateValue(textCtrl, -1),
                child: const Icon(Icons.arrow_drop_down, size: 15)),
          ],
        ),
        ),
      ),
      ),
    );
  }
}
