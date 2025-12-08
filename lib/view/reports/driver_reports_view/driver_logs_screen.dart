

import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../controller/report_controller.dart';

class DriverLogsScreen extends StatefulWidget {
  const DriverLogsScreen({super.key});

  @override
  State<DriverLogsScreen> createState() => _DriverLogsScreenState();
}

class _DriverLogsScreenState extends State<DriverLogsScreen> {
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
    shortCutKeyValue.value = "driverLogsScreen";
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
                          "DRIVER LOG",
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

                      CustomTimePicker(
                        controller: controller.logStartTimeController, // optional
                        onTimeSelected: (time) {
                          setState(() {
                            print(controller.logStartTimeController.text);
                          });
                        },
                      ),



                      // buildFilterField(
                      //   hint: fromTime == null
                      //       ? "--:--"
                      //       : "${fromTime!.hour}:${fromTime!.minute.toString()
                      //       .padLeft(2, '0')}",
                      //   icon: Icons.access_time,
                      //   onTap: () => _pickTime(context, true),
                      // ),

                      buildFilterField(
                        hint: toDate == null
                            ? "To Date"
                            : "${toDate!.day}/${toDate!.month}/${toDate!.year}",
                        icon: Icons.calendar_today,
                        onTap: () => _pickDate(context, false),
                      ),
                      CustomTimePicker(
                        controller: controller.logEndTimeController, // optional
                        onTimeSelected: (time) {
                          setState(() {
                            print(controller.logEndTimeController.text);
                          });
                        },
                      ),

                      // buildFilterField(
                      //   hint: toTime == null
                      //       ? "--:--"
                      //       : "${toTime!.hour}:${toTime!.minute.toString()
                      //       .padLeft(2, '0')}",
                      //   icon: Icons.access_time,
                      //   onTap: () => _pickTime(context, false),
                      // ),

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

                      CustomButton(
                        height: 35,
                        width: 80,
                        verticalPadding: 0.0,
                        borderRadius: 4,
                        widget: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                          child:  Text(
                            AppText.filter,
                            style: mozillaTextRegularText(
                                fontSize: 12, color: DynamicColors.whiteClr),
                          ),
                        ),
                      ),
                      CustomButton(
                        height: 35,
                        width: 80,
                        verticalPadding: 0.0,
                        borderRadius: 4,
                        widget: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                          child:  Text(
                            AppText.view,
                            style: mozillaTextRegularText(
                                fontSize: 12, color: DynamicColors.whiteClr),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(title: "REF #"),
                          buildHeaderWithSearch(title: "DATETIME"),
                          buildHeaderWithSearch(title: "VEHICLE"),
                          buildHeaderWithSearch(title: "PICKUP"),
                          buildHeaderWithSearch(title: "DROPOFF"),
                          buildHeaderWithSearch(title: "FARES"),
                        ],
                        totalRow: totalRows,
                        cells: [
                          const DataCell(Center(child: Text("driver"))),
                          const DataCell(Center(child: Text("bookings"))),
                          const DataCell(Center(child: Text("loginDate"))),
                          const DataCell(Center(child: Text("loginTime"))),
                          const DataCell(Center(child: Text("logoutDate"))),
                          const DataCell(Center(child: Text("logoutTime"))),
                        ],
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