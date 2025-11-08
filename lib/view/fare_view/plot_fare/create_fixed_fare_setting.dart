import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/fare_view/model/fixedFareVehicleLocationTypeModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
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
  final int totalRows =
      50; // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "createFixedFareSetting";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(

        initState: (v){
         controller.getFixedFareVehicleLocationType();
        },


        builder: (controller) {
      return controller.getFixedFareVehicleLocationTypeLoader.value
          ? Center(
        child: CircularProgressIndicator(),
      )
          : LayoutBuilder(builder: (context, constraints) {
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
          width: Get.width / 1.5,
          decoration:
              BoxDecoration(border: Border.all(color: DynamicColors.gryClr)),
          child: Column(
            children: [
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                  spacing: fieldWidth / 2,
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      // height: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppText.vehicleType,
                              style: mozillaTextSemiBoldText(
                                  context: context, fontSize: 13)),
                          CustomDropdownField<VehicleTypeFixed>(
                            label: "Select Subsidiary",
                            width: Get.width / 5,
                            height: 35,
                            items: controller.fixedFareVehicleLocationTypeModel!.vehicleTypesFixed!,
                            value: controller.vehicleTypesFixedvalue,
                            itemLabel: (templateList) =>
                            templateList.name!,
                            onChanged: (val) {
                              controller.vehicleTypesFixedvalue = val;
                              controller.update();
                            },
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
                  spacing: fieldWidth / 2,
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      // height: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppText.fromLocationType,
                              style: mozillaTextSemiBoldText(
                                  context: context, fontSize: 13)),
                          CustomDropdownField<LocationType>(
                            label: "Select Location Type",
                            width: Get.width / 5,
                            height: 35,
                            items: controller.fixedFareVehicleLocationTypeModel!.locationTypes!,
                            value: controller.locationTypevalue,
                            itemLabel: (templateList) =>
                            templateList.name!,
                            onChanged: (val) {
                              controller.locationTypevalue = val;
                              controller.update();
                            },
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
                          Text(AppText.toLocationType,
                              style: mozillaTextSemiBoldText(
                                  context: context, fontSize: 13)),
                          CustomDropdownField<LocationType>(
                            label: "Select Location Type",
                            width: Get.width / 5,
                            height: 35,
                            items: controller.fixedFareVehicleLocationTypeModel!.locationTypes!,
                            value: controller.locationTypevalue,
                            itemLabel: (templateList) =>
                            templateList.name!,
                            onChanged: (val) {
                              controller.locationTypevalue = val;
                              controller.update();
                            },
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
                  spacing: fieldWidth / 2,
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      // height: 30,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          SizedBox(
                            width: fieldWidth / 1.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("From Location",
                                    style: mozillaTextSemiBoldText(
                                        context: context, fontSize: 13)),
                                RestrictedDrivers(
                                  width: fieldWidth,
                                  height: 35,
                                  padding: 0.0,
                                  border: Border.all(
                                    color: DynamicColors.gryClr,
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
                                side: BorderSide(
                                    color: DynamicColors.gryClr), // optional border color
                              ),
                              onPressed: () {},
                              child: Icon(Icons.add)),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(43, 42), // width & height
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4), // <-- border radius here
                                ),
                                side: BorderSide(
                                    color: DynamicColors.gryClr), // optional border color
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.delete_forever,
                                color: DynamicColors.redClr,
                                size: 20,
                              )),
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
                            width: fieldWidth / 1.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("To Location ",
                                    style: mozillaTextSemiBoldText(
                                        context: context, fontSize: 13)),
                                RestrictedDrivers(
                                  width: fieldWidth,
                                  height: 35,
                                  padding: 0.0,
                                  border: Border.all(
                                    color: DynamicColors.gryClr,
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
                                minimumSize:
                                    const Size(43, 42), // width & height
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // <-- border radius here
                                ),
                                side: BorderSide(
                                    color: DynamicColors
                                        .gryClr), // optional border color
                              ),
                              onPressed: () {},
                              child: Icon(Icons.add)),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize:
                                    const Size(43, 42), // width & height
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // <-- border radius here
                                ),
                                side: BorderSide(
                                    color: DynamicColors
                                        .gryClr), // optional border color
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.delete_forever,
                                color: DynamicColors.redClr,
                                size: 20,
                              )),
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
                  spacing: fieldWidth / 2,
                  children: [
                    CustomTextField(
                      contentPadding: EdgeInsets.all(8.0),
                      borderRadius: 4,
                      controller: controller.fareDescriptionController,
                      width: fieldWidth,
                      hintText: "",
                      columnText: true,
                      maxLines: 5,
                      height: 100,
                    ),
                    CustomTextField(
                      contentPadding: EdgeInsets.all(8.0),
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
                  spacing: fieldWidth / 2,
                  children: [
                    CustomButton(
                      height: 35,
                      width: fieldWidth,
                      btnText: AppText.save,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      style: mozillaTextRegularText(
                          fontSize: 13, color: DynamicColors.whiteClr),
                    ),
                    CustomButton(
                      height: 35,
                      width: fieldWidth,
                      btnText: AppText.clear,
                      verticalPadding: 0.0,
                      btnColor: DynamicColors.redClr,
                      borderRadius: 4,
                      style: mozillaTextRegularText(
                          fontSize: 13, color: DynamicColors.whiteClr),
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
                  child: DatatableWidget(
                    columns: [
                      buildHeaderWithSearch(title: "VEHICLE"),
                      buildHeaderWithSearch(title: "FROM LOCATION"),
                      buildHeaderWithSearch(title: "TO LOCATION"),
                      buildHeaderWithSearch(title: "FARES"),
                      buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                    ],
                    totalRow: totalRows,
                    cells: [
                      const DataCell(Center(child: Text("SALOON"))),
                      const DataCell(Center(child: Text("NW7"))),
                      const DataCell(
                          Center(child: Text("HEATHROW TERMINAL 2 TW6 1JS"))),
                      const DataCell(Center(child: Text("£55.00"))),
                      DataCell(
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ), // border color & thickness
                                ),
                                onPressed: () {},
                                child: Icon(
                                  Icons.edit_calendar,
                                  size: 28,
                                  color: DynamicColors.primaryClr,
                                ),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ), // border color & thickness
                                ),
                                onPressed: () {},
                                child: Icon(
                                  Icons.delete_forever,
                                  size: 28,
                                  color: DynamicColors.redClr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
