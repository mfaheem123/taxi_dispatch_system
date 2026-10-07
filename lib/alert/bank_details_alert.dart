import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, LengthLimitingTextInputFormatter;
import 'package:get/get.dart';

import '../component/action_icon_button.dart';
import '../component/alert_close_button.dart';
import '../view/administration/User/create_subsiDiary.dart';
import '../view/administration/controller/administration_controller.dart';
import '../view/dashboard_view/widgets/time_picker_widget.dart';
import '../view/drivers_view/controller/driver_controller.dart';
import '../view/drivers_view/driver/create_driver_form/driver_form.dart';

class BankDetailsAlert {
  static void show() {
    // final List<Map<String, String>> shifts = [];
    final bank = TextEditingController();
    final accountTitle = TextEditingController();
    final account = TextEditingController();
    final iban = TextEditingController();
    final sortCode = TextEditingController();
    final vat = TextEditingController();

    AdministrationController controller = Get.isRegistered<AdministrationController>()
            ? Get.find<AdministrationController>()
            : Get.put(AdministrationController());

    int? editingIndex;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GetBuilder<AdministrationController>(
                  builder: (controller) {
                return FocusTraversalGroup(
                    policy: OrderedTraversalPolicy(),
                    child: Container(
                      width: Get.width * 0.7,
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
                                children: [
                                  Text("BANK DETAILS", style: titleDesign()),
                                  const Spacer(),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(999),
                                    child: const AlertCloseButton(),
                                  ),
                                ],
                              )),
                          const SizedBox(height: 12),

                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade200)),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 3,
                                          child: _buildField("BANK", bank, TextInputType.text, autofocus: true, order: 1)),
                                      const SizedBox(width: 8),
                                      Expanded(flex: 3,
                                          child: _buildField("ACCOUNT TITLE", accountTitle, TextInputType.text, order: 2)),
                                      const SizedBox(width: 8),
                                      Expanded(flex: 3,
                                          child: _buildField("ACCOUNT #", account, const TextInputType.numberWithOptions(decimal: true), order: 3)),
                                      const SizedBox(width: 8),
                                      Expanded(flex: 3,
                                        // keyboardType ko badal kar TextInputType.text kar diya
                                        child: _buildField("IBAN", iban, TextInputType.text, order: 4)),
                                      // const SizedBox(width: 8), Expanded(
                                      //     flex: 2, child: _buildField("IBAN", iban,const TextInputType.numberWithOptions(decimal: true))),
                                      const SizedBox(width: 8),
                                      Expanded(flex: 3,
                                          child: _buildField("SORT CODE", sortCode, const TextInputType.numberWithOptions(decimal: true), order: 5)),
                                      const SizedBox(width: 8),
                                      Expanded(flex: 3,
                                          child: _buildField("VAT #", vat, const TextInputType.numberWithOptions(decimal: true), order: 6)),
                                      const SizedBox(width: 8),

                                      FocusTraversalOrder(
                                        order: const NumericFocusOrder(6),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                            const SizedBox(height: 18),
                                        SizedBox(
                                          width: 100,
                                          height: 34,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:DynamicColors.primaryClr,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (bank.text.isEmpty) {
                                                BotToast.showText( text: "ERROR, BANK NAME IS REQUIRED");
                                                return;
                                              }
                                              if (editingIndex != null) {
                                                controller.bankDetailList[
                                                        editingIndex!] = BankDetailsAlertClass(
                                                  bank: bank.text,
                                                  accountTitle: accountTitle.text,
                                                  account: account.text,
                                                  iban: iban.text,
                                                  sortCode: sortCode.text,
                                                  vat: vat.text,
                                                );
                                                editingIndex = null;
                                              } else {
                                                controller.bankDetailList.add(BankDetailsAlertClass(
                                                  bank: bank.text,
                                                  accountTitle: accountTitle.text,
                                                  account: account.text,
                                                  iban: iban.text,
                                                  sortCode: sortCode.text,
                                                  vat: vat.text,
                                                ));
                                              }
                                              bank.clear();
                                              accountTitle.clear();
                                              account.clear();
                                              iban.clear();
                                              sortCode.clear();
                                              vat.clear();
                                              controller.update();
                                              setState(() {});
                                            },
                                            child: Text(
                                              editingIndex == null ? "SAVE" : "UPDATE",
                                              style: mozillaTextSemiBoldText(
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ])),


                                      ///-------------------
                                    ],
                                  ))),

                          const SizedBox(height: 14),

                          /// Table Header
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F3F5),
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4)),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(flex: 3,
                                            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                child: Center(child: Text("BANK", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold))))),
                                        VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                        Expanded(flex: 3,
                                            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                child: Center(child: Text("ACCOUNT TITLE", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold))))),
                                        VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                        Expanded(flex: 3,
                                            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                child: Center(child: Text("ACCOUNT #", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold))))),
                                        VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                        Expanded(flex: 3,
                                            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                child: Center(child: Text("IBAN", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold))))),
                                        VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                        Expanded(flex: 3,
                                            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                child: Center(child: Text("SORT CODE", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold))))),
                                        VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                        Expanded(flex: 3,
                                            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                child: Center(child: Text("VAT #", style: outFitRegular(fontSize: 13, fontWeight: FontWeight.bold))))),
                                        VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                        Expanded(flex: 3,
                                            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                child: SizedBox())),
                                      ]),
                                  ))),

                          /// Table Body

                          ...controller.bankDetailList.asMap().entries
                              .map((entry) {
                            int index = entry.key;
                            var row = entry.value; // This is a ShiftAlertClass object

                            return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(color: Colors.grey.shade300),
                                        right: BorderSide(color: Colors.grey.shade300),
                                        bottom: BorderSide(color: Colors.grey.shade300),
                                      ),
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Expanded(flex: 3,
                                              child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                  child: Center(child: Text(row.bank)))),
                                          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                          Expanded(flex: 3,
                                              child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                  child: Center(child: Text(row.accountTitle ?? "")))),
                                          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                          Expanded(flex: 3,
                                              child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                  child: Center(child: Text(row.account ?? "")))),
                                          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                          Expanded(flex: 3,
                                              child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                  child: Center(child: Text(row.iban)))),
                                          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                          Expanded(flex: 3,
                                              child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                  child: Center(child: Text(row.sortCode ?? "")))),
                                          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                          Expanded(flex: 3,
                                              child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                  child: Center(child: Text(row.vat ?? "")))),
                                          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ActionIconButton(
                                                  icon: Icons.edit,
                                                  color: const Color(0xFF43489A),
                                                  order: 10.0 + index * 2.0,
                                                  onPressed: () {
                                                    setState(() {
                                                      editingIndex = index;
                                                      bank.text = row.bank;
                                                      accountTitle.text = row.accountTitle ?? "";
                                                      account.text = row.account ?? "";
                                                      iban.text = row.iban ?? "";
                                                      sortCode.text = row.sortCode ?? "";
                                                      vat.text = row.vat ?? "";
                                                    });
                                                  },
                                                ),
                                                ActionIconButton(
                                                  icon: Icons.delete,
                                                  color: Colors.red,
                                                  order: 10.0 + index * 2.0 + 1.0,
                                                  onPressed: () {
                                                    setState(() {
                                                      controller.bankDetailList.removeAt(index);
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
                          const SizedBox(height: 20),
                        ],
                      ),
                    ));
                SizedBox(height: 10);
              });
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Widget _buildField(String label, TextEditingController controller,
      TextInputType keyboardType,
      {bool autofocus = false, double? order}) {
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
        keyboardType: keyboardType,
        controller: controller,
        inputFormatters: (label == "BANK" || label == "ACCOUNT TITLE")
            ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                UpperCaseTextFormatter()
              ]
            : label == "VAT #"
                ? [FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2)
                  ]
                : label == "IBAN"
                    ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                        UpperCaseTextFormatter()
                      ] // IBAN ke liye Letters + Numbers
                    : (keyboardType == TextInputType.number ||
                            keyboardType == const TextInputType.numberWithOptions(decimal: true)
                        ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                          ] // Normal numbers ke liye
                        : []),
        style: outFitRegular(fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: outFitRegular(fontSize: 11),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        ),
      ))],
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

