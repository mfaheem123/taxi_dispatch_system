import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timepickerfield/timepickerfield.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../alert/child_seats_alert.dart';
import '../../alert/extra_fares_alert.dart';
import '../../alert/extra_info_alert.dart';
import '../../alert/search_booking.dart';
import '../../component/marker_class.dart';
import '../../component/text_field.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/dashboard/F8_widget_alert.dart';
import '../dashboard_view/dashboard/F9_widget_alert.dart';
import '../dashboard_view/models/account_darshboard_model.dart';
import '../dashboard_view/models/all_addresses_model.dart';
import '../dashboard_view/models/dashboard_model.dart';
import '../dashboard_view/models/users_phone_numbers_model.dart';
import '../dashboard_view/widgets/fare_configuration.dart';
import '../dashboard_view/widgets/via_location.dart';
import '../locations_view/Model/location_types_zoneModel.dart' show ZoneObject;
import '../locations_view/controller/locations_controller.dart';


class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});
  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}
class _BookingFormScreenState extends State<BookingFormScreen> {
  // ────────── palette
  static const _purple = Color(0xFF312E81);
  static const _purpleDark = Color(0xFF312E81);
  static const _purpleSoft = Color(0xFFEEF2FF);
  // Background of the focused field. _purpleSoft (#EEF2FF) is too close to
  // white to register as "selected" on this dense form; indigo-100 reads
  // clearly while keeping black 12px text well above contrast minimums.
  static const _focusFill = Color(0xFFE0E7FF);
  static const _border = Colors.black;
  static const _surface = Color(0xFFF5F6FA);
  static const _red = Color(0xFFEF4444);
  static const _green = Color(0xFF22C55E);
  // ────────── font sizes (compact)
  static const _fsLabel = 11.0;
  static const _fsField = 12.0;
  static const _fsSection = 12.0;
  static const _fsTab = 12.0;
  // ────────── state
  String? driver;
  ZoneObject? dashboardZoneValue, dropZone;
  // String? account = 'DEMO';
  // String? vehicleType = 'Saloon';
  // bool quotation = true;
  AllAddressesModel? _selectedPickup;
  AllAddressesModel? _selectedDrop;
  // Kept focused (instead of a plain unfocus()) when the PICKUP/DROP
  // autocomplete is dismissed by a tap outside it, so F7/F8/F9 keep working —
  // unfocus() moves primary focus to the ambient FocusScope *outside*
  // CallbackShortcuts, and key events only bubble up from whichever node
  // currently has focus. NOT used when a suggestion is picked: that path keeps
  // focus on the field itself, which is inside CallbackShortcuts anyway and
  // preserves the Tab position.
  final FocusNode _shortcutFocusNode = FocusNode();
  // ────────── return-journey state
  ZoneObject? returnDropZone;
  // DashboardVehicleTypeObject? returnVehicleValue;
  // DashboardDriverObject? returnDriverValue;
  // late final _rDropoff = TextEditingController();
  // DateTime? returnDate = DateTime.now();
  // late final _rTime = TextEditingController(text: '15:03');
  // late final _rLead = TextEditingController();
  // late final _rFare = TextEditingController(text: '4.9');
  bool get _isReturnJourney {
    final j =
    controller.selectJourneyTypeValue?.journeyType?.toUpperCase().trim();
    return j == 'R/N' || j == 'RETURN';
  }
  // late final _pass = TextEditingController(text: '0');
  // late final _lugg = TextEditingController(text: '0');
  // late final _slugg = TextEditingController(text: '0');
  //_isReturnJourney ? 46 : 31
  void _onMultiReservation() => debugPrint('F8 / Multi Reservation tapped');
  void _onAddVehicles() => debugPrint('F9 / Vehicles tapped');
  void _onVia() => debugPrint('Via tapped');
  void _onClear() => debugPrint('F7 / Clear tapped');
  void _showPickBookingAlert() {
    showDialog(
      context: context,
      builder: (ctx) => const SearchBookingAlert(),
    );
  }
  final DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());
  final LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  // @override
  // void dispose() {
  //   for (final c in [
  //     controller.pickupController,
  //     controller.dropOffController,
  //     controller.nameController,
  //     controller.emailController,
  //     controller.mobileController,
  //     controller.telController,
  //     _date,
  //     controller.pickUpTimeController,
  //     controller.minController,
  //     controller.passController,
  //     controller.slugController,
  //     controller.passController,
  //     controller.luggController,
  //     controller.sluggController,
  //     controller.pickupTwoWayController,
  //     controller.dropOffTwoWayController,
  //     _rDate,
  //     controller.pickUpTimeControllerReturn,
  //     controller.minControllerReturn,
  //     controller.slugControllerReturn,
  //   ]) {
  //     c.dispose();
  //   }
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    if (controller.dashboardAllData == null) {
      controller.dashboardData();
    }
  }
  @override
  void dispose() {
    _shortcutFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final isTablet = w >= 640 && w < 1024;
    final isDesktop = w >= 1024;
    final cols = isMobile ? 1 : (isTablet ? 2 : 4);
    final formWidth = isDesktop ? w * 0.5 : double.infinity;
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.f7): () {
          controller.refreshPostAllFields();
        },
        const SingleActivator(LogicalKeyboardKey.f8): () {
          if (controller.pickupController.text.isNotEmpty &&
              controller.dropOffController.text.isNotEmpty) {
            DashboardF8Alert.show();
          }
        },
        // const SingleActivator(LogicalKeyboardKey.f8): _onMultiReservation,
        const SingleActivator(LogicalKeyboardKey.f9): () {
          if (controller.pickupController.text.isNotEmpty &&
              controller.dropOffController.text.isNotEmpty) {
            DashboardF9Alert.show();
          }
        },
        // const SingleActivator(LogicalKeyboardKey.f9): _onAddVehicles,
      },
      child: Focus(
        autofocus: true,
        focusNode: _shortcutFocusNode,
        // Focusable (so F7/F8/F9 keep a node in the focused chain) but NOT a
        // Tab stop — otherwise Shift+Tab off the first field lands on this
        // invisible full-screen node and the focus ring appears to vanish.
        skipTraversal: true,
        child: GetBuilder<DashboardController>(
          initState: (_) {
            controller.seeZoneOnMapp();
            if (_controller.locationtypezoneModel == null) {
              _controller.getLocationTypeZone();
            }
          },
          builder: (controller) {
            return  SafeArea(
              child: SizedBox(
                width: formWidth,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 0 : 12,
                    vertical: isMobile ? 0 : 12,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isMobile ? 0 : 10),
                      border: Border.all(color: _border.withOpacity(0.2)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Column(
                        children: [
                          _topTabs(isMobile),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal:isMobile ? 12 : 16,vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _locationRow<ZoneObject>(
                                  'PICKUP',
                                  _green,
                                  controller.pickupController,
                                  controller.allAddressesData,
                                  controller.dashboardZoneValue,
                                  _controller.updateLocationValue.value == true || _controller.locationtypezoneModel == null
                                      ? []
                                      : _controller.locationtypezoneModel!.zonesList!,
                                      (v) => setState(
                                          () => controller.dashboardZoneValue = v),
                                  isMobile,
                                      (value) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (value.isEmpty) {
                                        controller.dropDownShow.value = false;
                                      } else {
                                        controller.dropDownShow.value = true;
                                      }
                                      controller.onChangeHandler(
                                          fieldName: "PICKUP LOCATION",
                                          searchingText: value);
                                    });
                                  },
                                      (addr) =>
                                      setState(() => _selectedPickup = addr),
                                  1,
                                  zoneLabel: (z) => z.name!,
                                  onPickIndex: (index) {
                                    controller.tapSelect(index);
                                  },
                                  onPressed: () {
                                    final pickupPolylineIndex = controller.polyLineMarkerInfo
                                        .indexWhere((e) => e.markerType == "PICKUP LOCATION");
                                    if (pickupPolylineIndex >= 0) {
                                      controller.polyLineMarkerInfo.removeAt(pickupPolylineIndex);
                                    }
                                    final pickupMarkerIndex =
                                    controller.markers.indexWhere((e) => e.type == "pickup");
                                    if (pickupMarkerIndex >= 0) {
                                      controller.markers.removeAt(pickupMarkerIndex);
                                    }
                                    controller.pickupController.clear();
                                    // controller.dropOffController.clear();
                                    controller.dropDownShow.value = false;
                                    controller.suggestions.clear();
                                    controller.clearViaIfNoPickupAndDrop();
                                    controller.totalDistance.value = "0.00";
                                    controller.totalTimeDuration.value = "0 min";
                                    controller.fixedFare.value = "0";
                                    controller.returnFareValue = "0";
                                    controller.tempStoreViaMils = "0";
                                    controller.slugController.clear();
                                    controller.slugControllerReturn.clear();
                                    controller.tempStoreMils = null;
                                    controller.fetchRouteFromOSRM();
                                    FocusScope.of(Get.context!).requestFocus(controller.dropOffTextFieldFocusNode);
                                    controller.update();
                                  },
                                  notesController: controller.pickUpNoteController,
                                  onCurrentLocation: () {
                                    controller.swapeToChangeLocation();
                                  },
                                ),
                                Visibility(
                                  visible: controller.isAirportResponse.value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: isMobile
                                        ? Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        _field('FL',
                                            tab: 4.3,
                                            controller: controller
                                                .selectAirportController),
                                        const SizedBox(height: 4),
                                        _timeField('ARP',
                                            tab: 4.6,
                                            controller: controller
                                                .arrivalTimeController,
                                            onPicked: () => controller
                                                .arrivalTimePicked = true),
                                      ],
                                    )
                                        :
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 80, child:  Row(mainAxisSize: MainAxisSize.min, children: [
                                          Icon(Icons.circle, size: 9, color: Colors.green),
                                          const SizedBox(width: 6),
                                          Text("FL",
                                              style:
                                              const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsLabel)),
                                        ])),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          flex: 3,
                                          child: _field('FL',
                                              tab: 4.3,
                                              controller: controller
                                                  .selectAirportController),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          flex: 1,
                                          child: _timeField('ARP',
                                              tab: 4.6,
                                              controller: controller
                                                  .arrivalTimeController,
                                              onPicked: () => controller
                                                  .arrivalTimePicked = true),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                _locationRow<ZoneObject>(
                                  'DROP   ',
                                  _red,
                                  controller.dropOffController,
                                  controller.allAddressesData,
                                  controller.dashboardDZoneValue,
                                  _controller.updateLocationValue.value == true || _controller.locationtypezoneModel == null
                                      ? []
                                      : _controller
                                      .locationtypezoneModel!.zonesList!,
                                      (v) => setState(
                                          () => controller.dashboardDZoneValue = v),
                                  isMobile,
                                      (value) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (value.isEmpty) {
                                        controller.dropDownShow.value = false;
                                      } else {
                                        controller.dropDownShow.value = true;
                                      }
                                      controller.onChangeHandler(
                                          fieldName: "DROP LOCATION",
                                          searchingText: value);
                                    });
                                  },
                                      (addr) =>
                                      setState(() => _selectedDrop = addr),
                                  4,
                                  zoneLabel: (z) => z.name!,
                                  onPickIndex: (index) =>
                                      controller.tapSelect(index),
                                  onPressed: () {
                                    final dropPolylineIndex = controller.polyLineMarkerInfo
                                        .indexWhere((e) => e.markerType == "DROP LOCATION");

                                    if (dropPolylineIndex >= 0) {
                                      controller.polyLineMarkerInfo.removeAt(dropPolylineIndex);
                                    }
                                    final dropOffMarkerIndex =
                                    controller.markers.indexWhere((e) => e.type == "dropOff");

                                    if (dropOffMarkerIndex >= 0) {
                                      controller.markers.removeAt(dropOffMarkerIndex);
                                    }
                                    // controller.viaPoints.clear();
                                    // controller.viaTextEditingController.clear();
                                    // controller.pickupController.clear();
                                    controller.dropOffController.clear();
                                    controller.clearViaIfNoPickupAndDrop();
                                    controller.dropDownShow.value = false;
                                    controller.suggestions.clear();
                                    // controller.polyLineMarkerInfo.removeWhere((item) => item.markerType == "DROP LOCATION" || item.markerType == "Create Booking DROP LOCATION");
                                    controller.totalDistance.value = "0.00";
                                    controller.totalTimeDuration.value = "0 min";
                                    controller.fixedFare.value = "0";
                                    controller.returnFareValue = "0";
                                    controller.tempStoreViaMils = "0";
                                    controller.slugController.clear();
                                    controller.slugControllerReturn.clear();
                                    controller.tempStoreMils = null;
                                    controller.fetchRouteFromOSRM();
                                    FocusScope.of(Get.context!).requestFocus(controller.dropOffTextFieldFocusNode);
                                    controller.update();
                                  },
                                  notesController: controller.dropUpNoteController,
                                  onCurrentLocation: () {
                                    controller.swapeToChangeLocation();
                                  },
                                ),
                                const Divider(height: 14),
                                _sectionHeader(Icons.person,
                                    'PASSENGER & BOOKING DETAILS'),
                                const SizedBox(height: 4),
                                _grid(isMobile ? 1 : (isTablet ? 3 : 5), [
                                  _field('Name',
                                      tab: 8,
                                      controller: controller.nameController),
                                  _field('Email',
                                      tab: 9,
                                      controller: controller.emailController),
                                  _customerAutocompleteField(
                                    'Mobile',
                                    tab: 10,
                                    controller: controller.mobileController,
                                    customers: controller.customerPhoneNumber
                                        ?.customerInfo ??
                                        const [],
                                    onChanged: (q) {
                                      if (q.trim().isEmpty) return;
                                      controller.onPhoneNoChangeHandler(
                                        fieldName: "Phone Number",
                                        searchingText: q,
                                      );
                                    },
                                    onPicked: (c) {
                                      setState(() {
                                        controller.mobileController.text =
                                            c.mobile ?? '';
                                        controller.nameController.text =
                                            c.name ?? '';
                                        controller.emailController.text =
                                            c.email ?? '';
                                        controller.telController.text =
                                            c.telephone ?? '';
                                      });
                                    },
                                  ),
                                  _field('Tel.',
                                      tab: 11,
                                      controller: controller.telController),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(11.5),
                                    child: SizedBox(
                                      height: 32,
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          _showPickBookingAlert();
                                        },
                                        icon: const Icon(Icons.search,
                                            size: 16, color: Colors.white),
                                        label: const Text(
                                          'Pick Booking',
                                          style: TextStyle(
                                              fontSize: _fsField,
                                              color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(_purple),
                                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          side: WidgetStateProperty.resolveWith((states) {
                                            if (states.contains(WidgetState.focused)) {
                                              return const BorderSide(color: Colors.white, width: 2);
                                            }
                                            return BorderSide.none;
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                _grid(cols, [
                                  _dateField('Date',
                                      tab: 12,
                                      value: controller.pickUpDate,
                                      onChanged: (d) => setState(() {
                                            controller.pickUpDate = d;
                                            controller.pickUpDatePicked = true;
                                          })),
                                  _timeField('Time',
                                      tab: 13,
                                      controller:
                                      controller.pickUpTimeController,
                                      onPicked: () =>
                                          controller.pickUpTimePicked = true),
                                  _dropdown<JourneyTypeObject>(
                                    'Journey Type'.toUpperCase(),
                                    controller.selectJourneyTypeValue,
                                    controller.dashboardAllData!.journeyTypes ??
                                        const [],
                                        (v) {
                                          if(controller.pickupController.text.isNotEmpty && controller.dropOffController.text.isNotEmpty){
                                            setState(() {
                                              // controller.selectJourneyTypeValue = v;
                                              controller.dropDownShow.value = false;
                                              controller.jourValue =
                                              (v!.journeyType == "r/n")
                                                  ? 'W/R'
                                                  : null;
                                              controller.selectJourneyTypeValue = v;
                                            });
                                          }else{
                                            BotToast.showText(text: "Please select pickup and drop location first");
                                          }
                                    },
                                    14,
                                    itemLabel: (p) => p.journeyType!,
                                  ),
                                  _field('Lead Time',
                                      tab: 15,
                                      controller: controller.minController),
                                ]),
                                _grid(isMobile ? 1 : 3, [
                                  _field('No. of Passengers',
                                      tab: 16,
                                      prefix: Icons.person_outline,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      controller: controller.passController),
                                  _field('Fare',
                                      tab: 17,
                                      prefix: Icons.currency_pound,
                                      controller: controller.slugController),
                                  _dropdown<DashboardAccountObject>(
                                    'Account',
                                    controller.selectAccountValue,
                                    controller.dashboardAccountData?.accounts ??
                                        const [],
                                        (v) {
                                      setState(() {
                                        controller.selectAccountValue = v;
                                        controller.selectDepartmentData = null;
                                      });
                                    },
                                    18,
                                    itemLabel: (p) => p.name!,
                                  ),
                                ]),
                                if (_isReturnJourney)
                                  _returnJourneySection(isMobile, cols,controller),
                                const Divider(height: 10),
                                _sectionHeader(
                                    Icons.directions_car, 'VEHICLE & PAYMENT'),
                                const SizedBox(height: 4),
                                _grid(isMobile ? 1 : (isTablet ? 2 : 4), [
                                  _dropdown<PaymentTypeObject>(
                                    'Pay By',
                                    controller.selectPaymentTypeValue,
                                    controller.dashboardAllData!.paymentTypes ??
                                        const [],
                                        (v) => setState(() =>
                                    controller.selectPaymentTypeValue = v),
                                    _isReturnJourney?34:19,
                                    itemLabel: (p) => p.name!,
                                  ),
                                  _dropdown<DashboardVehicleTypeObject>(
                                    'Vehicle Type',
                                    controller.selectVehicleValue,
                                    controller.dashboardAllData!.vehicleTypes!,
                                        (v) => setState(() {
                                      controller.selectVehicleValue = v;
                                      controller.getFaresCalculation();
                                    }),
                                    _isReturnJourney?35:20,
                                    itemLabel: (p) => p.name!,
                                  ),
                                  _dropdown<DepartmentObject>(
                                    'Department',
                                    controller.selectDepartmentData,
                                    controller.selectAccountValue == null
                                        ? []
                                        : controller
                                        .selectAccountValue!.departments!,
                                        (v) => setState(() {
                                      controller.selectDepartmentData = v;
                                      controller.update();
                                    }),

                                    _isReturnJourney?36:21,
                                    itemLabel: (p) => p.name ?? "",
                                  ),
                                  _quotationToggle(),
                                ]),
                                const SizedBox(height: 4),
                                _commsAndLuggageRow(isMobile),
                                const SizedBox(height: 4),
                                _statusCards(isMobile),
                                const SizedBox(height: 4),
                                _driverRow(isMobile),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  // ────────── RETURN JOURNEY SECTION
  /// Shared cleanup for two-way pickup/drop clear buttons.
  void _clearTwoWayData(DashboardController ctrl, {bool recalcRoute = false}) {
    // Remove two-way polyline markers
    ctrl.polyLineMarkerInfo.removeWhere(
          (e) => e.markerType == "PICKUP TWO WAY LOCATION" ||
          e.markerType == "DROP TWO WAY LOCATION",
    );
    // Remove two-way map markers
    ctrl.markers.removeWhere(
          (m) => m.type == "pickup two way" ||
          m.type == "dropOff two way" ||
          m.type == "via with return",
    );
    // Remove via points tied to return way
    for (int i = ctrl.viaPoints.length - 1; i >= 0; i--) {
      if (ctrl.viaPoints[i].withReturnWay == "via with return") {
        ctrl.viaPoints.removeAt(i);
        if (i < ctrl.viaTextEditingController.length) {
          ctrl.viaTextEditingController.removeAt(i);
        }
      }
    }
    // Clear two-way text controllers
    ctrl.pickupTwoWayController.clear();
    ctrl.dropOffTwoWayController.clear();
    // Reset fare/temp state
    ctrl.returnFareValue = "";
    if (recalcRoute) {
      ctrl.tempStoreMils = null;
      ctrl.fetchRouteFromOSRM();
    }
    ctrl.update();
  }

  Widget _returnJourneySection(bool isMobile, int cols, DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 20),
        _sectionHeader(Icons.swap_horiz, 'RETURN JOURNEY'),
        const SizedBox(height: 8),
        _locationRow<ZoneObject>(
          'PICK',
          _green,
          controller.pickupTwoWayController,
          controller.allAddressesData,
          _controller.RNzoneValue,
          _controller.updateLocationValue.value == true
              ? []
              : _controller.locationtypezoneModel!.zonesList!,
              (v) => setState(() => _controller.RNzoneValue = v),
          isMobile,
              (value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.onChangeHandler(
                  fieldName: "PICKUP TWO WAY LOCATION", searchingText: value);
            });
          },
              (addr) {
            setState(() => _selectedDrop = addr);
          },
          19,
          zoneLabel: (z) => z.name!,
          onPickIndex: (index) => controller.tapSelect(index),
          onPressed: () {
            FocusScope.of(Get.context!).requestFocus(controller.pickupTwoTextFieldFocusNode);

            final pickupPolylineIndex = controller.polyLineMarkerInfo
                .indexWhere((e) => e.markerType == "PICKUP TWO WAY LOCATION");

            if (pickupPolylineIndex >= 0) {
              controller.polyLineMarkerInfo.removeAt(pickupPolylineIndex);
            }
            final pickupMarkerIndex =
            controller.markers.indexWhere((e) => e.type == "pickup two way");
            if (pickupMarkerIndex >= 0) {
              controller.markers.removeAt(pickupMarkerIndex);
            }
            controller.pickupTwoWayController.clear();
            controller.clearReturnViaIfNoPickupAndDrop();
            controller.selectAirportControllerReturn.clear();
            controller.arrivalReturnTimeController.clear();
            controller.isAirportResponseReturn.value = false;
            // controller.dropOffTwoWayController.clear();
            controller.polyLineMarkerInfo.removeWhere((item) => item.markerType == "PICKUP TWO WAY LOCATION");
            if (controller.markers is List<CustomMarker>) {
              controller.markers.removeWhere((marker) => marker.type == "PICKUP TWO WAY LOCATION");
            }
            // controller.tempStoreReturnMils = null;
            // controller.fixedFare.value = "0";
            // controller.returnFareValue = "";
            // controller.slugControllerReturn.clear();
            // // controller.slugController.clear();
            controller.dropDownShow.value = false;
            // controller.tempStoreMils = null;
            controller.fetchRouteFromOSRM();
            controller.update();
            // FocusScope.of(Get.context!)
            //     .requestFocus(controller.pickupTwoTextFieldFocusNode);
            // _clearTwoWayData(controller);
          },
          onCurrentLocation: () async {
            controller.swapeToChangeReturnLocation();
            },
        ),
        Visibility(
          visible: controller.isAirportResponseReturn.value,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: isMobile
                ? Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                _field('FL',
                    tab: 22.3,
                    controller: controller
                        .selectAirportControllerReturn),
                const SizedBox(height: 4),
                _timeField('ARP',
                    tab: 22.6,
                    controller: controller
                        .arrivalReturnTimeController,
                    onPicked: () =>
                        controller.arrivalReturnTimePicked = true),
              ],
            )
                :
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 80, child:  Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.circle, size: 9, color: Colors.green),
                  const SizedBox(width: 6),
                  Text("FL",
                      style:
                      const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsLabel)),
                ])),
                const SizedBox(width: 2),
                Expanded(
                  flex: 3,
                  child: _field('FL',
                      tab: 22.3,
                      controller: controller
                          .selectAirportControllerReturn),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _timeField('ARP',
                      tab: 22.6,
                      controller: controller
                          .arrivalReturnTimeController,
                      onPicked: () => controller.arrivalTimePicked = true),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        _locationRow<ZoneObject>(
          'DROP',
          _red,
          controller.dropOffTwoWayController,
          controller.allAddressesData,
          _controller.RN1zoneValue,
          _controller.updateLocationValue.value == true
              ? []
              : _controller.locationtypezoneModel!.zonesList!,
              (v) => setState(() => _controller.RN1zoneValue = v),
          isMobile,
              (value) {
            controller.onChangeHandler(
                fieldName: "DROP TWO WAY LOCATION", searchingText: value);
          },
              (addr) {
            setState(() => _selectedDrop = addr);
          },
          23,
          zoneLabel: (z) => z.name!,
          onPickIndex: (index) => controller.tapSelect(index),
          onPressed: () {
            FocusScope.of(Get.context!).requestFocus(controller.dropOffTwoWayTextFieldFocusNode);

            final dropPolylineIndex = controller.polyLineMarkerInfo
                .indexWhere((e) => e.markerType == "DROP TWO WAY LOCATION");

            if (dropPolylineIndex >= 0) {
              controller.polyLineMarkerInfo.removeAt(dropPolylineIndex);
            }
            final dropOffMarkerIndex =
            controller.markers.indexWhere((e) => e.type == "dropOff two way");

            if (dropOffMarkerIndex >= 0) {
              controller.markers.removeAt(dropOffMarkerIndex);
            }
            controller.markers.removeWhere((marker) => marker.type == "via with return");
            // 1. Only Two-Way controllers clear karein
            controller.dropOffTwoWayController.clear();
            controller.clearReturnViaIfNoPickupAndDrop();
            // 3. Fares aur temporaries reset
            // controller.tempStoreMils = null;
            // // controller.fixedFare.value = "0";
            // controller.returnFareValue = "";
            // controller.tempStoreReturnMils = null;
            // controller.slugControllerReturn.clear();
            // // controller.slugController.clear();
            // // controller.totalDistance.value = "0";
            // // controller.totalTimeDuration.value = "0";
            controller.dropDownShow.value = false;
            //  Route API
            controller.fetchRouteFromOSRM();
            controller.update();
            // FocusScope.of(Get.context!)
            //     .requestFocus(controller.dropOffTwoWayTextFieldFocusNode);
            // _clearTwoWayData(controller, recalcRoute: true);
          },
          onCurrentLocation: () async {
            controller.swapeToChangeReturnLocation();
          },
        ),
        const SizedBox(height: 8),
        _grid(cols, [
          _dateField('R/Date',
              tab: 28,
              value: controller.pickUpDateReturn,
              onChanged: (d) => setState(() {
                    controller.pickUpDateReturn = d;
                    controller.pickUpDateReturnPicked = true;
                  })),
          _timeField('R/Time',
              tab: 29,
              controller: controller.pickUpTimeControllerReturn,
              onPicked: () => controller.pickUpTimeReturnPicked = true),
          _field('R/Lead', tab: 30, controller: controller.minControllerReturn),
          _field('R/Fare',
              tab: 31,
              prefix: Icons.currency_pound,
              controller: controller.slugControllerReturn),
        ]),
        const SizedBox(height: 6),
        isMobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _addReturnFareCheckbox(),
          const SizedBox(height: 8),
          _dropdown<DashboardVehicleTypeObject>(
            'Select R/VEH',
            controller.selectVehicleValueReturn,
            controller.dashboardAllData!.vehicleTypes!,
                (v) {
              print('tap 01');
              setState(() async{

                print('tap 02');
                // controller.selectVehicleValueReturn = v;
                if (v == null) return;

                print('tap 03');
                controller.selectVehicleValueReturn = v;
                controller.dropDownShow.value = false;

                // Jab user khud badlega tab naye wale ki ID direct jayegi
                final fare = await getActiveFareForVehicle(
                  controller.dashboardAllData!.fareConfigurations!,
                  v.id!,
                );
                print('tap 04');
                if (fare != null) {
                  print('Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}');
                  controller.getFaresCalculation();
                  print('tap 05');
                  double inttt = (double.parse(controller.totalDistance.value) - double.parse(fare.minimumMiles.toString()));
                  controller.fixedFare.value = (inttt * double.parse(fare.minimumFares.toString())).toString();
                  print('tap 06');
                } else {
                  print('tap 07');
                  print('No active fare found for this vehicle');
                }
                print('tap 08');
                controller.update();
              }
              );},
            32,
            itemLabel: (p) => p.name!,
          ),
          const SizedBox(height: 8),
          _dropdown<DashboardDriverObject>(
            'Select R/DRV',
            controller.selectDriverValueReturn,
            controller.dashboardAllData!.drivers ?? const [],
                (v) => setState(() => controller.selectDriverValueReturn = v),
            33,
            itemLabel: (p) => p.name ?? '',
          ),
        ])
            : Row(children: [
          _addReturnFareCheckbox(),
          const SizedBox(width: 16),
          Expanded(
            child: _dropdown<DashboardVehicleTypeObject>(
              'Select R/VEH',
              controller.selectVehicleValueReturn,
              controller.dashboardAllData!.vehicleTypes!,
                  (v) {
                print('tap 01');
                setState(() async{

                  print('tap 02');
                  // controller.selectVehicleValueReturn = v;
                  if (v == null) return;

                  print('tap 03');
                  controller.selectVehicleValueReturn = v;
                  controller.dropDownShow.value = false;

                  // Jab user khud badlega tab naye wale ki ID direct jayegi
                  final fare = await getActiveFareForVehicle(
                    controller.dashboardAllData!.fareConfigurations!,
                    v.id!,
                  );
                  print('tap 04');
                  if (fare != null) {
                    print('Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}');
                    controller.getFaresCalculation();
                    print('tap 05');
                    double inttt = (double.parse(controller.totalDistance.value) - double.parse(fare.minimumMiles.toString()));
                    controller.fixedFare.value = (inttt * double.parse(fare.minimumFares.toString())).toString();
                    print('tap 06');
                  } else {
                    print('tap 07');
                    print('No active fare found for this vehicle');
                  }
                  print('tap 08');
                  controller.update();
                }
                );
                },
              32,
              itemLabel: (p) => p.name!,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _dropdown<DashboardDriverObject>(
              'Select R/DRV',
              controller.selectDriverValueReturn,
              controller.dashboardAllData!.drivers ?? const [],
                  (v) => setState(() => controller.selectDriverValueReturn = v),
              33,
              itemLabel: (p) => p.name ?? '',
            ),
          ),
        ]),
      ],
    );
  }

  Widget _addReturnFareCheckbox() =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        // Between R/Fare (31) and Select R/VEH (32). Orderless before this, so
        // Tab reached it only after the whole form had been traversed.
        FocusTraversalOrder(
          order: const NumericFocusOrder(31.5),
          child: _GlowFocus(
            radius: 4,
            child: SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: controller.addReturnFare.value,
              onChanged: (v) =>
                  setState(() => controller.addReturnFare.value = v ?? false),
              activeColor: _purple,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text('ADD RETURN FARE',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: _fsField)),
      ]);

  // ────────── top tabs (Subsidiary dd → tab 1)
  Widget _topTabs(bool isMobile) {
    // [order] < 1 so the tab strip is traversed before the Subsidiary dropdown
    // (order 1). Without an explicit order OrderedTraversalPolicy pushes these
    // InkWells behind every numbered field, i.e. to the end of the form.
    Widget tab(String label,
        {required double order, bool active = false, VoidCallback? onTap}) =>
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Material(
            color: Colors.transparent,
            child: FocusTraversalOrder(
              order: NumericFocusOrder(order),
              child: _GlowFocus(
              radius: 8,
              child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              mouseCursor: SystemMouseCursors.click,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: active ? _purple : Colors.white,
                  border: Border.all(color: active ? _purple : _border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: _fsTab,
                  ),
                ),
              ),
              ),
              ),
            ),
          ),
        );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: 8),
      // decoration: const BoxDecoration(
      //   border: Border(bottom: BorderSide(color: _border)),
      // ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tab('BOOKING', order: 0.1, active: true, onTap: () {}),
                  tab('+ Multi Reservation (F8)', order: 0.2, onTap: () {
                    if (controller.pickupController.text.isNotEmpty &&
                        controller.dropOffController.text.isNotEmpty) {
                      DashboardF8Alert.show();
                    }
                  }),
                  tab('+ Vehicles (F9)', order: 0.3, onTap: () {
                    if (controller.pickupController.text.isNotEmpty &&
                        controller.dropOffController.text.isNotEmpty) {
                      DashboardF9Alert.show();
                    }
                  }),
                  tab('Via (${controller.viaPoints.length})', order: 0.4, onTap: () {
                    if (controller.pickupController.text.isNotEmpty
                    // &&    controller.dropOffController.text.isNotEmpty
                    ) {
                      showDialog(context: context, builder: (_) => ViaLocation());
                    }else{
                      BotToast.showText(text: "Please write pickup and dropoff location");
                    }
                  }),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Text(
                      'Sub',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: _fsTab,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 220,
                    child: _dropdown<DashboardSubsidiaryObject>(
                      null,
                      controller.selectSubsidiariesValue,
                      controller.dashboardAllData?.subsidiaries ?? const [],
                          (v) {
                        if (v == null) return;
                        setState(() {
                          controller.selectSubsidiariesValue = v;
                          controller.getAccountData(subsidiariesId: v.id);
                        });
                      },
                      1,
                      itemLabel: (p) => p.name ?? '',
                    ),
                  ),
                ]),
          ),
          Divider(height: 10),
        ],
      ),
    );
  }

