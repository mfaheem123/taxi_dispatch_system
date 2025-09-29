



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class ReportFeedback extends StatefulWidget {
  const ReportFeedback({super.key});

  @override
  State<ReportFeedback> createState() => _ReportFeedbackState();
}

class _ReportFeedbackState extends State<ReportFeedback> {

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
                Container(
                  // height: screenHeight / 20,
                  width: Get.width,
                  color: DynamicColors.secondaryClr,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 16,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                        child: Text(
                          AppText.feedBack,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        label: AppText.to,
                        width: fieldWidth/1.5,
                        child: SizedBox(height: 30, child: KeyboardDatePicker()),
                      ),
                      CustomDropdownField<String>(
                        // text: AppText.selectDriver,
                        width: fieldWidth/1.5,
                        label: AppText.selectDriver,
                        items:[
                          "25 GEORGE HAMPTON1",
                          "25 GEORGE HAMPTON2",
                          "25 GEORGE HAMPTON3",
                          "25 GEORGE HAMPTON4",
                          "25 GEORGE HAMPTON5",
                          "25 GEORGE HAMPTON6",],
                        value: controller.selectDriver,
                        itemLabel: (val) => val, // just show the string
                        onChanged: (val) {
                          controller.selectDriver = val!;
                          controller.update();
                        },
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      CustomButton(
                        height: 30,
                        width: 80,
                        borderRadius: 4,
                        fontSize: 12,
                        verticalPadding: 0.0,
                        btnText: AppText.filter,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "DATE"),
                        buildHeaderWithSearch(title: "DRIVER"),
                        buildHeaderWithSearch(title: "DRIVING SKILL"),
                        buildHeaderWithSearch(title: "ROUTE KNOWLEDGE"),
                        buildHeaderWithSearch(title: "CUSTOMER BEHAVIOUR"),
                        buildHeaderWithSearch(title: "VEHICLE CONDITION"),
                        buildHeaderWithSearch(title: "COMMENTS"),
                      ],
                      totalRow: totalRows,
                      cells: [
                        const DataCell(Center(child: Text("driver"))),
                        const DataCell(Center(child: Text("bookings"))),
                        const DataCell(Center(child: Text("loginDate"))),
                        const DataCell(Center(child: Text("loginTime"))),
                        const DataCell(Center(child: Text("logoutDate"))),
                        const DataCell(Center(child: Text("logoutTime"))),
                        const DataCell(Center(child: Text("logoutTime"))),
                      ],
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
