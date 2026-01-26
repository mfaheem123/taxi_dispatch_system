


import 'package:dashboard_new1/view/fare_view/fare_by_vehicle/model/fare_by_vehicle_model.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/controller.dart';
import '../model/fixedFareVehicleLocationTypeModel.dart';

class FareByVehicle extends StatefulWidget {
  const FareByVehicle({super.key});

  @override
  State<FareByVehicle> createState() => _FareByVehicleState();
}

class _FareByVehicleState extends State<FareByVehicle> {

  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "fareByVehicle";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(
        initState: (state) {
          controller.getFixedFareVehicleType();
          controller.getFareByVehicleSetting();
        },
        builder: (controller) {
      return controller.getFixedFareVehicleLoader == true
            ? Center(
          child: CircularProgressIndicator(),
        ):
        LayoutBuilder(
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
            border: Border.all(color: DynamicColors.gryClr)),
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  child: Text(AppText.fareByVehicle, style: titleDesign()),
                ),
                SizedBox(
                  height: 6,
                ),
                Wrap(
                  verticalDirection: VerticalDirection.down,
                  spacing: 30,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.vehicleType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),

                        CustomDropdownField<VehicleTypeFixed>(
                          label: "Select Vehicle Type",
                          width: Get.width / 5,
                          height: 35,
                          items: controller.VehicleTypeModel!.vehicleTypesFixed ?? [],
                          value: controller.createByVehicleTypes,
                          itemLabel: (templateList) => templateList.name ?? "",
                          onChanged: (val) {
                            controller.createByVehicleTypes = val;
                            controller.update();
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.operator, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                        CustomDropdownField<String>(
                          label: "SELECT Operater",
                          width: Get.width / 6,
                          height: 35,
                          items: [
                            "AMOUNT",
                            "PERCENTAGE",
                          ],
                          value: controller.fareByVehicleOperater,
                          itemLabel: (templateList) => templateList,
                          onChanged: (val) {
                            controller.fareByVehicleOperater = val;
                            controller.update();
                          },
                        ),
                      ],
                    ),
                    CustomTextField(
                      borderRadius: 4,
                      controller: controller.fareValueVehicleController,
                      width: fieldWidth/1.3,
                      hintText: AppText.value,
                      columnText: true,
                      height: 35,
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Wrap(
                  verticalDirection: VerticalDirection.down,
                  spacing: fieldWidth/2,
                  runSpacing: 6,
                  children: [
                    CustomButton(
                      onTap: (){
                        controller.postFareByVehicleSetting();
                        controller.getFareByVehicleSetting();
                      },
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
                    CustomButton(
                      height: 30,
                      width: fieldWidth,
                      btnText: AppText.clear,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      btnColor: DynamicColors.redClr,
                      style: mozillaTextRegularText(
                          fontSize: 13,
                          color: DynamicColors.whiteClr
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: Get.width,
                    child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "VEHICLE TYPE"),
                        buildHeaderWithSearch(title: "OPERATOR"),
                        buildHeaderWithSearch(title: "VALUE"),
                        buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                      ],
                      rows: controller.fareByVehicleSetting!.fareByVehicles!.map((farefxed) => DataRow(
                        cells: [
                          DataCell(Center(child: Text(farefxed.vehicleType!.name ?? ""))),
                          DataCell(Center(child: Text(farefxed.fareByVehicleOperator! ?? ""))),
                          DataCell(Center(child: Text(farefxed.value ?? ""))),
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
                                      controller.bindFareByVechicle(farefxed);
                                      controller.update();
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
                      )).toList(),
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
