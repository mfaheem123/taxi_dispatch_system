import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
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
import '../model/update_account_invoice_model.dart' hide Subsidiary;

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

    return GetBuilder<InvoiceController>(builder: (controller) {
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

            CustomDropdownField<Subsidiary>(
              text: "SUBSIDIARY",
              width: fieldWidth / 1.5,
              label: "subsidiary",
              items: controller.selectedSubsidiary != null ? [controller.selectedSubsidiary!] : [],
              value: controller.selectedSubsidiary,
              itemLabel: (item) => item.name ?? "No Name",
              onChanged: (val) {
                controller.selectedSubsidiary = val;
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
              // Controller ke andar orderNumber wala TextEditingController use karein
              controller: controller.orderNumber,
              width: fieldWidth,
              hintText: AppText.order,
              columnText: true,
              height: 30,
            ),

            SizedBox(
              height: 8,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 5, left: 20, right: 15),
            //   child: Row(
            //     children: [
            //       labeledField(
            //         context: context,
            //         isMobile: isMobile,
            //         label: AppText.from,
            //         width: fieldWidth / 1.8,
            //         child: SizedBox(
            //             height: 30,
            //             child: KeyboardDatePicker(
            //                 initialDate: controller.updateFromDate ?? DateTime.now(),
            //                 onChanged: (pickedDate) {
            //                   controller.updateFromDate = pickedDate;
            //                   controller.update();
            //                 })),
            //       ),
            //       SizedBox(
            //         width: 15,
            //       ),
            //       labeledField(
            //         context: context,
            //         isMobile: isMobile,
            //         label: AppText.to,
            //         width: fieldWidth / 1.8,
            //         child: SizedBox(
            //             height: 30,
            //             child: KeyboardDatePicker(
            //               initialDate: controller.updateToDate ?? DateTime.now(),
            //               onChanged: (pickedDate) {
            //                 controller.updateToDate = pickedDate;
            //                 controller.update();
            //               },
            //             )),
            //       ),
            //       Spacer(),
            //       CustomButton(
            //         verticalPadding: 0.0,
            //         width: 40,
            //         height: 30,
            //         borderRadius: 4,
            //         btnText: AppText.filter,
            //         style: mozillaTextRegularText(
            //             fontSize: 10, color: DynamicColors.whiteClr),
            //         onTap: () {
            //           controller.getUpdateAccountInvoiceBookings();
            //         },
            //       ),
            //       SizedBox(
            //         width: 15,
            //       ),
            //       CustomButton(
            //         onTap: () {
            //           controller.postUpdateInvoice();
            //         },
            //         verticalPadding: 0.0,
            //         width: 40,
            //         height: 30,
            //         borderRadius: 4,
            //         btnText: AppText.update,
            //         style: mozillaTextRegularText(
            //             fontSize: 10, color: DynamicColors.whiteClr),
            //       ),
            //     ],
            //   ),
            // ),


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
                      return DataRow(cells: [
                        DataCell(Checkbox(value: false, onChanged: (val) {})),
                        DataCell(Center(child: Text(booking?.referenceNumber ?? "-"))),
                        DataCell(Center(child: Text("${booking?.pickupDate ?? ""} ${booking?.pickupTime ?? ""}"))),
                        DataCell(Center(child: Text(booking?.pickup ?? "-"))),
                        DataCell(Center(child: Text(booking?.dropoff ?? "-"))),
                        DataCell(Center(child: Text(booking?.name ?? "-"))), // Customer Name
                        DataCell(Center(child: Text(booking?.vehicleType?.name ?? "-"))),
                        DataCell(Center(child: Text(booking?.journeyType?.journeyType ?? "-"))),
                        DataCell(Center(child: Text(booking?.paymentType?.name ?? "-"))), // Payment Type (Model check karein agar missing hai)
                        DataCell(Center(child: Text(booking?.companyPrice?.toString() ?? "0"))),
                        DataCell(Center(child: Text(booking?.parkingCharges?.toString() ?? "0"))),
                        DataCell(Center(child: Text(booking?.waitingCharges?.toString() ?? "0"))),
                        DataCell(Center(child: Text(booking?.extraDropCharges?.toString() ?? "0"))),
                        DataCell(Center(child: Text(booking?.meetAndGreet?.toString() ?? "0"))),
                        DataCell(Center(child: Text(booking?.congestionCharges?.toString() ?? "0"))),
                        DataCell(Center(child: Text(booking?.totalCharges?.toString() ?? "0", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w100),))),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search, color: DynamicColors.primaryClr, size: 18),
                            const SizedBox(width: 8),
                            Icon(Icons.clear, color: DynamicColors.redClr, size: 18),
                          ],
                        )),
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
