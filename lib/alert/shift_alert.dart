import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftAlert {
  static void show() {
    final List<Map<String, String>> shifts = [];
    final shiftCtrl = TextEditingController();
    final startTimeCtrl = TextEditingController();
    final endTimeCtrl = TextEditingController();

    int? editingIndex;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: StatefulBuilder(
            builder: (context, setState) {
              void saveShift() {
                if (shiftCtrl.text.isEmpty || startTimeCtrl.text.isEmpty || endTimeCtrl.text.isEmpty) return;

                setState(() {
                  if (editingIndex == null) {
                    shifts.add({
                      "shift": shiftCtrl.text,
                      "start": startTimeCtrl.text,
                      "end": endTimeCtrl.text,
                    });
                  } else {
                    shifts[editingIndex!] = {
                      "shift": shiftCtrl.text,
                      "start": startTimeCtrl.text,
                      "end": endTimeCtrl.text,
                    };
                    editingIndex = null;
                  }

                  shiftCtrl.clear();
                  startTimeCtrl.clear();
                  endTimeCtrl.clear();
                });
              }

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
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.close, size: 20, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(flex: 2, child: _buildField("SHIFT", shiftCtrl)),
                        const SizedBox(width: 8),
                        Expanded(flex: 2, child: _buildField("START TIME", startTimeCtrl)),
                        const SizedBox(width: 8),
                        Expanded(flex: 2, child: _buildField("END TIME", endTimeCtrl)),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 34,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: editingIndex == null ? Color(0xFF43489A) : Colors.orange,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              onPressed: saveShift,
                              child: Text(
                                editingIndex == null ? "SAVE" : "UPDATE",
                                style: const TextStyle(fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: const [
                          Expanded(flex: 2, child: Text("SHIFT NAME", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text("START TIME", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text("END TIME", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text("ACTIONS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),

                    // Table Body
                    ...shifts.asMap().entries.map((entry) {
                      int index = entry.key;
                      var row = entry.value;
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text(row["shift"] ?? "")),
                            Expanded(flex: 2, child: Text(row["start"] ?? "")),
                            Expanded(flex: 2, child: Text(row["end"] ?? "")),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18, color: Color(0xFF43489A)),
                                    onPressed: () {
                                      setState(() {
                                        editingIndex = index;
                                        shiftCtrl.text = row["shift"] ?? "";
                                        startTimeCtrl.text = row["start"] ?? "";
                                        endTimeCtrl.text = row["end"] ?? "";
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        shifts.removeAt(index);
                                        if (editingIndex == index) {
                                          editingIndex = null;
                                          shiftCtrl.clear();
                                          startTimeCtrl.clear();
                                          endTimeCtrl.clear();
                                        }
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        ),
      ),
    );
  }
}
