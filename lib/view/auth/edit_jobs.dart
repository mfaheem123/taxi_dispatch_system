// edit_jobs.dart
//
// The UPDATE BOOKING form — an existing job opened for editing.
//
// Built from the same pieces as the create form (see
// booking_view/create_new_booking_form.dart): the shared layout primitives in
// booking_view/widgets/booking_form_layout.dart decide column count and label
// placement, the labeled_* widgets are the fields, and
// booking_view/widgets/update_booking_parts.dart adds the chrome this screen
// needs and the create form does not — the header bar, the fares bar and the
// bottom actions.
//
// How it differs from the create form:
//   * a header bar identifying the booking (reference, who raised it, status,
//     the associated leg) and carrying the actions that apply to the booking
//     as a whole;
//   * fields arrive pre-filled;
//   * PICK/DROP and their return counterparts each pair with an unlabelled
//     zone dropdown and notes field, which is what
//     `FieldShell`-with-an-empty-label is for;
//   * CANCEL / RECEIPT / AUDIT REPORT / SAVE instead of the create actions.
//
// ---------------------------------------------------------------------------
// LOCATION FIELDS
//
// PICK / DROP / R-PICK / R-DROP behave exactly as they do on the dashboard
// booking form (auth/dashboard_form_widget.dart's _locationRow): typing runs
// the same debounced lookup, picking a suggestion goes through
// DashboardController.tapSelect — which is what actually drops the map marker,
// rebuilds the polyline and refetches the route, distance and fare — the ×
// button tears that same state back down, and the swap button runs the
// controller's own swap so the markers follow the text.
//
// That means these four fields are bound to DashboardController's OWN
// controllers (`pickupController`, `dropOffController`,
// `pickupTwoWayController`, `dropOffTwoWayController`) rather than to private
// ones, because `tapSelect` writes into those by name — it dispatches on
// `selectedTextFieldsValue`, the field name the last search set. Binding
// anywhere else would show the address but drop the map and fare work on the
// floor.
//
// The consequence is deliberate and worth knowing: the location fields, their
// zones and their notes are shared with the dashboard form, so loading a
// booking here loads it there too. The contact and fare fields, which have no
// such controller contract, stay private to this screen.
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../Model/via_point.dart';
import '../../alert/child_seats_alert.dart';
import '../../alert/extra_fares_alert.dart';
import '../../alert/restrict_drivers_alert.dart';
import '../booking_view/widgets/booking_form_layout.dart';
import '../booking_view/widgets/booking_form_parts.dart';
import '../booking_view/widgets/labeled_address_field.dart';
import '../booking_view/widgets/labeled_checkbox.dart';
import '../booking_view/widgets/labeled_date_picker.dart';
import '../booking_view/widgets/labeled_dropdown.dart';
import '../booking_view/widgets/labeled_icon_actions.dart';
import '../booking_view/widgets/labeled_input.dart';
import '../booking_view/widgets/labeled_mobile_field.dart';
import '../booking_view/widgets/labeled_time_picker.dart';
import '../booking_view/widgets/update_booking_parts.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/dashboard/map_view_widget.dart';
import '../locations_view/Model/location_types_zoneModel.dart' show ZoneObject;
import '../locations_view/controller/locations_controller.dart';
import '../page_scroller.dart';

/// Everything the header bar and the pre-filled fields need to open a booking
/// for editing.
///
/// Passing one of these in is what turns this screen from a layout into an
/// actual booking; the defaults exist so it can be pushed with no arguments
/// while the caller is still being wired up.
class EditJobDetails {
  /// The booking's id in the backend.
  ///
  /// Set it and the screen loads the real booking through
  /// [DashboardController.dashBoardDataBinding] — the same call the old update
  /// screen makes — which fills the shared fields and plots the route from what
  /// the API returns. Left null, the screen falls back to the coordinates
  /// below, which is what lets it be pushed with no arguments at all and still
  /// draw something.
  final int? id;

  final String reference;
  final String user;
  final String bookedAt;
  final String status;
  final String? associatedReference;

  final String pickup;
  final String dropoff;
  final String returnPickup;
  final String returnDropoff;

  final String name;
  final String email;
  final String mobile;
  final String telephone;

  final String fare;
  final String returnFare;

  /// Read-only figures for the fares bar.
  final String eta;
  final String distance;
  final String totalFares;

