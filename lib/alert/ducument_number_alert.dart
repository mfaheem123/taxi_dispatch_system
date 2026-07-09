import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import '../component/dropdown_button.dart';
import '../component/text_widget.dart';
import '../view/administration/model/list_subsDiary.dart';
import '../view/reports/controller/report_controller.dart';
import '../view/setting/setting_controller.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        color: DynamicColors.gryClr,
        child: Text(
          "DOCUMENT NUMBER",
          style: mozillaTextSemiBoldText(
            fontSize: 18,
            color: DynamicColors.black,
          ),
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

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomDropdownField<String>(
                            width: maxWidth < 1400 ? fieldWidth / 1.7 : fieldWidth / 1.9,
                            text: "DOCUMENT TABLE",
                            label: "SELECT DOCUMENT TABLE",
                            items: logic.tableColumnsMap.keys.toList(),
                            value: logic.selectedTable,
                            itemLabel: (val) => val,
                            onChanged: (val) {
                              logic.onTableChanged(val);
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomDropdownField<String>(
                            width: maxWidth < 1400 ? fieldWidth / 1.7 : fieldWidth / 1.9,
                            text: "DOCUMENT COLUMN",
                            label: "SELECT DOCUMENT COLUMN",
                            items: logic.tableColumnsMap[logic.selectedTable] ?? ["SELECT DOCUMENT COLUMN"],
                            value: logic.selectedColumn,
                            itemLabel: (val) => val.toUpperCase().replaceAll("_", " "),
                            onChanged: (val) {
                              logic.selectedColumn = val;
                              logic.update();
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomDropdownField<dynamic>(
                            width: fieldWidth / 1.5,
                            text: AppText.subsidiary,
                            label: AppText.selectSubsidiary,
                            items: controller.subsDiaryModel?.subsidiaries ?? [],
                            value: controller.subsDiaryModel?.subsidiaries
                                ?.firstWhereOrNull((element) => element.id.toString() == controller.selectedSubsidiaryId.toString()),

                            itemLabel: (item) => item.name ?? "",
                            onChanged: (val) {
                              controller.selectedSubsidiaryId = val?.id.toString();
                              controller.update();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: "Prefix",
                            controller: logic.prefixController,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildCounterField(
                            label: "Start #",
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
                            label: "Increment",
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
      actionsPadding: const EdgeInsets.only(right: 20, bottom: 20, top: 10),
      actions: [
        // Close Button
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: DynamicColors.primaryClr,
            side: BorderSide(color: DynamicColors.primaryClr),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text("Close"),
          ),
        ),
        const SizedBox(width: 10),
        // Save Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: DynamicColors.primaryClr,
            foregroundColor: DynamicColors.whiteClr,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Text("Save"),
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
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 13),
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
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
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.only(left: 10, right: 4, top: 8, bottom: 8),
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onUp,
                  child: const Icon(Icons.arrow_drop_up,
                      size: 20, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: onDown,
                  child: const Icon(Icons.arrow_drop_down,
                      size: 20, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
