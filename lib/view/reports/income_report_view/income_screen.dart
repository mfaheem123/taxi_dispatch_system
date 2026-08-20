import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/pagination.dart';
import '../../../component/radio_button_widget.dart';
import '../../../component/responsive_datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../customer/model/restricDriver.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';
import 'income_view_screen.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 50;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(initState: (state) {
      controller.clearIncomeData();
      controller.clearDropdowns();
      controller.selectDriverObject = null;
      controller.getAllDrivers();
      controller.getSubsidiary();
      controller.getData();

    }, builder: (controller) {

      final listToShow = controller.incomeBookingFiltered.isNotEmpty
          ? controller.incomeBookingFiltered
          : controller.incomeBookingAll;

      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        final double totalAvailableWidth = constraints.maxWidth;

        final double fieldWidth = isMobile
            ? maxWidth
            : isTablet
            ? maxWidth / 2
            : maxWidth / 4;

        return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  runSpacing: 16,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "REPORT TYPE",
                          style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        StatusRadioGroup(
                          options: [
                            "ALL",
                            "CASH",
                            "ACCOUNT",
                          ],
                          onChanged: (index, value) {
                            debugPrint("Selected index: $index, value: $value");
                            controller.selectedIncomePaymentType = value.toString().toUpperCase();
                            controller.update();
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 15),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      column: true,
                      width: fieldWidth / 2.2,
                      child: SizedBox(
                        height: 30,
                        child:  KeyboardDatePicker(
                          initialDate: controller.incomeFromDate.value,
                          onChanged: (date) =>
                              setState(() => controller.incomeFromDate.value = date),
                        ),
                      ),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.to,
                      column: true,
                      width: fieldWidth / 2.2,
                      child: SizedBox(
                        height: 30,
                        child: KeyboardDatePicker(
                          initialDate: controller.incomeToDate.value,
                          onChanged: (date) =>
                              setState(() => controller.incomeToDate.value = date),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    CustomDropdownField<DriverObject>(
                      label: "SELECT DRIVERS",
                      width: fieldWidth / 2,
                      // height: 35,
                      items: controller.allDriverData?.drivers ?? [],
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
                    SizedBox(width: 15),
                    CustomDropdownField<dynamic>(
                      width: fieldWidth / 1.5,
                      label: AppText.selectSubsidiary,
                      items: controller.subsDiaryModel?.subsidiaries ?? [],
                      // value: controller.apiSelectedSubsidiary,
                      value: controller.subsDiaryModel?.subsidiaries?.any((sub) => sub.id == controller.apiSelectedSubsidiary?.id) ?? false
                          ? controller.subsDiaryModel!.subsidiaries!.firstWhere((sub) => sub.id == controller.apiSelectedSubsidiary?.id)
                          : null,
                      itemLabel: (val) => (val.name ?? "").toUpperCase(),
                      onChanged: (val) {
                        controller.apiSelectedSubsidiary = val;
                        controller.apiSelectedAccount = null;

                        if (val != null && val.id != null) {
                          controller.getAccountData(val.id);
                        }
                        controller.update();
                      },
                    ),
                    CustomDropdownField<dynamic>(
                      width: fieldWidth / 1.9,
                      label: AppText.selectAccount,
                      items: controller.dashboardAccountModel?.accounts ?? [],
                      value: controller.apiSelectedAccount,
                      itemLabel: (val) => (val.name ?? "").toUpperCase(),
                      onChanged: (val) {
                        controller.apiSelectedAccount = val;
                        controller.update();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          width: 150,
                          height: 30,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          btnText: AppText.filter,
                          fontSize: 14,
                          onTap: () {
                            controller.getIncome();
                          },
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          width: 150,
                          height: 30,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          btnText: AppText.view,
                          fontSize: 14,
                          onTap: () {
                            Get.dialog(IncomeReportViewWindow());
                          },
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  color: DynamicColors.secondaryClr,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Total Bookings Row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${AppText.totalBookings} ",
                            style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            controller.incomeModel != null
                                ? "${controller.incomeModel?.totalBookings ?? 0}"
                                : "",
                            style: mozillaTextSemiBoldText(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      // Total Earnings Row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${AppText.totalEarnings} ",
                            style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            controller.incomeModel != null
                                ? "£${controller.incomeModel?.totalEarnings?.toStringAsFixed(2) ?? "0.00"}"
                                : "",
                            style: mozillaTextSemiBoldText(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                controller.isLoadingIncome.value
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : ResponsiveDataTableWidget(
                  totalWidth: totalAvailableWidth,
                  columnConfigs: [
                    TableColumnConfig(title: "REF #", sizeType: ColumnSizeType.medium,
                        onChanged: (v) {
                          controller.searchIncomeRef.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "DATETIME", sizeType: ColumnSizeType.medium,
                        onChanged: (v) {
                          controller.searchIncomeDateTime.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "PICKUP", sizeType: ColumnSizeType.large,
                        onChanged: (v) {
                          controller.searchIncomePickup.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "DROPOFF", sizeType: ColumnSizeType.large,
                        onChanged: (v) {
                          controller.searchIncomeDropoff.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "VEHICLE", sizeType: ColumnSizeType.medium,
                        onChanged: (v) {
                          controller.searchIncomeVehicle.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "DRIVER", sizeType: ColumnSizeType.medium,
                        onChanged: (v) {
                          controller.searchIncomeDriver.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "ACCOUNT", sizeType: ColumnSizeType.medium,
                        onChanged: (v) {
                          controller.searchIncomeAccount.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "FARES", sizeType: ColumnSizeType.small,
                        onChanged: (v) {
                          controller.searchIncomeFares.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "PARKING", sizeType: ColumnSizeType.small,
                        onChanged: (v) {
                          controller.searchIncomeParking.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "WAITING", sizeType: ColumnSizeType.small,
                        onChanged: (v) {
                          controller.searchIncomeWaiting.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "EXTRA DROP", sizeType: ColumnSizeType.small,
                        onChanged: (v) {
                          controller.searchIncomeExtraDrop.value = v;
                          controller.onSearchIncome();
                        }),
                    TableColumnConfig(title: "TOTAL", sizeType: ColumnSizeType.medium,
                        onChanged: (v) {
                          controller.searchIncomeTotal.value = v;
                          controller.onSearchIncome();
                        }),
                  ],
                  // items: controller.incomeModel?.bookings ?? [],
                  items: listToShow,
                  rowBuilder: (item, widths) {
                    String formattedDateTime = "-";
                    if (item.pickupDate != null) {
                      String date = DateFormat('dd-MM-yy').format(item.pickupDate!);
                      String time = item.pickupTime ?? "";
                      formattedDateTime = time.isNotEmpty ? "$date $time" : date;
                    }
                    return [
                      item.referenceNumber ?? "",
                      formattedDateTime,
                      (item.pickup ?? "").toUpperCase(),
                      (item.dropoff ?? "").toUpperCase(),
                      (item.vehicle ?? "").toUpperCase(),
                      (item.driverName ?? "").toUpperCase(),
                      item.account ?? "",
                      "£${item.fares ?? ""}",
                      "£${item.parking ?? ""}",
                      "£${item.waiting ?? ""}",
                      "£${item.extraDrop ?? ""}",
                      "£${item.total ?? ""}",
                    ];
                  },
                ),
                PaginationWidget(
                  currentPage: controller.currentIncomePage.value,
                  totalPages: controller.totalIncomePages.value,
                  onPageChange: controller.onPageIncome,
                ),
              ],
            ));
      });
    }
    );
  }
}