import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

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
            Padding(
                padding: EdgeInsetsGeometry.all(16.0),
              child: Row(
                children: [
                  Text(
                    "EDIT BOOKING FARE ${widget.bookingItem?.referenceNumber ?? "N/A"}",
                    style: mozillaTextSemiBoldText(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 22, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
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
                    btnColor: Colors.grey,
                    borderRadius: 4,
                    style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold
                    ),
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                      width: 180, height: 28, verticalPadding: 0.0, borderRadius: 4,
                      btnText: "UPDATE FARE",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onTap: () {
                        controller.updateBookingFare(widget.bookingId, fareController.text);
                      }
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
