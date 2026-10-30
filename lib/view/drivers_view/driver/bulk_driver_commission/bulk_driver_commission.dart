import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/administration/model/list_subsDiary.dart';
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

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "bulkDriverCommission";
    controller.getSubsidiary();
    controller.clearBulkCommission();
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
                                      CustomDropdownField<Subsidiaries>(
                                        width: isCompact
                                            ? fieldWidth / 2.4
                                            : fieldWidth / 2,
                                        text: "SUBS",
                                        label: AppText.selectSubsidiary,
                                        items: controller.subsDiaryModel?.subsidiaries ?? [],
                                        value: controller.selectedSubsidiary,
                                        itemLabel: (item) => item.name ?? "",
                                        onChanged: (val) {
                                          controller.selectedSubsidiary = val;
                                          controller.update();
                                        },
                                      ),

                                      labeledField(
                                          context: context,
                                          isMobile: isMobile,
                                          label: AppText.from,
                                          width: isCompact
                                              ? fieldWidth / 2.4
                                              : fieldWidth / 2,
                                          column: true,
                                          child: SizedBox(
                                            height: isCompact ? 28 : 30,
                                            child: KeyboardDatePicker(
                                              initialDate: controller.bulkFromDate.isNotEmpty
                                                  ? DateTime.parse(controller.bulkFromDate)
                                                  : DateTime.now().subtract(Duration(days: 7)),
                                              onChanged: (date) {
                                                controller.bulkFromDate = date.toIso8601String().split("T").first;
                                                controller.update();
                                              },
                                              onSubmitted: (date) {
                                                controller.bulkFromDate = date.toIso8601String().split("T").first;
                                                controller.update();
                                              },
                                            ),
                                          )),

                                      labeledField(
                                          context: context,
                                          isMobile: isMobile,
                                          label: AppText.to,
                                          width: isCompact
                                              ? fieldWidth / 2.4
                                              : fieldWidth / 2,
                                          column: true,
                                          child: SizedBox(
                                            height: isCompact ? 28 : 30,
                                            child: KeyboardDatePicker(
                                              initialDate: controller.bulkToDate.isNotEmpty
                                                  ? DateTime.parse(controller.bulkToDate)
                                                  : DateTime.now(),
                                              onChanged: (date) {
                                                controller.bulkToDate = date.toIso8601String().split("T").first;
                                                controller.update();
                                              },
                                              onSubmitted: (date) {
                                                controller.bulkToDate = date.toIso8601String().split("T").first;
                                                controller.update();
                                              },
                                            ),
                                          )),

                                      SizedBox(width: isCompact ? 20 : 50),

                                      /// Action Buttons
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 18.0),
                                        child: Wrap(
                                          spacing: isCompact ? 6 : 8,
                                          runSpacing: 8,
                                          children: [
                                            CustomButton(
                                              width: isCompact ? 90 : 100,
                                              height: isCompact ? 30 : 33,
                                              borderRadius: 4,
                                              btnColor: DynamicColors.primaryClr,
                                              style: mozillaTextSemiBoldText(
                                                  fontSize: 11, color: DynamicColors.whiteClr),
                                              verticalPadding: 0.0,
                                              btnText: AppText.getBooking,
                                              onTap: () {
                                                controller.getBulkCommission();
                                              },
                                            ),
                                            CustomButton(
                                              width: isCompact ? 60 : 80,
                                              height: isCompact ? 30 : 33,
                                              borderRadius: 4,
                                              btnColor: DynamicColors.redClr,
                                              style: mozillaTextSemiBoldText(
                                                  fontSize: 11, color: DynamicColors.whiteClr),
                                              verticalPadding: 0.0,
                                              btnText: AppText.clear,
                                              onTap: () {
                                                controller.clearBulkCommission();
                                              },
                                            ),
                                            CustomButton(
                                              width: isCompact ? 70 : 90,
                                              height: isCompact ? 30 : 33,
                                              borderRadius: 4,
                                              btnColor: DynamicColors.greenClr,
                                              style: mozillaTextSemiBoldText(
                                                  fontSize: 11, color: DynamicColors.whiteClr),
                                              verticalPadding: 0.0,
                                              btnText: AppText.generate,
                                              onTap: () {

                                              },
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
                                          style: mozillaTextSemiBoldText(
                                              fontSize: 11, color: DynamicColors.whiteClr),
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
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    child: SizedBox(
                      width: Get.width,
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(
                              widget: Checkbox(
                                  value: controller.selectBulkDrivers.value,
                                  onChanged: (v) {
                                    controller.selectBulkDrivers.value = v!;
                                    controller.update();
                                  })),
                          buildHeaderWithSearch(title: "DRIVER", removeSearching: true),
                          buildHeaderWithSearch(title: "BOOKINGS", removeSearching: true),
                          buildHeaderWithSearch(title: "CASH TOTAL", removeSearching: true),
                          buildHeaderWithSearch(title: "ACCOUNT TOTALS", removeSearching: true),
                          buildHeaderWithSearch(title: "TOTALS", removeSearching: true),
                          buildHeaderWithSearch(title: "COMM", removeSearching: true),
                          buildHeaderWithSearch(title: "OLD BALANCE", removeSearching: true),
                          buildHeaderWithSearch(title: "BALANCE", removeSearching: true),
                          buildHeaderWithSearch(title: "OWED", removeSearching: true),
                          buildHeaderWithSearch(title: "ACTION", removeSearching: true),
                        ],
                        totalRow: controller.getBulkCommissionModel?.data?.length ?? 0,
                        rows: controller.getBulkCommissionModel?.data?.map((item) {
                          return DataRow(cells: [
                            DataCell(Center(
                                child: Checkbox(
                                    value: controller.selectBulkDrivers.value,
                                    onChanged: (v) {
                                      controller.selectBulkDrivers.value = v!;
                                      controller.update();
                                    }))),
                            DataCell(Center(child: Text(item.driver?.name ?? ""))),
                            DataCell(Center(child: Text(item.bookingsCount ?? ""))),
                            DataCell(Center(child: Text("£ ${item.cashJobsTotal ?? ""}"))),
                            DataCell(Center(child: Text("£ ${item.accountJobsTotal ?? ""}"))),
                            DataCell(Center(child: Text("£ ${item.jobsTotal ?? ""}"))),
                            DataCell(Center(child: Text("£ ${item.commissionTotal ?? ""}"))),
                            DataCell(Center(child: Text("£ ${item.oldBalance ?? ""}"))),
                            DataCell(Center(child: Text("£ ${item.currentBalance ?? ""}"))),
                            DataCell(Center(child: Text("£ ${item.owed ?? ""}"))),
                            DataCell(Center(child:
                            CustomButton(
                              width: 55,
                              height: 26,
                              btnText: AppText.view,
                              btnColor: DynamicColors.primaryClr,
                              borderRadius: 6,
                              verticalPadding: 0.0,
                              style: mozillaTextSemiBoldText(
                                  fontSize: 11, color: DynamicColors.whiteClr),
                            ))),
                          ]);
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
