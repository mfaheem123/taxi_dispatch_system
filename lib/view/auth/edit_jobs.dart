// edit_jobs.dart
//
// The EDIT JOB screen — an existing booking opened for editing.
//
// Design-wise this is the dashboard booking form (auth/dashboard_form_widget.dart)
// exactly as it stands: the same top tab strip, the same PICKUP / DROP location
// rows, the same sections, the same status cards and the same driver row, built
// from the same private primitives so the two screens cannot drift apart
// visually.
//
// What this file adds is only what a standalone route needs and a panel on the
// dashboard does not:
//
//   * [EditJobDetails] — the booking to open. With an [EditJobDetails.id] the
//     screen loads the real booking through
//     [DashboardController.dashBoardDataBinding] (the same call the old update
//     screen made), which fills the fields and plots the route from what the API
//     returns.
//   * a [Scaffold], because this is pushed as a page rather than embedded.
//   * the form runs at the full page width instead of the dashboard's half.
//   * [MapViewWidget] under the form — on the dashboard the map sits BESIDE the
//     form, so a standalone copy has to carry its own or the PICK / DROP route
//     the fields are drawing would be invisible.
//
// Everything else — every field, every binding, every keyboard order — is the
// dashboard form's, unchanged. The F2 "focus first field" hook is deliberately
// NOT registered here: the dashboard form stays mounted under this route, and
// claiming the hook would leave the dashboard without one once this screen pops.

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_date_picker/flutter_web_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import '../dashboard_view/dashboard/map_view_widget.dart';
import '../dashboard_view/models/account_darshboard_model.dart';
import '../dashboard_view/models/all_addresses_model.dart';
import '../dashboard_view/models/dashboard_model.dart';
import '../dashboard_view/models/users_phone_numbers_model.dart';
import '../dashboard_view/utils/address_query_match.dart';
import '../dashboard_view/utils/page_arrow_scroll.dart';
import '../dashboard_view/widgets/fare_configuration.dart';
import '../locations_view/Model/location_types_zoneModel.dart' show ZoneObject;
import '../locations_view/controller/locations_controller.dart';


// ════════════════════════════════════════════════════════════════════
// Typography
// ════════════════════════════════════════════════════════════════════
/// Declared in pubspec.yaml against assets/font-family/MozillaText-Regular.ttf.
const _kFontFamily = 'MozillaText-Regular';

/// What the user typed or picked: bold, tracked, pure black — so a filled
/// field reads apart from an empty one at a glance.
const _kValueTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.5,
  color: Colors.black,
);

/// Placeholder text, unchanged from before [_kValueTextStyle] went bold.
///
/// The weight and the tracking have to be spelled out even though they are the
/// old values: InputDecorator derives the hint from `titleMedium` merged with
/// the field's own `style`, and the Material 2 defaults this app runs on
/// contribute only a colour — so without this the bold and the tracking of the
/// value style would bleed into every empty field. `color` is deliberately
/// left null so the theme's hint colour still comes through the merge.
const _kHintTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.15,
);

/// Floating field labels — pinned for the same reason as [_kHintTextStyle].
const _kLabelTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.15,
  color: Colors.black,
);

/// The chrome every field on this form wears — border, focus tint, floating
/// label. Lives at top level so the dropdowns can be decorated from the same
/// place as the text fields instead of drawing a look-alike box of their own.
InputDecoration _kFieldDecoration() => InputDecoration(
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
  // Focused fields tint their background. InputDecorator resolves fillColor
  // against its own state set (which carries WidgetState.focused), so this
  // covers every field, dropdown, the date field and the time field in one
  // place. The unfocused value is white — the same as the card behind it —
  // so nothing looks different until focus actually arrives.
  filled: true,
  fillColor: WidgetStateColor.resolveWith((states) =>
      states.contains(WidgetState.focused) ? _kFocusFill : Colors.white),
  hintStyle: _kHintTextStyle,
  labelStyle: _kLabelTextStyle,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.7))),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.7))),
  disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.7))),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: _kPurple, width: 2)),
);

const _kPurple = Color(0xFF312E81);

/// Background of the focused field. #EEF2FF is too close to white to register
/// as "selected" on this dense form; indigo-100 reads clearly while keeping
/// black 12px text well above contrast minimums.
const _kFocusFill = Color(0xFFE0E7FF);

/// Applies [_kFontFamily] to a whole subtree instead of to every TextStyle.
///
/// Two layers, because Flutter resolves text in two different ways: the
/// [Theme] override reaches widgets that build their style from the theme
/// (TextField, dropdown menus, buttons) and also re-flows into any [Material]
/// below it, while [DefaultTextStyle] reaches plain [Text] widgets, whose
/// explicit styles here set only size / weight / colour and inherit the rest.
///
/// Needed a second time inside every suggestion panel: those are hand-rolled
/// [OverlayEntry]s, so they hang off the Overlay — not off the field that
/// opened them — and inherit nothing from the screen.
Widget _withFormFont(BuildContext context, Widget child) {
  final base = Theme.of(context);
  return Theme(
    data: base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: _kFontFamily),
      primaryTextTheme: base.primaryTextTheme.apply(fontFamily: _kFontFamily),
    ),
    child: DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: _kFontFamily),
      child: child,
    ),
  );
}

