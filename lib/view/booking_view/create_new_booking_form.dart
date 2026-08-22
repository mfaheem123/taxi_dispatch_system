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

import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../alert/child_seats_alert.dart';
import '../../alert/extra_fares_alert.dart';
import '../../alert/extra_info_alert.dart';
import '../../alert/restrict_drivers_alert.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/models/all_addresses_model.dart';
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

// ---------------------------------------------------------------------------
// The screen itself.
// ---------------------------------------------------------------------------
class CreateNewBookingForm extends StatefulWidget {
  const CreateNewBookingForm({super.key});

  @override
  State<CreateNewBookingForm> createState() => _CreateNewBookingFormState();
}

class _CreateNewBookingFormState extends State<CreateNewBookingForm> {
  // Same controller the dashboard booking form uses, so PICK/DROP/R-PICK/
  // R-DROP hit the exact same backend search — reuse it if the dashboard
  // already registered one, otherwise stand it up here.
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

  // The contact block is controller-driven because picking a customer in the
  // MOBILE field has to write into the three fields beside it.
  // final _name = TextEditingController();
  // final _email = TextEditingController();
  // final _mobile = TextEditingController();
  // final _tel = TextEditingController();

  // Likewise the four locations: swapping exchanges the text of a pair.
  // final _pick = TextEditingController();
  // final _drop = TextEditingController();
  final _rPick = TextEditingController();
  final _rDrop = TextEditingController();

  // Whichever AllAddressesModel the user last picked for each field — kept
  // around (lat/lon and all) for whatever consumes the booking payload later,
  // exactly like the dashboard form's _selectedPickup / _selectedDrop.
  AllAddressesModel? _selectedPickup;
  AllAddressesModel? _selectedDrop;
  AllAddressesModel? _selectedReturnPickup;
  AllAddressesModel? _selectedReturnDrop;

  // Backed by controller.allAddressesData — the same list the dashboard form
  // feeds its PICK/DROP rows from, refreshed every time a search resolves.
  List<AddressSuggestion> get _addresses => controller.allAddressesData
      .map((a) => AddressSuggestion(name: a.name ?? '', postcode: a.postcode ?? ''))
      .toList();

  /// Finds the AllAddressesModel behind a picked suggestion, so lat/lon is not
  /// lost just because LabeledAddressField only hands back display strings.
  AllAddressesModel? _modelFor(AddressSuggestion a) {
    for (final m in controller.allAddressesData) {
      if (m.name == a.name && (m.postcode ?? '') == a.postcode) return m;
    }
    return null;
  }

  void _onPickupSearch(String value) {
    if (value.trim().isEmpty) return;
    controller.onChangeHandler(
        fieldName: 'PICKUP LOCATION', searchingText: value);
  }

  void _onDropSearch(String value) {
    if (value.trim().isEmpty) return;
    controller.onChangeHandler(
        fieldName: 'DROP LOCATION', searchingText: value);
  }

  void _onReturnPickupSearch(String value) {
    if (value.trim().isEmpty) return;
    controller.onChangeHandler(
        fieldName: 'PICKUP TWO WAY LOCATION', searchingText: value);
  }

  void _onReturnDropSearch(String value) {
    if (value.trim().isEmpty) return;
    controller.onChangeHandler(
        fieldName: 'DROP TWO WAY LOCATION', searchingText: value);
  }

  // Backed by controller.customerPhoneNumber — the same lookup the dashboard
  // form's MOBILE field feeds its autocomplete from, refreshed every time a
  // search resolves.
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

  // ---- Journey type -------------------------------------------------------
  // JOUR picks between a return ('R/N') and a one-way booking. On ONE WAY every
  // return field disappears — there is no second leg to describe — so the form
  // gets shorter and Tab stops walking over inputs that cannot apply.
  static const _journeyTypes = ['R/N', 'ONE WAY'];
  static const _oneWay = 'ONE WAY';

  /// True while the booking has a return leg. Starts true because JOUR opens on
  /// 'R/N', the first item.
  bool _hasReturn = true;

  void _onJourneyChanged(String? value) {
    final hasReturn = value != _oneWay;
    if (hasReturn == _hasReturn) return;
    setState(() {
      _hasReturn = hasReturn;
      if (!hasReturn) {
        // The return fields are removed from the tree, so the ones holding
        // their own state lose it anyway. Clearing the two parent-owned
        // addresses as well keeps the whole return leg consistently empty
        // instead of leaving stale text to reappear — and stops a one-way
        // booking from carrying return data it should not have.
        _rPick.clear();
        _rDrop.clear();
      }
    });
  }

  /// [field] when the booking has a return leg, nothing when it does not.
  /// Returning a list lets it be spread straight into a grid's children.
  List<SpanField> _ifReturn(SpanField field) => _hasReturn ? [field] : const [];

