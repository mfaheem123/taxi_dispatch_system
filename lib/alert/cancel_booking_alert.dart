import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../controller/fob_controller.dart';

class CancelBookingRequest extends StatefulWidget {
  final dynamic bookingItem;
  final dynamic bookingId;
  const CancelBookingRequest({super.key, this.bookingItem, this.bookingId});

  @override
  State<CancelBookingRequest> createState() => _CancelBookingRequestState();
}

class _CancelBookingRequestState extends State<CancelBookingRequest> {
  final controller = Get.put(FobController());
  final TextEditingController reasonController = TextEditingController();

  final List<String> reasons = [
    "CHANGE OF MIND",
    "CHANGE IN PLAN",
    "DUPLICATE BOOKING",
    "NOT NEEDED ANYMORE",
    "GUEST STAYING AT HOME"
  ];

  String? focusedReason;

  void onReasonSelected(String reason) {
    setState(() {
      reasonController.text = reason;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 650,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "CANCEL BOOKING REQUEST ${widget.bookingItem?.referenceNumber ?? "N/A"}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, size: 24, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Divider(),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "SELECT CANCELLATION REASON",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                          letterSpacing: 1.1
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: reasons.map((reason) {
                        final bool isSelected = reasonController.text == reason;
                        final bool isFocused = focusedReason == reason;

                        final bool isActive = isSelected || isFocused;

                        return InkWell(
                          onTap: () => onReasonSelected(reason),
                          onFocusChange: (hasFocus) {
                            setState(() {
                              if (hasFocus) {
                                focusedReason = reason;
                              } else if (focusedReason == reason) {
                                focusedReason = null;
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: DynamicColors.primaryClr),
                              color: isActive ? DynamicColors.primaryClr : Colors.transparent
                              // color: Colors.transparent,
                            ),
                            child: Text(
                              reason,
                              style: TextStyle(
                                color: isActive ? Colors.white : DynamicColors.primaryClr,
                                // color: DynamicColors.primaryClr,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "OTHER DETAILS / REASON",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey,
                          letterSpacing: 1.1
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: reasonController,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 14),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [UpperCaseTextFormatter()],
                      decoration: InputDecoration(
                        hintText: "TYPE SPECIFIC REASON HERE...",
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          width: 100,
                          height: 35,
                          btnText: "BACK",
                          btnColor: Colors.grey,
                          verticalPadding: 0.0,
                          borderRadius: 6,
                          onTap: () => Get.back(),
                          style: mozillaTextSemiBoldText(fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 15),
                        CustomButton(
                          width: 220,
                          height: 40,
                          btnText: "CONFIRM CANCELLATION",
                          btnColor: DynamicColors.primaryClr,
                          verticalPadding: 0.0,
                          borderRadius: 8,
                          onTap: () {
                            if (reasonController.text.trim().isEmpty) {
                              BotToast.showText(text: "PLEASE PROVIDE A REASON");
                              return;
                            }

                            Get.defaultDialog(
                              title: "CONFIRMATION",
                              titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              middleText: "ARE YOU SURE YOU WANT TO CANCEL THIS BOOKING?",
                              backgroundColor: Colors.white,
                              radius: 8,

                              textCancel: "NO",
                              cancelTextColor: Colors.black54,
                              onCancel: () => Get.back(),

                              textConfirm: "YES",
                              confirmTextColor: Colors.white,
                              buttonColor: DynamicColors.primaryClr,
                              onConfirm: () {
                                Get.back();
                                
                                controller.postCancelBooking(widget.bookingId);
                              }
                            );
                          },
                          style: mozillaTextSemiBoldText(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}