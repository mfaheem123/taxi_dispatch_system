import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/keyboard_checkBox_widget.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timepickerfield/timepickerfield.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../../component/time_duration_method.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/setting_controller.dart';

class MultiReservationAlert extends StatefulWidget {
  const MultiReservationAlert({super.key});

  @override
  State<MultiReservationAlert> createState() => _MultiReservationAlertState();
}

class _MultiReservationAlertState extends State<MultiReservationAlert> {
  @override

  final int totalRows = 3;

  /// Same widget, panel and flow as the dashboard form's TIME field
  /// (dashboard_form_widget.dart `_timeField`): a read-only field that opens a
  /// HOURS / MINUTES dropdown panel on tap or Enter, Tab moves between the two
  /// dropdowns, OK confirms and writes a zero-padded 24-hour `HH:mm` back into
  /// [controller], CANCEL / Escape closes without changing anything.
  ///
  /// Replaces the old CustomTimePicker here, which was click-only and wrote
  /// `"HH:mm "` with a trailing space — unlike every other writer of these two
  /// controllers (see DashboardController.resetMultiReservationFields).
  Widget _timeField(TextEditingController controller, {ValueChanged<String>? onChanged}) {
    return SizedBox(
      height: 30,
      child: TimePickerField(
        controller: controller,
        accent: DynamicColors.primaryClr,
        textStyle: const TextStyle(fontSize: 12, color: Colors.black87),
        // The field writes the value itself; this just refreshes the alert.
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 13),
          // Blue outline at radius 4, matching the FROM / TO KeyboardDatePickers
          // sitting next to it in this row.
          border: _timeFieldBorder(),
          enabledBorder: _timeFieldBorder(),
          focusedBorder: _timeFieldBorder(width: 2),
        ),
      ),
    );
  }

  OutlineInputBorder _timeFieldBorder({double width = 1}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.blue, width: width),
      );

  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        final bool isHighRes = maxWidth > 1080;
        // Instead of fixed width, we calculate flexible field widths
        double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        if(!isMobile && !isTablet) {
          fieldWidth = fieldWidth.clamp(200.0, 400.0);
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                // padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 80),
                padding: EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: isMobile ? 10 : 40),
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
                                    Text("MULTI RESERVATION",
                                        style: titleDesign()),
                                    Spacer(),
                                    Focus(
                                      onKeyEvent: (node, event) {
                                        return KeyEventResult.ignored;
                                        },
                                      child: Builder(
                                        builder: (context) {
                                          final bool isFocused = Focus.of(context).hasFocus;
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: isFocused ? Colors.grey.withOpacity(0.4) : Colors.transparent,
                                              // borderRadius: BorderRadius.circular(4),
                                              // border: isFocused ? Border.all(color: Colors.blue, width: 1.5) : null,
                                              ),
                                            child: IconButton(
                                        onPressed: () {
                                         controller.multiReservationFromDate = DateTime.now();
                                         controller.multiReservationToDate = DateTime.now();
                                          String currentTime = "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
                                         controller.multiReservationToTimeController.text = currentTime;
                                         controller.returnMultiReservationToTimeController.text = currentTime;
                                          controller. mondayValue.value = false;
                                         controller.tuesdayValue.value = false;
                                         controller.wednesdayValue.value = false;
                                         controller.thursdayValue.value = false;
                                         controller.fridayValue.value = false;
                                         controller.saturdayValue.value = false;
                                         controller.sundayValue.value = false;

                                          Get.back();
                                        },
                                        icon: Icon(
                                            Icons.cancel_presentation_sharp)),
                                          );
                                          },
                                      ),
                                    )
                                  ],
                                )),
                          )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Wrap(
                      spacing: isHighRes ? 30 : 10,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        labeledField(
                          context: context,
                          isMobile: isMobile,
                          label: AppText.from,
                          // width: fieldWidth/1.4,
                          // width: fieldWidth/1.2,
                          // width: 155,
                          width: isHighRes ? 180 : 155,
                          column: true,
                          child: SizedBox(
                              height: 30,
                              child: KeyboardDatePicker(
                                key: ValueKey(controller.datePickerResetKey),
                            initialDate: controller.multiReservationFromDate?? DateTime.now(),
                            borderClr: Colors.blue,
                            onChanged: (date) {
                              controller.multiReservationFromDate = date;
                              controller.update();
                            },
                            onSubmitted: (date) {
                              print("User pressed enter: $date");
                            },
                          )),
                        ),
                        labeledField(
                          context: context,
                          isMobile: isMobile,
                          label: AppText.to,
                          // width: fieldWidth/1.4,
                          // width: fieldWidth/1.2,
                          // width: 155,
                          width: isHighRes ? 180 : 155,
                          column: true,
                          child: SizedBox(
                              height: 30,
                              child: KeyboardDatePicker(
                                key: ValueKey(controller.datePickerResetKey),
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
                          column: true,
                          // width: fieldWidth/2.3,
                          // width: fieldWidth / 2.0,
                          // width: 90,
                          width: isHighRes ? 110 : 90,
                          child: _timeField(
                              controller.multiReservationToTimeController,
                              onChanged: (_) {
                                controller.pickUpTimeController.text = controller.multiReservationToTimeController.text;
                                setState(() {});
                              }
                          ),
                        ),
                        if( controller.jourValue == 'W/R' ? true : false)
                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.rtime,
                            column: true,
                            // width: fieldWidth/2.3,
                            // width: fieldWidth / 2.0,
                            // width: 90,
                            width: isHighRes ? 110 : 90,
                            child: _timeField(controller
                                .returnMultiReservationToTimeController,
                                onChanged: (_) {
                                  controller.pickUpTimeControllerReturn.text = controller.returnMultiReservationToTimeController.text;
                                  setState(() {});
                                }
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: CustomButton(
                          height: 30,
                          // width: fieldWidth / 2,
                          // width: 140,
                          // width: 135,
                          width: 70,
                          fontSize: 10,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          onTap: (){
                            controller.addToMultiReservation(
                              endTime: controller.multiReservationToDate,
                              startTime: controller.multiReservationFromDate,
                              time: controller.multiReservationToTimeController.text,
                              selectedDays: controller.multiReservationDaysList,
                              returnTime: controller.jourValue == 'W/R'? controller.returnMultiReservationToTimeController.text:null,
                            );
                          },
                          btnText: "ADD",
                        ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: CustomButton(
                          height: 30,
                          onTap: (){
                            // Clear the lists
                            controller.resetMultiReservationFields();
                            controller.update();
                            // Get.back();
                          },
                          width: 70,
                          fontSize: 10,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          btnText: AppText.cancel,
                          btnColor: DynamicColors.redClr,
                        ),
                        ),
                      ],
                    ),
                  ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Wrap(
                          runSpacing: 10,
                          spacing: isHighRes ? 30 : 8,
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
                              // width: 120,
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
                              // width: 120,
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
                              // width: 120,
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
                              // width: 120,
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
                              // width: 120,
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
                              // width: 120,
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
                              // width: 120,
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          // width: Get.width/2,
                          // width: maxWidth < 1000 ? 1000 : maxWidth - 80,
                          width: maxWidth < 1000 ? 800 : maxWidth - 100,
                          child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(title: "EXCLUDE"),
                              buildHeaderWithSearch(title: "DAY"),
                              buildHeaderWithSearch(title: "DATE"),
                              buildHeaderWithSearch(title: "TIME"),
                              buildHeaderWithSearch(title: "RETURN TIME"),

                            ],

                            rows: [
                              // Existing extensions
                              ...controller
                                  .multiReservationList
                                  .map((object) {
                                return DataRow(
                                  cells: [
                                    // DataCell(Center(child: Text(object.exclude.toString().toUpperCase()))),
                                    // DataCell(
                                    //   Center(
                                    //     child: SizedBox(
                                    //       height: 24,
                                    //       width: 24,
                                    //       child: Checkbox(
                                    //         value: object.exclude,
                                    //         activeColor: DynamicColors.primaryClr,
                                    //         onChanged: (bool? value) {
                                    //           setState(() {
                                    //             object.exclude = value ?? false;
                                    //           });
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    DataCell(
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              object.exclude = !object.exclude;
                                            });
                                          },
                                          child: SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: Checkbox(
                                              value: object.exclude,
                                              activeColor: DynamicColors.primaryClr,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  object.exclude = value ?? false;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Center(child: Text(object.day??""))),
                                    DataCell(Center(child: Text(object.startDate??""))),
                                    DataCell(
                                      Center(
                                        child: SizedBox(
                                          width: 75,
                                          height: 25,
                                          child: TimePickerField(
                                            controller: TextEditingController(text: object.returnTime ?? ""),
                                            accent: DynamicColors.primaryClr,
                                            textStyle: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                            onChanged: (val) {
                                              object.returnTime = val;
                                            },
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue, width: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: controller.jourValue == 'W/R'
                                            ? SizedBox(
                                          width: 75,
                                          height: 25,
                                          child: TimePickerField(
                                            controller: TextEditingController(text: object.endTime ?? ""),
                                            accent: DynamicColors.primaryClr,
                                            textStyle: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            onChanged: (val) {
                                              object.endTime = val;
                                            },
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue, width: 1),
                                              ),
                                            ),
                                          ),
                                        )
                                            : const Text("-", style: TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                    ]),
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
                              if (controller.multiReservationList.isEmpty) {
                                BotToast.showText(text: "Please select data first");
                                return;
                              }
                              await controller.getFaresCalculation();
                              // final storedTemFare = await getFares(
                              //     journeyTypeId: controller.selectJourneyTypeValue!.id,
                              //     multiReservationList: controller.multiReservationList,
                              //     dropOff: controller.pickupController.text,
                              //     pickup: controller.dropOffController.text,
                              //     miles: controller.totalDistance.value,
                              //     dropoffPlotId: controller.dashboardZoneValue != null? controller.dashboardZoneValue!.id:null,
                              //     pickupDate: "${controller.pickUpDate!.year}-${controller.pickUpDate!.month}-${controller.pickUpDate!.day}",
                              //     pickupTime: controller.pickUpTimeController.text,
                              //     vehicleTypeId: controller.selectVehicleValue!.id,
                              //     returnVehicleTypeId: controller.selectVehicleValueReturn == null ? null : controller.selectVehicleValueReturn!.id
                              //
                              // );
                              // var fareValue = jsonDecode(storedTemFare);
                              // controller.fixedFare.value = fareValue['total_fare'].toString();
                              // controller.returnFareValue = fareValue== null?"0": fareValue['return_fare'].toString();
                              // controller.slugControllerReturn.text = fareValue== null?"0": fareValue['return_fare'].toString();
                              // controller.slugController.text = fareValue['fare'].toString();
                              // controller.update();
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
  String? time,returnTime, day, startDate, endTime;
  bool exclude = false;
  String? selectedTitle;


  MultiReservation({this.day, this.time, this.startDate, this.exclude = false, this.returnTime, this.endTime, this.selectedTitle});
}