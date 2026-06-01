


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class CompanyIncomeScreen extends StatefulWidget {
  const CompanyIncomeScreen({super.key});

  @override
  State<CompanyIncomeScreen> createState() => _CompanyIncomeScreenState();
}

class _CompanyIncomeScreenState extends State<CompanyIncomeScreen> {

  int selectedRowIndex = 0;
  final int totalRows = 50;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              SizedBox(
                height: 10,
              ),
               Row(
                  children: [
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      width: fieldWidth/1.9,
                      column: true,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      column: true,
                      label: AppText.to,
                      width: fieldWidth/1.9,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),

                    const Spacer(),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.filter,
                      fontSize: 12,
                    ),
                    SizedBox(width: 10),
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: DynamicColors.secondaryClr,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(AppText.totalBookings,
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      Text(AppText.totalEarnings,
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
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
                          buildHeaderWithSearch(title: "REF #"),
                          buildHeaderWithSearch(title: "DATETIME"),
                          buildHeaderWithSearch(title: "PICKUP"),

                          buildHeaderWithSearch(title: "DROPOFF"),
                          buildHeaderWithSearch(title: "VEHICLE"),
                          buildHeaderWithSearch(title: "DRIVER"),

                          buildHeaderWithSearch(title: "ACCOUNT"),
                          buildHeaderWithSearch(title: "FARES"),
                          buildHeaderWithSearch(title: "PC"),
                          buildHeaderWithSearch(title: "WC"),
                          buildHeaderWithSearch(title: "EDC"),
                          buildHeaderWithSearch(title: "M&G"),
                          buildHeaderWithSearch(title: "CC"),
                          buildHeaderWithSearch(title: "TOTAL"),
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
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                        ]
                    ),
                  ),
                ),
              ],
              )
            );
          }
        );
      }
    );
  }
}
