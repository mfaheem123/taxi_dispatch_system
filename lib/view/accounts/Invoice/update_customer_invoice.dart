import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';

import '../../../alert/update_invoice_email_alt.dart';
import '../../../component/responsive_datatable_widget.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/customer_invoice_controller.dart';
import 'account_invoice_preview_screen.dart';
import 'customer_invoice_view_screen.dart';

class UpdateCustomerInvoice extends StatefulWidget {
  const UpdateCustomerInvoice({super.key});

  @override
  State<UpdateCustomerInvoice> createState() => _UpdateCustomerInvoiceState();
}

class _UpdateCustomerInvoiceState extends State<UpdateCustomerInvoice> {
  CustomerInvoiceController controller =
  Get.isRegistered<CustomerInvoiceController>()
      ? Get.find<CustomerInvoiceController>()
      : Get.put(CustomerInvoiceController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "UpdateCustomerInvoiceScreen";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerInvoiceController>(
        initState: (state) {},
        builder: (controller) {
          return LayoutBuilder(builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

            final double totalAvailableWidth = constraints.maxWidth;
            final double fieldWidth = isMobile
                ? maxWidth // full width
                : isTablet
                ? maxWidth / 2
                : maxWidth / 4;
            return SingleChildScrollView(
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      child: Row(
                        children: [
                          Text("CUSTOMER INVOICE", style: titleDesign()),
                          Spacer(),
                          Obx(() => CustomButton(
                            verticalPadding: 0.0,
                            width: 100,
                            height: 30,
                            borderRadius: 4,
                            btnText: controller.isPaid.value ? "PAID" : "UNPAID",
                            btnColor: controller.isPaid.value ? Colors.green : DynamicColors.primaryClr,
                            style: mozillaTextRegularText(
                                fontSize: 10, color: DynamicColors.whiteClr),
                            onTap: () {
                              controller.togglePaidStatus();
                            },
                          )),
                          SizedBox(width: 5),
                          CustomButton(
                            verticalPadding: 0.0,
                            width: 75,
                            height: 30,
                            borderRadius: 4,
                            btnText: "EMAIL",
                            style: mozillaTextRegularText(
                                fontSize: 10, color: DynamicColors.whiteClr),
                            onTap: () {
                              EmailInvoiceAlert.show();
                            },
                          ),
                          SizedBox(width: 5),
                          PopupMenuButton<String>(
                            tooltip: "Export Options",
                            offset: const Offset(0, 40),
                            onSelected: (value) {
                              if (value == 'pdf') {
                                controller.downloadPdfFile();
                              } else if (value == 'excel') {
                                controller.downloadExel();
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              // --- PDF Option ---
                              PopupMenuItem<String>(
                                value: 'pdf',
                                child: Row(
                                  children: [
                                    const Icon(Icons.picture_as_pdf,
                                        color: Colors.red,
                                        size: 20),
                                    const SizedBox(width: 10),
                                    Text("Download PDF",
                                        style:
                                        mozillaTextRegularText(
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              // --- Excel Option ---
                              PopupMenuItem<String>(
                                value: 'excel',
                                child: Row(
                                  children: [
                                    const Icon(Icons.table_view,
                                        color: Colors.green,
                                        size: 20),
                                    const SizedBox(width: 10),
                                    Text("Download Excel",
                                        style:
                                        mozillaTextRegularText(
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                            child: Container(
                              width: 75,
                              height: 30,
                              decoration: BoxDecoration(
                                color: DynamicColors.primaryClr,
                                borderRadius:
                                BorderRadius.circular(4),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "EXPORT",
                                style: mozillaTextRegularText(
                                    fontSize: 10,
                                    color: DynamicColors.whiteClr),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          CustomButton(
                              verticalPadding: 0.0,
                              width: 75,
                              height: 30,
                              borderRadius: 4,
                              btnText: "VIEW",
                              style: mozillaTextRegularText(
                                  fontSize: 10, color: DynamicColors.whiteClr),
                              onTap: () {
                                Get.dialog(
                                  InvoiceViewWindowWrapper(),
                                  barrierDismissible: true,
                                );
                              }
                          ),
                          SizedBox(width: 5),
                          CustomButton(
                            verticalPadding: 0.0,
                            width: 75,
                            height: 30,
                            borderRadius: 4,
                            btnText: "SAVE",
                            style: mozillaTextRegularText(
                                fontSize: 10, color: DynamicColors.whiteClr),
                            onTap: () {
                              final invoice = controller.customerInvoiceByIdModel?.customerInvoice;
                              if (invoice != null) {
                                controller.updateBooking(invoice);
                              }
                              else {
                                BotToast.showText(text: "NO INVOICE DATA FOUND TO SAVE");
                              }
                            },
                          ),
                          SizedBox(width: 30),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),

                    Padding(padding: const EdgeInsets.all(18.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: AppText.invoiceDate,
                                column: true,
                                width: fieldWidth / 1.9,
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Text(
                                    (controller.customerInvoiceDateController != null &&
                                        controller.customerInvoiceDateController!.isNotEmpty)
                                        ? DateFormat("yyyy-MM-dd").format(
                                        DateFormat("yyyy-M-d").parse(controller.customerInvoiceDateController!))
                                        : "",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: AppText.invoiceDueDate,
                                  column: true,
                                  width: fieldWidth / 1.8,
                                  child: SizedBox(height: 30,
                                      child: KeyboardDatePicker(
                                        key: ValueKey(controller.customerInvoiceByIdModel?.customerInvoice?.invoiceDueDate),
                                        initialDate: controller.customerInvoiceByIdModel?.customerInvoice?.invoiceDueDate ?? DateTime.now(),
                                        onChanged: (date) {
                                          setState(() {
                                            controller.customerInvoiceDueDateController = "${date.year}-${date.month}-${date.day}";
                                            print(date);
                                          });
                                        },
                                        onSubmitted: (date) {
                                          setState(() {
                                            controller.customerInvoiceDueDateController = "${date.year}-${date.month}-${date.day}";
                                          });
                                          print("User pressed enter: $date");
                                        },
                                      )
                                  )),
                              const SizedBox(width: 12),
                              Padding(
                                  padding: EdgeInsets.only(top: 25),
                                  child: RichText(
                                      text: TextSpan(
                                          text: 'INVOICE #',
                                          style: mozillaTextSemiBoldText(
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                                text: controller.customerInvoiceByIdModel?.customerInvoice?.invoiceNumber.toString() ?? "-",
                                                style: mozillaTextRegularText(
                                                    color: DynamicColors.redClr)
                                            )
                                          ]))),
                            ])),

                    // SizedBox(height: 4),
                    Padding(padding: const EdgeInsets.all(18.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: AppText.name,
                                column: true,
                                width: fieldWidth / 1.1,
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Text((
                                      controller.updateNameController.text).toUpperCase(),
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: AppText.email,
                                column: true,
                                width: fieldWidth / 1.1,
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Text((
                                      controller.updateEmailController.text).toUpperCase(),
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: AppText.mobile,
                                column: true,
                                width: fieldWidth / 1.1,
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Text((
                                      controller.updateMobileController.text).toUpperCase(),
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: AppText.tel,
                                column: true,
                                width: fieldWidth / 1.1,
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Text((
                                      controller.updateTelephoneController.text).toUpperCase(),
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                            ])),

                    ResponsiveDataTableWidget(
                        totalWidth: totalAvailableWidth,
                        columnConfigs: [
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
                          ...(controller.customerInvoiceByIdModel?.customerInvoice?.customerInvoiceLineitems ?? []),
                          if (controller.customerInvoiceByIdModel?.customerInvoice != null)
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
                              const Center(
                                child: Text("TOTAL",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                              Center(
                                  child: Text(
                                      "£ ${controller.getUpdateColumnTotal('fare').toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 11))),
                              Center(
                                  child: Text(
                                      "£ ${controller.getUpdateColumnTotal('pc').toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 11))),
                              Center(
                                  child: Text(
                                      "£ ${controller.getUpdateColumnTotal('wc').toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 11))),
                              Center(
                                  child: Text(
                                      "£ ${controller.getUpdateColumnTotal('edc').toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 11))),
                              Center(
                                  child: Text(
                                      "£ ${controller.getUpdateColumnTotal('mg').toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 11))),
                              Center(
                                  child: Text(
                                      "£ ${controller.getUpdateColumnTotal('cc').toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 11))),
                              Center(
                                  child: Text(
                                      "£ ${controller.getUpdateColumnTotal('total').toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 11))),
                              "",
                            ];
                          }

                          final lineItem = item;
                          final booking = lineItem.booking;

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
                            booking.referenceNumber ?? "",
                            "${booking.pickupDate != null ? DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-M-d").parse(booking.pickupDate.toString())) : "-"} ${booking.pickupTime != null ? booking.pickupTime.toString().split('.')[0].substring(0, 5) : ""}",
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