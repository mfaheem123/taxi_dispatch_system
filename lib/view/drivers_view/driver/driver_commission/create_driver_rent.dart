import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/datatable_widget.dart';
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

        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        final bool isLaptop = maxWidth >= 1024 && maxWidth < 1440;
        final bool isLargeScreen = maxWidth >= 1440;

        final double fieldWidth = isMobile
            ? maxWidth * 0.9 // almost full width on mobile
            : isTablet
                ? 200 // smaller fixed size on tablet
                : isLaptop
                    ? 250 // medium size on laptop
                    : 330; // larger on LCD
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
                        runSpacing: 20,
                        spacing: 50,
                        children: [
                          SizedBox(
                            width: fieldWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppText.driver,
                                    style: mozillaTextSemiBoldText(
                                        context: context, fontSize: 13)),
                                const SizedBox(height: 5),
                                Container(
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: DynamicColors.primaryClr),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: Text("SELECT DRIVER",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: DynamicColors.black)),
                                      value: controller
                                              .rentDriverSelectionController
                                              .text
                                              .isEmpty
                                          ? null
                                          : controller
                                              .rentDriverSelectionController
                                              .text,
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      items: controller.driverRentModel?.drivers
                                              ?.map((driver) {
                                            final val =
                                                "${driver.username} ${driver.name}";
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(val.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                            );
                                          }).toList() ??
                                          [],
                                      onChanged: (val) {
                                        if (val != null) {
                                          controller
                                              .rentDriverSelectionController
                                              .text = val;
                                          controller.update();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(AppText.from,
                        style: mozillaTextSemiBoldText(
                            context: context,
                            fontSize: 13,
                            color: DynamicColors.textClr)),
                  ),
                  SizedBox(
                    width: fieldWidth / 1.2,
                    height: 30,
                    child: KeyboardDatePicker(
                      key: ValueKey("from_date_${controller.datePickerKey}"),
                      initialDate: DateTime.now(),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(AppText.to,
                        style: mozillaTextSemiBoldText(
                            context: context,
                            fontSize: 13,
                            color: DynamicColors.textClr)),
                  ),
                  SizedBox(
                    width: fieldWidth / 1.2,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(AppText.pt,
                        style: mozillaTextSemiBoldText(
                            context: context,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: DynamicColors.primaryClr)),
                  ),
                  if (controller.isLoadingPayments)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                            controller.selectedPaymentTypeIds.add(payment.id!);
                          }
                          controller.update();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
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
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  payment.name?.toUpperCase() ?? "",
                                  style: mozillaTextSemiBoldText(
                                    context: context,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: DynamicColors.primaryClr,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  SizedBox(
                    width: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomButton(
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
                  ),
                  SizedBox(width: 20),
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
              SizedBox(
                height: 10,
              ),
              controller.isRentFilterLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width,
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(
                                widget: Checkbox(
                                    value: controller.selectedIds.length ==
                                        controller.driverRentFilterModel
                                            ?.bookings?.length,
                                    onChanged: (bool? val) {
                                      if (val == true) {
                                        controller.selectedIds = controller
                                            .driverRentFilterModel!.bookings
                                            !.map((booking) =>
                                                booking.id.toString())
                                            .toSet();
                                      } else {
                                        controller.selectedIds.clear();
                                      }
                                      controller.calculateTotals();
                                      controller.update();
                                    })),
                            buildHeaderWithSearch(title: "REF#"),
                            buildHeaderWithSearch(title: "DATETIME"),
                            buildHeaderWithSearch(title: "PICKUP"),
                            buildHeaderWithSearch(title: "DROPOFF"),
                            buildHeaderWithSearch(title: "VEH"),
                            buildHeaderWithSearch(title: "ACC"),
                            buildHeaderWithSearch(title: "J/T"),
                            buildHeaderWithSearch(title: "P/T"),
                            buildHeaderWithSearch(title: "FARE"),
                            buildHeaderWithSearch(title: "PC"),
                            buildHeaderWithSearch(title: "WC"),
                            buildHeaderWithSearch(title: "EDC"),
                            buildHeaderWithSearch(title: "CC"),
                            buildHeaderWithSearch(title: "TOTAL"),
                            buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                          ],
                          rows: controller.driverRentFilterModel == null
                              ? []
                              : [
                                  ...(controller.driverRentFilterModel!
                                              .bookings ??
                                          [])
                                      .map((booking) {
                                    final isRowSelected = controller.selectedIds
                                        .contains(booking.id.toString());
                                    DataCell editableCell(dynamic initialValue,
                                        Function(String) onChanged) {
                                      return DataCell(
                                        Center(
                                          child: SizedBox(
                                            width: 70,
                                            child: TextFormField(
                                              initialValue:
                                                  initialValue?.toString() ??
                                                      "0",
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 4),
                                                border: OutlineInputBorder(),
                                              ),
                                              onChanged: onChanged,
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return DataRow(cells: [
                                      DataCell(Center(
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
                                              }))),
                                      DataCell(Center(
                                          child: Text(
                                              booking.referenceNumber ?? ""))),
                                      DataCell(Center(
                                          child: Text(
                                              "${booking.pickupDate ?? ""} ${booking.pickupTime ?? ""}"))),
                                      DataCell(Text((booking.pickup ?? "").toUpperCase())),
                                      DataCell(Text((booking.dropoff ?? "").toUpperCase())),
                                      DataCell(Center(
                                          child: Text((
                                              booking.vehicleType?.name ?? "").toUpperCase()))),
                                      DataCell(Center(
                                          child: Text((
                                              booking.account?.name ?? "").toUpperCase()))),
                                      DataCell(Center(
                                          child: Text((
                                              booking.journeyType?.journeyType ??
                                                  "").toUpperCase()))),
                                      DataCell(Center(
                                          child: Text((
                                              booking.paymentType?.name ?? "").toUpperCase()))),
                                      editableCell(booking.fares, (val) {
                                        booking.fares = val;
                                        controller
                                            .recalculateDriverCommissionRow(
                                                booking);
                                      }),
                                      editableCell(booking.parkingCharges,
                                          (val) {
                                        booking.parkingCharges = val;
                                        controller
                                            .recalculateDriverCommissionRow(
                                                booking);
                                      }),
                                      editableCell(booking.waitingCharges,
                                          (val) {
                                        booking.waitingCharges = val;
                                        controller
                                            .recalculateDriverCommissionRow(
                                                booking);
                                      }),
                                      editableCell(booking.extraDropCharges,
                                          (val) {
                                        booking.extraDropCharges = val;
                                        controller
                                            .recalculateDriverCommissionRow(
                                                booking);
                                      }),
                                      editableCell(booking.congestionCharges,
                                          (val) {
                                        booking.congestionCharges = val;
                                        controller
                                            .recalculateDriverCommissionRow(
                                                booking);
                                      }),
                                      DataCell(Center(
                                          child: Text(
                                              "£ ${booking.totalCharges ?? "0"}"))),
                                      DataCell(
                                        Center(
                                          child: CustomButton(
                                            verticalPadding: 0.0,
                                            width: 60,
                                            height: 30,
                                            borderRadius: 4,
                                            btnText: "SAVE",
                                            btnColor: DynamicColors.primaryClr,
                                            style: mozillaTextRegularText(
                                                fontSize: 10,
                                                color: DynamicColors.whiteClr),
                                            onTap: () async {
                                              if (booking != null) {
                                                await controller
                                                    .updateBookingCharges(
                                                        booking);
                                                controller.calculateTotals();
                                                controller.update();
                                                print(
                                                    "Updating Booking ID: ${booking.id}");
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                  DataRow(
                                    cells: [
                                      for (var i = 0; i < 8; i++)
                                        DataCell.empty,
                                      DataCell(Center(
                                          child: Text("TOTAL",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold)))),
                                      ...[
                                        'fare',
                                        'pc',
                                        'wc',
                                        'edc',
                                        'cc',
                                        'total'
                                      ].map((field) => DataCell(Center(
                                          child: Text(
                                              "£ ${controller.getCreateRentColumnTotal(field).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))))),
                                      DataCell.empty,
                                    ],
                                  ),
                                ],
                        ),
                      ),
                    ),
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
                fontSize: 20,
                color: DynamicColors.textClr.withOpacity(0.8),
                fontWeight: FontWeight.w800),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            value ?? "0",
            style: mozillaTextSemiBoldText(
                fontSize: 20,
                color: DynamicColors.textClr.withOpacity(0.8),
                fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
