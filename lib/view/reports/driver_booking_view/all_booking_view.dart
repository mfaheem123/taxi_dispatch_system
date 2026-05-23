import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/pagination.dart';
import '../../../component/radio_button_widget.dart';
import '../../../component/text_field.dart';
import '../../customer/model/restricDriver.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';
import 'booking_statistics.dart';
import 'booking_view_screen.dart';

class AllBookingView extends StatefulWidget {
  const AllBookingView({super.key});

  @override
  State<AllBookingView> createState() => _AllBookingViewState();
}

class _AllBookingViewState extends State<AllBookingView> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  // DateTime bookingFromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  // DateTime bookingToDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(initState: (state) {
      controller.selectDriverObject = null;
      controller.getAllDrivers();
      controller.getData();
      controller.getEmployeeData();
      controller.bookingStartTimeController.text = "12:00";
      controller.bookingEndTimeController.text =
          DateFormat('HH:mm').format(DateTime.now());
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
                Container(
                  padding: const EdgeInsetsGeometry.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: DynamicColors.gryClr),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            AppText.status,
                            style: mozillaTextRegularText(fontSize: 12),
                          ),
                          StatusRadioGroup(
                            options: const [
                              "ALL",
                              "COMPLETED",
                              "INCOMPLETE",
                              "MISSED",
                              "DECLINED",
                              "CANCELLED"
                            ],
                            onChanged: (index, value) {
                              controller.setSelectedStatusByName(value);
                            },
                          ),
                          const Spacer(),
                          Wrap(
                            spacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                AppText.pt,
                                style: mozillaTextRegularText(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              if (controller.apiDashboardData?.paymentTypes
                                      ?.isNotEmpty ??
                                  false)
                                ...controller.apiDashboardData!.paymentTypes!
                                    .map((paymentType) {
                                  final int typeId = paymentType.id ?? 0;
                                  String typeLabel = "";
                                  try {
                                    typeLabel =
                                        (paymentType.name ?? "").toUpperCase();
                                  } catch (_) {
                                    typeLabel =
                                        paymentType.toString().toUpperCase();
                                  }

                                  return KeyboardCheckbox(
                                    focusNode: FocusNode(),
                                    value: controller.apiSelectedPaymentTypeIds
                                        .contains(typeId),
                                    label: typeLabel,
                                    width: typeLabel.length > 10 ? 140 : 90,
                                    onChanged: (val) {
                                      controller.toggleApiPaymentType(typeId);
                                    },
                                  );
                                }).toList(),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 16,
                        children: [
                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: "FROM:",
                            column: false,
                            width: fieldWidth / 2.2,
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
                            isMobile: isMobile,
                            label: "",
                            column: false,
                            width: fieldWidth / 2.9,
                            child: CustomTimePicker(
                              controller: controller.bookingStartTimeController,
                              onTimeSelected: (time) => setState(() {}),
                            ),
                          ),
                          // To Date
                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: "TO:",
                            column: false,
                            width: fieldWidth / 2.2,
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

                          // End Time
                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: "",
                            column: false,
                            width: fieldWidth / 2.9,
                            child: CustomTimePicker(
                              controller: controller.bookingEndTimeController,
                              onTimeSelected: (time) => setState(() {}),
                            ),
                          ),

                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.customerController,
                            width: fieldWidth / 2.2,
                            hintText: AppText.customer,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.mobileController,
                            width: fieldWidth / 2.2,
                            hintText: "MOBILE",
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.phoneController,
                            width: fieldWidth / 2.2,
                            hintText: AppText.tel,
                          ),
                          CustomDropdownField<DriverObject>(
                            label: "SELECT DRIVERS",
                            width: fieldWidth / 2,
                            // height: 35,
                            items: controller.allDriverData?.drivers ?? [],
                            value: controller.allDriverData?.drivers?.any((d) =>
                                        d.id ==
                                        controller.selectDriverObject?.id) ??
                                    false
                                ? controller.allDriverData!.drivers!.firstWhere(
                                    (d) =>
                                        d.id ==
                                        controller.selectDriverObject?.id)
                                : null,
                            itemLabel: (driver) =>
                                driver.name ?? "".toUpperCase(),
                            onChanged: (val) {
                              controller.selectDriverObject = val;
                              controller.update();
                            },
                          ),
                          (() {
                            final ScrollController pickupScrollController =
                                ScrollController();

                            return SizedBox(
                              width: fieldWidth / 1.2,
                              height: 30,
                              child: Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) async {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return await controller.getSearchPostcodes(
                                      textEditingValue.text);
                                },
                                onSelected: (String selection) {
                                  controller.pickUpController.text = selection;
                                  controller.update();
                                },
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  final int highlightedIndex =
                                      AutocompleteHighlightedOption.of(context);

                                  if (pickupScrollController.hasClients &&
                                      highlightedIndex >= 0) {
                                    final double itemHeight = 32.0;
                                    final double currentScroll =
                                        pickupScrollController.offset;
                                    final double viewportHeight = 200.0;
                                    final double targetOffset =
                                        highlightedIndex * itemHeight;

                                    if (targetOffset + itemHeight >
                                        currentScroll + viewportHeight) {
                                      pickupScrollController.jumpTo(
                                          targetOffset +
                                              itemHeight -
                                              viewportHeight);
                                    } else if (targetOffset < currentScroll) {
                                      pickupScrollController
                                          .jumpTo(targetOffset);
                                    }
                                  }

                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4.0,
                                      borderRadius: BorderRadius.circular(4),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            maxHeight: 200),
                                        child: SizedBox(
                                          width: fieldWidth / 1.2,
                                          child: ListView.builder(
                                            controller: pickupScrollController,
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final String option =
                                                  options.elementAt(index);
                                              final bool highlight =
                                                  highlightedIndex == index;

                                              return InkWell(
                                                onTap: () => onSelected(option),
                                                child: Container(
                                                  color: highlight
                                                      ? Colors.blue
                                                          .withOpacity(0.1)
                                                      : null,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                                  child: Text(
                                                    option,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                fieldViewBuilder: (context,
                                    textEditingController,
                                    focusNode,
                                    onFieldSubmitted) {
                                  if (textEditingController.text !=
                                      controller.pickUpController.text) {
                                    textEditingController.text =
                                        controller.pickUpController.text;
                                  }
                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onSubmitted: (String value) =>
                                        onFieldSubmitted(),
                                    style: const TextStyle(fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: "PICKUP",
                                      hintStyle: const TextStyle(fontSize: 12),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 12),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                    ),
                                    onChanged: (val) {
                                      controller.pickUpController.text = val;
                                    },
                                  );
                                },
                              ),
                            );
                          })(),
                          (() {
                            final ScrollController dropoffScrollController =
                                ScrollController();

                            return SizedBox(
                              width: fieldWidth / 1.2,
                              height: 30,
                              child: Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) async {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return await controller.getSearchPostcodes(
                                      textEditingValue.text);
                                },
                                onSelected: (String selection) {
                                  controller.dropOffController.text = selection;
                                  controller.update();
                                },
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  final int highlightedIndex =
                                      AutocompleteHighlightedOption.of(context);

                                  if (dropoffScrollController.hasClients &&
                                      highlightedIndex >= 0) {
                                    final double itemHeight = 32.0;
                                    final double currentScroll =
                                        dropoffScrollController.offset;
                                    final double viewportHeight = 200.0;
                                    final double targetOffset =
                                        highlightedIndex * itemHeight;

                                    if (targetOffset + itemHeight >
                                        currentScroll + viewportHeight) {
                                      dropoffScrollController.jumpTo(
                                          targetOffset +
                                              itemHeight -
                                              viewportHeight);
                                    } else if (targetOffset < currentScroll) {
                                      dropoffScrollController
                                          .jumpTo(targetOffset);
                                    }
                                  }

                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4.0,
                                      borderRadius: BorderRadius.circular(4),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            maxHeight: 200),
                                        child: SizedBox(
                                          width: fieldWidth / 1.2,
                                          child: ListView.builder(
                                            controller: dropoffScrollController,
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final String option =
                                                  options.elementAt(index);
                                              final bool highlight =
                                                  highlightedIndex == index;

                                              return InkWell(
                                                onTap: () => onSelected(option),
                                                child: Container(
                                                  color: highlight
                                                      ? Colors.blue
                                                          .withOpacity(0.1)
                                                      : null,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                                  child: Text(
                                                    option,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                fieldViewBuilder: (context,
                                    textEditingController,
                                    focusNode,
                                    onFieldSubmitted) {
                                  if (textEditingController.text !=
                                      controller.dropOffController.text) {
                                    textEditingController.text =
                                        controller.dropOffController.text;
                                  }
                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onSubmitted: (String value) =>
                                        onFieldSubmitted(),
                                    style: const TextStyle(fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: "DROPOFF",
                                      hintStyle: const TextStyle(fontSize: 12),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 12),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                    ),
                                    onChanged: (val) {
                                      controller.dropOffController.text = val;
                                    },
                                  );
                                },
                              ),
                            );
                          })(),
                          CustomDropdownField<dynamic>(
                            width: fieldWidth / 1.9,
                            label: AppText.selectAccount,
                            items: controller.dashboardAccountModel?.accounts ??
                                [],
                            value: controller.apiSelectedAccount,
                            itemLabel: (val) => (val.name ?? "").toUpperCase(),
                            onChanged: (val) {
                              controller.apiSelectedAccount = val;

                              controller.apiSelectedDepartment = null;
                              controller.accountDepartmentsList.clear();

                              if (val != null && val.departments != null) {
                                controller.accountDepartmentsList
                                    .addAll(val.departments);
                              }
                              controller.update();
                            },
                          ),
                          CustomDropdownField<dynamic>(
                            width: fieldWidth / 1.9,
                            label: AppText.selectDepartment,
                            items: controller.accountDepartmentsList,
                            value: controller.apiSelectedDepartment,
                            itemLabel: (val) => (val.name ?? "").toUpperCase(),
                            onChanged: (val) {
                              controller.apiSelectedDepartment = val;
                              controller.update();
                            },
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.orderNumberController,
                            width: fieldWidth / 2,
                            hintText: AppText.orderNumber,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.bookedByController,
                            width: fieldWidth / 2,
                            hintText: AppText.bookedBy,
                          ),
                          CustomDropdownField<dynamic>(
                            width: fieldWidth / 1.5,
                            label: AppText.selectEmployee,
                            items: controller.userModel?.employees ?? [],
                            value: controller.apiSelectedEmployee,
                            itemLabel: (val) =>
                                (val.username ?? "").toUpperCase(),
                            onChanged: (val) {
                              controller.apiSelectedEmployee = val;
                              controller.update();
                            },
                          ),
                          CustomDropdownField<dynamic>(
                            width: fieldWidth / 1.5,
                            label: AppText.selectSubsidiary,
                            items:
                                controller.apiDashboardData?.subsidiaries ?? [],
                            value: controller.apiSelectedSubsidiary,
                            itemLabel: (val) => (val.name ?? "").toUpperCase(),
                            onChanged: (val) {
                              controller.apiSelectedSubsidiary = val;
                              controller.apiSelectedAccount = null;
                              controller.apiSelectedDepartment = null;

                              if (val != null && val.id != null) {
                                controller.getAccountData(val.id);
                              }
                              controller.update();
                            },
                          ),
                          CustomDropdownField<String>(
                            // text: AppText.selectRefNumber,
                            width: fieldWidth / 1.5,
                            label: AppText.selectRefNumber,
                            items: [
                              "REFERENCE NUMBER",
                              "DATETIME",
                              "CUSTOMER",
                              "MOBILE",
                              "TELEPHONE",
                              "PICKUP",
                              "DROPOFF",
                              "FARE",
                              "ACCOUNT",
                              "ORDER NUMBER",
                              "PAYMENT TYPE",
                              "DRIVER",
                              "VEHICLE TYPE",
                              "STATUS",
                            ],
                            value: controller.selectRefNumber,
                            itemLabel: (val) => val,
                            onChanged: (val) {
                              controller.selectRefNumber = val!;
                              controller.update();
                            },
                          ),
                          CustomDropdownField<String>(
                            // text: AppText.selectRefNumber,
                            width: fieldWidth / 1.5,
                            label: AppText.ascending,
                            items: ["ASCENDING", "DESCENDING"],
                            value: controller.selectAscending,
                            itemLabel: (val) => val,
                            onChanged: (val) {
                              controller.selectAscending = val!;
                              controller.update();
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          CustomButton(
                            width: 120,
                            height: 30,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.filter,
                            fontSize: 12,
                            onTap: () async {
                              controller.isFiltered.value = true;
                              await controller.getBookingStatistics();
                            },
                          ),
                          CustomButton(
                            width: 120,
                            height: 30,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.view,
                            fontSize: 12,
                            onTap: () {
                              Get.dialog(AllBookingViewWindow());
                            },
                          ),
                          CustomButton(
                            width: 120,
                            height: 30,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.statistics,
                            fontSize: 12,
                            onTap: () {
                              Get.dialog(BookingStatisticsWindow());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() => Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: DynamicColors.secondaryClr,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: DynamicColors.gryClr.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Total Bookings
                          _buildSummaryItem(
                            label: "TOTAL BOOKINGS",
                            value: controller.isFiltered.value
                                ? "£ ${controller.totalBookings.value}"
                                : "",
                          ),
                          // Total Earning
                          _buildSummaryItem(
                            label: "TOTAL EARNINGS",
                            value: controller.isFiltered.value
                                ? "£ ${controller.totalEarnings.value.toStringAsFixed(2)}"
                                : "",
                          ),
                          // Total Account Earning
                          _buildSummaryItem(
                            label: "TOTAL ACCOUNT EARNINGS",
                            value: controller.isFiltered.value
                                ? "£ ${controller.totalAccountEarnings.value.toStringAsFixed(2)}"
                                : "",
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 10),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     padding: const EdgeInsets.symmetric(horizontal: 4),
                //       child: DatatableWidget(
                //           columns: [
                //             buildHeaderWithSearch(title: "REF #"),
                //             buildHeaderWithSearch(title: "INVOICE #"),
                //             buildHeaderWithSearch(title: "DATETIME"),
                //             buildHeaderWithSearch(title: "CUSTOMER"),
                //             buildHeaderWithSearch(title: "PICKUP"),
                //             buildHeaderWithSearch(title: "DROPOFF"),
                //             buildHeaderWithSearch(title: "FARE"),
                //             buildHeaderWithSearch(title: "ACC FARE"),
                //             buildHeaderWithSearch(title: "ACC"),
                //             buildHeaderWithSearch(title: "ORDER #"),
                //             buildHeaderWithSearch(title: "P/T"),
                //             buildHeaderWithSearch(title: "J/T"),
                //             buildHeaderWithSearch(title: "DRV"),
                //             buildHeaderWithSearch(title: "VEH"),
                //             buildHeaderWithSearch(title: "SUBS"),
                //             buildHeaderWithSearch(title: "STATUS"),
                //             buildHeaderWithSearch(
                //                 title: "ACTION", removeSearching: true),
                //           ],
                //           totalRow: controller.bookingStatisticsModel?.data?.length ?? 0,
                //           rows: (controller.bookingStatisticsModel?.data ?? []).map((item) {
                //
                //             String formattedDateTime = "-";
                //             if (item.pickupDate != null) {
                //               String date = DateFormat('dd-MM-yyyy').format(item.pickupDate!);
                //               String time = item.pickupTime ?? "";
                //               formattedDateTime = "$date $time".trim();
                //             }
                //             return DataRow(
                //               cells: [
                //                 DataCell(Center(child: Text(item.referenceNumber ?? "-"))),
                //                 DataCell(Center(child: Text(item.invoiceNumber?.toString() ?? "-"))),
                //                 DataCell(Center(child: Text(formattedDateTime))),
                //                 DataCell(Center(child: Text((item.name ?? "-").toUpperCase()))),
                //                 DataCell(Center(child: Text(item.pickup ?? "-"))),
                //                 DataCell(Center(child: Text(item.dropoff ?? "-"))),
                //                 DataCell(Center(child: Text("£ ${item.fares ?? '0.00'}"))),
                //                 DataCell(Center(child: Text("£ ${item.companyPrice ?? '0.00'}"))),
                //                 DataCell(Center(child: Text((item.account?.name ?? "-").toUpperCase()))),
                //                 DataCell(Center(child: Text(item.orderNumber?.toString() ?? "-"))),
                //                 DataCell(Center(child: Text((item.paymentType?.name ?? "-").toUpperCase()))),
                //                 DataCell(Center(child: Text((item.journeyType?.journeyType ?? "-").toUpperCase()))),
                //                 DataCell(Center(child: Text((item.driver?.name ?? "-").toUpperCase()))),
                //                 DataCell(Center(child: Text((item.vehicleType?.name ?? "-").toUpperCase()))),
                //                 DataCell(Center(child: Text((item.subsidiary?.name ?? "-").toUpperCase()))),
                //                 DataCell(Center(child: Text((item.bookingStatus?.bookingStatus ?? "-").toUpperCase()))),
                //                 DataCell(
                //                   Center(
                //                     child: Row(
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         OutlinedButton(
                //                           style: OutlinedButton.styleFrom(
                //                             side: const BorderSide(
                //                               color: Colors.transparent,
                //                             ),
                //                           ),
                //                           onPressed: () {
                //                           },
                //                           child: const Icon(
                //                             Icons.edit_calendar,
                //                             size: 28,
                //                           ),
                //                         ),
                //                         const Text("|"),
                //                         OutlinedButton(
                //                           style: OutlinedButton.styleFrom(
                //                             side: const BorderSide(
                //                               color: Colors.transparent,
                //                             ),
                //                           ),
                //                           onPressed: () {
                //                           },
                //                           child: Icon(
                //                             Icons.delete_forever,
                //                             size: 28,
                //                             color: DynamicColors.redClr,
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             );
                //           }).toList()),
                //     ),
                //   ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.vertical,
                //     child: IntrinsicWidth(
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(horizontal: 4),
                //         child: DatatableWidget(
                //           columns: [
                //             buildHeaderWithSearch(title: "REF #",
                //             onChanged: (v) {
                //               controller.searchReferenceNo.value = v;
                //               controller.onBookingSearchChanged();
                //             }),
                //             buildHeaderWithSearch(title: "INVOICE #",
                //                 onChanged: (v) {
                //                   controller.searchInvoiceNo.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "DATETIME",
                //                 onChanged: (v) {
                //                   controller.searchDateTime.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "CUSTOMER",
                //                 onChanged: (v) {
                //                   controller.searchCustomer.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "PICKUP",
                //                 onChanged: (v) {
                //                   controller.searchPickup.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "DROPOFF",
                //                 onChanged: (v) {
                //                   controller.searchDropOff.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "FARE",
                //                 onChanged: (v) {
                //                   controller.searchFare.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "ACC FARE",
                //                 onChanged: (v) {
                //                   controller.searchAccFare.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "ACC",
                //                 onChanged: (v) {
                //                   controller.searchAcc.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "ORDER #",
                //                 onChanged: (v) {
                //                   controller.searchOrderNO.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "P/T",
                //                 onChanged: (v) {
                //                   controller.searchPaymentType.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "J/T",
                //                 onChanged: (v) {
                //                   controller.searchJourneyType.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "DRV",
                //                 onChanged: (v) {
                //                   controller.searchDriver.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "VEH",
                //                 onChanged: (v) {
                //                   controller.searchVehicle.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "SUBS",
                //                 onChanged: (v) {
                //                   controller.searchSubsidiary.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "STATUS",
                //                 onChanged: (v) {
                //                   controller.searchStatus.value = v;
                //                   controller.onBookingSearchChanged();
                //                 }),
                //             buildHeaderWithSearch(title: "ACTION", removeSearching: true),
                //           ],
                //           totalRow: controller.bookingStatisticsModel?.data?.length ?? 0,
                //           rows: List<DataRow>.generate(
                //             (controller.bookingStatisticsModel?.data ?? []).length,
                //                 (index) {
                //               var item = controller.bookingStatisticsModel!.data![index];
                //
                //               String formattedDateTime = "-";
                //               if (item.pickupDate != null) {
                //                 String date = DateFormat('dd-MM-yyyy').format(item.pickupDate!);
                //                 String time = item.pickupTime ?? "";
                //                 formattedDateTime = "$date $time".trim();
                //               }
                //
                //               return DataRow(
                //                 cells: [
                //                   DataCell(Center(child: Text(item.referenceNumber ?? "-", maxLines: 1))),
                //                   DataCell(Center(child: Text(item.invoiceNumber?.toString() ?? "-", maxLines: 1))),
                //                   DataCell(Center(child: Text(formattedDateTime, maxLines: 1))),
                //                   DataCell(Center(child: Text((item.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //
                //                   // PICKUP
                //                   DataCell(
                //                     SizedBox(
                //                       width: 150,
                //                       child: Text(
                //                         item.pickup ?? "-",
                //                         maxLines: 1,
                //                         overflow: TextOverflow.ellipsis,
                //                       ),
                //                     ),
                //                   ),
                //
                //                   // DROPOFF
                //                   DataCell(
                //                     SizedBox(
                //                       width: 150,
                //                       child: Text(
                //                         item.dropoff ?? "-",
                //                         maxLines: 1,
                //                         overflow: TextOverflow.ellipsis,
                //                       ),
                //                     ),
                //                   ),
                //                   DataCell(
                //                     Center(
                //                       child: Obx(() {
                //                         bool isEditing = controller.editingRowIndex.value == index;
                //                         return isEditing
                //                             ? SizedBox(
                //                           width: 90,
                //                           child: TextField(
                //                             controller: controller.fareController,
                //                             keyboardType: const TextInputType.numberWithOptions(decimal: true),
                //                             autofocus: true,
                //                             style: const TextStyle(fontSize: 14, color: Colors.black),
                //                             decoration: const InputDecoration(
                //                               prefixText: "£ ",
                //                               isDense: true,
                //                               contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                //                               border: OutlineInputBorder(),
                //                             ),
                //                           ),
                //                         )
                //                             : Text("£ ${item.fares ?? '0.00'}", maxLines: 1);
                //                       }),
                //                     ),
                //                   ),
                //
                //                   DataCell(Center(child: Text("£ ${item.companyPrice ?? '0.00'}", maxLines: 1))),
                //                   DataCell(Center(child: Text((item.account?.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //                   DataCell(Center(child: Text(item.orderNumber?.toString() ?? "-", maxLines: 1))),
                //                   DataCell(Center(child: Text((item.paymentType?.name ?? "-").toUpperCase(), maxLines: 1))),
                //                   DataCell(Center(child: Text((item.journeyType?.journeyType ?? "-").toUpperCase(), maxLines: 1))),
                //                   DataCell(Center(child: Text((item.driver?.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //                   DataCell(Center(child: Text((item.vehicleType?.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //                   DataCell(Center(child: Text((item.subsidiary?.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //                   DataCell(Center(child: Text((item.bookingStatus?.bookingStatus ?? "-").toUpperCase(), maxLines: 1))),
                //                   DataCell(
                //                     Center(
                //                       child: Obx(() {
                //                         bool isEditing = controller.editingRowIndex.value == index;
                //                         return ElevatedButton(
                //                           style: ElevatedButton.styleFrom(
                //                             backgroundColor: isEditing ? Colors.green : DynamicColors.gryClr,
                //                             foregroundColor: Colors.white,
                //                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //                             shape: RoundedRectangleBorder(
                //                               borderRadius: BorderRadius.circular(8),
                //                             ),
                //                           ),
                //                           onPressed: () {
                //                             if (isEditing) {
                //                               item.fares = controller.fareController.text;
                //                               controller.editingRowIndex.value = null;
                //                             } else {
                //                               controller.fareController.text = item.fares ?? '0.00';
                //                               controller.editingRowIndex.value = index;
                //                             }
                //                           },
                //                           child: Text(isEditing ? "SAVE" : "EDIT"),
                //                         );
                //                       }),
                //                     ),
                //                   ),
                //                 ],
                //               );
                //             },
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // PaginationWidget(
                //     currentPage: controller.currentPage.value,
                //     totalPages: controller.totalPages.value,
                //     onPageChange: controller.onBookingPageChange)

                Obx(() {
                  var dataList = controller.bookingStatisticsModel?.data ?? [];

                  // 17 Columns ki customized fixed widths (Pixels mein)
                  final List<double> colWidths = [
                    90, // 0. REF #
                    80, // 1. INVOICE #
                    60, // 2. DATETIME
                    60, // 3. CUSTOMER
                    70, // 4. PICKUP
                    70, // 5. DROPOFF
                    50, // 6. FARE
                    50, // 7. ACC FARE
                    50, // 8. ACC
                    50, // 9. ORDER #
                    50, // 10. P/T
                    50, // 11. J/T
                    60, // 12. DRV
                    50, // 13. VEH
                    50, // 14. SUBS
                    50, // 15. STATUS
                    50, // 16. ACTION
                  ];

                  // Total width saari columns ka sum hai
                  double totalTableWidth = colWidths.reduce((a, b) => a + b);

                  return Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ==========================================
                        // 1. SCROLLABLE CUSTOM TABLE AREA
                        // ==========================================
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: totalTableWidth,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // --- A. CUSTOM HEADER ROW ---
                                Container(
                                  color: Colors.grey[200],
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      _buildCustomHeaderCell(
                                          colWidths[0],
                                          buildHeaderWithSearch(
                                              title: "REF #",
                                              onChanged: (v) {
                                                controller.searchReferenceNo
                                                    .value = v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[1],
                                          buildHeaderWithSearch(
                                              title: "INVOICE #",
                                              onChanged: (v) {
                                                controller
                                                    .searchInvoiceNo.value = v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[2],
                                          buildHeaderWithSearch(
                                              title: "DATETIME",
                                              onChanged: (v) {
                                                controller
                                                    .searchDateTime.value = v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[3],
                                          buildHeaderWithSearch(
                                              title: "CUSTOMER",
                                              onChanged: (v) {
                                                controller
                                                    .searchCustomer.value = v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[4],
                                          buildHeaderWithSearch(
                                              title: "PICKUP",
                                              onChanged: (v) {
                                                controller.searchPickup.value =
                                                    v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[5],
                                          buildHeaderWithSearch(
                                              title: "DROPOFF",
                                              onChanged: (v) {
                                                controller.searchDropOff.value =
                                                    v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[6],
                                          buildHeaderWithSearch(
                                              title: "FARE",
                                              onChanged: (v) {
                                                controller.searchFare.value = v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[7],
                                          buildHeaderWithSearch(
                                              title: "ACC FARE",
                                              onChanged: (v) {
                                                controller.searchAccFare.value =
                                                    v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[8],
                                          buildHeaderWithSearch(
                                              title: "ACC",
                                              onChanged: (v) {
                                                controller.searchAcc.value = v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[9],
                                          buildHeaderWithSearch(
                                              title: "ORDER #",
                                              onChanged: (v) {
                                                controller.searchOrderNO.value =
                                                    v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[10],
                                          buildHeaderWithSearch(
                                              title: "P/T",
                                              onChanged: (v) {
                                                controller.searchPaymentType
                                                    .value = v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[11],
                                          buildHeaderWithSearch(
                                              title: "J/T",
                                              onChanged: (v) {
                                                controller.searchJourneyType
                                                    .value = v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[12],
                                          buildHeaderWithSearch(
                                              title: "DRV",
                                              onChanged: (v) {
                                                controller.searchDriver.value =
                                                    v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[13],
                                          buildHeaderWithSearch(
                                              title: "VEH",
                                              onChanged: (v) {
                                                controller.searchVehicle.value =
                                                    v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[14],
                                          buildHeaderWithSearch(
                                              title: "SUBS",
                                              onChanged: (v) {
                                                controller
                                                    .searchSubsidiary.value = v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[15],
                                          buildHeaderWithSearch(
                                              title: "STATUS",
                                              onChanged: (v) {
                                                controller.searchStatus.value =
                                                    v;
                                                controller
                                                    .onBookingSearchChanged();
                                              }).label),
                                      _buildCustomHeaderCell(
                                          colWidths[16],
                                          buildHeaderWithSearch(
                                              title: "ACTION",
                                              removeSearching: true).label),
                                    ],
                                  ),
                                ),
                                const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.grey),

                                // --- B. DATA ROWS LIST ---
                                if (dataList.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.all(30.0),
                                    child: Center(
                                        child: Text("No Data Found",
                                            style: TextStyle(fontSize: 16))),
                                  )
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: dataList.length,
                                    itemBuilder: (context, index) {
                                      var item = dataList[index];

                                      String formattedDateTime = "-";
                                      if (item.pickupDate != null) {
                                        String date = DateFormat('dd-MM-yyyy')
                                            .format(item.pickupDate!);
                                        String time = item.pickupTime ?? "";
                                        formattedDateTime =
                                            "$date $time".trim();
                                      }

                                      return Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.5)),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            _buildCustomDataCell(
                                                colWidths[0],
                                                Text(
                                                    item.referenceNumber ?? "-",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            _buildCustomDataCell(
                                                colWidths[1],
                                                Text(
                                                    item.invoiceNumber
                                                            ?.toString() ??
                                                        "-",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            _buildCustomDataCell(
                                                colWidths[2],
                                                Text(formattedDateTime,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            _buildCustomDataCell(
                                                colWidths[3],
                                                Text(
                                                    (item.name ?? "-")
                                                        .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            _buildCustomDataCell(
                                                colWidths[4],
                                                Text(item.pickup ?? "-",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                alignment:
                                                    Alignment.centerLeft),
                                            _buildCustomDataCell(
                                                colWidths[5],
                                                Text(item.dropoff ?? "-",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                alignment:
                                                    Alignment.centerLeft),

                                            // 6. FARE (EDITABLE)
                                            _buildCustomDataCell(colWidths[6],
                                                Obx(() {
                                              bool isEditing = controller
                                                      .editingRowIndex.value ==
                                                  index;
                                              return isEditing
                                                  ? SizedBox(
                                                      width: 85,
                                                      height: 32,
                                                      child: TextField(
                                                        controller: controller
                                                            .fareController,
                                                        keyboardType:
                                                            const TextInputType
                                                                .numberWithOptions(
                                                                decimal: true),
                                                        autofocus: true,
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black),
                                                        decoration:
                                                            const InputDecoration(
                                                          prefixText: "£ ",
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4,
                                                                      vertical:
                                                                          6),
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                      ),
                                                    )
                                                  : Text(
                                                      "£ ${item.fares ?? '0.00'}",
                                                      maxLines: 1);
                                            })),

                                            _buildCustomDataCell(
                                                colWidths[7],
                                                Text(
                                                    "£ ${item.companyPrice ?? '0.00'}",
                                                    maxLines: 1)),
                                            _buildCustomDataCell(
                                                colWidths[8],
                                                Text(
                                                    (item.account?.name ?? "-")
                                                        .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            _buildCustomDataCell(
                                                colWidths[9],
                                                Text(
                                                    item.orderNumber
                                                            ?.toString() ??
                                                        "-",
                                                    maxLines: 1)),
                                            _buildCustomDataCell(
                                                colWidths[10],
                                                Text(
                                                    (item.paymentType?.name ??
                                                            "-")
                                                        .toUpperCase(),
                                                    maxLines: 1)),
                                            _buildCustomDataCell(
                                                colWidths[11],
                                                Text(
                                                    (item.journeyType
                                                                ?.journeyType ??
                                                            "-")
                                                        .toUpperCase(),
                                                    maxLines: 1)),
                                            _buildCustomDataCell(
                                                colWidths[12],
                                                Text(
                                                    (item.driver?.name ?? "-")
                                                        .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            _buildCustomDataCell(
                                                colWidths[13],
                                                Text(
                                                    (item.vehicleType?.name ??
                                                            "-")
                                                        .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            _buildCustomDataCell(
                                                colWidths[14],
                                                Text(
                                                    (item.subsidiary?.name ??
                                                            "-")
                                                        .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            _buildCustomDataCell(
                                                colWidths[15],
                                                Text(
                                                    (item.bookingStatus
                                                                ?.bookingStatus ??
                                                            "-")
                                                        .toUpperCase(),
                                                    maxLines: 1)),

                                            // 16. ACTION
                                            _buildCustomDataCell(colWidths[16],
                                                Obx(() {
                                              bool isEditing = controller
                                                      .editingRowIndex.value ==
                                                  index;
                                              return SizedBox(
                                                height: 28,
                                                width: 75,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: isEditing
                                                        ? Colors.green
                                                        : Colors.grey[700],
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                  ),
                                                  onPressed: () {
                                                    if (isEditing) {
                                                      item.fares = controller
                                                          .fareController.text;
                                                      controller.editingRowIndex
                                                          .value = null;
                                                    } else {
                                                      controller.fareController
                                                              .text =
                                                          item.fares ?? '0.00';
                                                      controller.editingRowIndex
                                                          .value = index;
                                                    }
                                                  },
                                                  child: Text(
                                                      isEditing
                                                          ? "SAVE"
                                                          : "EDIT",
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              );
                                            })),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // ==========================================
                        // 2. FIXED BOTTOM PAGINATION WIDGET
                        // ==========================================
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: PaginationWidget(
                            currentPage: controller.currentPage.value,
                            totalPages: controller.totalPages.value,
                            onPageChange: controller.onBookingPageChange,
                          ),
                        ),
                      ],
                    ),
                  );
                })
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.vertical,
                //     child: IntrinsicWidth(
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(horizontal: 4),
                //         child: DatatableWidget(
                //           columns: [
                //             buildHeaderWithSearch(title: "REF #"),
                //             buildHeaderWithSearch(title: "INVOICE #"),
                //             buildHeaderWithSearch(title: "DATETIME"),
                //             buildHeaderWithSearch(title: "CUSTOMER"),
                //             buildHeaderWithSearch(title: "PICKUP"),
                //             buildHeaderWithSearch(title: "DROPOFF"),
                //             buildHeaderWithSearch(title: "FARE"),
                //             buildHeaderWithSearch(title: "ACC FARE"),
                //             buildHeaderWithSearch(title: "ACC"),
                //             buildHeaderWithSearch(title: "ORDER #"),
                //             buildHeaderWithSearch(title: "P/T"),
                //             buildHeaderWithSearch(title: "J/T"),
                //             buildHeaderWithSearch(title: "DRV"),
                //             buildHeaderWithSearch(title: "VEH"),
                //             buildHeaderWithSearch(title: "SUBS"),
                //             buildHeaderWithSearch(title: "STATUS"),
                //             buildHeaderWithSearch(title: "ACTION", removeSearching: true),
                //           ],
                //           totalRow: controller.bookingStatisticsModel?.data?.length ?? 0,
                //           rows: (controller.bookingStatisticsModel?.data ?? []).map((item) {
                //             String formattedDateTime = "-";
                //             if (item.pickupDate != null) {
                //               String date = DateFormat('dd-MM-yyyy').format(item.pickupDate!);
                //               String time = item.pickupTime ?? "";
                //               formattedDateTime = "$date $time".trim();
                //             }
                //             return DataRow(
                //               cells: [
                //                 DataCell(Center(child: Text(item.referenceNumber ?? "-", maxLines: 1))),
                //                 DataCell(Center(child: Text(item.invoiceNumber?.toString() ?? "-", maxLines: 1))),
                //                 DataCell(Center(child: Text(formattedDateTime, maxLines: 1))),
                //                 DataCell(Center(child: Text((item.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //                 DataCell(
                //                   SizedBox(
                //                     width: 150,
                //                     child: Text(
                //                       item.pickup ?? "-",
                //                       maxLines: 1,
                //                       overflow: TextOverflow.ellipsis,
                //                     ),
                //                   ),
                //                 ),
                //                 DataCell(
                //                   SizedBox(
                //                     width: 150,
                //                     child: Text(
                //                       item.dropoff ?? "-",
                //                       maxLines: 1,
                //                       overflow: TextOverflow.ellipsis,
                //                     ),
                //                   ),
                //                 ),
                //
                //                 DataCell(Center(child: Text("£ ${item.fares ?? '0.00'}", maxLines: 1))),
                //                 DataCell(Center(child: Text("£ ${item.companyPrice ?? '0.00'}", maxLines: 1))),
                //                 DataCell(Center(child: Text((item.account?.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //                 DataCell(Center(child: Text(item.orderNumber?.toString() ?? "-", maxLines: 1))),
                //                 DataCell(Center(child: Text((item.paymentType?.name ?? "-").toUpperCase(), maxLines: 1))),
                //                 DataCell(Center(child: Text((item.journeyType?.journeyType ?? "-").toUpperCase(), maxLines: 1))),
                //                 DataCell(Center(child: Text((item.driver?.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //                 DataCell(Center(child: Text((item.vehicleType?.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //                 DataCell(Center(child: Text((item.subsidiary?.name ?? "-").toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis))),
                //                 DataCell(Center(child: Text((item.bookingStatus?.bookingStatus ?? "-").toUpperCase(), maxLines: 1))),
                //                 DataCell(
                //                   Center(
                //                     child: ElevatedButton(
                //                       style: ElevatedButton.styleFrom(
                //                         backgroundColor: DynamicColors.gryClr,
                //                         foregroundColor: Colors.white,
                //                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //                         shape: RoundedRectangleBorder(
                //                           borderRadius: BorderRadius.circular(8),
                //                         ),
                //                       ),
                //                       onPressed: () {
                //
                //                       },
                //                       child: const Text("EDIT"),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ));
      });
    });
  }

  Widget _buildSummaryItem({required String label, required String value}) {
    return Row(
      children: [
        Text(
          "$label: ",
          style:
              mozillaTextRegularText(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style:
              mozillaTextRegularText(fontSize: 13, color: Colors.blue.shade800),
        ),
      ],
    );
  }

  Widget _buildCustomHeaderCell(double width, Widget child) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: child,
      ),
    );
  }

  Widget _buildCustomDataCell(double width, Widget child,
      {Alignment alignment = Alignment.center}) {
    return SizedBox(
      width: width,
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: child,
      ),
    );
  }
}
