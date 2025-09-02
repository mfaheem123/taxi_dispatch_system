



import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/controller.dart';

class FareConfigurationDay extends StatefulWidget {
  const FareConfigurationDay({super.key});

  @override
  State<FareConfigurationDay> createState() => _FareConfigurationDayState();
}

class _FareConfigurationDayState extends State<FareConfigurationDay> {


  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "fareConfigurationDay";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(builder: (controller) {
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

            return Column(
              children: [
                Container(
                  width: Get.width/1.5,
                  decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.gryClr)
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        color: DynamicColors.gryClr.withOpacity(0.5),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          children: [
                            Text(AppText.fareConfiguration, style: titleDesign()),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: DynamicColors.whiteClr,
                              ),
                              child: RestrictedDrivers(
                                width: fieldWidth,
                                height: 35,
                                padding: 0.0,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                titleText: "NORMAL DAY",
                                driversList: [
                                  "Sunday",
                                  "Monday",
                                  "Tuesday",
                                  "Wednesday",
                                  "Thursday",
                                  "Friday",
                                  "Saturday",
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Wrap(
                        verticalDirection: VerticalDirection.down,
                        spacing: fieldWidth/2,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.vehicleType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                              RestrictedDrivers(
                                width: fieldWidth,
                                // height: 35,
                                padding: 0.0,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                titleText: "VEHICLE TYPE",
                                driversList: [
                                  "25 GEORGE HAMPTON",
                                  "26 PAUL DOUBLEDAY",
                                  "27 RICHARD HARDWICK",
                                  "28 LANRE OKERJO",
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.account, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                              RestrictedDrivers(
                                width: fieldWidth,
                                // height: 35,
                                padding: 0.0,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                titleText: "ACCOUNT",
                                driversList: [
                                  "Sunday",
                                  "Monday",
                                  "Tuesday",
                                  "Wednesday",
                                  "Thursday",
                                  "Friday",
                                  "Saturday",
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Wrap(
                        verticalDirection: VerticalDirection.down,
                        spacing: fieldWidth/2,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.fromDay, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                              RestrictedDrivers(
                                width: fieldWidth,
                                // height: 35,
                                padding: 0.0,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                titleText: AppText.fromDay,
                                driversList: [
                                  "Sunday",
                                  "Monday",
                                  "Tuesday",
                                  "Wednesday",
                                  "Thursday",
                                  "Friday",
                                  "Saturday",
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.today, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                              RestrictedDrivers(
                                width: fieldWidth,
                                // height: 35,
                                padding: 0.0,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                titleText: AppText.today,
                                driversList: [
                                  "Sunday",
                                  "Monday",
                                  "Tuesday",
                                  "Wednesday",
                                  "Thursday",
                                  "Friday",
                                  "Saturday",
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Wrap(
                        verticalDirection: VerticalDirection.down,
                        spacing: fieldWidth/2,
                        children: [
                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.fromTime,
                            width: fieldWidth,
                            column: true,
                            child: SizedBox(height: 30, child: CustomTimePicker()),
                          ),

                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.toTime,
                            width: fieldWidth,
                            column: true,
                            child: SizedBox(height: 30, child: CustomTimePicker()),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Wrap(
                        verticalDirection: VerticalDirection.down,
                        spacing: fieldWidth/2,
                        children: [
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.startingFareController,
                            width: fieldWidth,
                            hintText: AppText.startingFare,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.startingMilesController,
                            width: fieldWidth,
                            hintText: AppText.startingMiles,
                            columnText: true,
                            height: 35,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomButton(
                          height: 30,
                          width: fieldWidth,
                          btnText: AppText.save,
                          verticalPadding: 0.0,
                          borderRadius: 4,
                          style: mozillaTextRegularText(
                              fontSize: 13,
                              color: DynamicColors.whiteClr
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 56,
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                      dataTextStyle: TextStyle(
                        fontSize: 10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: DynamicColors.textClr.withOpacity(0.5))
                      ),
                      columnSpacing: 12, // kam spacing taake sab fit ho
                      horizontalMargin: 8,
                      columns: [
                        buildHeaderWithSearch(title: "VEHICLE TYPE"),
                        buildHeaderWithSearch(title: "ACCOUNT"),
                        buildHeaderWithSearch(title: "FROM DAY"),
                        buildHeaderWithSearch(title: "TO DAY"),
                        buildHeaderWithSearch(title: "FROM TIME"),
                        buildHeaderWithSearch(title: "TO TIME"),
                        buildHeaderWithSearch(title: "MINIMUM FARES"),
                        buildHeaderWithSearch(title: "MINIMUM MILES"),
                        buildHeaderWithSearch(title: "TITLE"),
                        buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                      ],
                      rows: List.generate(totalRows, (index) {
                        bool isSelected = index == selectedRowIndex;
                        return DataRow(
                          cells: [
                            const DataCell(Text("SALOON")),
                            const DataCell(Text("21213")),
                            const DataCell(Text("SUNDAY")),
                            const DataCell(Text("SUNDAY")),
                            const DataCell(Text("00:00:00")),
                            const DataCell(Text("23:59:00")),
                            const DataCell(Text("£ 6.20")),
                            const DataCell(Text("0.90 MI")),
                            const DataCell(Text("NORMAL FARES")),
                            DataCell(
                              Row(
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero, // 👈 yeh horizontal aur vertical padding remove karega
                                      minimumSize: const Size(32, 32), // 👈 button ka size fix karna zaroori hai
                                      side: BorderSide(color: Colors.transparent,), // border color & thickness
                                    ),
                                    onPressed: () {},
                                    child: Icon(Icons.edit_calendar,
                                      size: 20,
                                      color: DynamicColors.primaryClr,
                                    ),
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero, // 👈 yeh horizontal aur vertical padding remove karega
                                      minimumSize: const Size(32, 32), // 👈 button ka size fix karna zaroori hai
                                      side: BorderSide(color: Colors.transparent,), // border color & thickness
                                    ),
                                    onPressed: () {},
                                    child: Icon(Icons.clear,
                                      size: 20,
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
                )
              ],
            );
          }
        );
      }
    );
  }
}