  // ---- Where those four addresses actually are ----------------------------
  // The map draws points, not text, and nothing on this screen geocodes: a
  // booking opened without an [id] has to arrive with its coordinates or the
  // map has nothing to plot. Kept as plain doubles rather than LatLng so the
  // whole model stays const-constructible.
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final double? returnPickupLat;
  final double? returnPickupLng;
  final double? returnDropoffLat;
  final double? returnDropoffLng;

  const EditJobDetails({
    this.id,
    this.reference = 'DCB75789',
    this.user = 'NADEEM',
    this.bookedAt = '24-08-26 09:20',
    this.status = 'WAITING',
    this.associatedReference = 'DCB75795',
    this.pickup = 'NORTHWICK AVENUE HARROW HA3 0AA',
    this.dropoff = 'GREEN PARK WAY GREENFORD UB6 0AD',
    this.returnPickup = 'GREEN PARK WAY GREENFORD UB6 0AD',
    this.returnDropoff = 'NORTHWICK AVENUE HARROW HA3 0AA',
    this.name = 'CUSTOMER',
    this.email = '',
    this.mobile = '000',
    this.telephone = '',
    this.fare = '10.9',
    this.returnFare = '10.9',
    this.eta = '0 M',
    this.distance = '3.34 M',
    this.totalFares = '£ 21.80',
    // Approximate positions for the two placeholder addresses above — enough
    // to draw a believable route on the argument-less demo, not survey data.
    // A real booking passes its own, or an [id] and lets the API supply them.
    this.pickupLat = 51.5722,
    this.pickupLng = -0.3194,
    this.dropoffLat = 51.5413,
    this.dropoffLng = -0.3477,
    this.returnPickupLat = 51.5413,
    this.returnPickupLng = -0.3477,
    this.returnDropoffLat = 51.5722,
    this.returnDropoffLng = -0.3194,
  });

  /// The four legs as map points, in the order the route runs. A leg with no
  /// coordinates comes back null and is simply not plotted.
  LatLng? get pickupPoint => _point(pickupLat, pickupLng);
  LatLng? get dropoffPoint => _point(dropoffLat, dropoffLng);
  LatLng? get returnPickupPoint => _point(returnPickupLat, returnPickupLng);
  LatLng? get returnDropoffPoint => _point(returnDropoffLat, returnDropoffLng);

  static LatLng? _point(double? lat, double? lng) =>
      (lat == null || lng == null) ? null : LatLng(lat, lng);
}

class EditJobsWidget extends StatefulWidget {
  final EditJobDetails booking;

  const EditJobsWidget({super.key, this.booking = const EditJobDetails()});

  @override
  State<EditJobsWidget> createState() => _EditJobsWidgetState();
}

class _EditJobsWidgetState extends State<EditJobsWidget> {
  // Reused rather than re-registered: the location fields below drive this
  // controller's map, route and fare state directly, so it has to be the same
  // instance the dashboard and the map are looking at.
  final DashboardController _dashboard = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  final LocationController _locations = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  // ---- Field names ---------------------------------------------------------
  // The strings DashboardController.onChangeHandler and tapSelect dispatch on.
  // They are the contract between a location field and the controller, so they
  // have to match the dashboard form's exactly.
  static const _pickField = 'PICKUP LOCATION';
  static const _dropField = 'DROP LOCATION';
  static const _rPickField = 'PICKUP TWO WAY LOCATION';
  static const _rDropField = 'DROP TWO WAY LOCATION';

  // ---- Fields this screen owns --------------------------------------------
  // Contact and fare values only. The four locations, their zones and their
  // notes live on DashboardController — see the note at the top of the file.
  late final _name = TextEditingController(text: widget.booking.name);
  late final _email = TextEditingController(text: widget.booking.email);
  late final _mobile = TextEditingController(text: widget.booking.mobile);
  late final _tel = TextEditingController(text: widget.booking.telephone);
  late final _fare = TextEditingController(text: widget.booking.fare);
  late final _rFare = TextEditingController(text: widget.booking.returnFare);

  /// PICK is the only one of the four locations DashboardController keeps no
  /// focus node for, so this screen supplies one — exactly as the dashboard
  /// form does with its own `_pickupFieldFocusNode`.
  final FocusNode _pickupFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (_locations.locationtypezoneModel == null) {
      _locations.getLocationTypeZone();
    }
    // Load the booking into the shared location fields. Straight assignment
    // rather than tapSelect: there is no suggestion list to index into yet,
    // and the booking's route is whatever the backend already costed.
    // _dashboard.pickupController.text = widget.booking.pickup;
    // _dashboard.dropOffController.text = widget.booking.dropoff;
    // _dashboard.pickupTwoWayController.text = widget.booking.returnPickup;
    // _dashboard.dropOffTwoWayController.text = widget.booking.returnDropoff;

