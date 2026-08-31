import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../customer/model/restricDriver.dart';
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

  DateTime fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<ReportController>(initState: (state) {
        controller.selectDriverObject = null;
        controller.getAllDrivers();
      }, builder: (controller) {

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
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "FEEDBACK",
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(width: 30),

                      // From Date
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: "FROM:",
                        column: false,
                        width: 160,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(
                            initialDate: fromDate,
                            onChanged: (date) =>
                                setState(() => fromDate = date),
                          ),
                        ),
                      ),

                      // To Date
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: "TO:",
                        column: false,
                        width: 160,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(
                            initialDate: toDate,
                            onChanged: (date) =>
                                setState(() => toDate = date),
                          ),
                        ),
                      ),

                      // Driver Dropdown
                      CustomDropdownField<DriverObject>(
                        label: "SELECT DRIVERS",
                        width: 320,
                        height: 30,
                        items: controller.allDriverData?.drivers ?? [],
                        // value: controller.selectDriverObject,
                        value: controller.allDriverData?.drivers?.any((d) => d.id == controller.selectDriverObject?.id) ?? false
                            ? controller.allDriverData!.drivers!.firstWhere((d) => d.id == controller.selectDriverObject?.id)
                            : null,
                        itemLabel: (driver) =>
                            "${driver.username} ${driver.name}" .toUpperCase(),
                        onChanged: (val) {
                          controller.selectDriverObject = val;
                          controller.update();
                        },
                      ),
                      SizedBox(width: 100),
                      CustomButton(
                        verticalPadding: 0.0,
                        width: 60,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.filter,
                        style: mozillaTextRegularText(
                            fontSize: 12, color: DynamicColors.whiteClr),
                        onTap: () {},
                      ),
                      // Driver Dropdown aur Filter Button ke baad yeh Row/Wrap add karein:

                      const SizedBox(height: 12),

// 4 Summary Metric Boxes (Tab Navigation Highlight Supported)
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          SummaryStatCard(
                            label: "TOTAL ENTRIES",
                            value: controller.allDriverData?.drivers?.length.toString() ?? "0",
                            width: 220,
                          ),
                          const SummaryStatCard(
                            label: "DRIVING SKILL",
                            value: "-",
                            width: 220,
                          ),
                          const SummaryStatCard(
                            label: "CUSTOMER BEHAVIOUR",
                            value: "-",
                            width: 220,
                          ),
                          const SummaryStatCard(
                            label: "VEHICLE CONDITION",
                            value: "-",
                            width: 220,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
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
              ));
        }
        );
      }
      ),
    );
  }
}

class SummaryStatCard extends StatefulWidget {
  final String label;
  final String value;
  final double width;

  const SummaryStatCard({
    super.key,
    required this.label,
    required this.value,
    this.width = 220,
  });

  @override
  State<SummaryStatCard> createState() => _SummaryStatCardState();
}

class _SummaryStatCardState extends State<SummaryStatCard> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: Container(
        width: widget.width,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFA5E6D0).withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isFocused ? Colors.blue : const Color(0xFFBBE5D8),
            width: _isFocused ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}