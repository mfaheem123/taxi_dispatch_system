



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../controller/controller.dart';
import '../model/GetAllFareMeterRateModel.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Assuming these models and custom widgets exist in your project path.
// Replace imports with your actual project imports.

class WaitingConfigurationAlert {
  static void show({
    required String vehicleTypeName,
    List<WaitingCharge>? waitingCharges}) {
    final shiftCtrl = TextEditingController();
    final startTimeCtrl = TextEditingController();
    final endTimeCtrl = TextEditingController();

    FareController controller = Get.isRegistered<FareController>()
        ? Get.find<FareController>()
        : Get.put(FareController());

    // Fallback initialize to avoid null errors on manipulation
    final List<WaitingCharge> listToManage = waitingCharges ?? [];

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: GetBuilder<FareController>(
            builder: (controller) {
              return Container(
                width: MediaQuery.of(Get.context!).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${vehicleTypeName.toUpperCase()} WAITING CONFIGURATION",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5
                            ),
                          ),
                          InkWell(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.close, size: 22, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Input Fields Row/Wrap Section (Fixes the Right Overflow)
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          // Special Day Checkbox
                          SizedBox(
                            width: 130,
                            child: KeyboardCheckbox(
                              width: 120,
                              label: "SPECIAL DAY",
                              focusNode: controller.specialDayNode,
                              value: controller.specialDayValue.value,
                              onChanged: (v) {
                                controller.specialDayValue.value = v;
                                controller.update();
                              },
                            ),
                          ),

                          // Day / Date Selector
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.specialDayValue.value ? "DATE" : "DAY",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              controller.specialDayValue.value
                                  ? KeyboardDatePicker(
                                initialDate: controller.specialDate ?? DateTime.now(),
                                onChanged: (date) {
                                  controller.specialDate = date;
                                  controller.update();
                                },
                              )
                                  : CustomDropdownField<String>(
                                label: "DAY",
                                width: 160,
                                height: 30,
                                items: const [
                                  "TUESDAY", "WEDNESDAY", "THURSDAY",
                                  "FRIDAY", "SATURDAY", "SUNDAY", "MONDAY"
                                ],
                                value: controller.selectFareMeterDay,
                                itemLabel: (data) => data,
                                onChanged: (val) {
                                  controller.selectFareMeterDay = val;
                                  controller.update();
                                },
                              ),
                            ],
                          ),

                          // From Time
                          SizedBox(
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("FROM TIME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 30,
                                  child: CustomTimePicker(
                                    controller: startTimeCtrl,
                                    onTimeSelected: (time) {},
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // To Time
                          SizedBox(
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("TO TIME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 30,
                                  child: CustomTimePicker(
                                    controller: endTimeCtrl,
                                    onTimeSelected: (time) {},
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Charges Input with Euro Prefix and Penny Suffix
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("CHARGES", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 30,
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: DynamicColors.primaryClr),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        bottomLeft: Radius.circular(4),
                                      ),
                                    ),
                                    child: const Center(child: Icon(Icons.euro_outlined, size: 16)),
                                  ),
                                  CustomTextField(
                                    borderRadius: 0,
                                    controller: shiftCtrl,
                                    width: 110,
                                    height: 30,
                                    hintText: "",
                                  ),
                                  Container(
                                    height: 30,
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: DynamicColors.primaryClr),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(4),
                                        bottomRight: Radius.circular(4),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text("PENNY", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Save Button
                          CustomButton(
                            width: 70,
                            height: 30,
                            verticalPadding: 0.0,
                            btnText: "SAVE",
                            borderRadius: 4,
                            style: mozillaTextRegularText(
                                fontSize: 13,
                                color: DynamicColors.whiteClr
                            ),
                            onTap: () {
                              if (shiftCtrl.text.isNotEmpty && startTimeCtrl.text.isNotEmpty && endTimeCtrl.text.isNotEmpty) {
                                String finalDay = controller.specialDayValue.value
                                    ? "${controller.specialDate?.day ?? DateTime.now().day}-${controller.specialDate?.month ?? DateTime.now().month}-${controller.specialDate?.year ?? DateTime.now().year}"
                                    : (controller.selectFareMeterDay ?? "MONDAY");

                                listToManage.add(WaitingCharge(
                                  charge: double.tryParse(shiftCtrl.text) ?? 0.0,
                                  fromTime: startTimeCtrl.text,
                                  toTime: endTimeCtrl.text,
                                  day: finalDay,
                                ));

                                shiftCtrl.clear();
                                startTimeCtrl.clear();
                                endTimeCtrl.clear();
                                controller.update();
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Responsive Data Table Section
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: const [
                            Expanded(flex: 3, child: Text("DAY/DATE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            Expanded(flex: 3, child: Text("TIME", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            Expanded(flex: 3, child: Text("WAITING CHARGES", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            SizedBox(width: 40, child: Text("", textAlign: TextAlign.center)),
                          ],
                        ),
                      ),

                      // Dynamic Table Items
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listToManage.length,
                        itemBuilder: (context, index) {
                          var row = listToManage[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text(row.day ?? "", style: const TextStyle(fontSize: 12))),
                                Expanded(flex: 3, child: Text("${row.fromTime} ~ ${row.toTime}", style: const TextStyle(fontSize: 12))),
                                Expanded(flex: 3, child: Text("${row.charge}", style: const TextStyle(fontSize: 12))),
                                SizedBox(
                                  width: 40,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    onPressed: () {
                                      listToManage.removeAt(index);
                                      controller.update();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}