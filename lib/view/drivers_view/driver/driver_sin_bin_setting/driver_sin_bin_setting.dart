import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../alert/success_alert.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../controller/driver_controller.dart';
import '../../controller/driver_sin_bin_controller.dart';

class DriverSinBinSetting extends StatefulWidget {
  const DriverSinBinSetting({super.key});

  @override
  State<DriverSinBinSetting> createState() => _DriverSinBinSettingState();
}

class _DriverSinBinSettingState extends State<DriverSinBinSetting> {
  // DriverController controller = Get.isRegistered<DriverController>()
  //     ? Get.find<DriverController>()
  //     : Get.put(DriverController());
  DriverSinBinController controller = Get.isRegistered<DriverSinBinController>()
      ? Get.find<DriverSinBinController>()
      : Get.put(DriverSinBinController());

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverSinBinSetting";
    controller.getDriverSinBinSetting();
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
            //   child: Container(
            // width: fieldWidth*2.8,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(4),
            //     border: Border.all(color: DynamicColors.textClr.withOpacity(0.5))
            // ),
            // child: SingleChildScrollView(
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
                            // verticalDirection: VerticalDirection.down,
                            spacing: fieldWidth / 2,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.recoverJobController,
                                    width: fieldWidth / 1.5,
                                    hintText: AppText.recoverJob,
                                    columnText: true,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.rejectJobController,
                                    width: fieldWidth / 1.5,
                                    hintText: AppText.rejectJob,
                                    columnText: true,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.ignoreJobController,
                                    width: fieldWidth / 1.5,
                                    hintText: AppText.ignoreJob,
                                    columnText: true,
                                  ),
                                  CustomButton(
                                      width: fieldWidth / 2,
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
                                ],
                              )
                            ],
                          )),
                      SizedBox(height: 10),
                    ],
                  ),
                ),

                SizedBox(height: 30),
                SingleChildScrollView(
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
                      totalRow: totalRows,
                      cells: [
                        DataCell(Center(child: Text("#PHC VEHICLE"))),
                        DataCell(Center(child: Text("PHC VEHICLE"))),
                        DataCell(Center(child: Text("#PHC VEHICLE"))),
                        DataCell(Center(child: Text("PHC VEHICLE"))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
          // ));
        });
      }),
    );
  }
}
