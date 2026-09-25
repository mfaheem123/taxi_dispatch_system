import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../component/alert_close_button.dart';

class ResendEmailAlert extends StatelessWidget {
  const ResendEmailAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RESEND EMAIL",
                    style: titleDesign(),
                  ),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(999),
                    child: const AlertCloseButton(),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),
            SizedBox(height: 15),

             Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Text(
                "ARE YOU SURE YOU WANT TO RESEND CONFIRMATION EMAIL?",
                textAlign: TextAlign.center,
                style: outFitRegular(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87),
              ),
            ),

            const Divider(height: 1),
            SizedBox(height: 15),


            // Buttons
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () => Get.back(),
                    child: Text("NO",
                        style: mozillaTextSemiBoldText(
                            fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DynamicColors.primaryClr,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("YES",
                        style: mozillaTextSemiBoldText(
                            fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResendSms extends StatefulWidget {
  final dynamic bookingItem;
  final Function(List<String> numbers)? onSend;

  const ResendSms({super.key, this.bookingItem, this.onSend});

  @override
  State<ResendSms> createState() => _ResendSmsState();
}

class _ResendSmsState extends State<ResendSms> {
  bool isMainCustomerSelected = true;
  final TextEditingController customNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final String customerName = (widget.bookingItem?.name != null && widget.bookingItem!.name!.isNotEmpty)
        ? widget.bookingItem!.name!
        : "N/A";

    final String customerPhone = (widget.bookingItem?.mobile != null && widget.bookingItem!.mobile!.isNotEmpty)
        ? widget.bookingItem!.mobile!
        // : ((widget.bookingItem?.telephone != null && widget.bookingItem!.telephone!.isNotEmpty)
        // ? widget.bookingItem!.telephone!
        : "N/A";
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RESEND SMS",
                    style: titleDesign()
                  ),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(999),
                    child: const AlertCloseButton(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SELECT MOBILE NUMBERS TO RECEIVE THE CONFIRMATION SMS.",
                    style: outFitRegular(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),

                  InkWell(
                    onTap: () {
                      setState(() {
                        isMainCustomerSelected = !isMainCustomerSelected;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              value: isMainCustomerSelected,
                              activeColor: DynamicColors.primaryClr,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  isMainCustomerSelected = val ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: outFitRegular(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                children: [
                                  const TextSpan(text: "MAIN: "),
                                  TextSpan(
                                    text: customerName.toUpperCase(),
                                  ),
                                  TextSpan(
                                    text: " ($customerPhone)",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Custom Number Input Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: customNumberController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "PRESS ENTER TO ADD CUSTOM NUMBER",
                        hintStyle: outFitRegular(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Footer (SEND Button)
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DynamicColors.primaryClr,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      List<String> selectedNumbers = [];
                      if (isMainCustomerSelected && customerPhone != "N/A" && customerPhone.isNotEmpty) {
                        selectedNumbers.add(customerPhone);
                      }
                      if (customNumberController.text.trim().isNotEmpty) {
                        selectedNumbers.add(customNumberController.text.trim());
                      }

                      if (widget.onSend != null) {
                        widget.onSend!(selectedNumbers);
                      }

                      Get.back();
                    },
                    child: Text(
                      "SEND",
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
