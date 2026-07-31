


import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
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
    return GetBuilder<FareController>(
        initState: (v){
          controller.getSurcharges();
        },


        builder: (controller) {

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
                    // SizedBox(
                    //   width: fieldWidth*2,
                    //   child:
                      Column(
                        children: [
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(border: Border.all(color: DynamicColors.gryClr)),
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
                                      CustomDropdownField<String>(
                                        label: "POSTCODE WISE",
                                        width: Get.width / 5,
                                        height: 35,
                                        items: [
                                          "POSTCODE WISE",
                                        ],
                                        value: controller.postCodeWise,
                                        itemLabel: (data) =>
                                        data,
                                        onChanged: (val) {
                                          controller.postCodeWise = val;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.surChargesFareController,
                                  width: fieldWidth/1.8,
                                  hintText: AppText.fare,
                                  height: 30,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  columnText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                  ],
                                ),

                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.postCodeFareController,
                                  width: fieldWidth/1.8,
                                  hintText: AppText.postCode,
                                  columnText: true,
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  height: 30,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.extraDropOffFareController,
                                  width: fieldWidth/1.8,
                                  hintText: AppText.extraDropOff,
                                  height: 30,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  columnText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                  ],
                                ),
                                SizedBox(
                                  width: fieldWidth/1.8,
                                  // height: 30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.operator, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      CustomDropdownField<String>(
                                        label: "SELECT OPERATION",
                                        width: Get.width / 5,
                                        height: 35,
                                        items: [
                                          "SELECT OPERATION",
                                          "AMOUNT",
                                          "PERCENTAGE",
                                        ],
                                        value: controller.selectOperation,
                                        itemLabel: (data) =>
                                        data,
                                        onChanged: (val) {
                                          controller.selectOperation = val;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.congestionFareController,
                                  width: fieldWidth/1.8,
                                  hintText: AppText.congestion,
                                  height: 30,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  columnText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                  ],
                                ),

                                SizedBox(
                                  width: fieldWidth/1.8,
                                  // height: 30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.applyCondition, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      CustomDropdownField<String>(
                                        label: "PICKUP",
                                        width: Get.width / 5,
                                        height: 35,
                                        items: [
                                          "PICKUP",
                                          "DROPOFF",
                                          "BOTH",
                                        ],
                                        value: controller.selectPickup,
                                        itemLabel: (data) =>
                                        data,
                                        onChanged: (val) {
                                          controller.selectPickup = val;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.parkingFareController,
                                  width: fieldWidth/1.8,
                                  hintText: AppText.parking,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  columnText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                  ],
                                  height: 30,
                                ),
                                SizedBox(
                                  width: fieldWidth/1.8,
                                  // height: 30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.timeLine, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      CustomDropdownField<String>(
                                        label: "DATE WISE",
                                        width: Get.width / 5,
                                        height: 35,
                                        items: [
                                          "DATE WISE",
                                          "TIME WISE",
                                          "DAY WISE",
                                        ],
                                        value: controller.selectDateWise,
                                        itemLabel: (data) =>
                                        data,
                                        onChanged: (val) {
                                          controller.selectDateWise = val;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: controller.selectDateWise !="DATE WISE"?false:true,
                                  child: labeledField(
                                    context: context,
                                    isMobile: isMobile,
                                    label: "FROM",
                                    column: true,
                                    width: fieldWidth/1.8,
                                    child: SizedBox(height: 30, child: KeyboardDatePicker(
                                      initialDate: controller.startDateSurCharges ?? DateTime.now(),
                                      onChanged: (date) {
                                        controller.startDateSurCharges = date;
                                        controller.update();
                                      },
                                    )),
                                  ),
                                ),
                                labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  column: true,
                                  label: "FROM",
                                  width: fieldWidth/1.8,
                                  child: SizedBox(height: 30,
                                      child: CustomTimePicker(
                                    controller: controller.startTimeSurCharge, // optional
                                    onTimeSelected: (time) {
                                      setState(() {
                                        print(controller.startTimeSurCharge.text);
                                        print(time);
                                      });
                                    },
                                  )),
                                ),
                                Visibility(
                                  visible: controller.selectDateWise !="DATE WISE"?false:true,
                                  child: labeledField(
                                    context: context,
                                    isMobile: isMobile,
                                    label: "TO",
                                    column: true,
                                    width: fieldWidth/1.8,
                                    child: SizedBox(height: 30, child: KeyboardDatePicker(
                                      initialDate: controller.endDateSurCharges ?? DateTime.now(),
                                      onChanged: (date) {
                                        controller.endDateSurCharges = date;
                                        controller.update();
                                      },
                                    )),
                                  ),
                                ),
                                 labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  column: true,
                                  label: "TO",
                                  width: fieldWidth/1.8,
                                  child: SizedBox(height: 30, child: CustomTimePicker(
                                    controller: controller.endTimeSurCharge, // optional
                                    onTimeSelected: (time) {
                                      setState(() {
                                        print(controller.endTimeSurCharge.text);
                                        print(time);
                                      });
                                    },
                                  )),
                                 ),
                                Visibility(
                                  visible: controller.selectDateWise == "DAY WISE"?true:false,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: List.generate(
                                      daysList.length,
                                          (index) {
                                        final item = daysList[index];
                                        return Obx(() => GestureDetector(
                                          onTap: () {
                                            // Yeh line check karegi current state kya hai aur usko ulat (toggle) degi
                                            item.selectedDay!.value = !item.selectedDay!.value;

                                            // Agar aapko selected item ka reference save karna hai (optional)
                                            controller.selectedDay = item;
                                          },
                                          child: Chip(
                                            padding: EdgeInsets.zero,
                                            labelPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),
                                            backgroundColor: item.selectedDay!.value
                                                ? DynamicColors.primaryClr
                                                : Colors.transparent,
                                            shape: StadiumBorder(
                                              side: BorderSide(
                                                color: DynamicColors.primaryClr,
                                                width: 1,
                                              ),
                                            ),

                                            label: Text(
                                              item.dayName!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: item.selectedDay!.value
                                                    ? Colors.white
                                                    : DynamicColors.textClr,
                                              ),
                                            ),
                                          ),
                                        ));
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),

                                CustomButton(
                                  onTap: (){
                                    controller.postSurchargeData();
                                  },
                                  width: fieldWidth/1.8,
                                  height: 30,
                                  borderRadius: 4,
                                  btnText: controller.sureChargeObject == null ? AppText.save: AppText.update,
                                  btnColor: DynamicColors.primaryClr,
                                  verticalPadding: 0.0,
                                  fontSize: 14,
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: Get.width,
                    child: controller.getSurchargesModel == null?SizedBox.shrink():
                    DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "TYPE", removeSearching: true ),
                        buildHeaderWithSearch(title: "CONDITION", removeSearching: true),
                        buildHeaderWithSearch(title: "POSTCODE", removeSearching: true),
                        buildHeaderWithSearch(title: "FARE", removeSearching: true),
                        buildHeaderWithSearch(title: "PC", removeSearching: true),
                        buildHeaderWithSearch(title: "EDC", removeSearching: true),
                        buildHeaderWithSearch(title: "CC", removeSearching: true),
                        buildHeaderWithSearch(title: "DURATION", removeSearching: true),
                        buildHeaderWithSearch(title: "DAY", removeSearching: true),
                        buildHeaderWithSearch(title: "FROM", removeSearching: true),
                        buildHeaderWithSearch(title: "TO", removeSearching: true),
                        buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),

                      ],
                      rows: controller
                          .getSurchargesModel!.surcharges!
                          .map((surcharges) => DataRow(
                        cells: [
                          DataCell(Center(child: Text(surcharges.surchargesType ?? ""))),
                          DataCell(Center(child: Text(surcharges.condition ?? ""))),
                          DataCell(Center(child: Text(surcharges.postcode ?? ""))),
                          DataCell(Center(child: Text(surcharges.fare ?? ""))),
                          DataCell(Center(child: Text(surcharges.parkingCharges ?? ""))),
                          DataCell(Center(child: Text(surcharges.extraDropCharges ?? ""))),
                          DataCell(Center(child: Text(surcharges.congestionCharges ?? ""))),
                          DataCell(Center(child: Text(surcharges.duration ?? ""))),
                          DataCell(Center(child: Text(surcharges.day ?? "-"))),
                          DataCell(Center(child: Text(
                            surcharges.duration == "DATE WISE"
                                ? "${surcharges.fromDate ?? ""} | ${surcharges.fromTime ?? ""}"
                                : (surcharges.fromTime ?? "") ))),
                          DataCell(Center(child: Text(
                            surcharges.duration == "DATE WISE"
                                ? "${surcharges.toDate ?? ""} | ${surcharges.toTime ?? ""}"
                                : (surcharges.toTime ?? "")  ))),



                          DataCell(
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(32, 32),
                                      side: BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    onPressed: () {
                                      // 🟢 Edit action
                                      controller.bindSurChargesData(sureChargeData: surcharges);
                                    },
                                    child: Icon(Icons.edit_calendar,
                                        size: 20,
                                        color:
                                        DynamicColors.primaryClr),
                                  ),
                                  Text("| "),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(32, 32),
                                      side: BorderSide(
                                          color: Colors.transparent),
                                      backgroundColor: surcharges.active == true ? DynamicColors.secondaryClr : Colors.transparent,
                                    ),
                                    onPressed: () {
                                      controller.bindSurChargesData(sureChargeData: surcharges, changeActiveStatus: true);
                                    },
                                    child: Icon(
                                      surcharges.active == true ? Icons.check: Icons.close,
                                        size: 20,
                                        color: surcharges.active == true ? DynamicColors.greenClr : DynamicColors.redClr,
                                    ),
                                  ),
                                  Text("| "),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(32, 32),
                                      side: BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    onPressed: () {
                                      controller.deleteSureCharge(id: surcharges.id);
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
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          }
        );
      }
    );
  }
}

List<DaysClass> daysList = [
  DaysClass(dayName: "MON",selectedDay: false.obs),
  DaysClass(dayName: "TUES",selectedDay: false.obs),
  DaysClass(dayName: "WED",selectedDay: false.obs),
  DaysClass(dayName: "THURS",selectedDay: false.obs),
  DaysClass(dayName: "FRI",selectedDay: false.obs),
  DaysClass(dayName: "SAT",selectedDay: false.obs),
  DaysClass(dayName: "SUN",selectedDay: false.obs),
];

class DaysClass {
  String? dayName;
  RxBool? selectedDay = false.obs;
  DaysClass({this.dayName,this.selectedDay});
}