// ────────── location row
  Widget _locationRow<T>(
      String label,
      Color dot,
      TextEditingController controller,
      List<AllAddressesModel> addresses,
      T? zone,
      List<T> zoneItems,
      ValueChanged<T?> onZone,
      bool isMobile,
      ValueChanged<String>? onChanged,
      ValueChanged<AllAddressesModel>? onAddressSelected,
      int tabBase, {
        String Function(T)? zoneLabel,
        VoidCallback? onCurrentLocation,
        ValueChanged<int>? onPickIndex,
        TextEditingController? notesController, // ← notes field controller
        VoidCallback? onPressed,
      }) {
    final tag = Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.circle, size: 9, color: dot),
      const SizedBox(width: 6),
      Text(label,
          style:
          const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsLabel)),
    ]);
    final address = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 1).toDouble()),
      child: _AddressModelAutocomplete(
        controller: controller,
        items: addresses,
        onChanged: onChanged,
        onSelected: onAddressSelected,
        onPickIndex: onPickIndex,
        fallbackFocusNode: _shortcutFocusNode,
        decoration: _inputDecoration().copyWith(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          suffixIconConstraints:
          const BoxConstraints(minWidth: 60, minHeight: 32),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // These live inside the field's suffixIcon, so they would inherit
              // the address field's own order (tabBase + 1) and be tie-broken by
              // geometry. Explicit fractional orders pin them deterministically
              // between the address field and the zone dropdown (tabBase + 2).
              controller.text.isNotEmpty
                  ? FocusTraversalOrder(
                order: NumericFocusOrder(tabBase + 1.3),
                child: _GlowFocus(
                  radius: 14,
                  child: IconButton(
                    tooltip: 'Clear',
                    onPressed: onPressed,
                    icon:
                    const Icon(Icons.close, size: 16, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints:
                    const BoxConstraints(minWidth: 28, minHeight: 28),
                    splashRadius: 16,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
              FocusTraversalOrder(
                order: NumericFocusOrder(tabBase + 1.6),
                child: _GlowFocus(
                  radius: 14,
                  child: IconButton(
                    tooltip: 'Use current location',
                    onPressed: onCurrentLocation,
                    icon:
                    Icon(LucideIcons.arrowDownUp, size: 16, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    splashRadius: 16,
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
    final zoneDd = _dropdown<T>(
      null,
      zone,
      zoneItems,
      onZone,
      tabBase + 2,
      itemLabel: zoneLabel,
      hint: 'New Zone',
    );
    // Notes is now an editable text field instead of a button.
    final noteHint =
        '${label[0]}${label.substring(1).toLowerCase().trim()} Notes';
    final notes = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 3).toDouble()),
      child: _GlowFocus(
        child: TextField(
          controller: notesController,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
          style: const TextStyle(fontSize: _fsField),
          textInputAction: TextInputAction.next,
          decoration: _inputDecoration().copyWith(
            hintText: noteHint,
            hintStyle:
            const TextStyle(fontSize: _fsField, color: Colors.black45),
          ),
        ),
      ),
    );
    if (isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        tag,
        const SizedBox(height: 6),
        address,
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: zoneDd),
          const SizedBox(width: 8),
          Expanded(child: notes),
        ]),
      ]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 80, child: tag),
        const SizedBox(width: 2),
        Expanded(flex: 5, child: address),
        const SizedBox(width: 8),
        SizedBox(width: 150, child: zoneDd),
        const SizedBox(width: 8),
        SizedBox(width: 160, child: notes), // gave the field a bounded width
      ],
    );
  }
  // ────────── comms + luggage (PASS=22, LUGG=23, SLUGG=24)
  Widget _commsAndLuggageRow(bool isMobile) {
    Widget checkbox(String label, bool value, ValueChanged<bool?> onChanged, {required num tab}) =>
        FocusTraversalOrder(
          order: NumericFocusOrder(tab.toDouble()),
          child: _GlowFocus(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  activeColor: _purple,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: _fsField)),
            ]),
          ),
        );
    Widget luggageField(String label, IconData icon,
        TextEditingController controller, int tab) =>
        SizedBox(
          width: 150,
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Text(label,
            //     style:
            //     const TextStyle(fontSize: _fsLabel, color: Colors.black)),
            const SizedBox(height: 2),
            FocusTraversalOrder(
              order: NumericFocusOrder(tab.toDouble()),
              child: _GlowFocus(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: _fsField),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: _inputDecoration().copyWith(
                    label:
                    Text(label,
                        style:
                        const TextStyle(fontSize: _fsLabel, color: Colors.black)),
                    prefixIconConstraints:
                    const BoxConstraints(minWidth: 26, minHeight: 0),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 6, right: 2),
                      child: Icon(icon, size: 13, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        );

    Widget iconBtn(IconData icon, {VoidCallback? onPressed, required int tab}) =>
        FocusTraversalOrder(
          order: NumericFocusOrder(tab.toDouble()),
          child: _GlowFocus(
            child: Focus(
              // Key-handling only: the inner IconButton is the single Tab stop.
              // A focusable wrapper here would double every Tab press, and key
              // events still bubble up to this node from the button.
              canRequestFocus: false,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    (event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.space)) {
                  onPressed?.call();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Container(
                  margin: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    color: _purpleSoft,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _border),
                  ),
                  child: IconButton(
                    onPressed: onPressed,
                    padding: const EdgeInsets.all(4),
                    visualDensity: VisualDensity.compact,
                    splashRadius: 18,
                    icon: Icon(
                      icon,
                      size: 17,
                      color: Colors.black,
                    ),
                  )
              ),
            ),
          ),
        );
    final left = Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // 21.2 / 21.4 (36.2 / 36.4 in return mode): these previously reused 20
        // and 21, which are the Vehicle Type and Department dropdowns in the
        // row above — a duplicate order leaves the relative position of the
        // colliding pair up to a geometry tie-break instead of to us.
        checkbox('SMS', controller.smsCheckbox.value,
                (v) => setState(() => controller.smsCheckbox.value = v ?? false), tab: _isReturnJourney ? 36.2 : 21.2),
        checkbox('EMAIL', controller.emailCheckbox.value,
                (v) => setState(() => controller.emailCheckbox.value = v ?? false), tab: _isReturnJourney ? 36.4 : 21.4),
        // luggageField('Passenger'.toUpperCase(), Icons.work, controller.passController, _isReturnJourney?37:22,),
        luggageField('luggage'.toUpperCase(), Icons.luggage, controller.luggController,  _isReturnJourney?37:22,),
        luggageField('small luggage'.toUpperCase(), Icons.luggage, controller.sluggController,  _isReturnJourney?38:23,),
      ],
    );
    final right = Row(mainAxisSize: MainAxisSize.min, children: [
      iconBtn(Icons.person, tab: _isReturnJourney ? 39 : 24, onPressed: () {
        showDialog(context: context, builder: (_) => RestrictDriversAlert());
      }),
      iconBtn(Icons.attach_money, tab: _isReturnJourney ? 40 : 25, onPressed: () {
        showDialog(
          context: context,
          builder: (_) => ChildSeatsAlert(),
        );
      }),
      iconBtn(Icons.note_add, tab: _isReturnJourney ? 41 : 26, onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ExtraFaresAlert(),
        );
      }),
      iconBtn(Icons.calculate, tab: _isReturnJourney ? 42 : 27, onPressed: () {
        showDialog(
          context: context,
          builder: (_) => ExtraInfoAlert(),
        );
      }),
    ]);
    if (isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        left,
        const SizedBox(height: 10),
        right,
      ]);
    }
    return Row(children: [Expanded(child: left), right]);
  }
  // ────────── status cards
  Widget _statusCards(bool isMobile) {
    Widget card({
      required IconData icon,
      required String label,
      required String value,
      bool emphasized = false,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: emphasized ? _purpleDark : _purpleSoft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          Icon(icon, size: 20, color: emphasized ? Colors.white : _purple),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: emphasized ? Colors.white70 : _purpleDark,
                    )),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: emphasized ? Colors.white : Colors.black87,
                    )),
              ],
            ),
          ),
        ]),
      );
    }
    final cards = [
      card(
          icon: Icons.schedule,
          label: 'ETA',
          value: '${controller.totalTimeDuration}'),
      card(icon: Icons.timer_outlined, label: 'JOURNEY', value: '0.0 mins'),
      card(
          icon: Icons.place_outlined,
          label: 'DISTANCE',
          value: '${controller.totalDistance}'),
      card(
          icon: Icons.payments_outlined,
          label: 'FARE',
          value:
          '£ ${double.parse(controller.fixedFare.value).toStringAsFixed(1)}',
          emphasized: true),
    ];
    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            cards[i],
            if (i < cards.length - 1) const SizedBox(height: 8),
          ],
        ],
      );
    }
    return Row(children: [
      for (var i = 0; i < cards.length; i++) ...[
        Expanded(child: cards[i]),
        if (i < cards.length - 1) const SizedBox(width: 10),
      ],
    ]);
  }
  // ────────── driver row (Driver dd → tab 25)
  Widget _driverRow(bool isMobile) {
    final dd = _dropdown<DashboardDriverObject>(
      null,
      controller.selectDriverValue,
      controller.dashboardAllData!.drivers ?? const [],
          (v) => setState(() => controller.selectDriverValue = v),
      _isReturnJourney ? 43 : 28,
      itemLabel: (p) => p.name ?? '',
      hint: 'Select Driver',
    );
    final clear = FocusTraversalOrder(
      order: NumericFocusOrder((_isReturnJourney ? 44 : 29).toDouble()),
      child: _GlowFocus(
        child: ElevatedButton(
          onPressed: () {
            controller.refreshPostAllFields();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            textStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsField),
          ),
          child: Text('CLEAR [F7]'.toUpperCase()),
        ),
      ),
    );
    final home = FocusTraversalOrder(
      order: NumericFocusOrder((_isReturnJourney ? 45 : 30).toDouble()),
      child: _GlowFocus(
        child: Focus(
          // Intercept Tab so focus jumps from the Home button directly to the
          // Driver panel's first focusable item, skipping any remaining items
          // inside this FocusTraversalGroup.
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.tab &&
                !HardwareKeyboard.instance.isShiftPressed &&
                // Only claim Tab when the Driver panel is actually mounted —
                // otherwise requestFocus() is a no-op and returning `handled`
                // would swallow the keypress, stranding focus on this button.
                controller.driverPanelFocusNode.context != null) {
              // Hand off focus to the Driver panel.
              controller.driverPanelFocusNode.requestFocus();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: ElevatedButton.icon(
            onPressed: () {
              if (controller.jourValue == 'W/R' &&
                  controller.pickupTwoWayController.text.isEmpty &&
                  controller.dropOffTwoWayController.text.isEmpty) {
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
            icon: const Icon(Icons.home_outlined, size: 16),
            label: const Text('SAVE [HOME]'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              textStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsField),
            ),
          ),
        ),
      ),
    );
    if (isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Driver',
            style: TextStyle(fontSize: _fsLabel, color: Colors.black)),
        const SizedBox(height: 4),
        dd,
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: clear),
          const SizedBox(width: 10),
          Expanded(child: home),
        ]),
      ]);
    }
    return Row(children: [
      const SizedBox(
        width: 70,
        child: Text('Driver',
            style: TextStyle(fontSize: _fsField, fontWeight: FontWeight.w600)),
      ),
      Expanded(child: dd),
      const SizedBox(width: 10),
      clear,
      const SizedBox(width: 8),
      home,
    ]);
  }
  // ────────── shared primitives
  Widget _sectionHeader(IconData icon, String title) => Row(children: [
    Icon(icon, size: 16, color: _purple),
    const SizedBox(width: 6),
    Text(title.toUpperCase(),
        style: const TextStyle(
            color: _purple,
            fontWeight: FontWeight.w700,
            fontSize: _fsSection)),
  ]);
  Widget _grid(int cols, List<Widget> children) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final slice = children.sublist(i, (i + cols).clamp(0, children.length));
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          for (var j = 0; j < slice.length; j++) ...[
            Expanded(child: slice[j]),
            if (j < slice.length - 1) const SizedBox(width: 12),
          ],
          for (var k = slice.length; k < cols; k++) ...[
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()),
          ],
        ]),
      ));
    }
    return Column(children: rows);
  }
  Widget _customerAutocompleteField(
      String label, {
        required int tab,
        required TextEditingController controller,
        required List<CustomerObject> customers,
        required ValueChanged<CustomerObject> onPicked,
        ValueChanged<String>? onChanged,
        IconData? prefix,
      }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(label.toUpperCase(),
      //     style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
      const SizedBox(height: 4),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: _CustomerModelAutocomplete(
          controller: controller,
          items: customers,
          onSelected: onPicked,
          onChanged: onChanged,
          decoration: _inputDecoration().copyWith(
            label: Text(label.toUpperCase(),),
            labelStyle: TextStyle(fontSize: _fsLabel, color: Colors.black),
            prefixIconConstraints:
            const BoxConstraints(minWidth: 28, minHeight: 0),
            prefixIcon: prefix != null
                ? Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: Icon(prefix, size: 15, color: Colors.grey),
            )
                : null,
          ),
        ),
      ),
    ]);
  }
  // Read-only date field backed by a [DateTime?] value (no TextEditingController).
  // • Tab focuses it (icon + border turn purple, date text shows the selection color).
  // • Enter / Space opens a React-datepicker-style dropdown calendar (anchored
  //   under the field) with month / year navigation, arrow-key day navigation,
  //   and the purple selection palette.
  Widget _dateField(String label,
      {required int tab,
        required DateTime? value,
        required ValueChanged<DateTime> onChanged}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(label.toUpperCase(),
      //     style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
      const SizedBox(height: 4),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: _GlowFocus(
          child: _CalendarDropdownField(
            value: value,
            label: label,
            onChanged: onChanged,
            decoration: _inputDecoration(),
            textStyle: const TextStyle(fontSize: _fsField, color: Colors.black87),
            accent: _purple,
            accentSoft: _purpleSoft,
            idleColor: Colors.grey,
          ),
        ),
      ),
    ]);
  }

  /// [onPicked] fires only when the user confirms a time in the dropdown, so
  /// the controller can tell a chosen time apart from the pre-filled "now".
  Widget _timeField(String label,
      {required num tab,
        required TextEditingController controller,
        VoidCallback? onPicked}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(label.toUpperCase(),
      //     style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
      // const SizedBox(height: 2),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: _GlowFocus(
          child: TimePickerField(
            controller: controller,
            onChanged: onPicked == null ? null : (_) => onPicked(),
            decoration: _inputDecoration().copyWith(
              label: Text(label.toUpperCase(),
                  style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
            ),
          ),
        ),
      ),
    ]);
  }
  Widget _field(String label,
      {required num tab,
        IconData? prefix,
        VoidCallback? onPrefixTap,
        TextEditingController? controller,
        List<TextInputFormatter>? inputFormatters,
      }) {
    Widget? prefixWidget;
    if (prefix != null) {
      final iconPadding = Padding(
        padding: const EdgeInsets.only(left: 8, right: 4),
        child: Icon(prefix, size: 15, color: Colors.grey),
      );
      prefixWidget = onPrefixTap != null
          ? InkWell(
        onTap: onPrefixTap,
        borderRadius: BorderRadius.circular(4),
        child: iconPadding,
      )
          : iconPadding;
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(label.toUpperCase(),
      //     style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
      // const SizedBox(height: 2),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: _GlowFocus(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: inputFormatters ??
                [
                  UpperCaseTextFormatter(),
                ],
            style: const TextStyle(fontSize: _fsField),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onPrefixTap?.call(),
            decoration: _inputDecoration().copyWith(
              label: Text(label.toUpperCase(),),
              labelStyle: TextStyle(fontSize: _fsLabel, color: Colors.black),
              prefixIconConstraints:
              const BoxConstraints(minWidth: 28, minHeight: 0),
              prefixIcon: prefixWidget,
            ),
          ),
        ),
      ),
    ]);
  }
  Widget _dropdown<T>(
      String? label,
      T? value,
      List<T> items,
      ValueChanged<T?> onChanged,
      int tab, {
        String Function(T item)? itemLabel,
        String? hint,
        bool isExpanded = true,
      }) {
    String labelOf(T item) => itemLabel?.call(item) ?? item.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          // Text(label.toUpperCase(),
          //     style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
          // const SizedBox(height: 2),
        ],
        FocusTraversalOrder(
          order: NumericFocusOrder(tab.toDouble()),
          child: _GlowFocus(
            child: DropdownButtonFormField<T>(
              value: value,
              isExpanded: isExpanded,
              // isDense: true,
              // itemHeight: 40, // default is around 48
              style: const TextStyle(fontSize: _fsField, color: Colors.black87),
              hint: hint != null
                  ? Text(hint.toUpperCase(),
                  style: const TextStyle(
                      fontSize: _fsField, color: Colors.black))
                  : null,
              decoration: _inputDecoration().copyWith(
                label: Text(label?.toUpperCase() ?? '',
                    style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8, // reduce vertical padding
                ),
              ),
              items: items
                  .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(
                  labelOf(e).toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: _fsField),
                ),
              ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
  Widget _quotationToggle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // const SizedBox(height: 16),
      Row(children: [
        // Last cell of the PAY BY / VEHICLE / DEPARTMENT row, so it sits just
        // after Department (21, or 36 in return mode). Previously orderless,
        // which parked it behind every numbered field.
        FocusTraversalOrder(
          order: NumericFocusOrder(_isReturnJourney ? 36.1 : 21.1),
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.enter): () {
                controller.dropDownShow.value = !controller.dropDownShow.value;
              },
            },
            child: Focus(
              // The Switch itself is the Tab stop and handles Enter/Space.
              canRequestFocus: false,
              child: _GlowFocus(
                radius: 20,
                child: Obx(() => Switch(
                  value: controller.dropDownShow.value,
                  onChanged: (v) => controller.dropDownShow.value = v,
                  activeColor: _purple,
                )),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text('Quotation'.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: _fsField)),
      ]),
    ]);
  }
  InputDecoration _inputDecoration() => InputDecoration(

    isDense: true,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
    // Focused fields tint their background. InputDecorator resolves fillColor
    // against its own state set (which carries WidgetState.focused), so this
    // covers every field, dropdown, the date field and the time field in one
    // place. The unfocused value is white — the same as the card behind it —
    // so nothing looks different until focus actually arrives.
    filled: true,
    fillColor: WidgetStateColor.resolveWith((states) =>
    states.contains(WidgetState.focused) ? _focusFill : Colors.white),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _border)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _border)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _purple, width: 2)),
  );
}
// ════════════════════════════════════════════════════════════════════
// Autocomplete: backed by AllAddressesModel (name + postcode + lat/lon)
// ════════════════════════════════════════════════════════════════════
class _AddressModelAutocomplete extends StatefulWidget {
  const _AddressModelAutocomplete({
    required this.controller,
    required this.items,
    required this.decoration,
    this.onChanged,
    this.onSelected,
    this.onPickIndex,
    this.fallbackFocusNode,
  });
  final TextEditingController controller;
  final List<AllAddressesModel> items;
  final InputDecoration decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<AllAddressesModel>? onSelected;
  final ValueChanged<int>? onPickIndex;
  // Focus is redirected here instead of being dropped, so the CallbackShortcuts
  // (F7/F8/F9) ancestor stays in the focused chain after a pick / tap-outside.
  final FocusNode? fallbackFocusNode;

