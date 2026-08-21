import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/pagination.dart';
import '../../../component/textStyle.dart';
import '../../customer/model/restricDriver.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';
import 'driver_logs_view_screen.dart';

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

  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverLogsScreen";
    controller.clearLogsData();
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

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<ReportController>(initState: (state) {
        controller.selectDriverObject = null;
        controller.getAllDrivers();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.loginStartTimeController.text = "12:00";
          controller.loginEndTimeController.text =
              DateFormat('HH:mm').format(DateTime.now());
          controller.update();
        });
      }, builder: (controller) {

        final listToShow = controller.logsBookingFiltered.isNotEmpty
            ? controller.logsBookingFiltered
            : controller.logsBookingAll;

        final int totalBookings =
            controller.driverLogsData?.bookings?.length ?? 0;

        final double totalEarnings =
        (controller.driverLogsData?.bookings ?? []).fold(0.0, (sum, item) {
          return sum + (double.tryParse(item.fares.toString()) ?? 0.0);
        });
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
                        width: maxWidth < 1366 ? 120 : 160,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(
                            initialDate:
                            controller.fromDate.value ?? DateTime.now(),
                            onChanged: (date) {
                              controller.fromDate.value = date;
                              controller.update();
                            },
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
                          controller: controller.logStartTimeController,
                          onTimeSelected: (time) => setState(() {}),
                        ),
                      ),
                      // To Date
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: "TO:",
                        column: false,
                        width: maxWidth < 1366 ? 120 : 160,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(
                            initialDate:
                            controller.toDate.value ?? DateTime.now(),
                            onChanged: (date) {
                              controller.toDate.value = date;
                              controller.update();
                            },
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
                          controller: controller.logEndTimeController,
                          onTimeSelected: (time) => setState(() {}),
                        ),
                      ),

                      // Driver Dropdown
                      CustomDropdownField<DriverObject>(
                        label: "SELECT DRIVERS",
                        width: maxWidth < 1366 ? 220 : 320,
                        height: 35,
                        items: controller.allDriverData?.drivers ?? [],
                        value: controller.allDriverData?.drivers?.any((d) =>
                        d.id ==
                            controller.selectDriverObject?.id) ??
                            false
                            ? controller.allDriverData!.drivers!.firstWhere(
                                (d) =>
                            d.id == controller.selectDriverObject?.id)
                            : null,
                        itemLabel: (driver) =>
                            "${driver.username} ${driver.name}" .toUpperCase(),
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
                        onTap: () {
                          controller.getDriverLogs();
                        },
                      ),
                      SizedBox(
                        width: maxWidth < 1366 ? 0 : 7,
                      ),
                      CustomButton(
                        verticalPadding: 0.0,
                        width: 60,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.view,
                        style: mozillaTextRegularText(
                            fontSize: 10, color: DynamicColors.whiteClr),
                        onTap: () {
                          if (controller.selectDriverObject != null) {
                            Get.dialog(
                              const DriverLogsViewWindow(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: DynamicColors.secondaryClr,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "TOTAL BOOKINGS: ",
                                style: mozillaTextSemiBoldText(
                                    fontSize: 14, color: Colors.black87),
                              ),
                              Text(
                                (controller.driverLogsData == null ||
                                    controller.isLoadingLogs.value)
                                    ? ""
                                    : "$totalBookings",
                                style: mozillaTextRegularText(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TOTAL EARNINGS: ",
                                style: mozillaTextSemiBoldText(
                                    fontSize: 14, color: Colors.black87),
                              ),
                              Text(
                                (controller.driverLogsData == null ||
                                    controller.isLoadingLogs.value)
                                    ? ""
                                    : "£${totalEarnings.toStringAsFixed(2)}",
                                style: mozillaTextRegularText(fontSize: 14),
                              ),
                            ],
                          ),
                        ),

                        // Right side balance placeholder
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width,
                  //     child: controller.isLoadingLogs.value
                  //         ? const Center(child: CircularProgressIndicator())
                  //         :
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: controller.isLoadingLogs.value
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : SingleChildScrollView(
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(
                              title: "REF #",
                              onChanged: (v) {
                                controller.searchLogsRef.value = v;
                                controller.onSearchDriverLogs();
                              }),
                          buildHeaderWithSearch(title: "DATETIME",
                              onChanged: (v) {
                                controller.searchLogsDateTime.value = v;
                                controller.onSearchDriverLogs();
                              }),
                          buildHeaderWithSearch(
                              title: "VEHICLE",
                              onChanged: (v) {
                                controller.searchLogsVehicle.value = v;
                                controller.onSearchDriverLogs();
                              }),
                          buildHeaderWithSearch(
                              title: "PICKUP",
                              onChanged: (v) {
                                controller.searchLogsPickup.value = v;
                                controller.onSearchDriverLogs();
                              }),
                          buildHeaderWithSearch(
                              title: "DROPOFF",
                              onChanged: (v) {
                                controller.searchLogsDropoff.value = v;
                                controller.onSearchDriverLogs();
                              }),
                          buildHeaderWithSearch(
                              title: "FARES",
                              onChanged: (v) {
                                controller.searchLogsFares.value = v;
                                controller.onSearchDriverLogs();
                              }),
                        ],
                        // totalRow: controller.driverLogsData?.bookings?.length ?? 0,
                        // rows: (controller.driverLogsData?.bookings ?? []).map((booking) {
                        totalRow: listToShow.length,
                        rows: listToShow.map((item) {
                          return DataRow(
                            cells: [
                              DataCell(Center(child: Text(item.referenceNumber ?? ""))),
                              DataCell(Center(child: Text("${item.pickupDate != null ? DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-M-d").parse(item.pickupDate.toString())) : "-"} "
                                  "${item.pickupTime != null ? item.pickupTime.toString().split('.')[0].substring(0, 5) : ""}"))),
                              DataCell(Center(child: Text(item.vehicleType?.name?.toUpperCase() ?? ""))),
                              DataCell(Text((item.pickup ?? "").toUpperCase())),
                              DataCell(Text((item.dropoff ?? "").toUpperCase())),
                              DataCell(Center(child: Text("£${item.fares ?? "0.00"}"))),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: controller.currentLogsPage.value,
                    totalPages: controller.totalLogsPages.value,
                    onPageChange: controller.onPageLogs,
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