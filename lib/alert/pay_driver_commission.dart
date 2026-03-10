import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayDriverCommission {
  static void show() {
    int stripRadio = 0;
    int paymentTypeGroup = 0;

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
                    children: [
                      // Cash Option
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => paymentTypeGroup = 0),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: paymentTypeGroup == 0
                                  ? Colors.green
                                  : Colors.transparent,
                              border: Border.all(
                                color: paymentTypeGroup == 0
                                    ? Colors.green
                                    : Colors.grey.shade400,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0,
                                  groupValue: paymentTypeGroup,
                                  activeColor: Colors.white,
                                  onChanged: (int? v) =>
                                      setState(() => paymentTypeGroup = v!),
                                ),
                                Text(
                                  "CASH",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: paymentTypeGroup == 0
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Card Option
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => paymentTypeGroup = 1),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: paymentTypeGroup == 1
                                  ? Colors.green
                                  : Colors.transparent,
                              border: Border.all(
                                color: paymentTypeGroup == 1
                                    ? Colors.green
                                    : Colors.grey.shade400,
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: paymentTypeGroup,
                                  activeColor: Colors.white,
                                  onChanged: (int? v) =>
                                      setState(() => paymentTypeGroup = v!),
                                ),
                                Text(
                                  "CARD",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: paymentTypeGroup == 1
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 30),
                  const Divider(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text("SAVE",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
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
