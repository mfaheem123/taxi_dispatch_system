import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/reports/driver_reports_view/earning_and_info_screen/vehicel_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../component/datatable_widget.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/report_controller.dart';

class EarningAndInfoScreen extends StatefulWidget {
  const EarningAndInfoScreen({super.key});

  @override
  State<EarningAndInfoScreen> createState() => _EarningAndInfoScreenState();
}

class _EarningAndInfoScreenState extends State<EarningAndInfoScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 5;
  bool vehicelInfo = false;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 700;
        final bool isTablet = maxWidth >= 700 && maxWidth < 1024;

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
              color: DynamicColors.gryClr,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Text(
                  AppText.driverEarning,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Wrap(
              runSpacing: 16,
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.from,
                  column: true,
                  width: fieldWidth / 1.5,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.to,
                  column: true,
                  width: fieldWidth / 1.5,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
                CustomButton(
                  height: 30,
                  width: 120,
                  borderRadius: 4,
                  fontSize: 12,
                  verticalPadding: 0.0,
                  btnText: AppText.allDrivers,
                ),
                CustomButton(
                  height: 30,
                  width: 120,
                  borderRadius: 4,
                  fontSize: 12,
                  verticalPadding: 0.0,
                  btnText: AppText.loginDrivers,
                ),
                CustomButton(
                  height: 30,
                  width: 120,
                  borderRadius: 4,
                  fontSize: 12,
                  verticalPadding: 0.0,
                  btnText: AppText.logoutDrivers,
                ),
                SizedBox(
                  width: 50,
                ),
                CustomButton(
                  height: 30,
                  width: 120,
                  borderRadius: 4,
                  fontSize: 12,
                  verticalPadding: 0.0,
                  btnText: AppText.view,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isTabletMini = constraints.maxWidth < 1024;
                final tableWidget = DatatableWidget(
                  columns: [
                    buildHeaderWithSearch(title: "USERNAME"),
                    buildHeaderWithSearch(title: "DRIVER"),
                    buildHeaderWithSearch(title: "TOTAL BOOKINGS"),
                    buildHeaderWithSearch(title: "TOTAL EARNINGS"),
                  ],
                  totalRow: totalRows,
                  cells: [
                    DataCell(Row(
                      children: [
                        CircleAvatar(
                            radius: 8, backgroundColor: DynamicColors.greenClr),
                        const SizedBox(width: 6),
                        const Text("driver"),
                      ],
                    )),
                    const DataCell(Center(child: Text("bookings"))),
                    const DataCell(Center(child: Text("loginDate"))),
                    const DataCell(Center(child: Text("loginTime"))),
                  ],
                );

                final rightWidget = vehicelInfo
                    ? SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: [
                          BarSeries<SalesData, String>(
                            dataSource: [
                              SalesData('Jan', 35),
                              SalesData('Feb', 28),
                              SalesData('Mar', 34),
                              SalesData('Apr', 32),
                              SalesData('May', 40),
                            ],
                            xValueMapper: (sales, _) => sales.month,
                            yValueMapper: (sales, _) => sales.sales,
                            color: DynamicColors.primaryClr,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                          ),
                        ],
                      )
                    : const VehicelsScreen();

                return isTabletMini
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          tableWidget,
                          const SizedBox(height: 20),
                          rightWidget,
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: tableWidget),
                          Expanded(child: rightWidget),
                        ],
                      );
              },
            ),
          ],
        );
      });
    });
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final double sales;
}
