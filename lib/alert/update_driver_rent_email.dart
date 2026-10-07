import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/text_field.dart';

class EmailDriverRentAlt {
  static void show() {
    final emailCtrl = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Text("EMAIL DRIVER RENT", style: titleDesign()),
                    const Spacer(),
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(999),
                      child: const AlertCloseButton(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              SizedBox(height: 15),

              // Label
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: Text("RECIPIENT",
                    style: outFitRegular(fontSize: 14, fontWeight: FontWeight.w600, color: DynamicColors.black),
                  )),
              const SizedBox(height: 8),

              Padding(padding: EdgeInsets.symmetric(horizontal: 26),
                  child: TextField(
                    controller: emailCtrl,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: DynamicColors.primaryClr, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),

              const SizedBox(height: 20),
              const Divider(),

              // Action Buttons Row
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: 80,
                      height: 28,
                      verticalPadding: 0.0,
                      btnText: "CANCEL",
                      btnColor: Colors.red,
                      borderRadius: 4,
                      style: mozillaTextSemiBoldText(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      onTap: () => Get.back(),
                    ),
                    const SizedBox(width: 12),

                    // SEND Button
                    CustomButton(
                        width: 80,
                        height: 28,
                        verticalPadding: 0.0,
                        btnText: "SEND",
                        btnColor: DynamicColors.primaryClr,
                        borderRadius: 4,
                        style: mozillaTextSemiBoldText(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        onTap: () {
                          print("Email sent to: ${emailCtrl.text}");
                          Get.back();
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
