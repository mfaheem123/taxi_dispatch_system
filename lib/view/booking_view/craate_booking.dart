import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/F8_widget_alert.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/F9_widget_alert.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/pickup_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/quotation_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart'
    hide KbdActivatable;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_fake.dart' as html;
import 'package:latlong2/latlong.dart';

import '../../alert/child_seats_alert.dart';
import '../../alert/extra_fares_alert.dart';
import '../../alert/extra_info_alert.dart';
import '../../alert/restrict_drivers_alert.dart';
import '../../component/dropdown_button.dart';
import '../../component/suggestion_widget/suggestion_controller.dart';
import '../../component/suggestion_widget/suggestion_view.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../../component/time_duration_method.dart';
import '../../routes/app_pages.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/dashboard/booking_form_widget.dart';
import '../dashboard_view/dashboard/map_view_widget.dart';
import '../dashboard_view/dashboard/shortcut_key_widget.dart';
import '../dashboard_view/models/account_darshboard_model.dart';
import '../dashboard_view/models/all_addresses_model.dart';
import '../dashboard_view/models/dashboard_model.dart';
import '../dashboard_view/widgets/fare_configuration.dart';
import '../dashboard_view/widgets/via_location.dart';
import '../locations_view/Model/location_types_zoneModel.dart' as location;
import '../locations_view/controller/locations_controller.dart';

