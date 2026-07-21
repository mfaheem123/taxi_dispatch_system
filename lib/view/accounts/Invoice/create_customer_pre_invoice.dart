import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/responsive_datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../booking_view/reusable_widget.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/preinvoice_controller.dart'; 

class CustomerPreInvoice extends StatelessWidget {
  const CustomerPreInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerPreInvoiceController>(
      init: CustomerPreInvoiceController(),
      builder: (controller) {
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
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  child: Text("Customer Pre Invoice", style: titleDesign()),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 4.0),
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
                            initialDate: DateTime.parse(controller.invoiceDate),
                            onChanged: (date) {
                              controller.changeInvoiceDate(date);
                            },
                            onSubmitted: (date) {
                              controller.changeInvoiceDate(date);
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
                            initialDate: DateTime.parse(controller.invoiceDueDate),
                            onChanged: (date) {
                              controller.changeInvoiceDueDate(date);
                            },
                            onSubmitted: (date) {
                              controller.changeInvoiceDueDate(date);
                            },
                          )),
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: RichText(
                          text: TextSpan(
                              text: 'INVOICE #',
                              style: mozillaTextSemiBoldText(
                                  fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                                text: " ${controller.invoiceNumber}",
                                style: mozillaTextRegularText(
                                    color: DynamicColors.redClr)),
                          ])),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        borderRadius: 4,
                        controller: controller.nameController,
                        width: double.infinity,
                        hintText: AppText.name,
                        columnText: true,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        borderRadius: 4,
                        controller: controller.emailController,
                        width: double.infinity,
                        hintText: AppText.email,
                        columnText: true,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        borderRadius: 4,
                        controller: controller.mobileController,
                        width: double.infinity,
                        hintText: AppText.mobile,
                        columnText: true,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        borderRadius: 4,
                        controller: controller.telController,
                        width: double.infinity,
                        hintText: AppText.tel,
                        columnText: true,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 4.0),
                child: Wrap(
                  runSpacing: 10,
                  spacing: maxWidth < 1366 ? 6 : 10,
                  children: [
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      width: maxWidth < 1366
                          ? fieldWidth / 2.2
                          : fieldWidth / 1.8,
                      child: SizedBox(
                        height: 30,
                        child: KeyboardDatePicker(
                          initialDate: DateTime.parse(controller.filterFromDate),
                          onChanged: (date) {
                            controller.changeFromDate(date);
                          },
                          onSubmitted: (date) {
                            controller.changeFromDate(date);
                          },
                        ),
                      ),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.to,
                      width: maxWidth < 1366
                          ? fieldWidth / 2.2
                          : fieldWidth / 1.8,
                      child: SizedBox(
                        height: 30,
                        child: KeyboardDatePicker(
                          initialDate: DateTime.parse(controller.filterToDate),
                          onChanged: (date) {
                            controller.changeToDate(date);
                          },
                          onSubmitted: (date) {
                            controller.changeToDate(date);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: maxWidth < 1366 ? 4 : 10),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: maxWidth < 1366 ? 4.0 : 10.0),
                      child: Transform.translate(
                          offset: const Offset(0, 6),
                          child: Text(AppText.pt,
                              style: mozillaTextSemiBoldText(
                                  context: context,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: DynamicColors.primaryClr))),
                    ),
                    ...controller.paymentTypes.map((payment) {
                      return InkWell(
                        onTap: () {
                          controller.togglePayment(payment['id']);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: maxWidth < 1366 ? 6 : 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                visualDensity: VisualDensity.compact,
                                value: controller.selectedPaymentTypeIds
                                    .contains(payment['id']),
                                onChanged: (v) {
                                  controller.togglePayment(payment['id']);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  (payment['name'] ?? "").toUpperCase(),
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
                        controller.filterBookings();
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
                        controller.saveInvoice();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ResponsiveDataTableWidget(
                  totalWidth: totalAvailableWidth,
                  columnConfigs: [
                    TableColumnConfig(
                        title: "CHECKBOX",
                        sizeType: ColumnSizeType.small,
                        customHeader: Checkbox(
                          value: controller.selectedIds.isNotEmpty &&
                              controller.selectedIds.length ==
                                  controller.bookings.length,
                          onChanged: (bool? val) {
                            controller.selectAll(val ?? false);
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
                    ...controller.bookings,
                    if (controller.bookings.isNotEmpty) "TOTAL_ROW"
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
                                "£ ${controller.getInvoiceTableColumnTotal('fares').toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11))),
                        Center(
                            child: Text(
                                "£ ${controller.getInvoiceTableColumnTotal('parkingCharges').toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11))),
                        Center(
                            child: Text(
                                "£ ${controller.getInvoiceTableColumnTotal('waitingCharges').toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11))),
                        Center(
                            child: Text(
                                "£ ${controller.getInvoiceTableColumnTotal('extraDropCharges').toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11))),
                        Center(
                            child: Text(
                                "£ ${controller.getInvoiceTableColumnTotal('meetAndGreet').toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11))),
                        Center(
                            child: Text(
                                "£ ${controller.getInvoiceTableColumnTotal('congestionCharges').toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11))),
                        Center(
                            child: Text(
                                "£ ${controller.getInvoiceTableColumnTotal('totalCharges').toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11))),
                        "",
                      ];
                    }

                    final booking = item as Map<String, dynamic>;
                    final isRowSelected = controller.selectedIds
                        .contains(booking['id'].toString());

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
                            controller.toggleBookingSelection(
                                booking['id'].toString());
                          },
                        ),
                      ),
                      booking['referenceNumber'] ?? "",
                      "${booking['pickupDate']} ${booking['pickupTime']}",
                      (booking['pickup'] ?? "").toUpperCase(),
                      (booking['dropoff'] ?? "").toUpperCase(),
                      (booking['vehicleType'] ?? "").toUpperCase(),
                      (booking['journeyType'] ?? "").toUpperCase(),
                      (booking['paymentType'] ?? "").toUpperCase(),
                      editableCell(booking['fares'], (val) {
                        controller.updateFare(booking, 'fares', val);
                      }),
                      editableCell(booking['parkingCharges'], (val) {
                        controller.updateFare(booking, 'parkingCharges', val);
                      }),
                      editableCell(booking['waitingCharges'], (val) {
                        controller.updateFare(booking, 'waitingCharges', val);
                      }),
                      editableCell(booking['extraDropCharges'], (val) {
                        controller.updateFare(booking, 'extraDropCharges', val);
                      }),
                      editableCell(booking['meetAndGreet'], (val) {
                        controller.updateFare(booking, 'meetAndGreet', val);
                      }),
                      editableCell(booking['congestionCharges'], (val) {
                        controller.updateFare(
                            booking, 'congestionCharges', val);
                      }),
                      Center(
                          child: Text("£ ${booking['totalCharges'] ?? "0"}")),
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
                          onTap: () {
                            controller.saveBookingRow(booking);
                          },
                        ),
                      ),
                    ];
                  }),
            ],
          ));
        });
      },
    );
  }
}
