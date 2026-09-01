import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/color.dart';

class DriverExpiryDocumentsAlert {
  static void show() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 1100, // Adjusted for 7 columns to fit comfortably
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DRIVER EXPIRY DOCUMENTS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DynamicColors.primaryClr,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Table
              Table(
                border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1.2),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1.2),
                  4: FlexColumnWidth(1.2),
                  5: FlexColumnWidth(1.2),
                  6: FlexColumnWidth(1.2),
                },
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(color: DynamicColors.primaryClr),
                    children: [
                      _headerCell("USERNAME"),
                      _headerCell("VEHICLE EXPIRY"),
                      _headerCell("DRIVER EXPIRY"),
                      _headerCell("MOT EXPIRY"),
                      _headerCell("MOT2 EXPIRY"),
                      _headerCell("INSURANCE EXPIRY"),
                      _headerCell("LICENSE EXPIRY"),
                    ],
                  ),
                  // Dummy Row 1
                  _buildRow("123", [
                    _DocData("19-05-2026 23:59", _DocState.expired),
                    _DocData("", _DocState.valid),
                    _DocData("", _DocState.valid),
                    _DocData("", _DocState.valid),
                    _DocData("", _DocState.valid),
                    _DocData("", _DocState.valid),
                  ]),
                  // Dummy Row 2
                  _buildRow("E01", [
                    _DocData("31-10-2024 14:59", _DocState.expired),
                    _DocData("31-10-2024 23:59", _DocState.expired),
                    _DocData("26-10-2024 23:59", _DocState.expired),
                    _DocData("29-09-2024 23:59", _DocState.expired),
                    _DocData("10-11-2024 23:59", _DocState.expired),
                    _DocData("03-11-2024 23:59", _DocState.expired),
                  ]),
                  // Dummy Row 3
                  _buildRow("S01", [
                    _DocData("17-07-2026 12:54", _DocState.warning),
                    _DocData("07-07-2025 12:54", _DocState.expired),
                    _DocData("27-02-2026 12:54", _DocState.expired),
                    _DocData("18-12-2027 12:54", _DocState.valid),
                    _DocData("08-07-2027 12:54", _DocState.valid),
                    _DocData("12-11-2026 12:55", _DocState.valid),
                  ]),
                  // Dummy Row 4
                  _buildRow("T02", [
                    _DocData("11-06-2026 14:56", _DocState.expired),
                    _DocData("13-10-2027 14:56", _DocState.valid),
                    _DocData("16-10-2026 14:56", _DocState.valid),
                    _DocData("06-03-2026 14:56", _DocState.expired),
                    _DocData("14-10-2027 14:56", _DocState.valid),
                    _DocData("01-03-2029 14:56", _DocState.valid),
                  ]),
                  // Dummy Row 5
                  _buildRow("T08", [
                    _DocData("21-12-2025 00:00", _DocState.expired),
                    _DocData("21-12-2025 00:00", _DocState.expired),
                    _DocData("21-12-2025 00:00", _DocState.expired),
                    _DocData("21-12-2025 00:00", _DocState.expired),
                    _DocData("21-12-2025 00:00", _DocState.expired),
                    _DocData("21-12-2025 00:00", _DocState.expired),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  static TableRow _buildRow(String username, List<_DocData> docs) {
    return TableRow(
      children: [
        _dataCell(username, _DocState.valid, isUsername: true),
        ...docs.map((d) => _dataCell(d.date, d.state)),
      ],
    );
  }

  static Widget _dataCell(String text, _DocState state, {bool isUsername = false}) {
    Color? bgColor;
    Color textColor = Colors.black;

    if (state == _DocState.expired) {
      bgColor = Colors.white;
      textColor = Colors.black;
    } else if (state == _DocState.warning) {
      bgColor = Colors.orange.shade400; // Warning/Soon color
      textColor = Colors.white;
    } else {
      bgColor = Colors.white;
      textColor = Colors.black;
    }

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isUsername ? FontWeight.bold : FontWeight.normal,
          color: textColor,
        ),
      ),
    );
  }
}

enum _DocState { valid, warning, expired }

class _DocData {
  final String date;
  final _DocState state;
  _DocData(this.date, this.state);
}