import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class MapConfigurationView extends StatefulWidget {
  const MapConfigurationView({super.key});

  @override
  State<MapConfigurationView> createState() => _MapConfigurationViewState();
}

class _MapConfigurationViewState extends State<MapConfigurationView> {
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
                          child: Text(AppText.mapConfiguration,
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
                label: "SELECT MAP SERVICE",
                items: const ["GOOGLE", "HEREWEGO", "MAPBOX", "OSM"],
                value: controller.mapServiceValue,
                itemLabel: (val) => val,
                onChanged: (val) {
                  controller.mapServiceValue = val!;
                  controller.update();
                },
              ),
            ),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
                borderRadius: 4,
                controller: controller.geoApifyApiKeyController,
                hintText: "GEOAPIFY API KEY",
                columnText: true,
                inputFormatters: [UpperCaseTextFormatter()]
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(
                child: CustomTextField(
                    borderRadius: 4,
                    controller: controller.serviceApiKeyController,
                    hintText: AppText.serviceApiKey,
                    columnText: true,
                    inputFormatters: [UpperCaseTextFormatter()]
                )),
            const SizedBox(width: horizontalSpacing),
            Expanded(
                child: CustomTextField(
                    borderRadius: 4,
                    controller: controller.mapApiKeyController,
                    hintText: AppText.mapApiKey,
                    columnText: true,
                    inputFormatters: [UpperCaseTextFormatter()]
                )),
          ],
        ),
        const SizedBox(height: runSpacing),

        // ROW 2
        Row(
          children: [
            buildNumberField(controller.distanceFactorController, AppText.distanceFactor),
            const SizedBox(width: horizontalSpacing),
            buildNumberField(controller.timeFactorController, AppText.timeFactor),
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
            controller.toggleMapControlsValue.value = v;
            controller.update();
          },
          label: AppText.toggleMapControls,
          value: controller.toggleMapControlsValue.value,
          focusNode: controller.toggleMapControlsNode,
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
