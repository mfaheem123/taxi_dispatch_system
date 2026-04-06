import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/shortcut_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../alert/child_seats_alert.dart';
import '../../../alert/extra_fares_alert.dart';
import '../../../alert/extra_info_alert.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/dropdown_button.dart' show CustomDropdownField;
import '../../../component/suggestion_widget/suggestion_controller.dart';
import '../../../component/suggestion_widget/suggestion_view.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../../component/time_duration_method.dart';
import '../../cli_Screen.dart';
import '../../locations_view/Model/location_types_zoneModel.dart';
import '../../locations_view/controller/locations_controller.dart';
import '../Controller/dashboard_controller.dart';
import '../booking_table.dart';
import '../models/account_darshboard_model.dart';
import '../models/dashboard_model.dart';
import '../widgets/fare_configuration.dart';
import '../widgets/pickup_widget.dart';
import '../widgets/quotation_widget.dart';
import '../widgets/time_picker_widget.dart';
import '../widgets/user_info_widget.dart' hide KbdActivatable;
import 'F8_widget_alert.dart';
import 'F9_widget_alert.dart';
import 'booking_form_widget.dart';
import 'custom_booking_widget/custom_deshboard_ipad_widget.dart';
import 'drivers.dart';
import 'form_short_cut_key.dart';
import 'map_view_widget.dart';
import 'package:flutter/material.dart' as material;

class ByDefaultDashboard extends StatefulWidget {
  ByDefaultDashboard({
    super.key,
    this.onTap,
  });

  final GestureTapCallback? onTap;

  @override
  State<ByDefaultDashboard> createState() => _ByDefaultDashboardState();
}

class _ByDefaultDashboardState extends State<ByDefaultDashboard> {
  FocusNode _focusNode = FocusNode();
  final FocusNode swap1FN = FocusNode();
  final FocusNode swap1FNTwoWay = FocusNode();
  final FocusNode clearPic = FocusNode();
  final FocusNode clearPicTwo = FocusNode();
  final FocusNode clearDrop = FocusNode();
  final FocusNode swap2FN = FocusNode();
  final FocusNode swap2FNTwoWay = FocusNode();
  final FocusNode calendarFN = FocusNode();
  final FocusNode checkboxFocus = FocusNode();
  final FocusNode checkboxFocusReturn = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final List<FocusNode> _focusNodes =
      List.generate(4, (index) => FocusNode()); // 4 icons

  Timer? _debounce;

