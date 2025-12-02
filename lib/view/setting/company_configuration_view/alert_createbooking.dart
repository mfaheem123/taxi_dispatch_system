import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/keyboard_checkBox_widget.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../setting_controller.dart';

class MultiReservationAlert extends StatefulWidget {
  const MultiReservationAlert({super.key});

  @override
  State<MultiReservationAlert> createState() => _MultiReservationAlertState();
}

class _MultiReservationAlertState extends State<MultiReservationAlert> {
  @override
  final int totalRows = 3;
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
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
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 80),
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: DynamicColors.whiteClr,
                      border: Border.all(
                        color: DynamicColors.secondaryClr,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: Get.width,
                          height: kToolbarHeight,
                          color: DynamicColors.secondaryClr,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text("Multi Reversation",
                                        style: titleDesign()),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Icon(
                                            Icons.cancel_presentation_sharp))
                                  ],
                                )),
                          )),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.mondayValue.value = v;
                                controller.update();
                              },
                              label: AppText.monday,
                              value: controller.mondayValue.value,
                              focusNode: controller.mondayNode,
                              width: 200,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.tuesdayValue.value = v;
                                controller.update();
                              },
                              label: AppText.tuesday,
                              value: controller.tuesdayValue.value,
                              focusNode: controller.tuesdayNode,
                              width: 200,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.wednesdayValue.value = v;
                                controller.update();
                              },
                              label: AppText.wednesday,
                              value: controller.wednesdayValue.value,
                              focusNode: controller.wednesdayNode,
                              width: 200,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.thursdayValue.value = v;
                                controller.update();
                              },
                              label: AppText.thursday,
                              value: controller.thursdayValue.value,
                              focusNode: controller.thursdayNode,
                              width: 200,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.fridayValue.value = v;
                                controller.update();
                              },
                              label: AppText.friday,
                              value: controller.fridayValue.value,
                              focusNode: controller.fridayNode,
                              width: 200,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.saturdayValue.value = v;
                                controller.update();
                              },
                              label: AppText.saturday,
                              value: controller.saturdayValue.value,
                              focusNode: controller.saturdayNode,
                              width: 200,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.sundayValue.value = v;
                                controller.update();
                              },
                              label: AppText.sunday,
                              value: controller.sundayValue.value,
                              focusNode: controller.sundayNode,
                              width: 200,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: Wrap(
                          runSpacing: 50,
                          spacing: 50,
                          children: [
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.weeks,
                              width: fieldWidth / 1.5,
                              labelText: AppText.weeks,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.weeks,
                              width: fieldWidth / 1.5,
                              labelText: AppText.fromDate,
                            ),
                            CustomTextField(
                              borderRadius: 1.5,
                              controller: controller.weeks,
                              width: fieldWidth / 1.5,
                              labelText: AppText.finishDate,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.weeks,
                              width: fieldWidth / 1.5,
                              labelText: AppText.pickupTime,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.weeks,
                              width: fieldWidth / 1.5,
                              labelText: AppText.returnPickupTime,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.weeks,
                              width: fieldWidth / 1.5,
                              labelText: AppText.fare,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.weeks,
                              width: fieldWidth / 1.5,
                              columnText: false,
                              labelText: AppText.returnFare,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.weeks,
                              width: fieldWidth / 1.5,
                              columnText: false,
                              labelText: AppText.accountPrice,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.weeks,
                              width: fieldWidth / 1.5,
                              columnText: false,
                              labelText: AppText.returnAccountPrice,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.returnTrip.value = v;
                                controller.update();
                              },
                              label: AppText.returnTrip,
                              value: controller.returnTrip.value,
                              focusNode: controller.returnTripNode,
                              width: 200,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CustomButton(
                            height: 35,
                            width: fieldWidth / 2,
                            fontSize: 10,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.createreservation,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/2,
                          child: DatatableWidget(
                              columns: [
                                buildHeaderWithSearch(title: "EXCLUDE"),
                                buildHeaderWithSearch(title: "DAY"),
                                buildHeaderWithSearch(title: "DATE"),
                                buildHeaderWithSearch(title: "TIME"),
                                buildHeaderWithSearch(title: "RETURN TIME"),

                              ],
                              totalRow: totalRows,
                              cells: [
                                const DataCell(Text("JOB")),
                                const DataCell(Text("MONDAY")),
                                const DataCell(Text("12-Nov-2025")),
                                const DataCell(Text("Time")),
                                const DataCell(Text("RETURN Time")),

                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CustomButton(
                            height: 35,
                            width: fieldWidth / 2,
                            fontSize: 14,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.saveAndClose,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, bottom: 30),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 80,
                          runSpacing: 50,
                          children: [

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      });
    });
  }
}
