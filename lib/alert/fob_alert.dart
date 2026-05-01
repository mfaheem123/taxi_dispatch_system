import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

void showDispatchFob() {
  Get.dialog(
    const DispatchFobAlert(),
    barrierColor: Colors.black54,
  );
}

class DispatchFobAlert extends StatelessWidget {
  const DispatchFobAlert({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF5AB65B);
    const lightGreyBg = Color(0xFFF8F9FA);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 850,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "DISPATCH FOB ",
                      style: mozillaTextSemiBoldText(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "(DCB75402)",
                          style: mozillaTextSemiBoldText(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.person_search, color: Colors.black54),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SELECT DRIVER TO DISPATCH",
                                style: mozillaTextSemiBoldText(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text("CHOOSE A DRIVER, THEN PRESS DISPATCH.",
                                style: mozillaTextRegularText(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const Spacer(),
                        CustomButton(
                          width: 165, height: 35, verticalPadding: 0.0, borderRadius: 4,
                          btnText: "CALCULATE DISTANCE",
                          style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.white),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: lightGreyBg,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                          child: Row(
                            children: [
                              _buildHeaderCell(Icons.badge_outlined, "ID", 1),
                              _buildHeaderCell(Icons.person_outline, "DRIVER", 3),
                              _buildHeaderCell(Icons.sell_outlined, "ATTRIBUTES", 2),
                              _buildHeaderCell(Icons.bar_chart, "STATUS", 2),
                              _buildHeaderCell(Icons.bolt, "ACTION", 2),
                            ],
                          ),
                        ),
                        _buildDataRow(["101", "Test Driver 1", "-", "ONLINE"], primaryGreen),
                        _buildDataRow(["102", "Test Driver 2", "-", "ONLINE"], primaryGreen),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  width: 100, height: 35, btnText: "CLOSE",
                  btnColor: const Color(0xFFF2F4F7),
                  verticalPadding: 0.0, borderRadius: 6,
                  onTap: () => Get.back(),
                  style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(IconData icon, String label, int flex) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Text(label, style: mozillaTextSemiBoldText(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDataRow(List<String> data, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Center(child: Text(data[0]))),
          Expanded(flex: 3, child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(data[1]),
          )),
          Expanded(flex: 2, child: Center(child: Text(data[2]))),
          Expanded(flex: 2, child: Center(child: Text(data[3], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)))),
          Expanded(
            flex: 2,
            child: Center(
              child: CustomButton(
                width: 80, height: 28, verticalPadding: 0.0, borderRadius: 4,
                btnText: "DISPATCH",
                style: const TextStyle(color: Colors.white, fontSize: 11),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}