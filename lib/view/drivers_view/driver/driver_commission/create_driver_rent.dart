import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/dropdown_button.dart';
import '../../../../component/editable_cell_widget.dart';
import '../../../../component/responsive_datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../controller/driver_controller.dart';

class CreateDriverRent extends StatefulWidget {
  const CreateDriverRent({super.key});

  @override
  State<CreateDriverRent> createState() => _CreateDriverRentState();
}

class _CreateDriverRentState extends State<CreateDriverRent> {
  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "createDriverRent";
  }

  int selectedRowIndex = 0;
  final int totalRows = 5;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<DriverController>(initState: (state) {
      controller.getDriver();
      controller.getPaymentTypes();
    }, builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double totalAvailableWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        final bool isLaptop = maxWidth >= 1024 && maxWidth < 1440;
        final bool isLargeScreen = maxWidth >= 1440;
        final bool isHighScale =
            MediaQuery.of(context).devicePixelRatio >= 1.25;

        // Responsive field width calculation according to screen and scale
        double fieldWidth;
        if (isMobile) {
          fieldWidth = maxWidth * 0.9;
        } else if (isTablet) {
          fieldWidth = isHighScale ? maxWidth / 2.3 : 200;
        } else if (isLaptop) {
          fieldWidth = isHighScale ? maxWidth / 4.9 : 220;
        } else {
          fieldWidth = isHighScale ? maxWidth / 4.6 : 330;
        }

        print(fieldWidth);
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(color: DynamicColors.gryClr)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Text(
                        AppText.driverRent,
                        style: titleDesign(),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Wrap(
                        runSpacing: 16,
                        spacing: isHighScale ? 16 : 24,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          CustomDropdownField<dynamic>(
                            width: fieldWidth,
                            height: 30,
                            text: AppText.driver,
                            label: "SELECT DRIVER",
                            value: controller.rentDriverSelectionController.text.isEmpty
                                ? null
                                : controller.driverRentModel?.drivers?.firstWhereOrNull(
                                    (d) => "${d.username} ${d.name}" == controller.rentDriverSelectionController.text
                            ),
                            items: controller.driverRentModel?.drivers ?? [],
                            itemLabel: (driver) => "${driver.username} ${driver.name}".toUpperCase(),
                            onChanged: (driver) {
                              if (driver != null) {
                                controller.rentDriverSelectionController.text = "${driver.username} ${driver.name}";
                                controller.update();
                              }
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.transactionDate,
                                  style: mozillaTextSemiBoldText(
                                      context: context, fontSize: 13)),
                              SizedBox(
                                width: fieldWidth,
                                height: 30,
                                child: KeyboardDatePicker(
                                  key: ValueKey("transaction_date_${controller.datePickerKey}"),
                                  initialDate: DateTime.now(),
                                  onChanged: (date) {
                                    controller.rentTransactionDate =
                                        date.toIso8601String().split("T").first;
                                    controller.update();
                                  },
                                  onSubmitted: (date) {
                                    controller.rentTransactionDate =
                                        date.toIso8601String().split("T").first;
                                    controller.update();
                                  },
                                ),
                              ),
                            ],
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.rentWeekController,
                            width: fieldWidth,
                            hintText: AppText.rentWeek,
                            columnText: true,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                            ],
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.pdaRentWeekController,
                            width: fieldWidth,
                            hintText: AppText.pdaRent,
                            columnText: true,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(AppText.from,
                          style: mozillaTextSemiBoldText(
                              context: context,
                              fontSize: 13,
                              color: DynamicColors.textClr)),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: isMobile ? 120 : fieldWidth / 1.5,
                        height: 30,
                        child: KeyboardDatePicker(
                          key: ValueKey("from_date_${controller.datePickerKey}"),
                          initialDate: DateTime.now(),
                            allowFutureDates: false,
                          onChanged: (date) {
                            controller.rentFilterFromDate =
                                date.toIso8601String().split("T").first;
                            controller.update();
                          },
                          onSubmitted: (date) {
                            controller.rentFilterFromDate =
                                date.toIso8601String().split("T").first;
                            controller.update();
                          },
                        ),
                      ),
                    ]),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppText.to,
                            style: mozillaTextSemiBoldText(
                                context: context,
                                fontSize: 13,
                                color: DynamicColors.textClr)),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: isMobile ? 120 : fieldWidth / 1.5,
                          height: 30,
                          child: KeyboardDatePicker(
                            key: ValueKey("to_date_${controller.datePickerKey}"),
                            initialDate: DateTime.now(),
                            onChanged: (date) {
                              controller.rentFilterToDate =
                                  date.toIso8601String().split("T").first;
                              controller.update();
                            },
                            onSubmitted: (date) {
                              controller.rentFilterToDate =
                                  date.toIso8601String().split("T").first;
                              controller.update();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(AppText.pt,
                          style: mozillaTextSemiBoldText(
                              context: context,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: DynamicColors.primaryClr)),
                    ]),
                    if (controller.isLoadingPayments)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    else
                      ...?controller.paymentTypesModel?.paymentTypes
                          ?.map((payment) {
                        return InkWell(
                          onTap: () {
                            if (controller.selectedPaymentTypeIds
                                .contains(payment.id)) {
                              controller.selectedPaymentTypeIds
                                  .remove(payment.id);
                            } else {
                              controller.selectedPaymentTypeIds
                                  .add(payment.id!);
                            }
                            controller.update();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                visualDensity: VisualDensity.compact,
                                value: controller.selectedPaymentTypeIds
                                    .contains(payment.id),
                                onChanged: (v) {
                                  if (v == true) {
                                    controller.selectedPaymentTypeIds
                                        .add(payment.id!);
                                  } else {
                                    controller.selectedPaymentTypeIds
                                        .remove(payment.id);
                                  }
                                  controller.update();
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0, right: 8.0),
                                child: Text(
                                  payment.name?.toUpperCase() ?? "",
                                  style: mozillaTextSemiBoldText(
                                    context: context,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: DynamicColors.primaryClr,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    CustomButton(
                      height: 30,
                      borderRadius: 6,
                      width: 80,
                      verticalPadding: 0.0,
                      btnText: AppText.filter,
                      btnColor: DynamicColors.primaryClr,
                      style: mozillaTextSemiBoldText(
                          fontSize: 13, color: DynamicColors.whiteClr),
                      onTap: () {
                        controller.getDriverRentByFilter();
                      },
                    ),
                    CustomButton(
                      height: 30,
                      borderRadius: 6,
                      width: 80,
                      verticalPadding: 0.0,
                      btnText: AppText.save,
                      btnColor: DynamicColors.primaryClr,
                      style: mozillaTextSemiBoldText(
                          fontSize: 13, color: DynamicColors.whiteClr),
                      onTap: () {
                        controller.saveDriverRent();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              controller.isRentFilterLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ResponsiveDataTableWidget(
                      totalWidth: totalAvailableWidth,
                      columnConfigs: [
                        TableColumnConfig(
                            title: "SELECT_ALL",
                            sizeType: ColumnSizeType.small,
                            customHeader: Checkbox(
                                value: controller.selectedIds.length == controller.driverRentFilterModel?.bookings?.length,
                                onChanged: (bool? val) {
                                  if (val == true) {
                                    controller.selectedIds = controller.driverRentFilterModel!.bookings!
                                        .map((booking) => booking.id.toString())
                                        .toSet();
                                  } else {
                                    controller.selectedIds.clear();
                                  }
                                  controller.calculateTotals();
                                  controller.update();
                                })),
                        TableColumnConfig(title: "REF#", sizeType: ColumnSizeType.medium),
                        TableColumnConfig(title: "DATETIME", sizeType: ColumnSizeType.medium),
                        TableColumnConfig(title: "PICKUP", sizeType: ColumnSizeType.large),
                        TableColumnConfig(title: "DROPOFF", sizeType: ColumnSizeType.large),
                        TableColumnConfig(title: "VEH", sizeType: ColumnSizeType.small),
                        TableColumnConfig(title: "ACC", sizeType: ColumnSizeType.small),
                        TableColumnConfig(title: "J/T", sizeType: ColumnSizeType.small),
                        TableColumnConfig(title: "P/T", sizeType: ColumnSizeType.small),
                        TableColumnConfig(title: "FARE", sizeType: ColumnSizeType.small),
                        TableColumnConfig(title: "PC", sizeType: ColumnSizeType.small),
                        TableColumnConfig(title: "WC", sizeType: ColumnSizeType.small),
                        TableColumnConfig(title: "EDC", sizeType: ColumnSizeType.small),
                        TableColumnConfig(title: "CC", sizeType: ColumnSizeType.small),
                        TableColumnConfig(title: "TOTAL", sizeType: ColumnSizeType.medium),
                        TableColumnConfig(title: "ACTIONS", sizeType: ColumnSizeType.fixed, fixedWidth: 65, removeSearching: true),
                      ],
                      items: [
                        ...?(controller.driverRentFilterModel?.bookings),
                        if(controller.driverRentFilterModel?.bookings != null) "TOTAL_ROW"
                      ],
                      rowBuilder: (item, widths) {
                        if (item == "TOTAL_ROW") {
                          final totalKeys = [
                            'fare',
                            'pc',
                            'wc',
                            'edc',
                            'cc',
                            'total'
                          ];
                          return [
                            "", "", "", "", "", "", "", "",
                            const Center(
                              child: Text("TOTAL", style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                            ...totalKeys.map((key) {
                              return Center(
                                child: Text(
                                    "£ ${controller
                                        .getCreateRentColumnTotal(key)
                                        .toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              );
                            }),
                            "",
                          ];
                        }
                        final booking = item;
                        final isRowSelected = controller.selectedIds.contains(
                            booking.id.toString());
                        return [
                          Center(
                              child: Checkbox(
                                  value: isRowSelected,
                                  onChanged: (bool? val) {
                                    if (val == true) {
                                      controller.selectedIds.add(
                                          booking.id.toString());
                                    } else {
                                      controller.selectedIds.remove(
                                          booking.id.toString());
                                    }
                                    controller.calculateTotals();
                                    controller.update();
                                  })),
                          booking.referenceNumber ?? "",
                          "${(booking.pickupDate ?? "").toString().split(
                              ' ')[0]} ${(booking.pickupTime ?? "")
                              .toString()
                              .split('.')[0].substring(0, 5)}",
                          (booking.pickup ?? "").toUpperCase(),
                          (booking.dropoff ?? "").toUpperCase(),
                          (booking.vehicleType?.name ?? "").toUpperCase(),
                          (booking.account?.name ?? "").toUpperCase(),
                          (booking.journeyType?.journeyType ?? "").toUpperCase(),
                          (booking.paymentType?.name ?? "").toUpperCase(),
                          EditableCellWidget(
                            initialValue: booking.fares,
                            onChanged: (val) {
                              booking.fares = val;
                              controller.recalculateDriverCommissionRow(booking);
                            },
                          ),
                          EditableCellWidget(
                            initialValue: booking.parkingCharges,
                            onChanged: (val) {
                              booking.parkingCharges = val;
                              controller.recalculateDriverCommissionRow(booking);
                            },
                          ),
                          EditableCellWidget(
                            initialValue: booking.waitingCharges,
                            onChanged: (val) {
                              booking.waitingCharges = val;
                              controller.recalculateDriverCommissionRow(booking);
                            },
                          ),
                          EditableCellWidget(
                            initialValue: booking.extraDropCharges,
                            onChanged: (val) {
                              booking.extraDropCharges = val;
                              controller.recalculateDriverCommissionRow(booking);
                            },
                          ),
                          EditableCellWidget(
                            initialValue: booking.congestionCharges,
                            onChanged: (val) {
                              booking.congestionCharges = val;
                              controller.recalculateDriverCommissionRow(booking);
                            },
                          ),
                          Center(child: Text("${booking.totalCharges ?? "0"}")),
                          Center(
                            child: CustomButton(
                              verticalPadding: 0.0,
                              width: 55,
                              height: 26,
                              borderRadius: 4,
                              btnText: "SAVE",
                              btnColor: DynamicColors.primaryClr,
                              style: mozillaTextRegularText(
                                  fontSize: 10, color: DynamicColors.whiteClr),
                              onTap: () async {
                                if (booking != null) {
                                  await controller.updateBookingCharges(booking);
                                  controller.calculateTotals();
                                  controller.update();
                                  print(
                                      "Updating Booking ID: ${booking.id}");
                                }
                              },
                            ),
                          ),
                        ];
                      }
                  )),
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 400.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customWidget(
                              title: AppText.cashTotal,
                              value:
                                  "£ ${controller.cashTotal.toStringAsFixed(2)}"),
                          customWidget(
                              title: AppText.total + ":",
                              value:
                                  "£ ${controller.grandTotal.toStringAsFixed(2)}"),
                          customWidget(
                              title: AppText.owed,
                              value: "£ ${controller.owed.toStringAsFixed(2)}"),
                          customWidget(
                              title: AppText.oldBalance,
                              value:
                                  "£ ${controller.oldBalance.toStringAsFixed(2)}"),
                          customWidget(
                              title: AppText.newBalance,
                              value:
                                  "£ ${controller.newBalance.toStringAsFixed(2)}"),
                        ],
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customWidget(
                              title: "ACCOUNT TOTAL:",
                              value:
                                  "£ ${controller.accountTotal.toStringAsFixed(2)}"),
                          customWidget(
                              title: AppText.parkingCongestion,
                              value:
                                  "£ ${controller.parkingCongestion.toStringAsFixed(2)}"),
                          customWidget(
                              title: "RENT TOTAL:",
                              value:
                                  "£ ${controller.rentTotal.toStringAsFixed(2)}"),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        );
      });
    });
  }

  Widget customWidget({title, value}) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            // title ?? AppText.cashTotal,
            title ?? "",
            style: mozillaTextSemiBoldText(
                fontSize: 17,
                color: DynamicColors.textClr.withOpacity(0.8),
                fontWeight: FontWeight.w800),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            value ?? "0",
            style: mozillaTextSemiBoldText(
                fontSize: 16,
                color: DynamicColors.textClr.withOpacity(0.8),
                fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
