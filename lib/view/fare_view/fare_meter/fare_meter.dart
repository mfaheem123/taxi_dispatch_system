import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/fare_view/fare_meter/waiting_configuration_alert.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/quotation_widget.dart';
import '../controller/controller.dart';

class FareMeter extends StatefulWidget {
  const FareMeter({super.key});

  @override
  State<FareMeter> createState() => _FareMeterState();
}

class _FareMeterState extends State<FareMeter> {
  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50; // total rows (dynamic list ke hisaab se change hoga)
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "fareMeter";
  }

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<FareController>(
          initState: (v){
            controller.getAllFareMeterRate();
          },
          builder: (controller) {
        return LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isMobile = maxWidth < 600;
          final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
          final bool isLaptop = maxWidth >= 1024 && maxWidth < 1400;

          final double dynamicColumnSpacing = isMobile
              ? 10.0
              : isTablet
              ? 15.0
              : isLaptop
              ? 14.0
              : 30.0;

          // Flexible field widths based on layout size
          final double fieldWidth = isMobile
              ? maxWidth
              : isTablet
              ? maxWidth / 2
              : isLaptop
              ? maxWidth / 4.8
              : maxWidth / 4;


          return Column(
            children: [
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                color: DynamicColors.gryClr.withOpacity(0.5),
                child: Text(AppText.fareMeterConfiguration, style: titleDesign()),
              ),
              controller.getAllFareMeterRateModel == null? CircularProgressIndicator(): Scrollbar(
                controller: _scrollController,
                thumbVisibility: true, // 👈 hamesha visible
                trackVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  controller: _scrollController, // 👈 yahan bhi same controller
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                    dataRowMinHeight: 48,
                    dataRowMaxHeight: 56,
                    columnSpacing: dynamicColumnSpacing,
                    border: TableBorder.all(
                      color: DynamicColors.gryClr,
                      width: 0.5,
                    ),
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: isLaptop ? 11 : 13,
                    ),
                    dataTextStyle: const TextStyle(
                      fontSize: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: DynamicColors.textClr.withOpacity(0.5),
                      ),
                    ),
                    columns: [
                      buildHeaderWithSearch(
                          title: " VEHICLES ",
                          removeSearching: true,
                        fontSize: isLaptop ? 11 : 13,),
                      buildHeaderWithSearch(
                          title: " METERED ",
                          removeSearching: true,
                        fontSize: isLaptop ? 11 : 13,),
                      buildHeaderWithSearch(
                          title: " AUTO WAIT ",
                          removeSearching: true,
                        fontSize: isLaptop ? 11 : 13,),
                      buildHeaderWithSearch(
                          title: " ACTIVATE WAITING ON SPEED ",
                          removeSearching: true,
                        fontSize: isLaptop ? 11 : 13,),
                      buildHeaderWithSearch(
                          title: " INITIATE WAITING AFTER ",
                          removeSearching: true,
                        fontSize: isLaptop ? 11 : 13,),
                      buildHeaderWithSearch(
                          title: " SUSPEND WAITING ON SPEED ",
                          removeSearching: true,
                        fontSize: isLaptop ? 11 : 13,),
                      buildHeaderWithSearch(
                          title: " WAITING CHAREGES/INTERVAL ",
                          removeSearching: true,
                        fontSize: isLaptop ? 11 : 13,),
                      buildHeaderWithSearch(
                          title: " INTERVALS ",
                          removeSearching: true,
                        fontSize: isLaptop ? 11 : 13,),

                      buildHeaderWithSearch(
                          title: " ACTIONS ",
                          removeSearching: true,
                        fontSize: isLaptop ? 11 : 13,),
                    ],
                    rows: List.generate(controller.getAllFareMeterRateModel!.fareMeters!.length, (index) {



                      return DataRow(
                        cells: [
                          DataCell(Center(child: Text(controller.getAllFareMeterRateModel!.fareMeters![index].vehicleType!.name!))),
                          DataCell(Center(
                            child: GetBuilder<FareController>( // Ensure correct controller scope
                              builder: (controller) {
                                final currentFareMeter = controller.getAllFareMeterRateModel!.fareMeters![index];
                                return DynamicSwitch(
                                  controller: ValueNotifier(currentFareMeter.hasMeter),
                                  activeColor: DynamicColors.primaryClr,
                                  inactiveColor: DynamicColors.gryClr,
                                  focusScale: 1.5,
                                  onChanged: (v) {
                                    currentFareMeter.hasMeter = v;
                                    controller.update();
                                  },
                                  onToggle: () async {
                                    currentFareMeter.hasMeter = !currentFareMeter.hasMeter;
                                    controller.update();
                                    print("Switch toggled locally: ${currentFareMeter.hasMeter}");
                                    await controller.editFareMeterRate(fareMeterObj: currentFareMeter);
                                  },
                                );
                              },
                            ),
                          )),
                          DataCell(Center(
                            child: DynamicSwitch(
                              controller: ValueNotifier(controller.getAllFareMeterRateModel!.fareMeters![index].autostartWait),
                              activeColor: DynamicColors.primaryClr,
                              inactiveColor: DynamicColors.gryClr,
                              focusScale: 1.5,
                              onChanged: (v){
                                controller.getAllFareMeterRateModel!.fareMeters![index].autostartWait =
                                !controller.getAllFareMeterRateModel!.fareMeters![index].autostartWait;
                                controller.update();
                                },
                              onToggle: () {
                                controller.getAllFareMeterRateModel!.fareMeters![index].autostartWait =
                                !controller.getAllFareMeterRateModel!.fareMeters![index].autostartWait;
                                controller.update();
                                print(
                                    "Switch toggled: ${controller.getAllFareMeterRateModel!.fareMeters![index].autostartWait}");
                              },
                            ),
                          )),
                          DataCell(Center(
                            child: customRow(
                              icons: Icons.speed,
                              controller.getAllFareMeterRateModel!.fareMeters![index].activeWaitingController,
                              width: isLaptop ? 45 : (fieldWidth / 3.9),
                              unitText: "MPH",
                            ),
                          )),
                          DataCell(Center(
                            child: customRow(
                              icons: Icons.alarm,
                              controller.getAllFareMeterRateModel!.fareMeters![index].autostartWaitingTimeController,
                              width: isLaptop ? 45 : (fieldWidth / 3.9),
                              unitText: "SECS",
                            ),
                          )),
                          DataCell(Center(
                            child: customRow(
                              icons: Icons.speed,
                              controller.getAllFareMeterRateModel!.fareMeters![index].suspendWaitingSpeedController,
                              width: isLaptop ? 45 : (fieldWidth / 3.9),
                              unitText: "MPH",
                            ),
                          )),
                          DataCell(Center(
                            child: CustomButton(
                              width: isLaptop ? 130 : (fieldWidth / 1.9),
                              onTap: () {
                                final fareMeterItem = controller.getAllFareMeterRateModel!.fareMeters![index];
                                WaitingConfigurationAlert.show(
                                  vehicleTypeName: fareMeterItem.vehicleType?.name ?? "VEHICLE",
                                  waitingCharges: fareMeterItem.waitingCharges,
                                );

                                // WaitingConfigurationAlert.show(
                                //     waitingCharges: controller.getAllFareMeterRateModel!.fareMeters![index].waitingCharges
                                // );
                              },
                              height: 30,
                              verticalPadding: 0.0,
                              btnText: "WAITING CONFIGURATION",
                              style: mozillaTextRegularText(
                                fontSize: 10,
                                color: DynamicColors.whiteClr,
                              ),
                              borderRadius: 4,
                            ),
                          )),
                          DataCell(Center(
                            child: customRow(
                              icons: Icons.alarm,
                              controller.getAllFareMeterRateModel!.fareMeters![index].waitingIntervalsController,
                              width: isLaptop ? 45 : (fieldWidth / 3.9),
                              unitText: "SEC",
                            ),
                          )),
                          DataCell(Center(
                            child: CustomButton(
                              width: 60,
                              onTap: () {
                               controller.editFareMeterRate(fareMeterObj: controller.getAllFareMeterRateModel!.fareMeters![index]);
                              },
                              height: 30,
                              verticalPadding: 0.0,
                              btnText: AppText.save,
                              style: mozillaTextSemiBoldText(
                                fontSize: 12,
                                color: DynamicColors.whiteClr,
                              ),
                              borderRadius: 4,
                            ),
                          )),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        });
      }),
    );
  }

  Widget customRow(
    TextEditingController controller, {
    double? width,
    String? unitText,
    IconData? icons,
    double borderRadius = 4,
  }) {
    return Row(
      children: [
        Container(
          height: 30,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: DynamicColors.primaryClr),
              right: BorderSide.none,
              bottom: BorderSide(color: DynamicColors.primaryClr),
              left: BorderSide(
                  color: DynamicColors.primaryClr), // left border hataya
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Icon(
              icons,
              size: 20,
            ),
          ),
        ),
        CustomTextField(
          borderRadius: 0,
          inputFormatters: [
            FilteringTextInputFormatter
                .digitsOnly
          ],
          keyboardType: TextInputType.number,
          controller: controller,
          width: width,
          hintText: "",
          columnText: true,
        ),
        Container(
          height: 30,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: DynamicColors.primaryClr),
              right: BorderSide(color: DynamicColors.primaryClr),
              bottom: BorderSide(color: DynamicColors.primaryClr),
              left: BorderSide.none, // left border hataya
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Text(unitText!),
          ),
        ),
      ],
    );
  }
}