class CreateBooking extends StatefulWidget {
  const CreateBooking({super.key});

  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {
  String selectedMenu = "";
  String selectedDropdownItem = "";
  DateTime selected = DateTime.now();
  final FocusNode swap1FN = FocusNode();
  final FocusNode swap2FN = FocusNode();
  final FocusNode calendarFN = FocusNode();
  final FocusNode checkboxFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode dropdownFocusNode = FocusNode();
  final FocusNode clearPic = FocusNode();
  final FocusNode clearDrop = FocusNode();

  final FocusNode clearPicTwo = FocusNode();
  final FocusNode swap2FNTwoWay = FocusNode();
  final FocusNode swap1FNTwoWay = FocusNode();
  final FocusNode checkboxFocusReturn = FocusNode();

  final List<FocusNode> _focusNodes =
      List.generate(4, (index) => FocusNode()); // 4 icons

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
      print("Controller initialized ✅");
    } else {
      print("Controller already exists, not re-initializing ♻️");
    }
    final params = Uri.base.queryParameters;
    print(params.length);
    print("value value 111");
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(dropdownFocusNode);
    });
  }

  @override
  void dispose() {
    super.dispose();
    calendarFN.dispose();
    dropdownFocusNode.dispose();
  }

  DashboardController controller = Get.put(DashboardController());

  SuggestionController suggestion_controller =
      Get.isRegistered<SuggestionController>()
          ? Get.find<SuggestionController>()
          : Get.put(SuggestionController());

  final LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    // Controller initialize only if not already put
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }

    return Scaffold(
      backgroundColor: DynamicColors.whiteClr,
      body: GetBuilder<DashboardController>(
        initState: (v) {
          controller.dashboardData();
          controller.seeZoneOnMapp();
          // controller.getMobileNumberWithName();
          if (_controller.locationtypezoneModel == null) {
            _controller.getLocationTypeZone();
          }
        },
        builder: (controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final bool isMobile = maxWidth < 600;
              final bool isTablet = maxWidth >= 400 && maxWidth < 1024;

              // Instead of fixed width, we calculate flexible field widths
              final double fieldWidth = isMobile
                  ? maxWidth // full width
                  : isTablet
                      ? maxWidth / 2.5
                      : maxWidth / 8;

              return Center(
                child: Container(
                  width: isMobile == true || isTablet == true
                      ? Get.width
                      : Get.width / 1.5,
                  height: Get.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: DynamicColors.textClr),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Shortcut Keys Row
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ShortcutKeyWidget(
                                    keyss: "F1", valuess: "BASE ADDRESS"),
                                const SizedBox(width: 10),
                                ShortcutKeyWidget(
                                    keyss: "F2", valuess: "BOOKING FORM"),
                                const SizedBox(width: 10),
                                ShortcutKeyWidget(
                                    keyss: "F6", valuess: "QUOTATION"),
                                const SizedBox(width: 10),
                                // Add more shortcut buttons here if needed
                              ],
                            ),
                          ),
                        ),
                        // Booking Title
                        // Top Row aligned with fields
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          decoration:
                              BoxDecoration(color: DynamicColors.secondaryClr),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                AppText.booking,
                                style: mozillaTextSemiBoldText(fontSize: 17),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              //
                              // SizedBox(
                              //   width: fieldWidth / 3,
                              // ),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: "",
                                width: fieldWidth / 1.5,
                                heights: 35,
                                child: Container(
                                  // height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: DynamicColors.primaryClr,
                                        width: 1.2),
                                  ),
                                  child: DropdownButtonFormField<
                                      DashboardDriverObject>(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    value: controller.selectDriverValue,
                                    items: controller.dashboardAllData!.drivers!
                                        .map((driver) => DropdownMenuItem<
                                                DashboardDriverObject>(
                                              value: driver,
                                              child: Text(
                                                driver.name ?? "",
                                                style: mozillaTextRegularText(
                                                  fontSize: 12,
                                                  color: DynamicColors.textClr,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (v) {
                                      controller.selectDriverValue = v;
                                      controller.update();
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 15,
                              ),

                              Text(
                                'SUB',
                                style: TextStyle(
                                  color: DynamicColors.primaryClr,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 200,
                                height: 35,
                                child: DropdownButtonFormField<DashboardSubsidiaryObject>(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      filled: true,
                                      fillColor: DynamicColors.whiteClr
                                  ),
                                  value: controller.selectSubsidiariesValue,
                                  items: controller.dashboardAllData!
                                      .subsidiaries!
                                      .map((subsidiaries) =>
                                      DropdownMenuItem<DashboardSubsidiaryObject>(
                                        value: subsidiaries,
                                        child: Text(subsidiaries.name ?? "",
                                          style: mozillaTextRegularText(
                                            fontSize: 12,
                                            color: DynamicColors.textClr,
                                          ),
                                        ),
                                      ))
                                      .toList(),
                                  onChanged: (v) {
                                    controller.selectSubsidiariesValue = v;
                                    controller.getAccountData(subsidiariesId: controller.selectSubsidiariesValue!.id);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Stack(key: controller.stackKey,
                            children: [
                          FocusTraversalGroup(
                            policy: OrderedTraversalPolicy(),
                            child: Column(
                              children: [
                                SizedBox(height: screenHeight * 0.01),

                                ///todo pickup fields widget
                                // Fields Row / Column Responsive
                                /*PickupWidget(),*/
                                ///todo pickup fields widget

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 16,
                                      runAlignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.start,
                                      children: [
                                        // ================= PICKUP ROW =================
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Wrap(
                                            runSpacing: 10,
                                            spacing: 16,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  AppText.pick,
                                                  style:
                                                      mozillaTextSemiBoldText(
                                                    context: context,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),

                                              // (1) Pickup textfield
                                              FocusTraversalOrder(
                                                order: NumericFocusOrder(1),
                                                child: SizedBox(
                                                  width: isMobile == true ||
                                                          isTablet == true
                                                      ? Get.width
                                                      : fieldWidth * 2.1,
                                                  height: 30,
                                                  child: RawKeyboardListener(
                                                    focusNode: controller
                                                        .pickupKeyboardFocusNode,
                                                    onKey: (event) {
                                                      if (event
                                                          is RawKeyDownEvent) {
                                                        if (event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .arrowDown &&
                                                            controller
                                                                    .highlightedIndex
                                                                    .value <
                                                                controller
                                                                        .suggestions
                                                                        .length -
                                                                    1) {
                                                          controller
                                                              .highlightedIndex
                                                              .value++;
                                                          FocusScope.of(
                                                                  Get.context!)
                                                              .requestFocus(
                                                                  controller
                                                                      .suggestionFocusNode);
                                                        } else if (event
                                                                    .logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .arrowUp &&
                                                            controller
                                                                    .highlightedIndex
                                                                    .value >
                                                                0) {
                                                          FocusScope.of(
                                                                  Get.context!)
                                                              .requestFocus(
                                                                  controller
                                                                      .suggestionFocusNode);
                                                          controller
                                                              .highlightedIndex
                                                              .value--;
                                                        } else if (event
                                                                .logicalKey ==
                                                            LogicalKeyboardKey
                                                                .enter) {
                                                          final selected = controller
                                                              .suggestions[
                                                                  controller
                                                                      .highlightedIndex
                                                                      .value]
                                                              .name;
                                                          controller
                                                              .selectSuggestion(
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
                                                          FocusScope.of(
                                                                  Get.context!)
                                                              .requestFocus(
                                                                  controller
                                                                      .suggestionFocusNode);
                                                        }
                                                      }
                                                    },
                                                    child: CustomTextField(
                                                      key: controller
                                                          .pickupFieldKey,
                                                      controller: controller
                                                          .pickupController,
                                                      width: isMobile == true ||
                                                              isTablet == true
                                                          ? Get.width
                                                          : fieldWidth * 2.1,
                                                      focusNode: controller
                                                          .pickupTextFieldFocusNode,
                                                      hintText:
                                                          'PICKUP LOCATION',
                                                      borderRadius: 4,
                                                      prefixIcon: const Icon(
                                                        Icons.location_pin,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onChanged: (v) {
                                                        controller.onChangeHandler(
                                                            fieldName:
                                                                "Create Booking PICKUP",
                                                            searchingText: v);
                                                      },
                                                      onTap: () {
                                                        shortCutKeyValue.value =
                                                            "Create Booking PICKUP";
                                                      },
                                                      onSubmitted: (_) =>
                                                          FocusScope.of(context)
                                                              .nextFocus(),
                                                      suffixIcon: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          controller
                                                                  .pickupController
                                                                  .text
                                                                  .isEmpty
                                                              ? SizedBox
                                                                  .shrink()
                                                              : KbdActivatable(
                                                                  focusNode:
                                                                      clearPic,
                                                                  onActivate:
                                                                      () {
                                                                    int index = controller
                                                                        .markers
                                                                        .indexWhere((test) =>
                                                                            test.type ==
                                                                            "pickup");
                                                                    // int indexx = controller.polyLineMarkerInfo.indexWhere(((element) => element.markerType == "PICKUP LOCATION"));
                                                                    // controller.polyLineMarkerInfo.remove(controller.polyLineMarkerInfo[indexx]);
                                                                    // controller.markers.remove(controller.markers[index]);
                                                                    FocusScope.of(Get
                                                                            .context!)
                                                                        .requestFocus(
                                                                            controller.pickupTextFieldFocusNode);
                                                                    controller
                                                                        .markers
                                                                        .clear();
                                                                    controller
                                                                        .polyLineMarkerInfo
                                                                        .clear();
                                                                    controller
                                                                        .pickupController
                                                                        .clear();
                                                                    controller
                                                                        .dropOffController
                                                                        .clear();
                                                                    controller
                                                                        .polylinePoints
                                                                        .clear();
                                                                    controller
                                                                        .fetchRouteFromOSRM();
                                                                    controller
                                                                        .update();
                                                                    // int index = controller.markers.indexWhere((test) => test.type == "pickup");
                                                                    // controller.markers
                                                                    //     .remove(controller.markers[index]);
                                                                    // controller.pickupController.clear();
                                                                    // controller.polylinePoints.clear();
                                                                    // controller.update();
                                                                  },
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: DynamicColors
                                                                        .redClr,
                                                                    size: 15,
                                                                  ),
                                                                ),
                                                          KbdActivatable(
                                                            focusNode: swap1FN,
                                                            onActivate: () {
                                                              String tempPic =
                                                                  controller
                                                                      .pickupController
                                                                      .text;
                                                              String tempDrop =
                                                                  controller
                                                                      .dropOffController
                                                                      .text;
                                                              controller
                                                                  .pickupController
                                                                  .text = tempDrop;
                                                              controller
                                                                  .dropOffController
                                                                  .text = tempPic;
                                                              controller
                                                                  .update();
                                                            },
                                                            child: const Icon(
                                                                Icons.swap_vert,
                                                                color: Color(
                                                                    0xFF575797),
                                                                size: 20),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Select PLots
                                              // Select Zone on pick Up location line
                                              Obx(
                                                () => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0),
                                                  child: FocusTraversalOrder(
                                                    order:
                                                        const NumericFocusOrder(
                                                            2),
                                                    child: CustomDropdownField<
                                                        location.ZoneObject>(
                                                      label: "Select Zone",
                                                      width: fieldWidth,
                                                      height: 30,
                                                      items: _controller
                                                                  .updateLocationValue
                                                                  .value ==
                                                              true
                                                          ? []
                                                          : _controller
                                                              .locationtypezoneModel!
                                                              .zonesList!,
                                                      value:
                                                          _controller.zoneValue,
                                                      itemLabel:
                                                          (templateList) =>
                                                              templateList
                                                                  .name!,
                                                      onChanged: (val) {
                                                        _controller.zoneValue =
                                                            val;
                                                        controller
                                                                .dashboardZoneValue =
                                                            val;
                                                        controller.update();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // (3) Pickup notes
                                              FocusTraversalOrder(
                                                order:
                                                    const NumericFocusOrder(3),
                                                child: SizedBox(
                                                  width: fieldWidth,
                                                  height: 30,
                                                  child: CustomTextField(
                                                    controller:
                                                        TextEditingController(),
                                                    hintText: "PICKUP NOTES",
                                                    borderRadius: 6,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    onSubmitted: (_) =>
                                                        FocusScope.of(context)
                                                            .nextFocus(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // ================= DROPOFF ROW =================

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Wrap(
                                            runSpacing: 10,
                                            spacing: 12,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  AppText.drop,
                                                  style:
                                                      mozillaTextSemiBoldText(
                                                    context: context,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),

                                              // (4) Dropoff textfield
                                              FocusTraversalOrder(
                                                order:
                                                    const NumericFocusOrder(4),
                                                child: SizedBox(
                                                  width: isMobile == true ||
                                                          isTablet == true
                                                      ? Get.width
                                                      : fieldWidth * 2.1,
                                                  height: 30,
                                                  child: RawKeyboardListener(
                                                    focusNode: controller
                                                        .dropOffKeyboardFocusNode,
                                                    onKey: (event) {
                                                      if (event
                                                          is RawKeyDownEvent) {
                                                        if (event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .arrowDown &&
                                                            controller.highlightedIndex
                                                                    .value <
                                                                controller
                                                                        .suggestions
                                                                        .length -
                                                                    1) {
                                                          controller
                                                              .highlightedIndex
                                                              .value++;
                                                        } else if (event
                                                                    .logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .arrowUp &&
                                                            controller
                                                                    .highlightedIndex
                                                                    .value >
                                                                0) {
                                                          controller
                                                              .highlightedIndex
                                                              .value--;
                                                        } else if (event
                                                                .logicalKey ==
                                                            LogicalKeyboardKey
                                                                .enter) {
                                                          final selected = controller
                                                              .suggestions[
                                                                  controller
                                                                      .highlightedIndex
                                                                      .value]
                                                              .name;
                                                          controller
                                                              .selectSuggestion(
                                                                  selected);
                                                        } else if (event
                                                                    .logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .arrowUp ||
                                                            event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .arrowDown ||
                                                            event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .tab) {
                                                          FocusScope.of(
                                                                  Get.context!)
                                                              .requestFocus(
                                                                  controller
                                                                      .suggestionFocusNode);
                                                        }
                                                      }
                                                    },
                                                    child: CustomTextField(
                                                      key: controller
                                                          .dropOffFieldKey,
                                                      controller: controller
                                                          .dropOffController,
                                                      focusNode: controller
                                                          .dropOffTextFieldFocusNode,
                                                      hintText: 'DROP LOCATION',
                                                      width: isMobile == true ||
                                                              isTablet == true
                                                          ? Get.width
                                                          : fieldWidth * 2.1,
                                                      borderRadius: 4,
                                                      prefixIcon: const Icon(
                                                        Icons.location_pin,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                      onTap: () {
                                                        shortCutKeyValue.value =
                                                            "Create Booking DROP LOCATION";
                                                      },
                                                      onChanged: (v) {
                                                        controller.onChangeHandler(
                                                            fieldName:
                                                                "Create Booking DROP LOCATION",
                                                            searchingText: v);
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onSubmitted: (_) =>
                                                          FocusScope.of(context)
                                                              .nextFocus(),
                                                      suffixIcon: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          controller
                                                                  .dropOffController
                                                                  .text
                                                                  .isEmpty
                                                              ? SizedBox
                                                                  .shrink()
                                                              : KbdActivatable(
                                                                  focusNode:
                                                                      clearDrop,
                                                                  onActivate:
                                                                      () {
                                                                    FocusScope.of(Get
                                                                            .context!)
                                                                        .requestFocus(
                                                                            controller.dropOffTextFieldFocusNode);
                                                                    controller
                                                                        .dropOffController
                                                                        .clear();
                                                                    controller
                                                                        .markers
                                                                        .clear();
                                                                    controller
                                                                        .polyLineMarkerInfo
                                                                        .clear();
                                                                    controller
                                                                        .pickupController
                                                                        .clear();
                                                                    controller
                                                                        .polylinePoints
                                                                        .clear();
                                                                    controller
                                                                        .fetchRouteFromOSRM();
                                                                    controller
                                                                        .update();
                                                                    // int index = controller
                                                                    //     .markers
                                                                    //     .indexWhere((test) =>
                                                                    //         test.type ==
                                                                    //         "dropOff");
                                                                    // controller.markers
                                                                    //     .remove(controller
                                                                    //             .markers[
                                                                    //         index]);
                                                                    // controller
                                                                    //     .dropOffController
                                                                    //     .clear();
                                                                    // controller.polylinePoints.clear();
                                                                    // controller.update();
                                                                  },
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: DynamicColors
                                                                        .redClr,
                                                                    size: 15,
                                                                  ),
                                                                ),
                                                          KbdActivatable(
                                                            focusNode: swap2FN,
                                                            onActivate: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) =>
                                                                      ViaLocation());
                                                            },
                                                            child: const Icon(
                                                                Icons
                                                                    .my_location,
                                                                color: Color(
                                                                    0xFF575797),
                                                                size: 20),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Select Plot
                                              Obx(
                                                () => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0),
                                                  child: FocusTraversalOrder(
                                                    order: NumericFocusOrder(5),
                                                    child: CustomDropdownField<
                                                        location.ZoneObject>(
                                                      label: "Select Zone",
                                                      width: fieldWidth,
                                                      height: 30,
                                                      items: _controller
                                                                  .updateDLocationValue
                                                                  .value ==
                                                              true
                                                          ? []
                                                          : _controller
                                                              .locationtypezoneModel!
                                                              .zonesList!,
                                                      value: _controller
                                                          .zoneDValue,
                                                      itemLabel:
                                                          (templateList) =>
                                                              templateList
                                                                  .name!,
                                                      onChanged: (val) {
                                                        _controller.zoneDValue =
                                                            val;
                                                        controller
                                                                .dashboardDZoneValue =
                                                            val;
                                                        controller.update();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // (3) Pickup notes
                                              FocusTraversalOrder(
                                                order: NumericFocusOrder(6),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: SizedBox(
                                                    width: fieldWidth,
                                                    height: 30,
                                                    child: CustomTextField(
                                                      controller:
                                                          TextEditingController(),
                                                      hintText: "DROP NOTES",
                                                      borderRadius: 6,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onSubmitted: (_) =>
                                                          FocusScope.of(context)
                                                              .nextFocus(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        FocusTraversalOrder(
                                          order: NumericFocusOrder(7),
                                          child: labeledTextField(
                                              context,
                                              isMobile,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              AppText.name,
                                              controller.nameController,
                                              width: fieldWidth,
                                              textInputAction:
                                                  TextInputAction.next),
                                        ),

                                        // email fileds
                                        FocusTraversalOrder(
                                          order: NumericFocusOrder(8),
                                          child: labeledTextField(
                                              context,
                                              isMobile,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              AppText.email,
                                              controller.emailController,
                                              width: fieldWidth,
                                              textInputAction:
                                                  TextInputAction.next),
                                        ),

                                        SizedBox(
                                          width: fieldWidth,
                                          // Fix: Column and Row must be instantiated with children
                                          child: (isMobile == true ||
                                                  isTablet == true)
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: _buildFields(
                                                      context,
                                                      isMobile,
                                                      isTablet,
                                                      fieldWidth), // Extracted for reuse
                                                )
                                              : Row(
                                                  children: _buildFields(
                                                      context,
                                                      isMobile,
                                                      isTablet,
                                                      fieldWidth),
                                                ),
                                        ),
                                        // Mob
                                        // SizedBox(
                                        //   width: fieldWidth,
                                        //   child: isMobile == true || isTablet == true? Column: Row(
                                        //     verticalDirection: VerticalDirection.down,
                                        //     children: [
                                        //       Padding(
                                        //         padding: const EdgeInsets.only(right: 16.0 ),
                                        //         child: Text(AppText.mobile, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                        //       ),
                                        //       FocusTraversalOrder(
                                        //         order: const NumericFocusOrder(9),
                                        //         child: RawKeyboardListener(
                                        //             focusNode: controller.phoneKeyboardFocusNode,
                                        //             onKey: (event) {
                                        //               if (event is RawKeyDownEvent) {
                                        //                 if (event.logicalKey ==
                                        //                     LogicalKeyboardKey.arrowDown &&
                                        //                     suggestion_controller.highlightedIndex.value <
                                        //                         suggestion_controller.allListData.length - 1) {
                                        //                   suggestion_controller.highlightedIndex.value++;
                                        //                 } else if (event.logicalKey ==
                                        //                     LogicalKeyboardKey.arrowUp &&
                                        //                     suggestion_controller.highlightedIndex.value >
                                        //                         0) {
                                        //                   suggestion_controller.highlightedIndex.value--;
                                        //                 } else if (event.logicalKey ==
                                        //                     LogicalKeyboardKey.enter) {
                                        //                   final selected = suggestion_controller.allListData[suggestion_controller.highlightedIndex.value].name;
                                        //                   suggestion_controller.selectSuggestion(selected);
                                        //                 }else if(event.logicalKey == LogicalKeyboardKey.arrowDown
                                        //                     || event.logicalKey == LogicalKeyboardKey.arrowUp
                                        //                     || event.logicalKey == LogicalKeyboardKey.tab){
                                        //                   FocusScope.of(Get.context!).requestFocus(controller.suggestionPhoneFocusNode.value);
                                        //                   FocusScope.of(Get.context!).requestFocus(controller.suggestionPhoneFocusNode.value);
                                        //                   controller.update();
                                        //                   // FocusScope.of(Get.context!).requestFocus(suggestion_controller.suggestionFocusNode.value);
                                        //                 }
                                        //               }
                                        //             },
                                        //             child: CustomTextField(
                                        //               focusNode: controller.phoneNumberFieldKey,
                                        //               controller: controller.mobileController,
                                        //               // hintText: AppText.mobile,
                                        //               borderRadius: 3,
                                        //               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        //               onChanged: (v){
                                        //                 if(v.isNotEmpty){
                                        //                   FocusScope.of(Get.context!).requestFocus(controller.phoneNumberFieldKey);
                                        //                   controller.onPhoneNoChangeHandler(fieldName: "Phone Number",searchingText: v);
                                        //                 }
                                        //               },
                                        //               width: fieldWidth/1.3,
                                        //             )
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // tel fields
                                        FocusTraversalOrder(
                                          order: const NumericFocusOrder(10),
                                          child: labeledTextField(
                                              context,
                                              isMobile,
                                              AppText.tel,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              controller.telController,
                                              width: fieldWidth,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType: TextInputType.phone,
                                              formatDigitsOnly: false),
                                        ),
                                        // date fields
                                        FocusTraversalOrder(
                                          order: NumericFocusOrder(11),
                                          child: labeledField(
                                            context: context,
                                            isMobile: isMobile,
                                            column: isMobile == true ||
                                                    isTablet == true
                                                ? true
                                                : false,
                                            label: AppText.date,
                                            width: fieldWidth,
                                            child: SizedBox(
                                                height: 30,
                                                width: fieldWidth,
                                                child: KeyboardDatePicker(
                                                  initialDate:
                                                      controller.pickUpDate ??
                                                          DateTime.now(),
                                                  borderClr: Colors.blue,
                                                  onChanged: (date) async {
                                                    controller.pickUpDate =
                                                        date;
                                                    final storedTemFare = await getFares(
                                                        journeyTypeId: controller
                                                            .selectJourneyTypeValue!
                                                            .id,
                                                        multiReservationList:
                                                            controller
                                                                .multiReservationList,
                                                        dropOff: controller
                                                            .pickupController
                                                            .text,
                                                        pickup: controller
                                                            .dropOffController
                                                            .text,
                                                        miles: controller
                                                            .totalDistance
                                                            .value,
                                                        dropoffPlotId:
                                                            controller.dashboardZoneValue != null
                                                                ? controller
                                                                    .dashboardZoneValue!
                                                                    .id
                                                                : null,
                                                        pickupDate:
                                                            "${controller.pickUpDate!.year}-${controller.pickUpDate!.month}-${controller.pickUpDate!.day}",
                                                        pickupTime: controller
                                                            .pickUpTimeController
                                                            .text,
                                                        vehicleTypeId: controller
                                                            .selectVehicleValue!
                                                            .id);
                                                    controller.fixedFare.value =
                                                        storedTemFare;
                                                    controller.update();
                                                  },
                                                  onSubmitted: (date) {
                                                    // jab user enter press kare
                                                    print(
                                                        "User pressed enter: $date");
                                                  },
                                                )),
                                          ),
                                        ),

                                        // (6) Time
                                        FocusTraversalOrder(
                                          order: const NumericFocusOrder(12),
                                          child: labeledField(
                                            context: context,
                                            isMobile: isMobile,
                                            column: isMobile == true ||
                                                    isTablet == true
                                                ? true
                                                : false,
                                            label: AppText.time,
                                            width: fieldWidth,
                                            child: SizedBox(
                                                height: 30,
                                                child: CustomTimePicker(
                                                  controller: controller
                                                      .pickUpTimeController, // optional
                                                  onTimeSelected: (time) async {
                                                    controller
                                                        .pickUpTimeController
                                                        .text = time;
                                                    final storedTemFare = await getFares(
                                                        journeyTypeId: controller
                                                            .selectJourneyTypeValue!
                                                            .id,
                                                        multiReservationList:
                                                            controller
                                                                .multiReservationList,
                                                        dropOff: controller
                                                            .pickupController
                                                            .text,
                                                        pickup: controller
                                                            .dropOffController
                                                            .text,
                                                        miles: controller
                                                            .totalDistance
                                                            .value,
                                                        dropoffPlotId:
                                                            controller.dashboardZoneValue != null
                                                                ? controller
                                                                    .dashboardZoneValue!
                                                                    .id
                                                                : null,
                                                        pickupDate:
                                                            "${controller.pickUpDate!.year}-${controller.pickUpDate!.month}-${controller.pickUpDate!.day}",
                                                        pickupTime: controller
                                                            .pickUpTimeController
                                                            .text,
                                                        vehicleTypeId: controller
                                                            .selectVehicleValue!
                                                            .id);
                                                    controller.fixedFare.value =
                                                        storedTemFare;
                                                    setState(() {
                                                      print(controller
                                                          .pickUpTimeController
                                                          .text);
                                                    });
                                                  },
                                                )),
                                          ),
                                        ),

                                        // (7) Lead (mins)
                                        FocusTraversalOrder(
                                          order: const NumericFocusOrder(13),
                                          child: labeledField(
                                            context: context,
                                            isMobile: isMobile,
                                            column: isMobile == true ||
                                                    isTablet == true
                                                ? true
                                                : false,
                                            label: AppText.lead,
                                            width: fieldWidth,
                                            child: SizedBox(
                                              height: 30,
                                              child: CustomTextField(
                                                hintText: "MINS",
                                                controller:
                                                    controller.minController,
                                                borderRadius: 4,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onSubmitted: (_) =>
                                                    FocusScope.of(context)
                                                        .nextFocus(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // (8) Journey dropdown (O/W, R/N, W/R)
                                        FocusTraversalOrder(
                                          order: const NumericFocusOrder(14),
                                          child: labeledField(
                                            context: context,
                                            isMobile: isMobile,
                                            column: isMobile == true ||
                                                    isTablet == true
                                                ? true
                                                : false,
                                            label: AppText.jour,
                                            width: fieldWidth,
                                            heights: 33,
                                            child: Container(
                                              // height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: DynamicColors
                                                        .primaryClr,
                                                    width: 1.2),
                                              ),
                                              child: DropdownButtonFormField<
                                                  JourneyTypeObject>(
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                value: controller
                                                    .selectJourneyTypeValue,
                                                items: controller
                                                    .dashboardAllData!
                                                    .journeyTypes!
                                                    .map((journey) =>
                                                        DropdownMenuItem<
                                                            JourneyTypeObject>(
                                                          value: journey,
                                                          child: Text(
                                                            journey.journeyType ??
                                                                "",
                                                            style:
                                                                mozillaTextRegularText(
                                                              fontSize: 12,
                                                              color:
                                                                  DynamicColors
                                                                      .textClr,
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                                onChanged: (v) async {
                                                  // O/W, R/N, W/R
                                                  final storedTemFare =
                                                      await getFares(
                                                          multiReservationList: controller
                                                              .multiReservationList,
                                                          // day: ,
                                                          dropOff: controller
                                                              .pickupController
                                                              .text,
                                                          pickup: controller
                                                              .dropOffController
                                                              .text,
                                                          miles: controller
                                                              .totalDistance
                                                              .value,
                                                          journeyTypeId: v!.id,
                                                          dropoffPlotId:
                                                              controller.dashboardZoneValue != null
                                                                  ? controller
                                                                      .dashboardZoneValue!
                                                                      .id
                                                                  : null,
                                                          pickupDate:
                                                              "${controller.pickUpDate!.year}-${controller.pickUpDate!.month}-${controller.pickUpDate!.day}",
                                                          pickupTime: controller
                                                              .pickUpTimeController
                                                              .text,
                                                          vehicleTypeId: controller
                                                              .selectVehicleValue!
                                                              .id,
                                                          partingCharges: controller
                                                              .partingChargesController
                                                              .text,
                                                          congestionCharges: controller
                                                              .congestionChargesController
                                                              .text,
                                                          meetGreet: controller
                                                              .meetGreetController
                                                              .text,
                                                          waitingCharges: controller
                                                              .waitingChargesController
                                                              .text,
                                                          extraDropCharges: controller
                                                              .extraDropChargesController
                                                              .text,
                                                          creditCardCharges: controller.creditCardChargesController.text,
                                                          companyPrice: controller.companyPriceController.text,
                                                          returnCompanyPrice: controller.returnCompanyPriceController.text);

                                                  controller.fixedFare.value =
                                                      storedTemFare;

                                                  if (v.journeyType == "r/n") {
                                                    controller.jourValue =
                                                        'W/R';
                                                  } else {
                                                    controller.jourValue = null;
                                                  }
                                                  controller
                                                      .selectJourneyTypeValue = v;
                                                  controller.update();
                                                },
                                              ),
                                            ),
                                          ),
                                        ),

                                        // (9) Driver dropdown
                                        if (controller.jourValue == 'W/R') ...[
                                          SizedBox(height: screenHeight * 0.01),

                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Wrap(
                                              runSpacing: 10,
                                              spacing: 16,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      AppText.pick,
                                                      style:
                                                          mozillaTextSemiBoldText(
                                                        context: context,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // (1) Pickup textfield
                                                FocusTraversalOrder(
                                                  order:
                                                      NumericFocusOrder(15),
                                                  child: SizedBox(
                                                    width: isMobile == true ||
                                                            isTablet == true
                                                        ? Get.width
                                                        : fieldWidth * 2.1,
                                                    height: 30,
                                                    child: RawKeyboardListener(
                                                      focusNode: controller
                                                          .pickupTwoWayKeyboardFocusNode,
                                                      onKey: (event) {
                                                        if (event
                                                            is RawKeyDownEvent) {
                                                          if (event.logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .arrowDown &&
                                                              controller
                                                                      .highlightedIndex
                                                                      .value <
                                                                  controller
                                                                          .suggestions
                                                                          .length -
                                                                      1) {
                                                            controller
                                                                .highlightedIndex
                                                                .value++;
                                                          } else if (event.logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .arrowUp &&
                                                              controller
                                                                      .highlightedIndex
                                                                      .value >
                                                                  0) {
                                                            controller
                                                                .highlightedIndex
                                                                .value--;
                                                          } else if (event
                                                                  .logicalKey ==
                                                              LogicalKeyboardKey
                                                                  .enter) {
                                                            final selected = controller
                                                                .suggestions[
                                                                    controller
                                                                        .highlightedIndex
                                                                        .value]
                                                                .name;
                                                            controller
                                                                .selectSuggestion(
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
                                                            FocusScope.of(Get
                                                                    .context!)
                                                                .requestFocus(
                                                                    controller
                                                                        .suggestionFocusNode);
                                                          }
                                                        }
                                                      },
                                                      child: CustomTextField(
                                                        key: controller
                                                            .pickupTwoWayFieldKey,
                                                        controller: controller
                                                            .pickupTwoWayController,
                                                        focusNode: controller
                                                            .pickupTwoTextFieldFocusNode,
                                                        hintText:
                                                            'PICKUP LOCATION',
                                                        borderRadius: 4,
                                                        width: isMobile ==
                                                                    true ||
                                                                isTablet == true
                                                            ? Get.width
                                                            : fieldWidth * 2.1,
                                                        prefixIcon: const Icon(
                                                          Icons.location_pin,
                                                          color: Colors.red,
                                                          size: 20,
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        onTap: () {
                                                          shortCutKeyValue
                                                                  .value =
                                                              "PICKUP Two Way LOCATION";
                                                        },
                                                        onChanged: (v) {
                                                          controller
                                                              .onChangeHandler(
                                                                  fieldName:
                                                                      "PICKUP TWO WAY LOCATION",
                                                                  searchingText:
                                                                      v);
                                                        },
                                                        onSubmitted: (_) =>
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus(),
                                                        suffixIcon: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            controller
                                                                    .pickupTwoWayController
                                                                    .text
                                                                    .isEmpty
                                                                ? SizedBox
                                                                    .shrink()
                                                                : KbdActivatable(
                                                                    focusNode:
                                                                        clearPicTwo,
                                                                    onActivate:
                                                                        () {
                                                                      FocusScope.of(Get
                                                                              .context!)
                                                                          .requestFocus(
                                                                              controller.pickupTwoTextFieldFocusNode);
                                                                      controller
                                                                          .markers
                                                                          .clear();
                                                                      controller
                                                                          .polyLineMarkerInfo
                                                                          .clear();
                                                                      controller
                                                                          .pickupTwoWayController
                                                                          .clear();
                                                                      controller
                                                                          .dropOffTwoWayController
                                                                          .clear();

                                                                      controller
                                                                          .polylinePoints
                                                                          .clear();
                                                                      controller
                                                                          .fetchRouteFromOSRM();
                                                                      controller
                                                                          .fixedFare
                                                                          .value = "0";
                                                                      controller
                                                                          .totalDistance
                                                                          .value = "0";
                                                                      controller
                                                                          .totalTimeDuration
                                                                          .value = "0";
                                                                      controller
                                                                          .update();

                                                                      // controller.fetchRouteFromOSRM();
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: DynamicColors
                                                                          .redClr,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                            KbdActivatable(
                                                              focusNode:
                                                                  swap1FNTwoWay,
                                                              onActivate: () {
                                                                String tempPic =
                                                                    controller
                                                                        .pickupTwoWayController
                                                                        .text;
                                                                String
                                                                    tempDrop =
                                                                    controller
                                                                        .dropOffTwoWayController
                                                                        .text;
                                                                controller
                                                                        .pickupTwoWayController
                                                                        .text =
                                                                    tempDrop;
                                                                controller
                                                                    .dropOffTwoWayController
                                                                    .text = tempPic;
                                                                controller
                                                                    .update();
                                                              },
                                                              child: const Icon(
                                                                  Icons
                                                                      .swap_vert,
                                                                  color: Color(
                                                                      0xFF575797),
                                                                  size: 20),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Select Zone
                                                Obx(
                                                  () => Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 17.0),
                                                    child: FocusTraversalOrder(
                                                      order:
                                                          const NumericFocusOrder(
                                                              16),
                                                      child:
                                                          CustomDropdownField<
                                                              location
                                                              .ZoneObject>(
                                                        label: "Select Zone",
                                                        width: fieldWidth,
                                                        height: 30,
                                                        items: _controller
                                                                    .updateRNLocationValue
                                                                    .value ==
                                                                true
                                                            ? []
                                                            : _controller
                                                                .locationtypezoneModel!
                                                                .zonesList!,
                                                        value: _controller
                                                            .RNzoneValue,
                                                        itemLabel:
                                                            (templateList) =>
                                                                templateList
                                                                    .name!,
                                                        onChanged: (val) {
                                                          _controller
                                                                  .RNzoneValue =
                                                              val;
                                                          controller
                                                                  .dashboardRNZoneValue =
                                                              val;
                                                          controller.update();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                // (3) Pickup notes
                                                FocusTraversalOrder(
                                                  order:
                                                      const NumericFocusOrder(
                                                          17),
                                                  child: SizedBox(
                                                    width: fieldWidth,
                                                    height: 30,
                                                    child: CustomTextField(
                                                      controller: controller
                                                          .pickUpNoteController,
                                                      hintText: "PICKUP NOTES",
                                                      borderRadius: 6,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onSubmitted: (_) =>
                                                          FocusScope.of(context)
                                                              .nextFocus(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Wrap(
                                              runSpacing: 10,
                                              spacing: 16,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Text(
                                                      AppText.drop,
                                                      style:
                                                          mozillaTextSemiBoldText(
                                                        context: context,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // (1) Pickup textfield
                                                // (4) Dropoff textfield
                                                FocusTraversalOrder(
                                                  order:
                                                      const NumericFocusOrder(
                                                          18),
                                                  child: SizedBox(
                                                    width: isMobile == true ||
                                                            isTablet == true
                                                        ? Get.width
                                                        : fieldWidth * 2.1,
                                                    height: 30,
                                                    child: RawKeyboardListener(
                                                      focusNode: controller
                                                          .dropOffTwoDayKeyboardFocusNode,
                                                      onKey: (event) {
                                                        if (event
                                                            is RawKeyDownEvent) {
                                                          if (event.logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .arrowDown &&
                                                              controller
                                                                      .highlightedIndex
                                                                      .value <
                                                                  controller
                                                                          .suggestions
                                                                          .length -
                                                                      1) {
                                                            controller
                                                                .highlightedIndex
                                                                .value++;
                                                          } else if (event.logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .arrowUp &&
                                                              controller
                                                                      .highlightedIndex
                                                                      .value >
                                                                  0) {
                                                            controller
                                                                .highlightedIndex
                                                                .value--;
                                                          } else if (event
                                                                  .logicalKey ==
                                                              LogicalKeyboardKey
                                                                  .enter) {
                                                            final selected = controller
                                                                .suggestions[
                                                                    controller
                                                                        .highlightedIndex
                                                                        .value]
                                                                .name;
                                                            controller
                                                                .selectSuggestion(
                                                                    selected);
                                                          } else if (event
                                                                      .logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .arrowUp ||
                                                              event.logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .arrowDown ||
                                                              event.logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .tab) {
                                                            FocusScope.of(Get
                                                                    .context!)
                                                                .requestFocus(
                                                                    controller
                                                                        .suggestionFocusNode);
                                                          }
                                                        }
                                                      },
                                                      child: CustomTextField(
                                                        key: controller
                                                            .dropOffTwoFieldKey,
                                                        controller: controller
                                                            .dropOffTwoWayController,
                                                        focusNode: controller
                                                            .dropOffTwoWayTextFieldFocusNode,
                                                        hintText:
                                                            'DROP LOCATION',
                                                        width: isMobile ==
                                                                    true ||
                                                                isTablet == true
                                                            ? Get.width
                                                            : fieldWidth * 2.1,
                                                        onTap: () {
                                                          shortCutKeyValue
                                                                  .value =
                                                              "DROP TWO WAY LOCATION";
                                                        },
                                                        borderRadius: 4,
                                                        onChanged: (v) {
                                                          controller
                                                              .onChangeHandler(
                                                                  fieldName:
                                                                      "DROP TWO WAY LOCATION",
                                                                  searchingText:
                                                                      v);
                                                        },
                                                        prefixIcon: const Icon(
                                                          Icons.location_pin,
                                                          color: Colors.red,
                                                          size: 20,
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        onSubmitted: (_) =>
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus(),
                                                        suffixIcon: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            controller
                                                                    .dropOffTwoWayController
                                                                    .text
                                                                    .isEmpty
                                                                ? SizedBox
                                                                    .shrink()
                                                                : KbdActivatable(
                                                                    focusNode:
                                                                        clearDrop,
                                                                    onActivate:
                                                                        () {
                                                                      FocusScope.of(Get
                                                                              .context!)
                                                                          .requestFocus(
                                                                              controller.dropOffTwoWayTextFieldFocusNode);

                                                                      controller
                                                                          .dropOffTwoWayController
                                                                          .clear();
                                                                      controller
                                                                          .markers
                                                                          .clear();
                                                                      controller
                                                                          .polyLineMarkerInfo
                                                                          .clear();
                                                                      controller
                                                                          .pickupController
                                                                          .clear();
                                                                      controller
                                                                          .polylinePoints
                                                                          .clear();
                                                                      controller
                                                                          .fetchRouteFromOSRM();
                                                                      controller
                                                                          .fixedFare
                                                                          .value = "0";
                                                                      controller
                                                                          .totalDistance
                                                                          .value = "0";
                                                                      controller
                                                                          .totalTimeDuration
                                                                          .value = "0";
                                                                      controller
                                                                          .update();
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: DynamicColors
                                                                          .redClr,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                            KbdActivatable(
                                                              focusNode:
                                                                  swap2FNTwoWay,
                                                              onActivate: () {
                                                                String tempPic =
                                                                    controller
                                                                        .pickupTwoWayController
                                                                        .text;
                                                                String
                                                                    tempDrop =
                                                                    controller
                                                                        .dropOffTwoWayController
                                                                        .text;
                                                                controller
                                                                        .pickupTwoWayController
                                                                        .text =
                                                                    tempDrop;
                                                                controller
                                                                    .dropOffTwoWayController
                                                                    .text = tempPic;
                                                                controller
                                                                    .update();
                                                              },
                                                              child: const Icon(
                                                                  Icons
                                                                      .swap_vert,
                                                                  color: Color(
                                                                      0xFF575797),
                                                                  size: 20),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 17.0),
                                                    child: FocusTraversalOrder(
                                                      order:
                                                          const NumericFocusOrder(
                                                              19),
                                                      child:
                                                          CustomDropdownField<
                                                              location
                                                              .ZoneObject>(
                                                        label: "Select Zone",
                                                        width: fieldWidth,
                                                        height: 30,
                                                        items: _controller
                                                                    .updateRN1LocationValue
                                                                    .value ==
                                                                true
                                                            ? []
                                                            : _controller
                                                                .locationtypezoneModel!
                                                                .zonesList!,
                                                        value: _controller
                                                            .RN1zoneValue,
                                                        itemLabel:
                                                            (templateList) =>
                                                                templateList
                                                                    .name!,
                                                        onChanged: (val) {
                                                          _controller
                                                                  .RN1zoneValue =
                                                              val;
                                                          controller
                                                                  .dashboardRN1ZoneValue =
                                                              val;
                                                          controller.update();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                // (3) Pickup notes
                                                FocusTraversalOrder(
                                                  order:
                                                      const NumericFocusOrder(
                                                          20),
                                                  child: SizedBox(
                                                    width: fieldWidth,
                                                    height: 30,
                                                    child: CustomTextField(
                                                      controller: controller
                                                          .dropUpNoteController,
                                                      hintText: "DROP NOTES",
                                                      borderRadius: 6,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onSubmitted: (_) =>
                                                          FocusScope.of(context)
                                                              .nextFocus(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          FocusTraversalOrder(
                                            order: const NumericFocusOrder(21),
                                            child: labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              label: "R/${AppText.date}",
                                              width: fieldWidth,
                                              child: SizedBox(
                                                  height: 30,
                                                  child: KeyboardDatePicker(
                                                    initialDate: controller
                                                            .pickUpDateReturn ??
                                                        DateTime.now(),
                                                    borderClr: Colors.blue,
                                                    onChanged: (date) {
                                                      controller
                                                              .pickUpDateReturn =
                                                          date;
                                                      controller.update();
                                                    },
                                                    onSubmitted: (date) {
                                                      // jab user enter press kare
                                                      print(
                                                          "User pressed enter: $date");
                                                    },
                                                  )),
                                            ),
                                          ),
                                          // (6) Time
                                          FocusTraversalOrder(
                                            order: const NumericFocusOrder(22),
                                            child: labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              label: "R/${AppText.time}",
                                              width: fieldWidth,
                                              child: SizedBox(
                                                  height: 30,
                                                  child: CustomTimePicker(
                                                    controller: controller
                                                        .pickUpTimeControllerReturn, // optional
                                                    onTimeSelected: (time) {
                                                      controller
                                                          .pickUpTimeControllerReturn
                                                          .text = time;
                                                      setState(() {});
                                                    },
                                                  )),
                                            ),
                                          ),
                                          // (7) Lead (mins)
                                          FocusTraversalOrder(
                                            order: const NumericFocusOrder(23),
                                            child: labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              label: "R/${AppText.lead}",
                                              width: fieldWidth,
                                              child: SizedBox(
                                                height: 30,
                                                child: CustomTextField(
                                                  hintText: "MINS",
                                                  controller: controller
                                                      .minControllerReturn,
                                                  borderRadius: 4,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onSubmitted: (_) =>
                                                      FocusScope.of(context)
                                                          .nextFocus(),
                                                ),
                                              ),
                                            ),
                                          ),

                                          FocusTraversalOrder(
                                            order: const NumericFocusOrder(24),
                                            child: SizedBox(
                                              width: fieldWidth,
                                              // height: 50 ,
                                              // width: fieldWidth/6,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  RawKeyboardListener(
                                                    focusNode:
                                                        checkboxFocusReturn,
                                                    onKey: (event) {
                                                      if (event
                                                              is RawKeyDownEvent &&
                                                          (event.logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .enter ||
                                                              event.logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .space)) {
                                                        setState(() {
                                                          // controller.smsCheckbox.value = !controller.smsCheckbox.value; // ✅ toggle
                                                        });
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 55),
                                                      child: Checkbox(
                                                        activeColor:
                                                            DynamicColors
                                                                .primaryClr,
                                                        value: controller
                                                            .addReturnFare
                                                            .value,
                                                        onChanged: (v) {
                                                          // controller.smsCheckbox.value = v!;
                                                          // controller.update();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "ADD RETURN FARE",
                                                    style:
                                                        mozillaTextSemiBoldText(
                                                            context: context,
                                                            fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          FocusTraversalOrder(
                                            order: const NumericFocusOrder(25),
                                            child: labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              label: "R/${AppText.fare}",
                                              width: fieldWidth,
                                              child: SizedBox(
                                                height: 30,
                                                child: CustomTextField(
                                                  hintText: "Slugg",
                                                  controller: controller
                                                      .slugControllerReturn,
                                                  borderRadius: 6,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        6),
                                                  ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onSubmitted: (_) =>
                                                      FocusScope.of(context)
                                                          .nextFocus(),
                                                ),
                                              ),
                                            ),
                                          ),

                                          FocusTraversalOrder(
                                            order: const NumericFocusOrder(26),
                                            child: labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              label: "R/${AppText.veh} ",
                                              width: fieldWidth,
                                              heights: 32,
                                              child: Container(
                                                // height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: DynamicColors
                                                          .primaryClr,
                                                      width: 1.2),
                                                ),
                                                child: DropdownButtonFormField<
                                                    DashboardVehicleTypeObject>(
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                  ),
                                                  value: controller
                                                      .selectVehicleValueReturn,
                                                  items: controller
                                                      .dashboardAllData!
                                                      .vehicleTypes!
                                                      .map((vehicle) =>
                                                          DropdownMenuItem<
                                                              DashboardVehicleTypeObject>(
                                                            value: vehicle,
                                                            child: Text(
                                                              vehicle.name ??
                                                                  "",
                                                              style:
                                                                  mozillaTextRegularText(
                                                                fontSize: 12,
                                                                color:
                                                                    DynamicColors
                                                                        .textClr,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  onChanged: (v) async {
                                                    controller
                                                        .selectVehicleValueReturn = v;

                                                    final fare =
                                                        await getActiveFareForVehicle(
                                                      controller
                                                          .dashboardAllData!
                                                          .fareConfigurations!,
                                                      controller
                                                          .selectVehicleValue!
                                                          .id!,
                                                    );
                                                    if (fare != null) {
                                                      print(
                                                        'Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}',
                                                      );

                                                      double inttt = (double
                                                              .parse(controller
                                                                  .totalDistance
                                                                  .value) -
                                                          double.parse(fare
                                                              .minimumMiles
                                                              .toString()));

                                                      controller.fixedFare
                                                          .value = (inttt *
                                                              double.parse(fare
                                                                  .minimumFares
                                                                  .toString()))
                                                          .toString();
                                                    } else {
                                                      print(
                                                          'No active fare found for this vehicle');
                                                    }
                                                    controller.update();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),

                                          FocusTraversalOrder(
                                            order: const NumericFocusOrder(27),
                                            child: labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              label: "R/${AppText.drv} ",
                                              width: fieldWidth,
                                              heights: 32,
                                              child: Container(
                                                // height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: DynamicColors
                                                          .primaryClr,
                                                      width: 1.2),
                                                ),
                                                child: DropdownButtonFormField<
                                                    DashboardDriverObject>(
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                  ),
                                                  value: controller
                                                      .selectDriverValueReturn,
                                                  items: controller
                                                      .dashboardAllData ==null?[]: controller
                                                      .dashboardAllData!
                                                      .drivers!
                                                      .map((driver) =>
                                                          DropdownMenuItem<
                                                              DashboardDriverObject>(
                                                            value: driver,
                                                            child: Text(
                                                              driver.name ?? "",
                                                              style:
                                                                  mozillaTextRegularText(
                                                                fontSize: 12,
                                                                color:
                                                                    DynamicColors
                                                                        .textClr,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  onChanged: (v) {
                                                    controller
                                                        .selectDriverValueReturn = v;
                                                    controller.update();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],

                                        // (10) Fare (Slugg)
                                        FocusTraversalOrder(
                                          order: NumericFocusOrder(
                                              controller.jourValue == 'W/R'
                                                  ? 28
                                                  : 15),
                                          child: labeledField(
                                            context: context,
                                            isMobile: isMobile,
                                            label: AppText.fare,
                                            column: isMobile == true ||
                                                    isTablet == true
                                                ? true
                                                : false,
                                            width: fieldWidth,
                                            child: SizedBox(
                                              height: 35,
                                              child: CustomTextField(
                                                hintText: "Slugg",
                                                controller:
                                                    controller.slugController,
                                                borderRadius: 6,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      6),
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onSubmitted: (_) =>
                                                    FocusScope.of(context)
                                                        .nextFocus(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // (11) Account
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          child: FocusTraversalOrder(
                                            order: NumericFocusOrder(
                                                controller.jourValue == 'W/R'
                                                    ? 29
                                                    : 16),
                                            child: labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                              label: "${AppText.acc}",
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              width: fieldWidth,
                                              heights: 32,
                                              child: Container(
                                                // height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: DynamicColors
                                                          .primaryClr,
                                                      width: 1.2),
                                                ),
                                                child: DropdownButtonFormField<
                                                    DashboardAccountObject>(
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                  ),
                                                  value: controller
                                                      .selectAccountValue,
                                                  items: controller
                                                              .dashboardAccountData ==
                                                          null
                                                      ? []
                                                      : controller
                                                          .dashboardAccountData!
                                                          .accounts!
                                                          .map((account) =>
                                                              DropdownMenuItem<
                                                                  DashboardAccountObject>(
                                                                value: account,
                                                                child: Text(
                                                                  account.name ??
                                                                      "",
                                                                  style:
                                                                      mozillaTextRegularText(
                                                                    fontSize:
                                                                        12,
                                                                    color: DynamicColors
                                                                        .textClr,
                                                                  ),
                                                                ),
                                                              ))
                                                          .toList(),
                                                  onChanged: (v) {
                                                    controller
                                                        .selectAccountValue = v;
                                                    controller
                                                            .selectDepartmentData =
                                                        null;
                                                    controller.update();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // (12) Pay dropdown
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: controller.jourValue == 'W/R'
                                                  ? 30
                                                  : 17),
                                          child: FocusTraversalOrder(
                                            order: NumericFocusOrder(
                                                controller.jourValue == 'W/R'
                                                    ? 36
                                                    : 23),
                                            child: labeledField(
                                              context: context,
                                              isMobile: isMobile,
                                              label: AppText.pay,
                                              column: isMobile == true ||
                                                      isTablet == true
                                                  ? true
                                                  : false,
                                              width: fieldWidth,
                                              heights: 32,
                                              child: Container(
                                                // height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: DynamicColors
                                                          .primaryClr,
                                                      width: 1.2),
                                                ),
                                                child: DropdownButtonFormField<
                                                    PaymentTypeObject>(
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                  ),
                                                  value: controller
                                                      .selectPaymentTypeValue,
                                                  items: controller
                                                      .dashboardAllData!
                                                      .paymentTypes!
                                                      .map((payment) =>
                                                          DropdownMenuItem<
                                                              PaymentTypeObject>(
                                                            value: payment,
                                                            child: Text(
                                                              payment.name ??
                                                                  "",
                                                              style:
                                                                  mozillaTextRegularText(
                                                                fontSize: 12,
                                                                color:
                                                                    DynamicColors
                                                                        .textClr,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  onChanged: (v) {
                                                    controller
                                                        .selectPaymentTypeValue = v;
                                                    controller.update();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // (12) Pay dropdown
                                        FocusTraversalOrder(
                                          order: NumericFocusOrder(
                                              controller.jourValue == 'W/R'
                                                  ? 31
                                                  : 18),
                                          child: labeledField(
                                            context: context,
                                            isMobile: isMobile,
                                            label: AppText.veh,
                                            column: isMobile == true ||
                                                    isTablet == true
                                                ? true
                                                : false,
                                            width: fieldWidth,
                                            heights: 32,
                                            child: Container(
                                              // height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: DynamicColors
                                                        .primaryClr,
                                                    width: 1.2),
                                              ),
                                              child: DropdownButtonFormField<
                                                  DashboardVehicleTypeObject>(
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                value: controller
                                                    .selectVehicleValue,
                                                items: controller
                                                    .dashboardAllData!
                                                    .vehicleTypes!
                                                    .map((vehicle) =>
                                                        DropdownMenuItem<
                                                            DashboardVehicleTypeObject>(
                                                          value: vehicle,
                                                          child: Text(
                                                            vehicle.name ?? "",
                                                            style:
                                                                mozillaTextRegularText(
                                                              fontSize: 12,
                                                              color:
                                                                  DynamicColors
                                                                      .textClr,
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                                onChanged: (v) async {
                                                  controller
                                                      .selectVehicleValue = v;
                                                  final storedTemFare = await getFares(
                                                      journeyTypeId: controller
                                                          .selectJourneyTypeValue!.id,
                                                      multiReservationList: controller
                                                          .multiReservationList,
                                                      dropOff: controller
                                                          .pickupController
                                                          .text,
                                                      pickup: controller
                                                          .dropOffController.text,
                                                      miles: controller
                                                          .totalDistance.value,
                                                      dropoffPlotId: controller
                                                                  .dashboardZoneValue !=
                                                              null
                                                          ? controller
                                                              .dashboardZoneValue!
                                                              .id
                                                          : null,
                                                      pickupDate:
                                                          "${controller.pickUpDate!.year}-${controller.pickUpDate!.month}-${controller.pickUpDate!.day}",
                                                      pickupTime: controller
                                                          .pickUpTimeController
                                                          .text,
                                                      vehicleTypeId: controller
                                                          .selectVehicleValue!
                                                          .id);
                                                  controller.fixedFare.value =
                                                      storedTemFare;

                                                  // final fare =
                                                  // await getActiveFareForVehicle(
                                                  //   controller.dashboardAllData!.fareConfigurations!,
                                                  //   controller.selectVehicleValue!.id!,
                                                  // );
                                                  // if (fare !=
                                                  //     null) {
                                                  //   print(
                                                  //     'Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}',
                                                  //   );
                                                  //
                                                  //   double
                                                  //   inttt =
                                                  //   (double.parse(controller.totalDistance.value) - double.parse(fare.minimumMiles.toString()));
                                                  //
                                                  //   controller.fixedFare.value =
                                                  //       (inttt * double.parse(fare.minimumFares.toString())).toString();
                                                  // } else {
                                                  //   print('No active fare found for this vehicle');
                                                  // }
                                                  controller.update();
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        controller.selectAccountValue == null
                                            ? SizedBox.shrink()
                                            : FocusTraversalOrder(
                                                order: NumericFocusOrder(
                                                    controller.jourValue == 'W/R'
                                                        ? 32
                                                        : 19),
                                                child: labeledField(
                                                  context: context,
                                                  isMobile: isMobile,
                                                  column: isMobile == true ||
                                                          isTablet == true
                                                      ? true
                                                      : false,
                                                  label: "DEPT",
                                                  width: fieldWidth,
                                                  heights: 35,
                                                  child: Container(
                                                    // height: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          color: DynamicColors
                                                              .primaryClr,
                                                          width: 1.2),
                                                    ),
                                                    child:
                                                        DropdownButtonFormField<
                                                            DepartmentObject>(
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        isDense: true,
                                                      ),
                                                      value: controller
                                                          .selectDepartmentData,
                                                      items: controller
                                                                  .selectAccountValue ==
                                                              null
                                                          ? []
                                                          : controller
                                                              .selectAccountValue!
                                                              .departments!
                                                              .map((department) =>
                                                                  DropdownMenuItem<
                                                                      DepartmentObject>(
                                                                    value:
                                                                        department,
                                                                    child: Text(
                                                                      department
                                                                              .name ??
                                                                          "",
                                                                      style:
                                                                          mozillaTextRegularText(
                                                                        fontSize:
                                                                            12,
                                                                        color: DynamicColors
                                                                            .textClr,
                                                                      ),
                                                                    ),
                                                                  ))
                                                              .toList(),
                                                      onChanged: (v) {
                                                        controller
                                                            .selectDepartmentData = v;
                                                        controller.update();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        // Switch + Quotation
                                        FocusTraversalOrder(
                                          order: NumericFocusOrder(
                                              controller.jourValue == 'W/R'
                                                  ? 33
                                                  : 20),
                                          child: DynamicSwitch(
                                            controller:
                                                controller.switchController,
                                            activeColor:
                                                DynamicColors.primaryClr,
                                            inactiveColor: DynamicColors.gryClr,
                                            focusScale: 1.5,
                                            onToggle: () {
                                              print(
                                                  "Switch toggled: ${controller.switchController.value}");
                                            },
                                          ),
                                        ),

                                        Text(
                                          AppText.quotation,
                                          style: mozillaTextSemiBoldText(
                                              context: context, fontSize: 13),
                                        ),

                                        // SMS Checkbox
                                        FocusTraversalOrder(
                                          order: NumericFocusOrder(
                                              controller.jourValue == 'W/R'
                                                  ? 34
                                                  : 21),
                                          child: SizedBox(
                                            // width: fieldWidth/6,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RawKeyboardListener(
                                                  focusNode: checkboxFocus,
                                                  onKey: (event) {
                                                    if (event
                                                            is RawKeyDownEvent &&
                                                        (event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .enter ||
                                                            event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .space)) {
                                                      setState(() {
                                                        // controller.smsCheckbox.value = !controller.smsCheckbox.value; // ✅ toggle
                                                      });
                                                    }
                                                  },
                                                  child: Checkbox(
                                                    activeColor: DynamicColors
                                                        .primaryClr,
                                                    value: controller
                                                        .smsCheckbox.value,
                                                    onChanged: (v) {
                                                      // controller.smsCheckbox.value = v!;
                                                      // controller.update();
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  AppText.sms,
                                                  style:
                                                      mozillaTextSemiBoldText(
                                                          context: context,
                                                          fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Email Checkbox
                                        FocusTraversalOrder(
                                          order: NumericFocusOrder(
                                              controller.jourValue == 'W/R'
                                                  ? 35
                                                  : 22),
                                          child: SizedBox(
                                            // width: fieldWidth/5,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RawKeyboardListener(
                                                  focusNode: emailFocus,
                                                  onKey: (event) {
                                                    if (event
                                                            is RawKeyDownEvent &&
                                                        (event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .enter ||
                                                            event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .space)) {
                                                      setState(() {
                                                        controller.emailCheckbox
                                                                .value =
                                                            !controller
                                                                .emailCheckbox
                                                                .value; // ✅ toggle
                                                      });
                                                    }
                                                  },
                                                  child: Checkbox(
                                                    activeColor: DynamicColors
                                                        .primaryClr,
                                                    value: controller
                                                        .emailCheckbox.value,
                                                    onChanged: (v) {
                                                      controller.emailCheckbox
                                                          .value = v!;
                                                      controller.update();
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  AppText.email,
                                                  style:
                                                      mozillaTextSemiBoldText(
                                                          context: context,
                                                          fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Pass, Lugg, Slugg fields
                                        SizedBox(
                                          // width: fieldWidth/2.0,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FocusTraversalOrder(
                                                order: NumericFocusOrder(
                                                    controller.jourValue == 'W/R'
                                                        ? 36
                                                        : 23),
                                                child: SizedBox(
                                                  width: 60,
                                                  height: 30,
                                                  child: CustomTextField(
                                                    hintText: "Pass",
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          2),
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                    controller: controller
                                                        .passController,
                                                    borderRadius: 4,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              FocusTraversalOrder(
                                                order: NumericFocusOrder(
                                                    controller.jourValue == 'W/R'
                                                        ? 37
                                                        : 24),
                                                child: SizedBox(
                                                  width: 60,
                                                  height: 30,
                                                  child: CustomTextField(
                                                    hintText: "Lugg",
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          2),
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                    controller: controller
                                                        .luggController,
                                                    borderRadius: 4,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              FocusTraversalOrder(
                                                order: NumericFocusOrder(
                                                    controller.jourValue == 'W/R'
                                                        ? 38
                                                        : 25),
                                                child: SizedBox(
                                                  width: 60,
                                                  height: 30,
                                                  child: CustomTextField(
                                                    hintText: "Slugg",
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          2),
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                    controller: controller
                                                        .sluggController,
                                                    borderRadius: 4,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // 3 icons row  (person) (shopping_cart) (doller)
                                        FocusTraversalGroup(
                                          policy: OrderedTraversalPolicy(),
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                buildFocusableIcon(
                                                  icon: Icons.person,
                                                  focusNode: _focusNodes[0],
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            RestrictDriversAlert());
                                                  },
                                                ),
                                                buildFocusableIcon(
                                                  icon: Icons
                                                      .shopping_cart_checkout_outlined,
                                                  focusNode: _focusNodes[1],
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          ChildSeatsAlert(),
                                                    );
                                                  },
                                                ),
                                                buildFocusableIcon(
                                                  icon: Icons.attach_money,
                                                  focusNode: _focusNodes[2],
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          ExtraFaresAlert(),
                                                    );
                                                  },
                                                ),
                                                buildFocusableIcon(
                                                  icon: Icons.note_add_sharp,
                                                  focusNode: _focusNodes[3],
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          ExtraInfoAlert(),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // (13) Calendar icon (keyboard clickable)
                                        FocusTraversalOrder(
                                          order: NumericFocusOrder(controller.jourValue == 'W/R'
                                              ? 39
                                              : 26),
                                          child: SizedBox(
                                            height: 33,
                                            child: KbdActivatable(
                                              focusNode: calendarFN,
                                              onActivate: () {
                                                // TODO: open your calendar modal/sheet
                                                // For demo:
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Calendar icon activated")),
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Icon(
                                                    Icons.calculate,
                                                    size: 25),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  width: Get.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      color: DynamicColors.secondaryClr),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 16,
                                    children: [
                                      SizedBox(width: 20),
                                      Icon(Icons.access_time_filled_outlined,
                                          color: DynamicColors.textClr,
                                          size: 18),
                                      SizedBox(width: 2),
                                      Text("ETA : ${controller.totalTimeDuration}",
                                          style: TextStyle(
                                              color: DynamicColors.textClr,
                                              fontSize: 13)),
                                      SizedBox(width: 20),
                                      Icon(Icons.access_time_filled_outlined,
                                          color: DynamicColors.textClr,
                                          size: 18),
                                      SizedBox(width: 2),
                                      Text("JOURNEY : 0.0 mins",
                                          style: TextStyle(
                                              color: DynamicColors.textClr,
                                              fontSize: 13)),
                                      SizedBox(width: 20),
                                      Icon(Icons.location_on,
                                          color: DynamicColors.textClr,
                                          size: 18),
                                      SizedBox(width: 2),
                                      Text("DISTANCE : ${controller.totalDistance}",
                                          style: TextStyle(
                                              color: DynamicColors.textClr,
                                              fontSize: 13)),
                                      SizedBox(width: 20),
                                      Container(
                                        width: fieldWidth / 3.5,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "PR: \$ ${(double.parse(controller.fixedFare.value) + 5).toStringAsFixed(1)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  width: Get.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      color: DynamicColors.secondaryClr),
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 16,
                                    children: [
                                      SizedBox(width: 20),
                                      // FocusTraversalOrder(
                                      //   order: NumericFocusOrder(
                                      //       controller.jourValue == 'W/R'
                                      //           ? 40
                                      //           : 27
                                      //   ),
                                      //   child: labeledField(
                                      //     context: context,
                                      //     isMobile: isMobile,
                                      //     label: AppText.driver,
                                      //     width: fieldWidth / 2.3,
                                      //     child: Container(
                                      //       height: 30,
                                      //       decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(4),
                                      //         border: Border.all(
                                      //             color:
                                      //                 DynamicColors.primaryClr),
                                      //       ),
                                      //       child: RestrictedDrivers(
                                      //         width: fieldWidth / 2.3,
                                      //         height: 30,
                                      //         padding: 0.0,
                                      //         titleText:
                                      //             controller.selectedDriver,
                                      //         driversList: [
                                      //           "Driver 01",
                                      //           "Driver 02",
                                      //           "Driver 03",
                                      //           "Driver 04"
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap: (){
                                          if(controller.pickupController.text.isNotEmpty && controller.dropOffController.text.isNotEmpty){
                                            DashboardF8Alert.show();
                                          }
                                        },
                                        child: Container(
                                          // margin: EdgeInsets.symmetric(
                                          //     horizontal: 16, vertical: 3),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: controller.isHoveredF8.value == true? Colors.cyanAccent.shade400:Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '+ MULTI RESERVATION [F8]',
                                            style: TextStyle(
                                              color: DynamicColors.primaryClr,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: (){
                                          if(controller.pickupController.text.isNotEmpty && controller.dropOffController.text.isNotEmpty)
                                          {
                                            DashboardF9Alert.show();
                                          }
                                        },
                                        child: Container(
                                          // margin: EdgeInsets.symmetric(
                                          //     horizontal: 16, vertical: 3),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: controller.isHoveredF9.value == true? Colors.cyanAccent.shade400: Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '+ VEHICLES [F9]',
                                            style: TextStyle(
                                              color: DynamicColors.primaryClr,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      CustomButton(
                                        btnText: "CLEAR [F7]",
                                        width: 110,
                                        height: 30,
                                        fontSize: 11,
                                        btnColor: DynamicColors.redClr,
                                        verticalPadding: 0.0,
                                        borderRadius: 4,
                                        onTap: (){
                                          controller.refreshPostAllFields();
                                        },
                                      ),
                                      CustomButton(
                                        onTap:
                                            () {
                                          if(controller.jourValue == 'W/R' && controller.pickupTwoWayController.text.isEmpty &&
                                              controller.dropOffTwoWayController.text.isEmpty){
                                            BotToast.showText(text: "Please chose waiting return");
                                            return;
                                          }
                                          controller
                                              .dashBoardApiValidation();
                                        },
                                        btnText: "SAVE[HOME]",
                                        width: 110,
                                        height: 30,
                                        fontSize: 11,
                                        verticalPadding: 0.0,
                                        borderRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height / 2.1,
                                  child: MapViewWidget(
                                    createBooking: true,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Obx(() {
                            if (controller.selectedTextFieldsValue.value ==
                                "via") {
                              return SizedBox();
                            }
                            if (controller.selectedTextFieldsValue.value ==
                                "Phone Number") {
                              return SuggestionView(
                                allListData: controller
                                    .customerPhoneNumber!.customerInfo!,
                                topPositions:
                                    MediaQuery.of(context).size.height * 0.125,
                                leftPositions: Get.width / 3.3,
                                onSelect: (value) {
                                  controller.suggestionPhoneFocusNode.value
                                      .unfocus();
                                  controller.selectedTextFieldsValue.value = "";
                                  FocusScope.of(Get.context!).requestFocus(
                                      controller.phoneKeyboardFocusNode);
                                  controller.mobileController.text = value
                                      .mobile
                                      .toString(); // <-- store anywhere
                                  controller.nameController.text =
                                      value.name.toString();
                                },
                              );
                            }
                            if (controller.allAddressesData.isEmpty) {
                              return const SizedBox();
                            }
                            final GlobalKey<State<StatefulWidget>>? activeKey =
                                controller.activeFieldKey.value;
                            final RenderBox? fieldBox =
                                activeKey?.currentContext?.findRenderObject()
                                    as RenderBox?;
                            final RenderBox? stackBox = controller
                                .stackKey.currentContext
                                ?.findRenderObject() as RenderBox?;

                            double top = 0.0;
                            double left = 0.0;
                            double width = screenWidth;

                            if (fieldBox != null && stackBox != null) {
                              final Offset localOffset = fieldBox.localToGlobal(
                                  Offset.zero,
                                  ancestor: stackBox);
                              final double fieldHeight = fieldBox.size.height;
                              width = fieldBox.size.width;
                              top = localOffset.dy + fieldHeight;
                              left = localOffset.dx;
                            }

                            // ensure RawKeyboardListener gets focus when suggestions appear
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (controller.allAddressesData.isNotEmpty &&
                                  !controller.suggestionFocusNode.hasFocus) {
                                // FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                // FocusScope.of(context).requestFocus(controller.pickupTextFieldFocusNode);
                              }
                            });

                            return Positioned(
                              top: top,
                              left: left,
                              width: fieldWidth * 2.1,
                              // width: fieldWidth,
                              child: RawKeyboardListener(
                                focusNode: controller.suggestionFocusNode,
                                autofocus: true,
                                onKey: (RawKeyEvent event) {
                                  if (event is RawKeyDownEvent) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowDown) {
                                      controller.moveHighlightDown();
                                      return;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowUp) {
                                      controller.moveHighlightUp();
                                      return;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.enter) {
                                      controller.tapSelect(controller
                                          .suggestionSelectedIndex.value);
                                      print("enter press");
                                    }
                                    // Enter intentionally ignored so it does not select anything
                                  }
                                },
                                child: Container(
                                  height: screenHeight * 0.3,
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
                                        controller: controller
                                            .suggestionScrollController,
                                        itemCount:
                                            controller.allAddressesData.length,
                                        padding: EdgeInsets.only(top: 15),
                                        itemBuilder: (context, index) {
                                          final item = controller
                                              .allAddressesData[index];
                                          final isHighlighted = controller
                                                  .highlightedIndex.value ==
                                              index;

                                          print(
                                              "controller.highlightedIndex.value");
                                          print(controller
                                              .highlightedIndex.value);
                                          print(index);
                                          print(
                                              "controller.highlightedIndex.value");

                                          return Obx(
                                            () {
                                              final isHighlighted = controller
                                                      .highlightedIndex.value ==
                                                  index;
                                              return Container(
                                                key: controller
                                                    .suggestionItemKeys[index],
                                                color: isHighlighted
                                                    ? const Color(0xffA0DCFF)
                                                    : Colors.transparent,
                                                child: ListTile(
                                                  dense: true,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  // Animated text style so color/weight changes step-by-step
                                                  title:
                                                      AnimatedDefaultTextStyle(
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
                                                  onTap: () => controller
                                                      .tapSelect(index),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )),
                                ),
                              ),
                            );
                          }),
                        ]),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildMenuTab(IconData icon, String label, String menuKey,
      List<String> items, GlobalKey key) {
    return GestureDetector(
      key: key,
      onTap: () async {
        setState(() {
          selectedMenu = menuKey;
        });

        final RenderBox renderBox =
            key.currentContext!.findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final Size size = renderBox.size;

        final selected = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            offset.dx,
            offset.dy + size.height,
            offset.dx + size.width,
            offset.dy,
          ),
          items: items
              .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          elevation: 8.0,
        );

        if (selected != null) {
          setState(() {
            selectedDropdownItem = selected;
          });
          // if (onMenuSelect != null) {
          //   onMenuSelect!(selected);
          // }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          // color: selectedMenu == menuKey
          //     ? Colors.cyanAccent.shade400
          //     : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: DynamicColors.textClr,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFields(
      BuildContext context, isMobile, isTablet, fieldWidth) {
    return [
      Padding(
        padding: const EdgeInsets.only(
            right: 16.0, bottom: 8.0), // Added bottom padding for Column layout
        child: Text(
          AppText.mobile,
          style: mozillaTextSemiBoldText(context: context, fontSize: 13),
        ),
      ),
      FocusTraversalOrder(
        order: const NumericFocusOrder(9),
        child: RawKeyboardListener(
          focusNode: controller.phoneKeyboardFocusNode,
          onKey: (event) {
            if (event is RawKeyDownEvent) {
              final listLength = suggestion_controller.allListData.length;
              final currentIndex = suggestion_controller.highlightedIndex.value;

              if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                  currentIndex < listLength - 1) {
                suggestion_controller.highlightedIndex.value++;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                  currentIndex > 0) {
                suggestion_controller.highlightedIndex.value--;
              } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                final selected =
                    suggestion_controller.allListData[currentIndex].name;
                suggestion_controller.selectSuggestion(selected);
              } else if (event.logicalKey == LogicalKeyboardKey.tab) {
                FocusScope.of(Get.context!)
                    .requestFocus(controller.suggestionPhoneFocusNode.value);
                controller.update();
              }
            }
          },
          child: CustomTextField(
            focusNode: controller.phoneNumberFieldKey,
            controller: controller.mobileController,
            borderRadius: 3,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) {
              if (v.isNotEmpty) {
                // Note: Avoid requesting focus inside onChanged if the field is already focused
                controller.onPhoneNoChangeHandler(
                    fieldName: "Phone Number", searchingText: v);
              }
            },
            // Adjust width logic: 100% width on mobile, partial on Row
            width: (isMobile || isTablet) ? fieldWidth : fieldWidth / 1.3,
          ),
        ),
      ),
    ];
  }
}
