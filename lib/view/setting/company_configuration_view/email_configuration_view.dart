import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../setting_controller.dart';

class EmailConfigurationView extends StatefulWidget {
  const EmailConfigurationView({super.key});

  @override
  State<EmailConfigurationView> createState() => _EmailConfigurationViewState();
}

class _EmailConfigurationViewState extends State<EmailConfigurationView> {
  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (controller) {
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
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: DynamicColors.secondaryClr,
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: Get.width,
                        height: kToolbarHeight,
                        color: DynamicColors.secondaryClr,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppText.emailConfigurations,
                                style: titleDesign()))),
                      Padding(
                        padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.userNameController,
                            width: fieldWidth / 1.5,
                            hintText: AppText.username,
                            columnText: true,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.passwordController,
                            width: fieldWidth / 1.5,
                            hintText: AppText.password,
                            columnText: true,
                          ),
                          CustomDropdownField<String>(
                            text: AppText.service,
                            width: fieldWidth / 1.5,
                            label: AppText.service,
                            items: [
                              "Sevice 1",
                              "Sevice 2",
                              "Sevice 3",
                              "Sevice 4",
                              "Sevice 5",
                            ],
                            value: controller.serviceValue,
                            itemLabel: (val) => val, // just show the string
                            onChanged: (val) {
                              controller.serviceValue = val!;
                              controller.update();
                            },
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.hostController,
                            width: fieldWidth / 1.5,
                            hintText: AppText.host,
                            columnText: true,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.portController,
                            width: fieldWidth / 1.5,
                            hintText: AppText.port,
                            columnText: true,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.ccController,
                            width: fieldWidth / 1.5,
                            hintText: AppText.cc,
                            columnText: true,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.secureConnectionValue.value = v;
                              controller.update();
                            },
                            label: AppText.secureConnection,
                            value: controller.secureConnectionValue.value,
                            focusNode: controller.secureConnectionNode,
                            width: 200,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.toggleAcceptEmailValue.value = v;
                              controller.update();
                            },
                            label: AppText.secureConnection,
                            value: controller.toggleAcceptEmailValue.value,
                            focusNode: controller.toggleAcceptEmailNode,
                            width: 200,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.toggleDeclineEmailValue.value = v;
                              controller.update();
                            },
                            label: AppText.toggleDeclineEmail,
                            value: controller.toggleDeclineEmailValue.value,
                            focusNode: controller.toggleDeclineEmailNode,
                            width: 200,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CustomButton(
                        height: 35,
                        width: fieldWidth,
                        fontSize: 14,
                        borderRadius: 4,
                        verticalPadding: 0.0,
                        btnText: AppText.save,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      });
    });
  }
}
