import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import '../component/alert_close_button.dart';
import '../component/customButton.dart';
import '../component/dropdown_button.dart';
import '../component/text_widget.dart';
import '../view/setting/controller/setting_controller.dart';

class AddDocumentDialog extends StatelessWidget {
  const AddDocumentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.isRegistered<SettingController>()
        ? Get.find<SettingController>()
        : Get.put(SettingController());

    return AlertDialog(
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: DynamicColors.gryClr.withOpacity(0.5),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Row(
          children: [
            Text("DOCUMENT NUMBER", style: titleDesign()),
            const Spacer(),
            FocusTraversalOrder(
              order: const NumericFocusOrder(999),
              child: const AlertCloseButton(),
            ),
          ],
        ),
      ),
      content: GetBuilder<SettingController>( initState: (state)  {
        controller.getDocumentSubsidiary();
      },
        builder: (logic) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: SingleChildScrollView(
              child: LayoutBuilder(builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth;
                final double fieldWidth = maxWidth;

                List<String> availableColumns = logic.tableColumnsMap[logic.selectedTable] ?? [];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "DOCUMENT TABLE",
                                style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87,
                                ),
                              ),
                              CustomDropdownField<String>(
                                width: maxWidth < 1400 ? fieldWidth / 1.7 : fieldWidth / 1.9,
                                height: 35,
                                text: "",
                                label: "SELECT DOCUMENT TABLE",
                                items: logic.tableColumnsMap.keys.toList(),
                                value: logic.tableColumnsMap.containsKey(logic.selectedTable)
                                    ? logic.selectedTable
                                    : null,
                                itemLabel: (val) => val.replaceAll("_", " ").toUpperCase(),
                                onChanged: (val) {
                                  logic.onTableChanged(val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(
                            "DOCUMENT TABLE",
                            style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          CustomDropdownField<String>(
                            width: maxWidth < 1400 ? fieldWidth / 1.7 : fieldWidth / 1.9,
                            height: 35,
                            text: "",
                            label: "SELECT DOCUMENT COLUMN",
                            items: availableColumns.isNotEmpty ? availableColumns : ["SELECT DOCUMENT COLUMN"],
                            value: availableColumns.contains(logic.selectedColumn)
                                ? logic.selectedColumn
                                : null,
                            itemLabel: (val) => val.replaceAll("_", " ").toUpperCase(),
                            onChanged: (val) {
                              logic.selectedColumn = val;
                              logic.update();
                            },
                          ),
                          ]),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(
                            AppText.subsidiary,
                            style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87,
                            ),
                          ),
                          CustomDropdownField<dynamic>(
                            width: fieldWidth / 1.5,
                            height: 35,
                            text: "",
                            label: AppText.selectSubsidiary,
                            items: controller.subsDiaryModel?.subsidiaries ?? [],
                            value: controller.subsDiaryModel?.subsidiaries
                                ?.firstWhereOrNull((element) => element.id.toString() == controller.selectedSubsidiaryId.toString()),

                            itemLabel: (item) => (item.name ?? "").toUpperCase(),
                            onChanged: (val) {
                              controller.selectedSubsidiaryId = val?.id.toString();
                              controller.update();
                            },
                          ),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: "PREFIX",
                            controller: logic.prefixController,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildCounterField(
                            label: "START #",
                            controller: logic.startNumberController,
                            onUp: () => logic.changeCounterValue(
                                logic.startNumberController, true),
                            onDown: () => logic.changeCounterValue(
                                logic.startNumberController, false),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildCounterField(
                            label: "INCREMENT",
                            controller: logic.incrementController,
                            onUp: () => logic.changeCounterValue(
                                logic.incrementController, true),
                            onDown: () => logic.changeCounterValue(
                                logic.incrementController, false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              }),
            ),
          );
        },
      ),

      actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
      actions: [
        // Close Button
        CustomButton(
          width: 100,
          height: 32,
          verticalPadding: 0.0,
          btnText: "CLOSE",
          btnColor: Colors.red,
          borderRadius: 4,
          style: mozillaTextSemiBoldText(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          onTap: () => Get.back(),
        ),
        const SizedBox(width: 10),
        // Save Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: DynamicColors.primaryClr,
            foregroundColor: DynamicColors.whiteClr,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onPressed: controller.isAddNumber
              ? null
              : () {
            controller.saveDocumentNumber();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: controller.isAddNumber
                ? const SizedBox(
              width: 15,
              height: 16,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : Obx(() => Text(
              controller.updateDocumentNumber.value ? "UPDATE" : "SAVE",
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
      {required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 6),
        CustomTextField(
          controller: controller,
          borderRadius: 4,
          inputFormatters: [UpperCaseTextFormatter()],
          height: 35,
        ),
      ],
    );
  }

  Widget _buildCounterField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onUp,
    required VoidCallback onDown,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 6),
        CustomTextField(
          controller: controller,
          keyboardType: TextInputType.number,
          borderRadius: 4,
          height: 35,
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onUp,
                  child: const Icon(Icons.arrow_drop_up, size: 16, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: onDown,
                  child: const Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
                ),
              ],
            ),
        ),
      ],
    );
  }
}
