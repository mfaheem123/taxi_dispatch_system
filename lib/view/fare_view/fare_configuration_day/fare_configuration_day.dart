import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/networks/ErrorMethod.dart';
import 'package:dashboard_new1/view/fare_view/model/getVehicleTypeAccountModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/pagination.dart' show PaginationWidget;
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/controller.dart';

class FareConfigurationDay extends StatefulWidget {
  const FareConfigurationDay({super.key});

  @override
  State<FareConfigurationDay> createState() => _FareConfigurationDayState();
}

class _FareConfigurationDayState extends State<FareConfigurationDay> {
  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows =
      50; // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "fareConfigurationDay";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(
        initState: (v) {
      if (controller.fareGetVehicleTypeAccount == null) {
        controller.getFareGetVehicleTypeAccount();
      } else {
        controller.getAllFareConfiguration();
      }
    }, builder: (controller) {
      return controller.getFareGetVehicleTypeAccountLoader.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final bool isMobile = maxWidth < 600;
              final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

              // Instead of fixed width, we calculate flexible field widths
              final double fieldWidth = isMobile
                  ? maxWidth // full width
                  : isTablet
                      ? maxWidth / 2
                      : maxWidth / 4;

              return  SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                              spacing: 10,
                              children: [
                                Text(AppText.fareConfiguration,
                                    style: titleDesign()),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: DynamicColors.whiteClr,
                                  ),
                                  child:
                                      // RestrictedDrivers(
                                      //   width: fieldWidth/1.5,
                                      //   height: 35,
                                      //   padding: 0.0,
                                      //   border: Border.all(
                                      //     color: DynamicColors.gryClr,
                                      //   ),
                                      //   titleText: "NORMAL DAY",
                                      //   driversList: [
                                      //     "Special Day",
                                      //   ],
                                      // ),
                                      CustomDropdownField<String>(
                                    label: "SELECT FARE CONFIGURATION",
                                    width: Get.width / 6,
                                    height: 30,

                                    items: [
                                      "NORMAL",
                                      "SPECIAL",
                                    ],

                                    value: controller.fareConfiguration,
                                    itemLabel: (templateList) => templateList,
                                    onChanged: (val) {
                                      controller.fareConfiguration = val;
                                      controller.getAllFareConfiguration();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Wrap(
                            verticalDirection: VerticalDirection.down,
                            spacing: fieldWidth / 2,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppText.vehicleType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                  CustomDropdownField<VehicleTypeConfiguration>(
                                    label: "Select Vehicle",
                                    width: fieldWidth,
                                    height: 35,
                                    items: controller.fareGetVehicleTypeAccount!.vehicleTypes!,
                                    value: controller.vehicleValue,
                                    itemLabel: (templateList) => templateList.name!,
                                    onChanged: (val) {
                                      controller.vehicleValue = val;
                                      controller.update();
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppText.account, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                  CustomDropdownField<Account>(
                                    label: "Select Account",
                                    width: fieldWidth,
                                    height: 35,
                                    items: controller.fareGetVehicleTypeAccount!.accounts!,
                                    value: controller.accountValue,
                                    itemLabel: (templateList) => templateList.name!,
                                    onChanged: (val) {
                                      controller.accountValue = val;
                                      controller.update();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          controller.fareConfiguration == "NORMAL"
                              ? Wrap(
                                  verticalDirection: VerticalDirection.down,
                                  spacing: fieldWidth / 2,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(AppText.fromDay,
                                            style: mozillaTextSemiBoldText(
                                                context: context, fontSize: 13)),
                                        CustomDropdownField<String>(
                                          label: "",
                                          width: fieldWidth,
                                          height: 35,
                                          items: controller. weekDayList,
                                          value: controller.fromDayValue,
                                          itemLabel: (day) => day,
                                          onChanged: (val) {
                                            controller.fromDayValue = val;
                                            controller.update();
                                          },
                                        ),
                                        // RestrictedDrivers(
                                        //
                                        //   width: fieldWidth/1.5,
                                        //   // height: 35,
                                        //   padding: 0.0,
                                        //   border: Border.all(
                                        //     color: DynamicColors.gryClr,
                                        //   ),
                                        //   titleText: AppText.fromDay,
                                        //   driversList: [
                                        //     "Sunday",
                                        //     "Monday",
                                        //     "Tuesday",
                                        //     "Wednesday",
                                        //     "Thursday",
                                        //     "Friday",
                                        //     "Saturday",
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(AppText.today, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                        CustomDropdownField<String>(
                                          label: "",
                                          width: fieldWidth,
                                          height: 35,
                                          items: controller.weekDayList,
                                          value: controller.toDayValue,
                                          itemLabel: (day) => day,
                                          onChanged: (val) {
                                            controller.toDayValue = val;
                                            controller.update();
                                          },
                                        ),
                                        // RestrictedDrivers(
                                        //   width: fieldWidth/1.5,
                                        //   // height: 35,
                                        //   padding: 0.0,
                                        //   border: Border.all(
                                        //     color: DynamicColors.gryClr,
                                        //   ),
                                        //   titleText: AppText.today,
                                        //   driversList: [
                                        //     "Sunday",
                                        //     "Monday",
                                        //     "Tuesday",
                                        //     "Wednesday",
                                        //     "Thursday",
                                        //     "Friday",
                                        //     "Saturday",
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ],
                                )
                              : Wrap(
                                  verticalDirection: VerticalDirection.down,
                                  spacing: fieldWidth / 2,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Start Date", style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: KeyboardDatePicker(
                                            initialDate: DateTime.now(),
                                            onChanged: (date) {
                                              // jab bhi user change kare
                                              controller.startDate = "${date.year}-${date.month}-${date.day}";
                                              print(date);
                                            },
                                            onSubmitted: (date) {
                                              // jab user enter press kare
                                              controller.startDate = "${date.year}-${date.month}-${date.day}";
                                              print("User pressed enter: $date");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("End Date", style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: KeyboardDatePicker(
                                            initialDate: DateTime.now(),
                                            onChanged: (date) {
                                              // jab bhi user change kare
                                              controller.endDate = "${date.year}-${date.month}-${date.day}";
                                              print(date);
                                            },
                                            onSubmitted: (date) {
                                              // jab user enter press kare
                                              controller.endDate =
                                                  "${date.year}-${date.month}-${date.day}";
                                              print("User pressed enter: $date");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 6,
                          ),
                          Wrap(
                            verticalDirection: VerticalDirection.down,
                            spacing: fieldWidth / 2,
                            children: [
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: AppText.fromTime,
                                width: fieldWidth,
                                column: true,
                                child: SizedBox(
                                    height: 30,
                                    child: CustomTimePicker(
                                      controller: controller.fromDayController,  // optional
                                      onTimeSelected: (time) {
                                        controller.fromDayController.text = time;
                                        controller.update();
                                      },
                                    )),
                              ),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: AppText.toTime,
                                width: fieldWidth,
                                column: true,
                                child: SizedBox(
                                    height: 30,
                                    child: CustomTimePicker(
                                      controller: controller.toDayController, // optional
                                      onTimeSelected: (time) {
                                        controller.toDayController.text = time;
                                        controller.update();
                                      },
                                    )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Wrap(
                            verticalDirection: VerticalDirection.down,
                            spacing: fieldWidth / 2,
                            children: [
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.startingFareController,
                                width: fieldWidth,
                                hintText: AppText.startingFare,
                                columnText: true,
                                height: 35,
                                keyboardType: TextInputType.number,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.startingMilesController,
                                width: fieldWidth,
                                hintText: AppText.startingMiles,
                                keyboardType: TextInputType.number,
                                columnText: true,
                                height: 35,
                              ),
                              Visibility(
                                visible: controller.fareConfiguration != "NORMAL"
                                    ? true
                                    : false,
                                child: CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.titleController,
                                  width: fieldWidth,
                                  hintText: "Title",
                                  columnText: true,
                                  height: 35,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CustomButton(
                              height: 30,
                              onTap: () {
                                if (controller.accountValue == null ||
                                    controller.vehicleValue == null) {
                                  BotToast.showText(text: "Please select account and vehicle");
                                  return;
                                }
                                if (controller.fareConfiguration != "NORMAL" && controller.titleController.text.isEmpty) {
                                  BotToast.showText(text: "Please write the title");
                                  return;
                                }
                                if (controller.fareConfiguration == "NORMAL" &&
                                    (controller.fromDayValue == null ||
                                        controller.toDayValue == null || controller.fromDayController.text.isEmpty||
                                        controller.toDayController.text.isEmpty)) {
                                  BotToast.showText(text: "Please select from-to day and start time and end time");
                                  return;
                                }
                                if (controller.startingFareController.text.isEmpty || controller.startingMilesController.text.isEmpty) {
                                  BotToast.showText(text: "Please write starting fare and starting miles");
                                  return;
                                }
                                if(controller.fareConfiguration != "NORMAL" && controller.fromDayController.text.isEmpty|| controller.toDayController.text.isEmpty){
                                  BotToast.showText(text: "Please select start and end time");
                                  return;
                                }
                                controller.createFareSetting();
                              },
                              width: fieldWidth,
                              btnText: AppText.save,
                              verticalPadding: 0.0,
                              borderRadius: 4,
                              style: mozillaTextRegularText(
                                  fontSize: 13,
                                  color: DynamicColors.whiteClr
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width,
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(
                              title: "VEHICLE TYPE", removeSearching: true),
                          buildHeaderWithSearch(
                              title: "ACCOUNT", removeSearching: true),
                          buildHeaderWithSearch(
                              title: controller.fareConfiguration != "NORMAL"?"Start Date":"FROM DAY", removeSearching: true),
                          buildHeaderWithSearch(
                              title: controller.fareConfiguration != "NORMAL"?"End Date": "TO DAY", removeSearching: true),
                          buildHeaderWithSearch(
                              title: "FROM TIME", removeSearching: true),
                          buildHeaderWithSearch(
                              title: "TO TIME", removeSearching: true),
                          buildHeaderWithSearch(
                              title: "MINIMUM FARES", removeSearching: true),
                          buildHeaderWithSearch(
                              title: "MINIMUM MILES", removeSearching: true),
                          if(controller.fareConfiguration != "NORMAL") buildHeaderWithSearch(
                              title: "TITLE", removeSearching: true),
                          buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                        ],
                        // 🔹 Dynamically create rows
                        rows: controller
                            .getAllFareConfigurationData!.fareConfigurations!
                            .map((fare) => DataRow(
                                  cells: [
                                    DataCell(Center(child: Text(fare.vehicleType!.name ?? ""))),
                                    DataCell(Center(child: Text(fare.account!.name ?? ""))),
                                    DataCell(Center(child: Text(controller.fareConfiguration != "NORMAL"?fare.fromDate.toString():fare.fromDay??""))),
                                    DataCell(Center(child: Text(controller.fareConfiguration != "NORMAL"?fare.toDate.toString():fare.toDay ?? ""))),
                                    DataCell(Center(child: Text(fare.fromTime ?? ""))),
                                    DataCell(Center(child: Text(fare.toTime ?? ""))),
                                    DataCell(Center(child: Text("£ ${fare.minimumFares ?? '0.00'}"))),
                                    DataCell(Center(child: Text("${fare.minimumMiles ?? '0.0'} MI"))),
                                   if(controller.fareConfiguration != "NORMAL") DataCell(Text(fare.title ?? "")),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: const Size(32, 32),
                                                side: const BorderSide(
                                                    color: Colors.transparent),
                                              ),
                                              onPressed: () {
                                                // 🟢 Edit action
                                              },
                                              child: Icon(Icons.edit_calendar,
                                                  size: 20,
                                                  color:
                                                      DynamicColors.primaryClr),
                                            ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: const Size(32, 32),
                                                side: const BorderSide(
                                                    color: Colors.transparent),
                                              ),
                                              onPressed: () {
                                                // 🔴 Delete action
                                              },
                                              child: Icon(Icons.delete_forever,
                                                  size: 20,
                                                  color: DynamicColors.redClr),
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
                  ],
                ),
              );
            });
    });
  }
}
