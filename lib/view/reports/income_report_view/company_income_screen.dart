import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/component/responsive_datatable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';
import 'company_income_view.dart';

class CompanyIncomeScreen extends StatefulWidget {
  const CompanyIncomeScreen({super.key});

  @override
  State<CompanyIncomeScreen> createState() => _CompanyIncomeScreenState();
}

class _CompanyIncomeScreenState extends State<CompanyIncomeScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 50;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    final listToShow = controller.filteredCompany;
    // final listToShow = controller.filteredCompany.isNotEmpty
    //     ? controller.filteredCompany
    //     : controller.companyListAll;
    return GetBuilder<ReportController>(initState: (state) {
      // controller.getCompanyIncome();
    }, builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        final double totalAvailableWidth = constraints.maxWidth;
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
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      width: fieldWidth / 1.9,
                      column: true,
                      child: SizedBox(
                        height: 30,
                        child: KeyboardDatePicker(
                          initialDate: controller.companyFromDate.value,
                          onChanged: (date) {
                            controller.companyFromDate.value = date;
                            controller.update();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      column: true,
                      label: AppText.to,
                      width: fieldWidth / 1.9,
                      child: SizedBox(
                        height: 30,
                        child: KeyboardDatePicker(
                          initialDate: controller.companyToDate.value,
                          onChanged: (date) {
                            controller.companyToDate.value = date;
                            controller.update();
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.filter,
                      fontSize: 12,
                      onTap: () {
                        controller.getCompanyIncome();
                      },
                    ),
                    SizedBox(width: 10),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.view,
                      fontSize: 12,
                      onTap: () {
                        Get.dialog(CompanyIncomeViewWindow(),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: DynamicColors.secondaryClr,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        controller.companyIncomeModel == null
                            ? AppText.totalBookings
                            : "${AppText.totalBookings} ${controller.comTotalBookings.value}",
                        style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        controller.companyIncomeModel == null
                            ? AppText.totalEarnings
                            : "${AppText.totalEarnings} £${controller.comTotalEarnings.value.toStringAsFixed(2)}",
                        style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width,
                //     child: DatatableWidget(
                //       columns: [
                //         buildHeaderWithSearch(
                //           title: "REF #",
                //           onChanged: (v) {
                //             controller.searchReferenceNo.value = v;
                //             controller.onSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "DATETIME",
                //           onChanged: (v) {
                //             controller.searchDateTime.value = v;
                //             controller.onSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "PICKUP",
                //           onChanged: (v) {
                //             controller.searchPickup.value = v;
                //             controller.onSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "DROPOFF",
                //           onChanged: (v) {
                //             controller.searchDropOff.value = v;
                //             controller.onSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "VEHICLE",
                //           onChanged: (v) {
                //             controller.searchVehicle.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "DRIVER",
                //           onChanged: (v) {
                //             controller.searchDriver.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "ACCOUNT",
                //           onChanged: (v) {
                //             controller.searchAcc.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "FARES",
                //           onChanged: (v) {
                //             controller.searchFare.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "PC",
                //           onChanged: (v) {
                //             controller.searchPc.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "WC",
                //           onChanged: (v) {
                //             controller.searchWc.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "EDC",
                //           onChanged: (v) {
                //             controller.searchEdc.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "M&G",
                //           onChanged: (v) {
                //             controller.searchMg.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "CC",
                //           onChanged: (v) {
                //             controller.searchCc.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //         buildHeaderWithSearch(
                //           title: "TOTAL",
                //           onChanged: (v) {
                //             controller.searchTotal.value = v;
                //             controller.onLocalSearchCompany();
                //           },
                //         ),
                //       ],
                //       totalRow: listToShow.length,
                //       rows: listToShow.map((item) {
                //         return DataRow(
                //             cells: [
                //               DataCell(Center(
                //                   child: Text(item.referenceNumber ?? '—'))),
                //               DataCell(Center(
                //                   child: Text(
                //                       "${DateFormat('dd-MM-yyyy').format(item.pickupDate!)} ${item.pickupTime}"))),
                //               DataCell(Center(
                //                 child: Text((item.pickup ?? '').toUpperCase()))),
                //               DataCell(Center(
                //                   child: Text((item.dropoff ?? '').toUpperCase()))),
                //               DataCell(Center(
                //                   child:
                //                   Text((item.vehicleType?.name ?? '').toUpperCase()))),
                //               DataCell(Center(
                //                   child: Text((item.driver?.name ?? '').toUpperCase()))),
                //               DataCell(Center(
                //                   child: Text((item.account?.name ?? '').toUpperCase()))),
                //               DataCell(Center(
                //                   child: Text("£${item.fares?.toString() ?? ''}"))),
                //               DataCell(Center(
                //                   child: Text("£${item.parkingCharges?.toString() ?? ''}"))),
                //               DataCell(Center(
                //                   child: Text("£${item.waitingCharges?.toString() ?? ''}"))),
                //               DataCell(Center(
                //                   child: Text("£${item.extraDropCharges?.toString() ?? ''}"))),
                //               DataCell(Center(
                //                   child: Text("£${item.meetAndGreet?.toString() ?? ''}"))),
                //               DataCell(Center(
                //                   child: Text("£${item.congestionCharges?.toString() ?? ''}"))),
                //               DataCell(Center(
                //                   child: Text("£${item.totalCharges?.toString() ?? ''}"))),
                //
                //             ]);
                //       }).toList(),
                //     ),
                //   ),
                // ),
                ResponsiveDataTableWidget(
                    totalWidth: totalAvailableWidth,
                    columnConfigs: [
                      TableColumnConfig(title: "REF #",
                          sizeType: ColumnSizeType.medium,
                        onChanged: (v) {
                          controller.searchReferenceNo.value = v;
                          controller.onSearchCompany();
                        }
                      ),
                      TableColumnConfig(title: "DATETIME",
                          sizeType: ColumnSizeType.medium,
                          onChanged: (v) {
                            controller.searchDateTime.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "PICKUP",
                          sizeType: ColumnSizeType.large,
                          onChanged: (v) {
                            controller.searchPickup.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "DROPOFF",
                          sizeType: ColumnSizeType.large,
                          onChanged: (v) {
                            controller.searchDropOff.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "VEHICLE",
                          sizeType: ColumnSizeType.medium,
                          onChanged: (v) {
                            controller.searchVehicle.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "DRIVER",
                          sizeType: ColumnSizeType.medium,
                          onChanged: (v) {
                            controller.searchDriver.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "ACCOUNT",
                          sizeType: ColumnSizeType.medium,
                          onChanged: (v) {
                            controller.searchAcc.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "FARES",
                          sizeType: ColumnSizeType.small,
                          onChanged: (v) {
                            controller.searchFare.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "PC",
                          sizeType: ColumnSizeType.small,
                          onChanged: (v) {
                            controller.searchPc.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "WC",
                          sizeType: ColumnSizeType.small,
                          onChanged: (v) {
                            controller.searchWc.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "EDC",
                          sizeType: ColumnSizeType.small,
                          onChanged: (v) {
                            controller.searchEdc.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "M&G",
                          sizeType: ColumnSizeType.small,
                          onChanged: (v) {
                            controller.searchMg.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "CC",
                          sizeType: ColumnSizeType.small,
                          onChanged: (v) {
                            controller.searchCc.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                      TableColumnConfig(title: "TOTAL",
                          sizeType: ColumnSizeType.medium,
                          onChanged: (v) {
                            controller.searchTotal.value = v;
                            controller.onSearchCompany();
                          }
                      ),
                    ],
                  items: listToShow,
                  rowBuilder: (item, widths) {
                    // Date and Time Formatting
                    String formattedDateTime = "—";
                    if (item.pickupDate != null) {
                      String date = DateFormat('dd-MM-yyyy').format(item.pickupDate!);
                      String time = item.pickupTime ?? "";
                      formattedDateTime = time.isNotEmpty ? "$date $time" : date;
                    }

                    return [
                      item.referenceNumber ?? '—',
                      formattedDateTime,
                      (item.pickup ?? '').toUpperCase(),
                      (item.dropoff ?? '').toUpperCase(),
                      (item.vehicleType?.name ?? '').toUpperCase(),
                      (item.driver?.name ?? '').toUpperCase(),
                      (item.account?.name ?? '').toUpperCase(),
                      "£${item.fares?.toString() ?? ''}",
                      "£${item.parkingCharges?.toString() ?? ''}",
                      "£${item.waitingCharges?.toString() ?? ''}",
                      "£${item.extraDropCharges?.toString() ?? ''}",
                      "£${item.meetAndGreet?.toString() ?? ''}",
                      "£${item.congestionCharges?.toString() ?? ''}",
                      "£${item.totalCharges?.toString() ?? ''}",
                    ];
                  },
                ),
                PaginationWidget(
                  currentPage: controller.comCurrentPage.value,
                  totalPages: controller.comTotalPages.value,
                  onPageChange: controller.onPageCompany,
                )
              ],
            ));
      });
    });
  }
}
