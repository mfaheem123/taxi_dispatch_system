import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/networks/api.dart';
import '../view/administration/model/user_model.dart';

class ExtensionAlert {
  static void show() {
    final TextEditingController extensionCtrl = TextEditingController(
        text: Employee.selectedEmployee?.extensionNumber ?? ""
    );
    bool isPermanentSave = true;
    RxBool postExtensionLoad = false.obs;
    postExtension(String extensionNumber, bool isPermanent) async {
      if (Employee.selectedEmployee == null) {
        BotToast.showText(text: "User not found. Please re-login.");
        return;
      }
      postExtensionLoad(true);
      var formData = {
        "extension_number": extensionNumber,
        "permanent_flag": isPermanent,
        "employee_id": Employee.selectedEmployee!.id,
      };

      var response = await Api().post(
        formData,
        'employeeextension/add',
        auth: true,
      );

      if (response.statusCode == 200) {
        BotToast.showText(text: 'Extension Added Successfully');
        print("ID------------ ${Employee.selectedEmployee!.id}");
        Get.back();
      }
      postExtensionLoad(false);
    }
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: Get.width * 0.3,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F9F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Header ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "EXTENSIONS",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Colors.black12),

                  // --- Body ---
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Extension Input Field
                        TextField(
                          controller: extensionCtrl,
                          decoration: InputDecoration(
                            hintText: "ENTER EXTENSION NUMBER",
                            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF43489A)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF43489A), width: 1),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Permanent Save Toggle Row
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: isPermanentSave,
                                activeColor: Colors.white,
                                activeTrackColor: const Color(0xFF43489A), // Green color from image
                                onChanged: (value) {
                                  setState(() {
                                    isPermanentSave = value;
                                  });
                                },
                              ),
                            ),
                            const Text(
                              "PERMANENT SAVE",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5A6A75),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- Footer ---
                  const Divider(height: 1, color: Colors.black12),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43489A), // Bright Green
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          if (extensionCtrl.text.isNotEmpty) {
                            if (Employee.selectedEmployee != null) {
                              postExtension(extensionCtrl.text, isPermanentSave);
                            } else {
                              BotToast.showText(text: "Session expired! Please login again.");
                            }
                          } else {
                            BotToast.showText(text: "Please enter extension number");
                          }
                        },
                        child: const Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      barrierDismissible: true,
    );
  }
}