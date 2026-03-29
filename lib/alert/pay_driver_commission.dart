import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

class PayDriverCommission {
  static void show() {
    int paymentTypeGroup = 0;
    bool isCardFlashing = false;
    final amountController = TextEditingController();
    final balanceController = TextEditingController(text: "0.00");

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: 450,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "PAY DRIVER COMMISSION",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 15),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PAYMENT TYPE",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => paymentTypeGroup = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 12),
                          decoration: BoxDecoration(
                            color: DynamicColors.primaryClr,
                            border: Border.all(color: Colors.green),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Radio<int>(
                                  value: 0,
                                  groupValue: paymentTypeGroup,
                                  fillColor:
                                      WidgetStateProperty.all(Colors.white),
                                  onChanged: (int? v) =>
                                      setState(() => paymentTypeGroup = v!),
                                ),
                              ),
                              const Text("CASH",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            paymentTypeGroup = 1;
                            isCardFlashing = true;
                          });
                          await Future.delayed(
                              const Duration(milliseconds: 200));

                          setState(() {
                            isCardFlashing = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isCardFlashing ? DynamicColors.primaryClr : Colors.white,
                            border: Border.all(
                                color: isCardFlashing
                                    ? DynamicColors.primaryClr
                                    : Colors.grey.shade400),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Radio<int>(
                                  value: 1,
                                  groupValue: paymentTypeGroup,
                                  activeColor: isCardFlashing
                                      ? Colors.white
                                      : DynamicColors.primaryClr,
                                  onChanged: (int? v) =>
                                      setState(() => paymentTypeGroup = v!),
                                ),
                              ),
                              Text(
                                "CARD",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  // color: isCardFlashing ? Colors.white : (paymentTypeGroup == 1 ? Colors.green : Colors.black87),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("BALANCE",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700])),
                            const SizedBox(height: 5),
                            TextField(
                              controller: balanceController,
                              readOnly: true,
                              // showCursor: true,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: DynamicColors.primaryClr, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("AMOUNT",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700])),
                            const SizedBox(height: 5),
                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "£ 0.00",
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: DynamicColors.primaryClr, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        height: 35,
                        borderRadius: 6,
                        width: 80,
                        verticalPadding: 0.0,
                        btnText: "CANCEL",
                        btnColor: Colors.grey.shade200,
                        style: mozillaTextSemiBoldText(
                            fontSize: 13,
                            color: DynamicColors.primaryClr),
                        onTap: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        height: 35,
                        borderRadius: 6,
                        width: 80,
                        verticalPadding: 0.0,
                        btnText: "SAVE",
                        btnColor: DynamicColors.primaryClr,
                        style: mozillaTextSemiBoldText(
                            fontSize: 13,
                            color: DynamicColors.whiteClr),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
