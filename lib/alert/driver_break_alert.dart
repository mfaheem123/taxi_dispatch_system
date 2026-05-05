import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../controller/driver_alert_controller.dart';

void showDriverActionAlert(int id) {
  final controller = Get.put(DriverAlertController());
  controller.getDriverById(id);

  Get.dialog(
    DriverActionAlert(),
    barrierColor: Colors.black54,
  );
}

class DriverActionAlert extends StatelessWidget {
   DriverActionAlert({super.key});
  final controller = Get.find<DriverAlertController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.1),
        //       blurRadius: 10,
        //       spreadRadius: 2,
        //     ),
        //   ],
        // ),
            child: Obx(() {
              if (controller.isDriverLoading.value) {
                return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator())
                );
              }

              String name = controller.driverData.value?.name ?? "Unknown";
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30, left: 20, right: 20, bottom: 10),
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
                            text: "($name)",
                            style: mozillaTextSemiBoldText(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: DynamicColors.primaryClr
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 25, left: 20, right: 20),
                    child: Text(
                      "WANTS TO TAKE A BREAK",
                      textAlign: TextAlign.center,
                      style: mozillaTextSemiBoldText(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Divider(height: 1, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 48,
                            btnText: "REJECT",
                            btnColor: Colors.red.shade600,
                            borderRadius: 8,
                            style: mozillaTextSemiBoldText(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                            onTap: () => Get.back(),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomButton(
                            height: 48,
                            btnText: "ACCEPT",
                            btnColor: DynamicColors.primaryClr,
                            borderRadius: 8,
                            style: mozillaTextSemiBoldText(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}