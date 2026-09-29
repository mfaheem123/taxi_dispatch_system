import 'package:dashboard_new1/component/action_icon_button.dart';
import 'package:dashboard_new1/component/alert_close_button.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';

import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/networks/api.dart';

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

                  controller.webLoginaccountCtrl.clear();
                  controller.webLoginusernameCtrl.clear();
                  controller.webLoginpasswordCtrl.clear();
                  controller.webLoginmobileCtrl.clear();
                  controller.webLogintelephoneCtrl.clear();
                });
              }

              return FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: Container(
                  width: Get.width * 0.6,
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
                      // Header
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
                            "WEB LOGINS",
                            style: titleDesign()
                          ),

                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                        ],
                      )),

                       SizedBox(height: 10),

                      // Input Fields Row
                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          _buildField("ACCOUNT #", controller.webLoginaccountCtrl, autofocus: true, order: 1),
                          const SizedBox(width: 8),
                          _buildField("USERNAME", controller.webLoginusernameCtrl, order: 2),
                          const SizedBox(width: 8),
                          _buildField("PASSWORD", controller.webLoginpasswordCtrl, order: 3),
                          const SizedBox(width: 8),
                          _buildField("MOBILE", controller.webLoginmobileCtrl, isNumber: true, order: 4),
                          const SizedBox(width: 8),
                          _buildField("TELEPHONE", controller.webLogintelephoneCtrl, isNumber: true, order: 5),
                          const SizedBox(width: 8),
                          if(permissions.contains('create_account_web_login')) FocusTraversalOrder(
                            order: const NumericFocusOrder(6),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                const SizedBox(height: 18),
                            SizedBox(
                              width: 100,
                              height: 32,
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
                                  style: mozillaTextSemiBoldText(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )),
                    ])
                      ),


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
                          Expanded(
                            flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Center(child: Text("ACCOUNT #", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold)))),
                          ),
                          VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey.shade300),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Center(child: Text("USERNAME", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold)))),
                          ),
                          VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey.shade300),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Center(child: Text("PASSWORD", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold)))),
                          ),
                          VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey.shade300),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Center(child: Text("MOBILE", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold)))),
                          ),
                          VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey.shade300),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Center(child: Text("TELEPHONE", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold)))),
                          ),
                          VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey.shade300),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Center(child: Text("ACTIONS", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold)))),
                          ),
                        ],
                      )),
                    )),

                    // Table Body
                    ...controller.webLoginDataList.asMap().entries.map((entry) {
                      int index = entry.key;
                      var row = entry.value;

                      return Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(flex:3,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    child: Center(child: Text(row.account ?? "")))),
                            VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                            Expanded(flex:3,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    child: Center(child: Text(row.userName ?? "")))),
                            VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                            Expanded(flex:3,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    child: Center(child: Text(row.password ?? "")))),
                            VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                            Expanded(flex:3,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    child: Center(child: Text(row.mobile ?? "")))),
                            VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                            Expanded(flex:3,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    child: Center(child: Text(row.telphone ?? "")))),
                            VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                            Expanded(
                                flex:3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if(permissions.contains('update_account_web_login')) ActionIconButton(
                                    icon: Icons.edit_calendar,
                                    color: const Color(0xFF43489A),
                                    order: 10.0 + index * 2.0,
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
                                  const SizedBox(width: 4),
                                  if(permissions.contains('delete_account_web_login')) ActionIconButton(
                                    icon: Icons.delete_forever,
                                    color: Colors.red,
                                    order: 10.0 + index * 2.0 + 1.0,
                                    onPressed: () {
                                      setState(() {
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
                      )));
                    }),
                      SizedBox(height: 20),
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
        style: outFitRegular(fontSize: 12),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 4,
          ),
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