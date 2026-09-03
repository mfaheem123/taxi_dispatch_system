import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/services.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:dashboard_new1/view/setting/controller/extension_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/dropdown_button.dart';
import 'controller/setting_controller.dart';

class VoipSettingsScreen extends StatefulWidget {
  const VoipSettingsScreen({super.key});

  @override
  State<VoipSettingsScreen> createState() => _VoipSettingsScreenState();
}

class _VoipSettingsScreenState extends State<VoipSettingsScreen> {
  // Temporary new rows for adding extension
  List<Map<String, dynamic>> newExtensions = [];

  int? editingExtensionId;
  final TextEditingController editExtensionController = TextEditingController();
  dynamic editSelectedEmployee;

  ExtensionController controller = Get.put(ExtensionController());
  final SettingController _controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  void initState() {
    super.initState();

    _controller.getDocumentSubsidiary();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.selectSubsidiaryValue != null) {
        _controller.getCompanyConfiguration(_controller.selectSubsidiaryValue!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<ExtensionController>(
      initState: (v) {
        controller.getManageExtention();
      },
      builder: (controller) {
        if (controller.getManageExtentionModel == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // List of employees for dropdown
        List<String> employeeList = controller
            .getManageExtentionModel!.employeeExtensions!
            .map((e) => e.employee!.username ?? "-")
            .toList();

        return GetBuilder<SettingController>(
          builder: (settingController) {
          return SingleChildScrollView(
            child: Container(
              width: w,
              height: h,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ---------- TITLE ----------

                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 12),
                  //   child: const Text(
                  //     "VOIP SETTINGS",
                  //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  //   ),
                  // ),

                  // ---------- SERVICE + STATUS ----------
                  Container(
                      width: w * 0.7,
                      // padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: DynamicColors.gryClr,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                            child: Text(
                              "VOIP SETTINGS",
                              style: mozillaTextSemiBoldText(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: DynamicColors.black,
                              ),
                            ),
                          ),
                          // Service
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text("SERVICE",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: CustomDropdownField<String>(
                                              label: "VOIP STATUS",
                                              items: const ["YESTECH", "V4VOIP"],
                                              value: ["YESTECH", "V4VOIP"].contains(settingController.voipServiceValue)
                                                  ? settingController.voipServiceValue
                                                  : "YESTECH",
                                              itemLabel: (item) => item,
                                              onChanged: (val) {
                                                settingController.voipServiceValue = val ?? "YESTECH";
                                                settingController.update();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 25),

                                    // Status
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text("STATUS",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: CustomDropdownField<String>(
                                              label: "VOIP STATUS",
                                              items: const ["IDLE", "RINGING", "IN USE"],
                                              value: ["IDLE", "RINGING", "IN USE"].contains(settingController.voipStatusValue)
                                                  ? settingController.voipStatusValue
                                                  : "IDLE",
                                              itemLabel: (item) => item,
                                              onChanged: (val) {
                                                settingController.voipStatusValue = val ?? "IDLE";
                                                settingController.update();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Save Button
                                Center(
                                  child: CustomButton(
                                    height: 35,
                                    width: 250,
                                    verticalPadding: 0.0,
                                    borderRadius: 4,
                                    widget: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 0.0),
                                      child: settingController.isSavingConfig
                                          ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : Text(
                                        AppText.save,
                                        style: mozillaTextRegularText(
                                            fontSize: 12,
                                            color: DynamicColors.whiteClr),
                                      ),
                                    ),
                                    onTap: () async {
                                      await settingController.saveCompanyConfiguration();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                  SizedBox(height: 20),

                  // ---------- MANAGE EXTENSIONS + BUTTON ----------
                  Container(
                    width: w * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "MANAGE EXTENSIONS",
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        CustomButton(
                          height: 35,
                          width: 50,
                          verticalPadding: 0.0,
                          borderRadius: 4,
                          widget: const Center(
                            child: Icon(Icons.add, size: 16, color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              newExtensions.add({
                                "employeeObj": null,
                                "extension": ""
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: w * 0.7,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "EMPLOYEE", removeSearching: true),
                        buildHeaderWithSearch(title: "EXTENSION", removeSearching: true),
                        buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                      ],
                      rows: [
                        // Existing Extensions List
                        ...controller.getManageExtentionModel!.employeeExtensions!.map((ext) {
                          bool isEditing = editingExtensionId == ext.id;

                          return DataRow(
                            cells: [

                              DataCell(
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text((ext.employee?.username ?? "-").toUpperCase()),
                                ),
                              ),

                              DataCell(
                                Container(
                                  alignment: Alignment.center,
                                  child: isEditing
                                      ? SizedBox(
                                    width: 130,
                                    height: 38,
                                    child: TextField(
                                      controller: editExtensionController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                      : Text(ext.extensionNumber ?? "-"),
                                ),
                              ),

                              DataCell(
                                Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Edit/Save Toggle Icon
                                      IconButton(
                                        onPressed: () async {
                                          if (isEditing) {
                                            // Update API Call
                                            controller.selectedEmployee = ext.employee;
                                            controller.extensionNumberController.text = editExtensionController.text.trim();
                                            controller.isUpdateExtension(true);
                                            controller.extensionUpdateId(ext.id!);

                                            await controller.saveExtension();

                                            setState(() {
                                              editingExtensionId = null;
                                            });
                                          } else {
                                            // Toggle to Edit State
                                            setState(() {
                                              editingExtensionId = ext.id;
                                              editExtensionController.text = ext.extensionNumber ?? "";
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          isEditing ? Icons.check : Icons.edit,
                                          color: isEditing ? Colors.green : DynamicColors.primaryClr,
                                          size: 20,
                                        ),
                                      ),

                                      // Delete or Cancel Editing Icon
                                      IconButton(
                                        onPressed: () async {
                                          if (isEditing) {
                                            setState(() {
                                              editingExtensionId = null;
                                            });
                                          } else {
                                            await controller.deleteExtension(ext.id!);
                                          }
                                        },
                                        icon: Icon(
                                          isEditing ? Icons.close : Icons.delete,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),

                        // New Temporary Rows (Adding Mode)
                        ...newExtensions.map((row) {
                          int index = newExtensions.indexOf(row);
                          return DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  alignment: Alignment.center,
                                  child: DropdownButton<dynamic>(
                                    value: row["employeeObj"],
                                    hint: const Text("SELECT EMPLOYEE"),
                                    alignment: Alignment.center,
                                    items: controller.getManageExtentionModel!.employeeExtensions!.map((e) {
                                      return DropdownMenuItem(
                                        value: e.employee,
                                        child: Text((e.employee?.username ?? "-").toUpperCase()),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        newExtensions[index]["employeeObj"] = val;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 150,
                                    height: 38,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "ENTER EXTENSION",
                                      ),
                                      onChanged: (val) {
                                        newExtensions[index]["extension"] = val;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          controller.selectedEmployee = row["employeeObj"];
                                          controller.extensionNumberController.text = row["extension"] ?? "";

                                          await controller.saveExtension();

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
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
          },
        );
      },
    );
  }
}
