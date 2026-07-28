import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/customer/model/search_customer_by_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  @override
  Widget build(BuildContext context) {
    double widthss = MediaQuery.of(context).size.width;
    return GetBuilder<ReportController>(initState: (state) {
      controller.clearDropdowns();
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
        final bool isHighScale = MediaQuery.of(context).devicePixelRatio >= 1.25;

        // Instead of fixed width, we calculate flexible field widths
        double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
            ? maxWidth / 2
            : maxWidth / 4;

        if (!isMobile && isHighScale) {
          fieldWidth = maxWidth / 4.8;
        }

        // final double cellWidth = (widthss - 80) / 16;
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
                          // CustomTextField(
                          //   borderRadius: 4,
                          //   controller: controller.mobileController,
                          //   width: fieldWidth / 2.2,
                          //   hintText: "MOBILE",
                          // ),

                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: "",
                            column: false,
                            width: fieldWidth / 2.2,
                            child: RawAutocomplete<SearchCustomer>(
                              textEditingController: controller.mobileController,
                              focusNode: FocusNode(),
                              displayStringForOption: (SearchCustomer option) => option.mobile ?? '',
                              optionsBuilder: (TextEditingValue textEditingValue) async {
                                if (textEditingValue.text.trim().isEmpty) {
                                  return const Iterable<SearchCustomer>.empty();
                                }

                                // API Search Call
                                await controller.getCustomer(textEditingValue.text);

                                return controller.searchCustomerByMobile?.customer ?? [];
                              },
                              onSelected: (SearchCustomer selection) {
                                // Auto-fill selected data
                                controller.mobileController.text = selection.mobile ?? '';
                                controller.customerController.text = selection.name ?? '';
                                controller.phoneController.text = selection.telephone ?? '';
                                controller.update();
                              },
                              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                return CustomTextField(
                                  borderRadius: 4,
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  width: fieldWidth / 2.2,
                                  hintText: "MOBILE",
                                );
                              },
                              optionsViewBuilder: (context, onSelected, options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 6.0,
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      width: fieldWidth / 2.2,
                                      constraints: const BoxConstraints(maxHeight: 220),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final SearchCustomer option = options.elementAt(index);
                                          final bool isHighlighted = AutocompleteHighlightedOption.of(context) == index;

                                          if (isHighlighted) {
                                            SchedulerBinding.instance.addPostFrameCallback((_) {
                                              Scrollable.ensureVisible(context, alignment: 0.5);
                                            });
                                          }

                                          return InkWell(
                                            onTap: () => onSelected(option),
                                            child: Container(
                                              color: isHighlighted
                                                  ? Colors.blue.withOpacity(0.15)
                                                  : Colors.transparent,
                                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  // Customer Name
                                                  Flexible(
                                                    child: Text(
                                                      option.name ?? '',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 13,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // Customer Mobile
                                                  Text(
                                                    option.mobile ?? '',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey.shade700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.phoneController,
                            width: fieldWidth / 2.2,
                            hintText: AppText.tel,
                          ),
                          CustomDropdownField<DriverObject>(
                            label: "SELECT DRIVERS",
                            width: maxWidth < 1366 ? fieldWidth / 1.8 : fieldWidth / 2,
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
                                      hintStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),
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
                                                        fontSize: 12, fontWeight: FontWeight.bold,),
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
                                      hintStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),
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
                            width: maxWidth < 1400 ? fieldWidth / 1.7 : fieldWidth / 1.9,
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
                          CustomDropdownField<dynamic>(
                            width: maxWidth < 1400 ? fieldWidth / 1.7 : fieldWidth / 1.9,
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
                            width: maxWidth < 1400 ? fieldWidth / 1.7 : fieldWidth / 1.9,
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
                              String? statusId = controller
                                  .apiSelectedBookingStatus?.id
                                  ?.toString();
                              controller.getBookingStatisticsGraph(
                                  statusId: statusId);

                              // Get.dialog(BookingStatisticsWindow());
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

                GetBuilder<ReportController>(
                  builder: (reportingCtrl) {
                    var dataList = reportingCtrl.bookingStatisticsModel?.data ?? [];


                    final double baseWidth = widthss - 90;
                    final double smallCellWidth = baseWidth / 20;
                    final double largeCellWidth = baseWidth / 14;
                    const double actionCellWidth = 65.0;

                    Widget buildCenteredCellText(String text, double width) {
                      return SizedBox(
                        width: width,
                        child: Text(
                          text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      );
                    }

                    return SizedBox(
                      width: widthss,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DataTable(
                            headingRowColor: MaterialStateProperty.all(DynamicColors.gryClr),
                            columnSpacing: 1.0,
                            horizontalMargin: 4.0,
                            dataRowMinHeight: 40,
                            dataRowMaxHeight: 48,
                            headingTextStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                            border: TableBorder(
                              horizontalInside: BorderSide(width: 0.5, color: Colors.grey.shade400),
                              verticalInside: BorderSide(width: 0.5, color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            columns: [
                              buildHeaderWithSearch(widhtss: smallCellWidth, title: "REF #", onChanged: (v) {
                                reportingCtrl.searchReferenceNo.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: smallCellWidth, title: "INVOICE #", onChanged: (v) {
                                reportingCtrl.searchInvoiceNo.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: largeCellWidth, title: "DATETIME", onChanged: (v) {
                                reportingCtrl.searchDateTime.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: largeCellWidth, title: "CUSTOMER", onChanged: (v) {
                                reportingCtrl.searchCustomer.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: largeCellWidth, title: "PICKUP", onChanged: (v) {
                                reportingCtrl.searchPickup.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: largeCellWidth, title: "DROPOFF", onChanged: (v) {
                                reportingCtrl.searchDropOff.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: smallCellWidth, title: "FARE", onChanged: (v) {
                                reportingCtrl.searchFare.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: smallCellWidth, title: "ACC FARE", onChanged: (v) {
                                reportingCtrl.searchAccFare.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: largeCellWidth, title: "ACC", onChanged: (v) {
                                reportingCtrl.searchAcc.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: smallCellWidth, title: "ORDER #", onChanged: (v) {
                                reportingCtrl.searchOrderNO.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: smallCellWidth, title: "P/T", onChanged: (v) {
                                reportingCtrl.searchPaymentType.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: smallCellWidth, title: "J/T", onChanged: (v) {
                                reportingCtrl.searchJourneyType.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: largeCellWidth, title: "DRV", onChanged: (v) {
                                reportingCtrl.searchDriver.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: smallCellWidth, title: "VEH", onChanged: (v) {
                                reportingCtrl.searchVehicle.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: largeCellWidth, title: "SUBS", onChanged: (v) {
                                reportingCtrl.searchSubsidiary.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: smallCellWidth, title: "STATUS", onChanged: (v) {
                                reportingCtrl.searchStatus.value = v;
                                reportingCtrl.onBookingSearchChanged();
                              }),
                              buildHeaderWithSearch(widhtss: actionCellWidth, title: "ACTION", removeSearching: true),
                            ],
                            rows: List.generate(dataList.length, (index) {
                              var item = dataList[index];
                              String formattedDateTime = "-";
                              if (item.pickupDate != null) {
                                String date = DateFormat('dd-MM-yyyy').format(item.pickupDate!);
                                String time = item.pickupTime ?? "";
                                formattedDateTime = "$date $time".trim();
                              }

                              return DataRow(
                                cells: [
                                  DataCell(buildCenteredCellText(item.referenceNumber ?? "-", smallCellWidth)),
                                  DataCell(buildCenteredCellText(item.invoiceNumber?.toString() ?? "-", smallCellWidth)),
                                  DataCell(buildCenteredCellText(formattedDateTime, largeCellWidth)), // Datetime with ...
                                  DataCell(buildCenteredCellText((item.name ?? "-").toUpperCase(), largeCellWidth)),
                                  DataCell(buildCenteredCellText((item.pickup ?? "-").toUpperCase(), largeCellWidth)),
                                  DataCell(buildCenteredCellText((item.dropoff ?? "-").toUpperCase(), largeCellWidth)),

                                  // FARE EDITABLE CELL
                                  DataCell(Obx(() {
                                    bool isEditing = reportingCtrl.editingRowIndex.value == index;
                                    return isEditing
                                        ? SizedBox(
                                      width: smallCellWidth > 55 ? smallCellWidth : 55,
                                      height: 28,
                                      child: TextField(
                                        controller: reportingCtrl.fareController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        autofocus: true,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 11, color: Colors.black),
                                        decoration: const InputDecoration(
                                          prefixText: "£",
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    )
                                        : buildCenteredCellText(
                                      (item.fares == null || item.fares!.trim().isEmpty)
                                          ? "£0.00"
                                          : "£${item.fares}",
                                      smallCellWidth,
                                    );
                                  })),

                                  DataCell(buildCenteredCellText("£ ${item.companyPrice ?? '0.00'}", smallCellWidth)),
                                  DataCell(buildCenteredCellText((item.account?.name ?? "-").toUpperCase(), largeCellWidth)),
                                  DataCell(buildCenteredCellText(item.orderNumber?.toString() ?? "-", smallCellWidth)),
                                  DataCell(buildCenteredCellText((item.paymentType?.name ?? "-").toUpperCase(), smallCellWidth)),
                                  DataCell(buildCenteredCellText((item.journeyType?.journeyType ?? "-").toUpperCase(), smallCellWidth)),
                                  DataCell(buildCenteredCellText((item.driver?.name ?? "-").toUpperCase(), largeCellWidth)),
                                  DataCell(buildCenteredCellText((item.vehicleType?.name ?? "-").toUpperCase(), smallCellWidth)),
                                  DataCell(buildCenteredCellText((item.subsidiary?.name ?? "-").toUpperCase(), largeCellWidth)),
                                  DataCell(buildCenteredCellText((item.bookingStatus?.bookingStatus ?? "-").toUpperCase(), smallCellWidth)),

                                  DataCell(
                                    Center(
                                      child: Obx(() {
                                        bool isEditing = reportingCtrl.editingRowIndex.value == index;
                                        bool isLoading = reportingCtrl.isFareLoading && isEditing;
                                        return SizedBox(
                                          height: 24,
                                          width: actionCellWidth - 5,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isEditing ? Colors.green : DynamicColors.primaryClr,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                            ),
                                            onPressed: () {
                                              if (reportingCtrl.isFareLoading) return;
                                              if (isEditing) {
                                                reportingCtrl.updateBookingFare(item.id, reportingCtrl.fareController.text, index);
                                              } else {
                                                reportingCtrl.fareController.text = item.fares ?? '0.00';
                                                reportingCtrl.editingRowIndex.value = index;
                                              }
                                            },
                                            child: isLoading
                                                ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.2),
                                            )
                                                : Text(isEditing ? "SAVE" : "EDIT", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          if (dataList.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Center(child: Text("No Data Found", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: PaginationWidget(
                    currentPage: controller.currentPage.value,
                    totalPages: controller.totalPages.value,
                    onPageChange: controller.onBookingPageChange,
                  ),
                ),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width,
                //     child: DatatableWidget(
                //       columns: [
                //         buildHeaderWithSearch(title: "REF #"),
                //         buildHeaderWithSearch(title: "INVOICE #"),
                //         buildHeaderWithSearch(title: "DATETIME"),
                //         buildHeaderWithSearch(title: "CUSTOMER"),
                //         buildHeaderWithSearch(title: "PICKUP"),
                //         buildHeaderWithSearch(title: "DROPOFF"),
                //         buildHeaderWithSearch(title: "FARE"),
                //         buildHeaderWithSearch(title: "ACC FARE"),
                //         buildHeaderWithSearch(title: "ACC"),
                //         buildHeaderWithSearch(title: "ORDER #"),
                //         buildHeaderWithSearch(title: "P/T"),
                //         buildHeaderWithSearch(title: "J/T"),
                //         buildHeaderWithSearch(title: "DRV"),
                //         buildHeaderWithSearch(title: "VEH"),
                //         buildHeaderWithSearch(title: "SUBS"),
                //         buildHeaderWithSearch(title: "STATUS"),
                //         buildHeaderWithSearch(
                //             title: "ACTION", removeSearching: true),
                //       ],
                //       totalRow:
                //           controller.bookingStatisticsModel?.data?.length ?? 0,
                //       rows: (controller.bookingStatisticsModel?.data ?? [])
                //           .map((item) {
                //         String formattedDateTime = "-";
                //         if (item.pickupDate != null) {
                //           String date =
                //               DateFormat('dd-MM-yyyy').format(item.pickupDate!);
                //           String time = item.pickupTime ?? "";
                //           formattedDateTime = "$date $time".trim();
                //         }
                //         return DataRow(
                //           cells: [
                //             DataCell(Center(
                //                 child: Text(item.referenceNumber ?? "-",
                //                     maxLines: 1))),
                //             DataCell(Center(
                //                 child: Text(
                //                     item.invoiceNumber?.toString() ?? "-",
                //                     maxLines: 1))),
                //             DataCell(Center(
                //                 child: Text(formattedDateTime, maxLines: 1))),
                //             DataCell(Center(
                //                 child: Text((item.name ?? "-").toUpperCase(),
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis))),
                //             DataCell(
                //               SizedBox(
                //                 width: 150,
                //                 child: Text(
                //                   item.pickup ?? "-",
                //                   maxLines: 1,
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //               ),
                //             ),
                //             DataCell(
                //               SizedBox(
                //                 width: 150,
                //                 child: Text(
                //                   item.dropoff ?? "-",
                //                   maxLines: 1,
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //               ),
                //             ),
                //             DataCell(Center(
                //                 child: Text("£ ${item.fares ?? '0.00'}",
                //                     maxLines: 1))),
                //             DataCell(Center(
                //                 child: Text("£ ${item.companyPrice ?? '0.00'}",
                //                     maxLines: 1))),
                //             DataCell(Center(
                //                 child: Text(
                //                     (item.account?.name ?? "-").toUpperCase(),
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis))),
                //             DataCell(Center(
                //                 child: Text(item.orderNumber?.toString() ?? "-",
                //                     maxLines: 1))),
                //             DataCell(Center(
                //                 child: Text(
                //                     (item.paymentType?.name ?? "-")
                //                         .toUpperCase(),
                //                     maxLines: 1))),
                //             DataCell(Center(
                //                 child: Text(
                //                     (item.journeyType?.journeyType ?? "-")
                //                         .toUpperCase(),
                //                     maxLines: 1))),
                //             DataCell(Center(
                //                 child: Text(
                //                     (item.driver?.name ?? "-").toUpperCase(),
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis))),
                //             DataCell(Center(
                //                 child: Text(
                //                     (item.vehicleType?.name ?? "-")
                //                         .toUpperCase(),
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis))),
                //             DataCell(Center(
                //                 child: Text(
                //                     (item.subsidiary?.name ?? "-")
                //                         .toUpperCase(),
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis))),
                //             DataCell(Center(
                //                 child: Text(
                //                     (item.bookingStatus?.bookingStatus ?? "-")
                //                         .toUpperCase(),
                //                     maxLines: 1))),
                //             DataCell(
                //               Center(
                //                 child: ElevatedButton(
                //                   style: ElevatedButton.styleFrom(
                //                     backgroundColor: DynamicColors.gryClr,
                //                     foregroundColor: Colors.white,
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 16, vertical: 8),
                //                     shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(8),
                //                     ),
                //                   ),
                //                   onPressed: () {},
                //                   child: const Text("EDIT"),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // ),
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
// Widget buildCellText(String text, double width) {
//   return SizedBox(
//     width: width,
//     child: Text(
//       text,
//       maxLines: 1,
//       overflow: TextOverflow.ellipsis,
//       style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
//     ),
//   );
// }

}