  @override
  void dispose() {
    for (final c in [
      // _name,
      // _email,
      // _mobile,
      // _tel,
      // _pick,
      // _drop,
      _rPick,
      _rDrop,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onCustomerPicked(CustomerSuggestion c) {
    setState(() {
      controller.nameController.text = c.name;
      controller.emailController.text = c.email;
      controller.telController.text = c.telephone;
    });
  }

  /// Exchanges a pickup with its drop, like the dashboard's swap button.
  void _swap(TextEditingController a, TextEditingController b) {
    final tmp = a.text;
    a.text = b.text;
    b.text = tmp;
  }

  @override
  Widget build(BuildContext context) {
    const vehicles = ['SALOON', 'ESTATE', 'MPV', 'EXECUTIVE'];

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
                  // Cap the width on very large screens so the form doesn't stretch
                  // into an unusable full-bleed layout on big monitors.
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: FocusTraversalGroup(
                      // Explicit order rather than geometry: a Wrap can place
                      // a short field (a checkbox) above a tall one, which is
                      // enough to confuse reading-order traversal.
                      policy: OrderedTraversalPolicy(
                        requestFocusCallback: smoothTraversalFocus,
                      ),
                      // Two nested GetBuilders: the outer rebuilds whenever
                      // LocationController.update() fires — i.e. when
                      // getLocationTypeZone() resolves and refills
                      // locationtypezoneModel.zonesList, feeding all four zone
                      // dropdowns. The inner rebuilds on
                      // DashboardController.update() — i.e. when
                      // getAddresses() finishes and refills
                      // controller.allAddressesData, feeding PICK/DROP/R-PICK/
                      // R-DROP's suggestion lists.
                      child: PageScrollWrapper(
                        child: GetBuilder<LocationController>(
                          builder: (_) => GetBuilder<DashboardController>(
                          builder: (controller) => Column(
                          children: [
                            const TopTabs(),
                            const SizedBox(height: Density.cardGap),

                            // ---- Booking header: source + sub ----
                            SectionCard(
                              child: ResponsiveGrid(
                                orderBase: 100,
                                children: [
                                  SpanField(HeaderTitle('BOOKING'), span: 2),
                                  SpanField(LabeledDropdown('SOURCE',
                                      items: ['OPT', 'WEB', 'APP', 'PHONE'])),
                                  SpanField(LabeledDropdown('SUB', items: [
                                    'DEMO COMPANY',
                                    'Company 2',
                                    'Company 3'
                                  ])),
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
                                        controller: controller.pickupTwoWayController,
                                        addresses: _addresses,
                                        dotColor: Colors.green,
                                        onSwap: () => _swap(controller.pickupTwoWayController, controller.dropOffController),
                                        onSearch: _onPickupSearch,
                                        onPicked: (a) =>
                                            _selectedPickup = _modelFor(a),
                                      ),
                                      span: 2),
                                  SpanField(LabeledZoneDropdown(
                                    'PICK ZONE',
                                    items: _zones,
                                    value: controller.dashboardZoneValue,
                                    onChanged: (v) =>
                                        setState(() => controller.dashboardZoneValue = v),
                                  )),
                                  SpanField(
                                      LabeledInput('PICKUP NOTES',
                                          uppercase: true)),
                                  SpanField(
                                      LabeledAddressField(
                                        'DROP',
                                        controller: controller.dropOffController,
                                        addresses: _addresses,
                                        dotColor: Colors.red,
                                        onSwap: () => _swap(controller.pickupTwoWayController, controller.dropOffController),
                                        onSearch: _onDropSearch,
                                        onPicked: (a) =>
                                            _selectedDrop = _modelFor(a),
                                      ),
                                      span: 2),
                                  SpanField(LabeledZoneDropdown(
                                    'DROP ZONE',
                                    items: _zones,
                                    value: controller.dashboardDZoneValue,
                                    onChanged: (v) =>
                                        setState(() => controller.dashboardDZoneValue = v),
                                  )),
                                  SpanField(
                                      LabeledInput('DROPOFF NOTES',
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
                                ],
                              ),
                            ),

                            // ---- Dates & times ----
                            SectionCard(
                              child: ResponsiveGrid(
                                orderBase: 300,
                                children: [
                                  SpanField(LabeledDatePicker('DATE')),
                                  SpanField(LabeledTimePicker('TIME')),
                                  // Everything below describes the return leg, so
                                  // ONE WAY drops the lot.
                                  ..._ifReturn(
                                      SpanField(LabeledDatePicker('R/DATE'))),
                                  ..._ifReturn(
                                      SpanField(LabeledTimePicker('R/TIME'))),
                                  ..._ifReturn(SpanField(
                                      LabeledAddressField(
                                        'R/PICK',
                                        controller: _rPick,
                                        addresses: _addresses,
                                        dotColor: Colors.green,
                                        onSwap: () => _swap(_rPick, _rDrop),
                                        onSearch: _onReturnPickupSearch,
                                        onPicked: (a) =>
                                            _selectedReturnPickup = _modelFor(a),
                                      ),
                                      span: 2)),
                                  ..._ifReturn(SpanField(LabeledZoneDropdown(
                                    'R/PICK ZONE',
                                    items: _zones,
                                    value: _locationController.RNzoneValue,
                                    onChanged: (v) => setState(
                                        () => _locationController.RNzoneValue = v),
                                  ))),
                                  ..._ifReturn(SpanField(
                                      LabeledInput('R/PICK NOTES',
                                          uppercase: true))),
                                  ..._ifReturn(SpanField(
                                      LabeledAddressField(
                                        'R/DROP',
                                        controller: _rDrop,
                                        addresses: _addresses,
                                        dotColor: Colors.red,
                                        onSwap: () => _swap(_rPick, _rDrop),
                                        onSearch: _onReturnDropSearch,
                                        onPicked: (a) =>
                                            _selectedReturnDrop = _modelFor(a),
                                      ),
                                      span: 2)),
                                  ..._ifReturn(SpanField(LabeledZoneDropdown(
                                    'R/DROP ZONE',
                                    items: _zones,
                                    value: _locationController.RN1zoneValue,
                                    onChanged: (v) => setState(
                                        () => _locationController.RN1zoneValue = v),
                                  ))),
                                  ..._ifReturn(SpanField(
                                      LabeledInput('R/DROP NOTES',
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
                                      keyboardType: TextInputType.number)),
                                  SpanField(LabeledDropdown('JOUR',
                                      items: _journeyTypes,
                                      onChanged: _onJourneyChanged)),
                                  SpanField(
                                      LabeledDropdown('VEH', items: vehicles)),
                                  ..._ifReturn(SpanField(
                                      LabeledDropdown('R/VEH',
                                          items: vehicles))),
                                  SpanField(LabeledDropdown('ACC', items: [
                                    'SELECT ACCOUNT',
                                    'Account 1',
                                    'Account 2'
                                  ])),
                                  SpanField(LabeledInput('PASS',
                                      keyboardType: TextInputType.number)),
                                  SpanField(LabeledInput('LUGG',
                                      keyboardType: TextInputType.number)),
                                  SpanField(LabeledInput('SLGG',
                                      keyboardType: TextInputType.number)),
                                ],
                              ),
                            ),

                            // ---- Payment + options ----
                            SectionCard(
                              child: ResponsiveGrid(
                                orderBase: 500,
                                children: [
                                  SpanField(LabeledDropdown('PAY', items: [
                                    'CASH',
                                    'CARD',
                                    'ACCOUNT',
                                    'INVOICE'
                                  ])),
                                  ..._ifReturn(SpanField(
                                      LabeledInput('R/LEAD (MINS)',
                                          keyboardType: TextInputType.number))),
                                  SpanField(LabeledCheckbox('QUOTATION'),widths: 110),
                                  SpanField(LabeledCheckbox('SMS', value: true),widths: 80),
                                  SpanField(LabeledCheckbox('EMAIL'),widths: 80),
                                  // Three keyboard-reachable shortcuts into the
                                  // booking's extra detail dialogs. They come
                                  // last in this section, so Tab reaches them
                                  // after the checkboxes and before the fares.
                                  SpanField(
                                    LabeledIconActions([
                                      IconAction(
                                        icon: Icons.person,
                                        tooltip: 'EXTRA INFO',
                                        onTap: () => showDialog(context: context, builder: (_) => RestrictDriversAlert()),
                                      ),
                                      IconAction(
                                        icon: Icons.attach_money,
                                        tooltip: 'EXTRA FARES',
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: (_) => ChildSeatsAlert(),
                                        ),
                                      ),
                                      IconAction(
                                        icon: Icons.note_add,
                                        tooltip: 'CHILD SEATS',
                                        onTap: () => showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => ExtraFaresAlert(),
                                        ),
                                      ),
                                    ]),
                                    widths: LabeledIconActions.width(3),
                                  ),
                                  // SpanField(LabeledCheckbox('ADD RETURN FARE')),
                                ],
                              ),
                            ),

                            // ---- Fares row ----
                            SectionCard(
                              child: Column(
                                children: [
                                  StatStrip(),
                                  SizedBox(height: Density.gridSpacing),
                                  ResponsiveGrid(
                                    orderBase: 600,
                                    children: [
                                      SpanField(LabeledInput('FARE (£)',
                                          keyboardType: TextInputType.number)),
                                      ..._ifReturn(SpanField(
                                          LabeledInput('R/FARE (£)',
                                              keyboardType:
                                                  TextInputType.number))),
                                      SpanField(LabeledDropdown('DRV', items: [
                                        'SELECT DRIVER',
                                        'Driver 1',
                                        'Driver 2'
                                      ])),
                                      ..._ifReturn(
                                          SpanField(LabeledDropdown('R/DRV',
                                              items: [
                                            'SELECT DRIVER',
                                            'Driver 1',
                                            'Driver 2'
                                          ]))),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // ---- Action buttons ----
                            const ActionButtons(),
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
