import 'package:bot_toast/bot_toast.dart';
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
import 'driver_login_view_screen.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 15;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverLogin";
    controller.clearLoginData();
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
        child: GetBuilder<ReportController>(
          initState: (state) {
            controller.selectDriverObject = null;
            controller.getAllDrivers();
            controller.loginStartTimeController.text = "12:00";
            controller.loginEndTimeController.text =
                DateFormat('HH:mm').format(DateTime.now());
          },
          builder: (controller) {
            final listToShow = controller.driverHistoryFiltered.isNotEmpty
                ? controller.driverHistoryFiltered
                : controller.driverShiftHistoryAll;

            return LayoutBuilder(builder: (context, constraints) {
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
                          "DRIVER LOGIN",
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
                              initialDate: controller.loginFromDate.value,
                              onChanged: (date) =>
                                  setState(() => controller.loginFromDate.value = date),
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
                          width: maxWidth < 1366 ? 120 : 160,
                          child: SizedBox(
                            height: 30,
                            child: KeyboardDatePicker(
                              initialDate: controller.loginToDate.value,
                              onChanged: (date) =>
                                  setState(() => controller.loginToDate.value = date),
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
                          width: maxWidth < 1366 ? 220 : 320,
                          height: 35,
                          items: controller.allDriverData?.drivers ?? [],
                          value: controller.allDriverData?.drivers?.any((d) => d.id == controller.selectDriverObject?.id) ?? false
                              ? controller.allDriverData!.drivers!.firstWhere((d) => d.id == controller.selectDriverObject?.id)
                              : null,
                          itemLabel: (driver) => "${driver.username} ${driver.name}" .toUpperCase(),
                          onChanged: (val) {
                            controller.selectDriverObject = val;
                            controller.update();
                          },
                        ),
                        SizedBox(width: maxWidth < 1366 ? 10 : 80),
                        CustomButton(
                          height: 30,
                          width: 60,
                          verticalPadding: 0.0,
                          borderRadius: 4,
                          onTap: () {
                            setState(() {
                              controller.loginFromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
                              controller.loginToDate.value = DateTime.now();
                              controller.selectDriverObject = null;
                              controller.driverLoginReportListModel = null;
                            });
                            controller.update();
                          },
                          widget: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0.0),
                            child: Icon(
                              Icons.refresh,
                              color: DynamicColors.whiteClr,
                              size: 25,
                            ),
                          ),
                        ),
                        CustomButton(
                          verticalPadding: 0.0,
                          width: 60,
                          height: 30,
                          borderRadius: 4,
                          btnText: AppText.filter,
                          style: mozillaTextRegularText(
                              fontSize: 10, color: DynamicColors.whiteClr),
                          onTap: () {
                            controller.getDriverShiftHistory();
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
                              if (controller.driverLoginReportListModel != null &&
                                  controller.driverLoginReportListModel!
                                      .driverShiftHistories != null) {
                                Get.dialog(DriverLoginViewWindow());
                              }
                            }
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Table Section
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                        child: controller.isLoadingShift.value
                            ? const Center(
                            child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: "DRIVER",
                                onChanged: (v) {
                                  controller.searchDrivers.value = v;
                                  controller.onSearchDriverShift();
                                }),
                            buildHeaderWithSearch(title: "BOOKINGS",
                                onChanged: (v) {
                                  controller.searchBookings.value = v;
                                  controller.onSearchDriverShift();
                                }),
                            buildHeaderWithSearch(title: "LOGIN DATE",
                                onChanged: (v) {
                                  controller.searchLoginDate.value = v;
                                  controller.onSearchDriverShift();
                                }),
                            buildHeaderWithSearch(title: "LOGIN TIME",
                                onChanged: (v) {
                                  controller.searchLoginTime.value = v;
                                  controller.onSearchDriverShift();
                                }),
                            buildHeaderWithSearch(title: "LOGOUT DATE",
                                onChanged: (v) {
                                  controller.searchLogoutDate.value = v;
                                  controller.onSearchDriverShift();
                                }),
                            buildHeaderWithSearch(title: "LOGOUT TIME",
                                onChanged: (v) {
                                  controller.searchLogoutTime.value = v;
                                  controller.onSearchDriverShift();
                                }),
                          ],
                          // totalRow: controller.driverLoginReportListModel?.driverShiftHistories?.length ?? 0,
                          // rows: (controller.driverLoginReportListModel?.driverShiftHistories ?? []).map((item) {
                          totalRow: listToShow.length,
                          rows: listToShow.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(Center(
                                    child: Text((item.driver?.username ?? "").toUpperCase()))),
                                DataCell(Center(
                                    child: Text(item.booking == null || item.booking!.isEmpty
                                        ? "0"
                                        : item.booking!.length.toString()))),
                                DataCell(Center(
                                    child: Text(item.loginDate != null
                                        ? DateFormat('dd-MM-yyyy').format(item.loginDate!)
                                        : "-"))),
                                DataCell(Center(
                                    child: Text(item.loginTime ?? "-"))),
                                DataCell(Center(
                                    child: Text(item.logoutDate != null
                                        ? DateFormat('dd-MM-yyyy').format(item.logoutDate!)
                                        : "-"))),
                                DataCell(Center(
                                    child: Text(item.logoutTime ?? "-"))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    PaginationWidget(
                      currentPage: controller.currentLoginPage.value,
                      totalPages: controller.totalLoginPages.value,
                      onPageChange: controller.onPageLogin,
                    ),
                  ],
                ),
              );
            });
          },
        ));
  }
}