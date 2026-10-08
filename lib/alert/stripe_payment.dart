import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

class StripePayment {
  static void show() {
    final amountCtrl = TextEditingController(text: "99.87");
    final mobileCtrl = TextEditingController();
    int stripRadio = 0;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: 450,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "STRIPE PAYMENT",
                          style: titleDesign()
                        ),
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

                  // Amount and Radio Row
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              controller: amountCtrl,
                              borderRadius: 5,
                              inputFormatters: [UpperCaseTextFormatter()],
                              // hintText: "99.87",
                            ),
                          ),
                          const SizedBox(width: 20),
                          // SMS Radio
                          Radio(
                            value: 0,
                            groupValue: stripRadio,
                            activeColor: Colors.green,
                            onChanged: (int? v) {
                              setState(() => stripRadio = v!);
                            },
                          ),
                          Text("SMS",
                              style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 10),
                          // EMAIL Radio
                          Radio(
                            value: 1,
                            groupValue: stripRadio,
                            activeColor: Colors.green,
                            onChanged: (int? v) {
                              setState(() => stripRadio = v!);
                            },
                          ),
                          Text("EMAIL", style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      )),

                  const SizedBox(height: 15),

                  // Mobile Field and Generate Link Button
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              controller: mobileCtrl,
                              hintText: "MOBILE",
                              borderRadius: 5,
                              inputFormatters: [UpperCaseTextFormatter()],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B90B8), // Blue color from image
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {},
                              child: Text("GENERATE LINK",
                                  style: outFitRegular(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                        ],
                      )),

                  const SizedBox(height: 30),
                  const Divider(),

                  // Bottom Send Button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                              Get.back();
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      barrierDismissible: true,
    );
  }
}
