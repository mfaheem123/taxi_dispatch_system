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
import '../../../component/time_duration_method.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        labeledField(
                          context: context,
                          isMobile: isMobile,
                          label: AppText.from,
                          width: fieldWidth/1.4,
                          child: SizedBox(
                              height: 30,
                              child: KeyboardDatePicker(
                            initialDate: controller.multiReservationFromDate?? DateTime.now(),
                            borderClr: Colors.blue,
                            onChanged: (date) {
                              controller.multiReservationFromDate = date;
                              controller.update();
                            },
                            onSubmitted: (date) {
                              // jab user enter press kare
                              print("User pressed enter: $date");
                            },
                          )),
                        ),
                        labeledField(
                          context: context,
                          isMobile: isMobile,
                          label: AppText.to,
                          width: fieldWidth/1.4,
                          child: SizedBox(
                              height: 30,
                              child: KeyboardDatePicker(
                            initialDate: controller.multiReservationToDate?? DateTime.now(),
                            borderClr: Colors.blue,
                            onChanged: (date) {
                              controller.multiReservationToDate = date;
                              controller.update();
                            },
                            onSubmitted: (date) {
                              // jab user enter press kare
                              print("User pressed enter: $date");
                            },
                          )),
                        ),
                        labeledField(
                          context: context,
                          isMobile: isMobile,
                          label: AppText.time,
                          width: fieldWidth/2.3,
                          child: SizedBox(height: 30, child: CustomTimePicker(
                            controller: controller.multiReservationToTimeController, // optional
                            onTimeSelected: (time) {
                              controller.multiReservationToTimeController.text = time;
                              setState(() {
                                print(controller.multiReservationToTimeController.text);
                              });
                            },

                          )),
                        ),
                        CustomButton(
                          height: 35,
                          width: fieldWidth / 2,
                          fontSize: 10,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          onTap: (){
                            controller.addToMultiReservation(
                              endTime: controller.multiReservationToDate,
                              startTime: controller.multiReservationFromDate,
                              time: controller.multiReservationToTimeController.text,
                              selectedDays: controller.multiReservationDaysList,
                            );
                          },
                          btnText: AppText.createreservation,
                        ),
                        CustomButton(
                          height: 35,
                          onTap: (){
                            controller.multiReservationList.clear();
                            controller.multiReservationDaysList.clear();
                            controller.update();
                            Get.back();
                          },
                          width: 60,
                          fontSize: 10,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          btnText: AppText.cancel,
                          btnColor: DynamicColors.redClr,
                        ),
                      ],
                    ),
                  ),
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
                                controller.addDayToTempList(AppText.monday);
                                controller.mondayValue.value = v;
                                controller.update();
                              },
                              label: AppText.monday,
                              value: controller.mondayValue.value,
                              focusNode: controller.mondayNode,
                              width: 120,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.addDayToTempList(AppText.tuesday);
                                controller.tuesdayValue.value = v;
                                controller.update();
                              },
                              label: AppText.tuesday,
                              value: controller.tuesdayValue.value,
                              focusNode: controller.tuesdayNode,
                              width: 120,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.addDayToTempList(AppText.wednesday);
                                controller.wednesdayValue.value = v;
                                controller.update();
                              },
                              label: AppText.wednesday,
                              value: controller.wednesdayValue.value,
                              focusNode: controller.wednesdayNode,
                              width: 120,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.addDayToTempList(AppText.thursday);
                                controller.thursdayValue.value = v;
                                controller.update();
                              },
                              label: AppText.thursday,
                              value: controller.thursdayValue.value,
                              focusNode: controller.thursdayNode,
                              width: 120,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.addDayToTempList(AppText.friday);
                                controller.fridayValue.value = v;
                                controller.update();
                              },
                              label: AppText.friday,
                              value: controller.fridayValue.value,
                              focusNode: controller.fridayNode,
                              width: 120,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.addDayToTempList(AppText.saturday);
                                controller.saturdayValue.value = v;
                                controller.update();
                              },
                              label: AppText.saturday,
                              value: controller.saturdayValue.value,
                              focusNode: controller.saturdayNode,
                              width: 120,
                            ),
                            KeyboardCheckbox(
                              onChanged: (v) {
                                controller.addDayToTempList(AppText.sunday);
                                controller.sundayValue.value = v;
                                controller.update();
                              },
                              label: AppText.sunday,
                              value: controller.sundayValue.value,
                              focusNode: controller.sundayNode,
                              width: 120,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 10, horizontal: 30),
                      //   child: Wrap(
                      //     runSpacing: 50,
                      //     spacing: 50,
                      //     children: [
                      //       CustomTextField(
                      //         borderRadius: 4,
                      //         controller: controller.weeks,
                      //         width: fieldWidth / 1.5,
                      //         labelText: AppText.weeks,
                      //       ),
                      //       CustomTextField(
                      //         borderRadius: 4,
                      //         controller: controller.weeks,
                      //         width: fieldWidth / 1.5,
                      //         labelText: AppText.fromDate,
                      //       ),
                      //       CustomTextField(
                      //         borderRadius: 1.5,
                      //         controller: controller.weeks,
                      //         width: fieldWidth / 1.5,
                      //         labelText: AppText.finishDate,
                      //       ),
                      //       CustomTextField(
                      //         borderRadius: 4,
                      //         controller: controller.weeks,
                      //         width: fieldWidth / 1.5,
                      //         labelText: AppText.pickupTime,
                      //       ),
                      //       CustomTextField(
                      //         borderRadius: 4,
                      //         controller: controller.weeks,
                      //         width: fieldWidth / 1.5,
                      //         labelText: AppText.returnPickupTime,
                      //       ),
                      //       CustomTextField(
                      //         borderRadius: 4,
                      //         controller: controller.weeks,
                      //         width: fieldWidth / 1.5,
                      //         labelText: AppText.fare,
                      //       ),
                      //       CustomTextField(
                      //         borderRadius: 4,
                      //         controller: controller.weeks,
                      //         width: fieldWidth / 1.5,
                      //         columnText: false,
                      //         labelText: AppText.returnFare,
                      //       ),
                      //       CustomTextField(
                      //         borderRadius: 4,
                      //         controller: controller.weeks,
                      //         width: fieldWidth / 1.5,
                      //         columnText: false,
                      //         labelText: AppText.accountPrice,
                      //       ),
                      //       CustomTextField(
                      //         borderRadius: 4,
                      //         controller: controller.weeks,
                      //         width: fieldWidth / 1.5,
                      //         columnText: false,
                      //         labelText: AppText.returnAccountPrice,
                      //       ),
                      //       KeyboardCheckbox(
                      //         onChanged: (v) {
                      //           controller.returnTrip.value = v;
                      //           controller.update();
                      //         },
                      //         label: AppText.returnTrip,
                      //         value: controller.returnTrip.value,
                      //         focusNode: controller.returnTripNode,
                      //         width: 200,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: Get.width/2,
                          child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(title: "EXCLUDE"),
                              buildHeaderWithSearch(title: "DAY"),
                              buildHeaderWithSearch(title: "DATE"),
                              buildHeaderWithSearch(title: "TIME"),
                              // buildHeaderWithSearch(title: "RETURN TIME"),

                            ],

                            rows: [
                              // Existing extensions
                              ...controller
                                  .multiReservationList
                                  .map((object) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(object.exclude.toString().toUpperCase())),
                                    DataCell(Text(object.day??"")),
                                    DataCell(Text(object.startDate??"")),
                                    // DataCell(Text(object.time??"")),
                                    DataCell(Text(object.returnTime??"")),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
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
                            onTap: () async{
                              final storedTemFare = await getFares(
                                  journeyTypeId: controller.selectJourneyTypeValue!.id,
                                  multiReservationList: controller.multiReservationList,
                                  dropOff: controller.pickupController.text,
                                  pickup: controller.dropOffController.text,
                                  miles: controller.totalDistance.value,
                                  dropoffPlotId: controller.dashboardZoneValue != null? controller.dashboardZoneValue!.id:null,
                                  pickupDate: "${controller.pickUpDate!.year}-${controller.pickUpDate!.month}-${controller.pickUpDate!.day}",
                                  pickupTime: controller.pickUpTimeController.text,
                                  vehicleTypeId: controller.selectVehicleValue!.id
                              );
                              controller.fixedFare.value = storedTemFare;
                              controller.update();
                              Get.back();
                            },
                            height: 35,
                            width: fieldWidth / 2,
                            fontSize: 14,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.saveAndClose,
                          ),
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


class MultiReservation{
  String? time,returnTime, day, startDate;
  bool exclude = false;

  MultiReservation({this.day, this.time, this.startDate, this.exclude = false, this.returnTime});
}