



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/textStyle.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../controller/controller.dart';

class WaitingConfigurationAlert {
  static void show() {
    // final List<Map<String, String>> shifts = [];
    final shiftCtrl = TextEditingController();
    final startTimeCtrl = TextEditingController();
    final endTimeCtrl = TextEditingController();
    FareController controller = Get.isRegistered<FareController>()
        ? Get.find<FareController>()
        : Get.put(FareController());

    // int? editingIndex;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: StatefulBuilder(
            builder: (context, setState) {


              return GetBuilder<FareController>(
                  builder: (controller) {
                    return Container(
                      width: Get.width * 0.7,
                      padding: const EdgeInsets.all(14),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "SALOON WAITING CONFIGURATION",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  // print(controller.shiftList);
                                  Get.back();
                                },
                                child: const Icon(Icons.close,
                                    size: 20, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                width: 100,
                                    child: Row(
                                      children: [
                                        KeyboardCheckbox(
                                          width: 120,
                                          label: "SPECIAL DAY",
                                          focusNode: controller.specialDayNode,
                                          value: controller.specialDayValue.value,
                                          onChanged: (v) {
                                            controller.specialDayValue.value = v;
                                            controller.update();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("DAY"),
                                  CustomDropdownField<String>(
                                    label: "DAY",
                                    width: 120,
                                    height: 35,
                                    items: [
                                      "TUESDAY",
                                      "WEDNESDAY",
                                      "THURSDAY",
                                      "FRIDAY",
                                      "SATURDAY",
                                      "SUNDAY",
                                      "MONDAY",
                                    ],
                                    value: controller.selectFareMeterDay,
                                    itemLabel: (data) =>
                                    data,
                                    onChanged: (val) {
                                      controller.selectFareMeterDay = val;
                                      controller.update();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              // _buildField("SHIFT", shiftCtrl),
                              Expanded(
                                flex: 2,
                                child:
                                SizedBox(
                                  height: 30,
                                  child: CustomTimePicker(
                                    controller: startTimeCtrl, // optional
                                    onTimeSelected: (time) {
                                      print(time);
                                      print(startTimeCtrl.text);
                                      // print(row.expiryTime!.text);
                                      // controller.updateExpiryTime(index, time);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child:
                                SizedBox(
                                  height: 30,
                                  child: CustomTimePicker(
                                    controller: endTimeCtrl, // optional
                                    onTimeSelected: (time) {
                                      print(time);
                                      print(startTimeCtrl.text);
                                      // print(row.expiryTime!.text);
                                      // controller.updateExpiryTime(index, time);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 34,
                                  child: CustomButton(
                                    width: 150,
                                    height: 35,
                                    verticalPadding: 0.0,
                                    btnText: "SAVE",
                                    borderRadius: 4,
                                    style: mozillaTextRegularText(
                                        fontSize: 14, color: DynamicColors.whiteClr),
                                    onTap: () {
                                      // controller.shiftList.add(ShiftAlertClass(
                                      //   shiftTitle: shiftCtrl.text,
                                      //   endTime: startTimeCtrl.text,
                                      //   startTime: endTimeCtrl.text,
                                      // ));
                                      // shiftCtrl.clear();
                                      // startTimeCtrl.clear();
                                      // endTimeCtrl.clear();
                                      // controller.update();
                                      // saveShift;
                                    },
                                  ),

                                ),
                              ),

                              ///-------------------
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: const [
                                Expanded(
                                    flex: 2,
                                    child: Text("SHIFT NAME",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("START TIME",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("END TIME",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("ACTIONS",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),

                          // Table Body
                          // ...controller.shiftList.asMap().entries.map((entry) {
                          //   int index = entry.key;
                          //   var row = entry.value; // This is a ShiftAlertClass object
                          //
                          //   return Container(
                          //     padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          //     decoration: BoxDecoration(
                          //       border: Border(
                          //         bottom: BorderSide(color: Colors.grey.shade200),
                          //       ),
                          //     ),
                          //     child: Row(
                          //       children: [
                          //         Expanded(flex: 2, child: Text(row.shiftTitle)),
                          //         Expanded(flex: 2, child: Text(row.startTime ?? "")),
                          //         Expanded(flex: 2, child: Text(row.endTime ?? "")),
                          //         Expanded(
                          //           flex: 2,
                          //           child: Row(
                          //             children: [
                          //               IconButton(
                          //                 icon: const Icon(Icons.edit,
                          //                     size: 18, color: Color(0xFF43489A)),
                          //                 onPressed: () {
                          //                   setState(() {
                          //                     shiftCtrl.text = row.shiftTitle.text;
                          //                     startTimeCtrl.text = row.startTime ?? "";
                          //                     endTimeCtrl.text = row.endTime ?? "";
                          //                   });
                          //                 },
                          //               ),
                          //               IconButton(
                          //                 icon: const Icon(Icons.delete,
                          //                     size: 18, color: Colors.red),
                          //                 onPressed: () {
                          //                   setState(() {
                          //                     // controller.shiftList.removeAt(index);
                          //                   });
                          //                 },
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }),

                        ],
                      ),
                    );
                  }
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Widget _buildField(String label, TextEditingController controller) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 11),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        ),
      ),
    );
  }
}