/// Which booking to open for editing.
///
/// Only the backend id is carried: the screen wears the dashboard booking
/// form's design, and that form binds every field to [DashboardController], so
/// the values come from the controller once
/// [DashboardController.dashBoardDataBinding] has loaded the booking — there is
/// nothing left for this model to pass in field by field.
///
/// Left null (or omitted entirely, which is what lets the screen be pushed with
/// no arguments) nothing is loaded and the form opens on whatever the controller
/// is already holding — an empty booking on a fresh session.
class EditJobDetails {
  final int? id;

  const EditJobDetails({this.id});
}

class EditJobsWidget extends StatefulWidget {
  final EditJobDetails booking;

  const EditJobsWidget({super.key, this.booking = const EditJobDetails()});

  @override
  State<EditJobsWidget> createState() => _EditJobsWidgetState();
}
class _EditJobsWidgetState extends State<EditJobsWidget> {
  // ────────── palette
  static const _purple = Color(0xFF312E81);
  static const _purpleDark = Color(0xFF312E81);
  static const _purpleSoft = Color(0xFFEEF2FF);
  static const _border = Colors.black;
  static const _surface = Color(0xFFF5F6FA);
  static const _red = Color(0xFFEF4444);
  // ────────── font sizes (compact)
  static const _fsLabel = 11.0;

