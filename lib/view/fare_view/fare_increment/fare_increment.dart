import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/controller.dart';

class FareIncrement extends StatefulWidget {
  const FareIncrement({super.key});

  @override
  State<FareIncrement> createState() => _FareIncrementState();
}

class _FareIncrementState extends State<FareIncrement> {
  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0;
  final int totalRows = 50;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "fareIncrement";


  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(
        initState: (v){
          controller.getFareIncrement();

        },

        builder: (controller) {
      return controller.getFareIncrementLoader==true?CircularProgressIndicator(): LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        final double fieldWidth = isMobile
            ? maxWidth
            : isTablet
            ? maxWidth / 2
            : maxWidth / 4;

        return Column(
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
                    child: Text(AppText.fareIncrement, style: titleDesign()),
                  ),
                  const SizedBox(height: 10),

                  /// MAIN INPUT AREA
                  Wrap(
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    runSpacing: 8,
                    spacing: 20,
                    children: [
                      /// Start Date
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.startDate,
                        width: fieldWidth / 2.0,
                        column: true,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(
                            initialDate: DateTime.now(),
                            onChanged: (date) {
                              controller.FareIncrementStart =
                              "${date.year}-${date.month}-${date.day}";
                            },
                            onSubmitted: (date) {
                              controller.FareIncrementStart =
                              "${date.year}-${date.month}-${date.day}";
                            },
                          ),
                        ),
                      ),

                      /// End Date
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.endDate,
                        column: true,
                        width: fieldWidth / 2.0,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(
                            initialDate: DateTime.now(),
                            onChanged: (date) {
                              controller.FareIncrementEnd =
                              "${date.year}-${date.month}-${date.day}";
                            },
                            onSubmitted: (date) {
                              controller.FareIncrementEnd =
                              "${date.year}-${date.month}-${date.day}";
                            },
                          ),
                        ),
                      ),


                      /// Operator Dropdown
                      SizedBox(
                        width: fieldWidth / 2.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppText.operator,
                                style: mozillaTextSemiBoldText(
                                    context: context, fontSize: 13)),
                            CustomDropdownField<String>(
                              label: "Select Operator",
                              width: Get.width / 6,
                              height: 30,
                              items: ["Percentage", "Amount"],
                              value: controller.operatorType,
                              itemLabel: (v) => v,
                              onChanged: (val) {
                                controller.operatorType = val;
                                controller.update();
                              },
                            ),
                          ],
                        ),
                      ),

                      /// Value
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.incrementValueVehicleController,
                        width: fieldWidth / 2.8,
                        hintText: AppText.value,
                        columnText: true,
                      ),

                      /// FIX FARE Button
                      OutlinedButton(

                        style: OutlinedButton.styleFrom(

                          backgroundColor:
                          controller.selectedType == "fixFare"
                              ? DynamicColors.primaryClr
                              : Colors.transparent,

                          side: BorderSide(color: DynamicColors.primaryClr),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          controller.selectType("fixFare");
                          controller.update();
                        },
                        child: Text(
                          AppText.fixeFare,
                          style: mozillaTextRegularText(
                            fontSize: 12,
                            color: controller.selectedType == "fixFare"
                                ? Colors.white
                                : DynamicColors.primaryClr,
                          ),
                        ),
                      ),

                      /// MILEAGE Button
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                          controller.selectedType == "mileage"
                              ? DynamicColors.primaryClr
                              : Colors.transparent,
                          side: BorderSide(color: DynamicColors.primaryClr),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {

                          controller.selectType("mileage");
                          controller.update();

                        },
                        child: Text(
                          AppText.mileage,
                          style: mozillaTextRegularText(

                            fontSize: 12,
                            color: controller.selectedType == "mileage"
                                ? Colors.white
                                : DynamicColors.primaryClr,

                          ),

                        ),
                      ),

                      /// Save Button
                      CustomButton(
                        height: 35,
                        width: 80,
                        verticalPadding: 0.0,
                        borderRadius: 4,
                        onTap: () {
                          controller.postFareIncrement();
                        },
                        widget: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0.0),
                          child: Text(
                            AppText.save,
                            style: mozillaTextRegularText(
                                fontSize: 12, color: DynamicColors.whiteClr),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),

            /// TABLE
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: Get.width,
                child: DatatableWidget(

                  columns: [
                    buildHeaderWithSearch(title: "FROM",removeSearching: true),
                    buildHeaderWithSearch(title: "TO",removeSearching: true),
                    buildHeaderWithSearch(title: "OPERATOR",removeSearching: true),
                    buildHeaderWithSearch(title: "VALUE",removeSearching: true),
                    buildHeaderWithSearch(title: "FIX FARE",removeSearching: true),
                    buildHeaderWithSearch(title: "MILEAGE",removeSearching: true),
                    buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                  ],

                  rows: controller
                      .getFareIncrementMoodel!.fareIncrement!
                      .map((fareIncrement) => DataRow(
                    cells: [
                      DataCell(Center(child: Text(fareIncrement.startDate! ?? ""))),
                      DataCell(Center(child: Text(fareIncrement.endDate! ?? ""))),
                      DataCell(Center(child: Text(fareIncrement.fareIncrementOperator! ?? ""))),
                      DataCell(Center(child: Text(fareIncrement.amount! ?? ""))),
                      fareIncrement.fixFare!.toString()=="true"?
                      DataCell(Center(child: Icon(Icons.check,color: Colors.green,))):DataCell(Center(child: Icon(Icons.cancel,color: Colors.red,))),
                      fareIncrement.mileage!.toString()=="true"?
                      DataCell(Center( child: Icon(Icons.check,color: Colors.green,))):DataCell(Center(child: Icon(Icons.cancel,color: Colors.red,))),
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
            ),
          ],
        );
      });
    });
  }
}
