import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/accounts/model/account_invoice_booking_model.dart';
import 'package:dashboard_new1/view/administration/model/list_subsDiary.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../alert/stripe_payment.dart';
import '../../../alert/update_invoice_email_alt.dart';
import '../../dashboard_view/models/account_darshboard_model.dart';
import '../controller/invoice_controller.dart';
import '../model/update_account_invoice_model.dart' hide Booking;

class UpdateAccountInvoiceScreen extends StatefulWidget {
  const UpdateAccountInvoiceScreen({super.key});

  @override
  State<UpdateAccountInvoiceScreen> createState() =>
      _UpdateAccountInvoiceScreenState();
}

class _UpdateAccountInvoiceScreenState
    extends State<UpdateAccountInvoiceScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

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
                    onTap: () {

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
              width: fieldWidth / 1.8,
              child: SizedBox(height: 30, child: KeyboardDatePicker())),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.invoiceDueDate,
              column: true,
              width: fieldWidth / 1.8,
              child: SizedBox(height: 30, child: KeyboardDatePicker())),
            Padding(
                padding: EdgeInsets.only(top: 25),
                child: RichText(
                    text: TextSpan(
                        text: 'Invoice #',
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.invoiceNumber.toString() ?? "-",
                          style: mozillaTextRegularText(
                              color: DynamicColors.redClr)
                      )
                    ]))),

            CustomDropdownField<Subsidiaries>(
              text: "SUBSIDIARY",
              width: fieldWidth / 1.5,
              label: "subsidiary",
              items: controller.subsDiaryModel?.subsidiaries ?? [],
              value: controller.subsidiaries,
              itemLabel: (item) => item.name ?? "",
              onChanged: (val) {
                controller.subsidiaries = val;
                controller.update();
              },
            ),


            CustomDropdownField<DepartmentObject>(
              text: "DEPARTMENT",
              width: fieldWidth / 1.5,
              label: "DEPARTMENT",
              items: controller.selectAccountValue?.departments ?? [],
              value: controller.selectDepartmentData,
              itemLabel: (item) => item.name ?? "",
              onChanged: (val) {
                controller.selectDepartmentData = val;
                controller.update();
              },
            ),
            CustomDropdownField<DashboardAccountObject>(
              text: "ACCOUNT",
              width: fieldWidth / 1.5,
              label: "account",
              items: controller.updateAccountModel?.accounts ?? [],
              value: controller.selectedUpdateAccount,
              itemLabel: (item) => item.name ?? "",
              onChanged: (val) {
                controller.selectedUpdateAccount = val;
                controller.update();
              },
            ),

            CustomTextField(
              borderRadius: 4,
              controller: controller.orderNumber,
              width: fieldWidth,
              hintText: AppText.order,
              columnText: true,
              height: 30,
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
                    DataColumn(label: Checkbox(value: false, onChanged: (val) {})),
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
                        DataCell(Checkbox(value: false, onChanged: (val) {})),
                        DataCell(Center(child: Text(booking?.referenceNumber ?? "-"))),
                        DataCell(Center(child: Text("${booking?.pickupDate ?? ""} ${booking?.pickupTime ?? ""}"))),
                        DataCell(Center(child: Text(booking?.pickup ?? "-"))),
                        DataCell(Center(child: Text(booking?.dropoff ?? "-"))),
                        DataCell(Center(child: Text(booking?.name ?? "-"))), // Customer Name
                        DataCell(Center(child: Text(booking?.vehicleType?.name ?? "-"))),
                        DataCell(Center(child: Text(booking?.journeyType?.journeyType ?? "-"))),
                        DataCell(Center(child: Text(booking?.paymentType?.name ?? "-"))),

                        editableCell(booking?.companyPrice, (val) {
                          booking?.companyPrice = int.tryParse(val) ?? 0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.parkingCharges, (val) {
                          booking?.parkingCharges = int.tryParse(val) ?? 0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.waitingCharges, (val) {
                          booking?.waitingCharges = int.tryParse(val) ?? 0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.extraDropCharges, (val) {
                          booking?.extraDropCharges = int.tryParse(val) ?? 0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.meetAndGreet, (val) {
                          booking?.meetAndGreet = int.tryParse(val) ?? 0;
                          controller.recalculateRowTotal(lineItem);
                        }),
                        editableCell(booking?.congestionCharges, (val) {
                          booking?.congestionCharges = int.tryParse(val) ?? 0;
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





                    //  Admin Row

                    if (controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice != null)
                      DataRow(cells: [
                        for (var i = 0; i < 8; i++) DataCell.empty,
                        DataCell(Text("ADMIN FEES", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900))),
                        for (var i = 0; i < 6; i++) DataCell.empty,
                        DataCell(Center(
                          child: Text(
                              "£${controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice?.account?.adminFees ?? "0"}",
                              style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900)),
                        )),
                        DataCell.empty,
                      ]),


                    //  TOTAL Row
                    if (controller.updateInvoiceByIdModel?.accountInvoice?.accountInvoice != null)
                      DataRow(cells: [
                        for (var i = 0; i < 8; i++) DataCell.empty,
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
