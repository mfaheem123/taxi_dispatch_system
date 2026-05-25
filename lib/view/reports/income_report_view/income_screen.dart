import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/radio_button_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
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
          children: [
            SizedBox(
              height: 10,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              alignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 16,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Report Type",
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    StatusRadioGroup(
                      options: [
                        "ALL",
                        "CASH",
                        "ACCOUNT",
                      ],
                      onChanged: (index, value) {
                        debugPrint("Selected index: $index, value: $value");
                        // controller.selectedValue = index;
                      },
                    ),
                  ],
                ),
                SizedBox(width: 15),
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.from,
                  column: true,
                  width: fieldWidth / 2.2,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.to,
                  column: true,
                  width: fieldWidth / 2.2,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
                SizedBox(width: 15),
                CustomDropdownField<String>(
                  text: AppText.driver,
                  width: fieldWidth / 1.5,
                  label: AppText.selectDriver,
                  items: [
                    "25 GEORGE HAMPTON1",
                    "25 GEORGE HAMPTON2",
                    "25 GEORGE HAMPTON3",
                    "25 GEORGE HAMPTON4",
                    "25 GEORGE HAMPTON5",
                    "25 GEORGE HAMPTON6",
                  ],
                  value: controller.selectBookingDriver,
                  itemLabel: (val) => val,
                  onChanged: (val) {
                    controller.selectBookingDriver = val!;
                    controller.update();
                  },
                ),
                SizedBox(width: 15),

                CustomDropdownField<String>(
                  text: AppText.account,
                  width: fieldWidth / 1.5,
                  label: AppText.selectAccount,
                  items: [
                    "ACCOUNT 1",
                    "ACCOUNT 2",
                    "ACCOUNT 3",
                    "ACCOUNT 4",
                    "ACCOUNT 5",
                  ],
                  value: controller.selectAccount,
                  itemLabel: (val) => val,
                  onChanged: (val) {
                    controller.selectAccount = val!;
                    controller.update();
                  },
                ),
                SizedBox(width: 15),

                CustomDropdownField<String>(
                  text: AppText.subsidiary,
                  width: fieldWidth / 1.5,
                  label: AppText.selectSubsidiary,
                  items: [
                    "SUBSIDIARY 1",
                    "SUBSIDIARY 2",
                    "SUBSIDIARY 3",
                    "SUBSIDIARY 4",
                    "SUBSIDIARY 5",
                  ],
                  value: controller.selectSubsidiary,
                  itemLabel: (val) => val, // just show the string
                  onChanged: (val) {
                    controller.selectSubsidiary = val!;
                    controller.update();
                  },
                ),
                // SizedBox(
                //   width: 20,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: 150,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.filter,
                      fontSize: 14,
                    ),
                    SizedBox(width: 20),
                    CustomButton(
                      width: 150,
                      height: 30,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.view,
                      fontSize: 14,
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              color: DynamicColors.secondaryClr,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    AppText.totalBookings,
                    style: mozillaTextSemiBoldText(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    AppText.totalEarnings,
                    style: mozillaTextSemiBoldText(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
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
                      buildHeaderWithSearch(title: "DATETIME"),
                      buildHeaderWithSearch(title: "PICKUP"),
                      buildHeaderWithSearch(title: "DROPOFF"),
                      buildHeaderWithSearch(title: "VEHICLE"),
                      buildHeaderWithSearch(title: "DRIVER"),
                      buildHeaderWithSearch(title: "ACCOUNT"),
                      buildHeaderWithSearch(title: "FARES"),
                      buildHeaderWithSearch(title: "PARKING"),
                      buildHeaderWithSearch(title: "WAITING"),
                      buildHeaderWithSearch(title: "EXTRA DROP"),
                      buildHeaderWithSearch(title: "TOTAL"),
                    ],
                    totalRow: totalRows,
                    cells: [
                      const DataCell(Center(child: Text("#PHC VEHICLE"))),
                      const DataCell(Center(child: Text("20/10/2025"))),
                      const DataCell(Center(child: Text("#PHC VEHICLE"))),
                      const DataCell(Center(child: Text("#PHC VEHICLE"))),
                      const DataCell(Center(child: Text("20/10/2025"))),
                      const DataCell(Center(child: Text("#PHC VEHICLE"))),
                      const DataCell(Center(child: Text("20/10/2025"))),
                      const DataCell(Center(child: Text("20/10/2025"))),
                      const DataCell(Center(child: Text("#PHC VEHICLE"))),
                      const DataCell(Center(child: Text("#PHC VEHICLE"))),
                      const DataCell(Center(child: Text("20/10/2025"))),
                      const DataCell(Center(child: Text("#PHC VEHICLE"))),
                    ]),
              ),
            ),
          ],
        ));
      });
    });
  }
}