  @override
  State<_AddressModelAutocomplete> createState() =>
      _AddressModelAutocompleteState();
}
class _AddressModelAutocompleteState extends State<_AddressModelAutocomplete> {
  final _layerLink = LayerLink();
  final _focusNode = FocusNode();
  final _fieldKey = GlobalKey();
  OverlayEntry? _entry;
  List<AllAddressesModel> _filtered = const [];
  int _highlighted = -1;
  bool _userTyped = false;

  /// Set while [_pick] lets the callbacks write the chosen address into the
  /// controller (onPickIndex → tapSelect does the actual write), so the text
  /// listener does not mistake that write for fresh typing and re-open the
  /// panel over a field the user just finished with.
  bool _picking = false;
  late final ScrollController _scrollController;
  static String _display(AllAddressesModel a) {
    final n = a.name ?? '';
    final p = a.postcode ?? '';
    if (n.isEmpty) return p;
    if (p.isEmpty) return n;
    return '$n, $p';
  }
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode.addListener(_onFocus);
    widget.controller.addListener(_onText);
  }
  @override
  void didUpdateWidget(covariant _AddressModelAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items && _userTyped) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_focusNode.hasFocus) return;
        // Late backend results arriving while the user navigates with the
        // arrow keys must NOT snap the highlight back to the top.
        _filter(widget.controller.text, preserveHighlight: true);
      });
    }
  }
  @override
  void dispose() {
    _hide();
    _focusNode.removeListener(_onFocus);
    widget.controller.removeListener(_onText);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  void _onFocus() {
    if (!_focusNode.hasFocus) _hide();
  }
  void _onText() {
    if (_picking || !_focusNode.hasFocus) return;
    final text = widget.controller.text.trim();
    if (text.isEmpty) {
      _userTyped = false;
      _hide();
      return;
    }
    _userTyped = true;
    _filter(widget.controller.text);
    _show();
  }
  void _filter(String q, {bool preserveHighlight = false}) {
    final query = q.trim().toLowerCase();
    // Remember the currently highlighted item so a list refresh can keep it.
    final AllAddressesModel? current = (preserveHighlight &&
        _highlighted >= 0 &&
        _highlighted < _filtered.length)
        ? _filtered[_highlighted]
        : null;

    if (query.isEmpty) {
      _filtered = const [];
    } else {
      _filtered = widget.items.where((a) {
        final n = (a.name ?? '').toLowerCase();
        final p = (a.postcode ?? '').toLowerCase();
        return n.contains(query) || p.contains(query);
      }).toList();
    }

    if (_filtered.isEmpty) {
      _highlighted = -1;
    } else if (preserveHighlight) {
      final idx = current == null ? -1 : _filtered.indexOf(current);
      _highlighted =
      idx >= 0 ? idx : _highlighted.clamp(0, _filtered.length - 1);
    } else {
      _highlighted = 0;
    }
    _entry?.markNeedsBuild();
  }
  void _show() {
    if (_entry != null) return;
    _entry = OverlayEntry(builder: _buildPanel);
    Overlay.of(context).insert(_entry!);
  }
  void _hide() {
    _entry?.remove();
    _entry = null;
  }
  void _pick(AllAddressesModel a) {
    final text = _display(a);
    _userTyped = false;
    // onPickIndex (→ tapSelect) and onSelected both rewrite this controller,
    // so every write stays inside the guard.
    _picking = true;
    widget.controller.text = text;
    final idx = widget.items.indexOf(a);
    if (idx >= 0) widget.onPickIndex?.call(idx);
    widget.onSelected?.call(a);
    _picking = false;
    // Caret at the end of whatever text the callbacks settled on (tapSelect
    // writes its own "NAME POSTCODE" form, not _display's).
    widget.controller.selection =
        TextSelection.collapsed(offset: widget.controller.text.length);
    // Close the panel but KEEP keyboard focus on this field. Handing focus to
    // fallbackFocusNode (the form-root shortcut node, which is skipTraversal)
    // made the next Tab restart the traversal order from the first field.
    // F7/F8/F9 still work: this field is a descendant of CallbackShortcuts, so
    // key events bubble up from here just as they did from the root node.
    _hide();
    if (!_focusNode.hasFocus) _focusNode.requestFocus();
  }
  void _moveHighlight(int delta) {
    if (_filtered.isEmpty) return;
    final next = (_highlighted + delta).clamp(0, _filtered.length - 1);
    if (next == _highlighted) return;
    _highlighted = next;
    _entry?.markNeedsBuild();
    _scrollHighlightedIntoView();
  }
  void _scrollHighlightedIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = _scrollController;
      if (!c.hasClients || _highlighted < 0) return;
      const itemHeight = 48.0;
      const panelHeight = 260.0;
      final itemTop = _highlighted * itemHeight;
      final itemBottom = itemTop + itemHeight;
      final viewTop = c.offset;
      final viewBottom = viewTop + panelHeight;
      final maxScroll = c.position.maxScrollExtent;
      if (itemTop < viewTop) {
        c.jumpTo(itemTop.clamp(0.0, maxScroll));
      } else if (itemBottom > viewBottom) {
        c.jumpTo((itemBottom - panelHeight).clamp(0.0, maxScroll));
      }
    });
  }
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      if (_entry != null) _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (_entry != null) _moveHighlight(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      if (_entry != null &&
          _highlighted >= 0 &&
          _highlighted < _filtered.length) {
        _pick(_filtered[_highlighted]);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.escape) {
      if (_entry != null) {
        _hide();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }
  Widget _buildPanel(BuildContext context) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 280;
    final height = box?.size.height ?? 48;
    return Positioned(
      width: width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, height + 4),
        child: TextFieldTapRegion(
          onTapOutside: (_) {
            if (widget.fallbackFocusNode != null) {
              widget.fallbackFocusNode!.requestFocus();
            } else {
              _focusNode.unfocus();
            }
          },
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 260),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _filtered.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: Text('No data',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
              )
                  : ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final a = _filtered[i];
                  final active = _highlighted == i;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      if (_highlighted == i) return;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        _highlighted = i;
                        _entry?.markNeedsBuild();
                      });
                    },
                    child: InkWell(
                      canRequestFocus: false,
                      onTap: () => _pick(a),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        color: active
                            ? const Color(0xFFEEF2FF)
                            : Colors.white,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${a.name} ${a.postcode}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: _GlowFocus(
        child: Focus(
          // Key-handling only (arrows / Enter / Esc drive the suggestion
          // panel). The inner TextField owns the single Tab stop; a focusable
          // wrapper would add a phantom stop that swallows a Tab press and
          // where typing does nothing. Key events still bubble up to here.
          canRequestFocus: false,
          onKeyEvent: _handleKey,
          child: TextField(
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            key: _fieldKey,
            onChanged: widget.onChanged,
            controller: widget.controller,
            focusNode: _focusNode,
            style: const TextStyle(fontSize: 12),
            decoration: widget.decoration,
          ),
        ),
      ),
    );
  }
}
// ════════════════════════════════════════════════════════════════════
// String-based autocomplete (kept for Mobile field)
// ════════════════════════════════════════════════════════════════════
class _StringAutocomplete extends StatefulWidget {
  const _StringAutocomplete({
    required this.controller,
    required this.suggestions,
    required this.decoration,
    this.onChanged,
  });
  final TextEditingController controller;
  final List<String> suggestions;
  final InputDecoration decoration;
  final ValueChanged<String>? onChanged;
  @override
  State<_StringAutocomplete> createState() => _StringAutocompleteState();
}
class _StringAutocompleteState extends State<_StringAutocomplete> {
  final _layerLink = LayerLink();
  final _focusNode = FocusNode();
  final _fieldKey = GlobalKey();
  OverlayEntry? _entry;
  List<String> _filtered = const [];
  int _highlighted = -1;
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode.addListener(_onFocus);
    widget.controller.addListener(_onText);
    _filtered = widget.suggestions;
  }
  @override
  void dispose() {
    _hide();
    _focusNode.removeListener(_onFocus);
    widget.controller.removeListener(_onText);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  void _onFocus() {
    if (_focusNode.hasFocus) {
      _filter(widget.controller.text);
      _show();
    } else {
      _hide();
    }
  }
  void _onText() {
    _filter(widget.controller.text);
    if (_focusNode.hasFocus) _show();
  }
  void _filter(String q) {
    final query = q.trim().toLowerCase();
    _filtered = query.isEmpty
        ? widget.suggestions
        : widget.suggestions
        .where((s) => s.toLowerCase().contains(query))
        .toList();
    _highlighted = _filtered.isEmpty ? -1 : 0;
    _entry?.markNeedsBuild();
  }
  void _show() {
    if (_entry != null) return;
    _entry = OverlayEntry(builder: _buildPanel);
    Overlay.of(context).insert(_entry!);
  }
  void _hide() {
    _entry?.remove();
    _entry = null;
  }
  void _pick(String value) {
    widget.controller.text = value;
    widget.controller.selection = TextSelection.collapsed(offset: value.length);
    _focusNode.unfocus();
  }
  void _moveHighlight(int delta) {
    if (_filtered.isEmpty) return;
    final next = (_highlighted + delta).clamp(0, _filtered.length - 1);
    if (next == _highlighted) return;
    _highlighted = next;
    _entry?.markNeedsBuild();
  }
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      if (_entry == null) _show();
      _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (_entry == null) _show();
      _moveHighlight(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      if (_entry != null &&
          _highlighted >= 0 &&
          _highlighted < _filtered.length) {
        _pick(_filtered[_highlighted]);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.escape) {
      if (_entry != null) {
        _hide();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }
  Widget _buildPanel(BuildContext context) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 280;
    final height = box?.size.height ?? 48;
    return Positioned(
      width: width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, height + 4),
        child: TapRegion(
          onTapOutside: (_) => _focusNode.unfocus(),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _filtered.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: Text('No matches',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
              )
                  : ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final s = _filtered[i];
                  final active = _highlighted == i;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      if (_highlighted == i) return;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        _highlighted = i;
                        _entry?.markNeedsBuild();
                      });
                    },
                    child: InkWell(
                      canRequestFocus: false,
                      onTap: () => _pick(s),
                      child: Container(
                        width: double.infinity,
                        height: 34,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                        color: active
                            ? const Color(0xFFEEF2FF)
                            : Colors.white,
                        alignment: Alignment.centerLeft,
                        child: Row(children: [
                          Icon(Icons.place_outlined,
                              size: 14,
                              color: active
                                  ? const Color(0xFF4F46E5)
                                  : Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(s,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: active
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                )),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: _GlowFocus(
        child: Focus(
          // Key-handling only (arrows / Enter / Esc drive the suggestion
          // panel). The inner TextField owns the single Tab stop; a focusable
          // wrapper would add a phantom stop that swallows a Tab press and
          // where typing does nothing. Key events still bubble up to here.
          canRequestFocus: false,
          onKeyEvent: _handleKey,
          child: TextField(
            key: _fieldKey,
            onChanged: widget.onChanged,
            controller: widget.controller,
            focusNode: _focusNode,
            style: const TextStyle(fontSize: 12),
            decoration: widget.decoration,
          ),
        ),
      ),
    );
  }
}
// ════════════════════════════════════════════════════════════════════
// Autocomplete: backed by CustomerObject (mobile + name + email)
// ════════════════════════════════════════════════════════════════════
class _CustomerModelAutocomplete extends StatefulWidget {
  const _CustomerModelAutocomplete({
    required this.controller,
    required this.items,
    required this.decoration,
    this.onChanged,
    this.onSelected,
  });
  final TextEditingController controller;
  final List<CustomerObject> items;
  final InputDecoration decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<CustomerObject>? onSelected;
  @override
  State<_CustomerModelAutocomplete> createState() =>
      _CustomerModelAutocompleteState();
}
class _CustomerModelAutocompleteState
    extends State<_CustomerModelAutocomplete> {
  final _layerLink = LayerLink();
  final _focusNode = FocusNode();
  final _fieldKey = GlobalKey();
  OverlayEntry? _entry;
  List<CustomerObject> _filtered = const [];
  int _highlighted = -1;
  bool _userTyped = false;

  /// Set while [_pick] writes the chosen customer into the controllers, so the
  /// text listener does not mistake that write for fresh typing and re-open
  /// the panel over a field the user just finished with.
  bool _picking = false;
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode.addListener(_onFocus);
    widget.controller.addListener(_onText);
  }
  @override
  void didUpdateWidget(covariant _CustomerModelAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items && _userTyped) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_focusNode.hasFocus) return;
        // Late backend results arriving while the user navigates with the
        // arrow keys must NOT snap the highlight back to the top.
        _filter(widget.controller.text, preserveHighlight: true);
      });
    }
  }
  @override
  void dispose() {
    _hide();
    _focusNode.removeListener(_onFocus);
    widget.controller.removeListener(_onText);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  void _onFocus() {
    if (!_focusNode.hasFocus) _hide();
  }
  void _onText() {
    if (_picking || !_focusNode.hasFocus) return;
    final text = widget.controller.text.trim();
    if (text.isEmpty) {
      _userTyped = false;
      _hide();
      return;
    }
    _userTyped = true;
    _filter(widget.controller.text);
    _show();
  }
  void _filter(String q, {bool preserveHighlight = false}) {
    final query = q.trim().toLowerCase();
    // Remember the currently highlighted item so a list refresh can keep it.
    final CustomerObject? current = (preserveHighlight &&
        _highlighted >= 0 &&
        _highlighted < _filtered.length)
        ? _filtered[_highlighted]
        : null;

    if (query.isEmpty) {
      _filtered = const [];
    } else {
      _filtered = widget.items.where((c) {
        final n = (c.name ?? '').toLowerCase();
        final m = (c.mobile ?? '').toLowerCase();
        final e = (c.email ?? '').toLowerCase();
        return n.contains(query) || m.contains(query) || e.contains(query);
      }).toList();
    }

    if (_filtered.isEmpty) {
      _highlighted = -1;
    } else if (preserveHighlight) {
      final idx = current == null ? -1 : _filtered.indexOf(current);
      _highlighted =
      idx >= 0 ? idx : _highlighted.clamp(0, _filtered.length - 1);
    } else {
      _highlighted = 0;
    }
    _entry?.markNeedsBuild();
  }
  void _show() {
    if (_entry != null) return;
    _entry = OverlayEntry(builder: _buildPanel);
    Overlay.of(context).insert(_entry!);
  }
  void _hide() {
    _entry?.remove();
    _entry = null;
  }
  void _pick(CustomerObject c) {
    final text = c.mobile ?? '';
    _userTyped = false;
    // onSelected re-writes this same controller (plus name / email / tel), so
    // both writes stay inside the guard.
    _picking = true;
    widget.controller.text = text;
    widget.onSelected?.call(c);
    _picking = false;
    // Keep the caret at the end of the picked value.
    widget.controller.selection =
        TextSelection.collapsed(offset: widget.controller.text.length);
    // Close the panel but KEEP keyboard focus on this field. Unfocusing here
    // handed primary focus back to the enclosing scope, which made the next
    // Tab restart the form's traversal order from the first field instead of
    // continuing to the one after Mobile.
    _hide();
    if (!_focusNode.hasFocus) _focusNode.requestFocus();
  }
  void _moveHighlight(int delta) {
    if (_filtered.isEmpty) return;
    final next = (_highlighted + delta).clamp(0, _filtered.length - 1);
    if (next == _highlighted) return;
    _highlighted = next;
    _entry?.markNeedsBuild();
    _scrollHighlightedIntoView();
  }
  void _scrollHighlightedIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = _scrollController;
      if (!c.hasClients || _highlighted < 0) return;
      const itemHeight = 48.0;
      const panelHeight = 260.0;
      final itemTop = _highlighted * itemHeight;
      final itemBottom = itemTop + itemHeight;
      final viewTop = c.offset;
      final viewBottom = viewTop + panelHeight;
      final maxScroll = c.position.maxScrollExtent;
      if (itemTop < viewTop) {
        c.jumpTo(itemTop.clamp(0.0, maxScroll));
      } else if (itemBottom > viewBottom) {
        c.jumpTo((itemBottom - panelHeight).clamp(0.0, maxScroll));
      }
    });
  }
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      if (_entry != null) _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (_entry != null) _moveHighlight(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      if (_entry != null &&
          _highlighted >= 0 &&
          _highlighted < _filtered.length) {
        _pick(_filtered[_highlighted]);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.escape) {
      if (_entry != null) {
        _hide();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }
  Widget _buildPanel(BuildContext context) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 280;
    final height = box?.size.height ?? 48;
    return Positioned(
      width: width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, height + 4),
        // TextFieldTapRegion (not a plain TapRegion): it joins the field's tap
        // group, so clicking a suggestion is NOT an "outside tap" for the
        // TextField. A plain TapRegion let EditableText's default
        // onTapOutside unfocus on pointer-down, which hid the panel before the
        // InkWell's onTap could fire — mouse picking silently did nothing
        // while the arrow keys (which never leave the field) worked.
        child: TextFieldTapRegion(
          onTapOutside: (_) => _focusNode.unfocus(),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 260),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _filtered.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: Text('No data',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
              )
                  : ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final c = _filtered[i];
                  final active = _highlighted == i;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      if (_highlighted == i) return;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        _highlighted = i;
                        _entry?.markNeedsBuild();
                      });
                    },
                    child: InkWell(
                      canRequestFocus: false,
                      onTap: () => _pick(c),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        color: active
                            ? const Color(0xFFEEF2FF)
                            : Colors.white,
                        alignment: Alignment.centerLeft,
                        child: Row(children: [
                          Icon(Icons.person_outline,
                              size: 16,
                              color: active
                                  ? const Color(0xFF4F46E5)
                                  : Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  c.mobile ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: active
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: _GlowFocus(
        child: Focus(
          // Key-handling only (arrows / Enter / Esc drive the suggestion
          // panel). The inner TextField owns the single Tab stop; a focusable
          // wrapper would add a phantom stop that swallows a Tab press and
          // where typing does nothing. Key events still bubble up to here.
          canRequestFocus: false,
          onKeyEvent: _handleKey,
          child: TextField(
            key: _fieldKey,
            onChanged: widget.onChanged,
            controller: widget.controller,
            focusNode: _focusNode,
            style: const TextStyle(fontSize: 12),
            keyboardType: TextInputType.phone,
            decoration: widget.decoration,
          ),
        ),
      ),
    );
  }
}
// ════════════════════════════════════════════════════════════════════
// Focus glow — soft animated "shining" purple halo shown around whichever
// field currently holds keyboard focus (reached via Tab / Shift+Tab).
// ════════════════════════════════════════════════════════════════════
// ════════════════════════════════════════════════════════════════════
// Focus ring — paints a crisp accent outline plus a soft halo around
// whichever control currently holds keyboard focus, so Tab / Shift+Tab has an
// unmistakable indicator on EVERY control type, not just the text inputs that
// get a coloured `focusedBorder`. Every field on this form sits on a black 1px
// border, which made a border-colour-only cue very hard to spot.
//
// Both cues are box shadows, so they paint OUTSIDE the child's rect and cost
// no layout: nothing shifts or resizes when focus arrives.
//
// The wrapper node is deliberately non-focusable and non-traversable — it only
// observes. `FocusNode.hasFocus` is true when the node OR ANY DESCENDANT holds
// primary focus, so this reports the focus state of whatever it wraps.
// ════════════════════════════════════════════════════════════════════
class _GlowFocus extends StatefulWidget {
  const _GlowFocus({required this.child, this.radius = 6});
  final Widget child;

  /// Corner radius of the ring. Match the wrapped control so the outline
  /// hugs it (6 = text fields / dropdowns / buttons, 8 = top tabs,
  /// 14+ = round icon buttons, switches and checkboxes).
  final double radius;

  @override
  State<_GlowFocus> createState() => _GlowFocusState();
}

class _GlowFocusState extends State<_GlowFocus> {
  static const _accent = Color(0xFF312E81);
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (hasFocus) {
        if (hasFocus != _focused) setState(() => _focused = hasFocus);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          // Painted in list order, so the soft halo goes down first and the
          // crisp ring lands on top of it.
          boxShadow: _focused
              ? const [
            BoxShadow(
                color: Color(0x40312E81), blurRadius: 8, spreadRadius: 4),
            BoxShadow(color: _accent, blurRadius: 0, spreadRadius: 2),
          ]
              : const [],
        ),
        child: widget.child,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// React-datepicker-style date field.
// • Single Tab focus stop → icon + border + date text take the accent color.
// • Enter / Space / Down (or click) opens a dropdown calendar anchored under
//   the field (an Overlay popup, NOT a Material dialog).
// • In the calendar: ‹ › navigate months, the title toggles month / year
//   pickers, arrow keys move the day selection, Enter confirms, Esc closes.
// • Selected day, today, headers and chips all use the accent (purple) palette.
// ════════════════════════════════════════════════════════════════════
class _CalendarDropdownField extends StatefulWidget {
  const _CalendarDropdownField({
    required this.value,
    required this.onChanged,
    required this.decoration,
    required this.textStyle,
    required this.accent,
    required this.accentSoft,
    required this.idleColor,
    required this.label
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final InputDecoration decoration;
  final TextStyle textStyle;
  final Color accent;
  final Color accentSoft;
  final Color idleColor;
  final String label;

  @override
  State<_CalendarDropdownField> createState() => _CalendarDropdownFieldState();
}

class _CalendarDropdownFieldState extends State<_CalendarDropdownField> {
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', //
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  static const _weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  // 0 = days, 1 = months, 2 = years
  static const _viewDays = 0;
  static const _viewMonths = 1;
  static const _viewYears = 2;

  final LayerLink _link = LayerLink();
  final FocusNode _fieldFocus = FocusNode(debugLabel: 'dateField');
  final FocusNode _calendarFocus = FocusNode(debugLabel: 'dateCalendar');
  final GlobalKey _fieldKey = GlobalKey();
  // Shared so a tap on the field is NOT treated as "outside" the calendar
  // (otherwise the field click closes via TapRegion AND reopens via InkWell).
  final Object _tapGroupId = Object();
  OverlayEntry? _entry;

  bool _focused = false;
  int _view = _viewDays;
  late DateTime _visibleMonth; // first-of-month being displayed
  DateTime? _selected;
  late int _yearPageStart;

  @override
  void initState() {
    super.initState();
    _fieldFocus.addListener(_onFocusChange);
    _selected = widget.value;
    final base = widget.value ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
  }

  @override
  void didUpdateWidget(covariant _CalendarDropdownField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _selected = widget.value;
      if (widget.value != null) {
        _visibleMonth = DateTime(widget.value!.year, widget.value!.month);
      }
    }
  }

  @override
  void dispose() {
    _closeCalendar(notify: false);
    _fieldFocus.removeListener(_onFocusChange);
    _fieldFocus.dispose();
    _calendarFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focused != _fieldFocus.hasFocus) {
      setState(() => _focused = _fieldFocus.hasFocus);
    }
  }

  bool get _isOpen => _entry != null;

  void _toggleCalendar() => _isOpen ? _closeCalendar() : _openCalendar();

  void _openCalendar() {
    if (_isOpen) return;
    _view = _viewDays;
    final base = _selected ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
    _entry = OverlayEntry(builder: _buildCalendarPanel);
    Overlay.of(context).insert(_entry!);
    setState(() {}); // refresh field chrome (arrow / accent)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _calendarFocus.requestFocus();
    });
  }

  void _closeCalendar({bool notify = true}) {
    _entry?.remove();
    _entry = null;
    if (notify && mounted) {
      setState(() {});
    }
  }

  void _rebuildPanel() => _entry?.markNeedsBuild();

  void _setView(int v) {
    if (v == _viewYears) _yearPageStart = _visibleMonth.year - 5;
    _view = v;
    _rebuildPanel();
  }

  void _navPrev() {
    if (_view == _viewDays) {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    } else if (_view == _viewMonths) {
      _visibleMonth = DateTime(_visibleMonth.year - 1, _visibleMonth.month);
    } else {
      _yearPageStart -= 12;
    }
    _rebuildPanel();
  }

  void _navNext() {
    if (_view == _viewDays) {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    } else if (_view == _viewMonths) {
      _visibleMonth = DateTime(_visibleMonth.year + 1, _visibleMonth.month);
    } else {
      _yearPageStart += 12;
    }
    _rebuildPanel();
  }

  void _pick(DateTime day) {
    _selected = DateTime(day.year, day.month, day.day);
    widget.onChanged(_selected!);
    _closeCalendar();
    _fieldFocus.requestFocus();
  }

  void _moveSelection(int days) {
    final base = _selected ?? _visibleMonth;
    final next = DateTime(base.year, base.month, base.day + days);
    _selected = next;
    _visibleMonth = DateTime(next.year, next.month);
    _view = _viewDays;
    _rebuildPanel();
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _format(DateTime? v) {
    if (v == null) return '';
    final d = v.day.toString().padLeft(2, '0');
    final m = v.month.toString().padLeft(2, '0');
    return '$d / $m / ${v.year}';
  }

  // ── field key handling: open the calendar
  KeyEventResult _onFieldKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.enter ||
        k == LogicalKeyboardKey.numpadEnter ||
        k == LogicalKeyboardKey.space ||
        k == LogicalKeyboardKey.arrowDown) {
      _openCalendar();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ── calendar key handling: navigate / confirm / close
  KeyEventResult _onCalendarKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.arrowLeft) {
      _moveSelection(-1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowRight) {
      _moveSelection(1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp) {
      _moveSelection(-7);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown) {
      _moveSelection(7);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.pageUp) {
      _navPrev();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.pageDown) {
      _navNext();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.numpadEnter) {
      _pick(_selected ?? _visibleMonth);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.escape) {
      _closeCalendar();
      _fieldFocus.requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ──────────────────────────────── field
  @override
  Widget build(BuildContext context) {
    final highlight = _focused || _isOpen;
    final iconColor = highlight ? widget.accent : widget.idleColor;

    final decoration = widget.decoration.copyWith(
      prefixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 0),
      label: Text(widget.label.toUpperCase(),),
      labelStyle: TextStyle(fontSize: 13, color: Colors.black),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 8, right: 4),
        child: Icon(Icons.calendar_today, size: 15, color: iconColor),
      ),
      suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 0),
      suffixIcon: Icon(
        _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        size: 20,
        color: highlight ? widget.accent : widget.idleColor,
      ),
    );

    return TapRegion(
      groupId: _tapGroupId,
      child: CompositedTransformTarget(
        link: _link,
        child: Focus(
          focusNode: _fieldFocus,
          onKeyEvent: _onFieldKey,
          child: InkWell(
            key: _fieldKey,
            canRequestFocus: false,
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              _fieldFocus.requestFocus();
              _toggleCalendar();
            },
            child: InputDecorator(
              isFocused: highlight,
              decoration: decoration,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: highlight
                    ? BoxDecoration(
                  color: widget.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                )
                    : null,
                child: Text(
                  _format(widget.value),
                  style: widget.textStyle.copyWith(
                    color: highlight ? widget.accent : widget.textStyle.color,
                    fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────── calendar popup
  Widget _buildCalendarPanel(BuildContext context) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth = box?.size.width ?? 280.0;
    final fieldHeight = box?.size.height ?? 40.0;
    final panelWidth = fieldWidth < 300 ? 300.0 : fieldWidth;

    return Positioned(
      width: panelWidth,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        offset: Offset(0, fieldHeight + 4),
        child: TapRegion(
          groupId: _tapGroupId,
          onTapOutside: (_) => _closeCalendar(),
          child: Focus(
            focusNode: _calendarFocus,
            onKeyEvent: _onCalendarKey,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _header(),
                    const SizedBox(height: 8),
                    if (_view == _viewDays) ...[
                      _weekdayRow(),
                      const SizedBox(height: 4),
                      _daysGrid(),
                    ] else if (_view == _viewMonths)
                      _monthsGrid()
                    else
                      _yearsGrid(),
                    const SizedBox(height: 6),
                    _footer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final String title = _view == _viewYears
        ? '$_yearPageStart - ${_yearPageStart + 11}'
        : '${_months[_visibleMonth.month - 1]} ${_visibleMonth.year}';
    return Row(
      children: [
        _navButton(Icons.chevron_left, _navPrev),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => _setView(_view == _viewDays ? _viewYears : _viewDays),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: widget.accent,
                  ),
                ),
              ),
            ),
          ),
        ),
        _navButton(Icons.chevron_right, _navNext),
      ],
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Icon(icon, size: 18, color: widget.accent),
    ),
  );

  Widget _weekdayRow() => Row(
    children: [
      for (final w in _weekdays)
        Expanded(
          child: Center(
            child: Text(
              w,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: widget.accent.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
    ],
  );

  Widget _daysGrid() {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday % 7; // Sunday = 0
    final today = DateTime.now();

    final cells = <Widget>[];
    for (var i = 0; i < leadingBlanks; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var d = 1; d <= daysInMonth; d++) {
      final day = DateTime(_visibleMonth.year, _visibleMonth.month, d);
      final isSelected = _selected != null && _sameDay(_selected!, day);
      final isToday = _sameDay(today, day);
      cells.add(_dayCell(d, isSelected, isToday, () => _pick(day)));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      childAspectRatio: 1.1,
      children: cells,
    );
  }

  Widget _dayCell(int day, bool selected, bool today, VoidCallback onTap) {
    Color bg = Colors.transparent;
    Color fg = Colors.black87;
    if (selected) {
      bg = widget.accent;
      fg = Colors.white;
    } else if (today) {
      bg = widget.accentSoft;
      fg = widget.accent;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: today && !selected
              ? Border.all(color: widget.accent, width: 1)
              : null,
        ),
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 12,
            color: fg,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _monthsGrid() => GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 6,
    crossAxisSpacing: 6,
    childAspectRatio: 1.8,
    children: [
      for (var m = 1; m <= 12; m++)
        _chip(
          _months[m - 1].substring(0, 3),
          m == _visibleMonth.month,
              () {
            _visibleMonth = DateTime(_visibleMonth.year, m);
            _setView(_viewDays);
          },
        ),
    ],
  );

  Widget _yearsGrid() => GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 6,
    crossAxisSpacing: 6,
    childAspectRatio: 1.8,
    children: [
      for (var i = 0; i < 12; i++)
        _chip(
          '${_yearPageStart + i}',
          (_yearPageStart + i) == _visibleMonth.year,
              () {
            _visibleMonth =
                DateTime(_yearPageStart + i, _visibleMonth.month);
            _setView(_viewMonths);
          },
        ),
    ],
  );

  Widget _chip(String label, bool selected, VoidCallback onTap) => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? widget.accent : widget.accentSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.white : widget.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  Widget _footer() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      TextButton(
        onPressed: () => _pick(DateTime.now()),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Today',
          style: TextStyle(
              color: widget.accent,
              fontSize: 12,
              fontWeight: FontWeight.w700),
        ),
      ),
      TextButton(
        onPressed: () {
          _closeCalendar();
          _fieldFocus.requestFocus();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Close',
          style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}