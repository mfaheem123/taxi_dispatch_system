import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DriverChartData {
  DriverChartData(this.username, this.bookings);
  final String username;
  final int bookings;
}

class DriverBookingChart extends StatelessWidget {
  final List<DriverChartData> chartData;

  const DriverBookingChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      isTransposed: false,

      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: '', textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),

      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'TOTAL BOOKINGS', textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),

      tooltipBehavior: TooltipBehavior(enable: true),

      series: <CartesianSeries<DriverChartData, String>>[
        BarSeries<DriverChartData, String>(
          dataSource: chartData,
          xValueMapper: (DriverChartData data, _) => data.username,
          yValueMapper: (DriverChartData data, _) => data.bookings,
          name: 'Bookings',
          color: DynamicColors.primaryClr,
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
            labelPosition: ChartDataLabelPosition.outside,
          ),
        )
      ],
    );
  }
}