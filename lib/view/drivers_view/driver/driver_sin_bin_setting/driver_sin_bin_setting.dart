


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

class DriverSinBinSetting extends StatefulWidget {
  const DriverSinBinSetting({super.key});

  @override
  State<DriverSinBinSetting> createState() => _DriverSinBinSettingState();
}

class _DriverSinBinSettingState extends State<DriverSinBinSetting> {

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverSinBinSetting";
  }

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)


  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<DriverController>(builder: (controller) {
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
                width: fieldWidth*2.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: DynamicColors.textClr.withOpacity(0.5))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        color: DynamicColors.gryClr.withOpacity(0.5),
                        child: Text(AppText.driverSinBinSetting, style: titleDesign()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: maxWidth >1034? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          CustomTextField(
                          borderRadius: 4,
                          controller: controller.recoverJobController,
                          width: fieldWidth/2,
                          hintText: AppText.recoverJob,
                          columnText: true,
                        ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.rejectJobController,
                              width: fieldWidth/2,
                              hintText: AppText.rejectJob,
                              columnText: true,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.ignoreJobController,
                              width: fieldWidth/2,
                              hintText: AppText.ignoreJob,
                              columnText: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: CustomButton(
                                width: fieldWidth/2,
                                height: 35,
                                verticalPadding: 0.0,
                                btnText: AppText.save,
                                borderRadius: 4,
                                style: mozillaTextRegularText(fontSize: 14,
                                color: DynamicColors.whiteClr
                                ),
                                  onTap: () {
                                    SuccessAlert.show("Data saved successfully!");
                                  }
                              ),
                            )
                          ],
                        ):
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.recoverJobController,
                              width: fieldWidth*2,
                              hintText: AppText.recoverJob,
                              columnText: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.rejectJobController,
                              width: fieldWidth*2,
                              hintText: AppText.rejectJob,
                              columnText: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.ignoreJobController,
                              width: fieldWidth*2,
                              hintText: AppText.ignoreJob,
                              columnText: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: CustomButton(
                                width: maxWidth >1034? fieldWidth/2: fieldWidth*2,
                                height: 35,
                                verticalPadding: 0.0,
                                btnText: AppText.save,
                                borderRadius: 4,
                                style: mozillaTextRegularText(fontSize: 14,
                                    color: DynamicColors.whiteClr
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: Get.width,
                          child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(title: "USERNAME"),
                              buildHeaderWithSearch(title: "NAME"),
                              buildHeaderWithSearch(title: "VEHICLE"),
                              buildHeaderWithSearch(title: "ACTIONS"),
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
                ),
              );
            }
          );
        }
      ),
    );
  }
}