  DashboardController controller =  Get.find();
  final LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  SuggestionController suggestion_controller =
      Get.isRegistered<SuggestionController>()
          ? Get.find<SuggestionController>()
          : Get.put(SuggestionController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (controller.dashboardAllData == null) {
      controller.dashboardData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<DashboardController>(initState: (v) {

      controller.seeZoneOnMapp();
      // controller.getMobileNumberWithName();
      if (_controller.locationtypezoneModel == null) {
        _controller.getLocationTypeZone();
      }
    }, builder: (controller) {
      return controller.dashboardDataLoader.value
          ? material.Center(child: CircularProgressIndicator())
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

              return RawKeyboardListener(
                focusNode: _focusNode,
                autofocus: true,
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent) {
                    final key = event.logicalKey;
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      return;
                    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      return;
                    } else if (event.logicalKey.keyLabel == "F8") {
                      if (controller.pickupController.text.isNotEmpty &&
                          controller.dropOffController.text.isNotEmpty) {
                        DashboardF8Alert.show();
                      }
                      return;
                    } else if (event.logicalKey.keyLabel == "F9") {
                      if (controller.pickupController.text.isNotEmpty &&
                          controller.dropOffController.text.isNotEmpty) {
                        DashboardF9Alert.show();
                      }
                      return;
                    }
                  }
                },
                child: _controller.getLocationTypeZoneLoader.value == true
                    ? SizedBox.shrink()
                    : SingleChildScrollView(
                        physics: controller.allAddressesData.isNotEmpty
                            ? const NeverScrollableScrollPhysics() // 👈 disable scrolling
                            : const BouncingScrollPhysics(), // 👈 enable normal scrolling
                        child: Column(
                          children: [
                            Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                  color: DynamicColors.secondaryClr),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Wrap(
                                  spacing: 10, // horizontal gap
                                  runSpacing: 8, // vertical gap when wrapped
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ShortcutKeyWidget(),
                                        ShortcutKeyWidget(
                                            keyss: "F2",
                                            valuess: "BOOKING FORM"),
                                        ShortcutKeyWidget(
                                            keyss: "F3",
                                            valuess: "DRIVER VEHICLE"),
                                        ShortcutKeyWidget(
                                            keyss: "F4",
                                            valuess: "DRIVER EARNING"),
                                        ShortcutKeyWidget(
                                            keyss: "F6", valuess: "QUOTATION"),
                                        width >= 1900
                                            ? Spacer()
                                            : SizedBox.shrink(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: CustomButton(
                                            width: 120,
                                            height: 35,
                                            borderRadius: 6,
                                            verticalPadding: 0,
                                            style: mozillaTextSemiBoldText(
                                                fontSize: 11,
                                                color: DynamicColors.whiteClr),
                                            onTap: () {
                                              controller.hideDashBoard.value =
                                                  !controller
                                                      .hideDashBoard.value;
                                              controller.update();
                                            },
                                            btnText:
                                                controller.hideDashBoard.value
                                                    ? "HIDE DASHBOARD"
                                                    : "SHOW DASHBOARD",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            width <= 1024
                                ? CustomIpadWidget()
                                : Stack(
                                    key: controller.stackKey,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 6, right: 6),
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible: controller
                                                  .hideDashBoard.value,
                                              child: SingleChildScrollView(
                                                physics: controller
                                                        .allAddressesData
                                                        .isNotEmpty
                                                    ? const NeverScrollableScrollPhysics() // 👈 disable scrolling
                                                    : const BouncingScrollPhysics(),
                                                // 👈 enable normal scrolling
                                                // scrollDirection: Axis.horizontal,
                                                child: width >= 1270
                                                    ? Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          FocusTraversalGroup(
                                                            policy:
                                                                OrderedTraversalPolicy(),
                                                            child: SizedBox(
                                                              width:
                                                                  Get.width / 2,
                                                              child: Column(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      FormShortCutKey(),
                                                                      SizedBox(
                                                                        height: screenHeight *
                                                                            0.018,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                12.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 10),
                                                                              child: Text(
                                                                                AppText.pick,
                                                                                style: mozillaTextSemiBoldText(
                                                                                  context: context,
                                                                                  fontSize: 13,
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            // (1) Pickup textfield
                                                                            FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(1),
                                                                              child: SizedBox(
                                                                                width: fieldWidth / 1.2,
                                                                                height: 30,
                                                                                child: RawKeyboardListener(
                                                                                  focusNode: controller.pickupKeyboardFocusNode,
                                                                                  onKey: (event) {
                                                                                    if (event is RawKeyDownEvent) {
                                                                                      if (event.logicalKey == LogicalKeyboardKey.arrowDown && controller.highlightedIndex.value < controller.suggestions.length - 1) {
                                                                                        controller.highlightedIndex.value++;
                                                                                      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && controller.highlightedIndex.value > 0) {
                                                                                        controller.highlightedIndex.value--;
                                                                                      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                                                                        final selected = controller.suggestions[controller.highlightedIndex.value].name;
                                                                                        controller.selectSuggestion(selected);
                                                                                      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp
                                                                                          || event.logicalKey == LogicalKeyboardKey.tab
                                                                                      ) {
                                                                                        FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                                                                      }
                                                                                      // }else if(event.logicalKey == LogicalKeyboardKey.tab){
                                                                                      //   FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                                                                      // }
                                                                                    }
                                                                                  },
                                                                                  child: CustomTextField(
                                                                                    key: controller.pickupFieldKey,
                                                                                    controller: controller.pickupController,
                                                                                    focusNode: controller.pickupTextFieldFocusNode,
                                                                                    hintText: 'PICKUP LOCATION',
                                                                                    borderRadius: 4,
                                                                                    prefixIcon: const Icon(
                                                                                      Icons.location_pin,
                                                                                      color: Colors.red,
                                                                                      size: 20,
                                                                                    ),
                                                                                    textInputAction: TextInputAction.next,
                                                                                    onTap: () {
                                                                                      shortCutKeyValue.value = "PICKUP LOCATION";
                                                                                    },
                                                                                    onChanged: (v) {
                                                                                      controller.onChangeHandler(fieldName: "PICKUP LOCATION", searchingText: v);
                                                                                    },
                                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                    suffixIcon: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        controller.pickupController.text.isEmpty
                                                                                            ? SizedBox.shrink()
                                                                                            : KbdActivatable(
                                                                                                focusNode: clearPic,
                                                                                                onActivate: () {
                                                                                                  int index = controller.markers.indexWhere((test) => test.type == "pickup");
                                                                                                  // int indexx = controller.polyLineMarkerInfo.indexWhere(((element) => element.markerType == "PICKUP LOCATION"));
                                                                                                  // controller.polyLineMarkerInfo.remove(controller.polyLineMarkerInfo[indexx]);
                                                                                                  // controller.markers.remove(controller.markers[index]);
                                                                                                  FocusScope.of(Get.context!).requestFocus(controller.pickupTextFieldFocusNode);
                                                                                                  controller.markers.clear();
                                                                                                  controller.polyLineMarkerInfo.clear();
                                                                                                  controller.pickupController.clear();
                                                                                                  controller.dropOffController.clear();
                                                                                                  controller.polylinePoints.clear();
                                                                                                  controller.fetchRouteFromOSRM();
                                                                                                  controller.fixedFare.value = "0";
                                                                                                  controller.totalDistance.value = "0";
                                                                                                  controller.totalTimeDuration.value = "0";
                                                                                                  controller.update();

                                                                                                  // controller.fetchRouteFromOSRM();
                                                                                                },
                                                                                                child: Icon(
                                                                                                  Icons.close,
                                                                                                  color: DynamicColors.redClr,
                                                                                                  size: 15,
                                                                                                ),
                                                                                              ),
                                                                                        KbdActivatable(
                                                                                          focusNode: swap1FN,
                                                                                          onActivate: () {
                                                                                            String tempPic = controller.pickupController.text;
                                                                                            String tempDrop = controller.dropOffController.text;
                                                                                            controller.pickupController.text = tempDrop;
                                                                                            controller.dropOffController.text = tempPic;
                                                                                            controller.update();
                                                                                          },
                                                                                          child: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 20),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            // Select Zone on pick Up location line
                                                                            Obx(
                                                                              () => Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                                                child: FocusTraversalOrder(
                                                                                  order: const NumericFocusOrder(2),
                                                                                  child: CustomDropdownField<ZoneObject>(
                                                                                    label: "Select Zone",
                                                                                    width: Get.width / 7,
                                                                                    height: 30,
                                                                                    items: _controller.updateLocationValue.value == true ? [] : _controller.locationtypezoneModel!.zonesList!,
                                                                                    value: _controller.zoneValue,
                                                                                    itemLabel: (templateList) => templateList.name!,
                                                                                    onChanged: (val) {
                                                                                      _controller.zoneValue = val;
                                                                                      controller.dashboardZoneValue = val;
                                                                                      controller.update();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            // (3) Pickup notes
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 15),
                                                                              child: FocusTraversalOrder(
                                                                                order: const NumericFocusOrder(3),
                                                                                child: SizedBox(
                                                                                  width: fieldWidth / 3,
                                                                                  height: 30,
                                                                                  child: CustomTextField(
                                                                                    controller: controller.pickUpNoteController,
                                                                                    hintText: "PICKUP NOTES",
                                                                                    borderRadius: 6,
                                                                                    textInputAction: TextInputAction.next,
                                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),


                                                                      // ================= Airport ROW ========================================================
                                                                      Visibility(
                                                                        visible: controller.isAirportResponse.value,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 12,
                                                                          vertical: 10
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 10),
                                                                                child: Text(
                                                                                  "FL",
                                                                                  style: mozillaTextSemiBoldText(
                                                                                    context: context,
                                                                                    fontSize: 13,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 15),
                                                                                child: FocusTraversalOrder(
                                                                                  order: const NumericFocusOrder(4),
                                                                                  child: SizedBox(
                                                                                    width: fieldWidth / 0.70,
                                                                                    height: 30,
                                                                                    child: CustomTextField(
                                                                                      controller: controller.selectAirportController,
                                                                                      hintText: "Flight Number",
                                                                                      borderRadius: 6,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 10, left: 5),
                                                                                child: Text(
                                                                                  "ARR",
                                                                                  style: mozillaTextSemiBoldText(
                                                                                    context: context,
                                                                                    fontSize: 13,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 0),
                                                                                child: FocusTraversalOrder(
                                                                                  order: const NumericFocusOrder(5),
                                                                                  child: SizedBox(
                                                                                    width: fieldWidth / 3.1,
                                                                                    height: 30,
                                                                                    child: CustomTextField(
                                                                                      controller: controller.arrivalTimeController,
                                                                                      hintText: "ARR",
                                                                                      borderRadius: 6,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                            ],
                                                                          ),
                                                                        ),

                                                                      ),



                                                                      // ================= DROPOFF ROW =================
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                10.0, vertical: 12.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 8),
                                                                              child: Text(
                                                                                AppText.drop,
                                                                                style: mozillaTextSemiBoldText(
                                                                                  context: context,
                                                                                  fontSize: 13,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            // (1) Pickup textfield

                                                                            // (4) Dropoff textfield
                                                                            FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(6),
                                                                              child: SizedBox(
                                                                                width: fieldWidth / 1.2,
                                                                                height: 30,
                                                                                child: RawKeyboardListener(
                                                                                  focusNode: controller.dropOffKeyboardFocusNode,
                                                                                  onKey: (event) {
                                                                                    if (event is RawKeyDownEvent) {
                                                                                      if (event.logicalKey == LogicalKeyboardKey.arrowDown && controller.highlightedIndex.value < controller.suggestions.length - 1) {
                                                                                        controller.highlightedIndex.value++;
                                                                                      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && controller.highlightedIndex.value > 0) {
                                                                                        controller.highlightedIndex.value--;
                                                                                      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                                                                        final selected = controller.suggestions[controller.highlightedIndex.value].name;
                                                                                        controller.selectSuggestion(selected);
                                                                                      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.tab) {
                                                                                        FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  child: CustomTextField(
                                                                                    key: controller.dropOffFieldKey,
                                                                                    controller: controller.dropOffController,
                                                                                    focusNode: controller.dropOffTextFieldFocusNode,
                                                                                    hintText: 'DROP LOCATION',
                                                                                    onTap: () {
                                                                                      shortCutKeyValue.value = "DROP LOCATION";
                                                                                    },
                                                                                    borderRadius: 4,
                                                                                    onChanged: (v) {
                                                                                      controller.onChangeHandler(fieldName: "DROP LOCATION", searchingText: v);
                                                                                    },
                                                                                    prefixIcon: const Icon(
                                                                                      Icons.location_pin,
                                                                                      color: Colors.red,
                                                                                      size: 20,
                                                                                    ),
                                                                                    textInputAction: TextInputAction.next,
                                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                    suffixIcon: Row(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        controller.dropOffController.text.isEmpty
                                                                                            ? SizedBox.shrink()
                                                                                            : KbdActivatable(
                                                                                                focusNode: clearDrop,
                                                                                                onActivate: () {
                                                                                                  // int index = controller.markers.indexWhere((test) => test.type == "dropOff");
                                                                                                  // int indexx = controller.polyLineMarkerInfo.indexWhere(((element) => element.markerType == "DROP LOCATION"));
                                                                                                  // controller.polyLineMarkerInfo.remove(controller.polyLineMarkerInfo[indexx]);
                                                                                                  // controller.markers.remove(controller.markers[index]);
                                                                                                  FocusScope.of(Get.context!).requestFocus(controller.dropOffTextFieldFocusNode);
                                                                                                  controller.dropOffController.clear();
                                                                                                  controller.markers.clear();
                                                                                                  controller.polyLineMarkerInfo.clear();
                                                                                                  controller.pickupController.clear();
                                                                                                  controller.polylinePoints.clear();
                                                                                                  controller.fetchRouteFromOSRM();
                                                                                                  controller.fixedFare.value = "0";
                                                                                                  controller.totalDistance.value = "0";
                                                                                                  controller.totalTimeDuration.value = "0";
                                                                                                  controller.update();
                                                                                                },
                                                                                                child: Icon(
                                                                                                  Icons.close,
                                                                                                  color: DynamicColors.redClr,
                                                                                                  size: 15,
                                                                                                ),
                                                                                              ),
                                                                                        KbdActivatable(
                                                                                          focusNode: swap2FN,
                                                                                          onActivate: () {
                                                                                            String tempPic = controller.pickupController.text;
                                                                                            String tempDrop = controller.dropOffController.text;
                                                                                            controller.pickupController.text = tempDrop;
                                                                                            controller.dropOffController.text = tempPic;
                                                                                            controller.update();
                                                                                          },
                                                                                          child: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 20),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            Obx(
                                                                              () => Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                                                child: FocusTraversalOrder(
                                                                                  order: const NumericFocusOrder(7),
                                                                                  child: CustomDropdownField<ZoneObject>(
                                                                                    label: "Select Zone",
                                                                                    width: Get.width / 7,
                                                                                    height: 30,
                                                                                    items: _controller.updateDLocationValue.value == true ? [] : _controller.locationtypezoneModel!.zonesList!,
                                                                                    value: _controller.zoneDValue,
                                                                                    itemLabel: (templateList) => templateList.name!,
                                                                                    onChanged: (val) {
                                                                                      _controller.zoneDValue = val;
                                                                                      controller.dashboardDZoneValue = val;
                                                                                      controller.update();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            // (3) Pickup notes
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 15),
                                                                              child: FocusTraversalOrder(
                                                                                order: const NumericFocusOrder(8),
                                                                                child: SizedBox(
                                                                                  width: fieldWidth / 3,
                                                                                  height: 30,
                                                                                  child: CustomTextField(
                                                                                    controller: controller.dropUpNoteController,
                                                                                    hintText: "DROP NOTES",
                                                                                    borderRadius: 6,
                                                                                    textInputAction: TextInputAction.next,
                                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  ///todo pickup fields widget
                                                                  // Fields Row / Column Responsive
                                                                  /*PickupWidget(),*/

                                                                  ///todo pickup fields widget
                                                                  SizedBox(
                                                                    height:
                                                                        screenHeight *
                                                                            0.01,
                                                                  ),

                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              6),
                                                                      child:
                                                                          Wrap(
                                                                        spacing:
                                                                            10,
                                                                        runSpacing:
                                                                            6,
                                                                        runAlignment:
                                                                            WrapAlignment.start,
                                                                        crossAxisAlignment:
                                                                            WrapCrossAlignment.center,
                                                                        alignment:
                                                                            WrapAlignment.start,
                                                                        children: [
                                                                          // Name Fields
                                                                          FocusTraversalOrder(
                                                                            order:
                                                                                const NumericFocusOrder(9),
                                                                            child: labeledTextField(
                                                                                context,
                                                                                isMobile,
                                                                                AppText.name,
                                                                                controller.nameController,
                                                                                width: fieldWidth / 3,
                                                                                textInputAction: TextInputAction.next),
                                                                          ),
                                                                          // Email Fields
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 0),
                                                                            child:
                                                                                FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(10),
                                                                              child: labeledTextField(context, isMobile, AppText.email, controller.emailController, width: fieldWidth / 2.8, textInputAction: TextInputAction.next),
                                                                            ),
                                                                          ),
                                                                          // MOB fields
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 22),
                                                                            child:
                                                                                SizedBox(
                                                                              width: fieldWidth / 2.1,
                                                                              child: Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(
                                                                                      right: 22.0,
                                                                                    ),
                                                                                    child: Text(AppText.mobile, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                                                                  ),
                                                                                  FocusTraversalOrder(
                                                                                    order: const NumericFocusOrder(11),
                                                                                    child: RawKeyboardListener(
                                                                                        focusNode: controller.phoneKeyboardFocusNode,
                                                                                        onKey: (event) {
                                                                                          if (event is RawKeyDownEvent) {
                                                                                            if (event.logicalKey == LogicalKeyboardKey.arrowDown && suggestion_controller.highlightedIndex.value < suggestion_controller.allListData.length - 1) {
                                                                                              suggestion_controller.highlightedIndex.value++;
                                                                                            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && suggestion_controller.highlightedIndex.value > 0) {
                                                                                              suggestion_controller.highlightedIndex.value--;
                                                                                            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                                                                              final selected = suggestion_controller.allListData[suggestion_controller.highlightedIndex.value].name;
                                                                                              suggestion_controller.selectSuggestion(selected);
                                                                                            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.tab) {
                                                                                              FocusScope.of(Get.context!).requestFocus(controller.suggestionPhoneFocusNode.value);
                                                                                              FocusScope.of(Get.context!).requestFocus(controller.suggestionPhoneFocusNode.value);
                                                                                              controller.update();
                                                                                              // FocusScope.of(Get.context!).requestFocus(suggestion_controller.suggestionFocusNode.value);
                                                                                            }
                                                                                          }
                                                                                        },
                                                                                        child: CustomTextField(
                                                                                          focusNode: controller.phoneNumberFieldKey,
                                                                                          controller: controller.mobileController,
                                                                                          // hintText: AppText.mobile,
                                                                                          borderRadius: 3,
                                                                                          inputFormatters: [
                                                                                            FilteringTextInputFormatter.digitsOnly
                                                                                          ],
                                                                                          onChanged: (v) {
                                                                                            if (v.isNotEmpty) {
                                                                                              FocusScope.of(Get.context!).requestFocus(controller.phoneNumberFieldKey);
                                                                                              controller.onPhoneNoChangeHandler(fieldName: "Phone Number", searchingText: v);
                                                                                            }
                                                                                          },
                                                                                          width: fieldWidth / 2.9,
                                                                                        )),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // Tel fileds
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 4),
                                                                            child:
                                                                                FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(12),
                                                                              child: labeledTextField(context, isMobile, AppText.tel, controller.telController, width: fieldWidth / 3, textInputAction: TextInputAction.next, keyboardType: TextInputType.phone, formatDigitsOnly: false),
                                                                            ),
                                                                          ),
                                                                          // date fileds
                                                                          FocusTraversalOrder(
                                                                            order:
                                                                                const NumericFocusOrder(13),
                                                                            child:
                                                                                labeledField(
                                                                              context: context,
                                                                              isMobile: isMobile,
                                                                              label: AppText.date,
                                                                              width: fieldWidth / 3,
                                                                              child: SizedBox(
                                                                                  height: 30,
                                                                                  child: KeyboardDatePicker(
                                                                                    initialDate: controller.pickUpDate ?? DateTime.now(),
                                                                                    borderClr: Colors.blue,
                                                                                    onChanged: (date) async {
                                                                                      controller.pickUpDate = date;
                                                                                      controller.getFaresCalculation();
                                                                                    },
                                                                                    onSubmitted: (date) {
                                                                                      // jab user enter press kare
                                                                                      print("User pressed enter: $date");
                                                                                    },
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                          // (6) Time
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 4),
                                                                            child:
                                                                                FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(14),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: AppText.time,
                                                                                width: fieldWidth / 2.8,
                                                                                child: SizedBox(
                                                                                    height: 30,
                                                                                    child: CustomTimePicker(
                                                                                      controller: controller.pickUpTimeController,
                                                                                      // optional
                                                                                      onTimeSelected: (time) async {
                                                                                        controller.pickUpTimeController.text = time;
                                                                                        controller.getFaresCalculation();
                                                                                        setState(() {
                                                                                          print(controller.pickUpTimeController.text);
                                                                                        });
                                                                                      },
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // (7) Lead (mins)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 28),
                                                                            child:
                                                                                FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(15),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: AppText.lead,
                                                                                width: fieldWidth / 2.9,
                                                                                child: SizedBox(
                                                                                  height: 30,
                                                                                  child: CustomTextField(
                                                                                    hintText: "MINS",
                                                                                    controller: controller.minController,
                                                                                    borderRadius: 4,
                                                                                    inputFormatters: [
                                                                                      FilteringTextInputFormatter.digitsOnly
                                                                                    ],
                                                                                    keyboardType: TextInputType.number,
                                                                                    textInputAction: TextInputAction.next,
                                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          // (8) Journey dropdown (O/W, R/N, W/R)
                                                                          FocusTraversalOrder(
                                                                            order:
                                                                                const NumericFocusOrder(16),
                                                                            child:
                                                                                labeledField(
                                                                              context: context,
                                                                              isMobile: isMobile,
                                                                              label: AppText.jour,
                                                                              width: fieldWidth / 2.95,
                                                                              heights: 33,
                                                                              child: Container(
                                                                                // height: 35,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(6),
                                                                                  border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                                ),
                                                                                child: DropdownButtonFormField<JourneyTypeObject>(
                                                                                  decoration: const InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    isDense: true,
                                                                                  ),
                                                                                  value: controller.selectJourneyTypeValue,
                                                                                  items: controller.dashboardAllData!.journeyTypes!
                                                                                      .map((journey) => DropdownMenuItem<JourneyTypeObject>(
                                                                                            value: journey,
                                                                                            child: Text(
                                                                                              journey.journeyType ?? "",
                                                                                              style: mozillaTextRegularText(
                                                                                                fontSize: 12,
                                                                                                color: DynamicColors.textClr,
                                                                                              ),
                                                                                            ),
                                                                                          ))
                                                                                      .toList(),
                                                                                  onChanged: (v) {
                                                                                    if (v!.journeyType == "r/n") {
                                                                                      controller.jourValue = 'W/R';
                                                                                    } else {
                                                                                      controller.jourValue = null;
                                                                                    }
                                                                                    controller.selectJourneyTypeValue = v;
                                                                                    controller.getFaresCalculation();
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          // (9) Driver dropdown
                                                                          if (controller.jourValue ==
                                                                              'W/R') ...[
                                                                            SizedBox(
                                                                              height: screenHeight * 0.01,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(right: 15),
                                                                                      child: Text(
                                                                                        AppText.pick,
                                                                                        style: mozillaTextSemiBoldText(
                                                                                          context: context,
                                                                                          fontSize: 13,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  // (1) Pickup textfield
                                                                                  FocusTraversalOrder(
                                                                                    order: const NumericFocusOrder(17),
                                                                                    child: SizedBox(
                                                                                      width: fieldWidth / 1.2,
                                                                                      height: 30,
                                                                                      child: RawKeyboardListener(
                                                                                        focusNode: controller.pickupTwoWayKeyboardFocusNode,
                                                                                        onKey: (event) {
                                                                                          if (event is RawKeyDownEvent) {
                                                                                            if (event.logicalKey == LogicalKeyboardKey.arrowDown && controller.highlightedIndex.value < controller.suggestions.length - 1) {
                                                                                              controller.highlightedIndex.value++;
                                                                                            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && controller.highlightedIndex.value > 0) {
                                                                                              controller.highlightedIndex.value--;
                                                                                            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                                                                              final selected = controller.suggestions[controller.highlightedIndex.value].name;
                                                                                              controller.selectSuggestion(selected);
                                                                                            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.tab) {
                                                                                              FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                                                                            }
                                                                                          }
                                                                                        },
                                                                                        child: CustomTextField(
                                                                                          key: controller.pickupTwoWayFieldKey,
                                                                                          controller: controller.pickupTwoWayController,
                                                                                          focusNode: controller.pickupTwoTextFieldFocusNode,
                                                                                          hintText: 'PICKUP LOCATION',
                                                                                          borderRadius: 4,
                                                                                          prefixIcon: const Icon(
                                                                                            Icons.location_pin,
                                                                                            color: Colors.red,
                                                                                            size: 20,
                                                                                          ),
                                                                                          textInputAction: TextInputAction.next,
                                                                                          onTap: () {
                                                                                            shortCutKeyValue.value = "PICKUP Two Way LOCATION";
                                                                                          },
                                                                                          onChanged: (v) {
                                                                                            controller.onChangeHandler(fieldName: "PICKUP TWO WAY LOCATION", searchingText: v);
                                                                                          },
                                                                                          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                          suffixIcon: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              controller.pickupTwoWayController.text.isEmpty
                                                                                                  ? SizedBox.shrink()
                                                                                                  : KbdActivatable(
                                                                                                      focusNode: clearPicTwo,
                                                                                                      onActivate: () {
                                                                                                        FocusScope.of(Get.context!).requestFocus(controller.pickupTwoTextFieldFocusNode);
                                                                                                        controller.markers.clear();
                                                                                                        controller.polyLineMarkerInfo.clear();
                                                                                                        controller.pickupTwoWayController.clear();
                                                                                                        controller.dropOffTwoWayController.clear();
                                                                                                        controller.pickupController.clear();
                                                                                                        controller.dropOffController.clear();
                                                                                                        controller.polylinePoints.clear();
                                                                                                        controller.fetchRouteFromOSRM();
                                                                                                        controller.fixedFare.value = "0";
                                                                                                        controller.totalDistance.value = "0";
                                                                                                        controller.totalTimeDuration.value = "0";
                                                                                                        controller.update();

                                                                                                        // controller.fetchRouteFromOSRM();
                                                                                                      },
                                                                                                      child: Icon(
                                                                                                        Icons.close,
                                                                                                        color: DynamicColors.redClr,
                                                                                                        size: 15,
                                                                                                      ),
                                                                                                    ),
                                                                                              KbdActivatable(
                                                                                                focusNode: swap1FNTwoWay,
                                                                                                onActivate: () {
                                                                                                  String tempPic = controller.pickupTwoWayController.text;
                                                                                                  String tempDrop = controller.dropOffTwoWayController.text;
                                                                                                  controller.pickupTwoWayController.text = tempDrop;
                                                                                                  controller.dropOffTwoWayController.text = tempPic;
                                                                                                  controller.update();
                                                                                                },
                                                                                                child: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 20),
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
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 17.0),
                                                                                      child: FocusTraversalOrder(
                                                                                        order: const NumericFocusOrder(18),
                                                                                        child: CustomDropdownField<ZoneObject>(
                                                                                          label: "Select Zone",
                                                                                          width: Get.width / 7,
                                                                                          height: 30,
                                                                                          items: _controller.updateRNLocationValue.value == true ? [] : _controller.locationtypezoneModel!.zonesList!,
                                                                                          value: _controller.RNzoneValue,
                                                                                          itemLabel: (templateList) => templateList.name!,
                                                                                          onChanged: (val) {
                                                                                            _controller.RNzoneValue = val;
                                                                                            controller.dashboardRNZoneValue = val;
                                                                                            controller.update();
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 12),
                                                                                  // (3) Pickup notes
                                                                                  FocusTraversalOrder(
                                                                                    order: const NumericFocusOrder(19),
                                                                                    child: SizedBox(
                                                                                      width: fieldWidth / 3,
                                                                                      height: 30,
                                                                                      child: CustomTextField(
                                                                                        controller: controller.pickUpNoteController,
                                                                                        hintText: "PICKUP NOTES",
                                                                                        borderRadius: 6,
                                                                                        textInputAction: TextInputAction.next,
                                                                                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(right: 10),
                                                                                      child: Text(
                                                                                        AppText.drop,
                                                                                        style: mozillaTextSemiBoldText(
                                                                                          context: context,
                                                                                          fontSize: 13,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  // (1) Pickup textfield
                                                                                  // (4) Dropoff textfield
                                                                                  FocusTraversalOrder(
                                                                                    order: const NumericFocusOrder(20),
                                                                                    child: SizedBox(
                                                                                      width: fieldWidth / 1.2,
                                                                                      height: 30,
                                                                                      child: RawKeyboardListener(
                                                                                        focusNode: controller.dropOffTwoDayKeyboardFocusNode,
                                                                                        onKey: (event) {
                                                                                          if (event is RawKeyDownEvent) {
                                                                                            if (event.logicalKey == LogicalKeyboardKey.arrowDown && controller.highlightedIndex.value < controller.suggestions.length - 1) {
                                                                                              controller.highlightedIndex.value++;
                                                                                            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && controller.highlightedIndex.value > 0) {
                                                                                              controller.highlightedIndex.value--;
                                                                                            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                                                                              final selected = controller.suggestions[controller.highlightedIndex.value].name;
                                                                                              controller.selectSuggestion(selected);
                                                                                            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.tab) {
                                                                                              FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                                                                            }
                                                                                          }
                                                                                        },
                                                                                        child: CustomTextField(
                                                                                          key: controller.dropOffTwoFieldKey,
                                                                                          controller: controller.dropOffTwoWayController,
                                                                                          focusNode: controller.dropOffTwoWayTextFieldFocusNode,
                                                                                          hintText: 'DROP LOCATION',
                                                                                          onTap: () {
                                                                                            shortCutKeyValue.value = "DROP TWO WAY LOCATION";
                                                                                          },
                                                                                          borderRadius: 4,
                                                                                          onChanged: (v) {
                                                                                            controller.onChangeHandler(fieldName: "DROP TWO WAY LOCATION", searchingText: v);
                                                                                          },
                                                                                          prefixIcon: const Icon(
                                                                                            Icons.location_pin,
                                                                                            color: Colors.red,
                                                                                            size: 20,
                                                                                          ),
                                                                                          textInputAction: TextInputAction.next,
                                                                                          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                          suffixIcon: Row(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              controller.dropOffTwoWayController.text.isEmpty
                                                                                                  ? SizedBox.shrink()
                                                                                                  : KbdActivatable(
                                                                                                      focusNode: clearDrop,
                                                                                                      onActivate: () {
                                                                                                        FocusScope.of(Get.context!).requestFocus(controller.dropOffTwoWayTextFieldFocusNode);
                                                                                                        controller.pickupController.clear();
                                                                                                        controller.dropOffController.clear();
                                                                                                        controller.dropOffTwoWayController.clear();
                                                                                                        controller.markers.clear();
                                                                                                        controller.polyLineMarkerInfo.clear();
                                                                                                        controller.pickupController.clear();
                                                                                                        controller.polylinePoints.clear();
                                                                                                        controller.pickupTwoWayController.clear();
                                                                                                        controller.fetchRouteFromOSRM();
                                                                                                        controller.fixedFare.value = "0";
                                                                                                        controller.totalDistance.value = "0";
                                                                                                        controller.totalTimeDuration.value = "0";
                                                                                                        controller.update();
                                                                                                      },
                                                                                                      child: Icon(
                                                                                                        Icons.close,
                                                                                                        color: DynamicColors.redClr,
                                                                                                        size: 15,
                                                                                                      ),
                                                                                                    ),
                                                                                              KbdActivatable(
                                                                                                focusNode: swap2FNTwoWay,
                                                                                                onActivate: () {
                                                                                                  String tempPic = controller.pickupTwoWayController.text;
                                                                                                  String tempDrop = controller.dropOffTwoWayController.text;
                                                                                                  controller.pickupTwoWayController.text = tempDrop;
                                                                                                  controller.dropOffTwoWayController.text = tempPic;
                                                                                                  controller.update();
                                                                                                },
                                                                                                child: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 20),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Obx(
                                                                                    () => Padding(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 17.0),
                                                                                      child: FocusTraversalOrder(
                                                                                        order: const NumericFocusOrder(21),
                                                                                        child: CustomDropdownField<ZoneObject>(
                                                                                          label: "Select Zone",
                                                                                          width: Get.width / 7,
                                                                                          height: 30,
                                                                                          items: _controller.updateRN1LocationValue.value == true ? [] : _controller.locationtypezoneModel!.zonesList!,
                                                                                          value: _controller.RN1zoneValue,
                                                                                          itemLabel: (templateList) => templateList.name!,
                                                                                          onChanged: (val) {
                                                                                            _controller.RN1zoneValue = val;
                                                                                            controller.dashboardRN1ZoneValue = val;
                                                                                            controller.update();
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 15),
                                                                                  // (3) Pickup notes
                                                                                  FocusTraversalOrder(
                                                                                    order: const NumericFocusOrder(22),
                                                                                    child: SizedBox(
                                                                                      width: fieldWidth / 3,
                                                                                      height: 30,
                                                                                      child: CustomTextField(
                                                                                        controller: controller.dropUpNoteController,
                                                                                        hintText: "DROP NOTES",
                                                                                        borderRadius: 6,
                                                                                        textInputAction: TextInputAction.next,
                                                                                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(23),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: "R/${AppText.date}",
                                                                                width: fieldWidth / 3,
                                                                                child: SizedBox(
                                                                                    height: 30,
                                                                                    child: KeyboardDatePicker(
                                                                                      initialDate: controller.pickUpDateReturn ?? DateTime.now(),
                                                                                      borderClr: Colors.blue,
                                                                                      onChanged: (date) {
                                                                                        controller.pickUpDateReturn = date;
                                                                                        controller.getFaresCalculation();
                                                                                        controller.update();
                                                                                      },
                                                                                      onSubmitted: (date) {
                                                                                        // jab user enter press kare
                                                                                        print("User pressed enter: $date");
                                                                                      },
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            // (6) Time
                                                                            FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(24),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: "R/${AppText.time}",
                                                                                width: fieldWidth / 3.1,
                                                                                child: SizedBox(
                                                                                    height: 30,
                                                                                    child: CustomTimePicker(
                                                                                      controller: controller.pickUpTimeControllerReturn,
                                                                                      // optional
                                                                                      onTimeSelected: (time) {

                                                                                        controller.pickUpTimeControllerReturn.text = time;
                                                                                        controller.getFaresCalculation();
                                                                                        setState(() {});
                                                                                      },
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            // (7) Lead (mins)
                                                                            FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(25),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: "R/${AppText.lead}",
                                                                                width: fieldWidth / 3,
                                                                                child: SizedBox(
                                                                                  height: 30,
                                                                                  child: CustomTextField(
                                                                                    hintText: "MINS",
                                                                                    controller: controller.minControllerReturn,
                                                                                    borderRadius: 4,
                                                                                    inputFormatters: [
                                                                                      FilteringTextInputFormatter.digitsOnly
                                                                                    ],
                                                                                    keyboardType: TextInputType.number,
                                                                                    textInputAction: TextInputAction.next,
                                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(26),
                                                                              child: SizedBox(
                                                                                width: fieldWidth / 2,
                                                                                // height: 50 ,
                                                                                // width: fieldWidth/6,
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    RawKeyboardListener(
                                                                                      focusNode: checkboxFocusReturn,
                                                                                      onKey: (event) {
                                                                                        if (event is RawKeyDownEvent && (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.space)) {
                                                                                          setState(() {
                                                                                            // controller.smsCheckbox.value = !controller.smsCheckbox.value; // ✅ toggle
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 55),
                                                                                        child: Checkbox(
                                                                                          activeColor: DynamicColors.primaryClr,
                                                                                          value: controller.addReturnFare.value,
                                                                                          onChanged: (v) {
                                                                                            // controller.smsCheckbox.value = v!;
                                                                                            // controller.update();
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      "ADD RETURN FARE",
                                                                                      style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(27),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: "R/${AppText.fare}",
                                                                                width: fieldWidth / 3,
                                                                                child: SizedBox(
                                                                                  height: 30,
                                                                                  child: CustomTextField(
                                                                                    hintText: "Slugg",
                                                                                    controller: controller.slugControllerReturn,
                                                                                    readOnly: true,
                                                                                    borderRadius: 6,
                                                                                    inputFormatters: [
                                                                                      FilteringTextInputFormatter.digitsOnly,
                                                                                      LengthLimitingTextInputFormatter(6),
                                                                                    ],
                                                                                    keyboardType: TextInputType.number,
                                                                                    textInputAction: TextInputAction.next,
                                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(28),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: "R/${AppText.veh} ",
                                                                                width: fieldWidth / 3,
                                                                                heights: 32,
                                                                                child: Container(
                                                                                  // height: 35,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(6),
                                                                                    border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                                  ),
                                                                                  child: DropdownButtonFormField<DashboardVehicleTypeObject>(
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(),
                                                                                      isDense: true,
                                                                                    ),
                                                                                    value: controller.selectVehicleValueReturn,
                                                                                    items: controller.dashboardAllData!.vehicleTypes!
                                                                                        .map((vehicle) => DropdownMenuItem<DashboardVehicleTypeObject>(
                                                                                              value: vehicle,
                                                                                              child: Text(
                                                                                                vehicle.name ?? "",
                                                                                                style: mozillaTextRegularText(
                                                                                                  fontSize: 12,
                                                                                                  color: DynamicColors.textClr,
                                                                                                ),
                                                                                              ),
                                                                                            ))
                                                                                        .toList(),
                                                                                    onChanged: (v) async {
                                                                                      controller.selectVehicleValueReturn = v;

                                                                                      final fare = await getActiveFareForVehicle(
                                                                                        controller.dashboardAllData!.fareConfigurations!,
                                                                                        controller.selectVehicleValue!.id!,
                                                                                      );
                                                                                      if (fare != null) {
                                                                                        print(
                                                                                          'Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}',
                                                                                        );

                                                                                        double inttt = (double.parse(controller.totalDistance.value) - double.parse(fare.minimumMiles.toString()));

                                                                                        controller.fixedFare.value = (inttt * double.parse(fare.minimumFares.toString())).toString();
                                                                                      } else {
                                                                                        print('No active fare found for this vehicle');
                                                                                      }
                                                                                      controller.update();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            FocusTraversalOrder(
                                                                              order: const NumericFocusOrder(29),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: "R/${AppText.drv} ",
                                                                                width: fieldWidth / 3,
                                                                                heights: 32,
                                                                                child: Container(
                                                                                  // height: 35,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(6),
                                                                                    border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                                  ),
                                                                                  child: DropdownButtonFormField<DashboardDriverObject>(
                                                                                    focusNode: controller.driverDropdownFocusNode,
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(),
                                                                                      isDense: true,
                                                                                    ),
                                                                                    value: controller.selectDriverValueReturn,
                                                                                    items: controller.dashboardAllData!.drivers!
                                                                                        .map((driver) => DropdownMenuItem<DashboardDriverObject>(
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
                                                                                      controller.selectDriverValueReturn = v;
                                                                                      controller.update();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          // (10) Fare (Slugg)
                                                                          SizedBox(
                                                                              width: 8),
                                                                          FocusTraversalOrder(
                                                                            order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                                                ? 34
                                                                                : 30),
                                                                            child:
                                                                                labeledField(
                                                                              context: context,
                                                                              isMobile: isMobile,
                                                                              label: AppText.fare,
                                                                              width: fieldWidth / 3,
                                                                              child: SizedBox(
                                                                                height: 35,
                                                                                child: CustomTextField(
                                                                                  hintText: "Fare",
                                                                                  controller: controller.slugController,
                                                                                  borderRadius: 6,
                                                                                  inputFormatters: [
                                                                                    FilteringTextInputFormatter.digitsOnly,
                                                                                    LengthLimitingTextInputFormatter(6),
                                                                                  ],
                                                                                  keyboardType: TextInputType.number,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          // (11) Account
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 2),
                                                                            child:
                                                                                FocusTraversalOrder(
                                                                              order: NumericFocusOrder(controller.jourValue == 'W/R' ? 35 : 31),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: "${AppText.acc}  ",
                                                                                width: fieldWidth / 2.8,
                                                                                heights: 32,
                                                                                child: Container(
                                                                                  // height: 35,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(6),
                                                                                    border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                                  ),
                                                                                  child: DropdownButtonFormField<DashboardAccountObject>(
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(),
                                                                                      isDense: true,
                                                                                    ),
                                                                                    value: controller.selectAccountValue,
                                                                                    items: controller.dashboardAccountData == null
                                                                                        ? []
                                                                                        : controller.dashboardAccountData!.accounts!
                                                                                            .map((account) => DropdownMenuItem<DashboardAccountObject>(
                                                                                                  value: account,
                                                                                                  child: Text(
                                                                                                    account.name ?? "",
                                                                                                    style: mozillaTextRegularText(
                                                                                                      fontSize: 12,
                                                                                                      color: DynamicColors.textClr,
                                                                                                    ),
                                                                                                  ),
                                                                                                ))
                                                                                            .toList(),
                                                                                    onChanged: (v) {
                                                                                      controller.selectAccountValue = v;
                                                                                      controller.selectDepartmentData = null;
                                                                                      controller.update();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // (12) Pay dropdown
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: controller.jourValue == 'W/R' ? 18 : 38),
                                                                            child:
                                                                                FocusTraversalOrder(
                                                                              order: NumericFocusOrder(controller.jourValue == 'W/R' ? 36 : 32),
                                                                              child: labeledField(
                                                                                context: context,
                                                                                isMobile: isMobile,
                                                                                label: AppText.pay,
                                                                                width: fieldWidth / 2.9,
                                                                                heights: 32,
                                                                                child: Container(
                                                                                  // height: 35,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(6),
                                                                                    border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                                  ),
                                                                                  child: DropdownButtonFormField<PaymentTypeObject>(
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(),
                                                                                      isDense: true,
                                                                                    ),
                                                                                    value: controller.selectPaymentTypeValue,
                                                                                    items: controller.dashboardAllData!.paymentTypes!
                                                                                        .map((payment) => DropdownMenuItem<PaymentTypeObject>(
                                                                                              value: payment,
                                                                                              child: Text(
                                                                                                payment.name ?? "",
                                                                                                style: mozillaTextRegularText(
                                                                                                  fontSize: 12,
                                                                                                  color: DynamicColors.textClr,
                                                                                                ),
                                                                                              ),
                                                                                            ))
                                                                                        .toList(),
                                                                                    onChanged: (v) {
                                                                                      controller.selectPaymentTypeValue = v;
                                                                                      controller.update();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 3),
                                                                          FocusTraversalOrder(
                                                                            order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                                                ? 38
                                                                                : 33),
                                                                            child:
                                                                                labeledField(
                                                                              context: context,
                                                                              isMobile: isMobile,
                                                                              label: AppText.veh,
                                                                              width: fieldWidth / 2.9,
                                                                              heights: 32,
                                                                              child: Container(
                                                                                // height: 35,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(6),
                                                                                  border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                                ),
                                                                                child: DropdownButtonFormField<DashboardVehicleTypeObject>(
                                                                                  decoration: const InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    isDense: true,
                                                                                  ),
                                                                                  value: controller.selectVehicleValue,
                                                                                  items: controller.dashboardAllData!.vehicleTypes!
                                                                                      .map((vehicle) => DropdownMenuItem<DashboardVehicleTypeObject>(
                                                                                            value: vehicle,
                                                                                            child: Text(
                                                                                              vehicle.name ?? "",
                                                                                              style: mozillaTextRegularText(
                                                                                                fontSize: 12,
                                                                                                color: DynamicColors.textClr,
                                                                                              ),
                                                                                            ),
                                                                                          ))
                                                                                      .toList(),
                                                                                  onChanged: (v) async {
                                                                                    controller.selectVehicleValue = v;
                                                                                    controller.getFaresCalculation();
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          controller.selectAccountValue == null
                                                                              ? SizedBox.shrink()
                                                                              : FocusTraversalOrder(
                                                                                  order: NumericFocusOrder(controller.jourValue == 'W/R' ? 39 : 34),
                                                                                  child: labeledField(
                                                                                    context: context,
                                                                                    isMobile: isMobile,
                                                                                    label: "DEPT",
                                                                                    width: fieldWidth / 3,
                                                                                    heights: 35,
                                                                                    child: Container(
                                                                                      // height: 35,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(6),
                                                                                        border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                                      ),
                                                                                      child: DropdownButtonFormField<DepartmentObject>(
                                                                                        decoration: const InputDecoration(
                                                                                          border: OutlineInputBorder(),
                                                                                          isDense: true,
                                                                                        ),
                                                                                        value: controller.selectDepartmentData,
                                                                                        items: controller.selectAccountValue == null
                                                                                            ? []
                                                                                            : controller.selectAccountValue!.departments!
                                                                                                .map((department) => DropdownMenuItem<DepartmentObject>(
                                                                                                      value: department,
                                                                                                      child: Text(
                                                                                                        department.name ?? "",
                                                                                                        style: mozillaTextRegularText(
                                                                                                          fontSize: 12,
                                                                                                          color: DynamicColors.textClr,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ))
                                                                                                .toList(),
                                                                                        onChanged: (v) {
                                                                                          controller.selectDepartmentData = v;
                                                                                          controller.update();
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                          // Switch + Quotation
                                                                          SizedBox(
                                                                              width: 15),
                                                                          FocusTraversalOrder(
                                                                            order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                                                ? 40
                                                                                : 35),
                                                                            child:
                                                                                DynamicSwitch(
                                                                              controller: controller.switchController,
                                                                              activeColor: DynamicColors.primaryClr,
                                                                              inactiveColor: DynamicColors.gryClr,
                                                                              focusScale: 1.5,
                                                                              onToggle: () {
                                                                                print("Switch toggled: ${controller.switchController.value}");
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            AppText.quotation,
                                                                            style:
                                                                                mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                                          ),
                                                                          // SMS Checkbox
                                                                          FocusTraversalOrder(
                                                                            order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                                                ? 41
                                                                                : 36),
                                                                            child:
                                                                                SizedBox(
                                                                              // width: fieldWidth/6,
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  RawKeyboardListener(
                                                                                    focusNode: checkboxFocus,
                                                                                    onKey: (event) {
                                                                                      if (event is RawKeyDownEvent && (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.space)) {
                                                                                        setState(() {
                                                                                          // controller.smsCheckbox.value = !controller.smsCheckbox.value; // ✅ toggle
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: Checkbox(
                                                                                      activeColor: DynamicColors.primaryClr,
                                                                                      value: controller.smsCheckbox.value,
                                                                                      onChanged: (v) {
                                                                                        // controller.smsCheckbox.value = v!;
                                                                                        // controller.update();
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    AppText.sms,
                                                                                    style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // Email Checkbox
                                                                          FocusTraversalOrder(
                                                                            order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                                                ? 42
                                                                                : 37),
                                                                            child:
                                                                                SizedBox(
                                                                              // width: fieldWidth/5,
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  RawKeyboardListener(
                                                                                    focusNode: emailFocus,
                                                                                    onKey: (event) {
                                                                                      if (event is RawKeyDownEvent && (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.space)) {
                                                                                        setState(() {
                                                                                          controller.emailCheckbox.value = !controller.emailCheckbox.value; // ✅ toggle
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: Checkbox(
                                                                                      activeColor: DynamicColors.primaryClr,
                                                                                      value: controller.emailCheckbox.value,
                                                                                      onChanged: (v) {
                                                                                        controller.emailCheckbox.value = v!;
                                                                                        controller.update();
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    AppText.email,
                                                                                    style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // Pass, Lugg, Slugg fields
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          SizedBox(
                                                                            // width: fieldWidth/2.0,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                FocusTraversalOrder(
                                                                                  order: NumericFocusOrder(controller.jourValue == 'W/R' ? 43 : 38),
                                                                                  child: SizedBox(
                                                                                    width: 60,
                                                                                    height: 30,
                                                                                    child: CustomTextField(
                                                                                      hintText: "Pass",
                                                                                      inputFormatters: [
                                                                                        FilteringTextInputFormatter.digitsOnly,
                                                                                        LengthLimitingTextInputFormatter(2),
                                                                                      ],
                                                                                      keyboardType: TextInputType.number,
                                                                                      contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                                                                      controller: controller.passController,
                                                                                      borderRadius: 4,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 15),
                                                                                FocusTraversalOrder(
                                                                                  order: NumericFocusOrder(controller.jourValue == 'W/R' ? 44 : 39),
                                                                                  child: SizedBox(
                                                                                    width: 60,
                                                                                    height: 30,
                                                                                    child: CustomTextField(
                                                                                      hintText: "Lugg",
                                                                                      inputFormatters: [
                                                                                        FilteringTextInputFormatter.digitsOnly,
                                                                                        LengthLimitingTextInputFormatter(2),
                                                                                      ],
                                                                                      keyboardType: TextInputType.number,
                                                                                      contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                                                                      controller: controller.luggController,
                                                                                      borderRadius: 4,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 15),
                                                                                FocusTraversalOrder(
                                                                                  order: NumericFocusOrder(controller.jourValue == 'W/R' ? 45 : 40),
                                                                                  child: SizedBox(
                                                                                    width: 60,
                                                                                    height: 30,
                                                                                    child: CustomTextField(
                                                                                      hintText: "Slugg",
                                                                                      inputFormatters: [
                                                                                        FilteringTextInputFormatter.digitsOnly,
                                                                                        LengthLimitingTextInputFormatter(2),
                                                                                      ],
                                                                                      keyboardType: TextInputType.number,
                                                                                      contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                                                                      controller: controller.sluggController,
                                                                                      borderRadius: 4,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 15),
                                                                          Container(
                                                                            height:
                                                                                40,
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.grey.shade300,
                                                                              borderRadius: BorderRadius.circular(4),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                FocusTraversalOrder(
                                                                                  order: NumericFocusOrder(controller.jourValue == 'W/R' ? 46 : 41),
                                                                                  child: buildFocusableIcon(
                                                                                    icon: Icons.person,
                                                                                    focusNode: _focusNodes[0],
                                                                                    onPressed: () {
                                                                                      showDialog(context: context, builder: (_) => RestrictDriversAlert());
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 5),
                                                                                FocusTraversalOrder(
                                                                                  order: NumericFocusOrder(controller.jourValue == 'W/R' ? 47 : 42),
                                                                                  child: buildFocusableIcon(
                                                                                    icon: Icons.shopping_cart_checkout_outlined,
                                                                                    focusNode: _focusNodes[1],
                                                                                    onPressed: () {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (_) => ChildSeatsAlert(),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 5),
                                                                                FocusTraversalOrder(
                                                                                  order: NumericFocusOrder(controller.jourValue == 'W/R' ? 48 : 43),
                                                                                  child: buildFocusableIcon(
                                                                                    icon: Icons.attach_money,
                                                                                    focusNode: _focusNodes[2],
                                                                                    onPressed: () {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        barrierDismissible: false,
                                                                                        builder: (_) => ExtraFaresAlert(),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 5),
                                                                                FocusTraversalOrder(
                                                                                  order: NumericFocusOrder(controller.jourValue == 'W/R' ? 49 : 44),
                                                                                  child: buildFocusableIcon(
                                                                                    icon: Icons.note_add_sharp,
                                                                                    focusNode: _focusNodes[3],
                                                                                    onPressed: () {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (_) => ExtraInfoAlert(),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                // (13) Calendar icon (keyboard clickable)
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 5),
                                                                          FocusTraversalOrder(
                                                                            order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                                                ? 37
                                                                                : 45),
                                                                            child:
                                                                                SizedBox(
                                                                              height: 40,
                                                                              child: KbdActivatable(
                                                                                focusNode: calendarFN,
                                                                                onActivate: () {
                                                                                  // TODO: open your calendar modal/sheet
                                                                                  // For demo:
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    const SnackBar(content: Text("Calendar icon activated")),
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.grey.shade300,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: const Icon(Icons.calculate, size: 23),
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
                                                                    width: Get
                                                                        .width,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            color:
                                                                                DynamicColors.secondaryClr),
                                                                    child: Wrap(
                                                                      spacing:
                                                                          10,
                                                                      runSpacing:
                                                                          16,
                                                                      children: [
                                                                        SizedBox(
                                                                            width:
                                                                                30),
                                                                        Icon(
                                                                            Icons
                                                                                .access_time_filled_outlined,
                                                                            color:
                                                                                DynamicColors.textClr,
                                                                            size: 18),
                                                                        SizedBox(
                                                                            width:
                                                                                2),
                                                                        Text(
                                                                            "ETA : ${controller.totalTimeDuration}",
                                                                            style:
                                                                                TextStyle(color: DynamicColors.textClr, fontSize: 13)),
                                                                        SizedBox(
                                                                            width:
                                                                                30),
                                                                        Icon(
                                                                            Icons
                                                                                .access_time_filled_outlined,
                                                                            color:
                                                                                DynamicColors.textClr,
                                                                            size: 18),
                                                                        SizedBox(
                                                                            width:
                                                                                2),
                                                                        Text(
                                                                            "JOURNEY : 0.0 mins",
                                                                            style:
                                                                                TextStyle(color: DynamicColors.textClr, fontSize: 13)),
                                                                        SizedBox(
                                                                            width:
                                                                                30),
                                                                        Icon(
                                                                            Icons
                                                                                .location_on,
                                                                            color:
                                                                                DynamicColors.textClr,
                                                                            size: 18),
                                                                        SizedBox(
                                                                            width:
                                                                                2),
                                                                        Text(
                                                                            "DISTANCE : ${controller.totalDistance}",
                                                                            style:
                                                                                TextStyle(color: DynamicColors.textClr, fontSize: 13)),
                                                                        SizedBox(
                                                                            width:
                                                                                30),
                                                                        Container(
                                                                          width:
                                                                              fieldWidth / 3.5,
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 4),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(4),
                                                                          ),
                                                                          child:
                                                                              FittedBox(
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                            child:
                                                                                Text(
                                                                              "FARE: \£  ${double.parse(controller.fixedFare.value).toStringAsFixed(1)}",
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
                                                                    width: Get
                                                                        .width,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            color:
                                                                                DynamicColors.secondaryClr),
                                                                    child: Wrap(
                                                                      spacing:
                                                                          10,
                                                                      runSpacing:
                                                                          16,
                                                                      children: [
                                                                        SizedBox(
                                                                            width:
                                                                                30),
                                                                        FocusTraversalOrder(
                                                                          order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                                              ? 50
                                                                              : 46),
                                                                          child:
                                                                              labeledField(
                                                                            context:
                                                                                context,
                                                                            isMobile:
                                                                                isMobile,
                                                                            label:
                                                                                AppText.drv,
                                                                            width:
                                                                                fieldWidth / 2.3,
                                                                            heights:
                                                                                35,
                                                                            child:
                                                                                Container(
                                                                              // height: 35,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(6),
                                                                                border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                              ),
                                                                              child: DropdownButtonFormField<DashboardDriverObject>(
                                                                                decoration: const InputDecoration(
                                                                                  border: OutlineInputBorder(),
                                                                                  isDense: true,
                                                                                ),
                                                                                value: controller.selectDriverValue,
                                                                                items: controller.dashboardAllData!.drivers!
                                                                                    .map((driver) => DropdownMenuItem<DashboardDriverObject>(
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
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                350),
                                                                        FocusTraversalOrder(
                                                                          order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                                              ? 51
                                                                              : 47),
                                                                          child:
                                                                              CustomButton(
                                                                            onTap:
                                                                                () {
                                                                              controller.refreshPostAllFields();
                                                                            },
                                                                            btnText:
                                                                                "CLEAR [F7]",
                                                                            width:
                                                                                110,
                                                                            height:
                                                                                30,
                                                                            fontSize:
                                                                                11,
                                                                            btnColor:
                                                                                DynamicColors.redClr,
                                                                            verticalPadding:
                                                                                0.0,
                                                                            borderRadius:
                                                                                4,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        FocusTraversalOrder(
                                                                          order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                                              ? 52
                                                                              : 48),
                                                                          child:
                                                                              CustomButton(
                                                                            onTap:
                                                                                () {
                                                                              if (controller.jourValue == 'W/R' && controller.pickupTwoWayController.text.isEmpty && controller.dropOffTwoWayController.text.isEmpty) {
                                                                                BotToast.showText(text: "Please chose waiting return");
                                                                                return;
                                                                              }
                                                                              controller.dashBoardApiValidation(id: controller.jobDetails == null?null: int.parse(controller.jobDetails!.id!));
                                                                            },
                                                                            btnText:
                                                                                "SAVE[HOME]",
                                                                            width:
                                                                                110,
                                                                            height:
                                                                                30,
                                                                            fontSize:
                                                                                11,
                                                                            verticalPadding:
                                                                                0.0,
                                                                            borderRadius:
                                                                                4,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          DriversView(),
                                                          MapViewWidget(),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          BookingFormWidget(),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              //Driver
                                                              DriversView(),
                                                              SizedBox(
                                                                  width:
                                                                      screenWidth *
                                                                          0.0133),

                                                              /// todo MAP SECTION
                                                              MapViewWidget(),

                                                              /// todo MAP SECTION
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                              ),
                                            ),
                                            Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  // color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: BookingTable(),
                                                )),
                                          ],
                                        ),
                                      ),
                                      // 🔽 Address suggestion dropdown with keyboard support
                                      Obx(() {
                                        if (controller.selectedTextFieldsValue
                                                .value ==
                                            "via") return const SizedBox();
                                        if (controller.selectedTextFieldsValue
                                                .value ==
                                            "Phone Number") {
                                          return SuggestionView(
                                            allListData: controller
                                                .customerPhoneNumber!
                                                .customerInfo!,
                                            onSelect: (value) {
                                              controller
                                                  .suggestionPhoneFocusNode
                                                  .value
                                                  .unfocus();
                                              controller.selectedTextFieldsValue
                                                  .value = "";
                                              FocusScope.of(Get.context!)
                                                  .requestFocus(controller
                                                      .phoneKeyboardFocusNode);
                                              controller.mobileController.text =
                                                  value.mobile
                                                      .toString(); // <-- store anywhere
                                              controller.nameController.text =
                                                  value.name.toString();
                                            },
                                          );
                                        }
                                        if (controller.allAddressesData.isEmpty)
                                          return SizedBox();

                                        final activeKey =
                                            controller.activeFieldKey.value;
                                        final fieldBox = activeKey
                                            ?.currentContext
                                            ?.findRenderObject() as RenderBox?;
                                        final stackBox = controller
                                            .stackKey.currentContext
                                            ?.findRenderObject() as RenderBox?;

                                        double top = 0.0;
                                        double left = 0.0;
                                        double width =
                                            screenWidth; // define early

                                        if (fieldBox != null &&
                                            stackBox != null) {
                                          final localOffset = fieldBox
                                              .localToGlobal(Offset.zero,
                                                  ancestor: stackBox);
                                          width = fieldBox.size.width;
                                          top = localOffset.dy +
                                              fieldBox.size.height;
                                          left = localOffset.dx;
                                        }

                                        return Positioned(
                                          top: controller
                                                      .selectedTextFieldsValue
                                                      .value ==
                                                  "PICKUP TWO WAY LOCATION"
                                              ? top * 1.8
                                              : controller.selectedTextFieldsValue
                                                          .value ==
                                                      "DROP TWO WAY LOCATION"
                                                  ? top * 2.05
                                                  : top,
                                          left: left,
                                          width: width,
                                          child: RawKeyboardListener(
                                            focusNode:
                                                controller.suggestionFocusNode,
                                            autofocus: true,
                                            onKey: (RawKeyEvent event) {
                                              if (event is RawKeyDownEvent) {
                                                if (event.logicalKey ==
                                                    LogicalKeyboardKey
                                                        .arrowDown) {
                                                  controller
                                                      .moveHighlightDown();
                                                } else if (event.logicalKey ==
                                                    LogicalKeyboardKey
                                                        .arrowUp) {
                                                  controller.moveHighlightUp();
                                                } else if (event.logicalKey ==
                                                    LogicalKeyboardKey.enter) {
                                                  controller.tapSelect(controller
                                                      .suggestionSelectedIndex
                                                      .value);
                                                }
                                              }
                                            },
                                            child: Container(
                                              height: screenHeight * 0.3,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEFF0F2),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 2)),
                                                ],
                                              ),
                                              child: Obx(() => ListView.builder(
                                                    key: controller
                                                        .suggestionListKey,
                                                    controller: controller
                                                        .suggestionScrollController,
                                                    itemCount: controller
                                                        .allAddressesData
                                                        .length,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item = controller
                                                              .allAddressesData[
                                                          index];
                                                      final isHighlighted =
                                                          controller
                                                                  .highlightedIndex
                                                                  .value ==
                                                              index;

                                                      return Obx(() {
                                                        final isHighlighted =
                                                            controller
                                                                    .highlightedIndex
                                                                    .value ==
                                                                index;
                                                        return Container(
                                                          key: controller
                                                                  .suggestionItemKeys[
                                                              index],
                                                          color: isHighlighted
                                                              ? const Color(
                                                                  0xffA0DCFF)
                                                              : Colors
                                                                  .transparent,
                                                          child: ListTile(
                                                            dense: true,
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            title:
                                                                AnimatedDefaultTextStyle(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          120),
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: isHighlighted
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .normal,
                                                                color: isHighlighted
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                              child: Text(
                                                                  "${item.name} ${item.postcode}"),
                                                            ),
                                                            onTap: () =>
                                                                controller
                                                                    .tapSelect(
                                                                        index),
                                                          ),
                                                        );
                                                      });
                                                    },
                                                  )),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                          ],
                        ),
                      ),
              );
            });
    });
  }

  Widget buildChip(String label, {bool isFirst = false, bool isLast = false}) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          border: Border.all(color: Colors.blue.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
