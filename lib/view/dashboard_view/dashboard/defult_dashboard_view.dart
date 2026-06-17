import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/marker_class.dart';
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

double containerFormHeight = 0;

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

  final LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());
  DashboardController controller = Get.find();

  SuggestionController suggestion_controller =
  Get.isRegistered<SuggestionController>()
      ? Get.find<SuggestionController>()
      : Get.put(SuggestionController());

  @override
  void initState() {
    // TODO: implement initState
    controller = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());
    super.initState();
    if (controller.dashboardAllData == null) {
      controller.dashboardData();
    }
  }

  final GlobalKey _containerKey = GlobalKey();

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
      return controller.dashboardAllData == null
          ? material.Center(child: CircularProgressIndicator())
          : LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = _containerKey.currentContext;
          final box = context?.findRenderObject() as RenderBox;
          setState(() {
            containerFormHeight = box.size.height;
          });
        });

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
            ? maxWidth / 2
            : maxWidth / 4;

        double fieldWidthh = MediaQuery.of(context).size.width;

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
                        Stack(
                          alignment: Alignment.centerRight,
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
                                    keyss: "F6",
                                    valuess: "QUOTATION"),
                                // width >= 1900
                                //     ? Spacer()
                                //     : SizedBox.shrink(),
                              ],
                            ),
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
                                  Container(
                                    key: _containerKey,
                                    child:
                                    FocusTraversalGroup(
                                      policy:
                                      OrderedTraversalPolicy(),
                                      child: SizedBox(
                                        width:
                                        Get.width /
                                            2,
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                FormShortCutKey(),
                                                SizedBox(
                                                  height:
                                                  screenHeight * 0.015,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0),
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
//                                                       FocusTraversalOrder(
//                                                         order: const NumericFocusOrder(1),
//                                                         child: SizedBox(
//                                                           width: fieldWidth / 1.2,
//                                                           height: 30,
//                                                           child: RawKeyboardListener(
//                                                             focusNode: controller.pickupKeyboardFocusNode,
//                                                             onKey: (event) {
//                                                               if (event is RawKeyDownEvent) {
//                                                                 if (event.logicalKey == LogicalKeyboardKey.arrowDown && controller.highlightedIndex.value < controller.suggestions.length - 1) {
//                                                                   controller.highlightedIndex.value++;
//                                                                 } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && controller.highlightedIndex.value > 0) {
//                                                                   controller.highlightedIndex.value--;
//                                                                 } else if (event.logicalKey == LogicalKeyboardKey.enter) {
//                                                                   final selected = controller.suggestions[controller.highlightedIndex.value].name;
//                                                                   controller.selectSuggestion(selected);
//                                                                 } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp
//                                                                     || event.logicalKey == LogicalKeyboardKey.tab
//                                                                 ) {
//                                                                   FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
//                                                                 }
//                                                                 // }else if(event.logicalKey == LogicalKeyboardKey.tab){
//                                                                 //   FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
//                                                                 // }
//                                                               }
//                                                             },
//                                                             child: CustomTextField(
//                                                               key: controller.pickupFieldKey,
//                                                               controller: controller.pickupController,
//                                                               focusNode: controller.pickupTextFieldFocusNode,
//                                                               inputFormatters: [
//                                                                 UpperCaseTextFormatter(),
//                                                               ],
//                                                               hintText: 'PICKUP LOCATION',
//                                                               borderRadius: 4,
//                                                               prefixIcon: const Icon(
//                                                                 Icons.location_pin,
//                                                                 color: Colors.red,
//                                                                 size: 20,
//                                                               ),
//                                                               textInputAction: TextInputAction.next,
//                                                               onTap: () {
//                                                                 shortCutKeyValue.value = "PICKUP LOCATION";
//                                                                 controller.dropDownShow.value = true;
//                                                               },
//                                                               onChanged: (v) {
//                                                                 if(v.isEmpty) {
//                                                                   controller
//                                                                       .dropDownShow
//                                                                       .value =
//                                                                   false;
//                                                                 }else{
//                                                                   controller.dropDownShow.value = true;
//                                                                 }
//                                                                 controller.onChangeHandler(fieldName: "PICKUP LOCATION", searchingText: v);
//                                                               },
//                                                               onSubmitted: (_) => FocusScope.of(context).nextFocus(),
//                                                               suffixIcon: Row(
//                                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                                 mainAxisSize: MainAxisSize.min,
//                                                                 children: [
//                                                                   controller.pickupController.text.isEmpty
//                                                                       ? SizedBox.shrink()
//                                                                       : KbdActivatable(
//                                                                     focusNode: clearPic,
//                                                                     onActivate: () {
//   // 1. Text Controller aur Dropdown clear karein
//   controller.pickupController.clear();
//   controller.dropDownShow.value = false;
//   controller.suggestions.clear();

//   // 2. Sirf PICKUP ya Create Booking PICKUP waale data ko list se remove karein
//   controller.polyLineMarkerInfo.removeWhere((item) =>
//     item.markerType == "PICKUP LOCATION" || item.markerType == "Create Booking PICKUP"
//   );

//   // 3. Fares aur distance ko reset karein
//   controller.totalDistance.value = "0.00";
//   controller.totalTimeDuration.value = "0 min";
//   controller.fixedFare.value = "0";
//   controller.returnFareValue = "0";
//   controller.slugController.clear();
//   controller.slugControllerReturn.clear();
//   controller.tempStoreMils = null;

//   // 4. Map aur Markers ko update karein
//   controller.fetchRouteFromOSRM();

//   // 5. Focus wapas textfield par le aayein
//   FocusScope.of(Get.context!).requestFocus(controller.pickupTextFieldFocusNode);
//   controller.update();
// },
//                                                                     // onActivate: () {
//                                                                       int index = controller.markers.indexWhere((test) => test.type == "pickup");
//                                                                       int indexx = controller.polyLineMarkerInfo.indexWhere(((element) => element.markerType == "PICKUP LOCATION"));
//                                                                       controller.polyLineMarkerInfo.remove(controller.polyLineMarkerInfo[indexx]);
//                                                                       controller.markers.remove(controller.markers[index]);
                                                      //   FocusScope.of(Get.context!).requestFocus(controller.pickupTextFieldFocusNode);
//                                                                     //   controller.markers.clear();
//                                                                     //   controller.fixedFare.value = "0";
//                                                                     //   controller.returnFareValue = "";
//                                                                     //   controller.slugControllerReturn.clear();
//                                                                     //   controller.slugController.clear();
//                                                                     //   controller.dropDownShow.value = false;
//                                                                     //   // controller.polyLineMarkerInfo.clear();
//                                                                     //   controller.pickupController.clear();
//                                                                     //   controller.dropOffController.clear();
//                                                                     //   controller.polylinePoints.clear();
//                                                                     //   controller.tempStoreMils = null;
//                                                                     //   controller.fetchRouteFromOSRM();
//                                                                     //   controller.fixedFare.value = "0";
//                                                                     //   controller.totalDistance.value = "0";
//                                                                     //   controller.totalTimeDuration.value = "0";
//                                                                     //   controller.update();
//                                                                     //   // controller.fetchRouteFromOSRM();
//                                                                     // },
//                                                                     child: Icon(
//                                                                       Icons.close,
//                                                                       color: DynamicColors.redClr,
//                                                                       size: 15,
//                                                                     ),
//                                                                   ),
//                                                                   KbdActivatable(
//                                                                     focusNode: swap1FN,
//                                                                     onActivate: () {
//                                                                       String tempPic = controller.pickupController.text;
//                                                                       String tempDrop = controller.dropOffController.text;
//                                                                       controller.pickupController.text = tempDrop;
//                                                                       controller.dropOffController.text = tempPic;
//                                                                       controller.update();
//                                                                     },
//                                                                     child: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 20),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
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
                                                                } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.tab) {
                                                                  FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                                                }
                                                              }
                                                            },
                                                            child: CustomTextField(
                                                              key: controller.pickupFieldKey,
                                                              controller: controller.pickupController,
                                                              focusNode: controller.pickupTextFieldFocusNode,
                                                              inputFormatters: [
                                                                UpperCaseTextFormatter()
                                                              ],
                                                              hintText: 'PICKUP LOCATION',
                                                              borderRadius: 4,
                                                              prefixIcon: const Icon(Icons.location_pin, color: Colors.red, size: 20),
                                                              textInputAction: TextInputAction.next,
                                                              onTap: () {
                                                                shortCutKeyValue.value = "PICKUP LOCATION";
                                                                controller.dropDownShow.value = true;
                                                              },
                                                              onChanged: (v) {
                                                                if (v.isEmpty) {
                                                                  controller.dropDownShow.value = false;
                                                                } else {
                                                                  controller.dropDownShow.value = true;
                                                                }
                                                                controller.onChangeHandler(fieldName: "PICKUP LOCATION", searchingText: v);
                                                              },
                                                              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                              suffixIcon: Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  controller.pickupController.text.isEmpty
                                                                      ? const SizedBox.shrink()
                                                                      : KbdActivatable(
                                                                    focusNode: clearPic,
                                                                    onActivate: () {
                                                                      final pickupPolylineIndex = controller.polyLineMarkerInfo
                                                                          .indexWhere((e) => e.markerType == "PICKUP LOCATION");

                                                                      if (pickupPolylineIndex >= 0) {
                                                                        controller.polyLineMarkerInfo.removeAt(pickupPolylineIndex);
                                                                      }

                                                                      final dropPolylineIndex = controller.polyLineMarkerInfo
                                                                          .indexWhere((e) => e.markerType == "DROP LOCATION");

                                                                      if (dropPolylineIndex >= 0) {
                                                                        controller.polyLineMarkerInfo.removeAt(dropPolylineIndex);
                                                                      }

                                                                      final pickupMarkerIndex =
                                                                      controller.markers.indexWhere((e) => e.type == "pickup");

                                                                      if (pickupMarkerIndex >= 0) {
                                                                        controller.markers.removeAt(pickupMarkerIndex);
                                                                      }

                                                                      final dropOffMarkerIndex =
                                                                      controller.markers.indexWhere((e) => e.type == "dropOff");

                                                                      if (dropOffMarkerIndex >= 0) {
                                                                        controller.markers.removeAt(dropOffMarkerIndex);
                                                                      }
                                                                      controller.markers.removeWhere((marker) => marker.type == "via");
                                                                      controller.viaPoints.clear();
                                                                      controller.viaTextEditingController.clear();

                                                                      controller.pickupController.clear();
                                                                      controller.dropOffController.clear();
                                                                      controller.dropDownShow.value = false;
                                                                      controller.suggestions.clear();

                                                                      // Sirf 1st Pickup wale markers remove honge
                                                                      // controller.polyLineMarkerInfo.removeWhere((item) => item.markerType == "PICKUP LOCATION" || item.markerType == "Create Booking PICKUP");

                                                                      controller.totalDistance.value = "0.00";
                                                                      controller.totalTimeDuration.value = "0 min";
                                                                      controller.fixedFare.value = "0";
                                                                      controller.returnFareValue = "0";
                                                                      controller.slugController.clear();
                                                                      controller.slugControllerReturn.clear();
                                                                      // controller.tempStoreMils = null;

                                                                      controller.fetchRouteFromOSRM();
                                                                      FocusScope.of(Get.context!).requestFocus(controller.pickupTextFieldFocusNode);
                                                                      controller.update();
                                                                    },
                                                                    child: Icon(Icons.close, color: DynamicColors.redClr, size: 15),
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
                                                      // (2) Pickup Zone Dropdown - (Flex: 5 aur width null ke sath)
                                                      Expanded(
                                                        flex: 5,
                                                        child: Obx(
                                                              () => Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 6.0, left: 15.0),
                                                                child: SizedBox(
                                                                  width: 40,
                                                                  // Perfect alignment ke liye bilkul baqi rows jitna size
                                                                  child: Text(
                                                                    "ZONE",
                                                                    style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: FocusTraversalOrder(
                                                                  order: const NumericFocusOrder(2),
                                                                  child: CustomDropdownField<ZoneObject>(
                                                                    label: "SELECT ZONE",
                                                                    width: fieldWidthh / 10.5,
                                                                    // Hardcoded width hata di taake flex perfect chale
                                                                    height: 30,
                                                                    items: _controller.updateLocationValue.value == true ? [] : _controller.locationtypezoneModel!.zonesList!,
                                                                    value: _controller.zoneValue,
                                                                    itemLabel: (templateList) => templateList.name!,
                                                                    onChanged: (val) {
                                                                      controller.dropDownShow.value = false;
                                                                      _controller.zoneValue = val;
                                                                      controller.dashboardZoneValue = val;
                                                                      controller.update();
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

// Dono fields ke darmiyan ka fasla (Aapka original 13.0 spacing)
                                                      const SizedBox(
                                                        width: 55.0,
                                                      ),

// (3) Pickup notes - (Flex: 3 aur bina label ke)
                                                      Expanded(
                                                        flex: 3,
                                                        child: FocusTraversalOrder(
                                                          order: const NumericFocusOrder(3),
                                                          child: SizedBox(
                                                            height: 30,
                                                            child: CustomTextField(
                                                              width: fieldWidthh / 15,
                                                              // Hardcoded width hata di taake Drop Notes ki tarah look aaye
                                                              controller: controller.pickUpNoteController,
                                                              inputFormatters: [
                                                                UpperCaseTextFormatter(),
                                                              ],
                                                              hintText: "PICKUP NOTES",
                                                              borderRadius: 6,
                                                              onTap: () {
                                                                controller.dropDownShow.value = false;
                                                              },
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
                                                  visible: controller
                                                      .isAirportResponse
                                                      .value,
                                                  child:
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                                                inputFormatters: [
                                                                  UpperCaseTextFormatter(),
                                                                ],
                                                                borderRadius: 6,
                                                                textInputAction: TextInputAction.next,
                                                                onTap: () {
                                                                  controller.dropDownShow.value = false;
                                                                },
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
                                                                inputFormatters: [
                                                                  UpperCaseTextFormatter(),
                                                                ],
                                                                hintText: "ARR",
                                                                borderRadius: 6,
                                                                onTap: () {
                                                                  controller.dropDownShow.value = false;
                                                                },
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
                                                      horizontal: 10.0,
                                                      vertical: 12.0),
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

                                                      // (2) Dropoff textfield
//                                                       FocusTraversalOrder(
//                                                         order: const NumericFocusOrder(6),
//                                                         child: SizedBox(
//                                                           width: fieldWidth / 1.2,
//                                                           height: 30,
//                                                           child: RawKeyboardListener(
//                                                             focusNode: controller.dropOffKeyboardFocusNode,
//                                                             onKey: (event) {
//                                                               if (event is RawKeyDownEvent) {
//                                                                 if (event.logicalKey == LogicalKeyboardKey.arrowDown && controller.highlightedIndex.value < controller.suggestions.length - 1) {
//                                                                   controller.highlightedIndex.value++;
//                                                                 } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && controller.highlightedIndex.value > 0) {
//                                                                   controller.highlightedIndex.value--;
//                                                                 } else if (event.logicalKey == LogicalKeyboardKey.enter) {
//                                                                   final selected = controller.suggestions[controller.highlightedIndex.value].name;
//                                                                   controller.selectSuggestion(selected);
//                                                                 } else if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.tab) {
//                                                                   FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
//                                                                 }
//                                                               }
//                                                             },
//                                                             child: CustomTextField(
//                                                               key: controller.dropOffFieldKey,
//                                                               controller: controller.dropOffController,
//                                                               focusNode: controller.dropOffTextFieldFocusNode,
//                                                               hintText: 'DROP LOCATION',
//                                                               inputFormatters: [
//                                                                 UpperCaseTextFormatter(),
//                                                               ],
//                                                               onTap: () {
//                                                                 shortCutKeyValue.value = "DROP LOCATION";
//                                                                 controller.dropDownShow.value = true;
//                                                               },
//                                                               borderRadius: 4,
//                                                               onChanged: (v) {
//                                                                 if(v.isEmpty){
//                                                                   controller.dropDownShow.value = false;
//                                                                 }else{
//                                                                   controller.dropDownShow.value = true;
//                                                                 }
//                                                                 controller.onChangeHandler(fieldName: "DROP LOCATION", searchingText: v);
//                                                               },
//                                                               prefixIcon: const Icon(
//                                                                 Icons.location_pin,
//                                                                 color: Colors.red,
//                                                                 size: 20,
//                                                               ),
//                                                               textInputAction: TextInputAction.next,
//                                                               onSubmitted: (_) => FocusScope.of(context).nextFocus(),
//                                                               suffixIcon: Row(
//                                                                 mainAxisSize: MainAxisSize.min,
//                                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                                 children: [
//                                                                   controller.dropOffController.text.isEmpty
//                                                                       ? SizedBox.shrink()
//                                                                       : KbdActivatable(
//                                                                     focusNode: clearDrop,
//                                                                     onActivate: () {
//   controller.dropOffController.clear();
//   controller.dropDownShow.value = false;
//   controller.suggestions.clear();

//   // Sirf DROP waale markers remove karein
//   controller.polyLineMarkerInfo.removeWhere((item) =>
//     item.markerType == "DROP LOCATION" || item.markerType == "Create Booking DROP LOCATION"
//   );

//   controller.totalDistance.value = "0.00";
//   controller.totalTimeDuration.value = "0 min";
//   controller.fixedFare.value = "0";
//   controller.returnFareValue = "0";
//   controller.slugController.clear();
//   controller.slugControllerReturn.clear();
//   controller.tempStoreMils = null;

//   controller.fetchRouteFromOSRM(); // Route aur markers update karega

//   FocusScope.of(Get.context!).requestFocus(controller.dropoffFocusNode); // Dropoff focus node
//   controller.update();
// },
//                                                                     // onActivate: () {
//                                                                     //   // int index = controller.markers.indexWhere((test) => test.type == "dropOff");
//                                                                     //   // int indexx = controller.polyLineMarkerInfo.indexWhere(((element) => element.markerType == "DROP LOCATION"));
//                                                                     //   // controller.polyLineMarkerInfo.remove(controller.polyLineMarkerInfo[indexx]);
//                                                                     //   // controller.markers.remove(controller.markers[index]);
//                                                                     //   FocusScope.of(Get.context!).requestFocus(controller.dropOffTextFieldFocusNode);
//                                                                     //   controller.dropOffController.clear();
//                                                                     //   controller.fixedFare.value = "0";
//                                                                     //   controller.returnFareValue = "";
//                                                                     //   controller.slugControllerReturn.clear();
//                                                                     //   controller.slugController.clear();
//                                                                     //   controller.markers.clear();
//                                                                     //   controller.polyLineMarkerInfo.clear();
//                                                                     //   controller.pickupController.clear();
//                                                                     //   controller.polylinePoints.clear();
//                                                                     //   controller.tempStoreMils = null;
//                                                                     //   controller.dropDownShow.value = false;
//                                                                     //   controller.fetchRouteFromOSRM();
//                                                                     //   controller.fixedFare.value = "0";
//                                                                     //   controller.totalDistance.value = "0";
//                                                                     //   controller.totalTimeDuration.value = "0";
//                                                                     //   controller.update();
//                                                                     // },
//                                                                     child: Icon(
//                                                                       Icons.close,
//                                                                       color: DynamicColors.redClr,
//                                                                       size: 15,
//                                                                     ),
//                                                                   ),
//                                                                   KbdActivatable(
//                                                                     focusNode: swap2FN,
//                                                                     onActivate: () {
//                                                                       String tempPic = controller.pickupController.text;
//                                                                       String tempDrop = controller.dropOffController.text;
//                                                                       controller.pickupController.text = tempDrop;
//                                                                       controller.dropOffController.text = tempPic;
//                                                                       controller.dropDownShow.value = false;
//                                                                       controller.update();
//                                                                     },
//                                                                     child: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 20),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),

                                                      // (2) Dropoff textfield
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
                                                              inputFormatters: [
                                                                UpperCaseTextFormatter()
                                                              ],
                                                              onTap: () {
                                                                shortCutKeyValue.value = "DROP LOCATION";
                                                                controller.dropDownShow.value = true;
                                                              },
                                                              borderRadius: 4,
                                                              onChanged: (v) {
                                                                if (v.isEmpty) {
                                                                  controller.dropDownShow.value = false;
                                                                } else {
                                                                  controller.dropDownShow.value = true;
                                                                }
                                                                controller.onChangeHandler(fieldName: "DROP LOCATION", searchingText: v);
                                                              },
                                                              prefixIcon: const Icon(Icons.location_pin, color: Colors.red, size: 20),
                                                              textInputAction: TextInputAction.next,
                                                              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                              suffixIcon: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  controller.dropOffController.text.isEmpty
                                                                      ? const SizedBox.shrink()
                                                                      : KbdActivatable(
                                                                    focusNode: clearDrop,
                                                                    onActivate: () {

                                                                      final pickupPolylineIndex = controller.polyLineMarkerInfo
                                                                          .indexWhere((e) => e.markerType == "PICKUP LOCATION");

                                                                      if (pickupPolylineIndex >= 0) {
                                                                        controller.polyLineMarkerInfo.removeAt(pickupPolylineIndex);
                                                                      }

                                                                      final dropPolylineIndex = controller.polyLineMarkerInfo
                                                                          .indexWhere((e) => e.markerType == "DROP LOCATION");

                                                                      if (dropPolylineIndex >= 0) {
                                                                        controller.polyLineMarkerInfo.removeAt(dropPolylineIndex);
                                                                      }

                                                                      final pickupMarkerIndex =
                                                                      controller.markers.indexWhere((e) => e.type == "pickup");

                                                                      if (pickupMarkerIndex >= 0) {
                                                                        controller.markers.removeAt(pickupMarkerIndex);
                                                                      }

                                                                      final dropOffMarkerIndex =
                                                                      controller.markers.indexWhere((e) => e.type == "dropOff");

                                                                      if (dropOffMarkerIndex >= 0) {
                                                                        controller.markers.removeAt(dropOffMarkerIndex);
                                                                      }
                                                                      controller.pickupController.clear();
                                                                      controller.dropOffController.clear();
                                                                      controller.dropDownShow.value = false;
                                                                      controller.suggestions.clear();

                                                                      // Sirf 1st Dropoff wale markers remove honge
                                                                      // controller.polyLineMarkerInfo.removeWhere((item) => item.markerType == "DROP LOCATION" || item.markerType == "Create Booking DROP LOCATION");

                                                                      controller.totalDistance.value = "0.00";
                                                                      controller.totalTimeDuration.value = "0 min";
                                                                      controller.fixedFare.value = "0";
                                                                      controller.returnFareValue = "0";
                                                                      controller.slugController.clear();
                                                                      controller.slugControllerReturn.clear();
                                                                      controller.tempStoreMils = null;
                                                                      controller.fetchRouteFromOSRM();
                                                                      FocusScope.of(Get.context!).requestFocus(controller.dropOffTextFieldFocusNode);
                                                                      controller.update();
                                                                    },
                                                                    child: Icon(Icons.close, color: DynamicColors.redClr, size: 15),
                                                                  ),
                                                                  KbdActivatable(
                                                                    focusNode: swap2FN,
                                                                    onActivate: () {
                                                                      String tempPic = controller.pickupController.text;
                                                                      String tempDrop = controller.dropOffController.text;
                                                                      controller.pickupController.text = tempDrop;
                                                                      controller.dropOffController.text = tempPic;
                                                                      controller.dropDownShow.value = false;
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

                                                      // (7) Zone Dropdown
                                                      Expanded(
                                                        flex: 5,
                                                        child: Obx(
                                                              () => Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 6.0, left: 15.0),
                                                                child: SizedBox(
                                                                  width: 40,
                                                                  // Baki fields (MOB/LEAD) ke sath perfect line up ke liye
                                                                  child: Text(
                                                                    "ZONE",
                                                                    style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: FocusTraversalOrder(
                                                                  order: const NumericFocusOrder(7),
                                                                  child: CustomDropdownField<ZoneObject>(
                                                                    label: "SELECT ZONE",
                                                                    width: fieldWidthh / 10.5,
                                                                    height: 30,
                                                                    items: _controller.updateDLocationValue.value == true ? [] : _controller.locationtypezoneModel!.zonesList!,
                                                                    value: _controller.zoneDValue,
                                                                    itemLabel: (templateList) => templateList.name!,
                                                                    onChanged: (val) {
                                                                      controller.dropDownShow.value = false;
                                                                      _controller.zoneDValue = val;
                                                                      controller.dashboardDZoneValue = val;
                                                                      controller.update();
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      SizedBox(width: 55),

                                                      //  DROP NOTES
                                                      Expanded(
                                                        flex: 3,
                                                        child: FocusTraversalOrder(
                                                          order: const NumericFocusOrder(8),
                                                          child: SizedBox(
                                                            height: 30,
                                                            child: CustomTextField(
                                                              width: fieldWidthh / 15,
                                                              controller: controller.dropUpNoteController,
                                                              hintText: "DROP NOTES",
                                                              inputFormatters: [
                                                                UpperCaseTextFormatter(),
                                                              ],
                                                              borderRadius: 6,
                                                              onTap: () {
                                                                controller.dropDownShow.value = false;
                                                              },
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
                                            // SizedBox(
                                            //   height: 6
                                            //       /*screenHeight *
                                            //           0.01*/,
                                            // ),

                                            Align(
                                              alignment:
                                              Alignment
                                                  .centerLeft,
                                              child:
                                              Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    left:
                                                    8),
                                                child:
                                                Wrap(
                                                  spacing:
                                                  10,
                                                  runSpacing:
                                                  2,
                                                  runAlignment:
                                                  WrapAlignment.start,
                                                  crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                                  alignment:
                                                  WrapAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      // Aligns items at the top
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        // Name Fields
                                                        Expanded(
                                                          child: FocusTraversalOrder(
                                                            order: const NumericFocusOrder(9),
                                                            child: labeledTextField(context, isMobile, AppText.name, controller.nameController, width: fieldWidthh / 12, onTap: () {
                                                              controller.dropDownShow.value = false;
                                                            }, textInputAction: TextInputAction.next),
                                                          ),
                                                        ),
                                                        // Email Fields
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 0),
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(10),
                                                              child: labeledTextField(
                                                                context,
                                                                isMobile,
                                                                AppText.email,
                                                                controller.emailController,
                                                                width: fieldWidthh / 12,
                                                                textInputAction: TextInputAction.next,
                                                                onTap: () {
                                                                  controller.dropDownShow.value = false;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // MOB fields
                                                        // Expanded(
                                                        //   child: Row(
                                                        //     children: [
                                                        //       Padding(
                                                        //         padding: const EdgeInsets.only(
                                                        //           right: 8.0, // Thoda spacing barha diya taake text clear rahe
                                                        //         ),
                                                        //         child: Text(
                                                        //           AppText.mobile,
                                                        //           style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                        //         ),
                                                        //       ),
                                                        //       // TextField ko Expanded me wrap kiya taake bachi hui saari jagah khud lele
                                                        //       Expanded(
                                                        //         child: FocusTraversalOrder(
                                                        //           order: const NumericFocusOrder(11),
                                                        //           child: RawKeyboardListener(
                                                        //             focusNode: controller.phoneKeyboardFocusNode,
                                                        //             onKey: (event) {
                                                        //               if (event is RawKeyDownEvent) {
                                                        //                 if (event.logicalKey == LogicalKeyboardKey.arrowDown && suggestion_controller.highlightedIndex.value < suggestion_controller.allListData.length - 1) {
                                                        //                   suggestion_controller.highlightedIndex.value++;
                                                        //                 } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && suggestion_controller.highlightedIndex.value > 0) {
                                                        //                   suggestion_controller.highlightedIndex.value--;
                                                        //                 } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                                        //                   final selected = suggestion_controller.allListData[suggestion_controller.highlightedIndex.value].name;
                                                        //                   suggestion_controller.selectSuggestion(selected);
                                                        //                 } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.tab) {
                                                        //                   FocusScope.of(Get.context!).requestFocus(controller.suggestionPhoneFocusNode.value);
                                                        //                   FocusScope.of(Get.context!).requestFocus(controller.suggestionPhoneFocusNode.value);
                                                        //                   controller.update();
                                                        //                 }
                                                        //               }
                                                        //             },
                                                        //             child: CustomTextField(
                                                        //               focusNode: controller.phoneNumberFieldKey,
                                                        //               controller: controller.mobileController,
                                                        //               borderRadius: 3,
                                                        //               inputFormatters: [
                                                        //                 FilteringTextInputFormatter.digitsOnly
                                                        //               ],
                                                        //               onTap: () {
                                                        //                 controller.dropDownShow.value = true;
                                                        //               },
                                                        //               onChanged: (v) {
                                                        //                 if (v.isNotEmpty) {
                                                        //                   controller.dropDownShow.value = true;
                                                        //                   FocusScope.of(Get.context!).requestFocus(controller.phoneNumberFieldKey);
                                                        //                   controller.onPhoneNoChangeHandler(fieldName: "Phone Number", searchingText: v);
                                                        //                 } else {
                                                        //                   controller.dropDownShow.value = false;
                                                        //                 }
                                                        //               },
                                                        //                ),
                                                        //           ),
                                                        //         ),
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                        // (8) Mobile Field - (Aapka original code baseline alignment ke sath)
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                  right: 6.0,
                                                                ),
                                                                child: SizedBox(
                                                                  width: 40,
                                                                  // Dono labels ko ek barabar width di taake text boxes perfectly align hon
                                                                  child: Text(AppText.mobile, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: FocusTraversalOrder(
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
                                                                          }
                                                                        }
                                                                      },
                                                                      child: CustomTextField(
                                                                        focusNode: controller.phoneNumberFieldKey,
                                                                        controller: controller.mobileController,
                                                                        borderRadius: 3,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.digitsOnly
                                                                        ],
                                                                        onTap: () {
                                                                          controller.dropDownShow.value = true;
                                                                        },
                                                                        onChanged: (v) {
                                                                          if (v.isNotEmpty) {
                                                                            controller.dropDownShow.value = true;
                                                                            FocusScope.of(Get.context!).requestFocus(controller.phoneNumberFieldKey);
                                                                            controller.onPhoneNoChangeHandler(fieldName: "Phone Number", searchingText: v);
                                                                          } else {
                                                                            controller.dropDownShow.value = false;
                                                                          }
                                                                        },
                                                                      )),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Tel fileds
                                                        // Expanded(
                                                        //   child: Padding(
                                                        //     padding:
                                                        //     const EdgeInsets.only(left: 4),
                                                        //     child:
                                                        //     FocusTraversalOrder(
                                                        //       order: const NumericFocusOrder(12),
                                                        //       child: labeledTextField
                                                        //         (context, isMobile, AppText.tel, controller.telController,
                                                        //         width: fieldWidthh / 12,
                                                        //         // width: fieldWidth / 3,
                                                        //         textInputAction: TextInputAction.next,
                                                        //         keyboardType: TextInputType.phone,
                                                        //         formatDigitsOnly: false,
                                                        //         onChanged: (v){
                                                        //           controller.dropDownShow.value = false;
                                                        //         },
                                                        //         onTap: (){
                                                        //           controller.dropDownShow.value = false;
                                                        //         },
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 30),
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(12),
                                                              child: labeledTextField(
                                                                context,
                                                                isMobile,
                                                                AppText.tel,
                                                                // Agar controller me text 'null' ya null hai, to usse empty '' kar do
                                                                (controller.telController.text == 'null' || controller.telController.text.isEmpty) ? (controller.telController..text = '') : controller.telController,
                                                                width: fieldWidthh / 15,
                                                                textInputAction: TextInputAction.next,
                                                                keyboardType: TextInputType.phone,
                                                                formatDigitsOnly: false,
                                                                onChanged: (v) {
                                                                  // Agar user type karte waqt shuruat me 'null' text aa jaye to clear karein (Safe check)
                                                                  if (v.startsWith('null')) {
                                                                    controller.telController.text = v.replaceAll('null', '');
                                                                    controller.telController.selection = TextSelection.fromPosition(
                                                                      TextPosition(offset: controller.telController.text.length),
                                                                    );
                                                                  }
                                                                  controller.dropDownShow.value = false;
                                                                },
                                                                onTap: () {
                                                                  // Tap karne par bhi agar 'null' likha hua ho to text field khali ho jaye
                                                                  if (controller.telController.text == 'null') {
                                                                    controller.telController.clear();
                                                                  }
                                                                  controller.dropDownShow.value = false;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      // Aligns items at the top
                                                      children: [
                                                        // (5) Date Field
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 5.0),
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(13),
                                                              child: labeledField(
                                                                context: context,
                                                                isMobile: isMobile,
                                                                label: AppText.date,
                                                                width: fieldWidthh / 12,
                                                                // width: null, // Let Expanded handle width
                                                                child: SizedBox(
                                                                  height: 30,
                                                                  child: KeyboardDatePicker(
                                                                    initialDate: controller.pickUpDate ?? DateTime.now(),
                                                                    borderClr: Colors.blue,
                                                                    onChanged: (date) async {
                                                                      controller.pickUpDate = date;
                                                                      controller.getFaresCalculation();
                                                                      controller.dropDownShow.value = false;

                                                                    },
                                                                    onSubmitted: (date) {
                                                                      print("User pressed enter: $date");
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        // const SizedBox(width: 12), // Uniform spacing

                                                        // (6) Time Field
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 8.0),
                                                            child: FocusTraversalOrder(
                                                              order: NumericFocusOrder(14),
                                                              child: labeledField(
                                                                context: context,
                                                                isMobile: isMobile,
                                                                label: AppText.time,
                                                                width: fieldWidthh / 12,
                                                                // width: null, // Removed hardcoded width
                                                                child: SizedBox(
                                                                  height: 30,
                                                                  child: CustomTimePicker(
                                                                    controller: controller.pickUpTimeController,
                                                                    onTimeSelected: (time) async {
                                                                      controller.pickUpTimeController.text = time;
                                                                      controller.getFaresCalculation();
                                                                      controller.dropDownShow.value = false;
                                                                      setState(() {});
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        // (7) Lead (mins) Field
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                  right: 6.0, // Same padding as MOB field
                                                                ),
                                                                child: SizedBox(
                                                                  width: 40,
                                                                  // MOB ke 'MOB' text aur LEAD ke 'LEAD' text ki width ko align karne ke liye explicit width
                                                                  child: Text(AppText.lead, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: FocusTraversalOrder(
                                                                  order: const NumericFocusOrder(15),
                                                                  child: SizedBox(
                                                                    height: 30,
                                                                    child: CustomTextField(
                                                                      hintText: "MINS",
                                                                      controller: controller.minController,
                                                                      borderRadius: 4,
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter.digitsOnly
                                                                      ],
                                                                      onTap: () => controller.dropDownShow.value = false,
                                                                      keyboardType: TextInputType.number,
                                                                      textInputAction: TextInputAction.next,
                                                                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        // const SizedBox(width: 12), // Uniform spacing

                                                        // (8) Journey dropdown
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 18.0),
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(16),
                                                              child: labeledField(
                                                                context: context,
                                                                isMobile: isMobile,
                                                                label: AppText.jour,
                                                                width: fieldWidthh / 15,
                                                                // width: null, // Removed hardcoded width
                                                                heights: 33,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(6),
                                                                    border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                  ),
                                                                  child: DropdownButtonFormField<JourneyTypeObject>(
                                                                    isExpanded: true,
                                                                    // Use true here so text reaches the icon and then clips
                                                                    decoration: const InputDecoration(
                                                                      /*border: OutlineInputBorder(),
                                                                                              isDense: true,
                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 2),
                                                                                              */
                                                                      // Remove the internal border since you have a Container border
                                                                      border: InputBorder.none,
                                                                      isDense: true,
                                                                      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                                                    ),
                                                                    // 3. You can also customize the icon to remove its default side padding
                                                                    icon: const Icon(Icons.arrow_drop_down, size: 20),

                                                                    padding: EdgeInsets.zero,

                                                                    value: controller.selectJourneyTypeValue,
                                                                    items: controller.dashboardAllData!.journeyTypes!
                                                                        .map((journey) => DropdownMenuItem<JourneyTypeObject>(
                                                                      value: journey,
                                                                      child: Text(
                                                                        (journey.journeyType ?? "").toUpperCase(),
                                                                        style: mozillaTextRegularText(
                                                                          fontSize: 12,
                                                                          color: DynamicColors.textClr,
                                                                        ),
                                                                      ),
                                                                    ))
                                                                        .toList(),
                                                                    onChanged: (v) {
                                                                      controller.dropDownShow.value = false;
                                                                      controller.jourValue = (v!.journeyType == "r/n") ? 'W/R' : null;
                                                                      controller.selectJourneyTypeValue = v;
                                                                      controller.getFaresCalculation();
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    // (9) Driver dropdown
                                                    if (controller.jourValue ==
                                                        'W/R') ...[
                                                      // SizedBox(
                                                      //   height: 6,
                                                      //   // height: screenHeight * 0.01,
                                                      // ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 10.0),
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
                                                            // (3) Pickup textfield ------------------------------------------------------
//                                                             FocusTraversalOrder(
//                                                               order: const NumericFocusOrder(17),
//                                                               child: SizedBox(
//                                                                 width: fieldWidth / 1.2,
//                                                                 height: 30,
//                                                                 child: RawKeyboardListener(
//                                                                   focusNode: controller.pickupTwoWayKeyboardFocusNode,
//                                                                   onKey: (event) {
//                                                                     if (event is RawKeyDownEvent) {
//                                                                       if (event.logicalKey == LogicalKeyboardKey.arrowDown && controller.highlightedIndex.value < controller.suggestions.length - 1) {
//                                                                         controller.highlightedIndex.value++;
//                                                                       } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && controller.highlightedIndex.value > 0) {
//                                                                         controller.highlightedIndex.value--;
//                                                                       } else if (event.logicalKey == LogicalKeyboardKey.enter) {
//                                                                         final selected = controller.suggestions[controller.highlightedIndex.value].name;
//                                                                         controller.selectSuggestion(selected);
//                                                                       } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.tab) {
//                                                                         FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
//                                                                       }
//                                                                     }
//                                                                   },
//                                                                   child: CustomTextField(
//                                                                     key: controller.pickupTwoWayFieldKey,
//                                                                     controller: controller.pickupTwoWayController,
//                                                                     focusNode: controller.pickupTwoTextFieldFocusNode,
//                                                                     hintText: 'PICKUP LOCATION',
//                                                                     inputFormatters: [
//                                                                       UpperCaseTextFormatter(),
//                                                                     ],
//                                                                     borderRadius: 4,
//                                                                     prefixIcon: const Icon(
//                                                                       Icons.location_pin,
//                                                                       color: Colors.red,
//                                                                       size: 20,
//                                                                     ),
//                                                                     textInputAction: TextInputAction.next,
//                                                                     onTap: () {
//                                                                       shortCutKeyValue.value = "PICKUP Two Way LOCATION";
//                                                                       controller.dropDownShow.value = true;
//                                                                     },
//                                                                     onChanged: (v) {
//                                                                       controller.onChangeHandler(fieldName: "PICKUP TWO WAY LOCATION", searchingText: v);
//                                                                     },
//                                                                     onSubmitted: (_) => FocusScope.of(context).nextFocus(),
//                                                                     suffixIcon: Row(
//                                                                       mainAxisAlignment: MainAxisAlignment.end,
//                                                                       mainAxisSize: MainAxisSize.min,
//                                                                       children: [
//                                                                         controller.pickupTwoWayController.text.isEmpty
//                                                                             ? SizedBox.shrink()
//                                                                             :
//                                                                         //      KbdActivatable(
//                                                                         //   focusNode: clearPicTwo,
//                                                                         //   onActivate: () {
//                                                                         //     FocusScope.of(Get.context!).requestFocus(controller.pickupTwoTextFieldFocusNode);
//                                                                         //     controller.markers.clear();
//                                                                         //     controller.fixedFare.value = "0";
//                                                                         //     controller.returnFareValue = "";
//                                                                         //     controller.slugControllerReturn.clear();
//                                                                         //     controller.slugController.clear();
//                                                                         //     controller.polyLineMarkerInfo.clear();
//                                                                         //     controller.pickupTwoWayController.clear();
//                                                                         //     controller.dropOffTwoWayController.clear();
//                                                                         //     controller.pickupController.clear();
//                                                                         //     controller.dropOffController.clear();
//                                                                         //     controller.polylinePoints.clear();
//                                                                         //     controller.fetchRouteFromOSRM();
//                                                                         //     controller.fixedFare.value = "0";
//                                                                         //     controller.totalDistance.value = "0";
//                                                                         //     controller.totalTimeDuration.value = "0";
//                                                                         //     controller.dropDownShow.value = false;
//                                                                         //     controller.update();

//                                                                         //     // controller.fetchRouteFromOSRM();
//                                                                         //   },
//                                                                         //   child: Icon(
//                                                                         //     Icons.close,
//                                                                         //     color: DynamicColors.redClr,
//                                                                         //     size: 15,
//                                                                         //   ),
//                                                                         // ),

//                                                                        // (3) Pickup textfield - Clear button logic section
// KbdActivatable(
//   focusNode: clearPicTwo,
//   onActivate: () {
//     FocusScope.of(Get.context!).requestFocus(controller.pickupTwoTextFieldFocusNode);
//     controller.markers.clear();
//     controller.fixedFare.value = "0";
//     controller.returnFareValue = "";
//     controller.slugControllerReturn.clear();
//     controller.slugController.clear();
//     controller.polyLineMarkerInfo.clear();

//     // ONLY CLEARING TWO-WAY FIELDS NOW
//     controller.pickupTwoWayController.clear();
//     controller.dropOffTwoWayController.clear();

//     // REMOVED: controller.pickupController.clear();
//     // REMOVED: controller.dropOffController.clear();

//     controller.polylinePoints.clear();
//     controller.fetchRouteFromOSRM();
//     controller.fixedFare.value = "0";
//     controller.totalDistance.value = "0";
//     controller.totalTimeDuration.value = "0";
//     controller.dropDownShow.value = false;
//     controller.update();
//   },
//   child: Icon(
//     Icons.close,
//     color: DynamicColors.redClr,
//     size: 15,
//   ),
// ),
//                                                                         KbdActivatable(
//                                                                           focusNode: swap1FNTwoWay,
//                                                                           onActivate: () {
//                                                                             String tempPic = controller.pickupTwoWayController.text;
//                                                                             String tempDrop = controller.dropOffTwoWayController.text;
//                                                                             controller.pickupTwoWayController.text = tempDrop;
//                                                                             controller.dropOffTwoWayController.text = tempPic;
//                                                                             controller.dropDownShow.value = false;
//                                                                             controller.update();
//                                                                           },
//                                                                           child: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 20),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),

                                                            // (3) Pickup textfield TWO WAY ------------------------------------------------------
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
                                                                    inputFormatters: [
                                                                      UpperCaseTextFormatter()
                                                                    ],
                                                                    borderRadius: 4,
                                                                    prefixIcon: const Icon(Icons.location_pin, color: Colors.red, size: 20),
                                                                    textInputAction: TextInputAction.next,
                                                                    onTap: () {
                                                                      shortCutKeyValue.value = "PICKUP Two Way LOCATION";
                                                                      controller.dropDownShow.value = true;
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
                                                                            ? const SizedBox.shrink()
                                                                            : KbdActivatable(
                                                                          focusNode: clearPicTwo,
                                                                          onActivate: () {
                                                                            FocusScope.of(Get.context!).requestFocus(controller.pickupTwoTextFieldFocusNode);

                                                                            final pickupPolylineIndex = controller.polyLineMarkerInfo
                                                                                .indexWhere((e) => e.markerType == "PICKUP TWO WAY LOCATION");

                                                                            if (pickupPolylineIndex >= 0) {
                                                                              controller.polyLineMarkerInfo.removeAt(pickupPolylineIndex);
                                                                            }

                                                                            final dropPolylineIndex = controller.polyLineMarkerInfo
                                                                                .indexWhere((e) => e.markerType == "DROP TWO WAY LOCATION");

                                                                            if (dropPolylineIndex >= 0) {
                                                                              controller.polyLineMarkerInfo.removeAt(dropPolylineIndex);
                                                                            }

                                                                            final pickupMarkerIndex =
                                                                            controller.markers.indexWhere((e) => e.type == "pickup two way");

                                                                            if (pickupMarkerIndex >= 0) {
                                                                              controller.markers.removeAt(pickupMarkerIndex);
                                                                            }

                                                                            final dropOffMarkerIndex =
                                                                            controller.markers.indexWhere((e) => e.type == "dropOff two way");

                                                                            if (dropOffMarkerIndex >= 0) {
                                                                              controller.markers.removeAt(dropOffMarkerIndex);
                                                                            }

                                                                            // 1. Sirf Two-Way waale controllers ko clear karein
                                                                            controller.pickupTwoWayController.clear();
                                                                            controller.dropOffTwoWayController.clear();

                                                                            // 2. POORI list clear karne ke bajaye, sirf TWO WAY waale markers remove karein
                                                                            controller.polyLineMarkerInfo.removeWhere((item) => item.markerType == "PICKUP TWO WAY LOCATION");

                                                                            // Agar aap `controller.markers` alag se use kar rahe hain (CustomMarker waala)
                                                                            // toh usme se bhi sirf Two-Way waale filters nikalein:
                                                                            if (controller.markers is List<CustomMarker>) {
                                                                              controller.markers.removeWhere((marker) => marker.type == "PICKUP TWO WAY LOCATION");
                                                                            }
                                                                            controller.tempStoreReturnMils = null;
                                                                            // 3. Baki states ko reset karein
                                                                            // controller.fixedFare.value = "0";
                                                                            controller.returnFareValue = "";
                                                                            // controller.slugControllerReturn.clear();
                                                                            // // controller.slugController.clear();
                                                                            // controller.dropDownShow.value = false;
                                                                            // controller.tempStoreMils = null;

                                                                            // 4. Route ko recalculate karein (Yeh ab bache hue 1st pickup/dropoff ka route banayega)
                                                                            // controller.fetchRouteFromOSRM();

                                                                            controller.update();
                                                                          },
                                                                          child: Icon(Icons.close, color: DynamicColors.redClr, size: 15),
                                                                        ),
                                                                        KbdActivatable(
                                                                          focusNode: swap1FNTwoWay,
                                                                          onActivate: () {
                                                                            String tempPic = controller.pickupTwoWayController.text;
                                                                            String tempDrop = controller.dropOffTwoWayController.text;
                                                                            controller.pickupTwoWayController.text = tempDrop;
                                                                            controller.dropOffTwoWayController.text = tempPic;
                                                                            controller.dropDownShow.value = false;
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

                                                            Expanded(
                                                              flex: 5,
                                                              child: Obx(
                                                                    () => Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 6.0, left: 15.0),
                                                                      child: SizedBox(
                                                                        width: 40,
                                                                        // Perfect alignment ke liye baqi pages jitna hi size rakha hai
                                                                        child: Text(
                                                                          "ZONE",
                                                                          style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: FocusTraversalOrder(
                                                                        order: const NumericFocusOrder(18),
                                                                        child: CustomDropdownField<ZoneObject>(
                                                                          label: "SELECT ZONE",
                                                                          width: fieldWidthh / 10.5,
                                                                          // Hardcoded width hata di taake flex perfect chale
                                                                          height: 30,
                                                                          items: _controller.updateRNLocationValue.value == true ? [] : _controller.locationtypezoneModel!.zonesList!,
                                                                          value: _controller.RNzoneValue,
                                                                          itemLabel: (templateList) => templateList.name!,
                                                                          onChanged: (val) {
                                                                            controller.dropDownShow.value = false;
                                                                            _controller.RNzoneValue = val;
                                                                            controller.dashboardRNZoneValue = val;
                                                                            controller.update();
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            // Dono fields ke darmiyan ka fasla (Aapki original 10.0 spacing)
                                                            const SizedBox(width: 55.0),

                                                            // (3) Pickup notes - (Flex: 3 aur bina label ke)
                                                            Expanded(
                                                              flex: 3,
                                                              child: FocusTraversalOrder(
                                                                order: const NumericFocusOrder(19),
                                                                child: SizedBox(
                                                                  height: 30,
                                                                  child: CustomTextField(
                                                                    width: fieldWidthh / 15.0,
                                                                    // Hardcoded width hata di taake notes field sahi se responsive ho
                                                                    controller: controller.pickUpNoteController,
                                                                    hintText: "PICKUP NOTES",
                                                                    borderRadius: 6,
                                                                    onTap: () {
                                                                      controller.dropDownShow.value = false;
                                                                    },
                                                                    textInputAction: TextInputAction.next,
                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 10.0),
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
                                                            // (4) Dropoff textfield --------------------------------------------------------
                                                            //                                                             FocusTraversalOrder(
                                                            //                                                               order: const NumericFocusOrder(20),
                                                            //                                                               child: SizedBox(
                                                            //                                                                 width: fieldWidth / 1.2,
                                                            //                                                                 height: 30,
                                                            //                                                                 child: RawKeyboardListener(
                                                            //                                                                   focusNode: controller.dropOffTwoDayKeyboardFocusNode,
                                                            //                                                                   onKey: (event) {
                                                            //                                                                     if (event is RawKeyDownEvent) {
                                                            //                                                                       if (event.logicalKey == LogicalKeyboardKey.arrowDown && controller.highlightedIndex.value < controller.suggestions.length - 1) {
                                                            //                                                                         controller.highlightedIndex.value++;
                                                            //                                                                       } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && controller.highlightedIndex.value > 0) {
                                                            //                                                                         controller.highlightedIndex.value--;
                                                            //                                                                       } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                                                            //                                                                         final selected = controller.suggestions[controller.highlightedIndex.value].name;
                                                            //                                                                         controller.selectSuggestion(selected);
                                                            //                                                                       } else if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.tab) {
                                                            //                                                                         FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                                            //                                                                       }
                                                            //                                                                     }
                                                            //                                                                   },
                                                            //                                                                   child: CustomTextField(
                                                            //                                                                     key: controller.dropOffTwoFieldKey,
                                                            //                                                                     controller: controller.dropOffTwoWayController,
                                                            //                                                                     focusNode: controller.dropOffTwoWayTextFieldFocusNode,
                                                            //                                                                     hintText: 'DROP LOCATION',
                                                            //                                                                     inputFormatters: [
                                                            //                                                                       UpperCaseTextFormatter(),
                                                            //                                                                     ],
                                                            //                                                                     onTap: () {
                                                            //                                                                       shortCutKeyValue.value = "DROP TWO WAY LOCATION";
                                                            //                                                                       controller.dropDownShow.value = true;
                                                            //                                                                     },
                                                            //                                                                     borderRadius: 4,
                                                            //                                                                     onChanged: (v) {
                                                            //                                                                       controller.onChangeHandler(fieldName: "DROP TWO WAY LOCATION", searchingText: v);
                                                            //                                                                     },
                                                            //                                                                     prefixIcon: const Icon(
                                                            //                                                                       Icons.location_pin,
                                                            //                                                                       color: Colors.red,
                                                            //                                                                       size: 20,
                                                            //                                                                     ),
                                                            //                                                                     textInputAction: TextInputAction.next,
                                                            //                                                                     onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                            //                                                                     suffixIcon: Row(
                                                            //                                                                       mainAxisSize: MainAxisSize.min,
                                                            //                                                                       mainAxisAlignment: MainAxisAlignment.end,
                                                            //                                                                       children: [
                                                            //                                                                         controller.dropOffTwoWayController.text.isEmpty
                                                            //                                                                             ? SizedBox.shrink()
                                                            //                                                                             :
                                                            //                                                                         //      KbdActivatable(
                                                            //                                                                         //   focusNode: clearDrop,
                                                            //                                                                         //   onActivate: () {
                                                            //                                                                         //     controller.tempStoreMils = null;
                                                            //                                                                         //     controller.fixedFare.value = "0";
                                                            //                                                                         //     controller.returnFareValue = "";
                                                            //                                                                         //     controller.slugControllerReturn.clear();
                                                            //                                                                         //     controller.slugController.clear();
                                                            //                                                                         //     FocusScope.of(Get.context!).requestFocus(controller.dropOffTwoWayTextFieldFocusNode);
                                                            //                                                                         //     controller.pickupController.clear();
                                                            //                                                                         //     controller.dropOffController.clear();
                                                            //                                                                         //     controller.dropOffTwoWayController.clear();
                                                            //                                                                         //     controller.markers.clear();
                                                            //                                                                         //     controller.polyLineMarkerInfo.clear();
                                                            //                                                                         //     controller.pickupController.clear();
                                                            //                                                                         //     controller.polylinePoints.clear();
                                                            //                                                                         //     controller.pickupTwoWayController.clear();
                                                            //                                                                         //     controller.fetchRouteFromOSRM();
                                                            //                                                                         //     controller.fixedFare.value = "0";
                                                            //                                                                         //     controller.totalDistance.value = "0";
                                                            //                                                                         //     controller.totalTimeDuration.value = "0";
                                                            //                                                                         //     controller.dropDownShow.value = false;
                                                            //                                                                         //     controller.update();
                                                            //                                                                         //   },
                                                            //                                                                         //   child: Icon(
                                                            //                                                                         //     Icons.close,
                                                            //                                                                         //     color: DynamicColors.redClr,
                                                            //                                                                         //     size: 15,
                                                            //                                                                         //   ),
                                                            //                                                                         // ),
                                                            //                                                                         // (4) Dropoff textfield - Clear button logic section
                                                            // KbdActivatable(
                                                            //   focusNode: clearDrop,
                                                            //   onActivate: () {
                                                            //     controller.tempStoreMils = null;
                                                            //     controller.fixedFare.value = "0";
                                                            //     controller.returnFareValue = "";
                                                            //     controller.slugControllerReturn.clear();
                                                            //     controller.slugController.clear();
                                                            //     FocusScope.of(Get.context!).requestFocus(controller.dropOffTwoWayTextFieldFocusNode);

                                                            //     // ONLY CLEARING TWO-WAY FIELDS NOW
                                                            //     controller.pickupTwoWayController.clear();
                                                            //     controller.dropOffTwoWayController.clear();

                                                            //     // REMOVED: controller.pickupController.clear();
                                                            //     // REMOVED: controller.dropOffController.clear();

                                                            //     controller.markers.clear();
                                                            //     controller.polyLineMarkerInfo.clear();
                                                            //     controller.polylinePoints.clear();
                                                            //     controller.fetchRouteFromOSRM();
                                                            //     controller.fixedFare.value = "0";
                                                            //     controller.totalDistance.value = "0";
                                                            //     controller.totalTimeDuration.value = "0";
                                                            //     controller.dropDownShow.value = false;
                                                            //     controller.update();
                                                            //   },
                                                            //   child: Icon(
                                                            //     Icons.close,
                                                            //     color: DynamicColors.redClr,
                                                            //     size: 15,
                                                            //   ),
                                                            // ),
                                                            //                                                                         KbdActivatable(
                                                            //                                                                           focusNode: swap2FNTwoWay,
                                                            //                                                                           onActivate: () {
                                                            //                                                                             String tempPic = controller.pickupTwoWayController.text;
                                                            //                                                                             String tempDrop = controller.dropOffTwoWayController.text;
                                                            //                                                                             controller.pickupTwoWayController.text = tempDrop;
                                                            //                                                                             controller.dropOffTwoWayController.text = tempPic;
                                                            //                                                                             controller.dropDownShow.value = false;
                                                            //                                                                             controller.update();
                                                            //                                                                           },
                                                            //                                                                           child: const Icon(Icons.swap_vert, color: Color(0xFF575797), size: 20),
                                                            //                                                                         ),
                                                            //                                                                       ],
                                                            //                                                                     ),
                                                            //                                                                   ),
                                                            //                                                                 ),
                                                            //                                                               ),
                                                            //                                                             ),
                                                            // (4) Dropoff textfield TWO WAY --------------------------------------------------------
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
                                                                    inputFormatters: [
                                                                      UpperCaseTextFormatter()
                                                                    ],
                                                                    onTap: () {
                                                                      shortCutKeyValue.value = "DROP TWO WAY LOCATION";
                                                                      controller.dropDownShow.value = true;
                                                                    },
                                                                    borderRadius: 4,
                                                                    onChanged: (v) {
                                                                      controller.onChangeHandler(fieldName: "DROP TWO WAY LOCATION", searchingText: v);
                                                                    },
                                                                    prefixIcon: const Icon(Icons.location_pin, color: Colors.red, size: 20),
                                                                    textInputAction: TextInputAction.next,
                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                    suffixIcon: Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        controller.dropOffTwoWayController.text.isEmpty
                                                                            ? const SizedBox.shrink()
                                                                            : KbdActivatable(
                                                                          focusNode: clearDrop,
                                                                          onActivate: () {
                                                                            FocusScope.of(Get.context!).requestFocus(controller.dropOffTwoWayTextFieldFocusNode);

                                                                            final pickupPolylineIndex = controller.polyLineMarkerInfo
                                                                                .indexWhere((e) => e.markerType == "PICKUP TWO WAY LOCATION");

                                                                            if (pickupPolylineIndex >= 0) {
                                                                              controller.polyLineMarkerInfo.removeAt(pickupPolylineIndex);
                                                                            }

                                                                            final dropPolylineIndex = controller.polyLineMarkerInfo
                                                                                .indexWhere((e) => e.markerType == "DROP TWO WAY LOCATION");

                                                                            if (dropPolylineIndex >= 0) {
                                                                              controller.polyLineMarkerInfo.removeAt(dropPolylineIndex);
                                                                            }

                                                                            final pickupMarkerIndex =
                                                                            controller.markers.indexWhere((e) => e.type == "pickup two way");

                                                                            if (pickupMarkerIndex >= 0) {
                                                                              controller.markers.removeAt(pickupMarkerIndex);
                                                                            }

                                                                            final dropOffMarkerIndex =
                                                                            controller.markers.indexWhere((e) => e.type == "dropOff two way");

                                                                            if (dropOffMarkerIndex >= 0) {
                                                                              controller.markers.removeAt(dropOffMarkerIndex);
                                                                            }

                                                                            // 1. Only Two-Way controllers clear karein
                                                                            controller.pickupTwoWayController.clear();
                                                                            controller.dropOffTwoWayController.clear();

                                                                            // 2. Specific filtering lagayein pure clear ke bajaye
                                                                            // controller.polyLineMarkerInfo.removeWhere((item) => item.markerType == "DROP TWO WAY LOCATION");
                                                                            //
                                                                            // if (controller.markers is List<CustomMarker>) {
                                                                            //   controller.markers.removeWhere((marker) => marker.type == "DROP TWO WAY LOCATION");
                                                                            // }

                                                                            // 3. Fares aur temporaries reset
                                                                            controller.tempStoreMils = null;
                                                                            // // controller.fixedFare.value = "0";
                                                                            controller.returnFareValue = "";
                                                                            controller.tempStoreReturnMils = null;
                                                                            // controller.slugControllerReturn.clear();
                                                                            // // controller.slugController.clear();
                                                                            // // controller.totalDistance.value = "0";
                                                                            // // controller.totalTimeDuration.value = "0";
                                                                            // controller.dropDownShow.value = false;

                                                                            // 4. Update Route
                                                                            controller.fetchRouteFromOSRM();

                                                                            controller.update();
                                                                          },
                                                                          child: Icon(Icons.close, color: DynamicColors.redClr, size: 15),
                                                                        ),
                                                                        KbdActivatable(
                                                                          focusNode: swap2FNTwoWay,
                                                                          onActivate: () {
                                                                            String tempPic = controller.pickupTwoWayController.text;
                                                                            String tempDrop = controller.dropOffTwoWayController.text;
                                                                            controller.pickupTwoWayController.text = tempDrop;
                                                                            controller.dropOffTwoWayController.text = tempPic;
                                                                            controller.dropDownShow.value = false;
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
                                                            // Select Zone Dropdown - (Flex: 5, width: null, label: "ZONE")
                                                            Expanded(
                                                              flex: 5,
                                                              child: Obx(
                                                                    () => Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 6.0, left: 15.0),
                                                                      child: SizedBox(
                                                                        width: 40,
                                                                        // Perfect alignment ke liye baqi saari fields jitna size
                                                                        child: Text(
                                                                          "ZONE",
                                                                          style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: FocusTraversalOrder(
                                                                        order: const NumericFocusOrder(21),
                                                                        child: CustomDropdownField<ZoneObject>(
                                                                          label: "SELECT ZONE",
                                                                          width: fieldWidthh / 10.5,
                                                                          // Hardcoded width hata di taake flex responsive chale
                                                                          height: 30,
                                                                          items: _controller.updateRN1LocationValue.value == true ? [] : _controller.locationtypezoneModel!.zonesList!,
                                                                          value: _controller.RN1zoneValue,
                                                                          itemLabel: (templateList) => templateList.name!,
                                                                          onChanged: (val) {
                                                                            controller.dropDownShow.value = false;
                                                                            _controller.RN1zoneValue = val;
                                                                            controller.dashboardRN1ZoneValue = val;
                                                                            controller.update();
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

// Dono fields ke darmiyan ka fasla
                                                            const SizedBox(width: 55.0),

// (3) Drop Notes - (Flex: 3 aur bina label ke)
                                                            Expanded(
                                                              flex: 3,
                                                              child: FocusTraversalOrder(
                                                                order: const NumericFocusOrder(22),
                                                                child: SizedBox(
                                                                  height: 30,
                                                                  child: CustomTextField(
                                                                    width: fieldWidthh / 15,
                                                                    // Hardcoded width hata di taake layout block na ho
                                                                    controller: controller.dropUpNoteController,
                                                                    hintText: "DROP NOTES",
                                                                    borderRadius: 6,
                                                                    onTap: () {
                                                                      controller.dropDownShow.value = false;
                                                                    },
                                                                    textInputAction: TextInputAction.next,
                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(23),
                                                              child: labeledField(
                                                                context: context,
                                                                isMobile: isMobile,
                                                                label: "R/${AppText.date}",
                                                                width: fieldWidthh / 12,
                                                                widthss: 6,
                                                                child: SizedBox(
                                                                    height: 30,
                                                                    child: KeyboardDatePicker(
                                                                      initialDate: controller.pickUpDateReturn ?? DateTime.now(),
                                                                      borderClr: Colors.blue,
                                                                      onChanged: (date) {
                                                                        controller.dropDownShow.value = false;
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
                                                          ),
                                                          SizedBox(
                                                            width: fieldWidthh / 150,
                                                          ),

                                                          // (6) Time
                                                          SizedBox(
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(24),
                                                              child: labeledField(
                                                                context: context,
                                                                isMobile: isMobile,
                                                                label: "R/${AppText.time}",
                                                                width: fieldWidthh / 12.5,
                                                                child: SizedBox(
                                                                    height: 30,
                                                                    child: CustomTimePicker(
                                                                      controller: controller.pickUpTimeControllerReturn,
                                                                      // optional
                                                                      onTimeSelected: (time) {
                                                                        controller.dropDownShow.value = false;
                                                                        controller.pickUpTimeControllerReturn.text = time;
                                                                        controller.getFaresCalculation();
                                                                        setState(() {});
                                                                      },
                                                                    )),
                                                              ),
                                                            ),
                                                          ),

                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          // (7) Lead (mins)
                                                          SizedBox(
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(25),
                                                              child: labeledField(
                                                                context: context,
                                                                isMobile: isMobile,
                                                                label: "R/${AppText.lead}",
                                                                width: fieldWidthh / 10.5,
                                                                child: SizedBox(
                                                                  height: 30,
                                                                  child: CustomTextField(
                                                                    hintText: "MINS",
                                                                    controller: controller.minControllerReturn,
                                                                    borderRadius: 4,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter.digitsOnly
                                                                    ],
                                                                    onTap: () {
                                                                      controller.dropDownShow.value = false;
                                                                    },
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          SizedBox(
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(26),
                                                              child: labeledField(
                                                                context: context,
                                                                isMobile: isMobile,
                                                                label: "R/${AppText.fare}",
                                                                // widthss: 15,
                                                                width: fieldWidthh / 15,
                                                                child: SizedBox(
                                                                  height: 30,
                                                                  child: CustomTextField(
                                                                    hintText: "R/FARE",
                                                                    controller: controller.slugControllerReturn,
                                                                    readOnly: true,
                                                                    borderRadius: 6,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter.digitsOnly,
                                                                      LengthLimitingTextInputFormatter(6),
                                                                    ],
                                                                    onTap: () {
                                                                      controller.dropDownShow.value = false;
                                                                    },
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // ---------------------------------------------------- checkBox
                                                      // Row(
                                                      //
                                                      //   children: [
                                                      //     Expanded(
                                                      //       child: FocusTraversalOrder(
                                                      //         order: const NumericFocusOrder(27),
                                                      //         child: SizedBox(
                                                      //           width: fieldWidth / 2,
                                                      //           // height: 50 ,
                                                      //           // width: fieldWidth/6,
                                                      //           child: Row(
                                                      //             mainAxisSize: MainAxisSize.min,
                                                      //             children: [
                                                      //               RawKeyboardListener(
                                                      //                 focusNode: checkboxFocusReturn,
                                                      //                 onKey: (event) {
                                                      //                   if (event is RawKeyDownEvent && (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.space)) {
                                                      //                     setState(() {
                                                      //                       // controller.smsCheckbox.value = !controller.smsCheckbox.value; // ✅ toggle
                                                      //                     });
                                                      //                   }
                                                      //                 },
                                                      //                 child: Padding(
                                                      //                   padding: const EdgeInsets.only(left: 20),
                                                      //                   child: Checkbox(
                                                      //                     activeColor: DynamicColors.primaryClr,
                                                      //                     value: controller.addReturnFare.value,
                                                      //                     onChanged: (v) {
                                                      //                       // controller.smsCheckbox.value = v!;
                                                      //                       // controller.update();
                                                      //                     },
                                                      //                   ),
                                                      //                 ),
                                                      //               ),
                                                      //               Text(
                                                      //                 "ADD RETURN FARE",
                                                      //                 style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //
                                                      //     // Expanded(
                                                      //     //   child: FocusTraversalOrder(
                                                      //     //     order: const NumericFocusOrder(28),
                                                      //     //     child: labeledField(
                                                      //     //       context: context,
                                                      //     //       isMobile: isMobile,
                                                      //     //       label: "Return/${AppText.veh} ",
                                                      //     //       width: fieldWidth / 3,
                                                      //     //       heights: 32,
                                                      //     //       child: Container(
                                                      //     //         // height: 35,
                                                      //     //         decoration: BoxDecoration(
                                                      //     //           borderRadius: BorderRadius.circular(6),
                                                      //     //           border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                      //     //         ),
                                                      //     //         child: DropdownButtonFormField<DashboardVehicleTypeObject>(
                                                      //     //           decoration: const InputDecoration(
                                                      //     //             border: OutlineInputBorder(),
                                                      //     //             isDense: true,
                                                      //     //           ),
                                                      //     //           value: controller.selectVehicleValueReturn,
                                                      //     //           items: controller.dashboardAllData!.vehicleTypes!
                                                      //     //               .map((vehicle) => DropdownMenuItem<DashboardVehicleTypeObject>(
                                                      //     //             value: vehicle,
                                                      //     //             child: Text(
                                                      //     //               vehicle.name ?? "",
                                                      //     //               style: mozillaTextRegularText(
                                                      //     //                 fontSize: 10,
                                                      //     //                 color: DynamicColors.textClr,
                                                      //     //               ),
                                                      //     //             ),
                                                      //     //           ))
                                                      //     //               .toList(),
                                                      //     //           onChanged: (v) async {
                                                      //     //             controller.selectVehicleValueReturn = v;
                                                      //     //             controller.dropDownShow.value = false;
                                                      //     //             final fare = await getActiveFareForVehicle(
                                                      //     //               controller.dashboardAllData!.fareConfigurations!,
                                                      //     //               controller.selectVehicleValue!.id!,
                                                      //     //             );
                                                      //     //             if (fare != null) {
                                                      //     //               print(
                                                      //     //                 'Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}',
                                                      //     //               );
                                                      //     //
                                                      //     //               double inttt = (double.parse(controller.totalDistance.value) - double.parse(fare.minimumMiles.toString()));
                                                      //     //
                                                      //     //               controller.fixedFare.value = (inttt * double.parse(fare.minimumFares.toString())).toString();
                                                      //     //             } else {
                                                      //     //               print('No active fare found for this vehicle');
                                                      //     //             }
                                                      //     //             controller.update();
                                                      //     //           },
                                                      //     //         ),
                                                      //     //       ),
                                                      //     //     ),
                                                      //     //   ),
                                                      //     // ),
                                                      //     Expanded(
                                                      //       child: FocusTraversalOrder(
                                                      //         order: const NumericFocusOrder(28),
                                                      //         child: labeledField(
                                                      //           context: context,
                                                      //           isMobile: isMobile,
                                                      //           label: "Return/${AppText.veh} ",
                                                      //           width: fieldWidth / 3,
                                                      //           heights: 32,
                                                      //           child: Container(
                                                      //             decoration: BoxDecoration(
                                                      //               borderRadius: BorderRadius.circular(6),
                                                      //               border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                      //             ),
                                                      //             child: DropdownButtonFormField<DashboardVehicleTypeObject>(
                                                      //               // 1. isExpanded true karne se text katega nahi aur icon aakhir me chala jayega
                                                      //               isExpanded: true,
                                                      //               decoration: const InputDecoration(
                                                      //                 // 2. Internal border ko none kiya taake double border issue na ho aur text ko jagah mile
                                                      //                 border: InputBorder.none,
                                                      //                 isDense: true,
                                                      //                 // 3. Padding thodi kam ki taake text vertical ya horizontal kooch na kate
                                                      //                 contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                                      //               ),
                                                      //               // 4. Dropdown icon ki padding aur size adjust ki
                                                      //               icon: const Icon(Icons.arrow_drop_down, size: 20),
                                                      //               value: controller.selectVehicleValueReturn,
                                                      //               items: controller.dashboardAllData!.vehicleTypes!
                                                      //                   .map((vehicle) => DropdownMenuItem<DashboardVehicleTypeObject>(
                                                      //                         value: vehicle,
                                                      //                         child: Text(
                                                      //                           vehicle.name ?? "",
                                                      //                           // Agar ab bhi text bada ho, to maxLines aur overflow handle karein
                                                      //                           maxLines: 1,
                                                      //                           overflow: TextOverflow.ellipsis,
                                                      //                           style: mozillaTextRegularText(
                                                      //                             fontSize: 12,
                                                      //                             // Font size 12 standard hai, aap 10 bhi rakh sakte hain
                                                      //                             color: DynamicColors.textClr,
                                                      //                           ),
                                                      //                         ),
                                                      //                       ))
                                                      //                   .toList(),
                                                      //               onChanged: (v) async {
                                                      //                 controller.selectVehicleValueReturn = v;
                                                      //                 controller.dropDownShow.value = false;
                                                      //
                                                      //                 // Note: Yahan aapne 'controller.selectVehicleValue!.id!' likha tha,
                                                      //                 // agar ye Return vehicle ke liye hai to shayad yahan 'v!.id!' ya 'controller.selectVehicleValueReturn!.id!' hona chahiye.
                                                      //                 final fare = await getActiveFareForVehicle(
                                                      //                   controller.dashboardAllData!.fareConfigurations!,
                                                      //                   v?.id ?? controller.selectVehicleValue!.id!,
                                                      //                 );
                                                      //
                                                      //                 if (fare != null) {
                                                      //                   print(
                                                      //                     'Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}',
                                                      //                   );
                                                      //
                                                      //                   double inttt = (double.parse(controller.totalDistance.value) - double.parse(fare.minimumMiles.toString()));
                                                      //
                                                      //                   controller.fixedFare.value = (inttt * double.parse(fare.minimumFares.toString())).toString();
                                                      //                 } else {
                                                      //                   print('No active fare found for this vehicle');
                                                      //                 }
                                                      //                 controller.update();
                                                      //               },
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //     Expanded(
                                                      //       child: FocusTraversalOrder(
                                                      //         order: const NumericFocusOrder(29),
                                                      //         child: labeledField(
                                                      //           context: context,
                                                      //           isMobile: isMobile,
                                                      //           label: "Return/${AppText.drv} ",
                                                      //           width: fieldWidthh / 13,
                                                      //           heights: 32,
                                                      //           child: Container(
                                                      //             // height: 35,
                                                      //             decoration: BoxDecoration(
                                                      //               borderRadius: BorderRadius.circular(6),
                                                      //               border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                      //             ),
                                                      //             child: DropdownButtonFormField<DashboardDriverObject>(
                                                      //               focusNode: controller.driverDropdownFocusNode,
                                                      //               isExpanded: true,
                                                      //               // Use true here so text reaches the icon and then clips
                                                      //               decoration: const InputDecoration(
                                                      //                 /*border: OutlineInputBorder(),
                                                      //               isDense: true,
                                                      //               contentPadding: EdgeInsets.symmetric(horizontal: 2),
                                                      //               */
                                                      //                 // Remove the internal border since you have a Container border
                                                      //                 border: InputBorder.none,
                                                      //                 isDense: true,
                                                      //                 contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                                      //               ),
                                                      //               // 3. You can also customize the icon to remove its default side padding
                                                      //               icon: const Icon(Icons.arrow_drop_down, size: 20),
                                                      //
                                                      //               padding: EdgeInsets.zero,
                                                      //               value: controller.selectDriverValueReturn,
                                                      //               items: controller.dashboardAllData!.drivers!
                                                      //                   .map((driver) => DropdownMenuItem<DashboardDriverObject>(
                                                      //                         value: driver,
                                                      //                         child: Text(
                                                      //                           driver.name ?? "",
                                                      //                           style: mozillaTextRegularText(
                                                      //                             fontSize: 12,
                                                      //                             color: DynamicColors.textClr,
                                                      //                           ),
                                                      //                         ),
                                                      //                       ))
                                                      //                   .toList(),
                                                      //
                                                      //               onTap: () {
                                                      //                 controller.dropDownShow.value = false;
                                                      //               },
                                                      //               onChanged: (v) {
                                                      //                 controller.selectDriverValueReturn = v;
                                                      //                 controller.update();
                                                      //               },
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // )
// ---------------------------------------------------- checkBox
                                                      // ---------------------------------------------------- checkBox
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(27),
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
                                                                        padding: const EdgeInsets.only(left: 10),
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
                                                          ),
                                                          SizedBox(
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(28),
                                                              child: Builder(
                                                                // Builder lagaya taake context safe rahe
                                                                builder: (context) {
                                                                  // --- JUGAD / DEFAULT ID LOGIC ---
                                                                  // Agar page load hote hi selectVehicleValueReturn null hai, lekin list me data hai
                                                                  if (controller.selectVehicleValueReturn == null && (controller.dashboardAllData?.vehicleTypes?.isNotEmpty ?? false)) {
                                                                    // Hum background me chupke se pehli gari (Saloon) assign kar dete hain
                                                                    controller.selectVehicleValueReturn = controller.dashboardAllData!.vehicleTypes!.first;

                                                                    // Aur bina tap kiye hi fare calculation ka function fire kar dete hain taake ID chali jaye
                                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                      controller.getFaresCalculation();
                                                                    });
                                                                  }

                                                                  // ---------------------------------

                                                                  return labeledField(
                                                                    context: context,
                                                                    isMobile: isMobile,
                                                                    label: "R/${AppText.veh} ",
                                                                    width: fieldWidth / 3,
                                                                    heights: 32,
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(6),
                                                                        border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                      ),
                                                                      child: DropdownButtonFormField<DashboardVehicleTypeObject>(
                                                                        isExpanded: true,
                                                                        decoration: const InputDecoration(
                                                                          border: InputBorder.none,
                                                                          isDense: true,
                                                                          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                                                        ),
                                                                        icon: const Icon(Icons.arrow_drop_down, size: 20),
                                                                        // Ab yahan har haal me default value show hogi
                                                                        value: controller.selectVehicleValueReturn,
                                                                        items: controller.dashboardAllData!.vehicleTypes!
                                                                            .map((vehicle) => DropdownMenuItem<DashboardVehicleTypeObject>(
                                                                          value: vehicle,
                                                                          child: Text(
                                                                            vehicle.name ?? "",
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: mozillaTextRegularText(
                                                                              fontSize: 12,
                                                                              color: DynamicColors.textClr,
                                                                            ),
                                                                          ),
                                                                        ))
                                                                            .toList(),
                                                                        onChanged: (v) async {
                                                                          if (v == null) return;
                                                                          controller.selectVehicleValueReturn = v;
                                                                          controller.dropDownShow.value = false;

                                                                          // Jab user khud badlega tab naye wale ki ID direct jayegi
                                                                          final fare = await getActiveFareForVehicle(
                                                                            controller.dashboardAllData!.fareConfigurations!,
                                                                            v.id!,
                                                                          );

                                                                          if (fare != null) {
                                                                            print('Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}');
                                                                            controller.getFaresCalculation();
                                                                            double inttt = (double.parse(controller.totalDistance.value) - double.parse(fare.minimumMiles.toString()));
                                                                            controller.fixedFare.value = (inttt * double.parse(fare.minimumFares.toString())).toString();
                                                                          } else {
                                                                            print('No active fare found for this vehicle');
                                                                          }
                                                                          controller.update();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: fieldWidthh / 150,
                                                          ),
                                                          SizedBox(
                                                            child: FocusTraversalOrder(
                                                              order: const NumericFocusOrder(29),
                                                              child: labeledField(
                                                                context: context,
                                                                isMobile: isMobile,
                                                                label: "R/${AppText.drv} ",
                                                                width: fieldWidthh / 10.4,
                                                                heights: 32,
                                                                child: Container(
                                                                  // height: 35,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(6),
                                                                    border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                  ),
                                                                  child: DropdownButtonFormField<DashboardDriverObject>(
                                                                    focusNode: controller.driverDropdownFocusNode,
                                                                    isExpanded: true,
                                                                    // Use true here so text reaches the icon and then clips
                                                                    decoration: const InputDecoration(
                                                                      /*border: OutlineInputBorder(),
                                                                                              isDense: true,
                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 2),
                                                                                              */
                                                                      // Remove the internal border since you have a Container border
                                                                      border: InputBorder.none,
                                                                      isDense: true,
                                                                      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                                                    ),
                                                                    // 3. You can also customize the icon to remove its default side padding
                                                                    icon: const Icon(Icons.arrow_drop_down, size: 20),

                                                                    padding: EdgeInsets.zero,
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

                                                                    onTap: () {
                                                                      controller.dropDownShow.value = false;
                                                                    },
                                                                    onChanged: (v) {
                                                                      controller.selectDriverValueReturn = v;
                                                                      controller.update();
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                    // (10) Fare (Slugg)

                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // (10) Fare Field
                                                        SizedBox(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 5.0),
                                                            child: FocusTraversalOrder(
                                                              order: NumericFocusOrder(controller.jourValue == 'W/R' ? 34 : 30),
                                                              child: labeledField(
                                                                context: context,
                                                                isMobile: isMobile,
                                                                label: AppText.fare,
                                                                // width: null, // Let Expanded handle this
                                                                width: fieldWidthh / 12,
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
                                                                    onTap: () => controller.dropDownShow.value = false,
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
                                                                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(width: fieldWidthh / 60),
                                                        // (11) Account Dropdown
                                                        SizedBox(
                                                          child: FocusTraversalOrder(
                                                            order: NumericFocusOrder(controller.jourValue == 'W/R' ? 35 : 31),
                                                            child: labeledField(
                                                              context: context,
                                                              isMobile: isMobile,
                                                              label: "${AppText.acc}  ",
                                                              width: fieldWidthh / 11.7,
                                                              // width: null,
                                                              heights: 32,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(6),
                                                                  border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                ),
                                                                child: DropdownButtonFormField<DashboardAccountObject>(
                                                                  isExpanded: true,
                                                                  // Use true here so text reaches the icon and then clips
                                                                  decoration: const InputDecoration(
                                                                    /*border: OutlineInputBorder(),
                                                                                              isDense: true,
                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 2),
                                                                                              */
                                                                    // Remove the internal border since you have a Container border
                                                                    border: InputBorder.none,
                                                                    isDense: true,
                                                                    contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                                                  ),
                                                                  // 3. You can also customize the icon to remove its default side padding
                                                                  icon: const Icon(Icons.arrow_drop_down, size: 20),

                                                                  padding: EdgeInsets.zero,

                                                                  value: controller.selectAccountValue,
                                                                  items: controller.dashboardAccountData?.accounts?.map((account) {
                                                                    return DropdownMenuItem<DashboardAccountObject>(
                                                                      value: account,
                                                                      child: Text(
                                                                        account.name ?? "",
                                                                        style: mozillaTextRegularText(fontSize: 12, color: DynamicColors.textClr),
                                                                      ),
                                                                    );
                                                                  }).toList() ??
                                                                      [],
                                                                  onTap: () => controller.dropDownShow.value = false,
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
                                                        SizedBox(width: fieldWidthh / 47),
                                                        // (12) Pay Dropdown
                                                        SizedBox(
                                                          child: FocusTraversalOrder(
                                                            order: NumericFocusOrder(controller.jourValue == 'W/R' ? 36 : 32),
                                                            child: labeledField(
                                                              context: context,
                                                              isMobile: isMobile,
                                                              label: AppText.pay,
                                                              width: fieldWidthh / 10.6,
                                                              // width: null,
                                                              heights: 32,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(6),
                                                                  border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                ),
                                                                child: DropdownButtonFormField<PaymentTypeObject>(
                                                                  isExpanded: true,
                                                                  // Use true here so text reaches the icon and then clips
                                                                  decoration: const InputDecoration(
                                                                    /*border: OutlineInputBorder(),
                                                                                              isDense: true,
                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 2),
                                                                                              */
                                                                    // Remove the internal border since you have a Container border
                                                                    border: InputBorder.none,
                                                                    isDense: true,
                                                                    contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                                                  ),
                                                                  // 3. You can also customize the icon to remove its default side padding
                                                                  icon: const Icon(Icons.arrow_drop_down, size: 20),

                                                                  padding: EdgeInsets.zero,
                                                                  value: controller.selectPaymentTypeValue,
                                                                  items: controller.dashboardAllData!.paymentTypes!.map((payment) {
                                                                    return DropdownMenuItem<PaymentTypeObject>(
                                                                      value: payment,
                                                                      child: Text(
                                                                        (payment.name ?? "").toUpperCase(),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 1,
                                                                        softWrap: false,
                                                                        style: mozillaTextRegularText(
                                                                          fontSize: 12,
                                                                          color: DynamicColors.textClr,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  onTap: () => controller.dropDownShow.value = false,
                                                                  onChanged: (v) {
                                                                    controller.selectPaymentTypeValue = v;
                                                                    controller.update();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: fieldWidthh / 55),
                                                        // Consistent spacing
                                                        // (13) Vehicle Dropdown
                                                        SizedBox(
                                                          child: FocusTraversalOrder(
                                                            order: NumericFocusOrder(controller.jourValue == 'W/R' ? 38 : 33),
                                                            child: labeledField(
                                                              context: context,
                                                              isMobile: isMobile,
                                                              label: AppText.veh,
                                                              width: fieldWidthh / 15,
                                                              // width: null,
                                                              heights: 32,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(6),
                                                                  border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                                ),
                                                                child: DropdownButtonFormField<DashboardVehicleTypeObject>(
                                                                  isExpanded: true,
                                                                  // Use true here so text reaches the icon and then clips
                                                                  decoration: const InputDecoration(
                                                                    /*border: OutlineInputBorder(),
                                                                                              isDense: true,
                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 2),
                                                                                              */
                                                                    // Remove the internal border since you have a Container border
                                                                    border: InputBorder.none,
                                                                    isDense: true,
                                                                    contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                                                  ),
                                                                  // 3. You can also customize the icon to remove its default side padding
                                                                  icon: const Icon(Icons.arrow_drop_down, size: 20),

                                                                  padding: EdgeInsets.zero,
                                                                  value: controller.selectVehicleValue,
                                                                  items: controller.dashboardAllData!.vehicleTypes!.map((vehicle) {
                                                                    return DropdownMenuItem<DashboardVehicleTypeObject>(
                                                                      value: vehicle,
                                                                      child: Text(
                                                                        vehicle.name ?? "",
                                                                        style: mozillaTextRegularText(fontSize: 12, color: DynamicColors.textClr),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  onTap: () => controller.dropDownShow.value = false,
                                                                  onChanged: (v) async {
                                                                    controller.selectVehicleValue = v;
                                                                    controller.getFaresCalculation();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    controller.selectAccountValue == null
                                                        ? SizedBox.shrink()
                                                        : FocusTraversalOrder(
                                                      order: NumericFocusOrder(controller.jourValue == 'W/R' ? 39 : 34),
                                                      child: labeledField(
                                                        context: context,
                                                        isMobile: isMobile,
                                                        label: "DEPT",
                                                        width: fieldWidthh / 13,
                                                        heights: 35,
                                                        child: Container(
                                                          // height: 35,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                            border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                          ),
                                                          child: DropdownButtonFormField<DepartmentObject>(
                                                            isExpanded: true,
                                                            // Use true here so text reaches the icon and then clips
                                                            decoration: const InputDecoration(
                                                              // Remove the internal border since you have a Container border
                                                              border: InputBorder.none,
                                                              isDense: true,
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                                            ),
                                                            // 3. You can also customize the icon to remove its default side padding
                                                            icon: const Icon(Icons.arrow_drop_down, size: 20),

                                                            padding: EdgeInsets.zero,
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
                                                            onTap: () {
                                                              controller.dropDownShow.value = false;
                                                            },
                                                            onChanged: (v) {
                                                              controller.selectDepartmentData = v;
                                                              controller.update();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Switch + Quotation
                                                    FocusTraversalOrder(
                                                      order: NumericFocusOrder(controller.jourValue == 'W/R' ? 40 : 35),
                                                      child: DynamicSwitch(
                                                        controller: controller.switchController,
                                                        activeColor: DynamicColors.primaryClr,
                                                        inactiveColor: DynamicColors.gryClr,
                                                        focusScale: 1.5,
                                                        onToggle: () {
                                                          controller.dropDownShow.value = false;
                                                          print("Switch toggled: ${controller.switchController.value}");
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      AppText.quotation,
                                                      style: mozillaTextSemiBoldText(context: context, fontSize: 13),
                                                    ),
                                                    // SMS Checkbox
                                                    FocusTraversalOrder(
                                                      order: NumericFocusOrder(controller.jourValue == 'W/R' ? 41 : 36),
                                                      child: SizedBox(
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
                                                                  controller.dropDownShow.value = false;
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
                                                      order: NumericFocusOrder(controller.jourValue == 'W/R' ? 42 : 37),
                                                      child: SizedBox(
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
                                                                  controller.dropDownShow.value = false;
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
                                                      // width: fieldWidth/2.0,
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          FocusTraversalOrder(
                                                            order: NumericFocusOrder(controller.jourValue == 'W/R' ? 43 : 38),
                                                            child: SizedBox(
                                                              width: 60,
                                                              height: 30,
                                                              child: CustomTextField(
                                                                hintText: "Pass".toUpperCase(),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                  LengthLimitingTextInputFormatter(2),
                                                                ],
                                                                onTap: () {
                                                                  controller.dropDownShow.value = false;
                                                                },
                                                                keyboardType: TextInputType.number,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                                                controller: controller.passController,
                                                                borderRadius: 4,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          FocusTraversalOrder(
                                                            order: NumericFocusOrder(controller.jourValue == 'W/R' ? 44 : 39),
                                                            child: SizedBox(
                                                              width: 60,
                                                              height: 30,
                                                              child: CustomTextField(
                                                                hintText: "Lugg".toUpperCase(),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                  LengthLimitingTextInputFormatter(2),
                                                                ],
                                                                onTap: () {
                                                                  controller.dropDownShow.value = false;
                                                                },
                                                                keyboardType: TextInputType.number,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                                                controller: controller.luggController,
                                                                borderRadius: 4,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          FocusTraversalOrder(
                                                            order: NumericFocusOrder(controller.jourValue == 'W/R' ? 45 : 40),
                                                            child: SizedBox(
                                                              width: 60,
                                                              height: 30,
                                                              child: CustomTextField(
                                                                hintText: "Slugg".toUpperCase(),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                  LengthLimitingTextInputFormatter(2),
                                                                ],
                                                                onTap: () {
                                                                  controller.dropDownShow.value = false;
                                                                },
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
                                                    SizedBox(width: 1),
                                                    Container(
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey.shade300,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          FocusTraversalOrder(
                                                            order: NumericFocusOrder(controller.jourValue == 'W/R' ? 46 : 41),
                                                            child: buildFocusableIcon(
                                                              icon: Icons.person,
                                                              focusNode: _focusNodes[0],
                                                              onPressed: () {
                                                                controller.dropDownShow.value = false;
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
                                                                controller.dropDownShow.value = false;
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
                                                                controller.dropDownShow.value = false;
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
                                                                controller.dropDownShow.value = false;
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
                                                    // SizedBox(width: 0.0),
                                                    FocusTraversalOrder(
                                                      order: NumericFocusOrder(controller.jourValue == 'W/R' ? 37 : 45),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: KbdActivatable(
                                                          focusNode: calendarFN,
                                                          onActivate: () {
                                                            controller.dropDownShow.value = false;
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
                                              height:
                                              10,
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
                                                  color: DynamicColors.secondaryClr),
                                              child:
                                              Wrap(
                                                spacing:
                                                10,
                                                runSpacing:
                                                16,
                                                children: [
                                                  SizedBox(
                                                      width: 30),
                                                  Icon(
                                                      Icons.access_time_filled_outlined,
                                                      color: DynamicColors.textClr,
                                                      size: 18),
                                                  SizedBox(
                                                      width: 2),
                                                  Text(
                                                      "ETA : ${controller.totalTimeDuration}",
                                                      style: TextStyle(color: DynamicColors.textClr, fontSize: 13)),
                                                  SizedBox(
                                                      width: 30),
                                                  Icon(
                                                      Icons.access_time_filled_outlined,
                                                      color: DynamicColors.textClr,
                                                      size: 18),
                                                  SizedBox(
                                                      width: 2),
                                                  Text(
                                                      "JOURNEY : 0.0 mins",
                                                      style: TextStyle(color: DynamicColors.textClr, fontSize: 13)),
                                                  SizedBox(
                                                      width: 30),
                                                  Icon(
                                                      Icons.location_on,
                                                      color: DynamicColors.textClr,
                                                      size: 18),
                                                  SizedBox(
                                                      width: 2),
                                                  Text(
                                                      "DISTANCE : ${controller.totalDistance}",
                                                      style: TextStyle(color: DynamicColors.textClr, fontSize: 13)),
                                                  SizedBox(
                                                      width: 30),
                                                  Container(
                                                    width:
                                                    fieldWidth / 3.5,
                                                    padding:
                                                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration:
                                                    BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child:
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
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
                                              height:
                                              10,
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
                                                  color: DynamicColors.secondaryClr),
                                              child:
                                              Wrap(
                                                spacing:
                                                10,
                                                runSpacing:
                                                16,
                                                children: [
                                                  SizedBox(
                                                      width: 30),
                                                  FocusTraversalOrder(
                                                    order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                        ? 50
                                                        : 46),
                                                    child:
                                                    labeledField(
                                                      context: context,
                                                      isMobile: isMobile,
                                                      label: AppText.drv,
                                                      width: fieldWidth / 2,
                                                      heights: 40,
                                                      child: Container(
                                                        // height: 35,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                          border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                                                        ),
                                                        child: DropdownButtonFormField<DashboardDriverObject>(
                                                          hint: Text("Select Driver".toUpperCase()),
                                                          style: mozillaTextSemiBoldText(
                                                            context: context,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w800,
                                                          ),
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
                                                          onTap: () {
                                                            controller.dropDownShow.value = false;
                                                          },
                                                          onChanged: (v) {
                                                            controller.selectDriverValue = v;
                                                            controller.update();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Spacer(),
                                                  SizedBox(
                                                      width: 200),
                                                  FocusTraversalOrder(
                                                    order: NumericFocusOrder(controller.jourValue == 'W/R'
                                                        ? 51
                                                        : 47),
                                                    child:
                                                    CustomButton(
                                                      onTap: () {
                                                        controller.dropDownShow.value = false;
                                                        controller.refreshPostAllFields();
                                                      },
                                                      btnText: "CLEAR [F7]",
                                                      width: 110,
                                                      height: 30,
                                                      fontSize: 11,
                                                      btnColor: DynamicColors.redClr,
                                                      verticalPadding: 0.0,
                                                      borderRadius: 4,
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
                                                      onTap: () {
                                                        controller.dropDownShow.value = false;
                                                        if (controller.jourValue == 'W/R' && controller.pickupTwoWayController.text.isEmpty && controller.dropOffTwoWayController.text.isEmpty) {
                                                          BotToast.showText(text: "Please chose waiting return");
                                                          return;
                                                        }
                                                        controller.dashBoardApiValidation(
                                                            id: controller.jobDetails == null
                                                                ? null
                                                                : controller.cliJobHit == true
                                                                ? null
                                                                : int.parse(controller.jobDetails!.id!));
                                                      },
                                                      btnText: "SAVE[HOME]",
                                                      width: 110,
                                                      height: 30,
                                                      fontSize: 11,
                                                      verticalPadding: 0.0,
                                                      borderRadius: 4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
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
                      if (controller.dropDownShow.value ==
                          false) {
                        controller.allAddressesData.clear();
                        // controller.customerPhoneNumber!.customerInfo!.clear();
                        return SizedBox();
                      }
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
                                value.name
                                    .toString()
                                    .toUpperCase();
                            controller.emailController.text =
                                value.email.toString();
                            controller.telController.text =
                                value.telephone.toString();
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