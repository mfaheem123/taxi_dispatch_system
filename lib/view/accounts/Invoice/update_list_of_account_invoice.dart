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
                  Obx(() => CustomButton(
                    verticalPadding: 0.0,
                    width: 100,
                    height: 30,
                    borderRadius: 4,
                    btnText: controller.isPaid.value ? "MARK AS  PAID" : "MARK AS UNPAID",
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
                    key: ValueKey(controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.invoiceDate),
                    initialDate: controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.invoiceDate ?? DateTime.now(),
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

            labeledField(
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

            SizedBox(
              height: 8,
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: Get.width,
                child: DatatableWidget(
                  columns: [
                //     DataColumn(
                // label: Checkbox(
                // value: controller.isAllUpdateSelected,
                //   onChanged: (val) {
                //     controller.isAllUpdateSelected = val ?? false;
                //     controller.selectedBookingIds.clear();
                //
                //     if (controller.isAllUpdateSelected) {
                //       controller.selectedBookingIds.addAll(
                //           controller.accountInvoiceBookingModel!.bookings!
                //               .map((e) => e.id!)
                //       );
                //     }
                //
                //     controller.update();
                //   },
                // ),
                //
                //     ),
                    buildHeaderWithSearch(title: "REF #"),
                    buildHeaderWithSearch(title: "DATETIME"),
                    buildHeaderWithSearch(title: "PICKUP"),
                    buildHeaderWithSearch(title: "DROPOFF"),
                    buildHeaderWithSearch(title: "CUST"),
                    buildHeaderWithSearch(title: "VEH"),
                    buildHeaderWithSearch(title: "J/T"),
                    buildHeaderWithSearch(title: "P/T"),
                    buildHeaderWithSearch(title: "FARE"),
                    buildHeaderWithSearch(title: "PC"),
                    buildHeaderWithSearch(title: "WC"),
                    buildHeaderWithSearch(title: "EDC"),
                    buildHeaderWithSearch(title: "M&G"),
                    buildHeaderWithSearch(title: "Cc"),
                    buildHeaderWithSearch(title: "TOTA"),
                    buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                  ],
                  rows: [
                    ...(controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.accountInvoiceLineitems ?? []).map((lineItem) {
                      final booking = lineItem.booking; // Short reference
                        // Helper function to create editable cell
                      DataCell editableCell(dynamic initialValue, Function(String) onChanged) {
                        return DataCell(
                          Center(
                            child: SizedBox(
                              width: 70,
                              child: TextFormField(
                                key: UniqueKey(),
                                initialValue: initialValue?.toString() ?? "0",
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: onChanged,
                              ),
                            ),
                          ),
                        );
                      }

                      return DataRow(cells: [

                        // DataCell(
                        //   Checkbox(
                        //     value: controller.selectedBookingIds.contains(booking?.id),
                        //     onChanged: (val) {
                        //
                        //       if (val == true) {
                        //         controller.selectedBookingIds.add(booking!.id!);
                        //       } else {
                        //         controller.selectedBookingIds.remove(booking?.id);
                        //       }
                        //
                        //       controller.isAllUpdateSelected =
                        //           controller.selectedBookingIds.length ==
                        //               controller.accountInvoiceBookingModel!.bookings!.length;
                        //
                        //       controller.update();
                        //     },
                        //   ),
                        // ),
                        DataCell(Center(child: Text(booking?.referenceNumber ?? "-"))),
                        DataCell(Center(child: Text("${booking?.pickupDate ?? ""} ${booking?.pickupTime ?? ""}"))),
                        DataCell(Center(child: Text((booking?.pickup ?? "-").toUpperCase()))),
                        DataCell(Center(child: Text((booking?.dropoff ?? "-").toUpperCase()))),
                        DataCell(Center(child: Text((booking?.name ?? "-").toUpperCase()))), // Customer Name
                        DataCell(Center(child: Text((booking?.vehicleType?.name ?? "-").toUpperCase()))),
                        DataCell(Center(child: Text((booking?.journeyType?.journeyType ?? "-").toUpperCase()))),
                        DataCell(Center(child: Text((booking?.paymentType?.name ?? "-").toUpperCase()))),

                        editableCell(booking?.fares, (val) {
                          booking?.fares = double.tryParse(val.toString()) ?? 0.0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.parkingCharges, (val) {
                          booking?.parkingCharges = double.tryParse(val.toString()) ?? 0.0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.waitingCharges, (val) {
                          booking?.waitingCharges = double.tryParse(val.toString()) ?? 0.0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.extraDropCharges, (val) {
                          booking?.extraDropCharges = double.tryParse(val.toString()) ?? 0.0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.meetAndGreet, (val) {
                          booking?.meetAndGreet = double.tryParse(val.toString()) ?? 0.0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.congestionCharges, (val) {
                          booking?.congestionCharges = double.tryParse(val.toString()) ?? 0.0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        DataCell(Center(
                          child: Text(
                            "£${booking?.totalCharges ?? 0}",
                            style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold),
                          ),
                        )),

                        DataCell(
                          Center(
                            child: CustomButton(
                              verticalPadding: 0.0,
                              width: 45,
                              height: 30,
                              borderRadius: 4,
                              btnText: "SAVE",
                              style: mozillaTextRegularText(
                                  fontSize: 10, color: DynamicColors.whiteClr),
                              onTap: () {

                                if (booking != null) {
                                  controller.updateBookingCharges(booking);
                                  print("Updating Booking ID: ${booking.id}");
                                }

                              },
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),


                    // 1. TOTAL Row
                    // DataRow(
                    //   cells: [
                    //     for (var i = 0; i < 7; i++) DataCell.empty,
                    //     DataCell(Center(
                    //         child: Text("TOTAL",
                    //           style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900)))),
                    //     ...['fare', 'pc', 'wc', 'edc', 'mg', 'cc', 'total'].map((field) => DataCell(
                    //       Center(
                    //         child: Text(
                    //           "£ ${controller.getInvoiceColumnTotal(field).toStringAsFixed(2)}",
                    //             style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900),
                    //         ),
                    //       ),
                    //     )),
                    //     DataCell.empty,
                    //   ],
                    // ),


                    if (controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice != null)
                      DataRow(
                        cells: [
                          for (var i = 0; i < 8; i++)DataCell(
                              i == 7
                                  ? Text("TOTAL", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900))
                                  : const SizedBox.shrink()
                          ),

                          DataCell(Center(child: Text("£${controller.totalFare.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()))),
                          DataCell(Center(child: Text("£${controller.totalPC.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()))),
                          DataCell(Center(child: Text("£${controller.totalWC.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()))),
                          DataCell(Center(child: Text("£${controller.totalEDC.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()))),
                          DataCell(Center(child: Text("£${controller.totalMG.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()))),
                          DataCell(Center(child: Text("£${controller.totalCC.toStringAsFixed(2)}", style: mozillaTextSemiBoldText()))),
                          DataCell(Center(
                              child: Text("£${controller.subTotal.toStringAsFixed(2)}",
                                  style: mozillaTextSemiBoldText(color: Colors.blue, fontWeight: FontWeight.bold)))),

                          DataCell.empty,
                        ],
                      ),

                    //  Admin Row

                    if (controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice != null)
                      DataRow(cells: [
                        for (var i = 0; i < 7; i++) DataCell.empty,
                        DataCell(Text("ADMIN FEES", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900))),
                        for (var i = 0; i < 6; i++) DataCell.empty,
                        DataCell(Center(
                          child: Text(
                              "£${controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.account?.adminFees ?? "0"}",
                              style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900)),
                        )),
                        DataCell.empty,
                      ]),


                    //  GRAND TOTAL Row
                    if (controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice != null)
                      DataRow(cells: [
                        for (var i = 0; i < 7; i++) DataCell.empty,
                        DataCell(Text("GRAND TOTAL", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900))),
                        for (var i = 0; i < 6; i++) DataCell.empty,
                        DataCell(Center(
                          child: Text(
                              "£${controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.amount ?? "0"}",
                              style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900)),
                        )),
                        DataCell.empty,
                      ]),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25,)
          ],
        );
      });
    });
  }
}
