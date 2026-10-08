import 'package:dashboard_new1/component/action_icon_button.dart';
import 'package:dashboard_new1/component/alert_close_button.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/networks/api.dart';

class OrderAlert {
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
                if (controller.orderCtrl.text.isEmpty ) return;

                setState(() {
                  if (editingIndex == null) {

                    controller.orderAccountList.add({
                      "order": controller.orderCtrl.text,

                    });
                  } else {
                    controller.orderAccountList[editingIndex!] = {
                      "order": controller.orderCtrl.text,

                    };
                    editingIndex = null;
                  }

                  // clear fields
                  controller.orderCtrl.clear();

                });
              }

              return FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: Container(
                  width: Get.width * 0.3,
                  // padding: const EdgeInsets.all(14),
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
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ORDER NUMBERS",
                            style: titleDesign()
                          ),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                        ],
                      )),

                      const SizedBox(height: 10),

                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                        children: [
                          _buildField("ORDER #", controller.orderCtrl, autofocus: true, order: 1),
                          const SizedBox(width: 8),

                          if(permissions.contains('create_account_order_number')) FocusTraversalOrder(
                            order: const NumericFocusOrder(2),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 18),
                                  SizedBox(
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
                                  style: mozillaTextSemiBoldText(fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ),
                            ])
                          ),
                        ],
                      )),



                    const SizedBox(height: 12),

                    // Table Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F5),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: IntrinsicHeight(
                      child: Row(
                        children: [

                          Expanded(flex: 3,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Center(child: Text("ORDER #", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold))))),
                          VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey.shade300),
                          Expanded(flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              child: Center(child: Text("ACTIONS", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold))))),

                        ],
                      ),
                    ))),

                    // Table Body
                    ...controller.orderAccountList.asMap().entries.map((entry) {
                      int index = entry.key;
                      var row = entry.value;
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Center(child: Text(row["order"] ?? "")))),
                            VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: Colors.grey.shade300),

                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(permissions.contains('update_account_order_number')) ActionIconButton(
                                      icon: Icons.edit_calendar,
                                      color: const Color(0xFF43489A),
                                      order: 10.0 + index * 2.0,
                                      onPressed: () {
                                        setState(() {
                                          editingIndex = index;
                                          controller.orderCtrl.text = row["order"] ?? "";

                                        });
                                      },
                                    ),
                                    const SizedBox(width: 4),
                                    if(permissions.contains('delete_account_order_number')) ActionIconButton(
                                      icon: Icons.delete_forever,
                                      color: Colors.red,
                                      order: 10.0 + index * 2.0 + 1.0,
                                      onPressed: () {
                                        setState(() {
                                          controller.orderAccountList.removeAt(index);
                                          if (editingIndex == index) {
                                            editingIndex = null;
                                            controller.orderCtrl.clear();

                                          }
                                        });
                                      },
                                    ),
                                  ],
                              ),
                            ),
                          ],
                        ),
                              ))
                      );
                    }),
                      SizedBox(height: 20),
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
    Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
      Text(label, style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 4),
    SizedBox(
      height: 32,
      child: TextField(
        autofocus: autofocus,
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [UpperCaseTextFormatter()],
        style: outFitRegular(fontSize: 12),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        ),
      ),
      )]
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
