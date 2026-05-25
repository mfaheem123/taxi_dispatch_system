

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class CreiditCardPayments extends StatefulWidget {
  const CreiditCardPayments({super.key});

  @override
  State<CreiditCardPayments> createState() => _CreiditCardPaymentsState();
}

class _CreiditCardPaymentsState extends State<CreiditCardPayments> {

  int selectedRowIndex = 0;
  final int totalRows = 50;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (controller) {

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
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      width: fieldWidth/1.9,
                      column: true,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      column: true,
                      label: AppText.to,
                      width: fieldWidth/1.9,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    const Spacer(),

                    KeyboardCheckbox(
                      focusNode: controller.creditCardPaidNode,
                      value: controller.creditCardPaidValue.value,
                      label: AppText.paymentRef,
                      width: 160,
                      onChanged: (val) {
                        controller.creditCardPaidValue.value = val;
                        controller.update();
                      },
                    ),
                   const Spacer(),

                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.filter,
                      fontSize: 12,
                    ),
                    SizedBox(width: 10),
                    CustomButton(
                      width: 120,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.view,
                      fontSize: 12,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(title: "REF #"),
                          buildHeaderWithSearch(title: "STRIPE PAYMENT ID"),
                          buildHeaderWithSearch(title: "DATETIME"),

                          buildHeaderWithSearch(title: "PICKUP"),
                          buildHeaderWithSearch(title: "DROPOFF"),
                          buildHeaderWithSearch(title: "FARE"),

                          buildHeaderWithSearch(title: "J/T"),
                          buildHeaderWithSearch(title: "STATUS"),
                          buildHeaderWithSearch(title: "PAYMENT TYPE"),
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
                        ]
                    ),
                  ),
                ),
              ],
                )
            );
          }
        );
      }
    );
  }
}
