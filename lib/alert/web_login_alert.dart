import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../component/networks/api.dart';
import '../component/text_field.dart';

class WebLoginAlert {
  static void show() {
    final List<Map<String, String>> rows = [];

    AccountController controller = Get.isRegistered<AccountController>()
        ? Get.find<AccountController>()
        : Get.put(AccountController());
    List permissions = [];
    permissions = Api().sp.read('all_permissions') ?? [];

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
                if (controller.webLoginaccountCtrl.text.isEmpty &&
                    controller.webLoginusernameCtrl.text.isEmpty &&
                    controller.webLoginpasswordCtrl.text.isEmpty &&
                    controller.webLoginmobileCtrl.text.isEmpty &&
                    controller.webLogintelephoneCtrl.text.isEmpty) return;

                setState(() {
                  // if (editingIndex == null) {
                  //   controller.webLoginDataList.add(WebLoginClass(
                  WebLoginClass entry = WebLoginClass(
                      account: controller.webLoginaccountCtrl.text,
                      userName: controller.webLoginusernameCtrl.text,
                      password: controller.webLoginpasswordCtrl.text,
                      mobile: controller.webLoginmobileCtrl.text,
                      telphone: controller.webLogintelephoneCtrl.text,
                    );
                  if (editingIndex == null) {
                    controller.webLoginDataList.add(entry);
                  } else {
                    controller.webLoginDataList[editingIndex!] = entry;
                    editingIndex = null;
                  }
                  //   rows.add({
                  //     "account": controller.webLoginaccountCtrl.text,
                  //     "username": controller.webLoginusernameCtrl.text,
                  //     "password": controller.webLoginpasswordCtrl.text,
                  //     "mobile": controller.webLoginmobileCtrl.text,
                  //     "telephone": controller.webLogintelephoneCtrl.text,
                  //   });
                  // } else {
                  //   controller.webLoginDataList.add(WebLoginClass(
                  //     account: controller.webLoginaccountCtrl.text,
                  //     userName: controller.webLoginusernameCtrl.text,
                  //     password: controller.webLoginpasswordCtrl.text,
                  //     mobile: controller.webLoginmobileCtrl.text,
                  //     telphone: controller.webLogintelephoneCtrl.text,
                  //   ));
                  //   rows[editingIndex!] = {
                  //     "account": controller.webLoginaccountCtrl.text,
                  //     "username": controller.webLoginusernameCtrl.text,
                  //     "password": controller.webLoginpasswordCtrl.text,
                  //     "mobile": controller.webLoginmobileCtrl.text,
                  //     "telephone": controller.webLogintelephoneCtrl.text,
                  //   };
                  //   editingIndex = null;
                  // }

                  // Clear fields
                  controller.webLoginaccountCtrl.clear();
                  controller.webLoginusernameCtrl.clear();
                  controller.webLoginpasswordCtrl.clear();
                  controller.webLoginmobileCtrl.clear();
                  controller.webLogintelephoneCtrl.clear();
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
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "WEB LOGINS",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                     SizedBox(height: 10),

                    // Input Fields Row
                    Row(
                      children: [
                        _buildField("ACCOUNT #", controller.webLoginaccountCtrl),
                        const SizedBox(width: 8),
                        _buildField("USERNAME", controller.webLoginusernameCtrl),
                        const SizedBox(width: 8),
                        _buildField("PASSWORD", controller.webLoginpasswordCtrl),
                        const SizedBox(width: 8),
                        _buildField("MOBILE", controller.webLoginmobileCtrl, isNumber: true),
                        const SizedBox(width: 8),
                        _buildField("TELEPHONE", controller.webLogintelephoneCtrl, isNumber: true),
                        const SizedBox(width: 8),
                        if(permissions.contains('create_account_web_login')) SizedBox(
                          width: 100,
                          height: 34,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: editingIndex == null
                                  ? const Color(0xFF43489A)
                                  : Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: saveRow,
                            child: Text(
                              editingIndex == null ? "SAVE" : "UPDATE",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),


                    const SizedBox(height: 12),

                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "ACCOUNT #",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "USERNAME",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "PASSWORD",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "MOBILE",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "TELEPHONE",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "ACTIONS",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Table Body
                    ...controller.webLoginDataList.asMap().entries.map((entry) {
                      int index = entry.key;
                      var row = entry.value;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(row.account ?? "")),
                            Expanded(child: Text(row.userName ?? "")),
                            Expanded(child: Text(row.password ?? "")),
                            Expanded(child: Text(row.mobile ?? "")),
                            Expanded(child: Text(row.telphone ?? "")),
                            Expanded(
                              child: Row(
                                children: [
                                  if(permissions.contains('update_account_web_login')) IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Color(0xFF43489A),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        editingIndex = index;
                                        controller.webLoginaccountCtrl.text =
                                            row.account ?? "";
                                        controller.webLoginusernameCtrl.text =
                                            row.userName ?? "";
                                        controller.webLoginpasswordCtrl.text =
                                            row.password ?? "";
                                        controller.webLoginmobileCtrl.text =
                                            row.mobile ?? "";
                                        controller.webLogintelephoneCtrl.text =
                                            row.telphone ?? "";
                                      });
                                    },
                                  ),
                                  if(permissions.contains('delete_account_web_login')) IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        // rows.removeAt(index);
                                        controller.webLoginDataList.removeAt(index);
                                        if (editingIndex == index) {
                                          editingIndex = null;
                                          controller.webLoginaccountCtrl.clear();
                                          controller.webLoginusernameCtrl.clear();
                                          controller.webLoginpasswordCtrl.clear();
                                          controller.webLoginmobileCtrl.clear();
                                          controller.webLogintelephoneCtrl.clear();
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

  static Widget _buildField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Expanded(
      child: SizedBox(
        height: 32,
        child: TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: (value) {
            if (!isNumber) {
              controller.value = controller.value.copyWith(
                text: value.toUpperCase(),
                selection: TextSelection.collapsed(offset: value.length),
              );
            }
          },
          inputFormatters: [
            if (isNumber) FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
          ),
        ),
      ),
    );
  }
}