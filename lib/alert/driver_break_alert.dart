import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

void showDriverActionAlert() {
  Get.dialog(
    const DriverActionAlert(driverName: "25 GEORGE HAMPTON"),
    barrierColor: Colors.black54,
  );
}

class DriverActionAlert extends StatelessWidget {
  final String driverName;
  const DriverActionAlert({super.key, required this.driverName});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF5AB65B);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 480,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "DRIVER ",
                  style: mozillaTextSemiBoldText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                  ),
                  children: [
                    TextSpan(
                      text: "($driverName)",
                      style: mozillaTextSemiBoldText(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 45,
                      btnText: "REJECT",
                      btnColor: Colors.red,
                      borderRadius: 8,
                      style: mozillaTextSemiBoldText(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 15),
                  // ACCEPT Button
                  Expanded(
                    child: CustomButton(
                      height: 45,
                      btnText: "ACCEPT",
                      btnColor: DynamicColors.primaryClr,
                      borderRadius: 8,
                      style: mozillaTextSemiBoldText(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      onTap: () {},
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