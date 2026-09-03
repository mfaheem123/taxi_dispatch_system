import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../controller/setting_controller.dart';

class SmsConfigurationView extends StatefulWidget {
  const SmsConfigurationView({super.key});

  @override
  State<SmsConfigurationView> createState() => _SmsConfigurationViewState();
}

class _SmsConfigurationViewState extends State<SmsConfigurationView> {
  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  List permissions = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      initState: (v) {
        permissions = Api().sp.read('all_permissions') ?? [];
      },
      builder: (controller) {
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

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                  border: Border.all(
                color: DynamicColors.secondaryClr,
              )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: Get.width,
                      height: kToolbarHeight,
                      color: DynamicColors.secondaryClr,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          child: Text(AppText.smsConfigurations,
                              style: titleDesign()))),
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

  Widget buildLeftFields() {
    const double horizontalSpacing = 16.0;
    const double runSpacing = 26.0;

    return Column(
      children: [
        // ROW 1
        Row(
          children: [
            Expanded(
              child: CustomDropdownField<String>(
                text: AppText.service,
                label: "SELECT SMS SERVICE",
                items: const ["DINSTAR", "CUSTOM"],
                value: controller.smsServiceValue,
                itemLabel: (val) => val,
                onChanged: (val) {
                  controller.smsServiceValue = val!;
                  controller.update();
                },
              ),
            ),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
               borderRadius: 4,
               controller: controller.smsServiceIpController,
               hintText: AppText.smsServiceIp,
               columnText: true,
               inputFormatters: [UpperCaseTextFormatter()])),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
                borderRadius: 4,
                controller: controller.smsHostController,
                hintText: AppText.smsHost,
                columnText: true,
                inputFormatters: [UpperCaseTextFormatter()]
            )),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 2
        Row(
          children: [
            Expanded(child: CustomTextField(
                borderRadius: 4,
                controller: controller.smsPortController,
                hintText: AppText.smsPort,
                columnText: true,
                inputFormatters: [UpperCaseTextFormatter()]
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
                borderRadius: 4,
                controller: controller.smsUserNameController,
                hintText: AppText.smsUserName,
                columnText: true,
                inputFormatters: [UpperCaseTextFormatter()]
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
                borderRadius: 4,
                controller: controller.smsPasswordController,
                hintText: AppText.smsPassword,
                columnText: true, obscureText: true)),
          ],
        ),
      ],
    );
  }

  Widget buildRightCheckboxes() {
    const double checkboxSpacing = 26.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.enableIncomingMessagesValue.value = v;
            controller.update();
          },
          label: AppText.enableIncomingMessages,
          value: controller.enableIncomingMessagesValue.value,
          focusNode: controller.enableIncomingMessagesNode,
          width: double.infinity,
        ),
      ],
    );
  }
}
