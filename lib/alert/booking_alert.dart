import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingAlert {
  static void showNoBookingAlert() {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.only(top: 20),
      snackStyle: SnackStyle.FLOATING,
      messageText: Center(
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade300, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "No bookings found for the selected date range",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
