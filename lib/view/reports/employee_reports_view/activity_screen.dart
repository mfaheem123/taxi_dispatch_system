import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/view/reports/employee_reports_view/employee_activity_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int selectedRowIndex = 0;
  bool showTotalRow = false;
  final int totalRows = 5;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(initState: (state) {
      controller.clearDropdowns();
      controller.getEmployeeData();
    }, builder: (controller) {
        return LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isMobile = maxWidth < 600;
          final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

          // Instead of fixed width, we calculate flexible field widths
          final double fieldWidth = isMobile
              ? maxWidth // full width
              : isTablet
              ? maxWidth / 2
              : maxWidth / 4;

          return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 16,
                    children: [
                      Text(
                        AppText.employeeActivity,
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(width: 10),
                      CustomDropdownField<dynamic>(
                        width: fieldWidth / 1.5,
                        label: AppText.selectEmployee,
                        items: controller.userModel?.employees ?? [],
                        value: controller.apiSelectedEmployee,
                        itemLabel: (val) =>
                            (val.username ?? "").toUpperCase(),
                        onChanged: (val) {
                          controller.apiSelectedEmployee = val;
                          controller.update();
                        },
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: "FROM:",
                        column: false,
                        width: fieldWidth / 2.2,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(
                            initialDate: controller.activityFromDate.value,
                            onChanged: (date) {
                              controller.activityFromDate.value = date;
                              controller.update();
                            },
                          ),
                        ),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: "",
                        column: false,
                        width: fieldWidth / 2.9,
                        child: CustomTimePicker(
                          controller: controller.activityStartTimeController,
                          onTimeSelected: (time) => setState(() {}),
                        ),
                      ),
                      // To Date
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: "TO:",
                        column: false,
                        width: fieldWidth / 2.2,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(
                            initialDate: controller.activityToDate.value,
                            onChanged: (date) {
                              controller.activityToDate.value = date;
                              controller.update();
                            },
                          ),
                        ),
                      ),

                      // End Time
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: "",
                        column: false,
                        width: fieldWidth / 2.9,
                        child: CustomTimePicker(
                          controller: controller.activityEndTimeController,
                          onTimeSelected: (time) => setState(() {}),
                        ),
                      ),
                      SizedBox(
                        width: maxWidth < 1366 ? 5 : 20,
                      ),
                      CustomButton(
                          width: maxWidth < 1366 ? 70 : 120,
                          height: 30,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          btnText: AppText.filter,
                          fontSize: 12,
                          onTap: () async {
                            await controller.getEmployeeActivity();
                            setState(() {
                              showTotalRow = controller.employeeActivityList.isNotEmpty;
                            });
                          }
                      ),
                      CustomButton(
                        width: maxWidth < 1366 ? 70 : 120,
                        height: 30,
                        borderRadius: 4,
                        verticalPadding: 0.0,
                        btnText: AppText.view,
                        fontSize: 12,
                        onTap: () {
                          Get.dialog(EmployeeActivityReportWindow());
                        },
                      ),
                    ],
                  ),
                  //         Container(
                  //           height: 15,
                  //       width: 15,
                  //       alignment: Alignment(15, 20),
                  //       clipBehavior: Clip.hardEdge,
                  //       constraints: BoxConstraints(),
                  //       color: Colors.grey,
                  //       decoration: BoxDecoration(),
                  //       foregroundDecoration: BoxDecoration(),
                  //       margin: EdgeInsets.only(left: 10
                  // ),
                  //
                  //       child: Text(""),
                  //     ),
                  SizedBox(
                    height: 50,
                  ),
                  controller.isLoadingActivity
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: "LOGIN DATETIME"),
                            buildHeaderWithSearch(title: "LOGOUT DATETIME"),
                            buildHeaderWithSearch(title: "BOOKINGS CREATED"),
                            buildHeaderWithSearch(title: "BOOKINGS DISPATCHED"),
                            buildHeaderWithSearch(title: "BOOKINGS CANCELLED"),
                            buildHeaderWithSearch(title: "CALLS ANSWERED"),
                            buildHeaderWithSearch(title: "WORKING HOURS", removeSearching: true),
                          ],
                          rows: [
                          ...controller.employeeActivityList.map((item) {

                            String formatDateTime(String? dateTimeStr) {
                              if (dateTimeStr == null || dateTimeStr.isEmpty) return "-";

                              DateTime? parsed = DateTime.tryParse(dateTimeStr);
                              if (parsed == null) return "-";

                              String date =
                                  "${parsed.day.toString().padLeft(2, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.year.toString().substring(2)}";

                              String time =
                                  "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}:${parsed.second.toString().padLeft(2, '0')}";

                              return "$date $time";
                            }

                            String rowWorkingHours = "-";

                            if (item.workingHours != null && item.workingHours!.isNotEmpty) {
                              double milliSeconds = double.tryParse(item.workingHours!) ?? 0;

                              double seconds = milliSeconds / 1000;
                              int hours = seconds ~/ 3600;
                              int minutes = ((seconds % 3600) ~/ 60).toInt();

                              if (hours > 0 && minutes > 0) {
                                rowWorkingHours = "$hours hours $minutes minutes";
                              } else if (hours > 0) {
                                rowWorkingHours = "$hours hours";
                              } else {
                                rowWorkingHours = "$minutes minutes";
                              }
                            }
                            return DataRow(cells: [
                              DataCell(Center(child: Text(formatDateTime(item.loginDatetime)))),
                              DataCell(Center(child: Text(formatDateTime(item.logoutDatetime)))),
                            DataCell(Center(child: Text((item.bookingsCreated ?? 0).toString()))),
                            DataCell(Center(child: Text((item.bookingsDispatched ?? 0).toString()))),
                            DataCell(Center(child: Text((item.bookingsCancelled ?? 0).toString()))),
                            DataCell(Center(child: Text((item.callsAnswered ?? 0).toString()))),
                            DataCell(Center(child: Text((rowWorkingHours).toUpperCase()))),
                            ]);
                          }).toList(),

                            if (showTotalRow)
                              DataRow(
                                color: WidgetStateProperty.all(Colors.grey.shade100),
                                cells: [
                                  const DataCell(Center(child: Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold)))),
                                  const DataCell(Center(child: Text(""))),
                                  DataCell(Center(child: Text(controller.totalCreated.toString(), style: const TextStyle(fontWeight: FontWeight.bold)))),
                                  DataCell(Center(child: Text(controller.totalDispatched.toString(), style: const TextStyle(fontWeight: FontWeight.bold)))),
                                  DataCell(Center(child: Text(controller.totalCancelled.toString(), style: const TextStyle(fontWeight: FontWeight.bold)))),
                                  DataCell(Center(child: Text(controller.totalCalls.toString(), style: const TextStyle(fontWeight: FontWeight.bold)))),
                                  DataCell(Center(child: Text((controller.totalWorkingHours).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)))),
                                ],
                              ),
                          ]),
                    ),
                  ),
                ],
              ));
        });
      }
    );
  }
}
