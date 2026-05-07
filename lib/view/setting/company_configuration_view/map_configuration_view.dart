



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
import '../setting_controller.dart';

class MapConfigurationView extends StatefulWidget {
  const MapConfigurationView({super.key});

  @override
  State<MapConfigurationView> createState() => _MapConfigurationViewState();
}

class _MapConfigurationViewState extends State<MapConfigurationView> {


  List permissions = [];


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(

        initState: (v){
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
                                child: Text(AppText.mapConfiguration, style: titleDesign()))
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CustomDropdownField<String>(
                                text: AppText.service,
                                width: fieldWidth/1.5,
                                label: AppText.service,
                                items:[
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
                                controller: controller.serviceApiKeyController,
                                width: fieldWidth/1.5,
                                hintText: AppText.serviceApiKey,
                                columnText: true,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.mapApiKeyController,
                                width: fieldWidth/1.5,
                                hintText: AppText.mapApiKey,
                                columnText: true,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.distanceFactorController,
                                width: fieldWidth/1.5,
                                hintText: AppText.distanceFactor,
                                columnText: true,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.timeFactorController,
                                width: fieldWidth/1.5,
                                hintText: AppText.timeFactor,
                                columnText: true,
                              ),
                              KeyboardCheckbox(
                                onChanged: (v){
                                  controller.toggleMapControlsValue.value = v;
                                  controller.update();
                                },
                                label: AppText.toggleMapControls,
                                value: controller.toggleMapControlsValue.value,
                                focusNode: controller.toggleMapControlsNode,
                                width: 250,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        if(permissions.contains('read_company_configuration'))  Align(
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
