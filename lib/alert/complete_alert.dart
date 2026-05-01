import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

void showCompleteBookingAlert() {
  Get.dialog(
    const CompleteBookingAlert(),
    barrierColor: Colors.black54,
  );
}

class CompleteBookingAlert extends StatelessWidget {
  const CompleteBookingAlert({super.key});

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 550,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    "COMPLETE BOOKING",
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
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SELECT DRIVER",
                    style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: "25 GEORGE HAMPTON",
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: ["25 GEORGE HAMPTON", "OTHER DRIVER"]
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: mozillaTextSemiBoldText(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {},
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
                    btnText: "BACK",
                    btnColor: const Color(0xFFEEEEEE),
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
                    btnText: "COMPLETE BOOKING",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    onTap: () {},
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