import 'package:dashboard_new1/component/textStyle.dart';
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

  final String totalBookingsCreated = "150";
  final String totalBookingsDispatched = "120";
  final String totalBookingsCancelled = "10";
  final String totalCallsAnswered = "250";
  final String totalWorkingHours = "45 hrs";

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (controller) {
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
                    CustomDropdownField<String>(
                      width: fieldWidth / 1.5,
                      label: AppText.selectEmployee,
                      items: [
                        "Employee 1",
                        "Employee 2",
                        "Employee 3",
                        "Employee 4",
                        "Employee 5",
                      ],
                      value: controller.selectEmployee,
                      itemLabel: (val) => val,
                      onChanged: (val) {
                        controller.selectEmployee = val!;
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
                          initialDate: controller.bookingFromDate.value,
                          onChanged: (date) {
                            controller.bookingFromDate.value = date;
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
                        controller: controller.bookingStartTimeController,
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
                          initialDate: controller.bookingToDate.value,
                          onChanged: (date) {
                            controller.bookingToDate.value = date;
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
                        controller: controller.bookingEndTimeController,
                        onTimeSelected: (time) => setState(() {}),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.filter,
                      fontSize: 12,
                        onTap: () {
                          setState(() {
                            showTotalRow = true;
                          });
                        }
                    ),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.view,
                      fontSize: 12,
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
                SingleChildScrollView(
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
                          // 1. Pehli Row (Normal Data Row)
                          DataRow(cells: [
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("20/10/2025"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("20/10/2025"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("20/10/2025"))),
                          ]),
                          if (showTotalRow)
                            DataRow(
                              cells: [
                                const DataCell(Center(child: Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold)))),
                                const DataCell(Center(child: Text(""))),
                                DataCell(Center(child: Text(totalBookingsCreated, style: const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(totalBookingsDispatched, style: const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(totalBookingsCancelled, style: const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(totalCallsAnswered, style: const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(totalWorkingHours, style: const TextStyle(fontWeight: FontWeight.bold)))),
                              ],
                            ),
                        ]),
                  ),
                ),
              ],
            ));
      });
    });
  }
}
