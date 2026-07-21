import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  List<DriverObject> selectedDriversList = [];
  DriverObject? activeRadioDriver;

  void handleView() {
    if (controller.selectDriverObject != null) {
      controller.getAllDriversEarnings();
      setState(() {
        isDataLoaded = true;
      });
    } else {
      BotToast.showText(text: "Please select a driver first");
    }
  }
  void updateDriverData(DriverObject driver, String viewType) {
    setState(() {
      activeRadioDriver = driver;
      isDataLoaded = true;
    });
    controller.selectDriverObject = driver;
    controller.getAllDriversEarnings(viewType: viewType);
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
                                            updateDriverData(val, controller.reportViewType);
                                          }
                                        },
                                      ),
                                    ],
                                  ),

                                  // VIEW TYPE BUTTONS
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
                                            btnColor: controller.reportViewType == "daily" ? DynamicColors.primaryClr : Colors.grey.shade500,
                                            onTap: () {
                                              if (activeRadioDriver != null) {
                                                updateDriverData(activeRadioDriver!, "daily");
                                              } else {
                                                controller.reportViewType = "daily";
                                                controller.update();
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
                                            btnColor: controller.reportViewType == "weekly" ? DynamicColors.primaryClr : Colors.grey.shade500,
                                            onTap: () {
                                              if (activeRadioDriver != null) {
                                                updateDriverData(activeRadioDriver!, "weekly");
                                              } else {
                                                controller.reportViewType = "weekly";
                                                controller.update();
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
                                            btnColor: controller.reportViewType == "monthly" ? DynamicColors.primaryClr : Colors.grey.shade500,
                                            onTap: () {
                                              if (activeRadioDriver != null) {
                                                updateDriverData(activeRadioDriver!, "monthly");
                                              } else {
                                                controller.reportViewType = "monthly";
                                                controller.update();
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
                                            onChanged: (date) {
                                              controller.earningFromDate.value = date;
                                              controller.update();
                                              if (controller.selectDriverObject != null) {
                                                controller.getAllDriversEarnings();
                                              }
                                            },
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
                                            onChanged: (date) {
                                              controller.earningToDate.value = date;
                                              controller.update();
                                              // if(activeRadioDriver != null) {
                                              //   updateDriverData(activeRadioDriver!, controller.reportViewType);
                                              // }
                                            },
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
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const BouncingScrollPhysics(),
                                            itemCount: selectedDriversList.length,
                                            itemBuilder: (context, index) {
                                              final driver = selectedDriversList[index];
                                              final bool isSelected = activeRadioDriver == driver;

                                              return InkWell(
                                                onTap: () => updateDriverData(driver, controller.reportViewType),
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
                                              value: isDataLoaded ? "£ ${totalEarnings.toStringAsFixed(2)}" : "",
                                              icon: Icons.currency_pound,
                                              iconColor: Colors.green,
                                              bgColor: Colors.green.withOpacity(0.1),
                                            ),
                                            _buildStatCard(
                                              label: "TOTAL TRIPS",
                                              value: isDataLoaded ? "$totalTrips" : "",
                                              icon: Icons.location_on_outlined,
                                              iconColor: Colors.blue,
                                              bgColor: Colors.blue.withOpacity(0.1),
                                            ),
                                            _buildStatCard(
                                              label: "AVERAGE PER TRIP",
                                              value: isDataLoaded ? "£ ${averagePerTrip.toStringAsFixed(2)}" : "",
                                              icon: Icons.bar_chart_rounded,
                                              iconColor: Colors.orange,
                                              bgColor: Colors.orange.withOpacity(0.1),
                                            ),
                                            _buildStatCard(
                                              label: "CASH COLLECTED",
                                              value: isDataLoaded ? "£ ${cashCollected.toStringAsFixed(2)}" : "",
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

  Widget _buildEarningChart(List<ChartDatum> chartData) {
    List<FlSpot> spots = [];
    double maxEarningsValue = 60.0;
    double yInterval = 10.0;

    Map<double, String> spotDisplayDates = {};
    Map<double, String> spotApiDates = {};

    final List<String> dailyLabels = List.generate(24, (i) => "${i.toString().padLeft(2, '0')}:00");
    final List<String> weeklyLabels = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];


    DateTime baseFromDate = controller.earningFromDate.value ?? DateTime.now();
    int daysInSelectedMonth = DateTime(baseFromDate.year, baseFromDate.month + 1, 0).day;

    // Date Format
    final List<String> monthlyLabels = List.generate(
        daysInSelectedMonth,
            // (index) => "${index + 1}/${baseFromDate.month}"
            (index) => "${index + 1}/${baseFromDate.month}/${baseFromDate.year.toString().substring(2)}"
    );

    List<String> activeLabels = dailyLabels;
    double xBottomInterval = 4.0;

    if (controller.reportViewType == "weekly") {
      maxEarningsValue = 200.0;
      yInterval = 50.0;
      activeLabels = weeklyLabels;
      xBottomInterval = 1.0;
    } else if (controller.reportViewType == "monthly") {
      maxEarningsValue = 1000.0;
      yInterval = 250.0;
      activeLabels = monthlyLabels;
      xBottomInterval = 1.0;
    }

    if (chartData.isNotEmpty) {
      for (var data in chartData) {
        double earningValue = double.tryParse(data.earnings ?? "0") ?? 0.0;
        if (earningValue <= 0) continue;

        if (earningValue > maxEarningsValue) {
          maxEarningsValue = earningValue;
        }

        String apiLabel = (data.label ?? "").trim().toUpperCase();
        int targetIndex = activeLabels.indexWhere((element) => element == apiLabel);

        if (targetIndex == -1) {
          int? numericIndex = int.tryParse(apiLabel);
          if (numericIndex != null) {
            if (controller.reportViewType == "daily") {
              targetIndex = numericIndex;
            } else if (controller.reportViewType == "monthly") {
              targetIndex = numericIndex - 1;
            } else {
              targetIndex = numericIndex - 1;
            }
          }
        }

        if (targetIndex >= 0 && targetIndex < activeLabels.length) {
          double xValue = targetIndex.toDouble();
          spots.add(FlSpot(xValue, earningValue));

          String exactDateText = "";
          String exactApiDateText = "";

          if (controller.reportViewType == "weekly") {
            int baseWeekday = baseFromDate.weekday;
            int daysDifference = targetIndex - (baseWeekday - 1);
            DateTime calculatedDate = baseFromDate.add(Duration(days: daysDifference));

            exactDateText = "${calculatedDate.day.toString().padLeft(2, '0')}-${calculatedDate.month.toString().padLeft(2, '0')}-${calculatedDate.year}";
            exactApiDateText = DateFormat('yyyy-MM-dd').format(calculatedDate);
          } else if (controller.reportViewType == "monthly") {
            int dayNumber = targetIndex + 1;
            DateTime calculatedDate = DateTime(baseFromDate.year, baseFromDate.month, dayNumber);

            // Tooltip par poori date show hogi (e.g. 01-07-2026)
            exactDateText = "${dayNumber.toString().padLeft(2, '0')}-${baseFromDate.month.toString().padLeft(2, '0')}-${baseFromDate.year}";
            exactApiDateText = DateFormat('yyyy-MM-dd').format(calculatedDate);
          } else {
            String formattedCurrentDate = "${baseFromDate.day.toString().padLeft(2, '0')}-${baseFromDate.month.toString().padLeft(2, '0')}-${baseFromDate.year}";
            exactDateText = "Time: ${activeLabels[targetIndex]} ($formattedCurrentDate)";
            exactApiDateText = DateFormat('yyyy-MM-dd').format(baseFromDate);
          }

          spotDisplayDates[xValue] = exactDateText;
          spotApiDates[xValue] = exactApiDateText;
        }
      }

      spots.sort((a, b) => a.x.compareTo(b.x));

      if (spots.isNotEmpty && spots.first.x > 0) {
        spots.insert(0, const FlSpot(0, 0));
        spotDisplayDates[0.0] = "Start";
        spotApiDates[0.0] = DateFormat('yyyy-MM-dd').format(baseFromDate);
      }

      if (maxEarningsValue > 60.0 && controller.reportViewType == "daily") {
        yInterval = (maxEarningsValue / 5).roundToDouble();
      } else if (maxEarningsValue > 200.0 && controller.reportViewType == "weekly") {
        yInterval = (maxEarningsValue / 4).roundToDouble();
      } else if (maxEarningsValue > 1000.0 && controller.reportViewType == "monthly") {
        yInterval = (maxEarningsValue / 4).roundToDouble();
      }
    }

    double graphMaxY = maxEarningsValue;

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
            if (!event.isInterestedForInteractions || touchResponse == null || touchResponse.lineBarSpots == null) {
              return;
            }
            if (event is FlTapUpEvent) {
              final touchedSpot = touchResponse.lineBarSpots!.first;
              final double xVal = touchedSpot.x;
              String? targetApiDate = spotApiDates[xVal];

              if (targetApiDate != null && !controller.isLoadingEarning) {
                print("Graph point clicked! Date: $targetApiDate");
                controller.getAllDriversEarnings(specificDate: targetApiDate);
              }
            }
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black.withOpacity(0.85),
            maxContentWidth: 150,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                String dateText = spotDisplayDates[touchedSpot.x] ?? "";

                return LineTooltipItem(
                  '$dateText\n£${touchedSpot.y.toStringAsFixed(2)}',
                  const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      height: 1.4
                  ),
                );
              }).toList();
            },
          ),
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                const FlLine(color: Colors.transparent, strokeWidth: 0),
                FlDotData(show: true, getDotPainter: (spot, percent, bar, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: DynamicColors.primaryClr,
                    strokeColor: Colors.white,
                    strokeWidth: 2,
                  );
                }),
              );
            }).toList();
          },
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: yInterval,
          verticalInterval: xBottomInterval,
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
              reservedSize: 45, // Rotated labels
              interval: xBottomInterval,
              getTitlesWidget: (value, meta) {
                if (controller.reportViewType == "daily") {
                  return const Text('');
                }

                int index = value.toInt();
                if (index >= 0 && index < activeLabels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Transform.rotate(
                      angle: controller.reportViewType == "monthly" ? -0.7 : 0, // Approx -40 degrees rotate
                      child: Text(
                        activeLabels[index], // Format: e.g. "1/7", "2/7"
                        style: TextStyle(
                          fontSize: controller.reportViewType == "monthly" ? 10 : 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
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
        maxX: (activeLabels.length - 1).toDouble(),
        minY: 0,
        maxY: graphMaxY,
        lineBarsData: [
          if (spots.isNotEmpty)
            LineChartBarData(
              spots: spots,
              isCurved: false,
              gradient: LinearGradient(colors: [DynamicColors.primaryClr, Colors.blueAccent]),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  if (spot.x == 0 && spot.y == 0 && index == 0) {
                    return FlDotCirclePainter(radius: 0, color: Colors.transparent, strokeWidth: 0);
                  }
                  return FlDotCirclePainter(
                    radius: 5,
                    color: DynamicColors.primaryClr,
                    strokeColor: Colors.white,
                    strokeWidth: 2,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [DynamicColors.primaryClr.withOpacity(0.15), Colors.blueAccent.withOpacity(0.01)],
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