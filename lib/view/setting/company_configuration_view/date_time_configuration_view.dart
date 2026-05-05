



import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../setting_controller.dart';

class DateTimeConfigurationView extends StatefulWidget {
  const DateTimeConfigurationView({super.key});

  @override
  State<DateTimeConfigurationView> createState() => _DateTimeConfigurationViewState();
}

class _DateTimeConfigurationViewState extends State<DateTimeConfigurationView> {

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
                                child: Text(AppText.DateTimeConfiguration, style: titleDesign()))
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CustomDropdownField<String>(
                                text: AppText.dateFormate,
                                width: fieldWidth/1.5,
                                label: AppText.dateFormate,
                                items:[
                                  "DD-MM-YY 1",
                                  "DD-MM-YY 2",
                                  "DD-MM-YY 3",
                                  "DD-MM-YY 4",
                                  "DD-MM-YY 5",
                                ],
                                value: controller.dateFormate,
                                itemLabel: (val) => val, // just show the string
                                onChanged: (val) {
                                  controller.dateFormate = val!;
                                  controller.update();
                                },
                              ),
                             CustomDropdownField<String>(
                                text: AppText.timeFormate,
                                width: fieldWidth/1.5,
                                label: AppText.timeFormate,
                                items:[
                                  "24 HOUR FORMATE 1",
                                  "24 HOUR FORMATE 2",
                                  "24 HOUR FORMATE 3",
                                  "24 HOUR FORMATE 4",
                                  "24 HOUR FORMATE 5",
                                ],
                                value: controller.timeFormate,
                                itemLabel: (val) => val, // just show the string
                                onChanged: (val) {
                                  controller.timeFormate = val!;
                                  controller.update();
                                },
                              ),
                              CustomDropdownField<String>(
                                text: AppText.timeZone,
                                width: fieldWidth/1.5,
                                label: AppText.timeZone,
                                items:[
                                  "EUROPE/LONDON 1",
                                  "EUROPE/LONDON 2",
                                  "EUROPE/LONDON 3",
                                  "EUROPE/LONDON 4",
                                  "EUROPE/LONDON 5",
                                ],
                                value: controller.zoneFormate,
                                itemLabel: (val) => val, // just show the string
                                onChanged: (val) {
                                  controller.zoneFormate = val!;
                                  controller.update();
                                },
                              ),

                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        if(permissions.contains('read_company_configuration')) Align(
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
