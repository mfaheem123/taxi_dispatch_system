import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessAlert {
  static void show(String message) {
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
              color: Colors.white,
              border: Border.all(color: Colors.green.shade300, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.green,
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
