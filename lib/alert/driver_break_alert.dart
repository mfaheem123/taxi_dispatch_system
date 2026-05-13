import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

class DriverActionAlert extends StatelessWidget {
  final String driverName;
  final String driverUsername;
  final String driverMobile;
  final String driverID;

   DriverActionAlert({
    super.key,
    required this.driverName,
    required this.driverUsername,
    required this.driverMobile,
    required this.driverID,
  });
  DashboardController controller =Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Bar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: DynamicColors.primaryClr,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "☕ BREAK REQUEST",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                const Icon(Icons.coffee_rounded, color: Colors.brown, size: 60),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "DRIVER ",
                          style: mozillaTextSemiBoldText(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                          children: [
                            TextSpan(
                              text: "($driverName)",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: DynamicColors.primaryClr),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "wants to take a short break.",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      ),
                    ],
                  ),
                ),

                // Driver Details
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.badge_outlined, size: 18, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text("Username: ", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                          Text(driverUsername,style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone_android, size: 18, color: Colors.green),
                          const SizedBox(width: 10),
                          Text("Contact: ", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                          Text(driverMobile,style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Divider(height: 1),

                // Action Buttons
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
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            onTap: () {
                              controller.breakReject(driverID, "Rejected");
                            }
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: CustomButton(
                          height: 48,
                          btnText: "APPROVE",
                          btnColor: DynamicColors.primaryClr,
                          borderRadius: 8,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          onTap: () {
                            controller.breakACCEPT(driverID, "Accepted");
                          }
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
    );
  }
}