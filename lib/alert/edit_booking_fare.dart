import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/textStyle.dart';
import '../controller/fob_controller.dart';

class EditBookingFare extends StatefulWidget {
  final dynamic bookingItem;
  final dynamic bookingId;
  const EditBookingFare({super.key, this.bookingItem, this.bookingId});

  @override
  State<EditBookingFare> createState() => _EditBookingFareState();
}

class _EditBookingFareState extends State<EditBookingFare> {
  final TextEditingController fareController = TextEditingController();
  final controller = Get.put(FobController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
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
                  Icon(Icons.currency_pound_sharp, color: DynamicColors.primaryClr),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      style: mozillaTextSemiBoldText(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        const TextSpan(text: "EDIT BOOKING FARE ("),
                        TextSpan(
                          text: widget.bookingItem?.referenceNumber ?? "N/A",
                          style: TextStyle(color: DynamicColors.primaryClr, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ")"),
                      ],
                    ),
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
            SizedBox(height: 20),

            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("DRIVER FARE (£)",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: fareController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: InputDecoration(
                      hintText: "0.00",
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),
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
                    btnColor: Colors.grey.shade300,
                    borderRadius: 4,
                    style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold
                    ),
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.updateBookingFare(widget.bookingId, fareController.text);
                    },
                    icon: const Icon(Icons.save, size: 16),
                    label: Text(
                      "UPDATE FARE",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DynamicColors.primaryClr,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
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
