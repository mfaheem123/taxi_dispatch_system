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
import '../dashboard_view/booking_form_scope.dart';
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
  /// Tag this screen's private DashboardController is registered under.
  /// Unique per screen instance, so two edit tabs on the same booking still
  /// get a form each.
  late final String _formTag;

  /// This screen's OWN booking form.
  ///
  /// A SECOND DashboardController, not the dashboard's permanent one. That is
  /// the whole point of it: both screens are the same form bound to the same
  /// controller, so an edit used to be typed straight into the operator's
  /// half-written new booking — every TextEditingController, the polyline, the
  /// markers and the via points were literally the same objects. A separate
  /// instance gives this screen its own of each, and the dashboard's NEW
  /// BOOKING form is never touched.
  ///
  /// Cheap to create: onInit() is empty, and every socket, timer and driver
  /// poll lives in inItStateOFController(), which only the app shell calls on
  /// the permanent instance. What this instance would otherwise have to fetch
  /// for itself — the dropdown lists and the zone overlay — is borrowed from
  /// the dashboard's copy in [_bootstrap] instead.
  late final DashboardController controller;

  /// Shared on purpose: [LocationController] is consulted for the zone LIST,
  /// which is reference data. The zone SELECTIONS moved onto
  /// [DashboardController.dashboardRNZoneValue] and its drop twin so they
  /// isolate with the rest of the form.
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
    // The screen's own form, registered under a tag of its own so the widgets
    // below — and the map, and the dialogs — can find THIS instance rather
    // than the dashboard's. Created here and deleted in dispose(), so a closed
    // edit screen leaves nothing behind.
    _formTag = DashboardController.newEditFormTag(widget.booking.id);
    controller = Get.put(
      DashboardController(formTag: _formTag),
      tag: _formTag,
    );
    // Writes wait for the first frame. Loading a booking assigns to
    // TextEditingControllers and Rx values that widgets are listening to, and
    // this screen is mounted during a tab switch — the outgoing tab is still
    // being taken down, so the tree is locked and a listener calling setState
    // throws "setState() or markNeedsBuild() called when widget tree was
    // locked". dashBoardDataBinding has always been deferred for the same
    // family of reason: it ends in update(), which cannot run mid-build.
    //
    // Nothing is captured or cleared any longer: a fresh instance starts empty
    // and the dashboard's form is a different object, so there is nothing left
    // to protect it from.
    //
    // Unlike the dashboard form, this screen does NOT claim
    // controller.focusBookingFormFirstField — that hook belongs to whichever
    // form is on the dashboard tab.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bootstrap();
    });
  }

  /// Fills the new instance in, then loads the booking into it.
  ///
  /// The dropdowns read their items off dashboardAllData and the selections
  /// dashBoardDataBinding restores are looked up in dashboardAccountData, so
  /// both have to be present BEFORE the booking is bound — hence the await
  /// rather than a fire-and-forget fetch. Normally there is nothing to wait
  /// for: the dashboard has already loaded all three and this instance simply
  /// borrows them. The fetch is the cold path — a browser reload straight onto
  /// /EditJobs, with no dashboard behind it.
  Future<void> _bootstrap() async {
    final dashboard = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : null;

    if (dashboard != null) {
      // The cold path — a browser reload straight onto this screen, with no
      // dashboard behind it — fetches through the DASHBOARD's instance, not
      // this one. dashboardData() does more than fill the dropdowns: it starts
      // the five-second booking-count poll and pulls the booking table. Both
      // belong to the dashboard, and running them on a throwaway instance
      // would be a second poll and a table nothing on this screen displays.
      if (dashboard.dashboardAllData == null) {
        await dashboard.dashboardData();
      }
      controller.seedReferenceDataFrom(dashboard);
      // Paint the form NOW. The builder below gates on dashboardAllData, so a
      // fresh instance shows a spinner until this lands — and waiting for the
      // booking fetch instead would leave that spinner up for a round trip,
      // or for good if the fetch comes back non-200.
      if (mounted) controller.update();
    } else if (controller.dashboardAllData == null) {
      // No dashboard registered at all. Shouldn't happen — main.dart puts one
      // in permanently — but the form cannot build without this data.
      await controller.dashboardData();
    }
    if (!mounted) return;

    final id = widget.booking.id;
    if (id != null) {
      // Restores the selections off the booking, and fetches the accounts for
      // its subsidiary itself.
      await controller.dashBoardDataBinding(id: id);
      return;
    }

    // No booking to load. dashboardData() kicks the accounts off without
    // awaiting it, so a cold start can leave the seed with nothing in the
    // ACCOUNT dropdown; fetch it here rather than leave the field dead.
    if (controller.dashboardAccountData == null &&
        controller.selectSubsidiariesValue != null) {
      await controller.getAccountData(
          subsidiariesId: controller.selectSubsidiariesValue!.id);
    }
    if (mounted) controller.update();
  }

  @override
  void dispose() {
    // Deleting the tagged instance runs its onClose, which disposes the text
    // controllers this screen created. Safe here: Flutter takes children down
    // before the parent State, so nothing is still listening to them.
    //
    // The dashboard's permanent instance is a different object and is not
    // touched — which is the entire reason the snapshot/restore this used to
    // do could be dropped.
    Get.delete<DashboardController>(tag: _formTag);
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
    // Material, not Scaffold. booking_table opens this screen as a chip in the
    // menu bar's page strip, and that strip renders inside a
    // SingleChildScrollView (main_appbar.dart) — so the page is laid out with
    // an unbounded height. A Scaffold expands to fill its box and its canvas
    // Material is a RenderPhysicalModel, which is what "was given an infinite
    // size during layout" was reporting. Material takes its child's height
    // instead, and still supplies the Material ancestor the fields need on the
    // /EditJobs route, where there is no Scaffold above it.
    return BookingFormScope(
      // Everything below — the map above all — resolves the form from here
      // instead of with a bare Get.find, so it follows THIS booking rather
      // than the dashboard's.
      controller: controller,
      child: Material(
      color: Colors.white,
      child: _withFormFont(
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
          // This screen's instance, not the dashboard's.
          tag: _formTag,
          initState: (_) {
            // Only when the seed did not already bring the overlay across.
            if (controller.seeZoneOnMapModel == null) {
              controller.seeZoneOnMapp();
            }
            if (_controller.locationtypezoneModel == null) {
              _controller.getLocationTypeZone();
            }
          },
          builder: (controller) {
            // Every dropdown below reads its items off dashboardAllData with a
            // null assertion. initState starts the fetch, but the first frame
            // lands before it returns — and this route can be entered with no
            // dashboard behind it (a restart straight into the booking), so
            // there is no earlier screen that already loaded it. The dashboard
            // gates the identical form the same way in
            // defult_dashboard_view.dart, which is why that copy can assert.
            if (controller.dashboardAllData == null) {
              return const Center(child: CircularProgressIndicator());
            }
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
                                  0,
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
                                // Visibility(
                                //   visible: controller.isAirportResponse.value,
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(top: 4),
                                //     child: isMobile
                                //         ? Column(
                                //       crossAxisAlignment:
                                //       CrossAxisAlignment.stretch,
                                //       children: [
                                //         _field('FL',
                                //             tab: 3.3,
                                //             controller: controller
                                //                 .selectAirportController),
                                //         const SizedBox(height: 4),
                                //         _timeField('ARP',
                                //             tab: 3.6,
                                //             controller: controller
                                //                 .arrivalTimeController,
                                //             onPicked: () => controller
                                //                 .arrivalTimePicked = true),
                                //       ],
                                //     )
                                //         :
                                //     Row(
                                //       crossAxisAlignment: CrossAxisAlignment.center,
                                //       children: [
                                //         SizedBox(width: 80, child:  Row(mainAxisSize: MainAxisSize.min, children: [
                                //           Icon(Icons.circle, size: 9, color: _purple),
                                //           const SizedBox(width: 6),
                                //           Text("FL",
                                //               style:
                                //               const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsLabel)),
                                //         ])),
                                //         const SizedBox(width: 2),
                                //         Expanded(
                                //           flex: 3,
                                //           // Caption blank: the dotted FL tag
                                //           // to the left already names it.
                                //           child: _field('',
                                //               tab: 3.3,
                                //               controller: controller
                                //                   .selectAirportController),
                                //         ),
                                //         const SizedBox(width: 12),
                                //         Expanded(
                                //           flex: 1,
                                //           child: _timeField('ARP',
                                //               tab: 3.6,
                                //               controller: controller
                                //                   .arrivalTimeController,
                                //               onPicked: () => controller
                                //                   .arrivalTimePicked = true),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
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
                                  3,
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
                                      tab: 7,
                                      controller: controller.nameController),
                                  _field('Email',
                                      tab: 8,
                                      controller: controller.emailController),
                                  _customerAutocompleteField(
                                    'Mobile',
                                    tab: 9,
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
                                      tab: 10,
                                      controller: controller.telController),
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(10.5),
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
                                // Row 4 — DATE / TIME beside their return twins. R/DATE and R/TIME
                                // used to sit in the RETURN JOURNEY block further down; the form
                                // pairs each return field with the outbound one it mirrors.
                                _grid(cols, [
                                  _dateField('Date',
                                      tab: 11,
                                      value: controller.pickUpDate,
                                      onChanged: (d) => setState(() {
                                            controller.pickUpDate = d;
                                            controller.pickUpDatePicked = true;
                                          })),
                                  _timeField('Time',
                                      tab: 12,
                                      controller:
                                      controller.pickUpTimeController,
                                      onPicked: () =>
                                          controller.pickUpTimePicked = true),
                                  if (_isReturnJourney) _rDateField(),
                                  if (_isReturnJourney) _rTimeField(),
                                ]),
                                // Rows 5-6 — the two return address rows, the only part of the
                                // return journey with no outbound field to sit beside.
                                if (_isReturnJourney)
                                  _returnJourneySection(isMobile, controller),
                                const Divider(height: 10),
                                _sectionHeader(
                                    Icons.directions_car, 'VEHICLE & PAYMENT'),
                                const SizedBox(height: 4),
                                // Row 7 — LEAD / JOUR / VEH / R/VEH.
                                _grid(isMobile ? 1 : (isTablet ? 2 : 4), [
                                  _field('Lead Time',
                                      tab: 21,
                                      controller: controller.minController),
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
                                    22,
                                    itemLabel: (p) => p.journeyType!,
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
                                    23,
                                    itemLabel: (p) => p.name!,
                                    allowUnselect: false,
                                  ),
                                  if (_isReturnJourney) _rVehicleDropdown(),
                                ]),
                                // Row 8 — ACC / QUOTATION / PASS / LUGG / SLGG.
                                _grid(isMobile ? 1 : (isTablet ? 3 : 5), [
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
                                    25,
                                    itemLabel: (p) => p.name!,
                                  ),
                                  _quotationToggle(),
                                  _field('No. of Passengers',
                                      tab: 27,
                                      prefix: Icons.person_outline,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      controller: controller.passController),
                                  ..._luggageFields(),
                                ]),
                                // Row 9 — PAY / ADD RETURN FARE / DEPARTMENT, then the SMS and
                                // EMAIL pair and the four dialog buttons.
                                _grid(isMobile ? 1 : (isTablet ? 2 : 4), [
                                  _dropdown<PaymentTypeObject>(
                                    'Pay By',
                                    controller.selectPaymentTypeValue,
                                    controller.dashboardAllData!.paymentTypes ??
                                        const [],
                                        (v) => setState(() =>
                                    controller.selectPaymentTypeValue = v),
                                    30,
                                    itemLabel: (p) => p.name!,
                                      allowUnselect: false
                                  ),
                                  if (_isReturnJourney) _addReturnFareCheckbox(),
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

                                    32,
                                    itemLabel: (p) => p.name ?? "",
                                  ),
                                  _commsAndActionsRow(isMobile),
                                ]),
                                // Row 10 — R/LEAD, on its own.
                                if (_isReturnJourney)
                                  _grid(isMobile ? 1 : (isTablet ? 2 : 4), [_rLeadField()]),
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
                                _statusCards(isMobile),
                                const SizedBox(height: 4),
                                // The fares bar's editable pair: FARE and, on a return, R/FARE.
                                _grid(isMobile ? 1 : (isTablet ? 2 : 4), [
                                  _field('FARE',
                                      tab: 40,
                                      prefix: Icons.currency_pound,
                                      controller: controller.slugController),
                                  if (_isReturnJourney) _rFareField(),
                                ]),
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
  ///
  /// Opened as a menu-bar tab: the strip hands the page an unbounded height and
  /// scrolls it itself, so neither of the above applies and both parts are laid
  /// out at their natural size.
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Unbounded host first, because it rules out both branches below. The
        // menu-bar tab strip renders the page inside a SingleChildScrollView
        // (main_appbar.dart), so there is no height to hand out: Expanded and
        // a maxHeight computed from infinity would throw, and a scroll view of
        // our own would be a viewport with unbounded height. The page lays out
        // at its natural size and the strip scrolls it.
        if (!constraints.hasBoundedHeight) {
          return Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                form,
                // The map already carries a height whenever canScroll is set;
                // on desktop it normally takes what the form leaves over, and
                // there is nothing left over here.
                canScroll
                    ? map
                    : SizedBox(height: _mapHeight(context), child: map),
              ],
            ),
          );
        }
        if (canScroll) {
          return SingleChildScrollView(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [form, map],
            ),
          );
        }
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

  Widget _returnJourneySection(bool isMobile, DashboardController controller) {
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
          // Was LocationController.RNzoneValue — a singleton the dashboard
          // form writes to as well, so the two screens shared one return zone.
          // dashboardRNZoneValue lives on this screen's own instance and
          // isolates with the rest of the form.
          controller.dashboardRNZoneValue,
          // Same guard the outbound rows use: locationtypezoneModel is null
          // until getLocationTypeZone() lands, and a return journey rendered
          // before then used to bring the screen down on the null assertion.
          _controller.updateLocationValue.value == true ||
                  _controller.locationtypezoneModel == null
              ? []
              : _controller.locationtypezoneModel!.zonesList!,
              (v) => setState(() => controller.dashboardRNZoneValue = v),
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
          14,
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
                    tab: 17.3,
                    controller: controller
                        .selectAirportControllerReturn),
                const SizedBox(height: 4),
                _timeField('ARP',
                    tab: 17.6,
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
                      tab: 17.3,
                      controller: controller
                          .selectAirportControllerReturn),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _timeField('ARP',
                      tab: 17.6,
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
          controller.dashboardRN1ZoneValue,
          _controller.updateLocationValue.value == true ||
                  _controller.locationtypezoneModel == null
              ? []
              : _controller.locationtypezoneModel!.zonesList!,
              (v) => setState(() => controller.dashboardRN1ZoneValue = v),
          isMobile,
              (value) {
            controller.onChangeHandler(
                fieldName: "DROP TWO WAY LOCATION", searchingText: value);
          },
              (addr) {
            setState(() => _selectedDrop = addr);
          },
          17,
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
      ],
    );
  }

  // ────────── return-journey fields, built one by one
  //
  // These used to sit together in a RETURN JOURNEY block below the outbound
  // fields. The form now pairs each with the field it mirrors — R/DATE beside
  // DATE, R/VEH beside VEH, R/FARE beside FARE — so each is built here and
  // placed by the main column. _returnJourneySection keeps only the two
  // address rows, which have no outbound twin to sit beside.
  Widget _rDateField() => _dateField('R/Date',
      tab: 13,
      value: controller.pickUpDateReturn,
      onChanged: (d) => setState(() {
            controller.pickUpDateReturn = d;
            controller.pickUpDateReturnPicked = true;
          }));

  Widget _rTimeField() => _timeField('R/Time',
      tab: 14,
      controller: controller.pickUpTimeControllerReturn,
      onPicked: () => controller.pickUpTimeReturnPicked = true);

  Widget _rLeadField() =>
      _field('R/Lead', tab: 39, controller: controller.minControllerReturn);

  Widget _rFareField() => _field('R/Fare',
      tab: 41,
      prefix: Icons.currency_pound,
      controller: controller.slugControllerReturn);

  // One builder where the mobile and desktop branches previously carried two
  // copies of this dropdown. The bodies differed only in the order of two
  // statements that both ran either way; this is the desktop copy.
  Widget _rVehicleDropdown() => _dropdown<DashboardVehicleTypeObject>(
        'Select R/VEH',
        controller.selectVehicleValueReturn,
        controller.dashboardAllData!.vehicleTypes!,
        (v) {
          if (v == null) return;
          // The old copies passed `() async {}` to setState. Nothing in the
          // body is awaited, and Flutter asserts when a setState callback
          // returns a Future, so the marker is dropped here.
          setState(() {
            controller.selectVehicleValueReturn = v;
            controller.getFaresCalculation();
            controller.dropDownShow.value = false;
          });
        },
        24,
        itemLabel: (p) => p.name!,
        allowUnselect: false,
      );

  Widget _rDriverDropdown() => _dropdown<DashboardDriverObject>(
        'Select R/DRV',
        controller.selectDriverValueReturn,
        controller.dashboardAllData!.drivers ?? const [],
        (v) => setState(() => controller.selectDriverValueReturn = v),
        43,
        itemLabel: (p) => p.name ?? '',
      );

  Widget _addReturnFareCheckbox() =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        // Sits in the PAY row, right after Pay By (30). Orderless before the
        // form was numbered, so Tab reached it only after everything else.
        FocusTraversalOrder(
          order: const NumericFocusOrder(31),
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
  // ────────── comms, luggage and the row action buttons
  // These three used to be closures inside _commsAndLuggageRow. The luggage
  // fields now sit in the ACCOUNT row and the checkboxes and action buttons in
  // the PAY row, so the builders have to be reachable from both.
  Widget _commsCheckbox(String label, bool value, ValueChanged<bool?> onChanged,
          {required num tab}) =>
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
  // No fixed width any more: these were sized by hand (210) to sit in a Wrap
  // beside the checkboxes. They are grid cells in the ACCOUNT row now, so they
  // take the column width the row gives them, like every other field.
  Widget _luggageField(String label, IconData icon,
          TextEditingController controller, int tab) =>
        _labelled(
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
        );

  Widget _actionIconBtn(IconData icon,
          {VoidCallback? onPressed, required int tab}) =>
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
  /// LUGG and SLGG — the two cells the ACCOUNT row ends with.
  List<Widget> _luggageFields() => [
        // _luggageField('Passenger'.toUpperCase(), Icons.work,
        //     controller.passController, 27),
        _luggageField(
            'luggage'.toUpperCase(), Icons.luggage, controller.luggController, 28),
        _luggageField('small luggage'.toUpperCase(), Icons.luggage,
            controller.sluggController, 29),
      ];

  /// SMS / EMAIL and the four dialog buttons — the tail of the PAY row.
  Widget _commsAndActionsRow(bool isMobile) {
    final left = Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _commsCheckbox('SMS', controller.smsCheckbox.value,
            (v) => setState(() => controller.smsCheckbox.value = v ?? false),
            tab: 33),
        _commsCheckbox('EMAIL', controller.emailCheckbox.value,
            (v) => setState(() => controller.emailCheckbox.value = v ?? false),
            tab: 34),
      ],
    );
    final right = Row(mainAxisSize: MainAxisSize.min, children: [
      _actionIconBtn(Icons.person, tab: 35, onPressed: () {
        showDialog(
            context: context,
            builder: (_) => RestrictDriversAlert(formController: controller));
      }),
      _actionIconBtn(Icons.attach_money, tab: 36, onPressed: () {
        showDialog(
          context: context,
          builder: (_) => ChildSeatsAlert(formController: controller),
        );
      }),
      _actionIconBtn(Icons.note_add, tab: 37, onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ExtraFaresAlert(formController: controller),
        );
      }),
      _actionIconBtn(Icons.calculate, tab: 38, onPressed: () {
        showDialog(
          context: context,
          builder: (_) => ExtraInfoAlert(formController: controller),
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
      42,
      itemLabel: (p) => p.name ?? '',
      hint: 'Select Driver',
    );
    final clear = FocusTraversalOrder(
      order: const NumericFocusOrder(44),
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
      order: const NumericFocusOrder(45),
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
    // R/DRV sits beside DRV here rather than at the end of a return block of
    // its own, the same pairing the rest of the form now uses.
    if (isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Driver',
            style: TextStyle(fontSize: _fsLabel, color: Colors.black)),
        const SizedBox(height: 4),
        dd,
        if (_isReturnJourney) ...[
          const SizedBox(height: 8),
          _rDriverDropdown(),
        ],
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
      if (_isReturnJourney) ...[
        const SizedBox(width: 12),
        Expanded(child: _rDriverDropdown()),
      ],
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
          order: const NumericFocusOrder(26),
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

  /// Placeholder drawn in the closed box while nothing is picked. Same
  /// centreStart Align the value entries use, so it sits on the field's
  /// middle line rather than on its baseline. Fields that carry their caption
  /// beside them pass no hint and get nothing.
  Widget get _hintChild => widget.hintText.isEmpty
      ? const SizedBox.shrink()
      : Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            widget.hintText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _kHintTextStyle.copyWith(color: Colors.grey.shade600),
          ),
        );

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
          isEmpty: widget.value == null,
          decoration: _kFieldDecoration().copyWith(
            // No hintText here: InputDecorator baseline-aligns its hint to the
            // input's baseline, and the closed dropdown's empty slot is a
            // zero-height box — so the placeholder sat on the bottom edge of
            // the field. The hint is drawn inside the button instead (see
            // `_hintChild`), where it centres exactly like a picked value.
            //
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
              // Only reached when nothing in `items` matches the value —
              // i.e. the allowUnselect: false fields with no selection.
              hint: _hintChild,
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
              // entries, and the hint for the placeholder slot.
              // The Aligns are not decoration: DropdownButton wraps these in
              // a fixed-height SizedBox, and the DropdownMenuItems they stand
              // in for carry a centerStart Align of their own — without it the
              // closed value rides the top of the row instead of its middle.
              selectedItemBuilder: (context) => [
                // The unselect entry is what a null value resolves to, so this
                // slot — not DropdownButton.hint — is the empty state whenever
                // allowUnselect is on.
                if (widget.allowUnselect) _hintChild,
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
