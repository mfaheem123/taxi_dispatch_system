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
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)


  InvoiceController Controller = Get.isRegistered<InvoiceController>()
      ? Get.find<InvoiceController>()
      : Get.put(InvoiceController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "CreateAccountInvoiceScreen";
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
          Controller.getSubsidiary();
          Controller.getInvoiceNumber();
          Controller.subsidiaries = null;
          Controller. selectAccountValue = null;
          Controller.selectDepartmentData = null;
          Controller.orderNumber.clear();
          Controller.fromDate = DateTime.now();
          Controller.toDate = DateTime.now();

        },
        builder: (controller) {
      return LayoutBuilder(

          builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        return
          controller.isSubsidiary == true? Center(child: CircularProgressIndicator()):

          Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                  height: 30,
                  child: KeyboardDatePicker(
                    initialDate: DateTime.now(),
                    onChanged: (date) {
                      setState(() {
                        controller.invoiceDateController = "${date.year}-${date.month}-${date.day}";
                        print(date);
                      });
                    },
                    onSubmitted: (date) {
                      setState(() {
                        controller.invoiceDateController = "${date.year}-${date.month}-${date.day}";
                      });
                      print("User pressed enter: $date");
                    },

                  )
              ),
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.invoiceDueDate,
              column: true,
              width: fieldWidth / 1.8,
              child: SizedBox(height: 30, child: KeyboardDatePicker(
                initialDate: DateTime.now(),
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
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 25),
                child: RichText(
                    text: TextSpan(
                        text: 'Invoice #',
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(text: " ${controller.invoiceNumberModel!.documentNumber!.prefix}" "${controller.invoiceNumberModel!.documentNumber!.endNumber}",
                          style: mozillaTextRegularText(
                              color: DynamicColors.redClr))
                    ]))),
            CustomDropdownField<Subsidiaries>(
              text: AppText.subsidiary,
              width: fieldWidth / 1.5,
              label: AppText.subsidiary,
              items: controller.subsDiaryModel?.subsidiaries ?? [],
              value: controller.subsidiaries,
              itemLabel: (item) => item.name ?? "",
              onChanged: (val) {
                controller.subsidiaries = val;
                controller.getAccountData(subsidiariesId: val!.id);
              },
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ACCOUNT",style:  mozillaTextSemiBoldText(context: context, fontSize: 13, )),
                SizedBox(
                  height: 30,
                  width:  fieldWidth / 1.5,
                  child: DropdownButtonFormField<DashboardAccountObject>(
                    decoration:const InputDecoration(
                      border:OutlineInputBorder(),isDense: true,),
                    value: controller.selectAccountValue,
                    items: controller.dashboardAccountData == null ? []
                        : controller.dashboardAccountData!.accounts!
                        .map((account) =>DropdownMenuItem<DashboardAccountObject>(
                          value: account,
                          child: Text(
                            account.name ?? "",
                            style:mozillaTextRegularText(
                              fontSize:12,
                              color: DynamicColors.textClr,
                            ),
                          ),
                        )).toList(),
                    onChanged: (v) {
                      controller.selectAccountValue = v;
                      controller.selectDepartmentData = null;
                      controller.update();
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text("DEPARTMENT" ,
                      style:  mozillaTextSemiBoldText(context: context, fontSize: 13, ) ),
                Container(
                  height: 30,
                  width:  fieldWidth / 1.5,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                        6),
                    border: Border.all(
                        color: DynamicColors
                            .primaryClr,
                        width: 1.2),
                  ),
                  child:DropdownButtonFormField< DepartmentObject>(
                    decoration:const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    value: controller.selectDepartmentData,
                    items: controller.selectAccountValue == null ? []
                        : controller
                        .selectAccountValue!
                        .departments!.map((department) =>
                        DropdownMenuItem<DepartmentObject>(
                          value: department,
                          child: Text(
                            department.name ?? "",
                            style:
                            mozillaTextRegularText(
                              fontSize: 12,
                              color: DynamicColors.textClr,
                            ),
                          ),
                        ))
                        .toList(),
                    onChanged: (v) {
                      controller.selectDepartmentData = v;
                      controller.update();
                    },
                  ),
                ),
              ],
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.orderNumber,
              width: fieldWidth,
              hintText: AppText.order,
              columnText: true,
              height: 30,
            ),

            labeledField(
              column: true,
              context: context,
              isMobile: isMobile,
              label: AppText.from,
              width: fieldWidth / 1.8,
              child: SizedBox(
                  height: 30,
                  child: KeyboardDatePicker(
                      initialDate: controller.fromDate ?? DateTime.now(),
                      onChanged: (fromDate) {
                        controller.fromDate = fromDate;
                        controller.update();
                      }

                      )

              ),
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
                  height: 30,
                  child: KeyboardDatePicker(
                    initialDate: controller.toDate ?? DateTime.now(),
                    onChanged: (toDate) {
                      controller.toDate = toDate;
                      controller.update();
                    },
                  )),
            ),
          SizedBox(width: 50),
            CustomButton(
              verticalPadding: 0.0,
              width: 40,
              height: 30,
              borderRadius: 4,
              btnText: AppText.filter,
              style: mozillaTextRegularText(
                  fontSize: 10, color: DynamicColors.whiteClr),
              onTap: () {
                controller.getAccountInvoiceByFilter();
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

Controller.addAccountInvoice();

              },
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
                  rows: controller.accountInvoiceBookingModel == null ? []
                      : [...controller.accountInvoiceBookingModel!.bookings!.map((booking) {
                      return DataRow(cells: [
                        DataCell(Checkbox(value: false, onChanged: (val) {})),
                        DataCell(Text(booking.referenceNumber ?? "")),
                        DataCell(Text("${booking.pickupDate ?? ""} ${booking.pickupTime ?? ""}")),
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
                        DataCell(Text(booking.meetAndGreet?.toString() ?? "0")),
                        DataCell(Text(booking.creditCardCharges ?? "0")),
                        DataCell(Text(booking.totalCharges?.toString() ?? "0")),
                        DataCell(Row(mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search, color: DynamicColors.primaryClr, size: 18),
                            Icon(Icons.clear, color: DynamicColors.redClr, size: 18),
                          ],
                        )),
                      ]);
                    }).toList(),
                    if (controller.accountInvoiceBookingModel?.total != null)
                      ...controller.accountInvoiceBookingModel!.total!.map((booking) {
                        return DataRow(cells: [
                          DataCell.empty, DataCell.empty, DataCell.empty, DataCell.empty,
                          DataCell.empty, DataCell.empty, DataCell.empty, DataCell.empty,
                          DataCell(Text("TOTAL", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold))),
                          DataCell(Text("£${booking.fareTotal ?? "0"}",  style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold ) )),
                          DataCell(Text("£${booking.parkingChargesTotal ?? "0"}", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold ))),
                          DataCell(Text("£${booking.waitingChargesTotal ?? "0"}", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold ))),
                          DataCell(Text("£${booking.extraDropChargesTotal ?? "0"}", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold ))),
                          DataCell(Text("£${booking.meetAndGreetTotal ?? "0"}", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold ))),
                          DataCell(Text("£${booking.congestionChargesTotal ?? "0"}", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold ))),
                          DataCell(Text("£${booking.total ?? "0"}" , style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold ),
                          )),
                          DataCell.empty,
                        ]);
                      }).toList(),
                    if (controller.accountInvoiceBookingModel?.total != null)
                      ...controller.accountInvoiceBookingModel!.total!.map((booking) {
                        return DataRow(cells: [
                          DataCell.empty, DataCell.empty, DataCell.empty, DataCell.empty,
                          DataCell.empty, DataCell.empty, DataCell.empty, DataCell.empty,
                          DataCell(Text("GRAND TOTAL", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold))),
                            DataCell.empty, DataCell.empty,
                            DataCell.empty, DataCell.empty,
                            DataCell.empty, DataCell.empty,
                          DataCell(Text("£${booking.grandTotal ?? "0"}",style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold ),
                          )),
                          DataCell.empty,
                        ]);
                      }).toList(),
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