  /// Width of the caption column [_labelled] draws to the left of every field,
  /// and the type it draws it in. Narrower and a point smaller than the
  /// PICKUP / DROPOFF tag because these sit inside grid cells, where the
  /// caption is taken straight out of the field's own width.
  static const _kCaptionWidth = 70.0;
  static const _kCaptionStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.15,
    color: Colors.black,
  );
  static const _fsField = 12.0;
  static const _fsSection = 12.0;

  /// The grey caption inside a header pill ("USER", "BOOKED"), and the value
  /// beside it.
  static const _kMetaCaption = TextStyle(
    fontSize: 9.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
    color: Color(0xFF6B7280),
  );
  static const _kMetaValue = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: Colors.black,
  );
  // ────────── state
  String? driver;
  ZoneObject? dashboardZoneValue, dropZone;
  // String? account = 'DEMO';
  // String? vehicleType = 'Saloon';
  // bool quotation = true;
  AllAddressesModel? _selectedPickup;
  AllAddressesModel? _selectedDrop;
  // Kept focused (instead of a plain unfocus()) when the PICKUP/DROP
  // autocomplete is dismissed by a tap outside it, so the arrow-key page
  // scrolling below keeps working — unfocus() moves primary focus to the
  // ambient FocusScope *outside* this form, and key events only bubble up from
  // whichever node currently has focus. NOT used when a suggestion is picked:
  // that path keeps focus on the field itself and preserves the Tab position.
  final FocusNode _shortcutFocusNode = FocusNode();

  /// Focus node of the PICKUP address field — the first stop of the form, and
  /// where the row's own clear button puts the caret back.
  final FocusNode _pickupFieldFocusNode = FocusNode();


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
    // The dropdowns read their items off dashboardAllData, so the form cannot
    // build until it is there.
    if (controller.dashboardAllData == null) {
      controller.dashboardData();
    }
    // Load the booking. After the first frame, not during initState:
    // dashBoardDataBinding ends in DashboardController.update(), and a
    // GetBuilder cannot be rebuilt while it is still being built.
    //
    // Unlike the dashboard form, this screen does NOT claim
    // controller.focusBookingFormFirstField — the dashboard form stays mounted
    // under this route and would be left without the F2 hook once this screen
    // pops.
    final id = widget.booking.id;
    if (id == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) controller.dashBoardDataBinding(id: id);
    });
  }
  @override
  void dispose() {
    _shortcutFocusNode.dispose();
    _pickupFieldFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final isTablet = w >= 640 && w < 1024;
    final cols = isMobile ? 1 : (isTablet ? 2 : 4);
    // The dashboard form takes half the window because the drivers panel and
    // the map sit beside it. Here it owns the page, but a form stretched across
    // a wide monitor reads badly, so cap it and centre what is left.
    final formWidth =
        isMobile ? double.infinity : (w * 0.88).clamp(600.0, 1320.0);
    // Scrolling is for the small screens only. A phone or an iPad cannot show
    // the whole form at once, so there it scrolls; on desktop web the form is
    // meant to sit inside the window, so the wheel, the drag and the scrollbar
    // are all off.
    //
    // Two signals, because neither alone covers an iPad: the width breakpoint
    // misses one in landscape (1194pt), and defaultTargetPlatform misses one in
    // a desktop-class browser session, where iPadOS reports macOS.
    final isTouch = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
    final canScroll = isTouch || isMobile || isTablet;
    // The F1-F12 / "/" shortcuts are NOT available here: they live in
    // DashboardShortcuts, which wraps the dashboard screen, and this route sits
    // above it. Only the arrow-key page scrolling below, which is this form's
    // own, still applies.
    return Scaffold(
      backgroundColor: Colors.white,
      body: _withFormFont(
      context,
      Focus(
        // No autofocus: the fields own the initial focus, and an invisible
        // full-screen node grabbing it first would strand the caret.
        focusNode: _shortcutFocusNode,
        // Focusable (so a dismissed autocomplete can park focus here instead
        // of dropping it) but NOT a Tab stop — otherwise Shift+Tab off the
        // first field lands on this invisible full-screen node and the focus
        // ring appears to vanish.
        skipTraversal: true,
        // Arrow up / down scrolls the hosting page. Handled with a raw key
        // handler rather than a shortcut binding so a key REPEAT scrolls
        // without re-animating.
        onKeyEvent: (node, event) => handlePageArrowScroll(context, event),
        child: GetBuilder<DashboardController>(
          initState: (_) {
            controller.seeZoneOnMapp();
            if (_controller.locationtypezoneModel == null) {
              _controller.getLocationTypeZone();
            }
          },
          builder: (controller) {
            return  SafeArea(
              // Top-aligned rather than Center so a short form stays put at
              // the top of the page instead of floating mid-screen.
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: formWidth,
                  child: _pageBody(
                    canScroll: canScroll,
                    isMobile: isMobile,
                    form: Container(
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
                          _headerBar(isMobile),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal:isMobile ? 12 : 16,vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _locationRow<ZoneObject>(
                                  'PICKUP',
                                  _purple,
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
                                    FocusScope.of(Get.context!).requestFocus(_pickupFieldFocusNode);
                                    controller.update();
                                  },
                                  notesController: controller.pickUpNoteController,
                                  addressFocusNode: _pickupFieldFocusNode,
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
                                          Icon(Icons.circle, size: 9, color: _purple),
                                          const SizedBox(width: 6),
                                          Text("FL",
                                              style:
                                              const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsLabel)),
                                        ])),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          flex: 3,
                                          // Caption blank: the dotted FL tag
                                          // to the left already names it.
                                          child: _field('',
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
                                  addressFocusNode: controller.dropOffTextFieldFocusNode,
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
                                    controller.dashboardAllData!.journeyTypes ?? const [],
                                        (v) {
                                      // 1. Validation check for pickup and dropoff locations
                                      if (controller.pickupController.text.isNotEmpty &&
                                          controller.dropOffController.text.isNotEmpty) {
                                        setState(() {
                                          // Dropdown menu close
                                          controller.dropDownShow.value = false;

                                          // Selected value assign
                                          controller.selectJourneyTypeValue = v;

                                          // Debug prints
                                          print("RAW journeyType from API => '${v?.journeyType}'");

                                          // String normalization (trim + lowercase)
                                          final type = (v?.journeyType ?? "").trim().toLowerCase();
                                          print("NORMALIZED type => '$type'");

                                          // Map journeyType value
                                          if (type == "o/w") {
                                            controller.jourValue = "O/W";
                                            controller.changeJourneyFtn();
                                          } else if (type == "r/n") {
                                            controller.jourValue = "R/N";
                                          } else if (type == "w/r") {
                                            controller.jourValue = "W/R";
                                            controller.changeJourneyFtn();
                                          } else {
                                            controller.jourValue = null;
                                            print("⚠️ NO MATCH FOUND for type: '$type' — jourValue set to null");
                                          }

                                          print("FINAL controller.jourValue => ${controller.jourValue}");
                                        });

                                        // 2. Fares calculation trigger
                                        controller.getFaresCalculation();
                                      } else {
                                        // 3. Validation fail warning
                                        BotToast.showText(text: "Please select pickup and drop location first");
                                      }
                                    },
                                    14,
                                    itemLabel: (p) => p.journeyType!,
                                    allowUnselect: false
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
                                  _field('FARE',
                                      tab: 17,
                                      prefix: Icons.currency_pound,
                                      controller: controller.slugController),
                                  _dropdown<DashboardAccountObject>(
                                    'SELECT ACCOUNT',
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
                                      allowUnselect: false
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
                                    allowUnselect: false,
                                  ),
                                  _dropdown<DepartmentObject>(
                                    'Select Department',
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
                                ///todo multi reservation
                                // _grid(cols, [
                                //   WebDateField('Date',
                                //       tab: _isReturnJourney?36.1:21.1,
                                //       // The calendar is an overlay off the
                                //       // root Overlay, so _withFormFont at the
                                //       // top of this screen never reaches it.
                                //       // baseTextStyle is merged under every
                                //       // string in the field AND the popup, so
                                //       // the family lands in one place instead
                                //       // of per slot.
                                //       baseTextStyle:
                                //       const TextStyle(fontFamily: _kFontFamily),
                                //       textStyle: _kValueTextStyle,
                                //       // fieldTextColor is what the package
                                //       // paints the value with while the field
                                //       // is at rest (black87 by default); the
                                //       // focused/open value stays the accent.
                                //       style: WebDatePickerStyle.of(context)
                                //           .copyWith(fieldTextColor: Colors.black),
                                //       // Unfocused / disabled border comes from
                                //       // the form's own decoration (grey 0.7) —
                                //       // the package default leaves it to the
                                //       // theme. Focused stays the purple accent.
                                //       decoration: _inputDecoration(),
                                //       value: controller.pickUpDate,
                                //       onChanged: (d) => setState(() {
                                //         controller.pickUpDate = d;
                                //         controller.pickUpDatePicked = true;
                                //       })),
                                //   _timeField('Time',
                                //       tab: _isReturnJourney?36.2:21.2,
                                //       controller:
                                //       controller.pickUpTimeController,
                                //       onPicked: () =>
                                //       controller.pickUpTimePicked = true),
                                //   WebDateField('Date',
                                //       tab: _isReturnJourney?36.3:21.3,
                                //       baseTextStyle:
                                //       const TextStyle(fontFamily: _kFontFamily),
                                //       textStyle: _kValueTextStyle,
                                //       style: WebDatePickerStyle.of(context)
                                //           .copyWith(fieldTextColor: Colors.black),
                                //       decoration: _inputDecoration(),
                                //       value: controller.pickUpDate,
                                //       onChanged: (d) => setState(() {
                                //         controller.pickUpDate = d;
                                //         controller.pickUpDatePicked = true;
                                //       })),
                                //   _timeField('Time',
                                //       tab: _isReturnJourney?36.4:21.4,
                                //       controller:
                                //       controller.pickUpTimeController,
                                //       onPicked: () =>
                                //       controller.pickUpTimePicked = true),
                                // ]),
                                ///todo multi reservation

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
                  // ---- The journey, drawn ----
                  // On the dashboard this widget is a sibling of the form, one
                  // panel over; a standalone edit page has to carry it or the
                  // route the PICK / DROP fields are plotting is invisible.
                  //
                  // The height matters more than it looks: MapViewWidget is a
                  // Stack with no size of its own, so an unbounded parent takes
                  // its inner layout out with a "size: MISSING" — the same
                  // reason the dashboard wraps it in a SizedBox. A height of
                  // its own only while the page scrolls, though: on desktop
                  // _pageBody hands it the space the form leaves, which is what
                  // keeps the whole map on screen.
                  map: Container(
                    height: canScroll ? _mapHeight(context) : null,
                    margin: EdgeInsets.fromLTRB(0, 12, 0, isMobile ? 0 : 12),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isMobile ? 0 : 10),
                      border: Border.all(color: _border.withOpacity(0.2)),
                    ),
                    // createBooking drops the MAPS / PLOT toggle and the
                    // distance readout it carries: both belong to the
                    // dashboard, and this screen has the status cards for the
                    // figures.
                    child: MapViewWidget(createBooking: true),
                  ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
    );
  }

  /// A map big enough to read a route on without pushing the form out of reach.
  /// Clamped rather than left as a straight fraction of the viewport: half of a
  /// laptop's height is a usable map, half of a phone's is not.
  /// Smallest slice of the window the map may be squeezed into on desktop.
  /// Below this it stops being a map and starts being a strip, so the form
  /// gives way first (it clips) rather than the map.
  static const _kMinMapHeight = 240.0;

  /// Lays the form card and the map out on the page.
  ///
  /// Touch (phone / iPad): one scrolling column, the map at [_mapHeight]. The
  /// page is taller than the screen and scrolling is how you reach the rest.
  ///
  /// Desktop web: nothing scrolls, so the map cannot keep a height of its own
  /// — it takes whatever the form card leaves and is therefore always whole,
  /// which is the point. The form is capped at (window - [_kMinMapHeight]) and
  /// clips past that instead of overflowing, so an unusually short window
  /// costs the bottom of the form rather than the map or a layout error.
  Widget _pageBody({
    required bool canScroll,
    required bool isMobile,
    required Widget form,
    required Widget map,
  }) {
    final padding = EdgeInsets.symmetric(
      horizontal: isMobile ? 0 : 12,
      vertical: isMobile ? 0 : 12,
    );
    if (canScroll) {
      return SingleChildScrollView(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [form, map],
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final formMax = (constraints.maxHeight -
                padding.vertical -
                _kMinMapHeight)
            .clamp(0.0, double.infinity);
        return Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: formMax),
                // A locked scroll view rather than the bare card: a
                // SingleChildScrollView takes the child's height up to the
                // cap, so normally this is a no-op, and in the one case where
                // the form is taller it clips quietly instead of throwing.
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: form,
                  ),
                ),
              ),
              Expanded(child: map),
            ],
          ),
        );
      },
    );
  }

  static double _mapHeight(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return (h * 0.55).clamp(280.0, 520.0).toDouble();
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
          _purple,
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
          addressFocusNode: controller.pickupTwoTextFieldFocusNode,
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
                  Icon(Icons.circle, size: 9, color: _purple),
                  const SizedBox(width: 6),
                  Text("FL",
                      style:
                      const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsLabel)),
                ])),
                const SizedBox(width: 2),
                Expanded(
                  flex: 3,
                  // Caption blank: the dotted FL tag to the left names it.
                  child: _field('',
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
          addressFocusNode: controller.dropOffTwoWayTextFieldFocusNode,
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
                controller.getFaresCalculation();

                // // Jab user khud badlega tab naye wale ki ID direct jayegi
                // final fare = await getActiveFareForVehicle(
                //   controller.dashboardAllData!.fareConfigurations!,
                //   v.id!,
                // );
                // print('tap 04');
                // if (fare != null) {
                //   print('Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}');
                //   controller.getFaresCalculation();
                //   print('tap 05');
                //   double inttt = (double.parse(controller.totalDistance.value) - double.parse(fare.minimumMiles.toString()));
                //   controller.fixedFare.value = (inttt * double.parse(fare.minimumFares.toString())).toString();
                //   print('tap 06');
                // } else {
                //   print('tap 07');
                //   print('No active fare found for this vehicle');
                // }
                print('tap 08');
                controller.update();
              }
              );},
            32,
            itemLabel: (p) => p.name!,
            allowUnselect: false,
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
                  controller.getFaresCalculation();

                  controller.dropDownShow.value = false;
                //
                //   // Jab user khud badlega tab naye wale ki ID direct jayegi
                //   final fare = await getActiveFareForVehicle(
                //     controller.dashboardAllData!.fareConfigurations!,
                //     v.id!,
                //   );
                //   print('tap 04');
                //   if (fare != null) {
                //     print('Vehicle: ${fare.vehicleTypeName} → Fare: ${fare.minimumFares}');
                //     controller.getFaresCalculation();
                //     print('tap 05');
                //     double inttt = (double.parse(controller.totalDistance.value) - double.parse(fare.minimumMiles.toString()));
                //     controller.fixedFare.value = (inttt * double.parse(fare.minimumFares.toString())).toString();
                //     print('tap 06');
                //   } else {
                //     print('tap 07');
                //     print('No active fare found for this vehicle');
                //   }
                //   print('tap 08');
                //   controller.update();
                }
                );
                },
              32,
              itemLabel: (p) => p.name!,
              allowUnselect: false,
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
          child: GlowFocus(
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
  // ────────── header bar
  //
  // Replaces the old BOOKING / + Multi Reservation / + Vehicles / Via tab
  // strip. This screen always opens on a job that already exists, so the bar
  // states WHICH job — reference, who took it, when, what it is doing now —
  // and carries the actions that only make sense once a booking is on file.
  //
  // No green anywhere: the pills the design draws in green (the reference, the
  // associated booking, LOST PROPERTY) take the form's own focus colour, so
  // the bar and the focused field border are the same indigo.
  Widget _headerBar(bool isMobile) {
    final job = controller.jobDetails;

    String orDash(String? v) =>
        (v == null || v.trim().isEmpty) ? '—' : v.trim();

    // createdAt is the parsed one; bookedAt is whatever the API sent, so it is
    // only worth a look when createdAt is absent.
    String bookedStamp() {
      final at = job?.createdAt ?? DateTime.tryParse(job?.bookedAt ?? '');
      return at == null ? '—' : DateFormat('dd-MM-yy HH:mm').format(at);
    }

    // associatedBooking is typed dynamic on the model and comes back as either
    // the reference itself or the whole booking, so the pill only appears once
    // a reference can actually be read out of it.
    String? associatedRef() {
      final a = job?.associatedBooking;
      if (a == null) return null;
      if (a is Map) {
        final r = a['reference_number'] ?? a['referenceNumber'];
        return (r == null || '$r'.trim().isEmpty) ? null : '$r'.trim();
      }
      final s = '$a'.trim();
      return s.isEmpty ? null : s;
    }

    Widget metaPill(String caption, String value,
        {Color background = const Color(0xFFF3F4F6),
          Color valueColor = Colors.black}) =>
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(caption.toUpperCase(), style: _kMetaCaption),
            const SizedBox(width: 6),
            Text(value.toUpperCase(),
                style: _kMetaValue.copyWith(color: valueColor)),
          ]),
        );

    // [order] < 1 so the bar is traversed before the first numbered field.
    Widget outlinePill(IconData? icon, String text, Color color,
        {required double order, VoidCallback? onTap}) =>
        FocusTraversalOrder(
          order: NumericFocusOrder(order),
          child: GlowFocus(
            radius: 20,
            accent: color,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(20),
                mouseCursor: SystemMouseCursors.click,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: color),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (icon != null) ...[
                      Icon(icon, size: 13, color: color),
                      const SizedBox(width: 5),
                    ],
                    Text(text.toUpperCase(),
                        style: _kMetaValue.copyWith(color: color)),
                  ]),
                ),
              ),
            ),
          ),
        );

    Widget iconBtn(IconData icon, String tooltip,
        {required double order, VoidCallback? onTap}) =>
        FocusTraversalOrder(
          order: NumericFocusOrder(order),
          child: GlowFocus(
            child: Tooltip(
              message: tooltip,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(6),
                  mouseCursor: SystemMouseCursors.click,
                  child: Container(
                    height: 27,
                    width: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(icon, size: 15, color: Colors.black87),
                  ),
                ),
              ),
            ),
          ),
        );

    final associated = associatedRef();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Two Wraps rather than one horizontally scrolling Row: the bar
              // is information, so on a narrow window it should fold onto a
              // second line instead of hiding half of itself off-screen.
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'UPDATE BOOKING',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        color: Colors.black,
                      ),
                    ),
                    outlinePill(null, orDash(job?.referenceNumber), _purple,
                        order: 0.1),
                    metaPill(
                        'User', orDash(job?.employee?.username ?? job?.bookedBy)),
                    metaPill('Booked', bookedStamp()),
                    metaPill('Status',
                        orDash(job?.bookingStatus?.bookingStatus),
                        background: _purpleSoft, valueColor: _purple),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (associated != null)
                    outlinePill(Icons.link, 'Associated: $associated', _purple,
                        order: 0.2,
                        onTap: () => _headerAction('Associated booking')),
                  iconBtn(Icons.play_arrow, 'Dispatch',
                      order: 0.3, onTap: () => _headerAction('Dispatch')),
                  iconBtn(Icons.chat_bubble_outline, 'Messages',
                      order: 0.4, onTap: () => _headerAction('Messages')),
                  iconBtn(Icons.send, 'Send details',
                      order: 0.5, onTap: () => _headerAction('Send details')),
                  outlinePill(
                      Icons.warning_amber_rounded, 'Complaint', _red,
                      order: 0.6, onTap: () => _headerAction('Complaint')),
                  outlinePill(
                      Icons.inventory_2_outlined, 'Lost property', _purple,
                      order: 0.7, onTap: () => _headerAction('Lost property')),
                ],
              ),
            ],
          ),
          const Divider(height: 10),
        ],
      ),
    );
  }

  /// The header's booking actions have no endpoint behind them yet — the bar
  /// was built to a design, not to an API. Each one says so rather than
  /// failing silently under the cursor.
  void _headerAction(String name) =>
      BotToast.showText(text: '$name is not wired up yet');


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
        FocusNode? addressFocusNode, // ← lets F2 focus the PICKUP field
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
        focusNode: addressFocusNode,
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
                child: GlowFocus(
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
                child: GlowFocus(
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
      hint: 'SELECT ZONE',
    );
    // Notes is now an editable text field instead of a button.
    final noteHint =
        '${label[0]}${label.substring(1).toLowerCase().trim()} Notes';
    final notes = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 3).toDouble()),
      child: GlowFocus(
        child: TextField(
          controller: notesController,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
          style: _kValueTextStyle,
          textInputAction: TextInputAction.next,
          decoration: _inputDecoration().copyWith(
            hintText: noteHint,
            hintStyle: _kHintTextStyle.copyWith(color: Colors.black45),
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
          child: GlowFocus(
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
          // 150 was the bare box; the caption beside it needs its own column.
          width: 210,
          child: _labelled(
            label,
            FocusTraversalOrder(
              order: NumericFocusOrder(tab.toDouble()),
              child: GlowFocus(
                child: TextField(
                  controller: controller,
                  style: _kValueTextStyle,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: _inputDecoration().copyWith(
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
          ),
        );

    Widget iconBtn(IconData icon, {VoidCallback? onPressed, required int tab}) =>
        FocusTraversalOrder(
          order: NumericFocusOrder(tab.toDouble()),
          child: GlowFocus(
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
      child: GlowFocus(
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
      child: GlowFocus(
        child: Focus(
          // Intercept Tab so focus jumps from the Home button directly to the
          // Driver panel's first focusable item, skipping any remaining items
          // inside this FocusTraversalGroup.
          //
          // Key-handling only: the inner ElevatedButton must own the single Tab
          // stop. A focusable wrapper took the stop for itself, so the button's
          // own focus node never became primary and Enter / Space had no
          // ButtonActivateIntent target — the press did nothing. Key events
          // still bubble up here from the focused button, so the Tab handoff
          // below keeps working.
          canRequestFocus: false,
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
              if (controller.jourValue == 'R/N' &&
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
  /// Caption BESIDE the field instead of floating inside it.
  ///
  /// The PICKUP / DROPOFF rows have always read this way - a fixed-width
  /// caption column, then the control - so every other field on the form now
  /// borrows the same shape and drops its floating label.
  ///
  /// An empty [label] returns the field bare: the caller has already drawn a
  /// caption of its own (the FL row, whose tag carries the coloured dot).
  Widget _labelled(String label, Widget field) {
    if (label.trim().isEmpty) return field;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: _kCaptionWidth,
          // Two lines rather than an ellipsis on the first: the long captions
          // ('NO. OF PASSENGERS', 'SELECT DEPARTMENT') are unreadable clipped,
          // and the field beside them stays vertically centred either way.
          child: Text(
            label.toUpperCase(),
            style: _kCaptionStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(child: field),
      ],
    );
  }

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
    return _labelled(
      label,
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: _CustomerModelAutocomplete(
          controller: controller,
          items: customers,
          onSelected: onPicked,
          onChanged: onChanged,
          decoration: _inputDecoration().copyWith(
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
    );
  }

  /// [onPicked] fires only when the user confirms a time in the dropdown, so
  /// the controller can tell a chosen time apart from the pre-filled "now".
  Widget _timeField(String label,
      {required num tab,
        required TextEditingController controller,
        VoidCallback? onPicked}) {
    return _labelled(
      label,
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: GlowFocus(
          child: TimePickerField(
            controller: controller,
            onChanged: onPicked == null ? null : (_) => onPicked(),
            textStyle: _kValueTextStyle,
            decoration: _inputDecoration(),
          ),
        ),
      ),
    );
  }

  /// Date field. Built on [CalendarDropdownField] rather than the package's
  /// [WebDateField] wrapper for one reason: the wrapper always draws a
  /// floating label, and the caption lives beside the field now.
  Widget _dateField(String label,
      {required num tab,
        required DateTime? value,
        required ValueChanged<DateTime> onChanged}) {
    return _labelled(
      label,
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: GlowFocus(
          child: CalendarDropdownField(
            label: null,
            value: value,
            onChanged: onChanged,
            // The calendar is an overlay off the root Overlay, so _withFormFont
            // at the top of this screen never reaches it. baseTextStyle is
            // merged under every string in the field AND the popup, so the
            // family lands in one place instead of per slot.
            baseTextStyle: const TextStyle(fontFamily: _kFontFamily),
            textStyle: _kValueTextStyle,
            // fieldTextColor is what the package paints the value with while
            // the field is at rest (black87 by default); the focused / open
            // value stays the accent.
            style: WebDatePickerStyle.of(context)
                .copyWith(fieldTextColor: Colors.black),
            // Unfocused / disabled border comes from the form's own decoration
            // (grey 0.7) - the package default leaves it to the theme.
            decoration: _inputDecoration(),
          ),
        ),
      ),
    );
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
    return _labelled(
      label,
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: GlowFocus(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: inputFormatters ??
                [
                  UpperCaseTextFormatter(),
                ],
            style: _kValueTextStyle,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onPrefixTap?.call(),
            decoration: _inputDecoration().copyWith(
              prefixIconConstraints:
              const BoxConstraints(minWidth: 28, minHeight: 0),
              prefixIcon: prefixWidget,
            ),
          ),
        ),
      ),
    );
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
        bool allowUnselect = true,
      }) {
    return _labelled(
      label ?? '',
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: GlowFocus(
          child: _DropdownField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: isExpanded,
            // labelText names the "clear" entry in the open menu; hintText is
            // what stands in the closed box while nothing is picked. A field
            // whose caption is beside it gets no hint - the caption already
            // says what it is - so only the call sites that ask for one
            // (SELECT ZONE, SELECT DRIVER) print anything inside the box.
            labelText: (label ?? hint ?? '').toUpperCase(),
            hintText: (hint ?? '').toUpperCase(),
            itemLabel: itemLabel,
            allowUnselect: allowUnselect,
          ),
        ),
      ),
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
              child: GlowFocus(
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
  InputDecoration _inputDecoration() => _kFieldDecoration();
}
// ════════════════════════════════════════════════════════════════════
// Focus-aware dropdown with unselect support (matches f3_alert.dart pattern)
// ════════════════════════════════════════════════════════════════════
class _DropdownField<T> extends StatefulWidget {
  const _DropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.labelText,
    this.hintText = '',
    this.itemLabel,
    this.isExpanded = true,
    this.allowUnselect = true,
  });

  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  /// Names the unselect entry in the open menu.
  final String labelText;

  /// Stands in the closed box while nothing is picked. Empty for the fields
  /// that carry their caption beside them.
  final String hintText;
  final String Function(T item)? itemLabel;
  final bool isExpanded;
  final bool allowUnselect;

  @override
  State<_DropdownField<T>> createState() => _DropdownFieldState<T>();
}

class _DropdownFieldState<T> extends State<_DropdownField<T>> {
  static const _fsField = 12.0;

  final FocusNode _dropdownFocusNode = FocusNode();

  @override
  void dispose() {
    _dropdownFocusNode.dispose();
    super.dispose();
  }

  String _labelOf(T item) =>
      widget.itemLabel?.call(item) ?? item.toString();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dropdownFocusNode,
      builder: (context, child) {
        final isFocused = _dropdownFocusNode.hasFocus;
        // The border, the focus tint and the label all come from the same
        // decoration the TextFields use, so a dropdown is indistinguishable
        // from the field beside it until it is opened.
        return InputDecorator(
          isFocused: isFocused,
          // Drives the hint: shown inside the box while nothing is picked,
          // gone the moment there is a value — exactly like a TextField's.
          isEmpty: widget.value == null,
          decoration: _kFieldDecoration().copyWith(
            hintText: widget.hintText,
            // A dense DropdownButton is 24px tall against a 12px field's ~16,
            // so the vertical padding drops by the difference to keep the two
            // controls the same overall height.
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T?>(
              focusNode: _dropdownFocusNode,
              focusColor: Colors.transparent,
              isDense: true,
              value: widget.value,
              // Empty: the decoration's hintText owns the empty state, and
              // a hint here would print a second string over it.
              hint: const SizedBox.shrink(),
              isExpanded: widget.isExpanded,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              // Ambient style for the open menu. The closed field is styled
              // separately below.
              style: const TextStyle(
                fontSize: _fsField,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              // The closed field and the open menu are otherwise rendered from
              // the same DropdownMenuItem children, so bolding the picked value
              // through `style` would bold the whole list with it. This builder
              // is the only seam between the two: same order and length as
              // `items` (DropdownButton asserts it), value style on the real
              // entries, and nothing at all for the placeholder — that slot is
              // the empty state, which the hint draws.
              // The Aligns are not decoration: DropdownButton wraps these in
              // a fixed-height SizedBox, and the DropdownMenuItems they stand
              // in for carry a centerStart Align of their own — without it the
              // closed value rides the top of the row instead of its middle.
              selectedItemBuilder: (context) => [
                if (widget.allowUnselect) const SizedBox.shrink(),
                ...widget.items.map((e) => Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    _labelOf(e).toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _kValueTextStyle,
                  ),
                )),
              ],
              items: [
                // Placeholder item: allows the user to unselect / reset. It
                // keeps the label text so the menu says what clearing gives
                // you back.
                if (widget.allowUnselect)
                  DropdownMenuItem<T?>(
                    value: null,
                    child: Text(
                      widget.labelText,
                      style: TextStyle(
                        fontSize: _fsField,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                // Actual items
                ...widget.items.map((e) => DropdownMenuItem<T?>(
                  value: e,
                  child: Text(
                    _labelOf(e).toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: _fsField),
                  ),
                )),
              ],
              onChanged: (T? newValue) {
                widget.onChanged(newValue);
              },
            ),
          ),
        );
      },
    );
  }
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
    this.focusNode,
    this.fallbackFocusNode,
  });
  final TextEditingController controller;
  final List<AllAddressesModel> items;
  final InputDecoration decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<AllAddressesModel>? onSelected;
  final ValueChanged<int>? onPickIndex;
  /// Supplied by the parent when it needs to focus this field from the outside
  /// (F2 → PICKUP). Null means the field owns — and disposes — its own node.
  final FocusNode? focusNode;
  // Focus is redirected here instead of being dropped, so the CallbackShortcuts
  // (F7/F8/F9) ancestor stays in the focused chain after a pick / tap-outside.
  final FocusNode? fallbackFocusNode;

  @override
  State<_AddressModelAutocomplete> createState() =>
      _AddressModelAutocompleteState();
}
class _AddressModelAutocompleteState extends State<_AddressModelAutocomplete> {
  final _layerLink = LayerLink();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
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

  /// Keeps one post-frame re-filter in flight at a time, since didUpdateWidget
  /// runs on every GetBuilder rebuild of the form, not just on new results.
  bool _refilterScheduled = false;
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
    // `items` is the controller's RxList, and getAddresses() refills it IN
    // PLACE (clear + addAll) — the reference never changes, so the old
    // `oldWidget.items != widget.items` guard was never true and backend
    // results that landed after the user stopped typing were never filtered
    // in. That is the whole failure for a search the debounce only fires once
    // for: the panel stayed on whatever the previous query had produced.
    // Re-filter on every parent rebuild while the panel is live instead; the
    // list is a page of search hits and the pass is O(n).
    if (!_userTyped || _refilterScheduled) return;
    _refilterScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refilterScheduled = false;
      if (!mounted || !_focusNode.hasFocus) return;
      // Late backend results arriving while the user navigates with the
      // arrow keys must NOT snap the highlight back to the top.
      _filter(widget.controller.text, preserveHighlight: true);
    });
  }
  @override
  void dispose() {
    _hide();
    _focusNode.removeListener(_onFocus);
    widget.controller.removeListener(_onText);
    // Only dispose a node we created — the parent owns the one it passed in.
    if (widget.focusNode == null) _focusNode.dispose();
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
      // Token-wise, NOT a single substring: the backend answers "A H" with
      // rows like "ASDA, HIGH STREET", and `contains('a h')` dropped all of
      // them, so the panel said "No data" over a perfectly good response.
      _filtered = widget.items
          .where((a) => addressMatchesQuery(
        name: a.name,
        postcode: a.postcode,
        query: query,
      ))
          .toList();
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
    // Only claim the arrows while the suggestion panel is actually open. With
    // it closed the event has to bubble up to the form root, which scrolls the
    // page — returning `handled` unconditionally swallowed it here and left
    // the PICKUP / DROP fields as the only ones that could not scroll.
    if (key == LogicalKeyboardKey.arrowDown) {
      if (_entry == null) return KeyEventResult.ignored;
      _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (_entry == null) return KeyEventResult.ignored;
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
  Widget _buildPanel(BuildContext context) =>
      _withFormFont(context, _buildPanelContent(context));

  Widget _buildPanelContent(BuildContext context) {
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
      child: GlowFocus(
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
            style: _kValueTextStyle,
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
  Widget _buildPanel(BuildContext context) =>
      _withFormFont(context, _buildPanelContent(context));

  Widget _buildPanelContent(BuildContext context) {
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
      child: GlowFocus(
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
            style: _kValueTextStyle,
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
    // Only claim the arrows while the suggestion panel is actually open, so a
    // closed Mobile field lets them bubble to the form root and scroll the
    // page like every other field.
    if (key == LogicalKeyboardKey.arrowDown) {
      if (_entry == null) return KeyEventResult.ignored;
      _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (_entry == null) return KeyEventResult.ignored;
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
  Widget _buildPanel(BuildContext context) =>
      _withFormFont(context, _buildPanelContent(context));

  Widget _buildPanelContent(BuildContext context) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    // The panel is exactly as wide as the field it hangs off, like every other
    // suggestion panel on this form.
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
                        // 8/6 instead of 12/8: the panel is only as wide as
                        // the Mobile cell, so every pixel of chrome came
                        // straight out of the text.
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        color: active
                            ? const Color(0xFFEEF2FF)
                            : Colors.white,
                        alignment: Alignment.centerLeft,
                        child: Row(children: [
                          Icon(Icons.person_outline,
                              size: 14,
                              color: active
                                  ? const Color(0xFF4F46E5)
                                  : Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // FittedBox, not ellipsis: the number and the
                                // name are what the user picks by, so a row
                                // too narrow for them shrinks the text to fit
                                // instead of cutting it off. maxLines/softWrap
                                // keep each on one line; nothing can overflow
                                // once it is scaled, so no ellipsis is needed.
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    c.mobile ?? '',
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: active
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    c.name ?? '',
                                    maxLines: 1,
                                    softWrap: false,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
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
      child: GlowFocus(
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
            style: _kValueTextStyle,
            keyboardType: TextInputType.phone,
            decoration: widget.decoration,
          ),
        ),
      ),
    );
  }
}
// ════════════════════════════════════════════════════════════════════
// The focus ring and the dropdown date field now live in the
// flutter_web_date_picker package (GlowFocus / WebDateField).
// ════════════════════════════════════════════════════════════════════
