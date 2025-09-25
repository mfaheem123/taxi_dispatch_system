



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/controller.dart';

class CreateFixedFareSetting extends StatefulWidget {
  const CreateFixedFareSetting({super.key});

  @override
  State<CreateFixedFareSetting> createState() => _CreateFixedFareSettingState();
}

class _CreateFixedFareSettingState extends State<CreateFixedFareSetting> {

  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "createFixedFareSetting";
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

            return Container(
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
                    child: Text(AppText.fixedFare, style: titleDesign()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                      verticalDirection: VerticalDirection.down,
                      spacing: fieldWidth/2,
                      children: [
                        SizedBox(
                          width: fieldWidth,
                          // height: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.vehicleType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                              RestrictedDrivers(
                                width: fieldWidth,
                                height: 35,
                                padding: 0.0,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                titleText: "SELECT VEHICLE TYPE",
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
                        CustomTextField(
                          borderRadius: 4,
                          controller: controller.fareController,
                          width: fieldWidth,
                          hintText: AppText.fare,
                          columnText: true,
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                      verticalDirection: VerticalDirection.down,
                      spacing: fieldWidth/2,
                      children: [
                        SizedBox(
                          width: fieldWidth,
                          // height: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.fromLocationType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                              RestrictedDrivers(
                                width: fieldWidth,
                                height: 35,
                                padding: 0.0,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                titleText: "ADDRESS",
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
                        SizedBox(
                          width: fieldWidth,
                          // height: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.toLocationType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                              RestrictedDrivers(
                                width: fieldWidth,
                                height: 35,
                                padding: 0.0,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                titleText: "ADDRESS",
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                      verticalDirection: VerticalDirection.down,
                      spacing: fieldWidth/2,
                      children: [
                        SizedBox(
                          width: fieldWidth,
                          // height: 30,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              SizedBox(
                                width: fieldWidth/1.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppText.fromPlot, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                    RestrictedDrivers(
                                      width: fieldWidth,
                                      height: 35,
                                      padding: 0.0,
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      titleText: "SELECT PLOT",
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
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(43, 42), // width & height
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4), // <-- border radius here
                                    ),
                                    side: BorderSide(color: DynamicColors.gryClr), // optional border color
                                  ),
                                  onPressed: (){

                                  }, child: Icon(Icons.add)
                              ),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(43, 42), // width & height
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4), // <-- border radius here
                                    ),
                                    side: BorderSide(color: DynamicColors.gryClr), // optional border color
                                  ),
                                  onPressed: (){

                                  }, child: Icon(Icons.delete_forever,
                                color: DynamicColors.redClr,
                                size: 20,
                              )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          // height: 30,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              SizedBox(
                                width: fieldWidth/1.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppText.fromPlot, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                    RestrictedDrivers(
                                      width: fieldWidth,
                                      height: 35,
                                      padding: 0.0,
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      titleText: "SELECT PLOT",
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
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(43, 42), // width & height
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4), // <-- border radius here
                                    ),
                                    side: BorderSide(color: DynamicColors.gryClr), // optional border color
                                  ),
                                  onPressed: (){

                                  }, child: Icon(Icons.add)
                              ),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(43, 42), // width & height
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4), // <-- border radius here
                                    ),
                                    side: BorderSide(color: DynamicColors.gryClr), // optional border color
                                  ),
                                  onPressed: (){

                                  }, child: Icon(Icons.delete_forever,
                                color: DynamicColors.redClr,
                                size: 20,
                              )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                      verticalDirection: VerticalDirection.down,
                      spacing: fieldWidth/2,
                      children: [
                        CustomTextField(
                          borderRadius: 4,
                          controller: controller.fareDescriptionController,
                          width: fieldWidth,
                          hintText: "",
                          columnText: true,
                          maxLines: 5,
                          height: 100,
                        ),
                        CustomTextField(
                          borderRadius: 4,
                          controller: controller.fareDescription2ndController,
                          width: fieldWidth,
                          hintText: "",
                          columnText: true,
                          maxLines: 5,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                      verticalDirection: VerticalDirection.down,
                      spacing: fieldWidth/2,
                      children: [
                        CustomButton(
                          height: 35,
                          width: fieldWidth,
                          btnText: AppText.save,
                          verticalPadding: 0.0,
                          borderRadius: 4,
                          style: mozillaTextRegularText(
                              fontSize: 13,
                              color: DynamicColors.whiteClr
                          ),
                        ),
                        CustomButton(
                          height: 35,
                          width: fieldWidth,
                          btnText: AppText.clear,
                          verticalPadding: 0.0,
                          btnColor: DynamicColors.redClr,
                          borderRadius: 4,
                          style: mozillaTextRegularText(
                              fontSize: 13,
                              color: DynamicColors.whiteClr
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: DataTable(
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
                          buildHeaderWithSearch(title: "VEHICLE"),
                          buildHeaderWithSearch(title: "FROM LOCATION"),
                          buildHeaderWithSearch(title: "TO LOCATION"),
                          buildHeaderWithSearch(title: "FARES"),
                          buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                        ],
                        rows: List.generate(totalRows, (index) {
                          bool isSelected = index == selectedRowIndex;
                          return DataRow(
                            cells: [
                              const DataCell(Text("SALOON")),
                              const DataCell(Text("NW7")),
                              const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                              const DataCell(Text("£55.00")),
                              DataCell(
                                Row(
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.transparent,), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(Icons.edit_calendar,
                                        size: 28,
                                        color: DynamicColors.primaryClr,
                                      ),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.transparent,), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(Icons.delete_forever,
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
                  )
                ],
              ),
            );
          }
      );
    });
  }
}
