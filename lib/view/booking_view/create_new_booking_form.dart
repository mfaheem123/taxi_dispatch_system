// create_new_booking_form.dart
//
// A responsive booking / dispatch form for Flutter.
// Works on phone, iPad and web from a SINGLE layout definition.
//
// Responsive strategy:
//   * LayoutBuilder measures the available width.
//   * A breakpoint chooses a "base column count" (phone=1, tablet=2, desktop=4).
//   * Each field declares how many base columns it spans.
//   * A Wrap reflows the fields, so the same field list restacks automatically.
//
// The individual field widgets (address lookup, mobile lookup, dropdowns,
// date/time pickers, checkboxes, icon actions, ...) and the shared layout
// primitives (Density, Breakpoints, FormLayout, ResponsiveGrid, SectionCard,
// ...) live under booking_view/widgets/ — this file wires them together into
// the actual screen.
//
// Behaviour mirrors the dashboard booking form (auth/dashboard_form_widget.dart)
// field for field: every input reads and writes the same DashboardController
// field, and every action (address pick, clear, swap, via, journey type,
// vehicle, fares, CLEAR, SAVE) runs the same controller calls.

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../alert/child_seats_alert.dart';
import '../../alert/extra_info_alert.dart';
import '../../alert/search_booking.dart';
import '../../alert/setting_dialog.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/dashboard/F8_widget_alert.dart';
import '../dashboard_view/dashboard/F9_widget_alert.dart';
import '../dashboard_view/dashboard/map_view_widget.dart';
import '../dashboard_view/models/account_darshboard_model.dart';
import '../dashboard_view/models/dashboard_model.dart';
import '../dashboard_view/widgets/via_location.dart';
import '../locations_view/Model/location_types_zoneModel.dart' show ZoneObject;
import '../locations_view/controller/locations_controller.dart';
import 'widgets/booking_form_layout.dart';
import 'widgets/booking_form_parts.dart';
import 'widgets/labeled_address_field.dart';
import 'widgets/labeled_checkbox.dart';
import 'widgets/labeled_date_picker.dart';
import 'widgets/labeled_dropdown.dart';
import 'widgets/labeled_icon_actions.dart';
import 'widgets/labeled_input.dart';
import 'widgets/labeled_mobile_field.dart';
import 'widgets/labeled_time_picker.dart';
import 'widgets/update_booking_parts.dart' show LabeledActionButton;

// ---------------------------------------------------------------------------
// The screen itself.
// ---------------------------------------------------------------------------
class CreateNewBookingForm extends StatefulWidget {
  const CreateNewBookingForm({super.key});

  @override
  State<CreateNewBookingForm> createState() => _CreateNewBookingFormState();
}

class _CreateNewBookingFormState extends State<CreateNewBookingForm> {
  // Same controller the dashboard booking form uses, so every field and action
  // lands in the same state and hits the same backend calls.
  final DashboardController controller =
      Get.isRegistered<DashboardController>()
          ? Get.find<DashboardController>()
          : Get.put(DashboardController());

