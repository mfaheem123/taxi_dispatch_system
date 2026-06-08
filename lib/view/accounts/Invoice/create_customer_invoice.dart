
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
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
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/account_controller.dart';



class CreateCustomerInvoice extends StatefulWidget {
  const CreateCustomerInvoice({super.key});

  @override
  State<CreateCustomerInvoice> createState() => _CreateCustomerInvoiceState();
}

/// ye screen Customer invoice ki hai   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class _CreateCustomerInvoiceState extends State<CreateCustomerInvoice> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

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
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width / WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<AccountController>(
        initState: (v){
          permissions = Api().sp.read('all_permissions') ?? [];
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
              child: Text(

                  AppText.customerInvoice,

                  style: titleDesign()),
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
                child: Text(AppText.invoice + " AG1757501649")),
            CustomTextField(
              borderRadius: 4,
              controller: controller.customerNameController,
              width: fieldWidth,
              hintText: AppText.name,
              columnText: true,
              height: 30,
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.customerEmailController,
              width: fieldWidth,
              hintText: AppText.email,
              columnText: true,
              height: 30,
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.customerMobileController,
              width: fieldWidth,
              hintText: AppText.mobile,
              columnText: true,
              height: 30,
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.customerTelephoneController,
              width: fieldWidth,
              hintText: AppText.tel,
              columnText: true,
              height: 30,
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.from,
                  width: fieldWidth / 1.8,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.to,
                  width: fieldWidth / 1.8,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
                customWidget(
                  value: controller.P_T_Value.value,
                  onChanged: (v) {
                    controller.P_T_Value.value = v!;
                    controller.update();
                  },
                  text: "P/T",
                  width: 140,
                ),
                customWidget(
                  value: controller.cashValue.value,
                  onChanged: (v) {
                    controller.cashValue.value = v!;
                    controller.update();
                  },
                  text: "CASH",
                  width: 140,
                ),
                customWidget(
                  value: controller.creditValue.value,
                  onChanged: (v) {
                    controller.creditValue.value = v!;
                    controller.update();
                  },
                  text: "CREDIT CARD",
                  width: 140,
                ),
                customWidget(
                  value: controller.account_Value.value,
                  onChanged: (v) {
                    controller.account_Value.value = v!;
                    controller.update();
                  },
                  text: "ACCOUNT",
                  width: 140,
                ),
                customWidget(
                  value: controller.creditCardPaid_Value.value,
                  onChanged: (v) {
                    controller.creditCardPaid_Value.value = v!;
                    controller.update();
                  },
                  text: "CREDIT CARD PAID",
                  width: 140,
                ),
                CustomButton(
                  verticalPadding: 0.0,
                  width: 40,
                  height: 30,
                  borderRadius: 4,
                  btnText: AppText.filter,
                  style: mozillaTextRegularText(
                      fontSize: 10, color: DynamicColors.whiteClr),
                ),
                if(permissions.contains('create_customer_invoice')) CustomButton(
                  onTap: (){
                    controller.showDownloadButtons.value = true;
                  },
                  verticalPadding: 0.0,
                  width: 40,
                  height: 30,
                  borderRadius: 4,
                  btnText: AppText.save,
                  style: mozillaTextRegularText(
                      fontSize: 10, color: DynamicColors.whiteClr),
                ),

                /// PDF BUTTON
                Obx(() => controller.showDownloadButtons.value
                    ? CustomButton(
                  onTap: () async {
                    if (controller.templeteHtmlModel == null) {
                      await controller.getTemplateHtmlText();
                    }
                    await controller.downloadApiContentAsFile();
                  },
                  verticalPadding: 0.0,
                  width: 110,
                  height: 35,
                  borderRadius: 4,
                  btnText: "DOWNLOAD PDF",
                  style: mozillaTextRegularText(
                    fontSize: 10,
                    color: DynamicColors.whiteClr,
                  ),
                )
                    : const SizedBox(),
                ),

                /// EXCEL BUTTON
                Obx(() => controller.showDownloadButtons.value
                    ? CustomButton(
                  onTap: () {
                    print("DOWNLOAD EXCEL");
                    downloadExcelWeb(controller.invoiceList);
                  },
                  verticalPadding: 0.0,
                  width: 120,
                  height: 35,
                  borderRadius: 4,
                  btnText: "DOWNLOAD EXCEL",
                  style: mozillaTextRegularText(
                    fontSize: 10,
                    color: DynamicColors.whiteClr,
                  ),
                )

                    : const SizedBox()),

              ],
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
                  totalRow: totalRows,
                  rows: controller.invoiceList.map((e) {
                    return DataRow(cells: [
                      DataCell(Checkbox(value: false, onChanged: (_) {})),
                      DataCell(Center(child: Text(e.ref))),
                      DataCell(Center(child: Text(e.datetime))),
                      DataCell(Center(child: Text(e.pickup))),
                      DataCell(Center(child: Text(e.dropoff))),
                      DataCell(Center(child: Text(e.datetime))),
                      DataCell(Center(child: Text(e.pickup))),
                      DataCell(Center(child: Text(e.dropoff))),
                      DataCell(Center(child: Text(e.fare))),
                        const DataCell(Center(child: Text("HEATHROW TERMINAL 2 TW6 1JS"))),
                        const DataCell(Center(child: Text("£55.00"))),
                        const DataCell(Center(child: Text("£55.00"))),
                        const DataCell(Center(child: Text("HEATHROW TERMINAL 2 TW6 1JS"))),
                        const DataCell(Center(child: Text("£55.00"))),
                        const DataCell(Center(child: Text("£55.00"))),
                      DataCell(
                        Center(
                          child:   Row(
                          children: [
                            if(permissions.contains('update_customer_invoice')) OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.transparent,
                                ), // border color & thickness
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.edit_calendar_rounded,
                                size: 28,
                                color: DynamicColors.primaryClr,
                              ),
                            ),
                            if(permissions.contains('delete_customer_invoice')) OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.transparent,
                                ), // border color & thickness
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.delete_forever,
                                size: 28,
                                color: DynamicColors.redClr,
                              ),
                            ),
                          ],
                        ),
                        ),
                      ),
                    ]);
                  }).toList(),


                  // cells: [
                  //   DataCell(
                  //     Checkbox(
                  //       value: false, // ✅ controlled by your state
                  //       onChanged: (val) {
                  //         // update your selected index or list here
                  //       },
                  //     ),
                  //   ),
                  //   const DataCell(Text("SALOON")),
                  //   const DataCell(Text("NW7")),
                  //   const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                  //   const DataCell(Text("£55.00")),
                  //   const DataCell(Text("SALOON")),
                  //   const DataCell(Text("NW7")),
                  //   const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                  //   const DataCell(Text("£55.00")),
                  //   const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                  //   const DataCell(Text("£55.00")),
                  //   const DataCell(Text("£55.00")),
                  //   const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                  //   const DataCell(Text("£55.00")),
                  //   const DataCell(Text("£55.00")),
                  //   DataCell(
                  //     Row(
                  //       children: [
                  //         OutlinedButton(
                  //           style: OutlinedButton.styleFrom(
                  //             side: BorderSide(
                  //               color: Colors.transparent,
                  //             ), // border color & thickness
                  //           ),
                  //           onPressed: () {},
                  //           child: Icon(
                  //             Icons.search,
                  //             size: 28,
                  //             color: DynamicColors.primaryClr,
                  //           ),
                  //         ),
                  //         OutlinedButton(
                  //           style: OutlinedButton.styleFrom(
                  //             side: BorderSide(
                  //               color: Colors.transparent,
                  //             ), // border color & thickness
                  //           ),
                  //           onPressed: () {},
                  //           child: Icon(
                  //             Icons.clear,
                  //             size: 28,
                  //             color: DynamicColors.redClr,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                ),
              ),
            ),
          ],
        );
      });
    });
  }
}


