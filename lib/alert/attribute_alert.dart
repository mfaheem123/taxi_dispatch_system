import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';

class AttributeAlert {
  static void show() {
    final List<Map<String, dynamic>> attributes = [
      {"id": 1, "name": "PET FRIENDLY", "code": "PF", "isSelected": false},
      {"id": 2, "name": "WHEEL CHAIR", "code": "WC", "isSelected": false},
    ];

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: DynamicColors.gryClr.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.local_offer,
                              color: DynamicColors.primaryClr, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "ATTRIBUTES",
                            style: mozillaTextSemiBoldText(
                                fontSize: 15, color: DynamicColors.textClr),
                          ),
                          const Spacer(),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 15),

                    // Table Header & Rows
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child:  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Column(
                          children: [
                            // Header Row
                            Container(
                              height: 38,
                              color: const Color(0xFFF8FAFC),
                              child: Row(
                                children: [
                                  _buildCell("#", width: 45, isHeader: true),
                                  _buildCell("ATTRIBUTE NAME", flex: 3, isHeader: true),
                                  _buildCell("SHORT CODE", flex: 3, isHeader: true),
                                  _buildCell("ACTION", width: 70, isHeader: true, showRightBorder: false, centerAlign: true),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Color(0xFFE2E8F0)),

                            // Table Rows
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: attributes.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
                              itemBuilder: (context, index) {
                                final item = attributes[index];
                                return SizedBox(
                                  height: 40,
                                  child: Row(
                                    children: [
                                      _buildCell("${item['id']}", width: 45),
                                      _buildCell(item['name'], flex: 3),
                                      _buildCell(item['code'], flex: 3),
                                      // Action Checkbox Cell
                                      SizedBox(
                                        width: 70,
                                        child: Center(
                                          child: Transform.scale(
                                            scale: 0.8,
                                            child: Checkbox(
                                              value: item['isSelected'],
                                              shape: const CircleBorder(),
                                              activeColor: DynamicColors.primaryClr,
                                              side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                                              onChanged: (val) {
                                                setState(() {
                                                  item['isSelected'] = val ?? false;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),

                    // Footer
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomButton(
                                width: 80,
                                height: 28,
                                verticalPadding: 0.0,
                                btnText: "CLOSE",
                                btnColor: Colors.red,
                                borderRadius: 4,
                                style: mozillaTextSemiBoldText(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                onTap: () => Get.back(),
                              )])),

                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildCell(
      String text, {
        double? width,
        int flex = 1,
        bool isHeader = false,
        bool showRightBorder = true,
        bool centerAlign = false,
      }) {
    final cellChild = Container(
      decoration: BoxDecoration(
        border: showRightBorder
            ? const Border(right: BorderSide(color: Color(0xFFE2E8F0), width: 1))
            : null,
      ),
      alignment: centerAlign ? Alignment.center : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: outFitRegular(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: cellChild);
    }
    return Expanded(flex: flex, child: cellChild);
  }
}