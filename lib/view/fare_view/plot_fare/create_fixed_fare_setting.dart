import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/fare_view/model/fixedFareVehicleLocationTypeModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/controller.dart';

class CreateFixedFareSetting extends StatefulWidget {
  const CreateFixedFareSetting({super.key});

  @override
  State<CreateFixedFareSetting> createState() => _CreateFixedFareSettingState();
}

class _CreateFixedFareSettingState extends State<CreateFixedFareSetting> {
  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows =
      35; // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "createFixedFareSetting";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<FareController>(initState: (v) {
      controller.getFixedFareVehicleLocationType();
      controller.getAllFixedFare();
    }, builder: (controller) {
      final listToShow = controller.fixedFareFiltered.isNotEmpty
          ? controller.fixedFareFiltered
          : controller.fixedFareAll;
      return controller.getFixedFareVehicleLocationTypeLoader.value
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

              return Container(
                width: Get.width / 1.5,
                decoration: BoxDecoration(
                    border: Border.all(color: DynamicColors.gryClr)),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          color: DynamicColors.gryClr.withOpacity(0.5),
                          child: Text(AppText.fixedFare, style: titleDesign()),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Wrap(
                            verticalDirection: VerticalDirection.down,
                            spacing: fieldWidth / 2,
                            children: [
                              SizedBox(
                                width: fieldWidth,
                                // height: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppText.vehicleType,
                                        style: mozillaTextSemiBoldText(
                                            context: context, fontSize: 13)),
                                    CustomDropdownField<VehicleTypeFixed>(
                                      label: "Select Subsidiary",
                                      width: Get.width / 5,
                                      height: 35,
                                      items: controller
                                          .fixedFareVehicleLocationTypeModel!
                                          .vehicleTypesFixed!,
                                      value: controller.vehicleTypesFixedvalue,
                                      itemLabel: (templateList) =>
                                          templateList.name!,
                                      onChanged: (val) {
                                        controller.vehicleTypesFixedvalue = val;
                                        controller.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.fareController,
                                width: fieldWidth,
                                hintText: AppText.fare,
                                columnText: true,
                                height: 35,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Wrap(
                            verticalDirection: VerticalDirection.down,
                            spacing: fieldWidth / 2,
                            children: [
                              SizedBox(
                                width: fieldWidth,
                                // height: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppText.fromLocationType,
                                        style: mozillaTextSemiBoldText(
                                            context: context, fontSize: 13)),
                                    CustomDropdownField<LocationType>(
                                      label: "Select Subsidiary",
                                      width: Get.width / 5,
                                      height: 35,
                                      items: controller
                                          .fixedFareVehicleLocationTypeModel!
                                          .locationTypes!,
                                      value: controller.fromLocationTypeValue,
                                      itemLabel: (templateList) =>
                                          templateList.name!,
                                      onChanged: (val) {
                                        controller.fromLocationTypeValue = val;
                                        controller.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                // height: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppText.toLocationType,
                                        style: mozillaTextSemiBoldText(
                                            context: context, fontSize: 13)),
                                    CustomDropdownField<LocationType>(
                                      label: "Select Location Type",
                                      width: Get.width / 5,
                                      height: 35,
                                      items: controller
                                          .fixedFareVehicleLocationTypeModel!
                                          .locationTypes!,
                                      value: controller.toLocationTypeValue,
                                      itemLabel: (templateList) =>
                                          templateList.name!,
                                      onChanged: (val) {
                                        controller.toLocationTypeValue = val;
                                        controller.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Wrap(
                            verticalDirection: VerticalDirection.down,
                            spacing: fieldWidth / 2,
                            children: [
                              SizedBox(
                                width: fieldWidth,
                                // height: 30,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: fieldWidth / 1.2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("From Location",
                                              style: mozillaTextSemiBoldText(
                                                  context: context,
                                                  fontSize: 13)),
                                          // RestrictedDrivers(
                                          //   width: fieldWidth,
                                          //   height: 35,
                                          //   padding: 0.0,
                                          //   border: Border.all(
                                          //     color: DynamicColors.gryClr,
                                          //   ),
                                          //   titleText: "SELECT PLOT",
                                          //   driversList: [
                                          //     "25 GEORGE HAMPTON",
                                          //     "26 PAUL DOUBLEDAY",
                                          //     "27 RICHARD HARDWICK",
                                          //     "28 LANRE OKERJO",
                                          //   ],
                                          // ),
                                          RawKeyboardListener(
                                            focusNode: controller
                                                .searchingAddressViaFocusNode,
                                            onKey: (event) {
                                              if (event is RawKeyDownEvent) {
                                                if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowDown &&
                                                    controller.highlightedIndex
                                                            .value <
                                                        controller.suggestions
                                                                .length -
                                                            1) {
                                                  controller
                                                      .highlightedIndex.value++;
                                                } else if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowUp &&
                                                    controller.highlightedIndex
                                                            .value >
                                                        0) {
                                                  controller
                                                      .highlightedIndex.value--;
                                                } else if (event.logicalKey ==
                                                    LogicalKeyboardKey.enter) {
                                                  final selected = controller
                                                      .suggestions[controller
                                                          .highlightedIndex
                                                          .value]
                                                      .name;
                                                  controller.selectSuggestion(
                                                      selected);
                                                } else if (event
                                                            .logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowDown ||
                                                    event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowUp ||
                                                    event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .tab) {
                                                  FocusScope.of(Get.context!)
                                                      .requestFocus(controller
                                                          .viaFocusNode);
                                                }
                                                // }else if(event.logicalKey == LogicalKeyboardKey.tab){
                                                //   FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                                // }
                                              }
                                            },
                                            child: SizedBox(
                                              width: Get.width / 4,
                                              height: 35,
                                              child: TextField(
                                                  focusNode: controller
                                                      .viaFieldFocusNode,
                                                  controller: controller
                                                      .addressController,
                                                  style:
                                                      mozillaTextSemiBoldText(
                                                          context: context,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                  onTap: () {
                                                    controller.activeField
                                                        .value = "from";
                                                  },
                                                  onChanged: (v) {
                                                    controller.onChangeHandler(
                                                        fieldName: "via",
                                                        searchingText: v);
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "Search Address",
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 14),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(
                                              43, 42), // width & height
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4), // <-- border radius here
                                          ),
                                          side: BorderSide(
                                              color: DynamicColors
                                                  .gryClr), // optional border color
                                        ),
                                        onPressed: () {},
                                        child: Icon(Icons.add)),
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(
                                              43, 42), // width & height
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4), // <-- border radius here
                                          ),
                                          side: BorderSide(
                                              color: DynamicColors
                                                  .gryClr), // optional border color
                                        ),
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: DynamicColors.redClr,
                                          size: 20,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                // height: 30,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: fieldWidth / 1.2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("To Location ",
                                              style: mozillaTextSemiBoldText(
                                                  context: context,
                                                  fontSize: 13)),
                                          // RestrictedDrivers(
                                          //   width: fieldWidth,
                                          //   height: 35,
                                          //   padding: 0.0,
                                          //   border: Border.all(
                                          //     color: DynamicColors.gryClr,
                                          //   ),
                                          //   titleText: "SELECT PLOT",
                                          //   driversList: [
                                          //     "25 GEORGE HAMPTON",
                                          //     "26 PAUL DOUBLEDAY",
                                          //     "27 RICHARD HARDWICK",
                                          //     "28 LANRE OKERJO",
                                          //   ],
                                          // ),
                                          RawKeyboardListener(
                                            focusNode: controller
                                                .searchingAddress1ViaFocusNode,
                                            onKey: (event) {
                                              if (event is RawKeyDownEvent) {
                                                if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowDown &&
                                                    controller.highlightedIndex1
                                                            .value <
                                                        controller.suggestions1
                                                                .length -
                                                            1) {
                                                  controller.highlightedIndex1
                                                      .value++;
                                                } else if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowUp &&
                                                    controller.highlightedIndex1
                                                            .value >
                                                        0) {
                                                  controller.highlightedIndex1
                                                      .value--;
                                                } else if (event.logicalKey ==
                                                    LogicalKeyboardKey.enter) {
                                                  final selected = controller
                                                      .suggestions1[controller
                                                          .highlightedIndex1
                                                          .value]
                                                      .name;
                                                  controller.selectSuggestion(
                                                      selected);
                                                } else if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowDown ||
                                                    event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .arrowUp ||
                                                    event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .tab) {
                                                  FocusScope.of(Get.context!)
                                                      .requestFocus(controller
                                                          .viaFocusNode1);
                                                }
                                                // }else if(event.logicalKey == LogicalKeyboardKey.tab){
                                                //   FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                                // }
                                              }
                                            },
                                            child: SizedBox(
                                              width: Get.width / 4,
                                              height: 35,
                                              child: TextField(
                                                  focusNode: controller
                                                      .viaFieldFocusNode1,
                                                  controller: controller
                                                      .addressController1,
                                                  style:
                                                      mozillaTextSemiBoldText(
                                                          context: context,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                  onTap: () {
                                                    controller.activeField
                                                        .value = "to";
                                                  },
                                                  onChanged: (v) {
                                                    controller.onChangeHandler1(
                                                        fieldName: "via",
                                                        searchingText: v);
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "Search Address",
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 14),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(
                                              43, 42), // width & height
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4), // <-- border radius here
                                          ),
                                          side: BorderSide(
                                              color: DynamicColors
                                                  .gryClr), // optional border color
                                        ),
                                        onPressed: () {},
                                        child: Icon(Icons.add)),
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(
                                              43, 42), // width & height
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4), // <-- border radius here
                                          ),
                                          side: BorderSide(
                                              color: DynamicColors
                                                  .gryClr), // optional border color
                                        ),
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: DynamicColors.redClr,
                                          size: 20,
                                        )),
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
                            spacing: fieldWidth / 2,
                            children: [
                              CustomTextField(
                                contentPadding: EdgeInsets.all(8.0),
                                borderRadius: 4,
                                controller:
                                    controller.fareDescriptionController,
                                width: fieldWidth,
                                hintText: "",
                                columnText: true,
                                maxLines: 5,
                                height: 100,
                              ),
                              CustomTextField(
                                contentPadding: EdgeInsets.all(8.0),
                                borderRadius: 4,
                                controller:
                                    controller.fareDescription2ndController,
                                width: fieldWidth,
                                hintText: "",
                                columnText: true,
                                maxLines: 5,
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Wrap(
                            verticalDirection: VerticalDirection.down,
                            spacing: fieldWidth / 2,
                            children: [
                              CustomButton(
                                height: 35,
                                width: fieldWidth,
                                btnText: AppText.save,
                                verticalPadding: 0.0,
                                borderRadius: 4,
                                style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: DynamicColors.whiteClr),
                                onTap: ()  {
                                   controller.postFixedFare();

                                },
                              ),
                              CustomButton(
                                onTap: () {
                                  controller.clearFormData();
                                },
                                height: 35,
                                width: fieldWidth,
                                btnText: AppText.clear,
                                verticalPadding: 0.0,
                                btnColor: DynamicColors.redClr,
                                borderRadius: 4,
                                style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: DynamicColors.whiteClr),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: Get.width / 1.5,
                            child: DatatableWidget(
                              columns: [
                                buildHeaderWithSearch(
                                    title: "VEHICLE",
                                    onChanged: (v) {
                                      controller.searchVehicle.value = v;
                                      controller.onSearchFixedFares();
                                    }),
                                buildHeaderWithSearch(
                                    title: "FROM LOCATION",
                                    onChanged: (v) {
                                      controller.searchFromLocation.value = v;
                                      controller.onSearchFixedFares();
                                    }),
                                buildHeaderWithSearch(
                                    title: "TO LOCATION",
                                    onChanged: (v) {
                                      controller.searchToLocation.value = v;
                                      controller.onSearchFixedFares();
                                    }),
                                buildHeaderWithSearch(
                                    title: "FARES",
                                    onChanged: (v) {
                                      controller.searchFares.value = v;
                                      controller.onSearchFixedFares();
                                    }),
                                buildHeaderWithSearch(
                                    title: "ACTIONS", removeSearching: true),
                              ],
                              totalRow: listToShow.length,
                              rows: listToShow.map((item) {
                                return DataRow(
                                  cells: [
                                    DataCell(Center(
                                        child:
                                            Text(item.vehicleTypeName ?? ""))),
                                    DataCell(
                                        Center(child: Text(item.area1 ?? ""))),
                                    DataCell(
                                        Center(child: Text(item.area2 ?? ""))),
                                    DataCell(
                                        Center(child: Text(item.fares ?? ""))),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                );
                              }).toList(),
                              //   totalRow: 2,
                              //   cells: [
                              //     const DataCell(Center(child: Text("SALOON"))),
                              //     const DataCell(Center(child: Text("NW7"))),
                              //     const DataCell(
                              //         Center(child: Text("HEATHROW TERMINAL 2 TW6 1JS"))),
                              //     const DataCell(Center(child: Text("£55.00"))),
                              //     DataCell(
                              //       Center(
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.center,
                              //           children: [
                              //             OutlinedButton(
                              //               style: OutlinedButton.styleFrom(
                              //                 side: BorderSide(
                              //                   color: Colors.transparent,
                              //                 ), // border color & thickness
                              //               ),
                              //               onPressed: () {},
                              //               child: Icon(
                              //                 Icons.edit_calendar,
                              //                 size: 28,
                              //                 color: DynamicColors.primaryClr,
                              //               ),
                              //             ),
                              //             OutlinedButton(
                              //               style: OutlinedButton.styleFrom(
                              //                 side: BorderSide(
                              //                   color: Colors.transparent,
                              //                 ), // border color & thickness
                              //               ),
                              //               onPressed: () {},
                              //               child: Icon(
                              //                 Icons.delete_forever,
                              //                 size: 28,
                              //                 color: DynamicColors.redClr,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Obx(() {
                      if (controller.allAddressesData.isEmpty) {
                        return SizedBox.shrink();
                      }
                      final GlobalKey<State<StatefulWidget>>? activeKey =
                          controller.activeFieldKey.value;
                      final RenderBox? fieldBox = activeKey?.currentContext
                          ?.findRenderObject() as RenderBox?;
                      final RenderBox? stackBox =
                          controller.stackKey.currentContext?.findRenderObject()
                              as RenderBox?;
                      double top = 0.0;
                      double left = 0.0;
                      double width = Get.width / 4;
                      if (fieldBox != null && stackBox != null) {
                        final Offset localOffset = fieldBox
                            .localToGlobal(Offset.zero, ancestor: stackBox);
                        final double fieldHeight = fieldBox.size.height;
                        width = fieldBox.size.width;
                        top = localOffset.dy + fieldHeight;
                        left = localOffset.dx;
                      }
                      // ensure RawKeyboardListener gets focus when suggestions appear
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (controller.allAddressesData.isNotEmpty &&
                            !controller.viaFocusNode.hasFocus) {
                          // FocusScope.of(context).requestFocus(controller.pickupTextFieldFocusNode);
                        }
                      });

                      return Positioned(
                        top: 240,
                        // top: top,
                        left: left,
                        width: Get.width / 4,
                        child: RawKeyboardListener(
                          focusNode: controller.viaFocusNode,
                          autofocus: true,
                          onKey: (RawKeyEvent event) {
                            if (event is RawKeyDownEvent) {
                              if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowDown) {
                                controller.moveHighlightDown(
                                    viaConditionValue: false);
                                return;
                              } else if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowUp) {
                                controller.moveHighlightUp(
                                    viaConditionValue: false);
                                return;
                              }
                              // else if (event.logicalKey == LogicalKeyboardKey.enter){
                              //   controller.selectedModel = controller.allAddressesData[controller.suggestionSelectedIndex.value];
                              //   controller.addressController.text = "${controller.allAddressesData[controller.suggestionSelectedIndex.value].name} ${controller.allAddressesData[controller.suggestionSelectedIndex.value].postcode}";
                              //   controller.allAddressesData.clear();
                              //   controller.update();
                              //   print("enter press");
                              // }

                              else if (event.logicalKey ==
                                  LogicalKeyboardKey.enter) {
                                final selected = controller.allAddressesData[
                                    controller.suggestionSelectedIndex.value];

                                controller.selectedModel = selected;

                                if (controller.activeField.value == "from") {
                                  controller.addressController.text =
                                      "${selected.name} ${selected.postcode}";
                                } else {
                                  controller.addressController1.text =
                                      "${selected.name} ${selected.postcode}";
                                }

                                controller.allAddressesData.clear();
                                controller.update();
                              }

                              // Enter intentionally ignored so it does not select anything
                            }
                          },
                          child: Container(
                            height: screenHeight * 0.3,
                            // height: screenHeight * 0.3,
                            width: Get.width / 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF0F2),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0, 2)),
                              ],
                            ),

                            // Rebuild list when highlightedIndex or data changes
                            child: Obx(() => ListView.builder(
                                  key: controller.suggestionListKey,
                                  controller:
                                      controller.suggestionScrollController,
                                  itemCount: controller.allAddressesData.length,
                                  padding: EdgeInsets.only(top: 15),
                                  itemBuilder: (context, index) {
                                    final item =
                                        controller.allAddressesData[index];
                                    return Obx(
                                      () {
                                        final isHighlighted =
                                            controller.highlightedIndex.value ==
                                                index;
                                        return Container(
                                          key: controller
                                              .suggestionItemKeys[index],
                                          // key: ValueKey('suggestion_item_$index'),
                                          color: isHighlighted
                                              ? const Color(0xffA0DCFF)
                                              : Colors.transparent,
                                          child: ListTile(
                                              dense: true,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              // Animated text style so color/weight changes step-by-step
                                              title: AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                    milliseconds: 120),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: isHighlighted
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: isHighlighted
                                                      ? Colors.blue
                                                      : Colors.black,
                                                ),
                                                child: Text(
                                                    "${item.name} ${item.postcode}"),
                                              ),
                                              onTap: () {
                                                controller.selectedModel = item;

                                                if (controller
                                                        .activeField.value ==
                                                    "from") {
                                                  controller.addressController
                                                          .text =
                                                      "${item.name} ${item.postcode}";
                                                } else {
                                                  controller.addressController1
                                                          .text =
                                                      "${item.name} ${item.postcode}";
                                                }

                                                controller.allAddressesData
                                                    .clear();
                                                controller.update();
                                              }),
                                        );
                                      },
                                    );
                                  },
                                )),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            });
    });
  }
}
