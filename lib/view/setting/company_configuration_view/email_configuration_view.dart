import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../controller/setting_controller.dart';

class EmailConfigurationView extends StatefulWidget {
  const EmailConfigurationView({super.key});

  @override
  State<EmailConfigurationView> createState() => _EmailConfigurationViewState();
}

class _EmailConfigurationViewState extends State<EmailConfigurationView> {
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
            padding: EdgeInsets.all(8.0),
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
                  //HEADER
                  Container(
                      width: Get.width,
                      height: kToolbarHeight,
                      color: DynamicColors.secondaryClr,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          child: Text(AppText.emailConfigurations,
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

  Widget buildLeftFields() {
    const double horizontalSpacing = 16.0;
    const double runSpacing = 26.0;

    return Column(
      children: [
        // ROW 1
        Row(
          children: [
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.userNameController,
              hintText: "USERNAME",
              columnText: true,
              inputFormatters: [UpperCaseTextFormatter()],)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
                    borderRadius: 4,
                    controller: controller.passwordController,
                    hintText: AppText.password,
                    columnText: true, obscureText: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(
              child: CustomDropdownField<String>(
                text: AppText.service,
                label: "SELECT EMAIL SERVICE",
                items: const ["GMAIL", "HOTMAIL", "OUTLOOK", "OTHER"],
                value: controller.emailServiceValue,
                itemLabel: (val) => val,
                onChanged: (val) {
                  controller.emailServiceValue = val!;
                  controller.update();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 2
        Row(
          children: [
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.hostController,
              hintText: AppText.host,
              columnText: true, readOnly: true,
              inputFormatters: [UpperCaseTextFormatter()],)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
                    borderRadius: 4,
                    controller: controller.portController,
                    hintText: AppText.port,
                    columnText: true, readOnly: true)),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
              borderRadius: 4,
              controller: controller.ccController,
              hintText: AppText.cc,
              columnText: true,
              inputFormatters: [UpperCaseTextFormatter()],)),
          ],
        ),
      ],
    );
  }

  Widget buildRightCheckboxes() {
    const double checkboxSpacing = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.secureConnectionValue.value = v;
            controller.update();
          },
          label: AppText.secureConnection,
          value: controller.secureConnectionValue.value,
          focusNode: controller.secureConnectionNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.toggleAcceptEmailValue.value = v;
            controller.update();
          },
          label: AppText.toggleAcceptEmail,
          value: controller.toggleAcceptEmailValue.value,
          focusNode: controller.toggleAcceptEmailNode,
          width: double.infinity,
        ),
        const SizedBox(height: checkboxSpacing),
        KeyboardCheckbox(
          onChanged: (v) {
            controller.toggleDeclineEmailValue.value = v;
            controller.update();
          },
          label: AppText.toggleDeclineEmail,
          value: controller.toggleDeclineEmailValue.value,
          focusNode: controller.toggleDeclineEmailNode,
          width: double.infinity,
        ),
      ],
    );
  }
}
