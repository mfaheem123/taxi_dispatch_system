import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showDriverInfoAlert() {
  Get.dialog(
    DriverInfoAlert(),
    barrierColor: Colors.black54,
  );
}

class DriverInfoAlert extends StatefulWidget {
  const DriverInfoAlert({super.key});

  @override
  State<DriverInfoAlert> createState() => _DriverInfoAlertState();
}

class _DriverInfoAlertState extends State<DriverInfoAlert> {
  // Dropdown selected value
  String? selectedDriver = "26 PAUL DOUBLEDAY";

  // Dummy driver list for dropdown
  final List<String> driverList = [
    "26 PAUL DOUBLEDAY",
    "27 RICHARD HARDWICK",
    "28 JOHN DOE",
    "29 ALI KHAN",
    "30 DAVID SMITH",
    "31 JAMES WILSON",
    "32 MARK TAYLOR",
    "33 STEVE BROWN",
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 650,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Header ───
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    AppText.driverInfo,
                    style: mozillaTextSemiBoldText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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

            // ─── Body ───
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // ─── Dropdown + Status Row ───
                  Row(
                    children: [
                      // Driver Dropdown
                      Expanded(
                        child: Container(
                          height: 42,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedDriver,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                              style: mozillaTextSemiBoldText(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              items: driverList.map((String driver) {
                                return DropdownMenuItem<String>(
                                  value: driver,
                                  child: Text(
                                    driver,
                                    style: mozillaTextSemiBoldText(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedDriver = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),

                      // Logged In Status
                      Text(
                        "LOGGED IN",
                        style: mozillaTextSemiBoldText(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: DynamicColors.redClr,
                        ),
                      ),
                      SizedBox(width: 12),

                      // Force Logout Button
                      CustomButton(
                        onTap: () {
                          // Force logout action
                        },
                        width: 130,
                        height: 38,
                        btnText: "FORCE LOGOUT",
                        btnColor: DynamicColors.redClr,
                        borderRadius: 4,
                        verticalPadding: 0.0,
                        fontSize: 12,
                        style: mozillaTextSemiBoldText(
                          fontSize: 12,
                          color: DynamicColors.whiteClr,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // ─── Vehicle Info & Driver Info Cards ───
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Vehicle Info Card ───
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card Header
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: Text(
                                  "VEHICLE INFO",
                                  style: mozillaTextSemiBoldText(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: DynamicColors.primaryClr,
                                  ),
                                ),
                              ),
                              // Card Body
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow("VEHICLE #:", "-"),
                                    SizedBox(height: 14),
                                    _buildInfoRow("MAKE:", "-"),
                                    SizedBox(height: 14),
                                    _buildInfoRow("MODEL:", "-"),
                                    SizedBox(height: 14),
                                    _buildInfoRow("TYPE:", "SALOON"),
                                    SizedBox(height: 14),
                                    _buildInfoRow("COLOR:", "-"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 16),

                      // ─── Driver Info Card ───
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: DynamicColors.primaryClr.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card Header
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: DynamicColors.primaryClr.withOpacity(0.4)),
                                  ),
                                ),
                                child: Text(
                                  "DRIVER INFO",
                                  style: mozillaTextSemiBoldText(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              // Card Body
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Mobile # with call button
                                    Row(
                                      children: [
                                        Text(
                                          "MOBILE #: ",
                                          style: mozillaTextSemiBoldText(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "0777777777777",
                                          style: mozillaTextRegularText(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Spacer(),
                                        // Green call icon
                                        GestureDetector(
                                          onTap: () {
                                            // Call action
                                          },
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: DynamicColors.greenClr,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.phone,
                                              color: DynamicColors.whiteClr,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    _buildInfoRow("TELEPHONE #:", "-"),
                                    SizedBox(height: 14),
                                    _buildInfoRow("ADDRESS:", "-"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a label: value info row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: mozillaTextSemiBoldText(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 8),
        Text(
          value,
          style: mozillaTextRegularText(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