  // Same zone/location-type controller the dashboard form reads
  // locationtypezoneModel.zonesList from for its zone dropdowns.
  final LocationController _locationController =
      Get.isRegistered<LocationController>()
          ? Get.find<LocationController>()
          : Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    if (controller.dashboardAllData == null) {
      controller.dashboardData();
    }
    controller.seeZoneOnMapp();
    if (_locationController.locationtypezoneModel == null) {
      _locationController.getLocationTypeZone();
    }
  }

  // The zone list feeding all four zone dropdowns — empty until the fetch
  // above resolves, or while a fresh update-mode fetch is in flight, exactly
  // like the dashboard form's own guard around this same field.
  List<ZoneObject> get _zones =>
      _locationController.updateLocationValue.value == true ||
              _locationController.locationtypezoneModel == null
          ? []
          : (_locationController.locationtypezoneModel!.zonesList ?? []);

  // ---- Address search ------------------------------------------------------

  // Backed by controller.allAddressesData — the same list the dashboard form
  // feeds its PICK/DROP rows from, refreshed every time a search resolves.
  List<AddressSuggestion> get _addresses => controller.allAddressesData
      .map((a) =>
          AddressSuggestion(name: a.name ?? '', postcode: a.postcode ?? ''))
      .toList();

  /// Hands a picked suggestion to the controller by its index in
  /// allAddressesData — tapSelect() writes the address into whichever field
  /// the last search was for and places the marker / route / fare, exactly as
  /// the dashboard form's address rows do.
  void _onAddressPicked(AddressSuggestion a) {
    final i = controller.allAddressesData.indexWhere(
        (m) => m.name == a.name && (m.postcode ?? '') == a.postcode);
    if (i >= 0) controller.tapSelect(i);
  }

  /// Same as the dashboard rows: search as the user types, and run the row's
  /// clear handler when the field is emptied by hand.
  ValueChanged<String> _search(String fieldName, VoidCallback onEmptied) =>
      (value) {
        if (value.isEmpty) {
          onEmptied();
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.dropDownShow.value = value.trim().isNotEmpty;
          controller.onChangeHandler(
              fieldName: fieldName, searchingText: value);
        });
      };

  /// Shared tail of the outbound PICK / DROP clear handlers.
  void _resetOutboundFares() {
    controller.dropDownShow.value = false;
    controller.suggestions.clear();
    controller.totalDistance.value = "0.00";
    controller.totalTimeDuration.value = "0 min";
    controller.fixedFare.value = "0";
    controller.returnFareValue = "0";
    controller.tempStoreViaMils = "0";
    controller.slugController.clear();
    controller.slugControllerReturn.clear();
    controller.tempStoreMils = null;
    controller.fetchRouteFromOSRM();
    controller.update();
  }

  void _clearPickup() {
    controller.polyLineMarkerInfo
        .removeWhere((e) => e.markerType == "PICKUP LOCATION");
    controller.markers.removeWhere((e) => e.type == "pickup");
    controller.pickupController.clear();
    controller.clearViaIfNoPickupAndDrop();
    _resetOutboundFares();
  }

  void _clearDrop() {
    controller.polyLineMarkerInfo
        .removeWhere((e) => e.markerType == "DROP LOCATION");
    controller.markers.removeWhere((e) => e.type == "dropOff");
    controller.dropOffController.clear();
    controller.clearViaIfNoPickupAndDrop();
    _resetOutboundFares();
  }

  void _clearReturnPickup() {
    controller.polyLineMarkerInfo
        .removeWhere((e) => e.markerType == "PICKUP TWO WAY LOCATION");
    controller.markers.removeWhere((e) => e.type == "pickup two way");
    controller.pickupTwoWayController.clear();
    controller.clearReturnViaIfNoPickupAndDrop();
    controller.selectAirportControllerReturn.clear();
    controller.arrivalReturnTimeController.clear();
    controller.isAirportResponseReturn.value = false;
    controller.dropDownShow.value = false;
    controller.fetchRouteFromOSRM();
    controller.update();
  }

  void _clearReturnDrop() {
    controller.polyLineMarkerInfo
        .removeWhere((e) => e.markerType == "DROP TWO WAY LOCATION");
    controller.markers.removeWhere(
        (e) => e.type == "dropOff two way" || e.type == "via with return");
    controller.dropOffTwoWayController.clear();
    controller.clearReturnViaIfNoPickupAndDrop();
    controller.dropDownShow.value = false;
    controller.fetchRouteFromOSRM();
    controller.update();
  }

  /// DROP's route button: the via-points dialog, outbound side.
  void _openVia() {
    if (controller.pickupController.text.isEmpty) {
      BotToast.showText(text: "Please write pickup and dropoff location");
      return;
    }
    showDialog(context: context, builder: (_) => ViaLocation());
  }

  /// R/DROP's route button: the same dialog, opened on the return side.
  void _openReturnVia() {
    if (controller.pickupTwoWayController.text.isEmpty) {
      BotToast.showText(
          text: "Please write return pickup and dropoff location");
      return;
    }
    controller.viaSelectionOneWay.value = false;
    showDialog(context: context, builder: (_) => ViaLocation());
  }

  // ---- Customer lookup -----------------------------------------------------

  // Backed by controller.customerPhoneNumber — the same lookup the dashboard
  // form's MOBILE field feeds its autocomplete from.
  List<CustomerSuggestion> get _customers =>
      (controller.customerPhoneNumber?.customerInfo ?? const [])
          .map((c) => CustomerSuggestion(
                mobile: c.mobile ?? '',
                name: c.name ?? '',
                email: c.email ?? '',
                telephone: c.telephone ?? '',
              ))
          .toList();

  void _onMobileSearch(String value) {
    if (value.trim().isEmpty) return;
    controller.onPhoneNoChangeHandler(
        fieldName: 'Phone Number', searchingText: value);
  }

  void _onCustomerPicked(CustomerSuggestion c) {
    setState(() {
      controller.mobileController.text = c.mobile;
      controller.nameController.text = c.name;
      controller.emailController.text = c.email;
      controller.telController.text = c.telephone;
    });
  }

  void _showPickBooking() {
    showDialog(
      context: context,
      builder: (_) => SearchBookingAlert(
        pickMobileNumber: controller.mobileController.text,
        pickName: controller.nameController.text,
        pickTeleNumber: controller.telController.text,
      ),
    );
  }

  // ---- Journey type --------------------------------------------------------

  /// True while the selected journey type has a return leg — the same test
  /// as the dashboard form's _isReturnJourney. Every R/ field is shown only
  /// then, so Tab never walks over inputs that cannot apply.
  bool get _hasReturn {
    final j =
        controller.selectJourneyTypeValue?.journeyType?.toUpperCase().trim();
    return j == 'R/N' || j == 'RETURN';
  }

  void _onJourneyChanged(JourneyTypeObject? v) {
    if (controller.pickupController.text.isEmpty ||
        controller.dropOffController.text.isEmpty) {
      BotToast.showText(text: "Please select pickup and drop location first");
      // Rebuild so the dropdown snaps back to the controller's value.
      setState(() {});
      return;
    }
    setState(() {
      controller.dropDownShow.value = false;
      controller.selectJourneyTypeValue = v;
      switch ((v?.journeyType ?? '').trim().toLowerCase()) {
        case 'o/w':
          controller.jourValue = 'O/W';
          controller.changeJourneyFtn();
          break;
        case 'r/n':
          controller.jourValue = 'R/N';
          break;
        case 'w/r':
          controller.jourValue = 'W/R';
          controller.changeJourneyFtn();
          break;
        default:
          controller.jourValue = null;
      }
    });
    controller.getFaresCalculation();
  }

  /// [field] when the booking has a return leg, nothing when it does not.
  /// Returning a list lets it be spread straight into a grid's children.
  List<SpanField> _ifReturn(SpanField field) => _hasReturn ? [field] : const [];

  // ---- Vehicles ------------------------------------------------------------

  void _onVehicleChanged(DashboardVehicleTypeObject? v) {
    setState(() {
      controller.selectVehicleValue = v;
      // Same as the dashboard: take the vehicle's seat count, re-check it.
      if (v?.passengers != null) {
        controller.passController.text = v!.passengers.toString();
      }
      controller.validatePassengerLimit(controller.passController.text);
    });
    controller.getFaresCalculation();
  }

  void _onReturnVehicleChanged(DashboardVehicleTypeObject? v) {
    if (v == null) return;
    setState(() {
      controller.selectVehicleValueReturn = v;
      controller.dropDownShow.value = false;
    });
    controller.getFaresCalculation();
    controller.update();
  }

  // ---- Actions -------------------------------------------------------------

  void _onSave() {
    if (controller.jourValue == 'R/N' &&
        controller.pickupTwoWayController.text.isEmpty &&
        controller.dropOffTwoWayController.text.isEmpty) {
      BotToast.showText(text: "Please chose waiting return");
      return;
    }
    controller.dashBoardApiValidation(
      id: (controller.jobDetails == null ||
              controller.cliJobHit == true ||
              controller.isPickBooking == true)
          ? null
          : int.parse(controller.jobDetails!.id!),
    );
  }

  String _fareText() {
    final f = double.tryParse(controller.fixedFare.value) ?? 0;
    return '£ ${f.toStringAsFixed(1)}';
  }

  /// FL / ARP pair shown under an address once its search came back as an
  /// airport (outbound or return).
  List<SpanField> _airportFields(bool visible,
          TextEditingController flight, TextEditingController arrival) =>
      visible
          ? [
              SpanField(LabeledInput('FL', controller: flight, uppercase: true),
                  span: 2),
              SpanField(LabeledInput('ARP', controller: arrival)),
            ]
          : const [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Theme(
          // Applied here so the compact field heights survive even if this
          // screen is embedded under someone else's MaterialApp.
          data:
              Theme.of(context).copyWith(inputDecorationTheme: denseInputTheme),
          child: LayoutBuilder(
            builder: (context, constraints) => FormLayout(
              // Decided once, from the real screen width, for the whole form.
              inlineLabels: constraints.maxWidth >= Breakpoints.inlineLabel,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Center(
                  // Cap the width on very large screens so the form doesn't
                  // stretch into an unusable full-bleed layout on big monitors.
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: FocusTraversalGroup(
                      // Explicit order rather than geometry: a Wrap can place
                      // a short field (a checkbox) above a tall one, which is
                      // enough to confuse reading-order traversal.
                      policy: OrderedTraversalPolicy(
                        requestFocusCallback: smoothTraversalFocus,
                      ),
                      // Outer GetBuilder: zones (LocationController.update()).
                      // Inner: everything on DashboardController — address and
                      // customer search results, the dashboard lookup lists,
                      // and every update() the shared actions fire.
                      child: PageScrollWrapper(
                        child: GetBuilder<LocationController>(
                          builder: (_) => GetBuilder<DashboardController>(
                            builder: (controller) =>
                                controller.dashboardAllData == null
                                    ? const Padding(
                                        padding: EdgeInsets.all(40),
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()),
                                      )
                                    : _form(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    final data = controller.dashboardAllData!;
    final vehicles = data.vehicleTypes ?? const <DashboardVehicleTypeObject>[];
    final drivers = data.drivers ?? const <DashboardDriverObject>[];
    String driverLabel(DashboardDriverObject d) => d.name ?? '';
    String vehicleLabel(DashboardVehicleTypeObject v) => v.name ?? '';

    return Column(
      children: [
        TopTabs(tabs: [
          const TopTab('F2', 'BOOKING', active: true),
          TopTab('F8', '+ MULTI RESERVATION', onTap: () {
            if (controller.pickupController.text.isNotEmpty &&
                controller.dropOffController.text.isNotEmpty) {
              DashboardF8Alert.show();
            }
          }),
          TopTab('F9', '+ VEHICLES', onTap: () {
            if (controller.pickupController.text.isNotEmpty &&
                controller.dropOffController.text.isNotEmpty) {
              DashboardF9Alert.show();
            }
          }),
          TopTab('VIA', 'VIA (${controller.viaPoints.length})',
              onTap: _openVia),
        ]),
        const SizedBox(height: Density.cardGap),

        // ---- Booking header: source + sub ----
        SectionCard(
          child: ResponsiveGrid(
            orderBase: 100,
            children: [
              SpanField(HeaderTitle('BOOKING'), span: 2),
              // No source field exists on the controller / booking payload
              // yet, so this one stays local.
              SpanField(LabeledDropdown('SOURCE',
                  items: ['OPT', 'WEB', 'APP', 'PHONE'])),
              SpanField(LabeledObjectDropdown<DashboardSubsidiaryObject>(
                'SUB',
                items: data.subsidiaries ?? const [],
                value: controller.selectSubsidiariesValue,
                itemLabel: (s) => s.name ?? '',
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    controller.selectSubsidiariesValue = v;
                    controller.getAccountData(subsidiariesId: v.id);
                  });
                },
              )),
            ],
          ),
        ),

        // ---- Pick / Drop + contact ----
        SectionCard(
          child: ResponsiveGrid(
            orderBase: 200,
            children: [
              SpanField(
                  LabeledAddressField(
                    'PICK',
                    controller: controller.pickupController,
                    addresses: _addresses,
                    dotColor: Colors.green,
                    onSwap: controller.swapeToChangeLocation,
                    onSearch: _search('PICKUP LOCATION', _clearPickup),
                    onPicked: _onAddressPicked,
                    onCleared: _clearPickup,
                  ),
                  span: 2),
              SpanField(LabeledZoneDropdown(
                'PICK ZONE',
                items: _zones,
                value: controller.dashboardZoneValue,
                onChanged: (v) {
                  setState(() => controller.dashboardZoneValue = v);
                  controller.getFaresCalculation();
                },
              )),
              SpanField(LabeledInput('PICKUP NOTES',
                  controller: controller.pickUpNoteController,
                  uppercase: true)),
              ..._airportFields(
                  controller.isAirportResponse.value,
                  controller.selectAirportController,
                  controller.arrivalTimeController),
              SpanField(
                  LabeledAddressField(
                    'DROP',
                    controller: controller.dropOffController,
                    addresses: _addresses,
                    dotColor: Colors.red,
                    onSwap: controller.swapeToChangeLocation,
                    onSearch: _search('DROP LOCATION', _clearDrop),
                    onPicked: _onAddressPicked,
                    onCleared: _clearDrop,
                    extraAction: IconAction(
                        icon: Icons.route,
                        tooltip: 'Via locations',
                        onTap: _openVia),
                  ),
                  span: 2),
              SpanField(LabeledZoneDropdown(
                'DROP ZONE',
                items: _zones,
                value: controller.dashboardDZoneValue,
                onChanged: (v) {
                  setState(() => controller.dashboardDZoneValue = v);
                  controller.getFaresCalculation();
                },
              )),
              SpanField(LabeledInput('DROPOFF NOTES',
                  controller: controller.dropUpNoteController,
                  uppercase: true)),
              SpanField(
                  LabeledInput('NAME', controller: controller.nameController)),
              SpanField(LabeledInput('EMAIL',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress)),
              SpanField(LabeledMobileField(
                'MOBILE',
                controller: controller.mobileController,
                customers: _customers,
                onSearch: _onMobileSearch,
                onPicked: _onCustomerPicked,
              )),
              SpanField(LabeledInput('TEL',
                  controller: controller.telController,
                  keyboardType: TextInputType.phone)),
              SpanField(LabeledActionButton(
                text: 'PICK BOOKING',
                icon: Icons.search,
                onPressed: _showPickBooking,
              ), id: 'PICK BOOKING'),
            ],
          ),
        ),

        // ---- Dates & times + return leg ----
        SectionCard(
          child: ResponsiveGrid(
            orderBase: 300,
            children: [
              SpanField(LabeledDatePicker(
                'DATE',
                value: controller.pickUpDate,
                onChanged: (d) => setState(() {
                  controller.pickUpDate = d;
                  controller.pickUpDatePicked = true;
                }),
              )),
              SpanField(LabeledTimePicker(
                'TIME',
                controller: controller.pickUpTimeController,
                onChanged: (_) => controller.pickUpTimePicked = true,
              )),
              // Everything below describes the return leg, so a journey type
              // without one drops the lot.
              ..._ifReturn(SpanField(LabeledDatePicker(
                'R/DATE',
                value: controller.pickUpDateReturn,
                onChanged: (d) => setState(() {
                  controller.pickUpDateReturn = d;
                  controller.pickUpDateReturnPicked = true;
                }),
              ))),
              ..._ifReturn(SpanField(LabeledTimePicker(
                'R/TIME',
                controller: controller.pickUpTimeControllerReturn,
                onChanged: (_) => controller.pickUpTimeReturnPicked = true,
              ))),
              ..._ifReturn(SpanField(
                  LabeledAddressField(
                    'R/PICK',
                    controller: controller.pickupTwoWayController,
                    addresses: _addresses,
                    dotColor: Colors.green,
                    onSwap: controller.swapeToChangeReturnLocation,
                    onSearch:
                        _search('PICKUP TWO WAY LOCATION', _clearReturnPickup),
                    onPicked: _onAddressPicked,
                    onCleared: _clearReturnPickup,
                  ),
                  span: 2)),
              ..._ifReturn(SpanField(LabeledZoneDropdown(
                'R/PICK ZONE',
                items: _zones,
                value: _locationController.RNzoneValue,
                onChanged: (v) => setState(() {
                  controller.dashboardRNZoneValue = v;
                  _locationController.RNzoneValue = v;
                }),
              ))),
              ..._ifReturn(SpanField(LabeledInput('R/PICK NOTES',
                  controller: controller.returnPickUpNoteController,
                  uppercase: true))),
              if (_hasReturn)
                ..._airportFields(
                    controller.isAirportResponseReturn.value,
                    controller.selectAirportControllerReturn,
                    controller.arrivalReturnTimeController),
              ..._ifReturn(SpanField(
                  LabeledAddressField(
                    'R/DROP',
                    controller: controller.dropOffTwoWayController,
                    addresses: _addresses,
                    dotColor: Colors.red,
                    onSwap: controller.swapeToChangeReturnLocation,
                    onSearch:
                        _search('DROP TWO WAY LOCATION', _clearReturnDrop),
                    onPicked: _onAddressPicked,
                    onCleared: _clearReturnDrop,
                    extraAction: IconAction(
                        icon: Icons.route,
                        tooltip: 'Via locations',
                        onTap: _openReturnVia),
                  ),
                  span: 2)),
              ..._ifReturn(SpanField(LabeledZoneDropdown(
                'R/DROP ZONE',
                items: _zones,
                value: _locationController.RN1zoneValue,
                onChanged: (v) => setState(() {
                  controller.dashboardRN1ZoneValue = v;
                  _locationController.RN1zoneValue = v;
                }),
              ))),
              ..._ifReturn(SpanField(LabeledInput('R/DROP NOTES',
                  controller: controller.returnDropUpNoteController,
                  uppercase: true))),
            ],
          ),
        ),

        // ---- Journey details ----
        SectionCard(
          child: ResponsiveGrid(
            orderBase: 400,
            children: [
              SpanField(LabeledInput('LEAD (MINS)',
                  controller: controller.minController,
                  keyboardType: TextInputType.number)),
              SpanField(LabeledObjectDropdown<JourneyTypeObject>(
                'JOUR',
                items: data.journeyTypes ?? const [],
                value: controller.selectJourneyTypeValue,
                itemLabel: (j) => j.journeyType ?? '',
                onChanged: _onJourneyChanged,
              )),
              SpanField(LabeledObjectDropdown<DashboardVehicleTypeObject>(
                'VEH',
                items: vehicles,
                value: controller.selectVehicleValue,
                itemLabel: vehicleLabel,
                onChanged: _onVehicleChanged,
              )),
              ..._ifReturn(
                  SpanField(LabeledObjectDropdown<DashboardVehicleTypeObject>(
                'R/VEH',
                items: vehicles,
                value: controller.selectVehicleValueReturn,
                itemLabel: vehicleLabel,
                onChanged: _onReturnVehicleChanged,
              ))),
              SpanField(LabeledObjectDropdown<DashboardAccountObject>(
                'ACC',
                items: controller.dashboardAccountData?.accounts ?? const [],
                value: controller.selectAccountValue,
                itemLabel: (a) => a.name ?? '',
                hint: 'SELECT ACCOUNT',
                onChanged: (v) => setState(() {
                  controller.selectAccountValue = v;
                  controller.selectDepartmentData = null;
                }),
              )),
              SpanField(LabeledObjectDropdown<DepartmentObject>(
                'DEPT',
                items: controller.selectAccountValue?.departments ?? const [],
                value: controller.selectDepartmentData,
                itemLabel: (d) => d.name ?? '',
                hint: 'SELECT DEPARTMENT',
                onChanged: (v) => setState(() {
                  controller.selectDepartmentData = v;
                  controller.update();
                }),
              )),
              SpanField(Obx(() => LabeledInput(
                    'PASS',
                    controller: controller.passController,
                    keyboardType: TextInputType.number,
                    isError: controller.isPassengerError.value,
                    onChanged: controller.validatePassengerLimit,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                  )),
                  // Obx hides the LabelledField label the grid keys cells by.
                  id: 'PASS'),
              SpanField(LabeledInput('LUGG',
                  controller: controller.luggController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ])),
              SpanField(LabeledInput('SLGG',
                  controller: controller.sluggController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ])),
            ],
          ),
        ),

        // ---- Payment + options ----
        SectionCard(
          child: ResponsiveGrid(
            orderBase: 500,
            children: [
              SpanField(LabeledObjectDropdown<PaymentTypeObject>(
                'PAY',
                items: data.paymentTypes ?? const [],
                value: controller.selectPaymentTypeValue,
                itemLabel: (p) => p.name ?? '',
                onChanged: (v) =>
                    setState(() => controller.selectPaymentTypeValue = v),
              )),
              ..._ifReturn(SpanField(LabeledInput('R/LEAD (MINS)',
                  controller: controller.minControllerReturn,
                  keyboardType: TextInputType.number))),
              // The dashboard form's quotation switch is bound to
              // dropDownShow; kept identical here.
              SpanField(
                  Obx(() => LabeledCheckbox('QUOTATION',
                      value: controller.dropDownShow.value,
                      onChanged: (v) => controller.dropDownShow.value = v)),
                  widths: 110,
                  id: 'QUOTATION'),
              SpanField(
                  Obx(() => LabeledCheckbox('SMS',
                      value: controller.smsCheckbox.value,
                      onChanged: (v) => controller.smsCheckbox.value = v)),
                  widths: 80,
                  id: 'SMS'),
              SpanField(
                  Obx(() => LabeledCheckbox('EMAIL',
                      value: controller.emailCheckbox.value,
                      onChanged: (v) => controller.emailCheckbox.value = v)),
                  widths: 80,
                  id: 'EMAIL'),
              // Same three dialogs, same order, as the dashboard form's
              // icon buttons beside LUGGAGE.
              SpanField(
                LabeledIconActions([
                  IconAction(
                    icon: Icons.settings_suggest,
                    tooltip: 'SETTINGS',
                    onTap: () => showDialog(
                        context: context, builder: (_) => SettingsDialog()),
                  ),
                  IconAction(
                    icon: Icons.attach_money,
                    tooltip: 'CHILD SEATS',
                    onTap: () => showDialog(
                        context: context, builder: (_) => ChildSeatsAlert()),
                  ),
                  IconAction(
                    icon: Icons.sticky_note_2,
                    tooltip: 'EXTRA INFO',
                    onTap: () => showDialog(
                        context: context, builder: (_) => ExtraInfoAlert()),
                  ),
                ]),
                widths: LabeledIconActions.width(3),
              ),
              ..._ifReturn(SpanField(
                  Obx(() => LabeledCheckbox('ADD RETURN FARE',
                      value: controller.addReturnFare.value,
                      onChanged: (v) => controller.addReturnFare.value = v)),
                  widths: 150,
                  id: 'ADD RETURN FARE')),
            ],
          ),
        ),

        // ---- Fares row ----
        SectionCard(
          child: Column(
            children: [
              Obx(() => StatStrip(stats: [
                    BookingStat(Icons.info_outline, 'ETA:',
                        '${controller.totalTimeDuration}'),
                    // Hard-coded on the dashboard form as well.
                    const BookingStat(
                        Icons.timer_outlined, 'JOURNEY:', '0.0 mins'),
                    BookingStat(Icons.route, 'DISTANCE:',
                        '${controller.totalDistance}'),
                    BookingStat(
                        Icons.payments_outlined, 'T/FARES:', _fareText()),
                  ])),
              const SizedBox(height: Density.gridSpacing),
              ResponsiveGrid(
                orderBase: 600,
                children: [
                  SpanField(LabeledInput('FARE (£)',
                      controller: controller.slugController,
                      keyboardType: TextInputType.number)),
                  ..._ifReturn(SpanField(LabeledInput('R/FARE (£)',
                      controller: controller.slugControllerReturn,
                      keyboardType: TextInputType.number))),
                  SpanField(LabeledObjectDropdown<DashboardDriverObject>(
                    'DRV',
                    items: drivers,
                    value: controller.selectDriverValue,
                    itemLabel: driverLabel,
                    hint: 'SELECT DRIVER',
                    onChanged: (v) =>
                        setState(() => controller.selectDriverValue = v),
                  )),
                  ..._ifReturn(
                      SpanField(LabeledObjectDropdown<DashboardDriverObject>(
                    'R/DRV',
                    items: drivers,
                    value: controller.selectDriverValueReturn,
                    itemLabel: driverLabel,
                    hint: 'SELECT DRIVER',
                    onChanged: (v) =>
                        setState(() => controller.selectDriverValueReturn = v),
                  ))),
                ],
              ),
            ],
          ),
        ),

        // ---- Action buttons ----
        ActionButtons(
          onClear: controller.refreshPostAllFields,
          onSave: _onSave,
        ),

        // ---- Map (same widget as the dashboard) ----
        // Fixed height because the form scrolls, same as craate_booking.dart.
        SizedBox(
          height: Get.height / 2.1,
          child: MapViewWidget(createBooking: true),
        ),
      ],
    );
  }
}
