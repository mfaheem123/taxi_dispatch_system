import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:dashboard_new1/view/administration/model/list_subsDiary.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import 'package:dashboard_new1/view/accounts/model/account_invoice_model.dart';

import '../../../component/editable_cell_widget.dart';
import '../../../component/networks/api.dart';
import '../../../component/responsive_datatable_widget.dart';
import '../../dashboard_view/models/account_darshboard_model.dart';
import '../controller/invoice_controller.dart';

class CreateAccountInvoiceScreen extends StatefulWidget {
  const CreateAccountInvoiceScreen({super.key});

  @override
  State<CreateAccountInvoiceScreen> createState() =>
      _CreateAccountInvoiceScreenState();
}

class _CreateAccountInvoiceScreenState
    extends State<CreateAccountInvoiceScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  InvoiceController Controller = Get.isRegistered<InvoiceController>()
      ? Get.find<InvoiceController>()
      : Get.put(InvoiceController());
  List permissions = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permissions = Api().sp.read('all_permissions') ?? [];
    shortCutKeyValue.value = "CreateAccountInvoiceScreen";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return PageScrollWrapper(
      child: GetBuilder<InvoiceController>(initState: (state) {
        Controller.clearInvoiceData();
        Controller.getSubsidiary();
        Controller.getInvoiceNumber();
        Controller.subsidiaries = null;
        Controller.selectAccountValue = null;
        Controller.selectDepartmentData = null;
        Controller.orderNumber.clear();
        Controller.fromDate = DateTime.now();
        Controller.toDate = DateTime.now();
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

          return controller.isSubsidiary == true
              ? Center(child: CircularProgressIndicator())
              : Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      child: Text(AppText.accountInvoice, style: titleDesign()),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.invoiceDate,
                      column: true,
                      width: fieldWidth / 1.8,
                      child: SizedBox(
                          height: 35,
                          child: KeyboardDatePicker(
                            key: ValueKey("invoice_date_${controller.datePickerKey}"),
                            initialDate: DateTime.now(),
                            onChanged: (date) {
                              setState(() {
                                controller.invoiceDateController =
                                    "${date.year}-${date.month}-${date.day}";
                                print(date);
                              });
                            },
                            onSubmitted: (date) {
                              setState(() {
                                controller.invoiceDateController =
                                    "${date.year}-${date.month}-${date.day}";
                              });
                              print("User pressed enter: $date");
                            },
                          )),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.invoiceDueDate,
                      column: true,
                      width: fieldWidth / 1.8,
                      child: SizedBox(
                          height: 35,
                          child: KeyboardDatePicker(
                            key: ValueKey("invoice_due_date_${controller.datePickerKey}"),
                            initialDate:
                                DateTime.now().add(Duration(days: 7)),
                            onChanged: (date) {
                              setState(() {
                                controller.invoiceDueDateController =
                                    "${date.year}-${date.month}-${date.day}";
                                print(date);
                              });
                            },
                            onSubmitted: (date) {
                              setState(() {
                                controller.invoiceDueDateController =
                                    "${date.year}-${date.month}-${date.day}";
                              });
                              print("User pressed enter: $date");
                            },
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: RichText(
                            text: TextSpan(
                                text: 'INVOICE #',
                                style: mozillaTextSemiBoldText(
                                    fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                  text:
                                      " ${controller.invoiceNumberModel!.documentNumber!.prefix}"
                                      "${controller.invoiceNumberModel!.documentNumber!.endNumber}".toUpperCase(),
                                  style: mozillaTextRegularText(
                                      color: DynamicColors.redClr))
                            ]))),
                    CustomDropdownField<Subsidiaries>(
                      height: 35,
                      text: AppText.subsidiary,
                      width: fieldWidth / 1.5,
                      label: AppText.subsidiary,
                      items: controller.subsDiaryModel?.subsidiaries ?? [],
                      value: controller.subsidiaries,
                      itemLabel: (item) => item.name ?? "",
                      onChanged: (val) {
                        controller.subsidiaries = val;

                        controller.selectAccountValue = null;
                        controller.selectDepartmentData = null;
                        controller.dashboardAccountData = null;
                        controller.getAccountData(subsidiariesId: val!.id);
                      },
                    ),
                    CustomDropdownField<DashboardAccountObject>(
                      height: 35,
                      text: "ACCOUNT",
                      width: fieldWidth / 1.5,
                      label: "ACCOUNT",
                      items: controller.dashboardAccountData?.accounts ?? [],
                      value: (controller.dashboardAccountData?.accounts?.contains(controller.selectAccountValue) ?? false)
                          ? controller.selectAccountValue
                          : null,
                      itemLabel: (item) => item.name ?? "",
                      onChanged: (val) {
                        controller.selectAccountValue = val;
                        controller.selectDepartmentData = null;
                        controller.update();
                      },
                    ),
                    CustomDropdownField<DepartmentObject>(
                      height: 35,
                      text: "DEPARTMENT",
                      width: fieldWidth / 1.5,
                      label: "DEPARTMENT",
                      items: controller.selectAccountValue?.departments ?? [],
                      value: (controller.selectAccountValue?.departments?.contains(controller.selectDepartmentData) ?? false)
                          ? controller.selectDepartmentData
                          : null,
                      itemLabel: (item) => item.name ?? "",
                      onChanged: (val) {
                        controller.selectDepartmentData = val;
                        controller.update();
                      },
                    ),


                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text("ACCOUNT",
                    //         style: mozillaTextSemiBoldText(
                    //           context: context,
                    //           fontSize: 13,
                    //         )),
                    //     SizedBox(
                    //       height: 35,
                    //       width: fieldWidth / 1.5,
                    //       child: DropdownButtonFormField<DashboardAccountObject>(
                    //         decoration: const InputDecoration(
                    //           border: OutlineInputBorder(),
                    //           isDense: true,
                    //         ),
                    //         value: (controller.dashboardAccountData?.accounts?.contains(controller.selectAccountValue) ?? false)
                    //             ? controller.selectAccountValue
                    //             : null,
                    //         items: controller.dashboardAccountData == null
                    //             ? []
                    //             : controller.dashboardAccountData!.accounts!
                    //                 .map((account) =>
                    //                     DropdownMenuItem<DashboardAccountObject>(
                    //                       value: account,
                    //                       child: Text(
                    //                         account.name ?? "",
                    //                         style: mozillaTextRegularText(
                    //                           fontSize: 12,
                    //                           color: DynamicColors.textClr,
                    //                         ),
                    //                       ),
                    //                     ))
                    //                 .toList(),
                    //         onChanged: (v) {
                    //           controller.selectAccountValue = v;
                    //           controller.selectDepartmentData = null;
                    //           controller.update();
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text("DEPARTMENT",
                    //         style: mozillaTextSemiBoldText(
                    //           context: context,
                    //           fontSize: 13,
                    //         )),
                    //     SizedBox(
                    //       height: 35,
                    //       width: fieldWidth / 1.5,
                    //       child: DropdownButtonFormField<DepartmentObject>(
                    //         decoration: const InputDecoration(
                    //           border: OutlineInputBorder(),
                    //           isDense: true,
                    //         ),
                    //         value: (controller.selectAccountValue?.departments?.contains(controller.selectDepartmentData) ?? false)
                    //             ? controller.selectDepartmentData
                    //             : null,
                    //         items: controller.selectAccountValue == null
                    //             ? []
                    //             : controller.selectAccountValue!.departments!
                    //                 .map((department) =>
                    //                     DropdownMenuItem<DepartmentObject>(
                    //                       value: department,
                    //                       child: Text(
                    //                         department.name ?? "",
                    //                         style: mozillaTextRegularText(
                    //                           fontSize: 12,
                    //                           color: DynamicColors.textClr,
                    //                         ),
                    //                       ),
                    //                     ))
                    //                 .toList(),
                    //         onChanged: (v) {
                    //           controller.selectDepartmentData = v;
                    //           controller.update();
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(padding: EdgeInsetsGeometry.only(left: 10),
                    child: CustomTextField(
                      borderRadius: 4,
                      controller: controller.orderNumber,
                      width: fieldWidth,
                      hintText: AppText.order,
                      columnText: true,
                      height: 35,
                      inputFormatters: [UpperCaseTextFormatter()
                      ],
                    ),
                    ),
                    labeledField(
                      column: true,
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      width: fieldWidth / 1.8,
                      child: SizedBox(
                          height: 35,
                          child: KeyboardDatePicker(
                              key: ValueKey("from_date_${controller.datePickerKey}"),
                              initialDate: controller.fromDate ?? DateTime.now(),
                              allowFutureDates: false,
                              onChanged: (fromDate) {
                                controller.fromDate = fromDate;
                                controller.update();
                              })),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    labeledField(
                      column: true,
                      context: context,
                      isMobile: isMobile,
                      label: AppText.to,
                      width: fieldWidth / 1.8,
                      child: SizedBox(
                          height: 35,
                          child: KeyboardDatePicker(
                            key: ValueKey("to_date_${controller.datePickerKey}"),
                            initialDate: controller.toDate ?? DateTime.now(),
                            onChanged: (toDate) {
                              controller.toDate = toDate;
                              controller.update();
                            },
                          )),
                    ),
                    SizedBox(width: 50),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomButton(
                        verticalPadding: 0.0,
                        width: 80,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.filter,
                        style: mozillaTextRegularText(
                            fontSize: 10, color: DynamicColors.whiteClr),
                        onTap: () {
                          controller.getInvoiceNumber();
                          controller.getAccountInvoiceByFilter();
                          },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomButton(
                        verticalPadding: 0.0,
                        width: 80,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.save,
                        style: mozillaTextRegularText(
                            fontSize: 10, color: DynamicColors.whiteClr),
                        onTap: () {
                          Controller.addAccountInvoice();
                          },
                      ),
                    ),
                     ResponsiveDataTableWidget(
                        totalWidth: totalAvailableWidth,
                        columnConfigs: [
                          TableColumnConfig(
                            title: "SELECT",
                            sizeType: ColumnSizeType.fixed,
                            fixedWidth: 35,
                            removeSearching: true,
                            customHeader: Checkbox(
                              value: controller.isAllSelected,
                              onChanged: (val) {
                                controller.isAllSelected = val ?? false;
                                controller.selectedCreateBookingIds.clear();
                                if (controller.isAllSelected) {
                                  controller.selectedCreateBookingIds.addAll(
                                      controller.accountInvoiceBookingModel!.bookings!.map((e) => e.id!));
                                }
                                controller.recalculateCreateInvoiceTotal(null);
                                controller.update();
                              },
                            ),
                          ),
                          TableColumnConfig(title: "REF #", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "DATETIME", sizeType: ColumnSizeType.medium),
                          TableColumnConfig(title: "PICKUP", sizeType: ColumnSizeType.large),
                          TableColumnConfig(title: "DROPOFF", sizeType: ColumnSizeType.large),
                          TableColumnConfig(title: "CUST", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "VEH", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "J/T", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "P/T", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "FARE", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "PC", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "WC", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "EDC", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "M&G", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "CC", sizeType: ColumnSizeType.small),
                          TableColumnConfig(title: "TOTAL", sizeType: ColumnSizeType.medium),
                          TableColumnConfig(title: "ACTIONS", sizeType: ColumnSizeType.fixed, fixedWidth: 70, removeSearching: true),
                        ],
                        items: (controller.accountInvoiceBookingModel?.bookings?.isEmpty ?? true)
                            ? []
                            : [
                          ...(controller.accountInvoiceBookingModel?.bookings ?? []),
                          ...(controller.accountInvoiceBookingModel?.total ?? []).map((t) => {'type': 'TOTAL', 'data': t}),
                          ...(controller.accountInvoiceBookingModel?.total ?? []).map((t) => {'type': 'GRAND_TOTAL', 'data': t}),
                        ],
                        rowBuilder: (item, widths) {

                          if (item is Map && item['type'] == 'TOTAL') {
                            final totalData = item['data'];
                            return [
                              "", "", "", "", "", "", "", "",
                              Center(child: Text("TOTAL", style: mozillaTextRegularText(fontWeight: FontWeight.bold, fontSize: 12))),
                              Center(child: Text("£${totalData.fareTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.parkingChargesTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.waitingChargesTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.extraDropChargesTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.meetAndGreetTotal ?? "0.00"}")),
                              Center(child:Text("£${totalData.congestionChargesTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.total ?? "0.00"}", style: mozillaTextRegularText(color: Colors.blue, fontSize: 12))),
                              "",
                            ];
                          }

                          if (item is Map && item['type'] == 'GRAND_TOTAL') {
                            final totalData = item['data'];
                            return [
                              "", "", "", "", "", "", "", "",
                              Center(child: Text("GRAND\nTOTAL", style: mozillaTextRegularText(fontWeight: FontWeight.bold, fontSize: 12))),
                              "", "", "", "", "", "",
                              Center(child: Text("£${totalData.grandTotal ?? "0.00"}", style: mozillaTextRegularText(fontWeight: FontWeight.bold, fontSize: 12))),
                              "",
                            ];
                          }
                          final booking = item;
                          return [
                            Center(
                              child:
                            Checkbox(
                              value: controller.selectedCreateBookingIds.contains(booking.id),
                              onChanged: (val) {
                                if (val == true) {
                                  controller.selectedCreateBookingIds.add(booking.id!);
                                } else {
                                  controller.selectedCreateBookingIds.remove(booking.id);
                                }
                                controller.isAllSelected = controller.selectedCreateBookingIds.length ==
                                    controller.accountInvoiceBookingModel!.bookings!.length;
                                controller.recalculateCreateInvoiceTotal(null);
                                controller.update();
                              },
                            ),
                            ),
                            booking.referenceNumber ?? "",
                            // "${booking.pickupDate ?? ""} ${booking.pickupTime ?? ""}",
                            "${(booking.pickupDate ?? "").split('-').length == 3 ? "${(booking.pickupDate ?? "").split('-')[0]}-${(booking.pickupDate ?? "").split('-')[1].padLeft(2, '0')}-${(booking.pickupDate ?? "").split('-')[2].padLeft(2, '0')}" : booking.pickupDate ?? ""} ${booking.pickupTime ?? ""}",
                            (booking.pickup ?? "").toUpperCase(),
                            (booking.dropoff ?? "").toUpperCase(),
                            (booking.customer?.address1 ?? "").toUpperCase(),
                            (booking.vehicleType?.name ?? "").toUpperCase(),
                            (booking.journeyType?.journeyType ?? "").toUpperCase(),
                            (booking.paymentType?.name ?? "").toUpperCase(),

                            EditableCellWidget(
                              initialValue: booking.fares,
                              onChanged: (val) {
                                booking.fares = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(booking);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: booking.parkingCharges,
                              onChanged: (val) {
                                booking.parkingCharges = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(booking);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: booking.waitingCharges,
                              onChanged: (val) {
                                booking.waitingCharges = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(booking);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: booking.extraDropCharges,
                              onChanged: (val) {
                                booking.extraDropCharges = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(booking);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: booking.meetAndGreet,
                              onChanged: (val) {
                                booking.meetAndGreet = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(booking);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: booking.congestionCharges,
                              onChanged: (val) {
                                booking.congestionCharges = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(booking);
                              },
                            ),

                            Center(
                              child: Text(
                                "£${booking.totalCharges ?? '0.0'}",
                                style: mozillaTextRegularText(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),

                            Center(
                              child: CustomButton(
                                verticalPadding: 0.0,
                                width: 50,
                                height: 26,
                                borderRadius: 4,
                                btnText: "SAVE",
                                style: mozillaTextRegularText(fontSize: 9, color: DynamicColors.whiteClr),
                                onTap: () {
                                  if (booking != null) {
                                    controller.updateBookingCharges(booking);
                                    print("Updating Booking ID: ${booking.id}");
                                  }
                                },
                              ),
                            ),
                          ];
                        },
                      ),
                  ],
                );
        });
      }),
    );
  }
}
