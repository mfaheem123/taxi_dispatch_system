

import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../customer/model/restricDriver.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class DriverLogsScreen extends StatefulWidget {
  const DriverLogsScreen({super.key});

  @override
  State<DriverLogsScreen> createState() => _DriverLogsScreenState();
}

class _DriverLogsScreenState extends State<DriverLogsScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 15;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  // Date controllers
  // DateTime? fromDate;
  // DateTime? toDate;
  DateTime fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDate = DateTime.now();
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverLogsScreen";
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          selectedRowIndex = (selectedRowIndex + 1) % totalRows;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          selectedRowIndex = (selectedRowIndex - 1 + totalRows) % totalRows;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        debugPrint("Row $selectedRowIndex Enter Pressed (Filter/View)");
      }
    }
  }

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isFrom) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromTime = picked;
        } else {
          toTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<ReportController>(initState: (state) {
        controller.getAllDrivers();
        controller.loginStartTimeController.text = "12:00";
        controller.loginEndTimeController.text =
            DateFormat('HH:mm').format(DateTime.now());
      },builder: (controller) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

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
                        "DRIVER LOG",
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(width: 10),

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

                      // Start Time
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: "",
                        column: false,
                        width: 100,
                        child: CustomTimePicker(
                          controller: controller.loginStartTimeController,
                          onTimeSelected: (time) => setState(() {}),
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

                      // End Time
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: "",
                        column: false,
                        width: 100,
                        child: CustomTimePicker(
                          controller: controller.loginEndTimeController,
                          onTimeSelected: (time) => setState(() {}),
                        ),
                      ),

                      // Driver Dropdown
                      CustomDropdownField<DriverObject>(
                        label: "SELECT DRIVERS",
                        width: 320,
                        height: 35,
                        items: controller.allDriverData?.drivers ?? [],
                        value: controller.selectDriverObject,
                        itemLabel: (driver) =>
                        driver.name ?? "".toUpperCase(),
                        onChanged: (val) {
                          controller.selectDriverObject = val;
                          controller.update();
                        },
                      ),

                      SizedBox(width: 50),
                      CustomButton(
                        verticalPadding: 0.0,
                        width: 60,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.filter,
                        style: mozillaTextRegularText(
                            fontSize: 10, color: DynamicColors.whiteClr),
                        onTap: () {},
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      CustomButton(
                        verticalPadding: 0.0,
                        width: 60,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.view,
                        style: mozillaTextRegularText(
                            fontSize: 10, color: DynamicColors.whiteClr),
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(title: "REF #"),
                          buildHeaderWithSearch(title: "DATETIME"),
                          buildHeaderWithSearch(title: "VEHICLE"),
                          buildHeaderWithSearch(title: "PICKUP"),
                          buildHeaderWithSearch(title: "DROPOFF"),
                          buildHeaderWithSearch(title: "FARES"),
                        ],
                        totalRow: totalRows,
                        cells: [
                          const DataCell(Center(child: Text("driver"))),
                          const DataCell(Center(child: Text("bookings"))),
                          const DataCell(Center(child: Text("loginDate"))),
                          const DataCell(Center(child: Text("loginTime"))),
                          const DataCell(Center(child: Text("logoutDate"))),
                          const DataCell(Center(child: Text("logoutTime"))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}