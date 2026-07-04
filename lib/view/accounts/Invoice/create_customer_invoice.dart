import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:dashboard_new1/component/responsive_datatable_widget.dart';
import 'package:excel/excel.dart' show Excel, Sheet, CellValue, TextCellValue;
import 'package:flutter_html/flutter_html.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/booking_view/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../customer/model/search_customer_by_mobile.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/account_controller.dart';
import '../controller/customer_invoice_controller.dart';

class CreateCustomerInvoice extends StatefulWidget {
  const CreateCustomerInvoice({super.key});

  @override
  State<CreateCustomerInvoice> createState() => _CreateCustomerInvoiceState();
}

/// ye screen Customer invoice ki hai   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class _CreateCustomerInvoiceState extends State<CreateCustomerInvoice> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  CustomerInvoiceController controller =
      Get.isRegistered<CustomerInvoiceController>()
          ? Get.find<CustomerInvoiceController>()
          : Get.put(CustomerInvoiceController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "CreateCustomerInvoice";
  }

  List permissions = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<CustomerInvoiceController>(initState: (v) {
      controller.getPaymentTypes();
      controller.getCustomerInvoiceNumber();
      permissions = Api().sp.read('all_permissions') ?? [];
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
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                color: DynamicColors.gryClr.withOpacity(0.5),
                child: Text(AppText.customerInvoice, style: titleDesign()),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  labeledField(
                    context: context,
                    isMobile: isMobile,
                    label: AppText.invoiceDate,
                    column: true,
                    width: fieldWidth / 1.8,
                    child: SizedBox(
                        height: 30,
                        child: KeyboardDatePicker(
                          initialDate: DateTime.now(),
                          onChanged: (date) {
                            setState(() {
                              controller.customerInvoiceDateController =
                                  "${date.year}-${date.month}-${date.day}";
                              print(date);
                            });
                          },
                          onSubmitted: (date) {
                            setState(() {
                              controller.customerInvoiceDateController =
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
                        height: 30,
                        child: KeyboardDatePicker(
                          initialDate: DateTime.now().add(Duration(days: 7)),
                          onChanged: (date) {
                            setState(() {
                              controller.customerInvoiceDueDateController =
                                  "${date.year}-${date.month}-${date.day}";
                              print(date);
                            });
                          },
                          onSubmitted: (date) {
                            setState(() {
                              controller.customerInvoiceDueDateController =
                                  "${date.year}-${date.month}-${date.day}";
                            });
                            print("User pressed enter: $date");
                          },
                        )),
                  ),
                  SizedBox(width: 20),
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
                                  " ${controller.customerInvoiceModel?.invoiceNumber}",
                              style: mozillaTextRegularText(
                                  color: DynamicColors.redClr)),
                        ])),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      borderRadius: 4,
                      controller: controller.customerNameController,
                      width: double.infinity,
                      hintText: AppText.name,
                      columnText: true,
                      height: 30,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      borderRadius: 4,
                      controller: controller.customerEmailController,
                      width: double.infinity,
                      hintText: AppText.email,
                      columnText: true,
                      height: 30,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        height: 52,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(AppText.mobile,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            SizedBox(
                              height: 30,
                              child: RawAutocomplete<SearchCustomer>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) async {
                                  if (textEditingValue.text.length < 2) {
                                    return const Iterable<
                                        SearchCustomer>.empty();
                                  }
                                  await controller
                                      .getCustomer(textEditingValue.text);
                                  return controller.searchCustomerByMobileModel
                                          ?.customer ??
                                      const Iterable<SearchCustomer>.empty();
                                },
                                displayStringForOption:
                                    (SearchCustomer option) =>
                                        option.mobile ?? '',

                                //  INPUT FIELD VIEW
                                fieldViewBuilder: (context,
                                    textEditingController,
                                    focusNode,
                                    onFieldSubmitted) {
                                  if (textEditingController.text.isEmpty &&
                                      controller.customerMobileController.text
                                          .isNotEmpty) {
                                    textEditingController.text = controller
                                        .customerMobileController.text;
                                  }

                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onSubmitted: (value) => onFieldSubmitted(),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 0),
                                      hintText: AppText.mobile,
                                      hintStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                            color: DynamicColors.primaryClr),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                            color: DynamicColors.primaryClr),
                                      ),
                                      suffixIcon: controller.isSearchingCustomer
                                          ? const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 1.5)),
                                            )
                                          : null,
                                    ),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    onChanged: (val) {
                                      controller.customerMobileController.text =
                                          val;
                                    },
                                  );
                                },

                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4.0,
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      child: Container(
                                        width: constraints.maxWidth,
                                        height: 250,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey.shade200),
                                        ),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final SearchCustomer option =
                                                options.elementAt(index);

                                            final bool highlight =
                                                AutocompleteHighlightedOption
                                                        .of(context) ==
                                                    index;

                                            return InkWell(
                                              onTap: () => onSelected(option),
                                              child: Container(
                                                color: highlight
                                                    ? const Color(0xFFE1F2FE)
                                                    : null,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      option.name ?? '',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      "${option.mobile ?? ''}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13),
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

                                // ACTION ON SELECTION
                                onSelected: (SearchCustomer selection) {
                                  controller.selectedCustomerId = selection.id;
                                  controller.customerMobileController.text =
                                      selection.mobile ?? '';
                                  controller.customerNameController.text =
                                      selection.name ?? '';
                                  controller.customerEmailController.text =
                                      selection.email ?? '';
                                  controller.customerTelephoneController.text =
                                      selection.telephone ?? '';
                                  controller.update();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      borderRadius: 4,
                      controller: controller.customerTelephoneController,
                      width: double.infinity,
                      hintText: AppText.tel,
                      columnText: true,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Wrap(
                runSpacing: 10,
                spacing: maxWidth < 1366 ? 6 : 10,
                children: [
                  labeledField(
                    context: context,
                    isMobile: isMobile,
                    label: AppText.from,
                    width: maxWidth < 1366 ? fieldWidth / 2.2 :fieldWidth / 1.8,
                    child: SizedBox(
                      height: 30,
                      child: KeyboardDatePicker(
                        initialDate: DateTime.now(),
                        onChanged: (date) {
                          controller.filterFromDate =
                              date.toIso8601String().split("T").first;
                          controller.update();
                        },
                        onSubmitted: (date) {
                          controller.filterFromDate =
                              date.toIso8601String().split("T").first;
                          controller.update();
                        },
                      ),
                    ),
                  ),
                  labeledField(
                    context: context,
                    isMobile: isMobile,
                    label: AppText.to,
                    width: maxWidth < 1366 ? fieldWidth / 2.2 :fieldWidth / 1.8,
                    child: SizedBox(
                      height: 30,
                      child: KeyboardDatePicker(
                        initialDate: DateTime.now(),
                        onChanged: (date) {
                          controller.filterToDate =
                              date.toIso8601String().split("T").first;
                          controller.update();
                        },
                        onSubmitted: (date) {
                          controller.filterToDate =
                              date.toIso8601String().split("T").first;
                          controller.update();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: maxWidth < 1366 ? 4 : 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: maxWidth < 1366 ? 4.0 : 10.0),
                    child: Transform.translate(
                        offset: const Offset(0, 6),
                        child: Text(AppText.pt,
                            style: mozillaTextSemiBoldText(
                                context: context,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: DynamicColors.primaryClr))),
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
                    ...?controller.paymentTypeModel?.paymentTypes
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
                          padding: EdgeInsets.symmetric(horizontal: maxWidth < 1366 ? 6 : 16),
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
                  SizedBox(width: maxWidth < 1366 ? 10 : 40),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 70,
                    height: 30,
                    borderRadius: 4,
                    btnText: AppText.filter,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {
                      controller.getCustomerInvoiceByFilter();
                    },
                  ),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 70,
                    height: 30,
                    borderRadius: 4,
                    btnText: AppText.save,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {
                      controller.saveCustomerInvoice();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ResponsiveDataTableWidget(
                totalWidth: totalAvailableWidth,
                columnConfigs: [
                  TableColumnConfig(
                      title: "CHECKBOX",
                      sizeType: ColumnSizeType.small,
                      customHeader: Checkbox(
                        value: controller.selectedIds.isNotEmpty &&
                            controller.selectedIds.length ==
                                controller.customerInvoiceFilterModel?.bookings
                                    ?.length,
                        onChanged: (bool? val) {
                          if (val == true) {
                            controller.selectedIds = controller
                                .customerInvoiceFilterModel!.bookings!
                                .map((booking) => booking.id.toString())
                                .toSet();
                          } else {
                            controller.selectedIds.clear();
                          }
                          controller.update();
                        },
                      )),
                  TableColumnConfig(
                      title: "REF#", sizeType: ColumnSizeType.medium),
                  TableColumnConfig(
                      title: "DATETIME", sizeType: ColumnSizeType.medium),
                  TableColumnConfig(
                      title: "PICKUP", sizeType: ColumnSizeType.large),
                  TableColumnConfig(
                      title: "DROPOFF", sizeType: ColumnSizeType.large),
                  TableColumnConfig(
                      title: "VEH", sizeType: ColumnSizeType.small),
                  TableColumnConfig(
                      title: "J/T", sizeType: ColumnSizeType.small),
                  TableColumnConfig(
                      title: "P/T", sizeType: ColumnSizeType.small),
                  TableColumnConfig(
                      title: "FARE", sizeType: ColumnSizeType.small),
                  TableColumnConfig(
                      title: "PC", sizeType: ColumnSizeType.small),
                  TableColumnConfig(
                      title: "WC", sizeType: ColumnSizeType.small),
                  TableColumnConfig(
                      title: "EDC", sizeType: ColumnSizeType.small),
                  TableColumnConfig(
                      title: "M&G", sizeType: ColumnSizeType.small),
                  TableColumnConfig(
                      title: "CC", sizeType: ColumnSizeType.small),
                  TableColumnConfig(
                      title: "TOTAL", sizeType: ColumnSizeType.medium),
                  TableColumnConfig(
                      title: "ACTIONS",
                      sizeType: ColumnSizeType.fixed,
                      fixedWidth: 65,
                      removeSearching: true),
                ],
                items: [
                  ...(controller.customerInvoiceFilterModel?.bookings ?? []),
                  if (controller.customerInvoiceFilterModel?.bookings != null)
                    "TOTAL_ROW"
                ],
                rowBuilder: (item, widths) {
                  if (item == "TOTAL_ROW") {
                    return [
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      const Center(
                        child: Text("TOTAL",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                      Center(
                          child: Text(
                              "£ ${controller.getInvoiceTableColumnTotal('fare').toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11))),
                      Center(
                          child: Text(
                              "£ ${controller.getInvoiceTableColumnTotal('pc').toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11))),
                      Center(
                          child: Text(
                              "£ ${controller.getInvoiceTableColumnTotal('wc').toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11))),
                      Center(
                          child: Text(
                              "£ ${controller.getInvoiceTableColumnTotal('edc').toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11))),
                      Center(
                          child: Text(
                              "£ ${controller.getInvoiceTableColumnTotal('mg').toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11))),
                      Center(
                          child: Text(
                              "£ ${controller.getInvoiceTableColumnTotal('cc').toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11))),
                      Center(
                          child: Text(
                              "£ ${controller.getInvoiceTableColumnTotal('total').toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11))),
                      "",
                    ];
                  }

                  final booking = item;
                  final isRowSelected =
                      controller.selectedIds.contains(booking.id.toString());

                  Widget editableCell(
                      dynamic initialValue, Function(String) onChanged) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        child: TextFormField(
                          initialValue: initialValue?.toString() ?? "0",
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 4),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: onChanged,
                        ),
                      ),
                    );
                  }

                  return [
                    Center(
                      child: Checkbox(
                        value: isRowSelected,
                        onChanged: (bool? val) {
                          if (val == true) {
                            controller.selectedIds.add(booking.id.toString());
                          } else {
                            controller.selectedIds
                                .remove(booking.id.toString());
                          }
                          controller.update();
                        },
                      ),
                    ),
                    booking.referenceNumber ?? "",
                    "${(booking.pickupDate ?? "").toString().split(' ')[0]} ${(booking.pickupTime ?? "").toString().split('.')[0].substring(0, 5)}",
                    (booking.pickup ?? "").toUpperCase(),
                    (booking.dropoff ?? "").toUpperCase(),
                    (booking.vehicleType?.name ?? "").toUpperCase(),
                    (booking.journeyType?.journeyType ?? "").toUpperCase(),
                    (booking.paymentType?.name ?? "").toUpperCase(),
                    editableCell(booking.fares, (val) {
                      booking.fares = val;
                      controller.recalculateTotalRow(booking);
                    }),
                    editableCell(booking.parkingCharges, (val) {
                      booking.parkingCharges = val;
                      controller.recalculateTotalRow(booking);
                    }),
                    editableCell(booking.waitingCharges, (val) {
                      booking.waitingCharges = val;
                      controller.recalculateTotalRow(booking);
                    }),
                    editableCell(booking.extraDropCharges, (val) {
                      booking.extraDropCharges = val;
                      controller.recalculateTotalRow(booking);
                    }),
                    editableCell(booking.meetAndGreet, (val) {
                      booking.meetAndGreet = val;
                      controller.recalculateTotalRow(booking);
                    }),
                    editableCell(booking.congestionCharges, (val) {
                      booking.congestionCharges = val;
                      controller.recalculateTotalRow(booking);
                    }),
                    Center(child: Text("£ ${booking.totalCharges ?? "0"}")),
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
                            controller.update();
                          }
                        },
                      ),
                    ),
                  ];
                }),
          ],
        ));
      });
    });
  }
}
