import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/drivers_view/model/driver_commission_filter_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../component/datatable_widget.dart';
import '../../../../component/text_field.dart';
import '../../../booking_view/reusable_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../controller/driver_controller.dart';

class UpdateDriverCommissionScreen extends StatefulWidget {
  const UpdateDriverCommissionScreen({super.key});

  @override
  State<UpdateDriverCommissionScreen> createState() =>
      _UpdateDriverCommissionScreenState();
}

class _UpdateDriverCommissionScreenState
    extends State<UpdateDriverCommissionScreen> {
  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "UpdateDriverCommissionScreen";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<DriverController>(
        initState: (state) {},
        builder: (controller) {
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
            return Column(
              children: [
                Container(
                  width: Get.width,
                  alignment: Alignment.centerLeft,
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: DynamicColors.gryClr)
                  // ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                              vertical: 20, horizontal: 15),
                          child: Text(
                            AppText.driverCommission,
                            style: titleDesign(),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                runSpacing: 20,
                                spacing: 50,
                                children: [
                                  SizedBox(
                                    width: fieldWidth,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppText.drivers,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          height: 35,
                                          padding: EdgeInsetsGeometry.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: DynamicColors.gryClr),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              hint: const Text("SELECT DRIVER",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey)),
                                              value: controller
                                                      .driverSelectionController
                                                      .text
                                                      .isEmpty
                                                  ? null
                                                  : controller
                                                      .driverSelectionController
                                                      .text,
                                              isExpanded: true,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              items: controller
                                                      .listDriverCommission
                                                      ?.drivers
                                                      ?.map((driver) {
                                                    final val =
                                                        "${driver.id} ${driver.name}";
                                                    return DropdownMenuItem(
                                                      value: val,
                                                      child: Text(
                                                          val.toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                    );
                                                  }).toList() ??
                                                  [],
                                              onChanged: (val) {
                                                if (val != null) {
                                                  controller
                                                      .driverSelectionController
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.transactionDate,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13)),
                                      SizedBox(
                                        width: fieldWidth,
                                        height: 30,
                                        child: KeyboardDatePicker(
                                          initialDate: DateTime.now(),
                                          onChanged: (date) {
                                            controller.transactionDate = date
                                                .toIso8601String()
                                                .split("T")
                                                .first;
                                            controller.update();
                                          },
                                          onSubmitted: (date) {
                                            controller.transactionDate = date
                                                .toIso8601String()
                                                .split("T")
                                                .first;
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.commissionController,
                                    width: fieldWidth,
                                    hintText: AppText.commission,
                                    columnText: true,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.pdaRentController,
                                    width: fieldWidth,
                                    hintText: AppText.pdaRent,
                                    columnText: true,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Wrap(
                                runSpacing: 20,
                                spacing: 50,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(AppText.from,
                                                style: mozillaTextSemiBoldText(
                                                    context: context,
                                                    fontSize: 13,
                                                    color:
                                                        DynamicColors.gryClr)),
                                            SizedBox(
                                              width: fieldWidth / 1.2,
                                              height: 30,
                                              child: KeyboardDatePicker(
                                                initialDate: DateTime.now(),
                                                onChanged: (date) {
                                                  controller.filterFromDate =
                                                      date
                                                          .toIso8601String()
                                                          .split("T")
                                                          .first;
                                                  controller.update();
                                                },
                                                onSubmitted: (date) {
                                                  controller.filterFromDate =
                                                      date
                                                          .toIso8601String()
                                                          .split("T")
                                                          .first;
                                                  controller.update();
                                                },
                                              ),
                                            ),
                                          ]),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(AppText.to,
                                              style: mozillaTextSemiBoldText(
                                                  context: context,
                                                  fontSize: 13,
                                                  color: DynamicColors.gryClr)),
                                          SizedBox(
                                            width: fieldWidth / 1.2,
                                            height: 30,
                                            child: KeyboardDatePicker(
                                              initialDate: DateTime.now(),
                                              onChanged: (date) {
                                                controller.filterToDate = date
                                                    .toIso8601String()
                                                    .split("T")
                                                    .first;
                                                controller.update();
                                              },
                                              onSubmitted: (date) {
                                                controller.filterToDate = date
                                                    .toIso8601String()
                                                    .split("T")
                                                    .first;
                                                controller.update();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomButton(
                                            height: 30,
                                            borderRadius: 6,
                                            width: 50,
                                            verticalPadding: 0.0,
                                            btnText: AppText.pay,
                                            btnColor: DynamicColors.primaryClr,
                                            style: mozillaTextSemiBoldText(
                                                fontSize: 13,
                                                color: DynamicColors.whiteClr),
                                          ),
                                          SizedBox(width: 5),
                                          CustomButton(
                                            height: 30,
                                            borderRadius: 6,
                                            width: 50,
                                            verticalPadding: 0.0,
                                            btnText: AppText.email,
                                            btnColor: DynamicColors.primaryClr,
                                            style: mozillaTextSemiBoldText(
                                                fontSize: 13,
                                                color: DynamicColors.whiteClr),
                                          ),
                                          SizedBox(width: 5),
                                          CustomButton(
                                            height: 30,
                                            borderRadius: 6,
                                            width: 60,
                                            verticalPadding: 0.0,
                                            btnText: "EXPORT",
                                            btnColor: DynamicColors.primaryClr,
                                            style: mozillaTextSemiBoldText(
                                                fontSize: 13,
                                                color: DynamicColors.whiteClr),
                                          ),
                                          SizedBox(width: 5),
                                          CustomButton(
                                            height: 30,
                                            borderRadius: 6,
                                            width: 50,
                                            verticalPadding: 0.0,
                                            btnText: AppText.view,
                                            btnColor: DynamicColors.primaryClr,
                                            style: mozillaTextSemiBoldText(
                                                fontSize: 13,
                                                color: DynamicColors.whiteClr),
                                          ),
                                          SizedBox(width: 5),
                                          CustomButton(
                                            height: 30,
                                            borderRadius: 6,
                                            width: 80,
                                            verticalPadding: 0.0,
                                            btnText: AppText.save,
                                            btnColor: DynamicColors.primaryClr,
                                            style: mozillaTextSemiBoldText(
                                                fontSize: 13,
                                                color: DynamicColors.whiteClr),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        controller.isLoadingUpdate
                            ? const Center(child: CircularProgressIndicator())
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: Get.width,
                                  child: DatatableWidget(
                                    columns: [
                                      buildHeaderWithSearch(title: "COMM"),
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
                                      buildHeaderWithSearch(title: "W/COMM"),
                                      buildHeaderWithSearch(title: "COMM"),
                                      buildHeaderWithSearch(title: "TOTAL"),
                                      buildHeaderWithSearch(title: "ACTION"),
                                    ],
                                    rows: [
                                      ...(controller
                                                  .updateDriverCommissionByIdModel
                                                  ?.driverCommission
                                                  ?.driverCommissionLineitems ??
                                              [])
                                          .map((lineItem) {
                                        final booking = lineItem.booking;
                                        if (booking == null)
                                          return const DataRow(cells: []);
                                        DataCell editableCell(
                                            dynamic initialValue,
                                            Function(String) onChanged) {
                                          return DataCell(
                                            Center(
                                              child: SizedBox(
                                                width: 70,
                                                child: TextFormField(
                                                  initialValue: initialValue
                                                          ?.toString() ??
                                                      "0",
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                  decoration:
                                                      const InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 4),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged: onChanged,
                                                ),
                                              ),
                                            ),
                                          );
                                        }

                                        return DataRow(
                                            // selected: isRowSelected,
                                            cells: [
                                              DataCell(Center(
                                                child: Checkbox(
                                                  value: booking.commission ??
                                                      false,
                                                  activeColor:
                                                      DynamicColors.primaryClr,
                                                  onChanged: (bool? newValue) {
                                                    booking.commission =
                                                        newValue;
                                                    controller
                                                        .calculateAllTotals();
                                                    controller.update();
                                                  },
                                                ),
                                              )),
                                              DataCell(Center(
                                                  child: Text(
                                                      booking.referenceNumber ??
                                                          ""))),
                                              DataCell(Center(
                                                  child: Text(
                                                      "${booking.pickupDate ?? ""} ${booking.pickupTime ?? ""}"))),
                                              DataCell(
                                                  Text(booking.pickup ?? "")),
                                              DataCell(
                                                  Text(booking.dropoff ?? "")),
                                              DataCell(Center(
                                                  child: Text(booking
                                                          .vehicleType?.name ??
                                                      ""))),
                                              DataCell(Center(
                                                  child: Text(
                                                      booking.account?.name ??
                                                          "Cash"))),
                                              DataCell(Center(
                                                  child: Text(booking
                                                          .journeyType
                                                          ?.journeyType ??
                                                      ""))),
                                              DataCell(Center(
                                                  child: Text(booking
                                                          .paymentType?.name ??
                                                      ""))),
                                              editableCell(booking.fares,
                                                  (val) {
                                                booking.fares = val;
                                                controller
                                                    .recalculateDriverCommissionRow(
                                                        booking);
                                              }),
                                              editableCell(
                                                  booking.parkingCharges,
                                                  (val) {
                                                booking.parkingCharges = val;
                                                controller
                                                    .recalculateDriverCommissionRow(
                                                        booking);
                                              }),
                                              editableCell(
                                                  booking.waitingCharges,
                                                  (val) {
                                                booking.waitingCharges = val;
                                                controller
                                                    .recalculateDriverCommissionRow(
                                                        booking);
                                              }),
                                              editableCell(
                                                  booking.extraDropCharges,
                                                  (val) {
                                                booking.extraDropCharges = val;
                                                controller
                                                    .recalculateDriverCommissionRow(
                                                        booking);
                                              }),
                                              editableCell(
                                                  booking.congestionCharges,
                                                  (val) {
                                                booking.congestionCharges = val;
                                                controller
                                                    .recalculateDriverCommissionRow(
                                                        booking);
                                              }),
                                              DataCell(Center(
                                                  child: Text(
                                                      "£ ${controller.calculateWithoutCommission(booking)}"))),
                                              DataCell(Center(
                                                  child: Text(
                                                      "£ ${controller.calculateFinalDriverComm(booking)}"))),
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
                                                    btnColor: DynamicColors
                                                        .primaryClr,
                                                    style:
                                                        mozillaTextRegularText(
                                                            fontSize: 10,
                                                            color: DynamicColors
                                                                .whiteClr),
                                                    onTap: () {
                                                      if (booking != null) {
                                                        controller
                                                            .updateBookingCharges(
                                                                booking);
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
                                            'wcomm',
                                            'finalcomm',
                                            'total'
                                          ].map((field) => DataCell(Center(
                                              child: Text(
                                                  "£ ${controller.getColumnTotal(field).toStringAsFixed(2)}",
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
                                          "£ ${controller.cashTotalValue.toStringAsFixed(2)}",
                                    ),
                                    customWidget(
                                      title: AppText.total + ":",
                                      value:
                                          "£ ${controller.grandTotalVar.toStringAsFixed(2)}",
                                    ),
                                    customWidget(
                                        title: AppText.owed,
                                        value:
                                            "£ ${controller.owedVar.toStringAsFixed(2)}"),
                                    customWidget(
                                        title: AppText.oldBalance,
                                        value:
                                            "£ ${controller.oldBalanceVar.toStringAsFixed(2)}"),
                                    customWidget(
                                        title: AppText.newBalance,
                                        value:
                                            "£ ${controller.newBalanceVar.toStringAsFixed(2)}"),
                                  ],
                                ),
                                SizedBox(
                                  width: 80,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customWidget(
                                      title: AppText.accountWCmm,
                                      value:
                                          "£ ${controller.accountFareTotalVar.toStringAsFixed(2)}",
                                    ),
                                    customWidget(
                                        title: AppText.accountWOCmm,
                                        value:
                                            "£ ${controller.accountWOCmmVar.toStringAsFixed(2)}"),
                                    customWidget(
                                        title: AppText.parkingCongestion,
                                        value:
                                            "£ ${controller.parkingCongestionVar.toStringAsFixed(2)}"),
                                    customWidget(
                                        title: AppText.totalCommission,
                                        value:
                                            "£ ${controller.totalCommissionVar.toStringAsFixed(2)}"),
                                  ],
                                ),
                              ],
                            ))
                      ]),
                ),
              ],
            );
          });
        });
  }

  Widget customWidget({title, value}) {
    if (title == null && value == null) return SizedBox(height: 30);
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
