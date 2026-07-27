import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard_new1/component/textStyle.dart';

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
            padding: const EdgeInsets.all(20),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "COMPLAINTS",
                      style: mozillaTextSemiBoldText(
                          fontSize: 16, color: Colors.black),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, color: Colors.grey, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Table
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        color: Colors.grey[50], 
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        child: Row(
                          children: [
                            _buildHeaderCell("REF #", 1),
                            _buildHeaderCell("BOOKING #", 2),
                            _buildHeaderCell("COMPLAIN DATE", 2),
                            _buildHeaderCell("INCIDENT DATE", 2),
                            _buildHeaderCell("CUSTOMER", 2),
                            _buildHeaderCell("COMPLAINT", 3),
                            _buildHeaderCell("RESULT", 2),
                          ],
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      // Row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        child: Row(
                          children: [
                            _buildRowCell("DCC42", 1),
                            _buildRowCell("DCB75536", 2),
                            _buildRowCell("2026-06-10", 2),
                            _buildRowCell("2026-06-04", 2),
                            _buildRowCell("NADEEM", 2),
                            _buildRowCell("TEST COMPLAIN", 3),
                            _buildRowCell("TESTING", 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildHeaderCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: mozillaTextSemiBoldText(fontSize: 12, color: Colors.black),
      ),
    );
  }

  static Widget _buildRowCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: mozillaTextRegularText(fontSize: 12, color: Colors.black),
      ),
    );
  }
}
