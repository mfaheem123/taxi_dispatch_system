
import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              width: 450, // Fixed width for better look
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
                        "STRIPE PAYMENT",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 15),

                  // Amount and Radio Row
                  Row(
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
                      const Text("SMS", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      const Text("EMAIL", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Mobile Field and Generate Link Button
                  Row(
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
                          child: const Text("GENERATE LINK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Divider(),

                  // Bottom Send Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {
                        // Your send logic here
                      },
                      child: const Text("SEND", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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


