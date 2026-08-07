import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_widget.dart';
import '../../../alert/stripe_payment.dart';
import '../../../alert/update_invoice_email_alt.dart';
import '../../../component/responsive_datatable_widget.dart';
import '../controller/invoice_controller.dart';
import 'account_invoice_preview_screen.dart';

class UpdateAccountInvoiceScreen extends StatefulWidget {
  const UpdateAccountInvoiceScreen({super.key});

  @override
  State<UpdateAccountInvoiceScreen> createState() =>
      _UpdateAccountInvoiceScreenState();
}

class _UpdateAccountInvoiceScreenState
    extends State<UpdateAccountInvoiceScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  InvoiceController controller = Get.isRegistered<InvoiceController>()
      ? Get.find<InvoiceController>()
      : Get.put(InvoiceController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "UpdateAccountInvoiceScreen";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<InvoiceController>(
        initState: (state) {
          // controller.getSubsidiary();
        },

        builder: (controller) {
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

        return Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: DynamicColors.gryClr.withOpacity(0.5),
              child: Row(
                children: [
                  Text(AppText.accountInvoice, style: titleDesign()),
                  Spacer(),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 65,
                    height: 30,
                    borderRadius: 4,
                    btnText: "STRIPE PAY",
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {
                      StripePayment.show();
                    },
                  ),
                  SizedBox(width: 5),
                  Obx(() {
                    final invoice = controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice;
                    return CustomButton(
                      verticalPadding: 0.0,
                      width: 100,
                      height: 30,
                      borderRadius: 4,
                      btnText: controller.isPaid.value ? "MARK AS PAID" : "MARK AS UNPAID",
                      btnColor: controller.isPaid.value ? Colors.green : DynamicColors.primaryClr,
                      style: mozillaTextRegularText(fontSize: 10, color: DynamicColors.whiteClr),
                      onTap: () {
                        if (invoice != null) {
                          controller.togglePaidStatus(invoice);
                        } else {
                          BotToast.showText(text: "Invoice data not loaded yet");
                        }
                      },
                    );
                  }),
                  SizedBox(width: 5),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 45,
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
                  // EXPORT
                  PopupMenuButton<String>(
                    tooltip: "Export Options",
                    offset: const Offset(0, 40),
                    onSelected: (value) {
                      if (value == 'pdf') {
                        controller.downloadApiContentAsFile(); // PDF function
                      } else if (value == 'excel') {
                        controller.downloadApiContentAsExcel(); // Excel function
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      // --- PDF Option ---
                      PopupMenuItem<String>(
                        value: 'pdf',
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                            const SizedBox(width: 10),
                            Text("Download PDF", style: mozillaTextRegularText(fontSize: 12)),
                          ],
                        ),
                      ),
                      // --- Excel Option ---
                      PopupMenuItem<String>(
                        value: 'excel',
                        child: Row(
                          children: [
                            const Icon(Icons.table_view, color: Colors.green, size: 20), // Excel icon
                            const SizedBox(width: 10),
                            Text("Download Excel", style: mozillaTextRegularText(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: DynamicColors.primaryClr,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "EXPORT",
                        style: mozillaTextRegularText(fontSize: 10, color: DynamicColors.whiteClr),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 45,
                    height: 30,
                    borderRadius: 4,
                    btnText: "VIEW",
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: ()  {
                      Get.dialog(
                        InvoicePreviewWindowWrapper(),
                        barrierDismissible: true,
                      );
                    },
                  ),
                  SizedBox(width: 5),

                  CustomButton(
                    verticalPadding: 0.0,
                    width: 45,
                    height: 30,
                    borderRadius: 4,
                    btnText: "SAVE",
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {
                      final invoice = controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice;
                      if (invoice != null) {
                        // Maine pichle jawab mein jo function bataya tha wahi call hoga
                        controller.updateBookingAmount(invoice);
                      } else {
                        BotToast.showText(text: "No invoice data found to save");
                      }
                    },
                  ),
                  SizedBox(width: 30),
                ],
              ),

            ),
            SizedBox(
              height: 8,
            ),

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
                child: Text(controller.invoiceDateController ?? ""),
              ),
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.invoiceDueDate,
              column: true,
              width: fieldWidth / 1.8,
              child: SizedBox(height: 30,
                  child: KeyboardDatePicker(
                    key: ValueKey(controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.invoiceDueDate),
                    initialDate: controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.invoiceDueDate ?? DateTime.now(),
                    onChanged: (date) {
                  setState(() {
                    controller.invoiceDueDateController = "${date.year}-${date.month}-${date.day}";
                    print(date);
                  });
                },
                onSubmitted: (date) {
                  setState(() {
                    controller.invoiceDueDateController = "${date.year}-${date.month}-${date.day}";
                  });
                  print("User pressed enter: $date");
                },

              )
              )),
            Padding(
                padding: EdgeInsets.only(top: 25),
                child: RichText(
                    text: TextSpan(
                        text: 'INVOICE #',
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.invoiceNumber.toString() ?? "-",
                          style: mozillaTextRegularText(
                              color: DynamicColors.redClr)
                      )
                    ]))),

            labeledField(
              context: context,
              isMobile: isMobile,
              label: "SUBSIDIARY",
              column: true,
              width: fieldWidth / 1.5,
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
                  controller.subsidiaries?.name ?? "").toUpperCase(),
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),

            labeledField(
              context: context,
              isMobile: isMobile,
              label: "DEPARTMENT",
              column: true,
              width: fieldWidth / 1.5,
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
                  controller.selectDepartmentData?.name ?? "").toUpperCase(),
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),

            labeledField(
              context: context,
              isMobile: isMobile,
              label: "ACCOUNT",
              column: true,
              width: fieldWidth / 1.5,
              child: Container(
                height: 30,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(child: Text((controller.selectAccountValue?.name ?? "").toUpperCase())),
                    Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),

            Padding(padding: EdgeInsetsGeometry.only(left: 10),
            child: labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.order,
              column: true,
              width: fieldWidth,
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
                  controller.orderNumber.text).toUpperCase(),
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
        ),

            SizedBox(
              height: 8,
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ResponsiveDataTableWidget(
                totalWidth: Get.width,
                columnConfigs: [
                  TableColumnConfig(title: "REF #", sizeType: ColumnSizeType.medium),
                  TableColumnConfig(title: "DATETIME", sizeType: ColumnSizeType.medium),
                  TableColumnConfig(title: "PICKUP", sizeType: ColumnSizeType.large),
                  TableColumnConfig(title: "DROPOFF", sizeType: ColumnSizeType.large),
                  TableColumnConfig(title: "CUST", sizeType: ColumnSizeType.medium),
                  TableColumnConfig(title: "VEH", sizeType: ColumnSizeType.small),
                  TableColumnConfig(title: "J/T", sizeType: ColumnSizeType.small),
                  TableColumnConfig(title: "P/T", sizeType: ColumnSizeType.small),
                  TableColumnConfig(title: "FARE", sizeType: ColumnSizeType.fixed, fixedWidth: 80),
                  TableColumnConfig(title: "PC", sizeType: ColumnSizeType.fixed, fixedWidth: 80),
                  TableColumnConfig(title: "WC", sizeType: ColumnSizeType.fixed, fixedWidth: 80),
                  TableColumnConfig(title: "EDC", sizeType: ColumnSizeType.fixed, fixedWidth: 80),
                  TableColumnConfig(title: "M&G", sizeType: ColumnSizeType.fixed, fixedWidth: 80),
                  TableColumnConfig(title: "CC", sizeType: ColumnSizeType.fixed, fixedWidth: 80),
                  TableColumnConfig(title: "TOTAL", sizeType: ColumnSizeType.medium),
                  TableColumnConfig(title: "ACTIONS", sizeType: ColumnSizeType.fixed, fixedWidth: 70, removeSearching: true),
                ],
                items: [
                  ...(controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.accountInvoiceLineitems ?? []),
                  if (controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice != null) ...[
                    {'type': 'TOTAL'},
                    {'type': 'ADMIN_FEES'},
                    {'type': 'GRAND_TOTAL'},
                  ]
                ],
                rowBuilder: (item, widths) {
                  Widget editableCell(String titleKey, dynamic initialValue, Function(String) onChanged) {
                    return SizedBox(
                      width: widths[titleKey]!,
                      child: Center(
                        child: SizedBox(
                          width: 65,
                          child: TextFormField(
                            key: UniqueKey(),
                            initialValue: initialValue?.toString() ?? "0",
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: onChanged,
                          ),
                        ),
                      ),
                    );
                  }

                  if (item is Map && item['type'] == 'TOTAL') {
                    return [
                      "", "", "", "", "", "", "",
                      Text("TOTAL", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900)),
                      Text("£${controller.totalFare.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()),
                      Text("£${controller.totalPC.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()),
                      Text("£${controller.totalWC.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()),
                      Text("£${controller.totalEDC.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()),
                      Text("£${controller.totalMG.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()),
                      Text("£${controller.totalCC.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()),
                      Text("£${controller.subTotal.toStringAsFixed(2)}", style: mozillaTextSemiBoldText(color: Colors.blue, fontWeight: FontWeight.bold)),
                      "",
                    ];
                  }

                  if (item is Map && item['type'] == 'ADMIN_FEES') {
                    return [
                      "", "", "", "", "", "", "",
                      Text("ADMIN FEES", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900)),
                      "", "", "", "", "", "",
                      Text("£${controller.adminFees ?? ""}", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900)),
                      "",
                    ];
                  }

                  if (item is Map && item['type'] == 'GRAND_TOTAL') {
                    return [
                      "", "", "", "", "", "", "",
                      Text("GRAND TOTAL", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900)),
                      "", "", "", "", "", "",
                      Text("£${controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.amount ?? "0"}", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900)),
                      "",
                    ];
                  }


                  final lineItem = item;
                  final booking = lineItem.booking;

                  return [
                    booking?.referenceNumber ?? "-",
                    "${booking?.pickupDate ?? ""} ${booking?.pickupTime ?? ""}",
                    (booking?.pickup ?? "-").toUpperCase(),
                    (booking?.dropoff ?? "-").toUpperCase(),
                    (booking?.name ?? "-").toUpperCase(),
                    (booking?.vehicleType?.name ?? "-").toUpperCase(),
                    (booking?.journeyType?.journeyType ?? "-").toUpperCase(),
                    (booking?.paymentType?.name ?? "-").toUpperCase(),

                    editableCell("FARE", booking?.fares, (val) {
                      booking?.fares = double.tryParse(val.toString()) ?? 0.0;
                      controller.recalculateRowTotal(lineItem);
                    }),
                    editableCell("PC", booking?.parkingCharges, (val) {
                      booking?.parkingCharges = double.tryParse(val.toString()) ?? 0.0;
                      controller.recalculateRowTotal(lineItem);
                    }),
                    editableCell("WC", booking?.waitingCharges, (val) {
                      booking?.waitingCharges = double.tryParse(val.toString()) ?? 0.0;
                      controller.recalculateRowTotal(lineItem);
                    }),
                    editableCell("EDC", booking?.extraDropCharges, (val) {
                      booking?.extraDropCharges = double.tryParse(val.toString()) ?? 0.0;
                      controller.recalculateRowTotal(lineItem);
                    }),
                    editableCell("M&G", booking?.meetAndGreet, (val) {
                      booking?.meetAndGreet = double.tryParse(val.toString()) ?? 0.0;
                      controller.recalculateRowTotal(lineItem);
                    }),
                    editableCell("Cc", booking?.congestionCharges, (val) {
                      booking?.congestionCharges = double.tryParse(val.toString()) ?? 0.0;
                      controller.recalculateRowTotal(lineItem);
                    }),

                    Center(
                      child: Text(
                        "£${booking?.totalCharges ?? 0}",
                        style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold),
                      ),
                    ),

                    Center(
                      child: CustomButton(
                        verticalPadding: 0.0,
                        width: 45,
                        height: 28,
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
            ),
            SizedBox(height: 25,)
          ],
        );
      });
    });
  }
}
