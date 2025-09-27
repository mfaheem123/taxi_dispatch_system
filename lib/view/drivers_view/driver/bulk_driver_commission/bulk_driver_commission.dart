



import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../component/color.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';

class BulkDriverCommission extends StatefulWidget {
  const BulkDriverCommission({super.key});

  @override
  State<BulkDriverCommission> createState() => _BulkDriverCommissionState();
}

class _BulkDriverCommissionState extends State<BulkDriverCommission> {
  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driversBulkCommission";
  }

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverController>(builder: (controller) {
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(AppText.bulkDriverCommission, style: titleDesign()),
                const SizedBox(height: 15),

                /// Responsive Box
                maxWidth >1034?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: fieldWidth*2.8,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.gryClr),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(
                              AppText.duration,
                              style: mozillaTextSemiBoldText(fontSize: 16),
                            ),
                          ),

                          /// Fields Section
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Wrap(
                              runSpacing: 12,
                              spacing: 20,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SizedBox(
                                  width: fieldWidth/1.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.sub,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13)),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: fieldWidth,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          border:Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: RestrictedDrivers(
                                          width: fieldWidth,
                                          border: Border.all(color: Colors.transparent),
                                          // border: Border(
                                          //   bottom: BorderSide(
                                          //     color: DynamicColors.gryClr, // border color
                                          //     width: 2.0,        // border thickness
                                          //   ),
                                          // ),
                                          titleText: "SELECT SUBSIDIARY",
                                          driversList: [
                                            "25 GEORGE HAMPTON",
                                            "26 PAUL DOUBLEDAY",
                                            "27 RICHARD HARDWICK",
                                            "28 LANRE OKERJO",
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth/1.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.from,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13)),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        height: 35,
                                        child: KeyboardDatePicker(),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: fieldWidth/1.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.to,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13)),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        height: 35,
                                        child: KeyboardDatePicker(),
                                      ),
                                    ],
                                  ),
                                ),

                                /// Action Buttons
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      CustomButton(
                                        width: 100,
                                        height: 33,
                                        borderRadius: 4,
                                        btnColor: DynamicColors.pink,
                                        style: mozillaTextRegularText(
                                            fontSize: 11,
                                            color: DynamicColors.whiteClr),
                                        verticalPadding: 0.0,
                                        btnText: AppText.getBooking,
                                      ),
                                      CustomButton(
                                        width: 80,
                                        height: 33,
                                        borderRadius: 4,
                                        btnColor: DynamicColors.redClr,
                                        style: mozillaTextRegularText(
                                            fontSize: 11,
                                            color: DynamicColors.whiteClr),
                                        verticalPadding: 0.0,
                                        btnText: AppText.clear,
                                      ),
                                      CustomButton(
                                        width: 90,
                                        height: 33,
                                        borderRadius: 4,
                                        style: mozillaTextRegularText(
                                            fontSize: 10,
                                            color: DynamicColors.whiteClr),
                                        verticalPadding: 0.0,
                                        btnText: AppText.generate,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// Responsive Box
                    Container(
                      width: fieldWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.gryClr),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(
                              AppText.info,
                              style: mozillaTextSemiBoldText(fontSize: 16),
                            ),
                          ),

                          /// Fields Section
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Wrap(
                              runSpacing: 12,
                              spacing: 20,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SizedBox(
                                  width: fieldWidth/1.7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      labeledTextField(context,
                                          isMobile,
                                          AppText.emailSubject,
                                          controller.emailSubjectController,
                                          width: fieldWidth,
                                          column: true,
                                          textInputAction: TextInputAction.next),
                                    ],
                                  ),
                                ),

                                /// Action Buttons
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: CustomButton(
                                    width: 140,
                                    height: 33,
                                    borderRadius: 4,
                                    style: mozillaTextRegularText(
                                        fontSize: 11,
                                        color: DynamicColors.whiteClr),
                                    verticalPadding: 0.0,
                                    btnText: AppText.generateSendPdf,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ):
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: fieldWidth*2.8,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.gryClr),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(
                              AppText.duration,
                              style: mozillaTextSemiBoldText(fontSize: 16),
                            ),
                          ),

                          /// Fields Section
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Wrap(
                              runSpacing: 12,
                              spacing: 20,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SizedBox(
                                  width: fieldWidth/1.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.sub,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13)),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: fieldWidth,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          border:Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: RestrictedDrivers(
                                          width: fieldWidth,
                                          border: Border.all(color: Colors.transparent),
                                          // border: Border(
                                          //   bottom: BorderSide(
                                          //     color: DynamicColors.gryClr, // border color
                                          //     width: 2.0,        // border thickness
                                          //   ),
                                          // ),
                                          titleText: "SELECT SUBSIDIARY",
                                          driversList: [
                                            "25 GEORGE HAMPTON",
                                            "26 PAUL DOUBLEDAY",
                                            "27 RICHARD HARDWICK",
                                            "28 LANRE OKERJO",
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth/1.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.from,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13)),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        height: 35,
                                        child: KeyboardDatePicker(),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: fieldWidth/1.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.to,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13)),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        height: 35,
                                        child: KeyboardDatePicker(),
                                      ),
                                    ],
                                  ),
                                ),

                                /// Action Buttons
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      CustomButton(
                                        width: 100,
                                        height: 33,
                                        borderRadius: 4,
                                        btnColor: DynamicColors.pink,
                                        style: mozillaTextRegularText(
                                            fontSize: 11,
                                            color: DynamicColors.whiteClr),
                                        verticalPadding: 0.0,
                                        btnText: AppText.getBooking,
                                      ),
                                      CustomButton(
                                        width: 80,
                                        height: 33,
                                        borderRadius: 4,
                                        btnColor: DynamicColors.redClr,
                                        style: mozillaTextRegularText(
                                            fontSize: 11,
                                            color: DynamicColors.whiteClr),
                                        verticalPadding: 0.0,
                                        btnText: AppText.clear,
                                      ),
                                      CustomButton(
                                        width: 90,
                                        height: 33,
                                        borderRadius: 4,
                                        style: mozillaTextRegularText(
                                            fontSize: 10,
                                            color: DynamicColors.whiteClr),
                                        verticalPadding: 0.0,
                                        btnText: AppText.generate,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// Responsive Box
                    Container(
                      width: fieldWidth*3,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.gryClr),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(
                              AppText.info,
                              style: mozillaTextSemiBoldText(fontSize: 16),
                            ),
                          ),

                          /// Fields Section
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Wrap(
                              runSpacing: 12,
                              spacing: 20,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SizedBox(
                                  width: fieldWidth/1.7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      labeledTextField(context,
                                          isMobile,
                                          AppText.emailSubject,
                                          controller.emailSubjectController,
                                          width: fieldWidth,
                                          column: true,
                                          textInputAction: TextInputAction.next),
                                    ],
                                  ),
                                ),

                                /// Action Buttons
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: CustomButton(
                                    width: 140,
                                    height: 33,
                                    borderRadius: 4,
                                    style: mozillaTextRegularText(
                                        fontSize: 11,
                                        color: DynamicColors.whiteClr),
                                    verticalPadding: 0.0,
                                    btnText: AppText.generateSendPdf,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: Get.width,
                    child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                        dataRowMinHeight: 48,
                        dataRowMaxHeight: 56,
                        headingRowHeight: 80,
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
                          buildHeaderWithSearch(
                              widget: Checkbox(value: controller.selectAllDrivers.value,
                                  onChanged: (v){
                                    controller.selectAllDrivers.value = v!;
                                    controller.update();
                                  })),
                          buildHeaderWithSearch(title: "DRIVER"),
                          buildHeaderWithSearch(title: "BOOKINGS"),
                          buildHeaderWithSearch(title: "CASH TOTAL"),
                          buildHeaderWithSearch(title: maxWidth > 1669? "ACCOUNT TOTALS":"ACCOUNT\nTOTALS"),
                          buildHeaderWithSearch(title: "TOTALS"),
                          buildHeaderWithSearch(title: "COMM"),
                          buildHeaderWithSearch(title: "OLD BALANCE"),
                          buildHeaderWithSearch(title: "BALANCE"),
                          buildHeaderWithSearch(title: "OWED"),
                          buildHeaderWithSearch(title: "ACTION"),
                        ],
                        rows: List.generate(totalRows, (index) {
                          bool isSelected = index == selectedRowIndex;
                          return DataRow(
                            cells: [
                              DataCell(Checkbox(value: controller.selectAllDrivers.value,
                                  onChanged: (v){
                                    controller.selectAllDrivers.value = v!;
                                    controller.update();
                                  })),
                              const DataCell(Text("#PHC VEHICLE")),
                              const DataCell(Text("PHC VEHICLE")),
                              const DataCell(Text("20/10/2025")),
                              const DataCell(Text("#PHC VEHICLE")),
                              const DataCell(Text("PHC VEHICLE")),
                              const DataCell(Text("20/10/2025")),
                              const DataCell(Text("#PHC VEHICLE")),
                              const DataCell(Text("PHC VEHICLE")),
                              const DataCell(Text("20/10/2025")),
                              const DataCell(Text("20/10/2025")),
                            ],
                          );
                        })
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}

