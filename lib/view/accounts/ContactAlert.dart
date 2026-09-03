import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/action_icon_button.dart';
import 'package:dashboard_new1/component/alert_close_button.dart';
import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../component/networks/api.dart';

class ContactAlert {
  static void show() {

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
                if (controller.contactAlertEmailCtrl.text.isNotEmpty &&
                    !controller.contactAlertEmailCtrl.text.contains('@')) {
                  BotToast.showText(text:"INVALID EMAIL FORMAT");
                  return;
                }
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

              return FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: Container(
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
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          _buildField("NAME", controller.contactAlertNameCtrl, autofocus: true, order: 1),
                          const SizedBox(width: 8),
                          _buildField("EMAIL", controller.contactAlertEmailCtrl, order: 2),
                          const SizedBox(width: 8),
                          _buildField("PASSWORD", controller.contactAlertPasswordCtrl, order: 3),
                          const SizedBox(width: 8),
                          _buildField("MOBILE", controller.contactAlertMobileCtrl, isNumber: true, order: 4),
                          const SizedBox(width: 8),
                          _buildField("TELEPHONE", controller.contactAlertTelephoneCtrl, isNumber: true, order: 5),
                          const SizedBox(width: 8),
                          if(permissions.contains('create_account_contact')) FocusTraversalOrder(
                            order: const NumericFocusOrder(6),
                            child: SizedBox(
                              width: 100,
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
                                  if(permissions.contains('update_account_contact')) ActionIconButton(
                                    icon: Icons.edit,
                                    color: const Color(0xFF43489A),
                                    order: 10.0 + index * 2.0,
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
                                  const SizedBox(width: 4),
                                  if(permissions.contains('delete_account_contact')) ActionIconButton(
                                    icon: Icons.delete,
                                    color: Colors.red,
                                    order: 10.0 + index * 2.0 + 1.0,
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
              )  );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Widget _buildField(String label, TextEditingController controller, {bool isNumber = false, bool autofocus = false, double? order}) {
    Widget field = SizedBox(
      height: 32,
      child: TextField(
        autofocus: autofocus,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        ),
      ),
    );

    if (order != null) {
      field = FocusTraversalOrder(
        order: NumericFocusOrder(order),
        child: field,
      );
    }

    return Expanded(child: field);
  }

}
