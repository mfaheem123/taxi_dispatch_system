import 'package:dashboard_new1/view/fare_view/fare_by_vehicle/model/fare_by_vehicle_model.dart'
    as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../page_scroller.dart';
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

  List permissions = [];
  @override
  void initState() {
    permissions = Api().sp.read('all_permissions') ?? [];
    super.initState();
    shortCutKeyValue.value = "fareByVehicle";
    controller.fareValueVehicleController.clear();
    controller.createByVehicleTypes = null;
    controller.fareByVehicleOperater = 'AMOUNT';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(initState: (state) {
      controller.getFixedFareVehicleType();
      controller.getFareByVehicleSetting();
    }, builder: (controller) {



      if (controller.getFixedFareVehicleLoader == true) {
        return const Center(child: CircularProgressIndicator());
      }

      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        final double fieldWidth = isMobile
            ? maxWidth
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        return PageScrollWrapper(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),

                Container(
                  width: Get.width / 1.1,
                  decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.gryClr)),
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
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
                              Text(AppText.vehicleType,
                                  style: mozillaTextSemiBoldText(
                                      context: context, fontSize: 13)),
                              CustomDropdownField<VehicleTypeFixed>(
                                label: "SELECT VEHICLE TYPE",
                                width: Get.width / 5,
                                height: 35,
                                items: controller
                                        .VehicleTypeModel!.vehicleTypesFixed ??
                                    [],
                                value: controller.createByVehicleTypes,
                                itemLabel: (templateList) =>
                                (templateList.name ?? "").toUpperCase(),
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
                              Text(AppText.operator,
                                  style: mozillaTextSemiBoldText(
                                      context: context, fontSize: 13)),
                              CustomDropdownField<String>(
                                label: "SELECT OPERATOR",
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
                            width: fieldWidth / 1.3,
                            hintText: AppText.value,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            columnText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                            ],
                            height: 35,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        verticalDirection: VerticalDirection.down,
                        spacing: fieldWidth / 2,
                        runSpacing: 6,
                        children: [
                          CustomButton(
                            onTap: () {
                              controller.postFareByVehicleSetting();

                              controller.getFareByVehicleSetting();

                              // controller.updateFarebyVehicle(false);
                            },
                            height: 30,
                            width: fieldWidth,
                            btnText: controller.updateFarebyVehicle.value == false
                                ? AppText.save
                                : "UPDATE",
                            verticalPadding: 0.0,
                            borderRadius: 4,
                            style: mozillaTextRegularText(
                                fontSize: 13, color: DynamicColors.whiteClr),
                          ),
                          CustomButton(
                            onTap: () {
                              controller.clearAllFields();
                            },
                            height: 30,
                            width: fieldWidth,
                            btnText: AppText.clear,
                            verticalPadding: 0.0,
                            borderRadius: 4,
                            btnColor: DynamicColors.redClr,
                            style: mozillaTextRegularText(
                                fontSize: 13, color: DynamicColors.whiteClr),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // --- TABLE SECTION ---
                Container(
                  width: Get.width / 1.1,
                  constraints: BoxConstraints(
                    maxHeight: Get.height * 0.6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: DynamicColors.gryClr),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(title: "VEHICLE TYPE", removeSearching: true

                            ),
                          buildHeaderWithSearch(title: "OPERATOR", removeSearching: true
                          ),
                          buildHeaderWithSearch(title: "VALUE", removeSearching: true

                          ),
                          buildHeaderWithSearch(
                              title: "ACTIONS", removeSearching: true),
                        ],
                        totalRow: controller.VehicleTypeModel!.vehicleTypesFixed!.length ?? 0,
                        rows: controller.fareByVehicleSetting!.fareByVehicles!.map((farefxed) => DataRow(
                                      cells: [
                                        DataCell(Center(
                                            child: Text(
                                                (farefxed.vehicleType?.name ??
                                                    "").toUpperCase()))),
                                        DataCell(Center(
                                            child: Text(
                                                farefxed.fareByVehicleOperator ??
                                                    ""
                                            ))),
                                        DataCell(Center(
                                            child: Text(farefxed.fareByVehicleOperator == "PERCENTAGE"
                                                ? "${farefxed.value ?? '0'}%"
                                                : "£${farefxed.value ?? '0'}"))),
                                        DataCell(
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit_calendar,
                                                      size: 20,
                                                      color: DynamicColors
                                                          .primaryClr),
                                                  onPressed: () {
                                                    controller.bindFareByVechicle(
                                                        farefxed);
                                                    controller.update();
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete_forever,
                                                      size: 20,
                                                      color:
                                                          DynamicColors.redClr),
                                                  onPressed: () =>
                                                      controller.deleteCustomer(
                                                          farefxed.id),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                                .toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Bottom padding
              ],
            ),
          ),
        );
      });
    });
  }
}
