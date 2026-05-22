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
                                  options: const ["ALL", "COMPLETED", "INCOMPLETE", "MISSED", "DECLINED", "CANCELLED"],
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
                                      style: mozillaTextRegularText(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 4),
                                    if (controller.apiDashboardData?.paymentTypes?.isNotEmpty ?? false)
                                      ...controller.apiDashboardData!.paymentTypes!.map((paymentType) {
                                        final int typeId = paymentType.id ?? 0;
                                        String typeLabel = "";
                                        try {
                                          typeLabel = (paymentType.name ?? "").toUpperCase();
                                        } catch (_) {
                                          typeLabel = paymentType.toString().toUpperCase();
                                        }

                                        return KeyboardCheckbox(
                                          focusNode: FocusNode(),
                                          value: controller.apiSelectedPaymentTypeIds.contains(typeId),
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
                                      initialDate:
                                          controller.bookingFromDate.value,
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
                                    controller:
                                        controller.bookingStartTimeController,
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
                                      initialDate:
                                          controller.bookingToDate.value,
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
                                    controller:
                                        controller.bookingEndTimeController,
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
                                  items:
                                      controller.allDriverData?.drivers ?? [],
                                  value: controller.allDriverData?.drivers?.any(
                                              (d) =>
                                                  d.id ==
                                                  controller.selectDriverObject
                                                      ?.id) ??
                                          false
                                      ? controller.allDriverData!.drivers!
                                          .firstWhere((d) =>
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
                                // CustomTextField(
                                //   borderRadius: 4,
                                //   controller: controller.pickUpController,
                                //   width: fieldWidth / 1.7,
                                //   hintText: "PICKUP",
                                // ),
                                // CustomTextField(
                                //   borderRadius: 4,
                                //   controller: controller.dropOffController,
                                //   width: fieldWidth / 1.7,
                                //   hintText: "DROPOFF",
                                // ),
                                // ----------------- PICKUP FIELD WITH AUTOCOMPLETE -----------------
                                (() {
                                  final ScrollController
                                      pickupScrollController =
                                      ScrollController();

                                  return SizedBox(
                                    width: fieldWidth / 1.2,
                                    height: 30,
                                    child: Autocomplete<String>(
                                      optionsBuilder: (TextEditingValue
                                          textEditingValue) async {
                                        if (textEditingValue.text.isEmpty) {
                                          return const Iterable<String>.empty();
                                        }
                                        return await controller
                                            .getSearchPostcodes(
                                                textEditingValue.text);
                                      },
                                      onSelected: (String selection) {
                                        controller.pickUpController.text =
                                            selection;
                                        controller.update();
                                      },
                                      optionsViewBuilder:
                                          (context, onSelected, options) {
                                        final int highlightedIndex =
                                            AutocompleteHighlightedOption.of(
                                                context);

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
                                          } else if (targetOffset <
                                              currentScroll) {
                                            pickupScrollController
                                                .jumpTo(targetOffset);
                                          }
                                        }

                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            elevation: 4.0,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 200),
                                              child: SizedBox(
                                                width: fieldWidth / 1.2,
                                                child: ListView.builder(
                                                  controller:
                                                      pickupScrollController,
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final String option =
                                                        options
                                                            .elementAt(index);
                                                    final bool highlight =
                                                        highlightedIndex ==
                                                            index;

                                                    return InkWell(
                                                      onTap: () =>
                                                          onSelected(option),
                                                      child: Container(
                                                        color: highlight
                                                            ? Colors.blue
                                                                .withOpacity(
                                                                    0.1)
                                                            : null,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0,
                                                                vertical: 8.0),
                                                        child: Text(
                                                          option,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
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
                                            hintStyle:
                                                const TextStyle(fontSize: 12),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 12),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                          ),
                                          onChanged: (val) {
                                            controller.pickUpController.text =
                                                val;
                                          },
                                        );
                                      },
                                    ),
                                  );
                                })(),
                                (() {
                                  final ScrollController
                                      dropoffScrollController =
                                      ScrollController();

                                  return SizedBox(
                                    width: fieldWidth / 1.2,
                                    height: 30,
                                    child: Autocomplete<String>(
                                      optionsBuilder: (TextEditingValue
                                          textEditingValue) async {
                                        if (textEditingValue.text.isEmpty) {
                                          return const Iterable<String>.empty();
                                        }
                                        return await controller
                                            .getSearchPostcodes(
                                                textEditingValue.text);
                                      },
                                      onSelected: (String selection) {
                                        controller.dropOffController.text =
                                            selection;
                                        controller.update();
                                      },
                                      optionsViewBuilder:
                                          (context, onSelected, options) {
                                        final int highlightedIndex =
                                            AutocompleteHighlightedOption.of(
                                                context);

                                        if (dropoffScrollController
                                                .hasClients &&
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
                                          } else if (targetOffset <
                                              currentScroll) {
                                            dropoffScrollController
                                                .jumpTo(targetOffset);
                                          }
                                        }

                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            elevation: 4.0,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 200),
                                              child: SizedBox(
                                                width: fieldWidth / 1.2,
                                                child: ListView.builder(
                                                  controller:
                                                      dropoffScrollController,
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final String option =
                                                        options
                                                            .elementAt(index);
                                                    final bool highlight =
                                                        highlightedIndex ==
                                                            index;

                                                    return InkWell(
                                                      onTap: () =>
                                                          onSelected(option),
                                                      child: Container(
                                                        color: highlight
                                                            ? Colors.blue
                                                                .withOpacity(
                                                                    0.1)
                                                            : null,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0,
                                                                vertical: 8.0),
                                                        child: Text(
                                                          option,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
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
                                            hintStyle:
                                                const TextStyle(fontSize: 12),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 12),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                          ),
                                          onChanged: (val) {
                                            controller.dropOffController.text =
                                                val;
                                          },
                                        );
                                      },
                                    ),
                                  );
                                })(),
                                CustomDropdownField<String>(
                                  width: fieldWidth / 1.9,
                                  label: AppText.selectAccount,
                                  items: [
                                    "ACCOUNT 1",
                                    "ACCOUNT 2",
                                    "ACCOUNT 3",
                                    "ACCOUNT 4",
                                    "ACCOUNT 5",
                                  ],
                                  value: controller.selectAccount,
                                  itemLabel: (val) => val,
                                  onChanged: (val) {
                                    controller.selectAccount = val!;
                                    controller.update();
                                  },
                                ),
                                CustomDropdownField<String>(
                                  width: fieldWidth / 1.9,
                                  label: AppText.selectDepartment,
                                  items: [
                                    "Department 1",
                                    "Department 2",
                                    "Department 3",
                                    "Department 4",
                                    "Department 5",
                                  ],
                                  value: controller.selectDepartment,
                                  itemLabel: (val) => val,
                                  onChanged: (val) {
                                    controller.selectDepartment = val!;
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
                                CustomDropdownField<String>(
                                  width: fieldWidth / 1.5,
                                  label: AppText.selectEmployee,
                                  items: [
                                    "Employee 1",
                                    "Employee 2",
                                    "Employee 3",
                                    "Employee 4",
                                    "Employee 5",
                                  ],
                                  value: controller.selectEmployee,
                                  itemLabel: (val) => val,
                                  onChanged: (val) {
                                    controller.selectEmployee = val!;
                                    controller.update();
                                  },
                                ),
                                // CustomDropdownField<String>(
                                //   // text: AppText.selectSubsidiary,
                                //   width: fieldWidth / 1.5,
                                //   label: AppText.selectSubsidiary,
                                //   items: [
                                //     "SUBSIDIARY 1",
                                //     "SUBSIDIARY 2",
                                //     "SUBSIDIARY 3",
                                //     "SUBSIDIARY 4",
                                //     "SUBSIDIARY 5",
                                //   ],
                                //   value: controller.selectSubsidiary,
                                //   itemLabel: (val) => val,
                                //   onChanged: (val) {
                                //     controller.selectSubsidiary = val!;
                                //     controller.update();
                                //   },
                                // ),
                                CustomDropdownField<dynamic>(
                                  width: fieldWidth / 1.5,
                                  label: AppText.selectSubsidiary,
                                  items: controller.apiDashboardData?.subsidiaries ?? [],
                                  value: controller.apiSelectedSubsidiary,
                                  itemLabel: (val) => (val.name ?? "").toUpperCase(),
                                  onChanged: (val) {
                                    controller.apiSelectedSubsidiary = val;
                                    controller.update();
                                  },
                                ),
                                CustomDropdownField<String>(
                                  // text: AppText.selectRefNumber,
                                  width: fieldWidth / 1.5,
                                  label: AppText.selectRefNumber,
                                  items: [
                                    "REFERENCE NUMBER 1",
                                    "REFERENCE NUMBER 2",
                                    "REFERENCE NUMBER 3",
                                    "REFERENCE NUMBER 4",
                                    "REFERENCE NUMBER 5",
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
                                  items: [
                                    "ASCENDING 1",
                                    "ASCENDING 2",
                                    "ASCENDING 3",
                                    "ASCENDING 4",
                                    "ASCENDING 5",
                                  ],
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
                                  onTap: () {
                                    controller.isFiltered.value = true;
                                    controller.totalBookings.value;
                                    controller.totalEarnings.value;
                                    controller.totalAccountEarnings.value;
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: "REF #"),
                            buildHeaderWithSearch(title: "INVOICE #"),
                            buildHeaderWithSearch(title: "DATETIME"),
                            buildHeaderWithSearch(title: "CUSTOMER"),
                            buildHeaderWithSearch(title: "PICKUP"),
                            buildHeaderWithSearch(title: "DROPOFF"),
                            buildHeaderWithSearch(title: "FARE"),
                            buildHeaderWithSearch(title: "ACC FARE"),
                            buildHeaderWithSearch(title: "ACC"),
                            buildHeaderWithSearch(title: "ORDER #"),
                            buildHeaderWithSearch(title: "P/T"),
                            buildHeaderWithSearch(title: "J/T"),
                            buildHeaderWithSearch(title: "DRV"),
                            buildHeaderWithSearch(title: "VEH"),
                            buildHeaderWithSearch(title: "SUBS"),
                            buildHeaderWithSearch(title: "STATUS"),
                            buildHeaderWithSearch(
                                title: "ACTION", removeSearching: true),
                          ],
                          totalRow: totalRows,
                          cells: [
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("20/10/2025"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("20/10/2025"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("20/10/2025"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("20/10/2025"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("20/10/2025"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            DataCell(
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Colors.transparent,
                                        ), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.edit_calendar,
                                        size: 28,
                                      ),
                                    ),
                                    Text("|"),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Colors.transparent,
                                        ), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.delete_forever,
                                        size: 28,
                                        color: DynamicColors.redClr,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                )
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
}
