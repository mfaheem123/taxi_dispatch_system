import 'package:dashboard_new1/component/action_icon_button.dart';
import 'package:dashboard_new1/component/alert_close_button.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/networks/api.dart';

class CompanyAddressAlert {
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
              // void saveRow() {
              //
              // }

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
                            "ADDRESS ",
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
                          _buildField("ADDRESS", controller.addressCtrl, autofocus: true, order: 1),
                          const SizedBox(width: 8),

                          if(permissions.contains('create_account_company_address')) FocusTraversalOrder(
                            order: const NumericFocusOrder(2),
                            child: SizedBox(
                              width: 100,
                              height: 34,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: editingIndex == null ? const Color(0xFF43489A) : Colors.orange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: (){
                                  if (controller.addressCtrl.text.isEmpty ) return;

                                  setState(() {
                                    if (editingIndex == null) {

                                      controller.companyAddressesList.add({
                                        "address": controller.addressCtrl.text,

                                      });
                                    } else {
                                      controller.companyAddressesList[editingIndex!] = {
                                        "address": controller.addressCtrl.text,

                                      };
                                      editingIndex = null;
                                    }

                                    // clear fields
                                    controller.addressCtrl.clear();

                                  });
                                },
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

                          Expanded(child: Text("ADDRESS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),

                          Expanded(child: Text("ACTIONS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),

                        ],
                      ),
                    ),

                    // Table Body
                    ...controller.companyAddressesList.asMap().entries.map((entry) {
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
                            Expanded(child: Text(row["address"] ?? "")),

                            Expanded(
                              child: Row(
                                  children: [
                                    if(permissions.contains('update_account_company_address')) ActionIconButton(
                                      icon: Icons.edit,
                                      color: const Color(0xFF43489A),
                                      order: 10.0 + index * 2.0,
                                      onPressed: () {
                                        setState(() {
                                          editingIndex = index;
                                          controller.addressCtrl.text = row["address"] ?? "";

                                        });
                                      },
                                    ),
                                    const SizedBox(width: 4),
                                    if(permissions.contains('delete_account_company_address')) ActionIconButton(
                                      icon: Icons.delete,
                                      color: Colors.red,
                                      order: 10.0 + index * 2.0 + 1.0,
                                      onPressed: () {
                                        setState(() {
                                          controller.companyAddressesList.removeAt(index);
                                          if (editingIndex == index) {
                                            editingIndex = null;
                                            controller.addressCtrl.clear();

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
              )
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Widget _buildField(String label, TextEditingController controller, {bool autofocus = false, double? order}) {
    Widget field = SizedBox(
      height: 32,
      child: TextField(
        autofocus: autofocus,
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [UpperCaseTextFormatter()],
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
