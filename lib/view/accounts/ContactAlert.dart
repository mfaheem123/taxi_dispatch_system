import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactAlert {
  static void show() {

    AccountController controller = Get.isRegistered<AccountController>()
        ? Get.find<AccountController>()
        : Get.put(AccountController());

    int? editingIndex;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: StatefulBuilder(
            builder: (context, setState) {
              void saveRow() {
                
                if (controller.contactAlertNameCtrl.text.isEmpty &&
                    controller.contactAlertEmailCtrl.text.isEmpty &&
                    controller.contactAlertPasswordCtrl.text.isEmpty &&
                    controller.contactAlertMobileCtrl.text.isEmpty &&
                    controller.contactAlertTelephoneCtrl.text.isEmpty) return;

                setState(() {
                  if (editingIndex == null) {
                    controller.contactsList.add({
                      "name": controller.contactAlertNameCtrl.text,
                      "email": controller.contactAlertEmailCtrl.text,
                      "password": controller.contactAlertPasswordCtrl.text,
                      "mobile": controller.contactAlertMobileCtrl.text,
                      "telephone": controller.contactAlertTelephoneCtrl.text,
                    });
                  } else {
                    controller.contactsList[editingIndex!] = {
                      "name": controller.contactAlertNameCtrl.text,
                      "email": controller.contactAlertEmailCtrl.text,
                      "password": controller.contactAlertPasswordCtrl.text,
                      "mobile": controller.contactAlertMobileCtrl.text,
                      "telephone": controller.contactAlertTelephoneCtrl.text,
                    };
                    editingIndex = null;
                  }

                  // clear fields
                  controller.contactAlertNameCtrl.clear();
                  controller.contactAlertEmailCtrl.clear();
                  controller.contactAlertPasswordCtrl.clear();
                  controller.contactAlertMobileCtrl.clear();
                  controller.contactAlertTelephoneCtrl.clear();
                });
              }

              return Container(
                width: Get.width * 0.6,
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
                          "CONTACT",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.close, size: 20, color: Colors.black54),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        _buildField("NAME", controller.contactAlertNameCtrl),
                        const SizedBox(width: 8),
                        _buildField("EMAIL", controller.contactAlertEmailCtrl),
                        const SizedBox(width: 8),
                        _buildField("PASSWORD", controller.contactAlertPasswordCtrl),
                        const SizedBox(width: 8),
                        _buildField("MOBILE", controller.contactAlertMobileCtrl),
                        const SizedBox(width: 8),
                        _buildField("TELEPHONE", controller.contactAlertTelephoneCtrl),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 90,
                          height: 34,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: editingIndex == null ? const Color(0xFF43489A) : Colors.orange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            onPressed: saveRow,
                            child: Text(
                              editingIndex == null ? "SAVE" : "UPDATE",
                              style: const TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),



                    const SizedBox(height: 12),

                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: const [

                          Expanded(child: Text("NAME", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("EMAIL", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("PASSWORD", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("MOBILE", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("TELEPHONE", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("ACTIONS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),

                        ],
                      ),
                    ),

                    // Table Body
                    ...controller.contactsList.asMap().entries.map((entry) {
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
                            Expanded(child: Text(row["name"] ?? "")),
                            Expanded(child: Text(row["email"] ?? "")),
                            Expanded(child: Text(row["password"] ?? "")),
                            Expanded(child: Text(row["mobile"] ?? "")),
                            Expanded(child: Text(row["telephone"] ?? "")),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18, color: Color(0xFF43489A)),
                                    onPressed: () {
                                      setState(() {
                                        editingIndex = index;
                                        controller.contactAlertNameCtrl.text = row["name"] ?? "";
                                        controller.contactAlertEmailCtrl.text = row["email"] ?? "";
                                        controller.contactAlertPasswordCtrl.text = row["password"] ?? "";
                                        controller.contactAlertMobileCtrl.text = row["mobile"] ?? "";
                                        controller.contactAlertTelephoneCtrl.text = row["telephone"] ?? "";
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        controller.contactsList.removeAt(index);
                                        if (editingIndex == index) {
                                          editingIndex = null;
                                          controller.contactAlertNameCtrl.clear();
                                          controller.contactAlertEmailCtrl.clear();
                                          controller.contactAlertPasswordCtrl.clear();
                                          controller.contactAlertMobileCtrl.clear();
                                          controller.contactAlertTelephoneCtrl.clear();
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
    return Expanded(
      child: SizedBox(
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
      ),
    );
  }

}
