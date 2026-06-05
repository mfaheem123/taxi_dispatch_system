import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/dropdown_button.dart';
import '../../../../component/text_widget.dart';
import '../../../customer/model/restricDriver.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/report_controller.dart';
import '../models/earning_and_info_model.dart';

class EarningAndInfoScreen extends StatefulWidget {
  const EarningAndInfoScreen({super.key});

  @override
  State<EarningAndInfoScreen> createState() => _EarningAndInfoScreenState();
}

class _EarningAndInfoScreenState extends State<EarningAndInfoScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  bool isDataLoaded = false;

  String selectedPeriod = "daily";

  List<DriverObject> selectedDriversList = [];
  DriverObject? activeRadioDriver;

  void handleView() {
    controller.getAllDriversEarnings();
    setState(() {
      isDataLoaded = true;
    });
  }
  void updateDriverData(DriverObject driver, String period) {
    setState(() {
      activeRadioDriver = driver;
      isDataLoaded = true;
    });
    controller.selectDriverObject = driver;
    controller.getAllDriversEarnings(period: period);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      initState: (state) {
        controller.selectDriverObject = null;
        controller.getAllDrivers();
      },
      builder: (controller) {
        return LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isMobile = maxWidth < 600;

          final driverData = controller.earningInfoListModel?.data;
          int totalTrips = driverData?.totalTrips ?? 0;
          double totalEarnings = (driverData?.totalEarnings ?? 0).toDouble();
          double averagePerTrip = (driverData?.averagePerTrip ?? 0).toDouble();
          double cashCollected = (driverData?.cashCollected ?? 0).toDouble();
          List<ChartDatum> chartList = driverData?.chartData ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                // MAIN CONTAINER
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: DynamicColors.gryClr.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        color: DynamicColors.gryClr,
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                        child: Text(
                          "DRIVER EARNING REPORT",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(bottom: 25),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade200, width: 1)
                                  )
                              ),
                              child: Wrap(
                                spacing: 24,
                                runSpacing: 20,
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [
                                  // SELECT DRIVER DROPDOWN
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "SELECT DRIVER",
                                        style: mozillaTextSemiBoldText(context: context, fontSize: 12),
                                      ),
                                      const SizedBox(height: 6),
                                      CustomDropdownField<DriverObject>(
                                        label: "SELECT DRIVERS",
                                        width: 240,
                                        height: 42,
                                        items: controller.allDriverData?.drivers ?? [],
                                        value: controller.allDriverData?.drivers?.any((d) => d.id == controller.selectDriverObject?.id) ?? false
                                            ? controller.allDriverData!.drivers!.firstWhere((d) => d.id == controller.selectDriverObject?.id)
                                            : null,
                                        itemLabel: (driver) =>
                                            (driver.name ?? "").toUpperCase(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            if (!selectedDriversList.contains(val)) {
                                              selectedDriversList.add(val);
                                            }
                                            updateDriverData(val, controller.selectedPeriod);
                                          }
                                        },
                                      ),
                                    ],
                                  ),

                                  // PERIOD BUTTONS
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "View",
                                        style: mozillaTextSemiBoldText(context: context, fontSize: 12),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomButton(
                                            verticalPadding: 0.0,
                                            width: 115,
                                            height: 42,
                                            borderRadius: 4,
                                            fontSize: 14,
                                            btnText: "DAILY",
                                            btnColor: selectedPeriod == "daily" ? DynamicColors.primaryClr : Colors.grey.shade500,
                                            onTap: () {
                                              if (activeRadioDriver != null) {
                                                updateDriverData(activeRadioDriver!, "daily");
                                              } else {
                                                setState(() => controller.selectedPeriod = "daily");
                                              }
                                            },
                                          ),
                                          const SizedBox(width: 6),
                                          CustomButton(
                                            verticalPadding: 0.0,
                                            width: 115,
                                            height: 42,
                                            borderRadius: 4,
                                            fontSize: 14,
                                            btnText: "WEEKLY",
                                            btnColor: controller.selectedPeriod == "weekly" ? DynamicColors.primaryClr : Colors.grey.shade500,
                                            onTap: () {
                                              if (activeRadioDriver != null) {
                                                updateDriverData(activeRadioDriver!, "weekly");
                                              } else {
                                                setState(() => controller.selectedPeriod = "weekly");
                                              }
                                            },
                                          ),
                                          const SizedBox(width: 6),
                                          CustomButton(
                                            verticalPadding: 0.0,
                                            width: 115,
                                            height: 42,
                                            borderRadius: 4,
                                            fontSize: 14,
                                            btnText: "MONTHLY",
                                            btnColor: controller.selectedPeriod == "monthly" ? DynamicColors.primaryClr : Colors.grey.shade500,
                                            onTap: () {
                                              if (activeRadioDriver != null) {
                                                updateDriverData(activeRadioDriver!, "monthly");
                                              } else {
                                                setState(() => controller.selectedPeriod = "monthly");
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      labeledField(
                                        context: context,
                                        isMobile: isMobile,
                                        label: AppText.from,
                                        column: true,
                                        width: 150,
                                        child: SizedBox(
                                          height: 40,
                                          child: KeyboardDatePicker(
                                            initialDate: controller.earningFromDate.value,
                                            onChanged: (date) =>
                                                setState(() => controller.earningFromDate.value = date),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      labeledField(
                                        context: context,
                                        isMobile: isMobile,
                                        label: AppText.to,
                                        column: true,
                                        width: 150,
                                        child: SizedBox(
                                          height: 40,
                                          child: KeyboardDatePicker(
                                            initialDate: controller.earningToDate.value,
                                            onChanged: (date) =>
                                                setState(() => controller.earningToDate.value = date),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // VIEW BUTTON
                                  CustomButton(
                                    verticalPadding: 0.0,
                                    width: 100,
                                    height: 42,
                                    borderRadius: 4,
                                    fontSize: 13,
                                    btnText: AppText.view,
                                    onTap: () {
                                      handleView();
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (selectedDriversList.isNotEmpty) ...[
                                        Container(
                                          height: 420,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.grey.shade200),
                                          ),
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: selectedDriversList.length,
                                              itemBuilder: (context, index) {
                                                final driver = selectedDriversList[index];
                                                final bool isSelected = activeRadioDriver == driver;

                                                return InkWell(
                                                  onTap: () => updateDriverData(driver, controller.selectedPeriod),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                                          color: isSelected ? DynamicColors.primaryClr : Colors.grey,
                                                          size: 18,
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            (driver.name ?? "").toUpperCase(),
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                              color: isSelected ? Colors.black : Colors.grey.shade700,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 24),

                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.shade200),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.05),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                              )
                                            ]),
                                        child: controller.isLoadingEarning
                                            ? const Center(child: CircularProgressIndicator())
                                            : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildStatCard(
                                              label: "TOTAL EARNINGS",
                                              value: isDataLoaded ? "£ ${totalEarnings.toStringAsFixed(2)}" : "£ 0.00",
                                              icon: Icons.currency_pound,
                                              iconColor: Colors.green,
                                              bgColor: Colors.green.withOpacity(0.1),
                                            ),
                                            _buildStatCard(
                                              label: "TOTAL TRIPS",
                                              value: isDataLoaded ? "$totalTrips" : "-",
                                              icon: Icons.location_on_outlined,
                                              iconColor: Colors.blue,
                                              bgColor: Colors.blue.withOpacity(0.1),
                                            ),
                                            _buildStatCard(
                                              label: "AVERAGE PER TRIP",
                                              value: isDataLoaded ? "£ ${averagePerTrip.toStringAsFixed(2)}" : "£ 0.00",
                                              icon: Icons.bar_chart_rounded,
                                              iconColor: Colors.orange,
                                              bgColor: Colors.orange.withOpacity(0.1),
                                            ),
                                            _buildStatCard(
                                              label: "CASH COLLECTED",
                                              value: isDataLoaded ? "£ ${cashCollected.toStringAsFixed(2)}" : "£ 0.00",
                                              icon: Icons.account_balance_wallet_outlined,
                                              iconColor: Colors.purple,
                                              bgColor: Colors.purple.withOpacity(0.1),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // GRAPH SECTION
                                      Container(
                                        height: 320,
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        child: controller.isLoadingEarning
                                            ? const Center(child: CircularProgressIndicator())
                                            : (isDataLoaded && activeRadioDriver != null)
                                            ? _buildEarningChart(chartList)
                                            : Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.insert_chart_outlined, size: 65, color: Colors.grey.shade300),
                                              const SizedBox(height: 10),
                                              Text(
                                                "SELECT A DRIVER TO VIEW EARNINGS GRAPH",
                                                style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
      },
    );
  }

// DYNAMIC CHART METHOD

  Widget _buildEarningChart(List<ChartDatum> chartData) {
    List<FlSpot> spots = [];
    double maxEarningsValue = 100.0;

    if (chartData.isNotEmpty) {
      for (int i = 0; i < chartData.length; i++) {
        double earningValue = double.tryParse(chartData[i].earnings ?? "0") ?? 0.0;
        spots.add(FlSpot(i.toDouble(), earningValue));
        if (earningValue > maxEarningsValue) {
          maxEarningsValue = earningValue;
        }
      }
    } else {
      spots = const [FlSpot(0, 0), FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 0)];
    }

    double graphMaxY = maxEarningsValue + (maxEarningsValue * 0.15);
    double yInterval = (graphMaxY / 4) > 0 ? (graphMaxY / 4).roundToDouble() : 20.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: yInterval,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
          getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (chartData.isNotEmpty && index >= 0 && index < chartData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                        chartData[index].label ?? '',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: yInterval,
              getTitlesWidget: (value, meta) => Text('£${value.toInt()}', style: const TextStyle(fontSize: 10, color: Colors.black54)),
              reservedSize: 50,
            ),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade200, width: 1)),
        minX: 0,
        maxX: chartData.isNotEmpty ? (chartData.length - 1).toDouble() : 3,
        minY: 0,
        maxY: graphMaxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(colors: [DynamicColors.primaryClr, Colors.blueAccent]),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [DynamicColors.primaryClr.withOpacity(0.2), Colors.blueAccent.withOpacity(0.01)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$label: ",
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w700, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        )
      ],
    );
  }
}
