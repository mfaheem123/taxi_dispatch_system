import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../component/color.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';
import 'model/booking_graph_model.dart';

// Chart Model
class BookingChartData {
  BookingChartData(this.date, this.bookings);
  final DateTime date;
  final int bookings;
}

class BookingStatisticsWindow extends StatefulWidget {
  @override
  _BookingStatisticsWindow createState() => _BookingStatisticsWindow();
}

class _BookingStatisticsWindow extends State<BookingStatisticsWindow> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isFullScreen ? Get.width : Get.width * 0.90,
          height: isFullScreen ? Get.height : Get.height * 0.90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            isFullScreen ? BorderRadius.zero : BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: DynamicColors.primaryClr,
                  borderRadius: isFullScreen
                      ? BorderRadius.zero
                      : const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                              isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                              size: 22),
                          onPressed: () =>
                              setState(() => isFullScreen = !isFullScreen),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 22),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Content Area
              Expanded(child: BookingStatisticsContent()),
            ],
          ),
        ),
      ),
    );
  }
}
class BookingStatisticsContent extends StatefulWidget {
  @override
  State<BookingStatisticsContent> createState() =>
      _BookingStatisticsContentState();
}

class _BookingStatisticsContentState extends State<BookingStatisticsContent> {
  final ReportController controller = Get.find<ReportController>();
  String selectedStatus = "COMPLETED";

  final Map<String, Color> paymentColors = {
    "CASH": DynamicColors.primaryClr,
    "ACCOUNT": Colors.blue.shade700,
    "CREDIT CARD": Colors.amber.shade700,
    "CARD": Colors.purple.shade600,
  };

  Color _getColorForPayment(String type) {
    String upperType = type.toUpperCase();
    if (paymentColors.containsKey(upperType)) {
      return paymentColors[upperType]!;
    }

    return Colors.teal;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerGraphApi();
    });
  }

  void _triggerGraphApi() {
    controller.setSelectedStatusByName(selectedStatus);
    String? statusId = controller.apiSelectedBookingStatus?.id?.toString();
    controller.getBookingStatisticsGraph(statusId: statusId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ReportController>(
        builder: (controller) {
          List<Datum> graphSourceList = controller.bookingGraphModel?.data ?? [];

          Map<String, Map<String, dynamic>> summaryData = {};

          for (var datum in graphSourceList) {
            if (datum.payments != null) {
              for (var payment in datum.payments!) {
                String typeName = (payment.paymentType ?? "UNKNOWN").toUpperCase().trim();
                if (typeName.isEmpty) typeName = "UNKNOWN";

                int bookings = payment.totalBookings ?? 0;
                double fares = payment.totalFares ?? 0.0;

                if (summaryData.containsKey(typeName)) {
                  summaryData[typeName]!['bookings'] = summaryData[typeName]!['bookings'] + bookings;
                  summaryData[typeName]!['fares'] = summaryData[typeName]!['fares'] + fares;
                } else {
                  summaryData[typeName] = {
                    'bookings': bookings,
                    'fares': fares,
                  };
                }
              }
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Image.asset("assets/logo.jpeg",
                    height: 70,
                    errorBuilder: (context, error, stackTrace) =>
                    const FlutterLogo(size: 70)),
                const SizedBox(height: 10),
                const Text("BOOKING STATISTICS",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1)),
                const SizedBox(height: 30),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    _buildRadioButton("COMPLETED"),
                    _buildRadioButton("INCOMPLETE"),
                    _buildRadioButton("MISSED"),
                    _buildRadioButton("DECLINED"),
                    _buildRadioButton("CANCELLED"),

                    labeledField(
                      context: context,
                      isMobile: false,
                      label: "FROM:",
                      column: false,
                      width: 160,
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
                      isMobile: false,
                      label: "TO:",
                      column: false,
                      width: 160,
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
                    ElevatedButton(
                      onPressed: _triggerGraphApi,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: DynamicColors.primaryClr,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: const Text("GENERATE",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                if (!controller.isLoadingGraph && summaryData.isNotEmpty)
                  Wrap(
                    spacing: 25,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: summaryData.entries.map((entry) {
                      String pType = entry.key;
                      int totalB = entry.value['bookings'];
                      double totalF = entry.value['fares'];

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 35,
                            height: 14,
                            decoration: BoxDecoration(
                              color: _getColorForPayment(pType),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "$pType ($totalB ${totalB == 1 ? 'BOOKING' : 'BOOKINGS'} | £ ${totalF.toStringAsFixed(2)})",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                else if (!controller.isLoadingGraph && summaryData.isEmpty)
                  const Text("NO PAYMENT DETAILS FOUND", style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 30),

                SizedBox(
                  height: 480,
                  child: controller.isLoadingGraph
                      ? const Center(child: CircularProgressIndicator())
                      : graphSourceList.isEmpty
                      ? const Center(
                      child: Text("NO DATA AVAILABLE",
                          style: TextStyle(fontWeight: FontWeight.w500)))
                      : SfCartesianChart(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    primaryXAxis: CategoryAxis(
                      labelPlacement: LabelPlacement.betweenTicks,
                      labelAlignment: LabelAlignment.center,
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      majorGridLines: const MajorGridLines(width: 0),
                      // labelIntersectAction: AxisLabelIntersectAction.rotate45,

                      labelRotation: graphSourceList.length > 8 ? -45 : 0,
                      interval: 1,
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'NO OF BOOKINGS'),
                      minimum: 0,
                      interval: 1,
                      rangePadding: ChartRangePadding.additional,
                      majorGridLines: const MajorGridLines(width: 0.5),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),

                    series: summaryData.keys.map<CartesianSeries<Datum, String>>((paymentTypeKey) {
                      return StackedColumnSeries<Datum, String>(
                        dataSource: graphSourceList,
                        xValueMapper: (Datum data, _) => data.date != null
                            ? DateFormat('dd-MM-yyyy').format(data.date!)
                            : "",
                        yValueMapper: (Datum data, _) {
                          var match = data.payments?.firstWhere(
                                (p) => (p.paymentType ?? "").toUpperCase().trim() == paymentTypeKey,
                            orElse: () => Payment(totalBookings: 0),
                          );
                          return match?.totalBookings ?? 0;
                        },
                        name: paymentTypeKey,
                        color: _getColorForPayment(paymentTypeKey),
                        width: 0.4,
                        spacing: 0.1,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRadioButton(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: title,
          groupValue: selectedStatus,
          activeColor: DynamicColors.primaryClr,
          onChanged: (val) {
            setState(() => selectedStatus = val!);
            _triggerGraphApi();
          },
        ),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}