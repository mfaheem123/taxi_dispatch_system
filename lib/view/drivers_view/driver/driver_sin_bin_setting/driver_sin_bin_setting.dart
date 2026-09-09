import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../controller/driver_sin_bin_controller.dart';

class DriverSinBinSetting extends StatefulWidget {
  const DriverSinBinSetting({super.key});

  @override
  State<DriverSinBinSetting> createState() => _DriverSinBinSettingState();
}

class _DriverSinBinSettingState extends State<DriverSinBinSetting> {
  DriverSinBinController controller = Get.isRegistered<DriverSinBinController>()
      ? Get.find<DriverSinBinController>()
      : Get.put(DriverSinBinController());

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverSinBinSetting";
    controller.getDriverSinBinSetting();
    controller.getDriverSinBin();
  }

  int selectedRowIndex = 0;
  final int totalRows = 5;

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<DriverSinBinController>(builder: (controller) {
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

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: Get.width / 1.5,
                  decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.gryClr)),
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        color: DynamicColors.gryClr.withOpacity(0.5),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 50,
                          children: [
                            Text(AppText.driverSinBinSetting,
                                style: titleDesign()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            spacing: fieldWidth / 2,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  buildNumberField(controller.recoverJobController, AppText.recoverJob, fieldWidth / 1.7),
                                  buildNumberField(controller.rejectJobController, AppText.rejectJob, fieldWidth / 1.7),
                                  buildNumberField(controller.ignoreJobController, AppText.ignoreJob, fieldWidth / 1.7),
                                  CustomButton(
                                      width: fieldWidth / 2.5,
                                      height: 30,
                                      verticalPadding: 0.0,
                                      btnText: AppText.save,
                                      borderRadius: 4,
                                      style: mozillaTextRegularText(
                                          fontSize: 14,
                                          color: DynamicColors.whiteClr),
                                      onTap: () {
                                        controller.saveSinBinSetting();
                                        // SuccessAlert.show(
                                        //     "Data saved successfully!");
                                      }),
                                  SizedBox(width: 10),
                                ],
                              )
                            ],
                          )),
                      SizedBox(height: 10),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                controller.isLoadingGetSinBin
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: CircularProgressIndicator(),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: Get.width/1.5,
                    child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "USERNAME", removeSearching: true),
                        buildHeaderWithSearch(title: "NAME", removeSearching: true),
                        buildHeaderWithSearch(title: "VEHICLE", removeSearching: true),
                        buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                      ],
                      totalRow: controller.sinBinDriversList.length,
                      rows: controller.sinBinDriversList.map((driver) {
                        return DataRow(
                      cells: [
                        DataCell(Center(child: Text(driver.username ?? ""))),
                        DataCell(Center(child: Text(driver.name ?? ""))),
                        DataCell(Center(child: Text(driver.vehicle?.vehicleType?.name ?? ""))),
                        DataCell(
                          Center(
                            child: Focus(
                              child: Builder(
                                builder: (context) {
                                  final hasFocus = Focus.of(context).hasFocus;
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(6),
                                      onTap: () {
                                        controller.addDriverSinBin(driver.id, 0, isActive: false);
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 150),
                                        height: 30,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          color: DynamicColors.redClr,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: hasFocus ? Colors.black : Colors.transparent,
                                            width: hasFocus ? 2 : 0,
                                          ),
                                          boxShadow: hasFocus ? [
                                            BoxShadow(
                                              color: DynamicColors.redClr.withOpacity(0.6),
                                              blurRadius: 6,
                                              spreadRadius: 2,
                                            )
                                          ] : [],
                                        ),
                                        child: const Icon(
                                          Icons.hourglass_full,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                      }).toList(),
                  ),
                ),
                )],
            ),
          ));
        });
      }),
    );
  }
  Widget buildNumberField(TextEditingController textCtrl, String hintText, double width) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            controller.updateValue(textCtrl, 1);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            controller.updateValue(textCtrl, -1);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: CustomTextField(
        width: width,
        borderRadius: 4,
        controller: textCtrl,
        hintText: hintText,
        columnText: true,
        // height: 38,
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
        ],
        suffixIcon: FocusScope(
          canRequestFocus: false,
          skipTraversal: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                focusNode: FocusNode(canRequestFocus: false),
                onTap: () => controller.updateValue(textCtrl, 1),
                child: const Icon(Icons.arrow_drop_up, size: 15),
              ),
              InkWell(
                focusNode: FocusNode(canRequestFocus: false),
                onTap: () => controller.updateValue(textCtrl, -1),
                child: const Icon(Icons.arrow_drop_down, size: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
