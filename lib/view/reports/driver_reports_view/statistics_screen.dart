
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../component/color.dart';
import '../controller/report_controller.dart';
import 'earning_and_info_screen/earning_and_info_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  CustomButton(
                    width: 120,
                    height: 30,
                    btnText: "LOGGEDIN",
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    fontSize: 15,
                    btnColor: DynamicColors.primaryClr,
                    onTap: (){

                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CustomButton(
                    width: 120,
                    height: 30,
                    btnText: "DAILY",
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    fontSize: 15,
                    btnColor: DynamicColors.secondaryClr,
                    onTap: (){

                    },
                  ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                height: Get.height/1.3,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries>[
                      ColumnSeries<SalesData, String>(
                        dataSource: <SalesData>[
                          SalesData('1', 35),
                          SalesData('2', 28),
                          SalesData('3', 34),
                          SalesData('4', 32),
                          SalesData('5', 40),
                          SalesData('6', 40),
                          SalesData('7', 55),
                          SalesData('8', 65),
                          SalesData('9', 75),
                          SalesData('10', 88),
                        ],
                        xValueMapper: (SalesData sales, _) => sales.month,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        name: 'Sales',
                        color: DynamicColors.primaryClr,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      )
                    ],
                  ),
                )

              ],
            );
          }
        );
      }
    );
  }
}
class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final double sales;
}