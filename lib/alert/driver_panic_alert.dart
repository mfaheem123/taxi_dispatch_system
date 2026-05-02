import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

void showDriverPanicAlert() {
  Get.dialog(
    const DriverPanicAlert(driverName: 'MARK',),
    barrierColor: Colors.black54,
  );
}

class DriverPanicAlert extends StatelessWidget {
  final String driverName;
  const DriverPanicAlert({super.key, required this.driverName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red.shade600,
              size: 50,
            ),

            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "DRIVER ($driverName)",
                textAlign: TextAlign.center,
                style: mozillaTextSemiBoldText(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "$driverName is in panic!",
                textAlign: TextAlign.center,
                style: mozillaTextSemiBoldText(
                  fontSize: 15,
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 25),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  height: 45,
                  width: 120,
                  btnText: "CLOSE",
                  btnColor: DynamicColors.primaryClr,
                  borderRadius: 8,
                  style: mozillaTextSemiBoldText(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () => Get.back(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}