


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
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
  final int totalRows = 5;

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
            return Column(
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
                    Text(AppText.employeeActivity,
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      width: fieldWidth/1.5,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: "",
                      width: fieldWidth/1.5,
                      child: SizedBox(height: 30, child: CustomTimePicker()),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.to,
                      width: fieldWidth/1.5,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: "",
                      width: fieldWidth/1.5,
                      child: SizedBox(height: 30, child: CustomTimePicker()),
                    ),
                    SizedBox(width: 20,),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.filter,
                      fontSize: 12,
                    ),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.view,
                      fontSize: 12,
                    ),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.statistics,
                      fontSize: 12,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                          buildHeaderWithSearch(title: "WORKING HOURS"),
                        ],
                        totalRow: totalRows,
                        cells: [
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                        ]
                    ),
                  ),
                ),
              ],
            );
          }
        );
      }
    );
  }
}
