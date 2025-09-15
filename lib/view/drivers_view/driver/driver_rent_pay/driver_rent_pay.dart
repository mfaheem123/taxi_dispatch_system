


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/quotation_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';

class DriverRentPay extends StatefulWidget {
  const DriverRentPay({super.key});

  @override
  State<DriverRentPay> createState() => _DriverRentPayState();
}

class _DriverRentPayState extends State<DriverRentPay> {
  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverCommissionPay";
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    child: Text(AppText.driverRentPay, style: titleDesign()),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Wrap(
                      runSpacing: 12,
                      spacing: 20,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: fieldWidth/2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.driver,
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
                                  //     color: Colors.grey, // border color
                                  //     width: 2.0,        // border thickness
                                  //   ),
                                  // ),
                                  titleText: "SELECT Driver",
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
                          width: fieldWidth/3,
                          child: labeledTextField(context, isMobile, AppText.driverRent, controller.commissionDueController,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next,
                              column: true
                          ),
                        ),

                        SizedBox(
                          width: fieldWidth/3,
                          child: labeledTextField(context, isMobile, AppText.amount, controller.amountController,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next,
                              column: true
                          ),
                        ),

                        SizedBox(
                          width: fieldWidth/2,
                          child: labeledTextField(context, isMobile, AppText.description, controller.descriptionController,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next,
                              column: true
                          ),
                        ),
                        // Checkbox(value: controller.creditValue.value, onChanged: (v){
                        //   controller.creditValue.value = v!;
                        //   controller.update();
                        // }),
                        DynamicSwitch(
                          controller: controller.creditValue,
                          activeColor: DynamicColors.primaryClr,
                          inactiveColor: Colors.grey,
                          focusScale: 1.5,
                          onToggle: () {
                            print("Switch toggled: ${controller.creditValue.value}");
                          },
                        ),
                        Text(AppText.credit),
                        DynamicSwitch(
                          controller: controller.debitValue,
                          activeColor: DynamicColors.primaryClr,
                          inactiveColor: Colors.grey,
                          focusScale: 1.5,
                          onToggle: () {
                            print("Switch toggled: ${controller.debitValue.value}");
                          },
                        ),
                        Text(AppText.debit),
                        CustomButton(
                          width: 100,
                          height: 33,
                          borderRadius: 4,
                          style: mozillaTextRegularText(
                              fontSize: 11,
                              color: DynamicColors.whiteClr),
                          verticalPadding: 0.0,
                          btnText: AppText.save,
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
                                const DataCell(Text("#PHC VEHICLE")),
                                const DataCell(Text("PHC VEHICLE")),
                                const DataCell(Text("20/10/2025")),
                                const DataCell(Text("#PHC VEHICLE")),
                                const DataCell(Text("PHC VEHICLE")),
                                const DataCell(Text("PHC VEHICLE")),
                              ],
                            );
                          })
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      );
    }
    );
  }
}
