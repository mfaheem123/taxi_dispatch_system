import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/fare_view/model/fixedFareVehicleLocationTypeModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/networks/api.dart';
import '../../../component/pagination.dart';
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

  List permissions = [];
  @override
  void initState() {
    permissions = Api().sp.read('all_permissions') ?? [];
    super.initState();
    shortCutKeyValue.value = "createFixedFareSetting";
    controller.clearForm();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<FareController>(initState: (v) {
      controller.fixedFareVehicleLocationTypeModel = null;
      controller.getFixedFareVehicleLocationType();
      controller.getAllFixedFare();
      // controller.getFixedFareVehicleLocationType();
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
                  key: controller.stackKey,
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
                                      label: "SELECT VEHICLE TYPE",
                                      width: fieldWidth,
                                      height: 35,
                                      items: controller
                                          .fixedFareVehicleLocationTypeModel!
                                          .vehicleTypesFixed!,
                                      value: controller
                                                  .fixedFareVehicleLocationTypeModel
                                                  ?.vehicleTypesFixed
                                                  ?.contains(controller
                                                      .vehicleTypesFixedvalue) ==
                                              true
                                          ? controller.vehicleTypesFixedvalue
                                          : null,
                                      itemLabel: (templateList) =>
                                          templateList.name!.toUpperCase(),
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
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                columnText: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                ],
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
                                      label: "SELECT LOCATION TYPE",
                                      width: fieldWidth,
                                      height: 35,
                                      items: controller
                                          .fixedFareVehicleLocationTypeModel!
                                          .locationTypes!,
                                      value: controller.fromLocationTypeValue,
                                      itemLabel: (templateList) =>
                                          templateList.name!.toUpperCase(),
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
                                      label: "SELECT LOCATION TYPE",
                                      width: fieldWidth,
                                      height: 35,
                                      items: controller
                                          .fixedFareVehicleLocationTypeModel!
                                          .locationTypes!,
                                      value: controller.toLocationTypeValue,
                                      itemLabel: (templateList) =>
                                          templateList.name!.toUpperCase(),
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
                        Padding (
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
                                          Text("FROM LOCATION",
                                              style: mozillaTextSemiBoldText(
                                                  context: context,
                                                  fontSize: 13)),
                                          CallbackShortcuts(
                                            bindings: <ShortcutActivator,
                                                VoidCallback>{
                                              const SingleActivator(
                                                  LogicalKeyboardKey
                                                      .arrowDown): () {
                                                controller.activeField.value =
                                                    "from";
                                                controller.moveHighlightDown();
                                              },
                                              const SingleActivator(
                                                  LogicalKeyboardKey.arrowUp): () {
                                                controller.activeField.value =
                                                    "from";
                                                controller.moveHighlightUp();
                                              },
                                              const SingleActivator(
                                                  LogicalKeyboardKey.enter): () {
                                                controller.activeField.value =
                                                    "from";
                                                controller
                                                    .selectHighlightedAddress();
                                              },
                                            },
                                            child: SizedBox(
                                              key: controller.fromFieldKey,
                                              width: Get.width / 4,
                                              height: 35,
                                              child: TextField(
                                                  inputFormatters: [UpperCaseTextFormatter()],
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
                                                    controller.activeField.value = "from";
                                                    controller.activeFieldKey
                                                        .value = controller
                                                        .fromFieldKey;
                                                  },
                                                  onChanged: (v) {
                                                    controller.activeField.value = "from";
                                                    controller.activeFieldKey
                                                        .value = controller
                                                        .fromFieldKey;
                                                    controller.onChangeHandler(
                                                        fieldName: "via",
                                                        searchingText: v);
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "SEARCH ADDRESS",
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
                                          minimumSize: constraints.maxWidth >= 1024 && constraints.maxWidth < 1400
                                              ? const Size(33, 42)
                                              : const Size(40, 42),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4), // <-- border radius here
                                          ),
                                          side: BorderSide(
                                              color: DynamicColors
                                                  .gryClr), // optional border color
                                        ),
                                        onPressed: () {

                                          controller.addFromAddress();
                                        },

                                        child: Icon(Icons.add)),
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: constraints.maxWidth >= 1024 && constraints.maxWidth < 1400
                                              ? const Size(33, 42)
                                              : const Size(40, 42),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4), // <-- border radius here
                                          ),
                                          side: BorderSide(
                                              color: DynamicColors
                                                  .gryClr), // optional border color
                                        ),
                                        onPressed: () {
                                          controller.addressController.clear();
                                        },
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
                                          Text("TO LOCATION ",
                                              style: mozillaTextSemiBoldText(
                                                  context: context,
                                                  fontSize: 13)),
                                          CallbackShortcuts(
                                            bindings: <ShortcutActivator,
                                                VoidCallback>{
                                              const SingleActivator(
                                                  LogicalKeyboardKey
                                                      .arrowDown): () {
                                                controller.activeField.value =
                                                    "to";
                                                controller.moveHighlightDown();
                                              },
                                              const SingleActivator(
                                                  LogicalKeyboardKey.arrowUp): () {
                                                controller.activeField.value =
                                                    "to";
                                                controller.moveHighlightUp();
                                              },
                                              const SingleActivator(
                                                  LogicalKeyboardKey.enter): () {
                                                controller.activeField.value =
                                                    "to";
                                                controller
                                                    .selectHighlightedAddress();
                                              },
                                            },
                                            child: SizedBox(
                                              key: controller.toFieldKey,
                                              width: Get.width / 4,
                                              height: 35,
                                              child: TextField(
                                                  inputFormatters: [UpperCaseTextFormatter()],
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
                                                    controller.activeFieldKey
                                                        .value = controller
                                                        .toFieldKey;
                                                  },
                                                  onChanged: (v) {
                                                    controller.activeField
                                                        .value = "to";
                                                    controller.activeFieldKey
                                                        .value = controller
                                                        .toFieldKey;
                                                    controller.onChangeHandler1(
                                                        fieldName: "via",
                                                        searchingText: v);
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "SEARCH ADDRESS",
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
                                          minimumSize: constraints.maxWidth >= 1024 && constraints.maxWidth < 1400
                                              ? const Size(33, 42)
                                              : const Size(40, 42),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4), // <-- border radius here
                                          ),
                                          side: BorderSide(
                                              color: DynamicColors
                                                  .gryClr), // optional border color
                                        ),
                                        onPressed: () {

                                          controller.addToAddress();


                                        },
                                        child: Icon(Icons.add)),
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: constraints.maxWidth >= 1024 && constraints.maxWidth < 1400
                                              ? const Size(33, 42)
                                              : const Size(40, 42),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4),
                                          ),
                                          side: BorderSide(
                                              color: DynamicColors
                                                  .gryClr),
                                        ),
                                        onPressed: () {
                                          controller.addressController1.clear();
                                        },
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
                              if(permissions.contains('create_fixed_fare')) CustomButton(
                                height: 35,
                                width: fieldWidth,
                                btnText: controller.fixedFareAll.any((e) => e.fares == controller.fareController.text)
                                    ? "UPDATE"
                                    : AppText.save,
                                // btnText: controller
                                //             .fixedFareVehicleLocationTypeModel !=
                                //         null
                                //     ? "UPDATE"
                                //     : AppText.save,
                                verticalPadding: 0.0,
                                borderRadius: 4,
                                style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: DynamicColors.whiteClr),
                                onTap: () {
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
                        if(permissions.contains('read_fixed_fare')) SingleChildScrollView(
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
                                            Text((item.vehicleTypeName ?? "").toUpperCase()))),
                                    DataCell(Center(
                                        child:
                                            Text((item.area1.toString() ?? "").toUpperCase()))),
                                    DataCell(Center(
                                        child:
                                            Text((item.area2.toString() ?? "").toUpperCase()))),
                                    DataCell(
                                        Center(child: Text((item.fares ?? "").toUpperCase()))),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if(permissions.contains('update_fixed_fare')) OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: const Size(32, 32),
                                                side: const BorderSide(
                                                    color: Colors.transparent),
                                              ),
                                              onPressed: () {
                                                controller
                                                    .fixedFareBinding(item);

                                              },
                                              child: Icon(Icons.edit_calendar,
                                                  size: 20,
                                                  color:
                                                      DynamicColors.primaryClr),
                                            ),
                                            if(permissions.contains('delete_fixed_fare')) OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: const Size(32, 32),
                                                side: const BorderSide(
                                                    color: Colors.transparent),
                                              ),
                                              onPressed: () {

                                                controller
                                                    .deleteFixedFareSetting(
                                                        item.id);
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
                        ),
                        PaginationWidget(
                          currentPage: controller.currentPageFixedFare.value,
                          totalPages: controller.totalPagesFixedFare.value,
                          onPageChange: controller.onPageFixedFare,
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
                        top: top,
                        left: left,
                        width: width,
                        child: RawKeyboardListener(
                          focusNode: controller.viaFocusNode,
                          autofocus: false,
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
                            width: width,
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
                                                    "${item.name} ${item.postcode}".toUpperCase()),
                                              ),
                                              onTap: () {
                                                controller.selectedModel = item;

                                                if (controller
                                                        .activeField.value ==
                                                    "from") {
                                                  controller.addressController
                                                          .text =
                                                      "${item.name} ${item.postcode}".toUpperCase();
                                                } else {
                                                  controller.addressController1
                                                          .text =
                                                      "${item.name} ${item.postcode}".toUpperCase();
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
