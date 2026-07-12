import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void showDriverEarningsAlert() {
  Get.dialog(
    DriverEarningsAlert(),
    barrierColor: Colors.black54,
  );
}

class DriverEarningsAlert extends StatefulWidget {
  const DriverEarningsAlert({super.key});

  @override
  State<DriverEarningsAlert> createState() => _DriverEarningsAlertState();
}

class _DriverEarningsAlertState extends State<DriverEarningsAlert> {
  // Date controllers
  DateTime fromDate = DateTime(2026, 1, 5);
  DateTime toDate = DateTime(2026, 9, 7);

  // Dropdown selected value
  String? selectedDriver = "26 PAUL DOUBLEDAY";

  // Dummy driver list
  final List<String> driverList = [
    "26 PAUL DOUBLEDAY",
    "27 RICHARD HARDWICK",
    "28 JOHN DOE",
    "29 ALI KHAN",
    "30 DAVID SMITH",
  ];

  // Date format
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 700,
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
                    AppText.driverEarning,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Filter Row ───
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // FROM Date
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppText.from,
                              style: mozillaTextSemiBoldText(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => _pickDate(context, true),
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _dateFormat.format(fromDate),
                                      style: mozillaTextRegularText(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.calendar_today_outlined,
                                        size: 16, color: Colors.grey.shade600),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),

                      // TO Date
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppText.to,
                              style: mozillaTextSemiBoldText(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => _pickDate(context, false),
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _dateFormat.format(toDate),
                                      style: mozillaTextRegularText(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.calendar_today_outlined,
                                        size: 16, color: Colors.grey.shade600),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),

                      // DRIVERS Dropdown
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppText.drivers.toString().toUpperCase(),
                              style: mozillaTextSemiBoldText(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedDriver,
                                  isExpanded: true,
                                  isDense: true,
                                  icon: Icon(Icons.arrow_drop_down,
                                      size: 20, color: Colors.grey.shade600),
                                  style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                  items: driverList.map((String driver) {
                                    return DropdownMenuItem<String>(
                                      value: driver,
                                      child: Text(
                                        driver,
                                        style: mozillaTextRegularText(
                                          fontSize: 13,
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
                          ],
                        ),
                      ),
                      SizedBox(width: 12),

                      // VIEW Button
                      CustomButton(
                        onTap: () {
                          // View action
                        },
                        width: 70,
                        height: 40,
                        btnText: AppText.view,
                        btnColor: DynamicColors.greenClr,
                        borderRadius: 4,
                        verticalPadding: 0.0,
                        style: mozillaTextSemiBoldText(
                          fontSize: 12,
                          color: DynamicColors.whiteClr,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),

                      // CLEAR Button
                      CustomButton(
                        onTap: () {
                          // Clear action
                        },
                        width: 70,
                        height: 40,
                        btnText: AppText.clear,
                        btnColor: DynamicColors.greenClr,
                        borderRadius: 4,
                        verticalPadding: 0.0,
                        style: mozillaTextSemiBoldText(
                          fontSize: 12,
                          color: DynamicColors.whiteClr,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // ─── Data Table ───
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowHeight: 45,
                      columnSpacing: 20,
                      headingRowColor: WidgetStateProperty.all(
                          DynamicColors.gryClr.withOpacity(0.3)),
                      border: TableBorder.all(
                          color: Colors.grey.shade300, width: 1),
                      columns: [
                        _buildDataColumn(AppText.drivers.toString().toUpperCase()),
                        _buildDataColumn("TOTAL BOOKINGS"),
                        _buildDataColumn("TOTAL EARNINGS"),
                        _buildDataColumn(""),
                      ],
                      rows: [
                        _buildEarningsRow("26", "15", "£63.20"),
                      ],
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

  DataRow _buildEarningsRow(String driver, String bookings, String earnings) {
    return DataRow(cells: [
      DataCell(Text(driver,
          style: mozillaTextRegularText(fontSize: 13, color: Colors.black87))),
      DataCell(Text(bookings,
          style: mozillaTextRegularText(fontSize: 13, color: Colors.black87))),
      DataCell(Text(earnings,
          style: mozillaTextRegularText(fontSize: 13, color: Colors.black87))),
      DataCell(
        CustomButton(
          onTap: () {
            // Bookings detail action
          },
          width: 100,
          height: 32,
          btnText: "BOOKINGS",
          btnColor: DynamicColors.primaryClr,
          borderRadius: 4,
          verticalPadding: 0.0,
          style: mozillaTextSemiBoldText(
            fontSize: 11,
            color: DynamicColors.whiteClr,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ]);
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(label,
          style: mozillaTextSemiBoldText(
              fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}