    // After the first frame, not during initState: both paths below end in
    // DashboardController.update(), and a GetBuilder cannot be rebuilt while it
    // is still being built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _seedMap();
    });
  }

  // ---- Putting the booking on the map -------------------------------------

  /// Draw this booking's route.
  ///
  /// [MapViewWidget] has no input of its own — it renders whatever
  /// DashboardController is holding at the time — so a screen that opens with a
  /// booking already filled in has to seed that state itself. The dashboard
  /// form never needs this because it builds the same state a pick at a time
  /// through `tapSelect`; here the addresses arrive already chosen, so nothing
  /// has run and the map would come up on whatever the dashboard last plotted.
  ///
  /// Two ways in, matching where the booking came from:
  ///   * with an [EditJobDetails.id], through the controller's own loader,
  ///     which fetches the booking and plots it — what the old update screen
  ///     does;
  ///   * without one, straight from the coordinates on the booking.
  void _seedMap() {
    final b = widget.booking;
    if (b.id != null) {
      _dashboard.dashBoardDataBinding(id: b.id);
      return;
    }

    // markerType is the contract fetchRouteFromOSRM dispatches on — the same
    // four names the location fields register under, which is why they are the
    // constants above rather than repeated strings.
    final legs = <(String, LatLng?)>[
      (_pickField, b.pickupPoint),
      (_dropField, b.dropoffPoint),
      if (_hasReturn) (_rPickField, b.returnPickupPoint),
      if (_hasReturn) (_rDropField, b.returnDropoffPoint),
    ];

    final c = _dashboard;
    // The same wipe dashBoardDataBinding opens with: this is a different
    // booking than whatever the dashboard was last holding, so its points, its
    // legs and its vias all go. markers and polylinePointsCoordinate are left
    // alone — fetchRouteFromOSRM clears those itself.
    c.polyLineMarkerInfo.clear();
    c.polylinePoints.clear();
    c.viaPoints.clear();
    c.viaTextEditingController.clear();

    for (final (field, point) in legs) {
      if (point == null) continue;
      c.polylinePoints.add(point);
      c.polyLineMarkerInfo.add(ViaPoint(
        address: '',
        lat: point.latitude,
        lng: point.longitude,
        markerType: field,
      ));
    }

    if (c.polyLineMarkerInfo.isEmpty) {
      c.update();
      return;
    }
    // Builds the markers, fetches the road route behind the straight line and
    // frames the whole journey — and calls update(), which is what gets the
    // map to repaint.
    c.fetchRouteFromOSRM();
  }

  @override
  void dispose() {
    // Only what this screen made. The location controllers and their three
    // focus nodes belong to DashboardController and outlive this form.
    for (final c in [_name, _email, _mobile, _tel, _fare, _rFare]) {
      c.dispose();
    }
    _pickupFocus.dispose();
    super.dispose();
  }

  // ---- Lookup plumbing ----------------------------------------------------

  /// Empty until the zone fetch resolves, and while a fresh one is in flight —
  /// the same guard the dashboard form puts around this field, since a dropdown
  /// whose value is not in its item list asserts.
  List<ZoneObject> get _zones =>
      _locations.updateLocationValue.value == true ||
              _locations.locationtypezoneModel == null
          ? []
          : (_locations.locationtypezoneModel!.zonesList ?? []);

  List<AddressSuggestion> get _addresses => _dashboard.allAddressesData
      .map((a) =>
          AddressSuggestion(name: a.name ?? '', postcode: a.postcode ?? ''))
      .toList();

  /// Runs the dashboard's debounced lookup and opens or closes the suggestion
  /// panel with it. Called on every keystroke, empty included — an empty value
  /// still has to register [field] as the active one, because that is what
  /// [DashboardController.tapSelect] reads to decide which field a later pick
  /// belongs to.
  void _onLocationSearch(String field, String value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dashboard.dropDownShow.value = value.isNotEmpty;
      _dashboard.onChangeHandler(fieldName: field, searchingText: value);
    });
  }

  /// Commits a picked suggestion the way the dashboard does — through
  /// [DashboardController.tapSelect], by index into `allAddressesData`.
  ///
  /// tapSelect is what makes the pick mean anything: it replaces the field's
  /// polyline point, writes the address into the bound controller itself and
  /// refetches the route so distance and fare follow.
  void _onLocationPicked(AddressSuggestion a) {
    final index = _indexOfSuggestion(a);
    if (index >= 0) _dashboard.tapSelect(index);
  }

  /// Position of [a] in `allAddressesData`, or -1. tapSelect takes an index
  /// rather than a model, and [LabeledAddressField] hands back display strings.
  int _indexOfSuggestion(AddressSuggestion a) {
    final data = _dashboard.allAddressesData;
    for (var i = 0; i < data.length; i++) {
      if ((data[i].name ?? '') == a.name &&
          (data[i].postcode ?? '') == a.postcode) {
        return i;
      }
    }
    return -1;
  }

  /// Tears down everything one outbound location contributed: its polyline
  /// point, its map marker, the via points that only existed to join it to the
  /// other end, and the costing that came out of the route.
  ///
  /// Mirrors the dashboard form's PICKUP / DROP clear buttons.
  void _clearOutbound({required bool pickup}) {
    final c = _dashboard;
    c.polyLineMarkerInfo
        .removeWhere((e) => e.markerType == (pickup ? _pickField : _dropField));
    c.markers.removeWhere((m) => m.type == (pickup ? 'pickup' : 'dropOff'));
    (pickup ? c.pickupController : c.dropOffController).clear();
    c.dropDownShow.value = false;
    c.suggestions.clear();
    // Only drops the one-way via points if BOTH ends are now empty.
    c.clearViaIfNoPickupAndDrop();
    c.totalDistance.value = '0.00';
    c.totalTimeDuration.value = '0 min';
    c.fixedFare.value = '0';
    c.returnFareValue = '0';
    c.tempStoreViaMils = '0';
    c.slugController.clear();
    c.slugControllerReturn.clear();
    c.tempStoreMils = null;
    c.fetchRouteFromOSRM();
    FocusScope.of(context)
        .requestFocus(pickup ? _pickupFocus : c.dropOffTextFieldFocusNode);
    c.update();
  }

  /// The return leg's equivalent. Lighter than [_clearOutbound] because the
  /// outbound costing stands on its own — clearing a return location must not
  /// zero the fare the outbound journey earned.
  ///
  /// Mirrors the dashboard form's return PICK / DROP clear buttons.
  void _clearReturn({required bool pickup}) {
    final c = _dashboard;
    c.polyLineMarkerInfo.removeWhere(
        (e) => e.markerType == (pickup ? _rPickField : _rDropField));
    c.markers.removeWhere(
        (m) => m.type == (pickup ? 'pickup two way' : 'dropOff two way'));
    if (!pickup) {
      // The dashboard drops the return-leg via markers with R/DROP, the end
      // they hang off.
      c.markers.removeWhere((m) => m.type == 'via with return');
    }
    (pickup ? c.pickupTwoWayController : c.dropOffTwoWayController).clear();
    c.clearReturnViaIfNoPickupAndDrop();
    if (pickup) {
      // The arrival details describe where the return leg starts, so they go
      // when it does.
      c.selectAirportControllerReturn.clear();
      c.arrivalReturnTimeController.clear();
      c.isAirportResponseReturn.value = false;
    }
    c.dropDownShow.value = false;
    c.fetchRouteFromOSRM();
    FocusScope.of(context).requestFocus(pickup
        ? c.pickupTwoTextFieldFocusNode
        : c.dropOffTwoWayTextFieldFocusNode);
    c.update();
  }

  List<CustomerSuggestion> get _customers =>
      (_dashboard.customerPhoneNumber?.customerInfo ?? const [])
          .map((c) => CustomerSuggestion(
                mobile: c.mobile ?? '',
                name: c.name ?? '',
                email: c.email ?? '',
                telephone: c.telephone ?? '',
              ))
          .toList();

  void _onMobileSearch(String value) {
    if (value.trim().isEmpty) return;
    _dashboard.onPhoneNoChangeHandler(
        fieldName: 'Phone Number', searchingText: value);
  }

  void _onCustomerPicked(CustomerSuggestion c) {
    setState(() {
      _name.text = c.name;
      _email.text = c.email;
      _tel.text = c.telephone;
    });
  }

  // ---- Journey type -------------------------------------------------------
  // Same rule as the create form: on ONE WAY every return field is removed, so
  // the form gets shorter and Tab stops walking over inputs that cannot apply.
  static const _journeyTypes = ['R/N', 'ONE WAY'];
  static const _oneWay = 'ONE WAY';

  bool _hasReturn = true;

  void _onJourneyChanged(String? value) {
    final hasReturn = value != _oneWay;
    if (hasReturn == _hasReturn) return;
    setState(() {
      _hasReturn = hasReturn;
      if (hasReturn) return;
      // The whole return leg is gone, so everything it put on the map and in
      // the costing goes with it — the same cleanup the dashboard form's
      // _clearTwoWayData does.
      final c = _dashboard;
      c.polyLineMarkerInfo.removeWhere((e) =>
          e.markerType == _rPickField || e.markerType == _rDropField);
      c.markers.removeWhere((m) =>
          m.type == 'pickup two way' ||
          m.type == 'dropOff two way' ||
          m.type == 'via with return');
      // Backwards, so removing one does not shift the ones still to check.
      for (var i = c.viaPoints.length - 1; i >= 0; i--) {
        if (c.viaPoints[i].withReturnWay == 'via with return') {
          c.viaPoints.removeAt(i);
          if (i < c.viaTextEditingController.length) {
            c.viaTextEditingController.removeAt(i);
          }
        }
      }
      c.pickupTwoWayController.clear();
      c.dropOffTwoWayController.clear();
      c.returnPickUpNoteController.clear();
      c.returnDropUpNoteController.clear();
      c.returnFareValue = '';
      c.tempStoreMils = null;
      c.fetchRouteFromOSRM();
      c.update();
      _rFare.clear();
      _locations.RNzoneValue = null;
      _locations.RN1zoneValue = null;
    });
  }

  /// [field] when the booking has a return leg, nothing when it does not.
  List<SpanField> _ifReturn(SpanField field) => _hasReturn ? [field] : const [];

  /// A map big enough to read a route on without pushing the form's own fields
  /// out of reach. Measured off the real viewport rather than `Get.height` so a
  /// resized or embedded window gets a map that still fits, and clamped rather
  /// than left as a straight fraction: half of a laptop's height is a usable
  /// map, half of a phone's is not.
  static double _mapHeight(BoxConstraints constraints) {
    if (!constraints.maxHeight.isFinite) return 420;
    return (constraints.maxHeight * 0.55).clamp(280.0, 520.0).toDouble();
  }

  // ---- Placeholder handlers ----------------------------------------------
  // The actions the design shows that have no endpoint yet, wired to a single
  // reporting stub so the screen is fully clickable. The location fields above
  // are NOT among these — they are live.
  void _todo(String action) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action — not wired up yet'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const vehicles = ['SALOON', 'ESTATE', 'MPV', 'EXECUTIVE'];
    const drivers = ['SELECT DRIVER', 'Driver 1', 'Driver 2'];
    final b = widget.booking;

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
                // Horizontal breathing room only — the section cards carry
                // their own padding, so a matching 10 top and bottom just
                // pushed the header and the action row away from the edges.
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                child: Center(
                  // Cap the width on very large screens so the form does not
                  // stretch into an unusable full-bleed layout.
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: FocusTraversalGroup(
                      // Explicit order rather than geometry: a Wrap can place a
                      // short field (a checkbox) above a tall one, which is
                      // enough to confuse reading-order traversal.
                      policy: OrderedTraversalPolicy(
                        requestFocusCallback: smoothTraversalFocus,
                      ),
                      child: PageScrollWrapper(
                        // Two nested GetBuilders, as on the create form: the
                        // outer rebuilds when LocationController.update() fires
                        // and refills the zone list feeding all four zone
                        // dropdowns; the inner rebuilds when
                        // DashboardController.update() fires — which the
                        // location clear buttons and tapSelect both do — and
                        // refills the address and customer suggestion lists.
                        child: GetBuilder<LocationController>(
                          builder: (_) => GetBuilder<DashboardController>(
                            builder: (_) => Column(
                              children: [
                                // ---- Who / what / where this booking is ----
                                UpdateBookingHeader(
                                  reference: b.reference,
                                  user: b.user,
                                  bookedAt: b.bookedAt,
                                  status: b.status,
                                  associatedReference: b.associatedReference,
                                  onAssociatedTap: () =>
                                      _todo('OPEN ASSOCIATED BOOKING'),
                                  onTrack: () => _todo('TRACK JOURNEY'),
                                  onMessages: () => _todo('MESSAGES'),
                                  onDispatch: () => _todo('DISPATCH'),
                                  onComplaint: () => _todo('COMPLAINT'),
                                  onLostProperty: () => _todo('LOST PROPERTY'),
                                ),

                                // ---- The booking itself ----
                                SectionCard(
                                  child: ResponsiveGrid(
                                    orderBase: 100,
                                    children: [
                                      // PICK spans two columns and carries the
                                      // row's label; the zone and notes cells
                                      // beside it are unlabelled, so they close
                                      // straight up against it.
                                      SpanField(
                                        LabeledAddressField(
                                          'PICK',
                                          controller:
                                              _dashboard.pickupController,
                                          focusNode: _pickupFocus,
                                          addresses: _addresses,
                                          dotColor: UpdateFormPalette.green,
                                          onSearch: (v) =>
                                              _onLocationSearch(_pickField, v),
                                          onPicked: _onLocationPicked,
                                          onCleared: () =>
                                              _clearOutbound(pickup: true),
                                          onSwap: _dashboard
                                              .swapeToChangeLocation,
                                        ),
                                        span: 2,
                                      ),
                                      SpanField(
                                        LabeledZoneDropdown(
                                          '',
                                          items: _zones,
                                          value: _dashboard.dashboardZoneValue,
                                          onChanged: (v) => setState(() =>
                                              _dashboard.dashboardZoneValue =
                                                  v),
                                        ),
                                        id: 'pickZone',
                                      ),
                                      SpanField(
                                        LabeledInput('',
                                            hint: 'PICKUP NOTES',
                                            controller:
                                                _dashboard.pickUpNoteController,
                                            uppercase: true,
                                            prefixIcon:
                                                Icons.local_taxi_outlined),
                                        id: 'pickNotes',
                                      ),
                                      SpanField(
                                        LabeledAddressField(
                                          'DROP',
                                          controller:
                                              _dashboard.dropOffController,
                                          focusNode: _dashboard
                                              .dropOffTextFieldFocusNode,
                                          addresses: _addresses,
                                          dotColor: Colors.red,
                                          extraAction: IconAction(
                                            icon: Icons.add_location_alt_outlined,
                                            tooltip: 'ADD VIA POINT',
                                            onTap: () => _todo('ADD VIA POINT'),
                                          ),
                                          onSearch: (v) =>
                                              _onLocationSearch(_dropField, v),
                                          onPicked: _onLocationPicked,
                                          onCleared: () =>
                                              _clearOutbound(pickup: false),
                                          onSwap: _dashboard
                                              .swapeToChangeLocation,
                                        ),
                                        span: 2,
                                      ),
                                      SpanField(
                                        LabeledZoneDropdown(
                                          '',
                                          items: _zones,
                                          value: _dashboard.dashboardDZoneValue,
                                          onChanged: (v) => setState(() =>
                                              _dashboard.dashboardDZoneValue =
                                                  v),
                                        ),
                                        id: 'dropZone',
                                      ),
                                      SpanField(
                                        LabeledInput('',
                                            hint: 'DROPOFF NOTES',
                                            controller:
                                                _dashboard.dropUpNoteController,
                                            uppercase: true,
                                            prefixIcon:
                                                Icons.local_taxi_outlined),
                                        id: 'dropNotes',
                                      ),

                                      // ---- Contact ----
                                      SpanField(
                                          LabeledInput('NAME',
                                              controller: _name,
                                              uppercase: true)),
                                      SpanField(LabeledInput('EMAIL',
                                          controller: _email,
                                          keyboardType:
                                              TextInputType.emailAddress)),
                                      SpanField(LabeledMobileField(
                                        'MOBILE',
                                        controller: _mobile,
                                        customers: _customers,
                                        onSearch: _onMobileSearch,
                                        onPicked: _onCustomerPicked,
                                      )),
                                      SpanField(LabeledInput('TEL',
                                          controller: _tel,
                                          keyboardType: TextInputType.phone)),
                                      SpanField(
                                        LabeledActionButton(
                                          text: 'PICK BOOKING',
                                          icon: Icons.search,
                                          onPressed: () =>
                                              _todo('PICK BOOKING'),
                                        ),
                                        id: 'pickBooking',
                                      ),

                                      // ---- Dates & times ----
                                      SpanField(LabeledDatePicker('DATE')),
                                      SpanField(LabeledTimePicker('TIME')),
                                      ..._ifReturn(
                                          SpanField(LabeledDatePicker('R/DATE'))),
                                      ..._ifReturn(
                                          SpanField(LabeledTimePicker('R/TIME'))),

                                      // ---- Return leg locations ----
                                      ..._ifReturn(SpanField(
                                        LabeledAddressField(
                                          'R/PICK',
                                          controller: _dashboard
                                              .pickupTwoWayController,
                                          focusNode: _dashboard
                                              .pickupTwoTextFieldFocusNode,
                                          addresses: _addresses,
                                          dotColor: UpdateFormPalette.green,
                                          onSearch: (v) =>
                                              _onLocationSearch(_rPickField, v),
                                          onPicked: _onLocationPicked,
                                          onCleared: () =>
                                              _clearReturn(pickup: true),
                                          onSwap: _dashboard
                                              .swapeToChangeReturnLocation,
                                        ),
                                        span: 2,
                                      )),
                                      ..._ifReturn(SpanField(
                                        LabeledZoneDropdown(
                                          '',
                                          items: _zones,
                                          value: _locations.RNzoneValue,
                                          onChanged: (v) => setState(
                                              () => _locations.RNzoneValue = v),
                                        ),
                                        id: 'rPickZone',
                                      )),
                                      ..._ifReturn(SpanField(
                                        LabeledInput('',
                                            hint: 'PICKUP NOTES',
                                            controller: _dashboard
                                                .returnPickUpNoteController,
                                            uppercase: true,
                                            prefixIcon:
                                                Icons.local_taxi_outlined,
                                            prefixText: 'R/'),
                                        id: 'rPickNotes',
                                      )),
                                      ..._ifReturn(SpanField(
                                        LabeledAddressField(
                                          'R/DROP',
                                          controller: _dashboard
                                              .dropOffTwoWayController,
                                          focusNode: _dashboard
                                              .dropOffTwoWayTextFieldFocusNode,
                                          addresses: _addresses,
                                          dotColor: Colors.red,
                                          extraAction: IconAction(
                                            icon: Icons.add_location_alt_outlined,
                                            tooltip: 'ADD VIA POINT',
                                            onTap: () => _todo('ADD VIA POINT'),
                                          ),
                                          onSearch: (v) =>
                                              _onLocationSearch(_rDropField, v),
                                          onPicked: _onLocationPicked,
                                          onCleared: () =>
                                              _clearReturn(pickup: false),
                                          onSwap: _dashboard
                                              .swapeToChangeReturnLocation,
                                        ),
                                        span: 2,
                                      )),
                                      ..._ifReturn(SpanField(
                                        LabeledZoneDropdown(
                                          '',
                                          items: _zones,
                                          value: _locations.RN1zoneValue,
                                          onChanged: (v) => setState(() =>
                                              _locations.RN1zoneValue = v),
                                        ),
                                        id: 'rDropZone',
                                      )),
                                      ..._ifReturn(SpanField(
                                        LabeledInput('',
                                            hint: 'DROPOFF NOTES',
                                            controller: _dashboard
                                                .returnDropUpNoteController,
                                            uppercase: true,
                                            prefixIcon:
                                                Icons.local_taxi_outlined,
                                            prefixText: 'R/'),
                                        id: 'rDropNotes',
                                      )),

                                      // ---- Journey details ----
                                      SpanField(LabeledInput('LEAD',
                                          hint: 'MINS',
                                          keyboardType: TextInputType.number)),
                                      SpanField(LabeledDropdown('JOUR',
                                          items: _journeyTypes,
                                          onChanged: _onJourneyChanged)),
                                      SpanField(LabeledDropdown('VEH',
                                          items: vehicles)),
                                      ..._ifReturn(SpanField(LabeledDropdown(
                                          'R/VEH',
                                          items: vehicles))),

                                      SpanField(LabeledDropdown('ACC', items: [
                                        'SELECT ACCOUNT',
                                        'Account 1',
                                        'Account 2'
                                      ])),
                                      SpanField(
                                          LabeledCheckbox('QUOTATION',
                                              circular: true),
                                          widths: 120),
                                      SpanField(LabeledInput('PASS',
                                          keyboardType: TextInputType.number)),
                                      SpanField(LabeledInput('LUGG',
                                          keyboardType: TextInputType.number)),
                                      SpanField(LabeledInput('SLGG',
                                          keyboardType: TextInputType.number)),

                                      // ---- Payment ----
                                      SpanField(LabeledDropdown('PAY', items: [
                                        'CASH',
                                        'CARD',
                                        'ACCOUNT',
                                        'INVOICE'
                                      ])),
                                      ..._ifReturn(SpanField(
                                          LabeledCheckbox('ADD RETURN FARE',
                                              circular: true),
                                          widths: 150)),
                                      SpanField(LabeledDropdown('SOURCE',
                                          items: ['OPT', 'WEB', 'APP', 'PHONE'])),
                                      SpanField(LabeledDropdown('SUB', items: [
                                        'DEMO COMPANY',
                                        'Company 2',
                                        'Company 3'
                                      ])),
                                      // Shortcuts into the booking's extra
                                      // detail dialogs, last in this section so
                                      // Tab reaches them after the fields.
                                      SpanField(
                                        LabeledIconActions([
                                          IconAction(
                                            icon: Icons.groups_outlined,
                                            tooltip: 'RESTRICT DRIVERS',
                                            background:
                                                UpdateFormPalette.green,
                                            onTap: () => showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  RestrictDriversAlert(),
                                            ),
                                          ),
                                          IconAction(
                                            icon: Icons.child_care_outlined,
                                            tooltip: 'CHILD SEATS',
                                            background:
                                                UpdateFormPalette.valueText,
                                            onTap: () => showDialog(
                                              context: context,
                                              builder: (_) => ChildSeatsAlert(),
                                            ),
                                          ),
                                          IconAction(
                                            icon: Icons.note_alt_outlined,
                                            tooltip: 'EXTRA FARES',
                                            background:
                                                UpdateFormPalette.valueText,
                                            onTap: () => showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => ExtraFaresAlert(),
                                            ),
                                          ),
                                        ]),
                                        widths: LabeledIconActions.width(3),
                                        id: 'extras',
                                      ),

                                      ..._ifReturn(SpanField(
                                          LabeledInput('R/LEAD',
                                              hint: 'MINS',
                                              keyboardType:
                                                  TextInputType.number))),
                                    ],
                                  ),
                                ),

                                // ---- What it has been costed at ----
                                FaresBar(
                                  stats: [
                                    BookingStat(
                                        Icons.timer_outlined, 'ETA:', b.eta),
                                    BookingStat(Icons.route, 'DISTANCE:',
                                        b.distance),
                                    BookingStat(Icons.payments_outlined,
                                        'T/FARES:', b.totalFares),
                                  ],
                                  fareFields: [
                                    LabeledInput('FARE',
                                        controller: _fare,
                                        keyboardType: TextInputType.number),
                                    if (_hasReturn)
                                      LabeledInput('R/FARE',
                                          controller: _rFare,
                                          keyboardType: TextInputType.number),
                                  ],
                                  onRecalculate: () =>
                                      _todo('RECALCULATE FARES'),
                                ),

                                // ---- Who is driving it, and the actions ----
                                SectionCard(
                                  child: ResponsiveGrid(
                                    orderBase: 600,
                                    children: [
                                      SpanField(LabeledDropdown('DRV',
                                          items: drivers)),
                                      ..._ifReturn(SpanField(LabeledDropdown(
                                          'R/DRV',
                                          items: drivers))),
                                      SpanField(
                                        UpdateActionButtons(
                                          onCancel: () => _todo('CANCEL'),
                                          onReceipt: () => _todo('RECEIPT'),
                                          onAuditReport: () =>
                                              _todo('AUDIT REPORT'),
                                          onSave: () => _todo('SAVE'),
                                        ),
                                        span: 2,
                                        id: 'actions',
                                      ),
                                    ],
                                  ),
                                ),
                                // ---- The journey, drawn ----
                                // Full form width, because it is a child of the
                                // same Column every SectionCard above sits in,
                                // and framed like one so it reads as part of
                                // the form rather than something stuck under
                                // it.
                                //
                                // The height matters more than it looks:
                                // MapViewWidget is a Stack with no size of its
                                // own, so an unbounded parent takes its inner
                                // layout out with a "size: MISSING" — the same
                                // reason the dashboard wraps it in a SizedBox.
                                Container(
                                  width: double.infinity,
                                  height: _mapHeight(constraints),
                                  margin: const EdgeInsets.only(
                                      bottom: Density.cardGap),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xFFE0E0E0)),
                                  ),
                                  // createBooking drops the MAPS / PLOT toggle
                                  // and the distance readout it carries: both
                                  // belong to the dashboard, and this screen
                                  // already has the fares bar for the figures.
                                  child: MapViewWidget(createBooking: true),
                                ),
                              ],
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
      ),
    );
  }
}
