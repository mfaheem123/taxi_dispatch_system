import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';
import '../driver_app_features/drivers_list_feature.dart';
import '../driver_app_features/pda_details_widget.dart';


class ListDriverCommission extends StatefulWidget {
  const ListDriverCommission({super.key});

  @override
  State<ListDriverCommission> createState() => _ListDriverCommissionState();
}

class _ListDriverCommissionState extends State<ListDriverCommission> {

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "driverCommission";
  }

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<DriverController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        final bool isLaptop = maxWidth >= 1024 && maxWidth < 1440;
        final bool isLargeScreen = maxWidth >= 1440;

        final double fieldWidth = isMobile
            ? maxWidth * 0.9 // almost full width on mobile
            : isTablet
                ? 200 // smaller fixed size on tablet
                : isLaptop
                    ? 250 // medium size on laptop
                    : 330; // larger on LCD
        print(fieldWidth);
        return Column(
          children: [
            Container(
              width: Get.width,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(color: DynamicColors.gryClr)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: Text(
                      AppText.driverCommission,
                      style: titleDesign(),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: fieldWidth,
                          // height: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.drivers,
                                  style: mozillaTextSemiBoldText(
                                      context: context, fontSize: 13)),
                              RestrictedDrivers(
                                titleText: "SELECT DRIVER",
                                driversList: [
                                  "25 GEORGE HAMPTON",
                                  "26 PAUL DOUBLEDAY",
                                  "27 RICHARD HARDWICK",
                                  "28 LANRE OKERJO",
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppText.drivers,
                                style: mozillaTextSemiBoldText(
                                    context: context, fontSize: 13)),
                            SizedBox(
                              width: fieldWidth,
                              height: 30,
                              child: KeyboardDatePicker(),
                            ),
                          ],
                        ),
                        CustomTextField(
                          borderRadius: 4,
                          controller: controller.commissionController,
                          width: fieldWidth,
                          hintText: AppText.commission,
                          columnText: true,
                        ),
                        CustomTextField(
                          borderRadius: 4,
                          controller: controller.pdaRentController,
                          width: fieldWidth,
                          hintText: AppText.pdaRent,
                          columnText: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(AppText.from,
                      style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                          color: DynamicColors.gryClr)),
                ),
                SizedBox(
                  width: fieldWidth / 1.2,
                  height: 30,
                  child: KeyboardDatePicker(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(AppText.to,
                      style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                          color: DynamicColors.gryClr)),
                ),
                SizedBox(
                  width: fieldWidth / 1.2,
                  height: 30,
                  child: KeyboardDatePicker(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(AppText.pt,
                      style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                          color: DynamicColors.gryClr)),
                ),
                Checkbox(
                    value: controller.ptValue.value,
                    onChanged: (v) {
                      controller.ptValue.value = v!;
                      controller.update();
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(AppText.cash,
                      style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                          color: DynamicColors.gryClr)),
                ),
                Checkbox(
                    value: controller.cashValue.value,
                    onChanged: (v) {
                      controller.cashValue.value = v!;
                      controller.update();
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(AppText.creditCard,
                      style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                          color: DynamicColors.gryClr)),
                ),
                Checkbox(
                    value: controller.creditCardValue.value,
                    onChanged: (v) {
                      controller.creditCardValue.value = v!;
                      controller.update();
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(AppText.account,
                      style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                          color: DynamicColors.gryClr)),
                ),
                Checkbox(
                    value: controller.accountValue.value,
                    onChanged: (v) {
                      controller.accountValue.value = v!;
                      controller.update();
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(AppText.creditCardPaid,
                      style: mozillaTextSemiBoldText(
                          context: context,
                          fontSize: 13,
                          color: DynamicColors.gryClr)),
                ),
                SizedBox(
                  width: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomButton(
                    height: 30,
                    borderRadius: 6,
                    width: 80,
                    verticalPadding: 0.0,
                    btnText: AppText.filter,
                    btnColor: DynamicColors.primaryClr,
                    style: mozillaTextSemiBoldText(
                        fontSize: 13, color: DynamicColors.whiteClr),
                  ),
                ),
                CustomButton(
                  height: 30,
                  borderRadius: 6,
                  width: 80,
                  verticalPadding: 0.0,
                  btnText: AppText.save,
                  btnColor: DynamicColors.primaryClr,
                  style: mozillaTextSemiBoldText(
                      fontSize: 13, color: DynamicColors.whiteClr),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                dataRowMinHeight: 48,
                dataRowMaxHeight: 56,
                horizontalMargin: 0.0,
                checkboxHorizontalMargin: 0.0,
                showCheckboxColumn: true,
                columnSpacing: 5,
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
                dataTextStyle: TextStyle(
                  fontSize: 10,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: DynamicColors.textClr.withOpacity(0.5))),
                columns: [
                  buildHeaderWithSearch(
                      widget: Checkbox(
                          value: controller.selectAllDrivers.value,
                          onChanged: (v) {
                            controller.selectAllDrivers.value = v!;
                            controller.update();
                          })),
                  buildHeaderWithSearch(title: "COMM"),
                  buildHeaderWithSearch(title: "REF#"),
                  buildHeaderWithSearch(title: "DATETIME"),
                  buildHeaderWithSearch(title: "PICKUP"),
                  buildHeaderWithSearch(title: "DROPOFF"),
                  buildHeaderWithSearch(title: "VEH"),
                  buildHeaderWithSearch(title: "ACC"),
                  buildHeaderWithSearch(title: "J/T"),
                  buildHeaderWithSearch(title: "P/T"),
                  buildHeaderWithSearch(title: "FARE"),
                  buildHeaderWithSearch(title: "PC"),
                  buildHeaderWithSearch(title: "WC"),
                  buildHeaderWithSearch(title: "EDC"),
                  buildHeaderWithSearch(title: "CC"),
                  buildHeaderWithSearch(title: "W/COMM"),
                  buildHeaderWithSearch(title: "COMM"),
                  buildHeaderWithSearch(title: "TOTAL"),
                  buildHeaderWithSearch(title: "ACTIONS"),
                ],
                rows: List.generate(totalRows, (index) {
                  bool isSelected = index == selectedRowIndex;
                  return DataRow(
                    cells: [
                      DataCell(Checkbox(
                          value: controller.selectAllDrivers.value,
                          onChanged: (v) {
                            controller.selectAllDrivers.value = v!;
                            controller.update();
                          })),
                      const DataCell(Text("#PHC VEHICLE")),
                      const DataCell(Text("PHC VEHICLE")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("#PHC VEHICLE")),
                      const DataCell(Text("PHC VEHICLE")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("#PHC VEHICLE")),
                      const DataCell(Text("PHC VEHICLE")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("#PHC VEHICLE")),
                      const DataCell(Text("PHC VEHICLE")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("20/10/2025")),
                    ],
                  );
                })),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(AppText.total,
                style: mozillaTextSemiBoldText(
                  fontSize: 25,
                    color: DynamicColors.textClr.withOpacity(0.8),
                  fontWeight: FontWeight.w800
                ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customWidget(),
                    customWidget(
                      title: AppText.total+":",
                      value: "0"
                    ),
                    customWidget(
                      title: AppText.owed,
                      value: "0"
                    ),
                    customWidget(
                      title: AppText.owed,
                      value: "0"
                    ),
                    customWidget(
                      title: AppText.oldBalance,
                      value: "0"
                    ),
                    customWidget(
                      title: AppText.newBalance,
                      value: "0"
                    ),
                  ],
                ),
                SizedBox(width: 80,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customWidget(),
                    customWidget(
                      title: AppText.accountWCmm,
                      value: "0"
                    ),
                    customWidget(
                      title: AppText.accountWOCmm,
                      value: "0"
                    ),
                    customWidget(
                      title: AppText.parkingCongestion,
                      value: "0"
                    ),
                    customWidget(
                      title: AppText.totalCommission,
                      value: "0"
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      });
    });
  }

  Widget customWidget({title,value}){
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(title??AppText.cashTotal,
            style: mozillaTextSemiBoldText(
                fontSize: 20,
                color: DynamicColors.textClr.withOpacity(0.8),
                fontWeight: FontWeight.w800
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(value??"0",
            style: mozillaTextSemiBoldText(
                fontSize: 20,
                color: DynamicColors.textClr.withOpacity(0.8),
                fontWeight: FontWeight.w800
            ),
          ),
        ),

      ],
    );
  }

}
