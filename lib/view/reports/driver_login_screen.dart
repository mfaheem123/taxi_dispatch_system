import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../component/calender.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../drivers_view/controller/driver_controller.dart';
import 'controller/report_controller.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 15;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  // Date controllers
  DateTime? fromDate;
  DateTime? toDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverLogin";
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          selectedRowIndex = (selectedRowIndex + 1) % totalRows;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          selectedRowIndex = (selectedRowIndex - 1 + totalRows) % totalRows;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        debugPrint("Row $selectedRowIndex Enter Pressed (Filter/View)");
      }
    }
  }

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  Future<void> _pickTime(BuildContext context, bool isFrom) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromTime = picked;
        } else {
          toTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<ReportController>(builder: (controller) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: maxWidth < 600 ? double.infinity : 200,
                        child: Text(
                          "DRIVER LOGIN",
                          style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                        ),
                      ),

                      buildFilterField(
                        hint: fromDate == null
                            ? "From Date"
                            : "${fromDate!.day}/${fromDate!.month}/${fromDate!
                            .year}",
                        icon: Icons.calendar_today,
                        onTap: () => _pickDate(context, true),
                      ),

                      buildFilterField(
                        hint: fromTime == null
                            ? "--:--"
                            : "${fromTime!.hour}:${fromTime!.minute.toString()
                            .padLeft(2, '0')}",
                        icon: Icons.access_time,
                        onTap: () => _pickTime(context, true),
                      ),

                      buildFilterField(
                        hint: toDate == null
                            ? "To Date"
                            : "${toDate!.day}/${toDate!.month}/${toDate!.year}",
                        icon: Icons.calendar_today,
                        onTap: () => _pickDate(context, false),
                      ),

                      buildFilterField(
                        hint: toTime == null
                            ? "--:--"
                            : "${toTime!.hour}:${toTime!.minute.toString()
                            .padLeft(2, '0')}",
                        icon: Icons.access_time,
                        onTap: () => _pickTime(context, false),
                      ),

                      SizedBox(
                        width: maxWidth < 400 ? double.infinity : 180,
                        height: 40,
                        child: DropdownButtonFormField<String>(
                          value: "Select Driver",
                          items: const [
                            DropdownMenuItem(
                                value: "Select Driver",
                                child: Text("Select Driver")),
                            DropdownMenuItem(
                                value: "Nadeem", child: Text("Nadeem")),
                            DropdownMenuItem(
                                value: "Faheem", child: Text("Faheem")),
                            DropdownMenuItem(
                                value: "Shahzaib", child: Text("Shahzaib")),
                          ],
                          onChanged: (val) {},
                          decoration: const InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {
                            controller.applyFilters();
                          },
                          child: const Text("FILTER",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text("VIEW",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // DATATABLE
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                        dataRowMinHeight: 48,
                        dataRowMaxHeight: 56,
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        dataTextStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: DynamicColors.textClr.withOpacity(0.5)),
                        ),
                        columns: [
                          buildHeaderWithSearch(title: "DRIVER"),
                          buildHeaderWithSearch(title: "BOOKINGS"),
                          buildHeaderWithSearch(title: "LOGIN DATE"),
                          buildHeaderWithSearch(title: "LOGIN TIME"),
                          buildHeaderWithSearch(title: "LOGOUT DATE"),
                          buildHeaderWithSearch(title: "LOGOUT TIME"),
                        ],
                        rows: controller.filteredRows.map((row) {
                          return DataRow(cells: [
                            DataCell(Center(child: Text(row["driver"]))),
                            DataCell(Center(child: Text(row["bookings"].toString()))),
                            DataCell(Center(child: Text(row["loginDate"]))),
                            DataCell(Center(child: Text(row["loginTime"]))),
                            DataCell(Center(child: Text(row["logoutDate"]))),
                            DataCell(Center(child: Text(row["logoutTime"]))),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),

                ],
              ),
            );
          },
        );
      }),
    );
  }
}
Widget buildFilterField({
  required String hint,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return SizedBox(
    width: 140,
    height: 40,
    child: InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon, size: 18),
        ),
        child: Text(
          hint,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    ),
  );
}
