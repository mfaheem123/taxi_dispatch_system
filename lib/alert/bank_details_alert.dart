import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter, LengthLimitingTextInputFormatter;
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
                                "BANK DETAILS",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(999),
                                child: const AlertCloseButton(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                  flex: 2, child: _buildField("BANK", bank, TextInputType.text, autofocus: true, order: 1)),
                              const SizedBox(width: 8),
                              Expanded(
                                  flex: 2, child: _buildField("ACCOUNT TITLE", accountTitle,TextInputType.text, order: 2)),
                              const SizedBox(width: 8),
                              Expanded(
                                  flex: 2, child: _buildField("ACCOUNT #", account,const TextInputType.numberWithOptions(decimal: true), order: 3 )),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                // keyboardType ko badal kar TextInputType.text kar diya
                                child: _buildField("IBAN", iban, TextInputType.text, order: 4),
                              ),
                              // const SizedBox(width: 8), Expanded(
                              //     flex: 2, child: _buildField("IBAN", iban,const TextInputType.numberWithOptions(decimal: true))),
                              const SizedBox(width: 8), Expanded(
                                  flex: 2, child: _buildField("SORT CODE", sortCode, const TextInputType.numberWithOptions(decimal: true), order: 5)),
                              const SizedBox(width: 8), Expanded(
                                  flex: 2, child: _buildField("VAT #", vat, const TextInputType.numberWithOptions(decimal: true), order: 6)),
                              const SizedBox(width: 8),

                              FocusTraversalOrder(
                                  order: const NumericFocusOrder(6),
                                  child: SizedBox(
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
                                    onPressed: () {
                                      if (bank.text.isEmpty) {
                                        Get.snackbar("Error", "Bank name is required");
                                        return;
                                      }
                                      if (editingIndex != null) {
                                        controller.bankDetailList[editingIndex!] = BankDetailsAlertClass(
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
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ),

                                ),
                              ),

                              ///-------------------
                            ],
                          ),

                          const SizedBox(height: 14),

                          /// Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6,),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: const [
                                Expanded(
                                    flex: 2,
                                    child: Text("BANK",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("ACCOUNT TITLE",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("ACCOUNT #",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("IBAN",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("SORT CODE",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("VAT #",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(flex: 1, child: SizedBox()),
                              ],
                            ),
                          ),

                          /// Table Body

                          ...controller.bankDetailList.asMap().entries.map((entry) {
                            int index = entry.key;
                            var row = entry.value; // This is a ShiftAlertClass object

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 6,),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(row.bank)),
                                  Expanded(flex: 2, child: Text(row.accountTitle ?? "")),
                                  Expanded(flex: 2, child: Text(row.account ?? "")),
                                  Expanded(flex: 2, child: Text(row.iban)),
                                  Expanded(flex: 2, child: Text(row.sortCode ?? "")),
                                  Expanded(flex: 2, child: Text(row.vat ?? "")),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
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
                            );
                          }

                          ),

                        ],
                      ),
                    ));
                  }
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  static Widget _buildField(String label, TextEditingController controller, TextInputType keyboardType, { bool autofocus = false, double? order}) {
    Widget field = SizedBox(
      height: 32,
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        inputFormatters: (label == "BANK" || label == "ACCOUNT TITLE")
            ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), UpperCaseTextFormatter()]
            : label == "VAT #"
            ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)]
            : label == "IBAN"
            ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), UpperCaseTextFormatter()] // IBAN ke liye Letters + Numbers
            : (keyboardType == TextInputType.number || keyboardType == const TextInputType.numberWithOptions(decimal: true)
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))] // Normal numbers ke liye
            : []),
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
  // static Widget _buildField(String label, TextEditingController controller, TextInputType keyboardType) {
  //   return SizedBox(
  //     height: 32,
  //     child: TextField(
  //       keyboardType: keyboardType,
  //       controller: controller,
  //       inputFormatters: keyboardType == TextInputType.number || keyboardType == const TextInputType.numberWithOptions(decimal: true)
  //           ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
  //           : [],
  //       style: const TextStyle(fontSize: 12),
  //       decoration: InputDecoration(
  //         labelText: label,
  //         labelStyle: const TextStyle(fontSize: 11),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(6),
  //         ),
  //         contentPadding:
  //         const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  //       ),
  //     ),
  //   );
  // }
}



class NoteAlert {
  static void show() {
    // final List<Map<String, String>> shifts = [];
    DriverController controller = Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : Get.put(DriverController());

    // int? editingIndex;
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GetBuilder<DriverController>(
                  builder: (controller) {
                    return Container(
                      width: Get.width * 0.7,
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
                                "NOTES",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () => Get.back(),
                                child: const Icon(Icons.close,
                                    size: 20, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                  flex: 4, child: TextField(
                                maxLines: 5,
                                minLines: 5,
                                controller: controller.notesCtrl,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  labelText: "NOTES",
                                  labelStyle: const TextStyle(fontSize: 11),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                ),
                              )),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 34,
                                  child: CustomButton(
                                    width: 150,
                                    height: 35,
                                    verticalPadding: 0.0,
                                    btnText: "SAVE",
                                    borderRadius: 4,
                                    style: mozillaTextRegularText(
                                        fontSize: 14, color: DynamicColors.whiteClr),
                                    onTap: () {
                                      controller.noteList.add(NoteAlertClass(
                                          notesTitle: controller.notesCtrl.text,
                                          createdItTime: "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                          createdByTime: "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"
                                      ));
                                      controller.notesCtrl.clear();
                                      controller.update();
                                      // saveShift;
                                    },
                                  ),

                                ),
                              ),

                              ///-------------------
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: const [
                                Expanded(
                                    flex: 2,
                                    child: Text("SHIFT NAME",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("START TIME",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("END TIME",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text("ACTIONS",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),

                          // Table Body
                          ...controller.noteList.asMap().entries.map((entry) {
                            int index = entry.key;
                            var row = entry.value; // This is a ShiftAlertClass object

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(row.notesTitle)),
                                  Expanded(flex: 2, child: Text(row.createdItTime ?? "")),
                                  Expanded(flex: 2, child: Text(row.createdByTime ?? "")),
                                  Expanded(
                                    flex: 2,
                                    child: Row(

                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              size: 18, color: Color(0xFF43489A)),
                                          onPressed: () {
                                            setState(() {

                                              controller.notesCtrl.text = row.notesTitle.text;
                                            });
                                          },
                                        ),

                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 18, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              controller.shiftList.removeAt(index);
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
                  }
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}


