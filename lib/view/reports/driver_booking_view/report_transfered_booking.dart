import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/radio_button_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class ReportTransferedBooking extends StatefulWidget {
  const ReportTransferedBooking({super.key});

  @override
  State<ReportTransferedBooking> createState() =>
      _ReportTransferedBookingState();
}

class _ReportTransferedBookingState extends State<ReportTransferedBooking> {
  int selectedRowIndex = 0;
  final int totalRows = 20;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<ReportController>(builder: (controller) {
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
          return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TOP HEADING
                  const Text(
                    "TRANSFERED BOOKINGS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.from,
                        width: 150,
                        column: true,
                        child: SizedBox(height: 30, child: KeyboardDatePicker()),
                      ),
                      const SizedBox(width: 15),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.to,
                        width: 150,
                        column: true,
                        child: SizedBox(height: 30, child: KeyboardDatePicker()),
                      ),
                      const Spacer(),
                      Wrap(
                        spacing: 10,
                        children: [
                          CustomButton(
                            width: 100,
                            height: 32,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.filter,
                            fontSize: 12,
                          ),
                          CustomButton(
                            width: 100,
                            height: 32,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.view,
                            fontSize: 12,
                          ),
                          CustomButton(
                            width: 110,
                            height: 32,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.download,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: DynamicColors.secondaryClr,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "TOTAL BOOKINGS: 0",
                                style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TOTAL EARNINGS: £ 0",
                                style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(title: "REF #"),
                              buildHeaderWithSearch(title: "INITIAL SUBS"),
                              buildHeaderWithSearch(title: "CHANGED SUBS"),
                              buildHeaderWithSearch(title: "INVOICE #"),
                              buildHeaderWithSearch(title: "DATETIME"),
                              buildHeaderWithSearch(title: "CUSTOMER"),
                              buildHeaderWithSearch(title: "PICKUP"),
                              buildHeaderWithSearch(title: "DROPOFF"),
                              buildHeaderWithSearch(title: "FARE"),
                              buildHeaderWithSearch(title: "ACC"),
                              buildHeaderWithSearch(title: "ORDER #"),
                              buildHeaderWithSearch(title: "P/T"),
                              buildHeaderWithSearch(title: "J/T"),
                              buildHeaderWithSearch(title: "DRV"),
                              buildHeaderWithSearch(title: "VEH"),
                              buildHeaderWithSearch(title: "STATUS"),
                            ],
                            totalRow: totalRows,
                            cells: [
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("20/10/2025"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("20/10/2025"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("20/10/2025"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("20/10/2025"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("20/10/2025"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                              const DataCell(Center(child: Text("#PHC VEHICLE"))),
                            ]),
                      ),
                    ),
                  ),
                ],
              )
          );
        });
      }),
    );
  }
}