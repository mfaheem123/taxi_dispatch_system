import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsAlert {
  static void show() {
    final List<Map<String, String>> rows = [];

    final accountCtrl = TextEditingController();
    final usernameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final mobileCtrl = TextEditingController();
    final telephoneCtrl = TextEditingController();

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
                if (accountCtrl.text.isEmpty &&
                    usernameCtrl.text.isEmpty &&
                    passwordCtrl.text.isEmpty &&
                    mobileCtrl.text.isEmpty &&
                    telephoneCtrl.text.isEmpty) return;

                setState(() {
                  if (editingIndex == null) {

                    rows.add({
                      "account": accountCtrl.text,
                      "username": usernameCtrl.text,
                      "password": passwordCtrl.text,
                      "mobile": mobileCtrl.text,
                      "telephone": telephoneCtrl.text,
                    });
                  } else {
                    rows[editingIndex!] = {
                      "account": accountCtrl.text,
                      "username": usernameCtrl.text,
                      "password": passwordCtrl.text,
                      "mobile": mobileCtrl.text,
                      "telephone": telephoneCtrl.text,
                    };
                    editingIndex = null;
                  }

                  // clear fields
                  accountCtrl.clear();
                  usernameCtrl.clear();
                  passwordCtrl.clear();
                  mobileCtrl.clear();
                  telephoneCtrl.clear();
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
                          "WEB LOGINS",
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
                        _buildField("ACCOUNT #", accountCtrl),
                        const SizedBox(width: 8),
                        _buildField("USERNAME", usernameCtrl),
                        const SizedBox(width: 8),
                        _buildField("PASSWORD", passwordCtrl),
                        const SizedBox(width: 8),
                        _buildField("MOBILE", mobileCtrl),
                        const SizedBox(width: 8),
                        _buildField("TELEPHONE", telephoneCtrl),
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
                          Expanded(child: Text("ACCOUNT #", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("USERNAME", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("PASSWORD", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("MOBILE", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("TELEPHONE", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          Expanded(child: Text("ACTIONS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),

                    // Table Body
                    ...rows.asMap().entries.map((entry) {
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
                            Expanded(child: Text(row["account"] ?? "")),
                            Expanded(child: Text(row["username"] ?? "")),
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
                                        accountCtrl.text = row["account"] ?? "";
                                        usernameCtrl.text = row["username"] ?? "";
                                        passwordCtrl.text = row["password"] ?? "";
                                        mobileCtrl.text = row["mobile"] ?? "";
                                        telephoneCtrl.text = row["telephone"] ?? "";
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        rows.removeAt(index);
                                        if (editingIndex == index) {
                                          editingIndex = null;
                                          accountCtrl.clear();
                                          usernameCtrl.clear();
                                          passwordCtrl.clear();
                                          mobileCtrl.clear();
                                          telephoneCtrl.clear();
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
