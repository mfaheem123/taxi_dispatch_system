import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';
import '../component/networks/api.dart';
import '../view/dashboard_view/widgets/time_picker_widget.dart';
import '../view/drivers_view/controller/driver_controller.dart';
import '../view/drivers_view/driver/create_driver_form/driver_form.dart';
import '../view/page_scroller.dart';

class ShiftAlert {
  static void show() {
    // final List<Map<String, String>> shifts = [];
    final shiftCtrl = TextEditingController();
    final startTimeCtrl = TextEditingController();
    final endTimeCtrl = TextEditingController();
    DriverController controller = Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : Get.put(DriverController());
    List permissions = [];
    permissions = Api().sp.read('all_permissions') ?? [];

    int? editingIndex;

    Get.dialog(
      PageScrollWrapper(
        child: Dialog(
          insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
          backgroundColor: Colors.transparent,
          child: Align(
            alignment: Alignment.topCenter,
            child: StatefulBuilder(
              builder: (context, setState) {


                return GetBuilder<DriverController>(
                  builder: (controller) {
                    return Container(
                      width: Get.width * 0.4,
                      // padding: const EdgeInsets.all(14),
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
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.watch_later_rounded, color: DynamicColors.primaryClr),
                              const SizedBox(width: 10),
                              Text(
                                "SHIFTS",
                                style: titleDesign()
                              ),
                              const Spacer(),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(999),
                                child: const AlertCloseButton(),
                              ),
                            ],
                          )),
                          const Divider(height: 1, thickness: 1),
                          SizedBox(height: 15),

                          Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("SHIFT NAME", style: outFitRegular(fontSize: 13)),
                                            const SizedBox(height: 6),
                                            _buildField("SHIFT", shiftCtrl),
                                          ],
                                          )),
                                      const SizedBox(width: 12),

                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("START TIME", style: outFitRegular(fontSize: 13)),
                                              const SizedBox(height: 6),
                                              SizedBox(
                                                height: 30,
                                                child: CustomTimePicker(
                                                  controller: startTimeCtrl,
                                                  onTimeSelected: (time) {
                                                    // controller.updateExpiryTime(index, time);
                                                    },
                                                ),
                                              ),
                                            ],
                                          ),
                                      ),
                                          const SizedBox(width: 12),

                                          Expanded(
                                            flex: 3,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("END TIME", style: outFitRegular(fontSize: 13)),
                                                  const SizedBox(height: 6),
                                                  SizedBox(
                                                    height: 30,
                                                    child: CustomTimePicker(
                                                      controller: endTimeCtrl,
                                                      onTimeSelected: (time) {
                                                        // controller.updateExpiryTime(index, time);
                                                        },
                                                    ),
                                                  ),
                                                ],
                                              )),
                                      const SizedBox(width: 8),

                                      if(permissions.contains('create_driver_shift')|| permissions.contains('update_driver_shift'))
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            height: 34,
                                            child: CustomButton(
                                              width: 150,
                                              height: 35,
                                              verticalPadding: 0.0,
                                              btnText: editingIndex != null? "UPDATE" : "SAVE",
                                              borderRadius: 4,
                                              style: outFitRegular(
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
                          ))),

                          const SizedBox(height: 14),

                          // Table Header
                          // Table Header with Vertical Dividers
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F3F5),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        child: Text(
                                          "SHIFT NAME",
                                          style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        child: Text(
                                          "START TIME",
                                          style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        child: Text(
                                          "END TIME",
                                          style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        child: Center(
                                          child: Text(
                                            "ACTION",
                                            style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Table Body
                        // Table Body Row section in ShiftAlert
                        ...controller.shiftList.asMap().entries.map((entry) {
                      int index = entry.key;
                      var row = entry.value;
                      bool isSelected = editingIndex == index; // <-- Track active selection

                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.indigo.shade50 : Colors.transparent,
                              border: Border(
                                left: BorderSide(color: Colors.grey.shade300),
                                right: BorderSide(color: Colors.grey.shade300),
                                bottom: BorderSide(
                                  color: isSelected ? DynamicColors.primaryClr : Colors.grey.shade300,
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                            ),

                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      child: Text(row.shiftTitle, style: outFitRegular(fontSize: 12)),
                                    ),
                                  ),
                                  VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      child: Text(row.startTime ?? "", style: outFitRegular(fontSize: 12)),
                                    ),
                                  ),
                                  VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      child: Text(row.endTime ?? "", style: outFitRegular(fontSize: 12)),
                                    ),
                                  ),
                                  VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          icon: Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: isSelected ? Colors.orange : const Color(0xFF43489A),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              editingIndex = index;
                                              shiftCtrl.text = row.shiftTitle;
                                              startTimeCtrl.text = row.startTime ?? "";
                                              endTimeCtrl.text = row.endTime ?? "";
                                            });
                                            controller.update();
                                          },
                                        ),
                                        if (permissions.contains('delete_driver_shift'))
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                if (editingIndex == index) editingIndex = null;
                                                controller.shiftList.removeAt(index);
                                              });
                                              controller.update();
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      );
                        }),
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomButton(
                                      width: 80,
                                      height: 28,
                                      verticalPadding: 0.0,
                                      btnText: "CLOSE",
                                      btnColor: Colors.red,
                                      borderRadius: 4,
                                      style: mozillaTextSemiBoldText(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      onTap: () => Get.back(),
                                    )])),

                        ],
                      ),
                    );
                  }
                );
              },
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Widget _buildField(String label, TextEditingController controller, {bool hasError = false}) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          controller.value = controller.value.copyWith(
            text: value.toUpperCase(),
            selection: controller.selection,
          );
        },
        style: outFitRegular(fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: outFitRegular(fontSize: 11),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.grey,
              width: hasError ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Color(0xFF43489A),
              width: 2,
            ),
          ),
          filled: hasError ? true : false,
          fillColor: hasError ? Colors.red.shade50 : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                      Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: DynamicColors.gryClr.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.sticky_note_2, color: DynamicColors.primaryClr),
                          const SizedBox(width: 10),
                              const Text(
                                "NOTES",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                          const Spacer(),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                            ],
                          )),
                          const SizedBox(height: 12),

                          Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 4, child: TextField(
                                maxLines: 5,
                                minLines: 5,
                                controller: controller.notesCtrl,
                                textCapitalization: TextCapitalization.characters,
                                onChanged: (value) {
                                  controller.notesCtrl.value = controller.notesCtrl.value.copyWith(
                                    text: value.toUpperCase(),
                                    selection: controller.notesCtrl.selection,
                                  );
                                },
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  labelText: "NOTES",
                                  labelStyle: const TextStyle(fontSize: 11),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
                                ),
                              )
                              )
                            ]))),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                              Align(
                                alignment: Alignment.bottomRight,
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
                              ]),

                              ///-------------------


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


