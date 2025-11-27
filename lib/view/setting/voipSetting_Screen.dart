import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VoipSettingsScreen extends StatefulWidget {
  const VoipSettingsScreen({super.key});

  @override
  State<VoipSettingsScreen> createState() => _VoipSettingsScreenState();
}

class _VoipSettingsScreenState extends State<VoipSettingsScreen> {
  /// Employee dropdown options (safe, non-null)
  List<String> employeeOptions = ["USER", "NADEEM", "DRIVER", "ADMIN"];

  /// Default rows (later will come from API)
  List<Map<String, dynamic>> extensionList = [
    {"employee": "USER", "extension": "210", "isEditing": false},
    {"employee": "NADEEM", "extension": "210", "isEditing": false},
  ];
  SettingController controller =Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      width: w,
      height: h,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ====== PAGE TITLE ======
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              "VOIP SETTINGS",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ====== SERVICE + STATUS SECTION =======
          Container(
            width: w * 0.5,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                // Service
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text("SERVICE",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: "YESTECH",
                        items: const [
                          DropdownMenuItem(value: "YESTECH", child: Text("YESTECH")),
                          DropdownMenuItem(value: "OTHER", child: Text("OTHER")),
                        ],
                        onChanged: (v) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Status
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text("STATUS",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 30),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: "RINGING",
                        items: const [
                          DropdownMenuItem(value: "RINGING", child: Text("RINGING")),
                          DropdownMenuItem(value: "ACTIVE", child: Text("ACTIVE")),
                        ],
                        onChanged: (v) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Save Button
                Center(
                  child: CustomButton(
                    height: 35,
                    width: 80,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        AppText.save,
                        style: mozillaTextRegularText(
                            fontSize: 12, color: DynamicColors.whiteClr),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ====== MANAGE EXTENSIONS TITLE + ADD BUTTON ======
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "MANAGE EXTENSIONS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // ➕ ADD NEW ROW
              IconButton(
                icon: Icon(Icons.add_circle,
                    size: 28, color: DynamicColors.primaryClr),
                onPressed: () {
                  setState(() {
                    extensionList.add({
                      "employee":
                      employeeOptions.isNotEmpty ? employeeOptions.first : "USER",
                      "extension": "",
                      "isEditing": true,
                    });
                  });
                },
              )
            ],
          ),

          const SizedBox(height: 10),

          // ====== EXTENSION TABLE ======
          Expanded(
            child: Container(
              width: w * 0.6,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("EMPLOYEE")),
                    DataColumn(label: Text("EXTENSION")),
                    DataColumn(label: Text("ACTIONS")),
                  ],
                  rows: _tableRows(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // **************** BUILD TABLE ROWS (SAFE) ********************
  // ============================================================
  List<DataRow> _tableRows() {
    return extensionList.asMap().entries.map((entry) {
      int index = entry.key;
      var row = entry.value;

      return DataRow(
        cells: [
          // ===== EMPLOYEE DROPDOWN =====
          DataCell(
            row["isEditing"]
                ? DropdownButton<String>(
              value: row["employee"],
              items: employeeOptions
                  .map((item) =>
                  DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  extensionList[index]["employee"] = value;
                });
              },
            )
                : Text(row["employee"]),
          ),

          // ===== EXTENSION TEXT FIELD =====
          DataCell(
            row["isEditing"]
                ? SizedBox(
              width: 80,
              child: TextField(
                onChanged: (val) =>
                extensionList[index]["extension"] = val,
                controller: TextEditingController(text: row["extension"]),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            )
                : Text(row["extension"]),
          ),

          // ===== ACTION BUTTONS =====
          DataCell(
            Row(
              children: [
                // ✔ SAVE / ✏ EDIT
                IconButton(
                  icon: Icon(
                    row["isEditing"] ? Icons.check_circle : Icons.edit,
                    color: row["isEditing"] ? Colors.green : DynamicColors.primaryClr,
                  ),
                  onPressed: () {
                    setState(() {
                      extensionList[index]["isEditing"] =
                      !extensionList[index]["isEditing"];
                    });
                  },
                ),

                // 🗑 DELETE
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => extensionList.removeAt(index));
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }
}
