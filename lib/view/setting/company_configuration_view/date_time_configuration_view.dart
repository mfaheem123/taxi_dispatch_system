



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../setting_controller.dart';

class DateTimeConfigurationView extends StatefulWidget {
  const DateTimeConfigurationView({super.key});

  @override
  State<DateTimeConfigurationView> createState() => _DateTimeConfigurationViewState();
}

class _DateTimeConfigurationViewState extends State<DateTimeConfigurationView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
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
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: Get.width,
                            height: kToolbarHeight,
                            color: DynamicColors.secondaryClr,

                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppText.paymentGateWays, style: titleDesign()))
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.mapApiKeyController,
                                width: fieldWidth/1.5,
                                hintText: "STRIPE PUBLIC KEY",
                                columnText: true,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.distanceFactorController,
                                width: fieldWidth/1.5,
                                hintText: "STRIPE SECRET KEY",
                                columnText: true,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.timeFactorController,
                                width: fieldWidth/1.5,
                                hintText: "ENDPOINT KEY",
                                columnText: true,
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
                            borderRadius:4,
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
                SizedBox(
                  height: 8,
                ),
              ],
            );
            }
          );
      }
    );
  }
}
