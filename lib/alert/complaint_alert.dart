import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard_new1/component/textStyle.dart';

import '../component/alert_close_button.dart';
import '../component/color.dart';

class ComplaintAlert {
  static void show() {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 1000,
            constraints: BoxConstraints(
              minHeight: 200,
              maxHeight: Get.height * 0.8,
            ),
            // padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Row(
                  children: [
                    Text(
                      "COMPLAINTS",
                      style: mozillaTextSemiBoldText(
                          fontSize: 16, color: Colors.black),
                    ),
                    const Spacer(),
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(999),
                      child: const AlertCloseButton(),
                    ),
                  ],
                )),
                const SizedBox(height: 20),
                // Table
                Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      // Header
                      // Header Section
                      Container(
                        color: Colors.grey[50],
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              _buildHeaderCell("REF #", 1),
                              _buildHeaderCell("BOOKING #", 2),
                              _buildHeaderCell("COMPLAIN DATE", 2),
                              _buildHeaderCell("INCIDENT DATE", 2),
                              _buildHeaderCell("CUSTOMER", 2),
                              _buildHeaderCell("COMPLAINT", 3),
                              _buildHeaderCell("RESULT", 2, isLast: true),
                            ],
                          ),
                        ),
                      ),

                      const Divider(height: 1, thickness: 1),

                      // Data Row Section
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            _buildRowCell("DCC42", 1),
                            _buildRowCell("DCB75536", 2),
                            _buildRowCell("2026-06-10", 2),
                            _buildRowCell("2026-06-04", 2),
                            _buildRowCell("NADEEM", 2),
                            _buildRowCell("TEST COMPLAIN", 3),
                            _buildRowCell("TESTING", 2, isLast: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildHeaderCell(String text, int flex, {bool isLast = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(right: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: Text(
          text,
          style: mozillaTextSemiBoldText(fontSize: 12, color: Colors.black),
        ),
      ),
    );
  }

  static Widget _buildRowCell(String text, int flex, {bool isLast = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(right: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: Text(
          text,
          style: mozillaTextRegularText(fontSize: 12, color: Colors.black),
        ),
      ),
    );
  }
}
