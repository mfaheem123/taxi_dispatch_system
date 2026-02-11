import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/services.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:dashboard_new1/view/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoipSettingsScreen extends StatefulWidget {
  const VoipSettingsScreen({super.key});

  @override
  State<VoipSettingsScreen> createState() => _VoipSettingsScreenState();
}

class _VoipSettingsScreenState extends State<VoipSettingsScreen> {
  // Temporary new rows for adding extension
  List<Map<String, dynamic>> newExtensions = [];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    SettingController controller = Get.put(SettingController());

    return GetBuilder<SettingController>(
      initState: (v) {
        controller.getManageExtention();
      },
      builder: (controller) {
        if (controller.getManageExtentionModel == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // List of employees for dropdown
        List<String> employeeList = controller.getManageExtentionModel!.employeeExtensions!
            .map((e) => e.employee!.username ?? "-")
            .toList();

        return Container(
          width: w,
          height: h,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              // ---------- TITLE ----------

              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Text(
                  "VOIP SETTINGS",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // ---------- SERVICE + STATUS ----------
              Container(
                width: w * 0.5,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const Text("SERVICE",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: "YESTECH",
                            items: const [
                              DropdownMenuItem(
                                  value: "YESTECH", child: Text("YESTECH")),
                              DropdownMenuItem(
                                  value: "OTHER", child: Text("OTHER")),
                            ],
                            onChanged: (v) {},
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(width: 30),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: "RINGING",
                            items: const [
                              DropdownMenuItem(
                                  value: "RINGING", child: Text("RINGING")),
                              DropdownMenuItem(
                                  value: "ACTIVE", child: Text("ACTIVE")),
                            ],
                            onChanged: (v) {},
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0.0),
                          child: Text(
                            AppText.save,
                            style: mozillaTextRegularText(
                                fontSize: 12, color: DynamicColors.whiteClr),
                          ),
                        ),
                        onTap: () {
                          print("VOIP settings saved");
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // ---------- MANAGE EXTENSIONS + BUTTON ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "MANAGE EXTENSIONS",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 15),
                  CustomButton(
                    height: 35,
                    width: 100,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 16, color: Colors.white),
                          SizedBox(width: 5),
                          Text("Add", style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                    onTap: () {
                      // Add new row
                      setState(() {
                        newExtensions.add({"employee": null, "extension": ""});
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ---------- TABLE ----------
              Expanded(
                child: DatatableWidget(
                  columns: [
                    buildHeaderWithSearch(
                        title: "EMPLOYEE", removeSearching: true),
                    buildHeaderWithSearch(
                        title: "EXTENSION", removeSearching: true),
                    buildHeaderWithSearch(
                        title: "ACTIONS", removeSearching: true),
                  ],
                  rows: [
                    // Existing extensions
                    ...controller
                        .getManageExtentionModel!.employeeExtensions!
                        .map((ext) {
                      return DataRow(
                        cells: [
                          DataCell(Text(ext.employee!.username ?? "-")),
                          DataCell(Text(ext.extensionNumber ?? "-")),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    print("Edit clicked");
                                  },
                                  icon: Icon(Icons.edit,
                                      color: DynamicColors.primaryClr),
                                ),
                                IconButton(
                                  onPressed: () {
                                    print("Delete clicked");
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),

                    // New temporary rows
                    ...newExtensions.map((row) {
                      int index = newExtensions.indexOf(row);
                      return DataRow(
                        cells: [
                          // Employee dropdown
                          DataCell(
                            DropdownButton<String>(
                              value: row["employee"],
                              hint: const Text("Select Employee"),
                              items: employeeList
                                  .map((e) =>

                                  DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  newExtensions[index]["employee"] = val;
                                });
                              },
                            ),
                          ),
                          // Extension TextField
                          DataCell(
                              TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Extension",
                                ),

                                keyboardType: TextInputType.number, // Numeric keyboard

                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly, // Sirf numbers allow
                                ],

                                onChanged: (val) {
                                  newExtensions[index]["extension"] = val;
                                },
                              )
                          ),
                          // Actions: Save / Cancel
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    print("Save new extension: ${row["employee"]} - ${row["extension"]}");
                                    // Yahan controller ke addExtension method call kar sakte ho
                                    setState(() {
                                      newExtensions.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.check, color: Colors.green),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      newExtensions.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.close, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
