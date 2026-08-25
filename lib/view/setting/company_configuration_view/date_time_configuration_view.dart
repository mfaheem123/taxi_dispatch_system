import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../controller/setting_controller.dart';

class DateTimeConfigurationView extends StatefulWidget {
  const DateTimeConfigurationView({super.key});

  @override
  State<DateTimeConfigurationView> createState() =>
      _DateTimeConfigurationViewState();
}

class _DateTimeConfigurationViewState extends State<DateTimeConfigurationView> {
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
        return LayoutBuilder(
          builder: (context, constraints) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: Get.width,
                        height: kToolbarHeight,
                        color: DynamicColors.secondaryClr,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 12.0),
                            child: Text(AppText.DateTimeConfiguration,
                                style: titleDesign()))),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: isMobile
                          ? buildLeftFields()
                          : IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: buildLeftFields(),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildLeftFields() {
    const double horizontalSpacing = 16.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDropdownField<String>(
                text: AppText.dateFormate,
                label: AppText.dateFormate,
                items: const [
                  "DD-MM-YY",
                  "MM-DD-YY ",
                  "YY-MM-DD ",
                  "DD-MM-YYYY",
                  "MM-DD-YYYY",
                  "YYYY-MM-DD",
                ],
                value: controller.dateFormate,
                itemLabel: (val) => val,
                onChanged: (val) {
                  controller.dateFormate = val!;
                  controller.update();
                },
              ),
            ),
            const SizedBox(width: horizontalSpacing),
            Expanded(
              child: CustomDropdownField<String>(
                text: AppText.timeFormate,
                label: AppText.timeFormate,
                items: const [
                  "24 HOUR FORMATE",
                  "12 HOUR FORMATE",
                ],
                value: controller.timeFormate,
                itemLabel: (val) => val,
                onChanged: (val) {
                  controller.timeFormate = val!;
                  controller.update();
                },
              ),
            ),
            const SizedBox(width: horizontalSpacing),
            Expanded(
              child: CustomDropdownField<String>(
                text: AppText.timeZone,
                label: AppText.timeZone,
                items: const [
                  "EUROPE/LONDON",
                  "ASIA/KARACHI",
                ],
                value: controller.zoneFormate,
                itemLabel: (val) => val,
                onChanged: (val) {
                  controller.zoneFormate = val!;
                  controller.update();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
