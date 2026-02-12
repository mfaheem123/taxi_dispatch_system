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
import 'package:dashboard_new1/view/accounts/model/account_invoice_model.dart';

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

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

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

    return GetBuilder<AccountController>(builder: (controller) {
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
                  Text(AppText.accountInvoice, style: titleDesign()),Spacer(),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 65,
                    height: 30,
                    borderRadius: 4,
                    btnText: "STRIPE PAY",
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {

                    },
                  ),
                  SizedBox(width: 5),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 85,
                    height: 30,
                    borderRadius: 4,
                    btnText: "MARK AS PAID",
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
                    btnText: "EMAIL",
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
                    btnText: "EXPORT",
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
              child: SizedBox(height: 30, child: KeyboardDatePicker()),
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.invoiceDueDate,
              column: true,
              width: fieldWidth / 1.8,
              child: SizedBox(height: 30, child: KeyboardDatePicker()),
            ),
            Padding(
                padding: EdgeInsets.only(top: 25),
                child: RichText(
                    text: TextSpan(
                        text: 'Invoice #',
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          // text: "  INV368",
                          text: controller.isLoading.value
                              ? " Loading..."
                              : "  ${controller.invoiceNumber.value}",
                          style: mozillaTextRegularText(
                              color: DynamicColors.redClr))
                    ]))),
            CustomDropdownField<Subsidiaries>(
              text: AppText.subsidiary,
              width: fieldWidth / 1.5,
              label: AppText.subsidiary,
              items: controller.subsDiaryModel?.subsidiaries ?? [],
              value: controller.selectedSubsidiaryForGet.value,
              itemLabel: (item) => item.name ?? "",
              onChanged: (val) {
                controller.selectedSubsidiaryForGet.value = val;
                if (val != null && val.id != null) {
                  controller.getAccountsBySubsidiary(val.id!);
                }
              },
            ),
            CustomDropdownField<Account>(
              text: AppText.account,
              width: fieldWidth / 1.5,
              label: AppText.account,
              items: controller.accountList,
              value: controller.selectedAccount.value,
              itemLabel: (item) => item.name ?? "",
              onChanged: (val) {
                controller.selectedAccount.value = val;
                controller.update();
              },
            ),
            CustomDropdownField<String>(
              text: AppText.department,
              width: fieldWidth / 1.5,
              label: AppText.department,
              items: controller.departmentList,
              value: controller.selectedDepartment.value,
              itemLabel: (val) => val,
              onChanged: (val) {
                controller.selectedDepartment.value = val;
                controller.update();
              },
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.customerTelephoneController,
              width: fieldWidth,
              hintText: AppText.order,
              columnText: true,
              height: 30,
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 15),
              child: Row(
                children: [
                  labeledField(
                    context: context,
                    isMobile: isMobile,
                    label: AppText.from,
                    width: fieldWidth / 1.8,
                    child: SizedBox(
                        height: 30,
                        child: KeyboardDatePicker(
                            initialDate: controller.fromDate ?? DateTime.now(),
                            onChanged: (pickedDate) {
                              controller.fromDate = pickedDate;
                              controller.update();
                            })),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  labeledField(
                    context: context,
                    isMobile: isMobile,
                    label: AppText.to,
                    width: fieldWidth / 1.8,
                    child: SizedBox(
                        height: 30,
                        child: KeyboardDatePicker(
                          initialDate: controller.toDate ?? DateTime.now(),
                          onChanged: (pickedDate) {
                            controller.toDate = pickedDate;
                            controller.update();
                          },
                        )),
                  ),
                  Spacer(),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 40,
                    height: 30,
                    borderRadius: 4,
                    btnText: AppText.filter,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {
                      controller.getAccountInvoiceBookings();
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 40,
                    height: 30,
                    borderRadius: 4,
                    btnText: AppText.save,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {
                      controller.postInvoice();
                    },
                  ),
                ],
              ),
            ),


            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: Get.width,
                child: DatatableWidget(
                  columns: [
                    DataColumn(
                      label: Checkbox(
                        value: false, // a bool you keep in state
                        onChanged: (val) {},
                      ),
                    ),
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
                    buildHeaderWithSearch(
                        title: "ACTIONS", removeSearching: true),
                  ],
                  rows: [
                    // Add the booking rows
                    ...controller.invoiceBookings.map((booking) {
                      return DataRow(cells: [
                        DataCell(Checkbox(value: false, onChanged: (val) {})),
                        DataCell(Text(booking.referenceNumber ?? "")),
                        DataCell(Text(
                            "${booking.pickupDate ?? ""} ${booking.pickupTime ?? ""}")),
                        DataCell(Text(booking.pickup ?? "")),
                        DataCell(Text(booking.dropoff ?? "")),
                        DataCell(Text(booking.customer?.address1 ?? "")),
                        DataCell(Text(booking.vehicleType?.name ?? "")),
                        DataCell(Text(booking.journeyType?.journeyType ?? "")),
                        DataCell(Text(booking.paymentType?.name ?? "")),
                        DataCell(Text(booking.fares ?? "0")),
                        DataCell(Text(booking.parkingCharges ?? "0")),
                        DataCell(Text(booking.waitingCharges ?? "0")),
                        DataCell(Text(booking.extraDropCharges ?? "0")),
                        DataCell(Text(booking.meetAndGreet.toString() ?? "0")),
                        DataCell(Text(booking.creditCardCharges ?? "0")),
                        DataCell(Text(booking.totalCharges.toString() ?? "0")),
                        DataCell(Row(
                          children: [
                            Icon(Icons.search, color: DynamicColors.primaryClr),
                            Icon(Icons.clear, color: DynamicColors.redClr),
                          ],
                        )),
                      ]);
                    }).toList(),

                    // TOTAL row
                    if (controller.invoiceTotals.isNotEmpty)
                      DataRow(cells: [
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell(Text(
                          "TOTAL",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.bold),
                        )),
                        DataCell(Text(
                            "£${controller.invoiceTotals[0].fareTotal ?? "0"}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(
                            "£${controller.invoiceTotals[0].parkingChargesTotal ?? "0"}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(
                            "£${controller.invoiceTotals[0].waitingChargesTotal ?? "0"}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(
                            "£${controller.invoiceTotals[0].extraDropChargesTotal ?? "0"}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(
                            "£${controller.invoiceTotals[0].meetAndGreetTotal ?? "0"}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(
                            "£${controller.invoiceTotals[0].congestionChargesTotal ?? "0"}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(
                            "£${controller.invoiceTotals[0].total ?? "0"}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell.empty,
                      ]),

                    // GRAND TOTAL row
                    if (controller.invoiceTotals.isNotEmpty)
                      DataRow(cells: [
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell(Text(
                          "GRAND TOTAL",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.bold),
                        )),
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell.empty,
                        DataCell(Text(
                            "£${controller.invoiceTotals[0].grandTotal ?? "0"}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell.empty,
                      ]),
                  ],
                ),
              ),
            ),
          ],
        );
      });
    });
  }
}