class InvoiceRow {
  final String ref;
  final String datetime;
  final String pickup;
  final String dropoff;
  final String fare;
  final String pickup1;
  final String dropoff2;
  final String fare3;


  InvoiceRow({
    required this.ref,
    required this.datetime,
    required this.pickup,
    required this.dropoff,
    required this.fare,
    required this.pickup1,
    required this.dropoff2,
    required this.fare3,
  });
}












Future<void> downloadExcelWeb(List<InvoiceRow> list) async {
  var excel = Excel.createExcel();
  Sheet sheet = excel['Invoice'];

  // Header row
  sheet.appendRow([
    TextCellValue('REF'),
    TextCellValue('DATE'),
    TextCellValue('PICKUP'),
    TextCellValue('DROPOFF'),
    TextCellValue('PICKUP1'),
    TextCellValue('DROPOFF2'),
    TextCellValue('FARE3'),
  ]);

  // Data rows
  for (var e in list) {
    sheet.appendRow([
      TextCellValue(e.ref.isNotEmpty ? e.ref : 'No Data'),
      TextCellValue(e.datetime.isNotEmpty ? e.datetime : 'No Data'),
      TextCellValue(e.pickup.isNotEmpty ? e.pickup : 'No Data'),
      TextCellValue(e.dropoff.isNotEmpty ? e.dropoff : 'No Data'),
      TextCellValue(e.fare.isNotEmpty ? e.fare : 'No Data'),
      TextCellValue(e.dropoff2.isNotEmpty ? e.dropoff : 'No Data'),
      TextCellValue(e.fare3.isNotEmpty ? e.fare : 'No Data'),
    ]);
  }

  final List<int>? excelBytes = excel.encode();
  if (excelBytes == null) return;

  // Download for web
  final blob = html.Blob([excelBytes],
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  final url = html.Url.createObjectUrlFromBlob(blob);

  html.AnchorElement(href: url)
    ..setAttribute("download", "invoice.xlsx")
    ..click();

  html.Url.revokeObjectUrl(url);
}










