import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/color_picker_widget.dart';

class PaymentTypeColorAlert extends StatefulWidget {
  const PaymentTypeColorAlert({super.key});

  static void show() {
    Get.dialog(
      const AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        content: PaymentTypeColorAlert(),
      ),
      barrierDismissible: true,
    );
  }

  @override
  State<PaymentTypeColorAlert> createState() => _PaymentTypeColorAlertState();
}

class _PaymentTypeColorAlertState extends State<PaymentTypeColorAlert> {
  final List<String> paymentTypes = [
    "CASH",
    "CREDIT CARD",
    "ACCOUNT",
    "CREDIT CARD PAID"
  ];

  // Colors state maintain karne ke liye variables
  final Map<int, Color> bgColors = {};
  final Map<int, Color> fgColors = {};

  @override
  void initState() {
    super.initState();
    // Sab rows ke liye default colors initial state me set kiye hain
    for (int i = 0; i < paymentTypes.length; i++) {
      bgColors[i] = Colors.white;
      fgColors[i] = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550, // 🔥 Chota aur compact size bilkul phle alert jaisa
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. HEADER (HEADING)
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: DynamicColors.gryClr,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Text(
              "PAYMENT TYPE COLOR CODE",
              style: mozillaTextSemiBoldText(
                fontSize: 16,
                color: DynamicColors.black,
              )..copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // 2. CONTENT AREA
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SAVE BUTTON (Right Aligned)
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    height: 32,
                    width: 80,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: Center(
                      child: Text(
                        "Save",
                        style: mozillaTextRegularText(
                          fontSize: 12,
                          color: DynamicColors.whiteClr,
                        ),
                      ),
                    ),
                    onTap: () {
                      print("Saved Colors Data: BG: $bgColors, FG: $fgColors");
                      Get.back();
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ---------- TABLE STRUCTURE ----------
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      // Table Headers
                      Container(
                        color: Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  "PAYMENT TYPE",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  "BACKGROUND COLOR",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  "FOREGROUND COLOR",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.grey),

                      // StatefuleBuilder lagaya hai taake color selection real-time refresh ho 🔴
                      StatefulBuilder(
                          builder: (context, dialogState) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paymentTypes.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Column 1: Payment Type Text
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            paymentTypes[index],
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),

                                      // Column 2: Background Color Picker Widget
                                      Expanded(
                                        flex: 4,
                                        child: Center(
                                          child: ColorPickerWidget(
                                            width: 110,
                                            pickerColor: bgColors[index]!,
                                            onColorChanged: (color) {
                                              dialogState(() {
                                                bgColors[index] = color;
                                              });
                                            },
                                            onColorSelected: (color) {
                                              dialogState(() {
                                                bgColors[index] = color;
                                              });
                                            },
                                            borderColor: DynamicColors.gryClr,
                                          ),
                                        ),
                                      ),

                                      // Column 3: Foreground Color Picker Widget
                                      Expanded(
                                        flex: 4,
                                        child: Center(
                                          child: ColorPickerWidget(
                                            width: 110,
                                            pickerColor: fgColors[index]!,
                                            onColorChanged: (color) {
                                              dialogState(() {
                                                fgColors[index] = color;
                                              });
                                            },
                                            onColorSelected: (color) {
                                              dialogState(() {
                                                fgColors[index] = color;
                                              });
                                            },
                                            borderColor: DynamicColors.gryClr,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}