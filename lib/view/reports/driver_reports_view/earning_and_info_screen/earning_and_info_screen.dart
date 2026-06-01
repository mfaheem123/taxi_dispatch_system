import 'package:dashboard_new1/alert/restrict_drivers_alert.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/view/reports/driver_reports_view/earning_and_info_screen/vehicel_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/dropdown_button.dart';
import '../../../../component/text_widget.dart';
import '../../../customer/model/restricDriver.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/report_controller.dart';
import 'driver_statistics_chart.dart';

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

  // DateTime fromDate = DateTime.now();
  // DateTime toDate = DateTime.now();
  DateTime? fromDate;
  DateTime? toDate;

  bool isDataLoaded = false;
  int rightSideTab = 1;

  void handleView() {
    if (fromDate == null || toDate == null) {
      return;
    }
    controller.getAllDriverEarnings();
    setState(() {
      isDataLoaded = true;
      rightSideTab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      initState: (state) {
        controller.selectDriverObject = null;
        controller.getFilteredDrivers(status: "all");
      },
      builder: (controller) {
        return LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isMobile = maxWidth < 600;

          return SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // MAIN CONTAINER
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: DynamicColors.gryClr.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    // --- UPDATED HEADING ROW ---
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          // Left Heading
                          Expanded(
                            flex: 5,
                            child: Container(
                              color: DynamicColors.gryClr,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 12),
                              child: Text(
                                AppText.driverEarning,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                              width: 1, thickness: 1, color: Colors.grey),
                          Expanded(
                            flex: 5,
                            child: Container(
                              color: DynamicColors.gryClr,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 12),
                              child: Text(
                                "DRIVER INFORMATION",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Stack(
                      children: [
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: MediaQuery.of(context).size.width / 2 - 15,
                          child: Container(
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        // --- CONTENT ROW ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LEFT SIDE CONTENT
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 15,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.end,
                                      children: [
                                        labeledField(
                                          context: context,
                                          isMobile: isMobile,
                                          label: AppText.from,
                                          column: true,
                                          width: 130,
                                          child: SizedBox(
                                              height: 30,
                                              child: KeyboardDatePicker(
                                                initialDate: fromDate ?? DateTime.now(),
                                                onChanged: (date) {
                                                  setState(() => fromDate = date);
                                                  controller.fromDate.value = date;
                                                },
                                              )),
                                        ),
                                        labeledField(
                                          context: context,
                                          isMobile: isMobile,
                                          label: AppText.to,
                                          column: true,
                                          width: 130,
                                          child: SizedBox(
                                              height: 30,
                                              child: KeyboardDatePicker(
                                                initialDate: toDate ?? DateTime.now(),
                                                onChanged: (date) {
                                                  setState(() => toDate = date);
                                                  controller.toDate.value = date;
                                                },
                                              )),
                                        ),
                                        CustomButton(
                                          verticalPadding: 0.0,
                                          width: 60,
                                          height: 32,
                                          borderRadius: 4,
                                          fontSize: 12,
                                          btnText: AppText.all,
                                          btnColor: controller.selectedDriverType == "all" ? DynamicColors.primaryClr : Colors.grey.shade500,
                                          onTap: () {
                                            controller.selectedDriverType = "all";
                                            controller.update();
                                          },
                                        ),
                                        CustomButton(
                                          verticalPadding: 0.0,
                                          width: 60,
                                          height: 32,
                                          borderRadius: 4,
                                          fontSize: 12,
                                          btnText: AppText.login,
                                          btnColor: controller.selectedDriverType == "login" ? DynamicColors.primaryClr : Colors.grey.shade500,
                                          onTap: () {
                                            controller.selectedDriverType = "login";
                                            controller.update();
                                          },
                                        ),
                                        CustomButton(
                                          verticalPadding: 0.0,
                                          width: 60,
                                          height: 32,
                                          borderRadius: 4,
                                          fontSize: 12,
                                          btnText: "LOGOUT",
                                          btnColor: controller.selectedDriverType == "logout" ? DynamicColors.primaryClr : Colors.grey.shade500,
                                          onTap: () {
                                            controller.selectedDriverType = "logout";
                                            controller.update();
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        CustomButton(
                                          verticalPadding: 0.0,
                                          width: 60,
                                          height: 32,
                                          borderRadius: 4,
                                          fontSize: 12,
                                          btnText: AppText.view,
                                          onTap: () {
                                            handleView();
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        if (isDataLoaded) ...[
                                          // --- NEW SUMMARY ROW ---
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.05),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  color: Colors.blue
                                                      .withOpacity(0.2)),
                                            ),
                                            child: controller.isLoadingEarning
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      _summaryItem(
                                                          "TOTAL BOOKINGS",
                                                          "${controller.earningInfoListModel?.data?.totalBookings ?? 0}"),
                                                      _summaryItem(
                                                          "TOTAL AMOUNT",
                                                          "£ ${controller.earningInfoListModel?.data?.totalAmount?.toStringAsFixed(2) ?? '0.00'}"),
                                                    ],
                                                  ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    (controller.earningInfoListModel?.data?.drivers != null &&
                                        controller.earningInfoListModel!.data!.drivers!.isNotEmpty &&
                                        !controller.isLoadingEarning)
                                        ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Table(
                                            border: TableBorder.symmetric(
                                                inside: BorderSide(color: Colors.grey.shade300, width: 0.5)),
                                            columnWidths: const {
                                              0: FlexColumnWidth(1),   // Username
                                              1: FlexColumnWidth(1.5), // Driver Name
                                              2: FlexColumnWidth(1),   // Total Bookings
                                              3: FlexColumnWidth(1),   // Total Earnings
                                            },
                                            children: [
                                              // Table Header
                                              TableRow(
                                                decoration: BoxDecoration(color: Colors.grey.shade100),
                                                children: [
                                                  _tableHeader("USERNAME"),
                                                  _tableHeader("DRIVER"),
                                                  _tableHeader("TOTAL BOOKINGS"),
                                                  _tableHeader("TOTAL EARNINGS"),
                                                ],
                                              ),
                                              // if (!controller.isLoadingEarning && controller.earningInfoListModel?.data?.drivers != null)
                                                ...controller.earningInfoListModel!.data!.drivers!.map((driver) {
                                                  return TableRow(
                                                    children: [
                                                      _tableCell((driver.username ?? "-").toUpperCase()),
                                                      _tableCell((driver.name ?? "-").toUpperCase()),
                                                      _tableCell(driver.totalBookings ?? "0"),
                                                      _tableCell("£ ${driver.totalEarnings ?? "0.00"}"),
                                                    ],
                                                  );
                                                }).toList(),
                                            ],
                                          ),
                                    )
                                        : Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 50.0),
                                        child: Column(
                                          children: [
                                            controller.isLoadingEarning
                                                ? const CircularProgressIndicator()
                                                : Icon(
                                              Icons.block,
                                              size: 120,
                                              color: Colors.grey.withOpacity(0.3),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // RIGHT SIDE CONTENT
                            Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (isDataLoaded) ...[
                                          Row(
                                            children: [
                                              CustomButton(
                                                btnText: "STATISTICS",
                                                borderRadius: 4,
                                                verticalPadding: 0.0,
                                                width: 130,
                                                height: 30,
                                                fontSize: 14,
                                                btnColor: rightSideTab == 0
                                                    ? DynamicColors.primaryClr
                                                    : Colors.grey.shade500,
                                                onTap: () => setState(
                                                    () => rightSideTab = 0),
                                              ),
                                              const SizedBox(width: 10),
                                              CustomButton(
                                                btnText: "DRIVER INFORMATION",
                                                borderRadius: 4,
                                                verticalPadding: 0.0,
                                                width: 250,
                                                height: 30,
                                                fontSize: 14,
                                                btnColor: rightSideTab == 1
                                                    ? DynamicColors.primaryClr
                                                    : Colors.grey.shade500,
                                                onTap: () => setState(
                                                    () => rightSideTab = 1),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                        if (isDataLoaded && rightSideTab == 0)
                                          Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              // Chart Container
                                              Container(
                                                height: 400,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade200),
                                                ),
                                                child: DriverBookingChart(
                                                  chartData: controller.earningInfoListModel?.data?.drivers?.map((d) =>
                                                      DriverChartData(
                                                          d.username ?? "N/A",
                                                          int.tryParse(d.totalBookings ?? "0") ?? 0
                                                      )
                                                  ).toList() ?? [],
                                                ),
                                                // child: DriverBookingChart(
                                                //   chartData: [
                                                //     DriverChartData(
                                                //         "user_01", 45),
                                                //     DriverChartData(
                                                //         "user_02", 32),
                                                //     DriverChartData(
                                                //         "user_03", 58),
                                                //     DriverChartData(
                                                //         "user_04", 20),
                                                //     DriverChartData(
                                                //         "user_05", 38),
                                                //   ],
                                                // ),
                                              ),
                                            ],
                                          )
                                        else
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                spacing: 20,
                                                runSpacing: 15,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.end,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(AppText.driver,
                                                          style:
                                                              mozillaTextSemiBoldText(
                                                                  context:
                                                                      context,
                                                                  fontSize:
                                                                      12)),
                                                      const SizedBox(height: 5),
                                                      CustomDropdownField<
                                                          DriverObject>(
                                                        label: "SELECT DRIVERS",
                                                        width: 200,
                                                        height: 35,
                                                        items: controller.filteredDriverList,
                                                        value: controller.filteredDriverList.contains(controller.selectDriverObject)
                                                            ? controller.selectDriverObject
                                                            : null,
                                                        itemLabel: (driver) =>
                                                            (driver.name ?? "").toUpperCase(),
                                                        onChanged: (val) {
                                                          controller
                                                                  .selectDriverObject =
                                                              val;
                                                          controller.update();
                                                        },
                                                      ),
                                                      // RestrictedDrivers(
                                                      //   width: 200,
                                                      //   padding: 0.0,
                                                      //   border: Border.all(color: DynamicColors.gryClr),
                                                      //   titleText: AppText.selectDriver,
                                                      //   driversList: const ["Driver 01", "Driver 02", "Driver 03"],
                                                      // ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(AppText.driverStatus,
                                                          style:
                                                              mozillaTextSemiBoldText(
                                                                  context:
                                                                      context,
                                                                  fontSize:
                                                                      12)),
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CustomButton(
                                                            verticalPadding:
                                                                0.0,
                                                            width: 90,
                                                            height: 32,
                                                            borderRadius: 4,
                                                            fontSize: 12,
                                                            btnText:
                                                                AppText.active,
                                                            btnColor: controller.selectedStatus == "active"
                                                                ? DynamicColors.primaryClr
                                                                : Colors.grey.shade500,
                                                            onTap: () {
                                                              controller.getFilteredDrivers(status: "active");
                                                              },
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          CustomButton(
                                                            verticalPadding:
                                                                0.0,
                                                            width: 90,
                                                            height: 32,
                                                            borderRadius: 4,
                                                            fontSize: 12,
                                                            btnText:
                                                                "IN ACTIVE",
                                                            btnColor: controller.selectedStatus == "inactive"
                                                                ? DynamicColors.primaryClr
                                                                : Colors.grey.shade500,
                                                            onTap: () {
                                                              controller.getFilteredDrivers(status: "inactive");
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 60),
                                              controller.selectDriverObject !=
                                                      null
                                                  ? VehiclesScreen(
                                                      driverName: controller
                                                              .selectDriverObject!
                                                              .name ??
                                                          "")
                                                  : Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.folder_open,
                                                            size: 120,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          )
                                      ]),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ])),

              const SizedBox(height: 20),
            ],
          ));
        });
      },
    );
  }

  Widget _tableHeader(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _tableCell(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Row(
      children: [
        Text("$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
