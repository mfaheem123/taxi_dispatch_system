


import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/account_controller.dart';

class InvoiceList extends StatefulWidget {
  const InvoiceList({super.key});

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "invoiceList";
  }


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
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
                  child: Text(AppText.customerInvoice, style: titleDesign()),
                ),
                SizedBox(
                  height: 8,
                ),
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.invoiceDate,
                  column: true,
                  width: fieldWidth,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.invoiceDueDate,
                  column: true,
                  width: fieldWidth,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text(AppText.invoice+" AG1757501649")),
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
                      width: fieldWidth/1.8,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.to,
                      width: fieldWidth/1.8,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    SizedBox(
                      width: 20,
                      child: Checkbox(value: true, onChanged: (v){
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("P/T"),
                    ),
                    SizedBox(
                      width: 20,
                      child: Checkbox(value: true, onChanged: (v){
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("CASH"),
                    ),
                    SizedBox(
                      width: 20,
                      child: Checkbox(value: true, onChanged: (v){
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("CREDIT CARD"),
                    ),
                    SizedBox(
                      width: 20,
                      child: Checkbox(value: true, onChanged: (v){
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("ACCOUNT"),
                    ),
                    SizedBox(
                      width: 20,
                      child: Checkbox(value: true, onChanged: (v){
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("CREDIT CARD PAID"),
                    ),
                    SizedBox(
                      width: fieldWidth/1.8,
                    ),
                    CustomButton(
                      verticalPadding: 0.0,
                      width: 40,
                      height: 30,
                      borderRadius: 4,
                      btnText: AppText.filter,
                      style: mozillaTextRegularText(
                        fontSize: 10,
                        color: DynamicColors.whiteClr
                      ),
                    ),
                    CustomButton(
                      verticalPadding: 0.0,
                      width: 40,
                      height: 30,
                      borderRadius: 4,
                      btnText: AppText.save,
                      style: mozillaTextRegularText(
                        fontSize: 10,
                        color: DynamicColors.whiteClr
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: Get.width,
                    child: DataTable(
                        columnSpacing: 20,
                        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                        dataRowMinHeight: 48,
                        dataRowMaxHeight: 56,
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        dataTextStyle: TextStyle(
                          fontSize: 10,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: DynamicColors.textClr.withOpacity(0.5))
                        ),
                        columns: [
                          DataColumn(
                            label: Checkbox(
                              value: false, // a bool you keep in state
                              onChanged: (val) {
                              },
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
                          buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                        ],
                        rows: List.generate(totalRows, (index) {
                          bool isSelected = index == selectedRowIndex;
                          return DataRow(
                            cells: [
                              DataCell(
                                Checkbox(
                                  value: isSelected, // ✅ controlled by your state
                                  onChanged: (val) {
                                    // update your selected index or list here
                                  },
                                ),
                              ),
                              const DataCell(Text("SALOON")),
                              const DataCell(Text("NW7")),
                              const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                              const DataCell(Text("£55.00")),
                              const DataCell(Text("SALOON")),
                              const DataCell(Text("NW7")),
                              const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                              const DataCell(Text("£55.00")),
                              const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                              const DataCell(Text("£55.00")),
                              const DataCell(Text("£55.00")),
                              const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                              const DataCell(Text("£55.00")),
                              const DataCell(Text("£55.00")),
                              DataCell(
                                Row(
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.transparent,), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(Icons.search,
                                        size: 28,
                                        color: DynamicColors.primaryClr,
                                      ),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.transparent,), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(Icons.clear,
                                        size: 28,
                                        color: DynamicColors.redClr,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        })
                    ),
                  ),
                ),
              ],
            );
          }
        );
      }
    );
  }
}
