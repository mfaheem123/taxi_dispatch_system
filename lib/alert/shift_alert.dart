import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/dashboard_view/widgets/time_picker_widget.dart';
import '../view/drivers_view/controller/driver_controller.dart';
import '../view/drivers_view/driver/create_driver_form/driver_form.dart';

class ShiftAlert {
  static void show() {
    // final List<Map<String, String>> shifts = [];
    final shiftCtrl = TextEditingController();
    final startTimeCtrl = TextEditingController();
    final endTimeCtrl = TextEditingController();
    DriverController controller = Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : Get.put(DriverController());


    int? editingIndex;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: StatefulBuilder(
            builder: (context, setState) {


              return GetBuilder<DriverController>(
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
                              "SHIFTS",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {
                                print(controller.shiftList);
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
                                flex: 2, child: _buildField("SHIFT", shiftCtrl)),
                            const SizedBox(width: 8),
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
                                  btnText: editingIndex != null? "UPDATE" : "SAVE",
                                  borderRadius: 4,
                                  style: mozillaTextRegularText(
                                      fontSize: 14, color: DynamicColors.whiteClr),
                                  onTap: () {
                                    if (editingIndex != null) {
                                      controller.shiftList[editingIndex!] = ShiftAlertClass(
                                        shiftTitle: shiftCtrl.text,
                                        startTime: startTimeCtrl.text,
                                        endTime: endTimeCtrl.text,
                                      );
                                      editingIndex = null;
                                    } else {
                                      controller.shiftList.add(
                                        ShiftAlertClass(
                                          shiftTitle: shiftCtrl.text,
                                          startTime: startTimeCtrl.text,
                                          endTime: endTimeCtrl.text,
                                        ),
                                      );
                                    }

                                    shiftCtrl.clear();
                                    startTimeCtrl.clear();
                                    endTimeCtrl.clear();
                                    controller.update();
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
                        ...controller.shiftList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var row = entry.value; // This is a ShiftAlertClass object

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(row.shiftTitle)),
                                Expanded(flex: 2, child: Text(row.startTime ?? "")),
                                Expanded(flex: 2, child: Text(row.endTime ?? "")),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            size: 18, color: Color(0xFF43489A)),
                                        onPressed: () {

                                            setState(() {
                                              editingIndex = index;
                                              shiftCtrl.text = row.shiftTitle;
                                              startTimeCtrl.text = row.startTime ?? "";
                                              endTimeCtrl.text = row.endTime ?? "";

                                            });


                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            size: 18, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            controller.shiftList.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

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



class NoteAlert {
  static void show() {
    // final List<Map<String, String>> shifts = [];
    DriverController controller = Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : Get.put(DriverController());


    int? editingIndex;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GetBuilder<DriverController>(
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
                                "NOTES",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () => Get.back(),
                                child: const Icon(Icons.close,
                                    size: 20, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                  flex: 4, child: TextField(
                                maxLines: 5,
                                minLines: 5,
                                controller: controller.notesCtrl,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  labelText: "NOTES",
                                  labelStyle: const TextStyle(fontSize: 11),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                ),
                              )),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 34,
                                  child: CustomButton(
                                    width: 150,
                                    height: 35,
                                    verticalPadding: 0.0,
                                    btnText:    editingIndex != null? "UPDATE" :  "SAVE",
                                    borderRadius: 4,
                                    style: mozillaTextRegularText(
                                        fontSize: 14, color: DynamicColors.whiteClr),
                                    onTap: () {
                                      if (editingIndex != null) {
                                        controller.noteList[editingIndex!] = NoteAlertClass(
                                          notesTitle: controller.notesCtrl.text,
                                          createdItTime: controller.noteList[editingIndex!].createdItTime,
                                          createdByTime: controller.noteList[editingIndex!].createdByTime,
                                        );
                                        editingIndex = null;  // reset
                                      } else {
                                        controller.noteList.add(
                                          NoteAlertClass(
                                            notesTitle: controller.notesCtrl.text,
                                            createdItTime: "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                            createdByTime: "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                          ),
                                        );
                                      }
                                      controller.notesCtrl.clear();
                                      controller.update();
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
                          ...controller.noteList.asMap().entries.map((entry) {
                            int index = entry.key;
                            var row = entry.value; // This is a ShiftAlertClass object

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(row.notesTitle)),
                                  Expanded(flex: 2, child: Text(row.createdItTime ?? "")),
                                  Expanded(flex: 2, child: Text(row.createdByTime ?? "")),
                                  Expanded(
                                    flex: 2,
                                    child: Row(

                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              size: 18, color: Color(0xFF43489A)),
                                          onPressed: () {
                                            setState(() {
                                              editingIndex = index;
                                              controller.notesCtrl.text = row.notesTitle;
                                            });
                                          },
                                        ),

                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 18, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              controller.noteList.removeAt(index);
                                              controller.update();

                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

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
}


