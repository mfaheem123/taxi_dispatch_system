import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/fare_view/model/plotVehicleModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final int totalRows =
      50; // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "plotFare";
    controller.getPlotVehicleType();
    controller.getAllPlotFare();
    controller.clearFormData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(initState: (v) {
      controller.getPlotVehicleType();
      controller.getAllPlotFare();
    }, builder: (controller) {
      if (controller.getAllPlotFareLoader.value ||
          controller.getPlotVehicleTypeLoader.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

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

        return Container(
          width: Get.width / 1.2,
          decoration:
              BoxDecoration(border: Border.all(color: DynamicColors.gryClr)),
          child: Column(
            children: [
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                          CustomDropdownField<VehicleTypee>(
                            label: "SELECT VEHICLE TYPE",
                            width: fieldWidth,
                            height: 35,
                            items:
                                controller.plotVehicleTypeModel!.vehicleTypes!,
                            value: controller.plotVehicleTypevalue,
                            itemLabel: (templateList) =>
                                templateList.name!.toUpperCase(),
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
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      columnText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                      height: 35,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
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
                                Text(AppText.fromPlot,
                                    style: mozillaTextSemiBoldText(
                                        context: context, fontSize: 13)),
                                CustomDropdownField<Zonee>(
                                  label: "SELECT ZONE",
                                  width: Get.width / 5,
                                  height: 35,
                                  items:
                                      controller.plotVehicleTypeModel!.zones!,
                                  value: controller.Zoneevalue,
                                  itemLabel: (templateList) =>
                                      templateList.name!.toUpperCase(),
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
                                minimumSize: constraints.maxWidth >= 1024 && constraints.maxWidth < 1400
                                    ? const Size(33, 42)
                                    : const Size(40, 42),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // <-- border radius here
                                ),
                                side: BorderSide(
                                    color: DynamicColors
                                        .gryClr), // optional border color
                              ),
                              onPressed: () {
                                if (controller.Zoneevalue != null) {
                                  // 1. ID list mein add karein backend ke liye
                                  controller.addPickupPlot(
                                      controller.Zoneevalue!.id!);

                                  // 2. UI Description (Jo aapne pehle likha tha)
                                  String newValue = controller.Zoneevalue!.name!
                                      .toUpperCase();
                                  String currentText = controller
                                      .ploteFareDescriptionController.text;
                                  controller
                                          .ploteFareDescriptionController.text =
                                      currentText.isEmpty
                                          ? newValue
                                          : "$currentText, $newValue";

                                  controller.Zoneevalue = null;
                                  controller.update();
                                }
                              },
                              child: Icon(Icons.add)),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: constraints.maxWidth >= 1024 && constraints.maxWidth < 1400
                                    ? const Size(33, 42)
                                    : const Size(40, 42),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // <-- border radius here
                                ),
                                side: BorderSide(
                                    color: DynamicColors
                                        .gryClr), // optional border color
                              ),
                              onPressed: () {
                                controller.ploteFareDescriptionController
                                    .clear();
                                controller.selectedPickupIds.clear();
                                controller.Zoneevalue = null;
                                controller.update();
                              },
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
                                Text(AppText.toPlot,
                                    style: mozillaTextSemiBoldText(
                                        context: context, fontSize: 13)),
                                CustomDropdownField<Zonee>(
                                  label: "SELECT ZONE",
                                  width: Get.width / 5,
                                  height: 35,
                                  items:
                                      controller.plotVehicleTypeModel!.zones!,
                                  value: controller.Zonee1value,
                                  itemLabel: (templateList) =>
                                      templateList.name!.toUpperCase(),
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
                                minimumSize: constraints.maxWidth >= 1024 && constraints.maxWidth < 1400
                                    ? const Size(33, 42)
                                    : const Size(40, 42),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // <-- border radius here
                                ),
                                side: BorderSide(
                                    color: DynamicColors
                                        .gryClr), // optional border color
                              ),
                              onPressed: () {
                                if (controller.Zonee1value != null) {
                                  // 1. Backend ID list (Dropoff) mein add karein
                                  controller.addDropoffPlot(
                                      controller.Zonee1value!.id!);

                                  // 2. UI Description (2nd Controller) update karein
                                  String newValue = controller
                                      .Zonee1value!.name!
                                      .toUpperCase();
                                  String currentText = controller
                                      .ploteFareDescription2ndController.text;

                                  controller.ploteFareDescription2ndController
                                          .text =
                                      currentText.isEmpty
                                          ? newValue
                                          : "$currentText, $newValue";

                                  // 3. Dropdown reset aur UI refresh
                                  controller.Zonee1value = null;
                                  controller.update();
                                }
                              },
                              child: Icon(Icons.add)),
                          // Delete To Plot
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: constraints.maxWidth >= 1024 && constraints.maxWidth < 1400
                                    ? const Size(33, 42)
                                    : const Size(40, 42),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // <-- border radius here
                                ),
                                side: BorderSide(
                                    color: DynamicColors
                                        .gryClr), // optional border color
                              ),
                              onPressed: () {
                                controller.ploteFareDescription2ndController
                                    .clear();
                                controller.selectedDropoffIds.clear();
                                controller.Zonee1value = null;
                                controller.update();
                              },
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
                      borderRadius: 4,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      controller: controller.ploteFareDescriptionController,
                      width: fieldWidth,
                      hintText: "",
                      columnText: true,
                      maxLines: 5,
                      height: 100,
                    ),
                    CustomTextField(
                      borderRadius: 4,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      controller: controller.ploteFareDescription2ndController,
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
                      onTap: () {
                        controller.ploteFareDescription2ndController == null ||
                                controller.ploteFareDescriptionController ==
                                    null
                            ? BotToast.showText(text: "ADD PLOT")
                            : controller.postPlotFare();
                      },
                      height: 35,
                      width: fieldWidth,
                      btnText: controller.isUpdatePlot.value
                          ? "UPDATE"
                          : AppText.save,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      style: mozillaTextRegularText(
                          fontSize: 13, color: DynamicColors.whiteClr),
                    ),
                    CustomButton(
                      onTap: () {
                        controller.clearFormData();
                      },
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
              controller.getPlotVehicleTypeLoader == true
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width / 1.3,
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(
                                title: "VEHICLE", removeSearching: true),
                            buildHeaderWithSearch(
                                title: "FROM PLOT", removeSearching: true),
                            buildHeaderWithSearch(
                                title: "TO PLOT", removeSearching: true),
                            buildHeaderWithSearch(
                                title: "FARES", removeSearching: true),
                            buildHeaderWithSearch(
                                title: "ACTIONS", removeSearching: true),
                          ],
                          rows: controller.allPlotFareModel!.plotFares!
                              .map((plot) => DataRow(
                                    cells: [
                                      DataCell(Center(
                                          child: Text(
                                              (plot.vehicleType!.name ?? "")
                                                  .toUpperCase()))),
                                      DataCell(Center(
                                          child: Text(
                                              (plot.pickupPlot!.name ?? "")
                                                  .toUpperCase()))),
                                      DataCell(Center(
                                          child: Text(
                                              (plot.dropoffPlot!.name ?? "")
                                                  .toUpperCase()))),
                                      DataCell(Center(
                                          child: Text(plot.fares ?? ""))),
                                      DataCell(
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize:
                                                      const Size(32, 32),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                onPressed: () {
                                                  // 🟢 Edit action
                                                  controller.bindPlotFare(plot);
                                                  // controller.clearFormData();
                                                },
                                                child: Icon(Icons.edit_calendar,
                                                    size: 20,
                                                    color: DynamicColors
                                                        .primaryClr),
                                              ),
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize:
                                                      const Size(32, 32),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                onPressed: () {
                                                  controller
                                                      .plotfareDelete(plot.id);
                                                  // 🔴 Delete action
                                                },
                                                child: Icon(
                                                    Icons.delete_forever,
                                                    size: 20,
                                                    color:
                                                        DynamicColors.redClr),
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
              SizedBox(height: 25),
            ],
          ),
        );
      });
    });
  }
}
