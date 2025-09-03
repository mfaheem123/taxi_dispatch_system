


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/controller.dart';

class FareCharges extends StatefulWidget {
  const FareCharges({super.key});

  @override
  State<FareCharges> createState() => _FareChargesState();
}

class _FareChargesState extends State<FareCharges> {

  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows =
  50; // total rows (dynamic list ke hisaab se change hoga)
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "fareCharges";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(builder: (controller) {

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

            return Column(
              children: [
                Wrap(
                  children: [
                    SizedBox(
                      width: fieldWidth*2,
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(AppText.surCharges, style: titleDesign()),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                            child: Wrap(
                              verticalDirection: VerticalDirection.down,
                              runSpacing: 10,
                              spacing: fieldWidth/10,
                              children: [
                                SizedBox(
                                  width: fieldWidth/1.8,
                                  // height: 30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.surChargesType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      RestrictedDrivers(
                                        width: fieldWidth/1.8,
                                        padding: 0.0,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        titleText: "POSTCODE WISE",
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
                                  controller: controller.surChargesFareController,
                                  width: fieldWidth/1.8,
                                  hintText: AppText.fare,
                                  columnText: true,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: fieldWidth/1.8,
                                  // height: 30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.timeLine, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      RestrictedDrivers(
                                        width: fieldWidth/1.8,
                                        padding: 0.0,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        titleText: "DATE WISE",
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Wrap(
                              verticalDirection: VerticalDirection.down,
                              runSpacing: 10,
                              spacing: fieldWidth/10,
                              children: [
                                SizedBox(
                                  width: fieldWidth/1.8,
                                  // height: 30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.applyCondition, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      RestrictedDrivers(
                                        width: fieldWidth/1.8,
                                        padding: 0.0,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        titleText: "PICKUP",
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
                                  controller: controller.parkingFareController,
                                  width: fieldWidth/1.8,
                                  hintText: AppText.parking,
                                  columnText: true,
                                  height: 30,
                                ),
                                labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: AppText.from,
                                  column: true,
                                  width: fieldWidth/1.8,
                                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                            child: Wrap(
                              verticalDirection: VerticalDirection.down,
                              runSpacing: 10,
                              spacing: fieldWidth/10,
                              children: [
                              CustomTextField(
                              borderRadius: 4,
                              controller: controller.postCodeFareController,
                              width: fieldWidth/1.8,
                              hintText: AppText.postCode,
                              columnText: true,
                              height: 30,
                            ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.extraDropOffFareController,
                                  width: fieldWidth/1.8,
                                  hintText: AppText.extraDropOff,
                                  columnText: true,
                                  height: 30,
                                ),
                                labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: AppText.from,
                                  column: true,
                                  width: fieldWidth/1.8,
                                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Wrap(
                              verticalDirection: VerticalDirection.down,
                              runSpacing: 10,
                              spacing: fieldWidth/10,
                              children: [
                                SizedBox(
                                  width: fieldWidth/1.8,
                                  // height: 30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.operator, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      RestrictedDrivers(
                                        width: fieldWidth/1.8,
                                        padding: 0.0,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        titleText: "SELECT OPERATION",
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
                                  controller: controller.congestionFareController,
                                  width: fieldWidth/1.8,
                                  hintText: AppText.congestion,
                                  columnText: true,
                                  height: 30,
                                ),
                            labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.to,
                              column: true,
                              width: fieldWidth/1.8,
                              child: SizedBox(height: 30, child: KeyboardDatePicker()),
                            ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        );
      }
    );
  }
}
