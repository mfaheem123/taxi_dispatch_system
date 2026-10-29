import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
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

  String? selectSub = "SELECT SUBSIDIARY";

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driversBulkCommission";
  }

  int selectedRowIndex = 0;
  final int totalRows = 5;

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<DriverController>(builder: (controller) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

            final bool isCompact = maxWidth < 1550;

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
                  // maxWidth > 1034
                      // ?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                              // width: fieldWidth * 2.8,
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
                                    child: Text(AppText.duration,
                                      style: mozillaTextSemiBoldText(fontSize: 16),
                                    ),
                                  ),

                                  /// Fields Section
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Wrap(
                                      runSpacing: 8,
                                      spacing: isCompact ? 6 : 8,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                         CustomDropdownField(
                                           width: isCompact ? fieldWidth / 2.5 : fieldWidth / 2,
                                            text: "SUBS",
                                            label: AppText.selectSubsidiary,
                                            items: [
                                              "25 GEORGE HAMPTON",
                                              "26 PAUL DOUBLEDAY",
                                              "27 RICHARD HARDWICK",
                                              "28 LANRE OKERJO",
                                            ],
                                            value: selectSub,
                                            itemLabel: (val) => val,
                                            onChanged: (val) {
                                              selectSub = val;
                                              controller.update();
                                            },
                                          ),


                                          labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                              label: AppText.from,
                                              width: isCompact ? fieldWidth / 2.6 : fieldWidth / 2,
                                              column: true,
                                              child: SizedBox(
                                                height: isCompact ? 28 : 30,
                                                child: KeyboardDatePicker(),
                                              )),


                                       labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                           label: AppText.to,
                                           width: isCompact ? fieldWidth / 2.6 : fieldWidth / 2,
                                              column: true,
                                              child: SizedBox(
                                                height: isCompact ? 28 : 30,
                                                child: KeyboardDatePicker(),
                                              )),

                                        SizedBox(width: isCompact ? 20 : 50),
                                        /// Action Buttons
                                        Padding(
                                          padding: const EdgeInsets.only(top: 18.0),
                                          child: Wrap(
                                            spacing: isCompact ? 6 : 8,
                                            runSpacing: 8,
                                            children: [
                                              CustomButton(
                                                width: isCompact ? 85 : 100,
                                                height: isCompact ? 30 : 33,
                                                borderRadius: 4,
                                                btnColor: DynamicColors.primaryClr,
                                                style: mozillaTextRegularText(fontSize: 11, color: DynamicColors.whiteClr),
                                                verticalPadding: 0.0,
                                                btnText: AppText.getBooking,
                                              ),
                                              CustomButton(
                                                width: isCompact ? 60 : 80,
                                                height: isCompact ? 30 : 33,
                                                borderRadius: 4,
                                                btnColor: DynamicColors.redClr,
                                                style: mozillaTextRegularText(fontSize: 11, color: DynamicColors.whiteClr),
                                                verticalPadding: 0.0,
                                                btnText: AppText.clear,
                                              ),
                                              CustomButton(
                                                width: isCompact ? 70 : 90,
                                                height: isCompact ? 30 : 33,
                                                borderRadius: 4,
                                                btnColor: DynamicColors.greenClr,
                                                style: mozillaTextRegularText(fontSize: 10, color: DynamicColors.whiteClr),
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
                            )),

                            SizedBox(width: 10),
                            /// Responsive Box
                            Expanded(
                              flex: 2,
                              child: Container(
                              // width: fieldWidth,
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
                                    child: Text(AppText.info,
                                      style: mozillaTextSemiBoldText(fontSize: 16),
                                    ),
                                  ),

                                  /// Fields Section
                                  Padding(
                                    padding: EdgeInsets.all(isCompact ? 10.5 : 12.0),
                                    child: Wrap(
                                      runSpacing: 6,
                                      spacing: isCompact ? 20 : 30,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: isCompact ? fieldWidth / 1.3 : fieldWidth,
                                          child: labeledTextField(
                                                  context,
                                                  isMobile,
                                                  AppText.emailSubject,
                                                  controller.emailSubjectController,
                                                  width: fieldWidth,
                                                  column: true,
                                                  textInputAction: TextInputAction.next),
                                        ),

                                        /// Action Buttons
                                        Padding(
                                          padding: const EdgeInsetsGeometry.only(top: 18.0),
                                          child: CustomButton(
                                            width: 140,
                                            height: isCompact ? 30 : 33,
                                            borderRadius: 4,
                                            btnColor: DynamicColors.greenClr,
                                            style: mozillaTextRegularText(fontSize: 11, color: DynamicColors.whiteClr),
                                            verticalPadding: 0.0,
                                            btnText: AppText.generateSendPdf,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      // : Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Container(
                      //         width: fieldWidth * 2.8,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(color: DynamicColors.gryClr),
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             /// Header
                      //             Container(
                      //               width: double.infinity,
                      //               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      //               color: DynamicColors.gryClr.withOpacity(0.5),
                      //               child: Text(AppText.duration,
                      //                 style: mozillaTextSemiBoldText(fontSize: 16),
                      //               ),
                      //             ),
                      //
                      //             /// Fields Section
                      //             Padding(
                      //               padding: const EdgeInsets.all(12.0),
                      //               child: Wrap(
                      //                 runSpacing: 12,
                      //                 spacing: 20,
                      //                 crossAxisAlignment: WrapCrossAlignment.center,
                      //                 children: [
                      //                   SizedBox(
                      //                     width: fieldWidth / 1.5,
                      //                     child: CustomDropdownField(
                      //                       width: fieldWidth,
                      //                       label: AppText.selectSubsidiary,
                      //                       items: [
                      //                         "25 GEORGE HAMPTON",
                      //                         "26 PAUL DOUBLEDAY",
                      //                         "27 RICHARD HARDWICK",
                      //                         "28 LANRE OKERJO",
                      //                       ],
                      //                       value: selectSub,
                      //                       itemLabel: (val) => val,
                      //                       onChanged: (val) {
                      //                         selectSub = val;
                      //                         controller.update();
                      //                       },
                      //                     ),
                      //                   ),
                      //                   SizedBox(
                      //                     width: fieldWidth / 1.5,
                      //                     child: labeledField(
                      //                         context: context,
                      //                         isMobile: isMobile,
                      //                         label: AppText.from,
                      //                         width: fieldWidth,
                      //                         child: SizedBox(
                      //                             height: 30,
                      //                             child: KeyboardDatePicker())),
                      //                   ),
                      //
                      //                   SizedBox(
                      //                     width: fieldWidth / 1.5,
                      //                     child: labeledField(
                      //                         context: context,
                      //                         isMobile: isMobile,
                      //                         label: AppText.to,
                      //                         width: fieldWidth,
                      //                         child: SizedBox(
                      //                             height: 30,
                      //                             child: KeyboardDatePicker())),
                      //                   ),
                      //
                      //                   /// Action Buttons
                      //                   Padding(
                      //                     padding: const EdgeInsets.only(top: 18.0),
                      //                     child: Wrap(
                      //                       spacing: 8,
                      //                       runSpacing: 8,
                      //                       children: [
                      //                         CustomButton(
                      //                           width: 100,
                      //                           height: 33,
                      //                           borderRadius: 4,
                      //                           btnColor: DynamicColors.primaryClr,
                      //                           style: mozillaTextRegularText(fontSize: 11, color: DynamicColors.whiteClr),
                      //                           verticalPadding: 0.0,
                      //                           btnText: AppText.getBooking,
                      //                         ),
                      //                         CustomButton(
                      //                           width: 80,
                      //                           height: 33,
                      //                           borderRadius: 4,
                      //                           btnColor: DynamicColors.redClr,
                      //                           style: mozillaTextRegularText(fontSize: 11, color: DynamicColors.whiteClr),
                      //                           verticalPadding: 0.0,
                      //                           btnText: AppText.clear,
                      //                         ),
                      //                         CustomButton(
                      //                           width: 90,
                      //                           height: 33,
                      //                           borderRadius: 4,
                      //                           btnColor: DynamicColors.greenClr,
                      //                           style: mozillaTextRegularText(fontSize: 10, color: DynamicColors.whiteClr),
                      //                           verticalPadding: 0.0,
                      //                           btnText: AppText.generate,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(width: 15),
                      //
                      //       /// Responsive Box
                      //       Container(
                      //         width: fieldWidth,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(color: DynamicColors.gryClr),
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             /// Header
                      //             Container(
                      //               width: double.infinity,
                      //               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      //               color: DynamicColors.gryClr.withOpacity(0.5),
                      //               child: Text(AppText.info,
                      //                 style: mozillaTextSemiBoldText(fontSize: 16),
                      //               ),
                      //             ),
                      //
                      //             /// Fields Section
                      //             Padding(
                      //               padding: const EdgeInsets.all(12.0),
                      //               child: Wrap(
                      //                 runSpacing: 12,
                      //                 spacing: 20,
                      //                 crossAxisAlignment: WrapCrossAlignment.center,
                      //                 children: [
                      //                   SizedBox(
                      //                     width: fieldWidth / 1.7,
                      //                     child: Column(
                      //                       crossAxisAlignment: CrossAxisAlignment.start,
                      //                       children: [
                      //                         labeledTextField(
                      //                             context,
                      //                             isMobile,
                      //                             AppText.emailSubject,
                      //                             controller.emailSubjectController,
                      //                             width: fieldWidth,
                      //                             column: true,
                      //                             textInputAction: TextInputAction.next),
                      //                       ],
                      //                     ),
                      //                   ),
                      //
                      //                   /// Action Buttons
                      //                   Padding(
                      //                     padding: const EdgeInsets.only(top: 18.0),
                      //                     child: CustomButton(
                      //                       width: 140,
                      //                       height: 33,
                      //                       borderRadius: 4,
                      //                       btnColor: DynamicColors.greenClr,
                      //                       style: mozillaTextRegularText(fontSize: 11, color: DynamicColors.whiteClr),
                      //                       verticalPadding: 0.0,
                      //                       btnText: AppText.generateSendPdf,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),

                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    // scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: Get.width,
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(
                              widget: Checkbox(
                                  value: controller.selectAllDrivers.value,
                                  onChanged: (v) {
                                    controller.selectAllDrivers.value = v!;
                                    controller.update();
                                  })),
                          buildHeaderWithSearch(title: "DRIVER"),
                          buildHeaderWithSearch(title: "BOOKINGS"),
                          buildHeaderWithSearch(title: "CASH TOTAL"),
                          buildHeaderWithSearch(
                              title: "ACCOUNT TOTALS"),
                              // maxWidth > 1669
                              //     ? "ACCOUNT TOTALS"
                              //     : "ACCOUNT\nTOTALS"),
                          buildHeaderWithSearch(title: "TOTALS"),
                          buildHeaderWithSearch(title: "COMM"),
                          buildHeaderWithSearch(title: "OLD BALANCE"),
                          buildHeaderWithSearch(title: "BALANCE"),
                          buildHeaderWithSearch(title: "OWED"),
                          buildHeaderWithSearch(title: "ACTION"),
                        ],
                        totalRow: totalRows,
                        cells: [
                          DataCell(Checkbox(
                              value: controller.selectAllDrivers.value,
                              onChanged: (v) {
                                controller.selectAllDrivers.value = v!;
                                controller.update();
                              })),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
