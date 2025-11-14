


import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/fare_view/model/plotVehicleModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../drivers_view/controller/driver_controller.dart';
import '../controller/controller.dart';

class PlotFare extends StatefulWidget {
  const PlotFare({super.key});

  @override
  State<PlotFare> createState() => _PlotFareState();
}

class _PlotFareState extends State<PlotFare> {

  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "plotFare";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(
        initState: (v){
          controller.getPlotVehicleType();
          controller.getAllPlotFare();
        },


        builder: (controller) {
          return controller.getPlotVehicleTypeLoader==true?CircularProgressIndicator(): LayoutBuilder(
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
                        child: Text(AppText.plotFare, style: titleDesign()),
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
                                  CustomDropdownField<VehicleTypee>(
                                    label: "Select Subsidiary",
                                    width: Get.width / 5,
                                    height: 35,
                                    items: controller.plotVehicleTypeModel!.vehicleTypes!,
                                    value: controller.plotVehicleTypevalue,
                                    itemLabel: (templateList) =>
                                    templateList.name!,
                                    onChanged: (val) {
                                      controller.plotVehicleTypevalue = val;
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
                                        CustomDropdownField<Zonee>(
                                          label: "Select Subsidiary",
                                          width: Get.width / 5,
                                          height: 35,
                                          items: controller.plotVehicleTypeModel!.zones!,
                                          value: controller.Zoneevalue,
                                          itemLabel: (templateList) =>
                                          templateList.name!,
                                          onChanged: (val) {
                                            controller.Zoneevalue = val;
                                            controller.update();
                                          },
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
                                        CustomDropdownField<Zonee>(
                                          label: "Select Subsidiary",
                                          width: Get.width / 5,
                                          height: 35,
                                          items: controller.plotVehicleTypeModel!.zones!,
                                          value: controller.Zonee1value,
                                          itemLabel: (templateList) =>
                                          templateList.name!,
                                          onChanged: (val) {
                                            controller.Zonee1value = val;
                                            controller.update();
                                          },
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
                              onTap: (){
                                controller.postPlotFare();
                              },
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: Get.width/2,
                          child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(title: "VEHICLE",removeSearching: true),
                              buildHeaderWithSearch(title: "FROM PLOT",removeSearching: true),
                              buildHeaderWithSearch(title: "TO PLOT",removeSearching: true),
                              buildHeaderWithSearch(title: "FARES",removeSearching: true),
                              buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                            ],
                            rows: controller
                                .allPlotFareModel!.plotFares!
                                .map((plot) => DataRow(
                              cells: [
                                DataCell(Text(plot.vehicleType!.name ?? "")),
                                DataCell(Text(plot.pickupPlot!.name ?? "")),
                                DataCell(Text(plot.dropoffPlot!.name ?? "")),
                                DataCell(Text(plot.fares ?? "")),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: const Size(32, 32),
                                            side: const BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          onPressed: () {
                                            // 🟢 Edit action
                                          },
                                          child: Icon(Icons.edit_calendar,
                                              size: 20,
                                              color:
                                              DynamicColors.primaryClr),
                                        ),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: const Size(32, 32),
                                            side: const BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          onPressed: () {
                                            // 🔴 Delete action
                                          },
                                          child: Icon(Icons.delete_forever,
                                              size: 20,
                                              color: DynamicColors.redClr),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}