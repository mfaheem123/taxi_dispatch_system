import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../alert/child_seats_alert.dart';
import '../../alert/extra_fares_alert.dart';
import '../../alert/extra_info_alert.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/models/account_darshboard_model.dart';
import '../dashboard_view/models/all_addresses_model.dart';
import '../dashboard_view/models/dashboard_model.dart';
import '../dashboard_view/models/users_phone_numbers_model.dart';
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

  String? account = 'DEMO';
  String? vehicleType = 'Saloon';
  bool quotation = true, sms = true, email = false;

  AllAddressesModel? _selectedPickup;
  AllAddressesModel? _selectedDrop;

  // ────────── return-journey state
  bool addReturnFare = false;
  ZoneObject? returnPickupZone;
  ZoneObject? returnDropZone;
  DashboardVehicleTypeObject? returnVehicleValue;
  DashboardDriverObject? returnDriverValue;

  late final _rDropoff = TextEditingController();
  late final _rDate = TextEditingController(text: '19 / 05 / 2026');
  late final _rTime = TextEditingController(text: '15:03');
  late final _rLead = TextEditingController();
  late final _rFare = TextEditingController(text: '4.9');

  bool get _isReturnJourney {
    final j = controller.selectJourneyTypeValue?.journeyType
        ?.toUpperCase()
        .trim();
    return j == 'R/N' || j == 'RETURN';
  }


  late final _date = TextEditingController(text: '25 / 04 / 2026');
  late final _fare = TextEditingController(text: '226.00');
  late final _pass = TextEditingController(text: '0');
  late final _lugg = TextEditingController(text: '0');
  late final _slugg = TextEditingController(text: '0');

  void _onMultiReservation() => debugPrint('F8 / Multi Reservation tapped');
  void _onAddVehicles() => debugPrint('F9 / Vehicles tapped');
  void _onVia() => debugPrint('Via tapped');
  void _onSub() => debugPrint('Sub tapped');
  void _onClear() => debugPrint('F7 / Clear tapped');

  final DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  final LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  @override
  void dispose() {
    for (final c in [
      controller.pickupController,
      controller.dropOffController,
      controller.nameController,
      controller.emailController,
      controller.mobileController,
      controller.telController,
      _date,
      controller.pickUpTimeController,
      controller.minController,
      controller.passController,
      _fare,
      _pass,
      _lugg,
      _slugg,
      controller.pickupTwoWayController,
      _rDropoff,
      _rDate,
      _rTime,
      _rLead,
      _rFare,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (controller.dashboardAllData == null) {
      controller.dashboardData();
    }
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
        const SingleActivator(LogicalKeyboardKey.f7): _onClear,
        const SingleActivator(LogicalKeyboardKey.f8): _onMultiReservation,
        const SingleActivator(LogicalKeyboardKey.f9): _onAddVehicles,
      },
      child: Focus(
        autofocus: true,
        child: GetBuilder<DashboardController>(
          initState: (_) {
            controller.seeZoneOnMapp();
            if (_controller.locationtypezoneModel == null) {
              _controller.getLocationTypeZone();
            }
          },
          builder: (controller) {
            return SafeArea(
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
                      borderRadius:
                      BorderRadius.circular(isMobile ? 0 : 10),
                      border: Border.all(color: _border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Column(
                        children: [
                          _topTabs(isMobile),
                          Padding(
                            padding: EdgeInsets.all(isMobile ? 12 : 16),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                _locationRow<ZoneObject>(
                                  'PICKUP',
                                  _green,
                                  controller.pickupController,
                                  controller.allAddressesData,
                                  controller.dashboardZoneValue,
                                  _controller.updateLocationValue.value == true
                                      ? []
                                      : _controller.locationtypezoneModel!.zonesList!,
                                      (v) => setState(() =>
                                  controller.dashboardZoneValue = v),
                                  isMobile,
                                      (value) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if(value.isEmpty) {
                                        controller
                                            .dropDownShow
                                            .value = false;
                                      }else{
                                        controller.dropDownShow.value = true;
                                      }
                                      controller.onChangeHandler(fieldName: "PICKUP LOCATION", searchingText: value);
                                    });
                                  },
                                      (addr) => setState(() => _selectedPickup = addr),
                                  1,
                                  zoneLabel: (z) => z.name!,
                                  onPickIndex: (index) {
                                    controller.tapSelect(index);
                                  },
                                  onCurrentLocation: () {
                                    debugPrint('Use current location → PICKUP');
                                  },
                                ),
                                const SizedBox(height: 4),
                                _locationRow<ZoneObject>(
                                  'DROP   ',
                                  _red,
                                  controller.dropOffController,
                                  controller.allAddressesData,
                                  controller.dashboardDZoneValue,
                                  _controller.updateLocationValue.value == true
                                      ? []
                                      : _controller.locationtypezoneModel!.zonesList!,
                                      (v) => setState(() =>
                                  controller.dashboardDZoneValue = v),
                                  isMobile,
                                      (value) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if(value.isEmpty){
                                            controller.dropDownShow.value = false;
                                          }else{
                                            controller.dropDownShow.value = true;
                                          }
                                          controller.onChangeHandler(fieldName: "DROP LOCATION", searchingText: value);
                                        });
                                  },
                                      (addr) => setState(() => _selectedDrop = addr),
                                  4,
                                  zoneLabel: (z) => z.name!,
                                  onPickIndex: (index) => controller.tapSelect(index),
                                  onCurrentLocation: () {
                                    debugPrint('Use current location → DROP');
                                  },
                                ),
                                const Divider(height: 20),
                                _sectionHeader(Icons.person,
                                    'PASSENGER & BOOKING DETAILS'),
                                _grid(cols, [
                                  _field('Name',
                                      tab: 8, controller: controller.nameController),
                                  _field('Email',
                                      tab: 9, controller: controller.emailController),
                                  _customerAutocompleteField(
                                    'Mobile',
                                    tab: 10,
                                    controller: controller.mobileController,
                                    customers: controller.customerPhoneNumber?.customerInfo ?? const [],
                                    onChanged: (q) {
                                      if (q.trim().isEmpty) return;
                                      controller.onPhoneNoChangeHandler(
                                        fieldName: "Phone Number",
                                        searchingText: q,
                                      );
                                    },
                                    onPicked: (c) {
                                      setState(() {
                                        controller.mobileController.text = c.mobile    ?? '';
                                        controller.nameController.text   = c.name      ?? '';
                                        controller.emailController.text  = c.email     ?? '';
                                        controller.telController.text    = c.telephone ?? '';
                                      });
                                    },
                                  ),
                                  _field('Tel.',
                                      tab: 11, controller: controller.telController),
                                ]),
                                _grid(cols, [
                                  _field('Date',
                                      tab: 12,
                                      prefix: Icons.calendar_today,
                                      controller: _date,
                                      onPrefixTap: () => _pickDate(_date)),
                                  _timeField('Time',
                                      tab: 13,
                                      controller:
                                          controller.pickUpTimeController),
                                  _dropdown<JourneyTypeObject>(
                                    'Journey Type'.toUpperCase(),
                                    controller.selectJourneyTypeValue,
                                    controller.dashboardAllData!.journeyTypes ?? const [],
                                        (v) => setState(() =>
                                    controller.selectJourneyTypeValue = v),
                                    14,
                                    itemLabel: (p) => p.journeyType!,
                                  ),
                                  _field('Lead Time',
                                      tab: 15, controller: controller.minController),
                                ]),
                                _grid(isMobile ? 1 : 3, [
                                  _field('No. of Passengers',
                                      tab: 16,
                                      prefix: Icons.person_outline,
                                      controller: controller.passController),
                                  _field('Fare',
                                      tab: 17,
                                      prefix: Icons.currency_pound,
                                      controller: _fare),
                                  _dropdown<DashboardAccountObject>(
                                    'Account',
                                    controller.selectAccountValue,
                                    controller.dashboardAccountData?.accounts ?? const [],
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
                                if (_isReturnJourney) _returnJourneySection(isMobile, cols),
                                const Divider(height: 20),
                                _sectionHeader(Icons.directions_car,
                                    'VEHICLE & PAYMENT'),
                                const SizedBox(height: 4),
                                _grid(isMobile ? 1 : (isTablet ? 2 : 4), [
                                  _dropdown<PaymentTypeObject>(
                                    'Pay By',
                                    controller.selectPaymentTypeValue,
                                    controller.dashboardAllData!.paymentTypes ?? const [],
                                        (v) => setState(() =>
                                    controller.selectPaymentTypeValue = v),
                                    19,
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
                                    20,
                                    itemLabel: (p) => p.name!,
                                  ),
                                  _dropdown<DepartmentObject>(
                                    'Department',
                                    controller.selectDepartmentData,
                                    controller.selectAccountValue == null
                                        ? []
                                        : controller.selectAccountValue!.departments!,
                                        (v) => setState(() {
                                      controller.selectDepartmentData = v;
                                      controller.update();
                                    }),
                                    21,
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
  Widget _returnJourneySection(bool isMobile, int cols) {
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
          returnPickupZone,
          _controller.updateLocationValue.value == true
              ? []
              : _controller.locationtypezoneModel!.zonesList!,
              (v) => setState(() => returnPickupZone = v),
          isMobile,
              (value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.onChangeHandler(
                  fieldName: "PICKUP LOCATION", searchingText: value);
            });
          },
              (addr) {},
          30,
          zoneLabel: (z) => z.name!,
          onPickIndex: (index) => controller.tapSelect(index),
          onCurrentLocation: () => debugPrint('Use current location → R/PICK'),
        ),
        const SizedBox(height: 4),
        _locationRow<ZoneObject>(
          'DROP',
          _red,
          _rDropoff,
          controller.allAddressesData,
          returnDropZone,
          _controller.updateLocationValue.value == true
              ? []
              : _controller.locationtypezoneModel!.zonesList!,
              (v) => setState(() => returnDropZone = v),
          isMobile,
              (value) {
            controller.onChangeHandler(
                fieldName: "DROP LOCATION", searchingText: value);
          },
              (addr) {},
          33,
          zoneLabel: (z) => z.name!,
          onPickIndex: (index) => controller.tapSelect(index),
          onCurrentLocation: () => debugPrint('Use current location → R/DROP'),
        ),
        const SizedBox(height: 8),
        _grid(cols, [
          _field('R/Date',
              tab: 36,
              prefix: Icons.calendar_today,
              controller: _rDate,
              onPrefixTap: () => _pickDate(_rDate)),
          _timeField('R/Time', tab: 37, controller: _rTime),
          _field('R/Lead', tab: 38, controller: _rLead),
          _field('R/Fare',
              tab: 39, prefix: Icons.currency_pound, controller: _rFare),
        ]),
        const SizedBox(height: 6),
        isMobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _addReturnFareCheckbox(),
          const SizedBox(height: 8),
          _dropdown<DashboardVehicleTypeObject>(
            'Return/VEH',
            returnVehicleValue,
            controller.dashboardAllData!.vehicleTypes!,
                (v) => setState(() => returnVehicleValue = v),
            40,
            itemLabel: (p) => p.name!,
          ),
          const SizedBox(height: 8),
          _dropdown<DashboardDriverObject>(
            'Return/DRV',
            returnDriverValue,
            controller.dashboardAllData!.drivers ?? const [],
                (v) => setState(() => returnDriverValue = v),
            41,
            itemLabel: (p) => p.name ?? '',
          ),
        ])
            : Row(children: [
          _addReturnFareCheckbox(),
          const SizedBox(width: 16),
          Expanded(
            child: _dropdown<DashboardVehicleTypeObject>(
              'Return/VEH',
              returnVehicleValue,
              controller.dashboardAllData!.vehicleTypes!,
                  (v) => setState(() => returnVehicleValue = v),
              40,
              itemLabel: (p) => p.name!,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _dropdown<DashboardDriverObject>(
              'Return/DRV',
              returnDriverValue,
              controller.dashboardAllData!.drivers ?? const [],
                  (v) => setState(() => returnDriverValue = v),
              41,
              itemLabel: (p) => p.name ?? '',
            ),
          ),
        ]),
      ],
    );
  }

  Widget _addReturnFareCheckbox() => Row(mainAxisSize: MainAxisSize.min, children: [
    SizedBox(
      width: 20,
      height: 20,
      child: Checkbox(
        value: addReturnFare,
        onChanged: (v) => setState(() => addReturnFare = v ?? false),
        activeColor: _purple,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    const SizedBox(width: 6),
    const Text('ADD RETURN FARE',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: _fsField)),
  ]);

  // ────────── top tabs (Subsidiary dd → tab 1)
  Widget _topTabs(bool isMobile) {
    Widget tab(String label, {bool active = false, VoidCallback? onTap}) =>
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Material(
            color: Colors.transparent,
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
            child: Row(children: [
              tab('Booking', active: true, onTap: () {}),
              tab('+ Multi Reservation (F8)', onTap: _onMultiReservation),
              tab('+ Vehicles (F9)', onTap: _onAddVehicles),
              tab('Via (0)', onTap: _onVia),
              tab('Sub', onTap: _onSub),
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
          Divider(
            color: _border,
            height: 10,
          )
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
      }) {
    final tag = Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.circle, size: 9, color: dot),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: _fsLabel)),
    ]);

    final address = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 1).toDouble()),
      child: _AddressModelAutocomplete(
        controller: controller,
        items: addresses,
        onChanged: onChanged,
        onSelected: onAddressSelected,
        onPickIndex: onPickIndex,
        decoration: _inputDecoration().copyWith(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          suffixIconConstraints:
          const BoxConstraints(minWidth: 60, minHeight: 32),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.text.isNotEmpty
                  ? IconButton(
                tooltip: 'Clear',
                onPressed: () {
                  DashboardController _controller = Get.find();
                  int index = _controller.markers.indexWhere((test) => test.type == "pickup");
                  FocusScope.of(Get.context!).requestFocus(_controller.pickupTextFieldFocusNode);
                  _controller.markers.clear();
                  _controller.dropDownShow.value = false;
                  _controller.polyLineMarkerInfo.clear();
                  _controller.pickupController.clear();
                  _controller.dropOffController.clear();
                  _controller.polylinePoints.clear();
                  _controller.fetchRouteFromOSRM();
                  _controller.fixedFare.value = "0";
                  _controller.totalDistance.value = "0";
                  _controller.totalTimeDuration.value = "0";
                  _controller.update();
                  controller.clear();
                  onChanged?.call('');
                },
                icon: const Icon(Icons.close,
                    size: 16, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints:
                const BoxConstraints(minWidth: 28, minHeight: 28),
                splashRadius: 16,
              )
                  : IconButton(
                tooltip: '',
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
                icon: const Icon(Icons.close,
                    size: 16, color: Colors.transparent),
                padding: EdgeInsets.zero,
                constraints:
                const BoxConstraints(minWidth: 28, minHeight: 28),
                splashRadius: 16,
              ),
              IconButton(
                tooltip: 'Use current location',
                onPressed: onCurrentLocation,
                icon: const Icon(Icons.my_location,
                    size: 16, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints:
                const BoxConstraints(minWidth: 28, minHeight: 28),
                splashRadius: 16,
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

    final notes = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 3).toDouble()),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: _purple,
          side: const BorderSide(color: _purple),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle:
          const TextStyle(fontSize: _fsField, fontWeight: FontWeight.w600),
        ),
        child: Text('${label[0]}${label.substring(1).toLowerCase()} Notes'),
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
          notes,
        ]),
      ]);
    }

    return Row(children: [
      SizedBox(width: 80, child: tag),
      const SizedBox(width: 8),
      Expanded(flex: 4, child: address),
      const SizedBox(width: 8),
      SizedBox(width: 150, child: zoneDd),
      const SizedBox(width: 8),
      notes,
    ]);
  }

  // ────────── comms + luggage (PASS=22, LUGG=23, SLUGG=24)
  Widget _commsAndLuggageRow(bool isMobile) {
    Widget checkbox(String label, bool value, ValueChanged<bool?> onChanged) =>
        Row(mainAxisSize: MainAxisSize.min, children: [
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
        ]);

    Widget luggageField(String label, IconData icon,
        TextEditingController controller, int tab) =>
        SizedBox(
          width: 80,
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(
                    fontSize: _fsLabel, color: Colors.black)),
            const SizedBox(height: 2),
            FocusTraversalOrder(
              order: NumericFocusOrder(tab.toDouble()),
              child: _GlowFocus(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: _fsField),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          ]),
        );

    Widget iconBtn(IconData icon, {VoidCallback? onPressed}) => Container(
      margin: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _border),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 17, color: Colors.black87),
        splashRadius: 18,
      ),
    );

    final left = Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        checkbox('SMS', sms, (v) => setState(() => sms = v ?? false)),
        checkbox('EMAIL', email, (v) => setState(() => email = v ?? false)),
        luggageField('PASS', Icons.work_outline, _pass, 22),
        luggageField('LUGG', Icons.luggage, _lugg, 23),
        luggageField('SLUGG', Icons.luggage, _slugg, 24),
      ],
    );

    final right = Row(mainAxisSize: MainAxisSize.min, children: [
      iconBtn(Icons.person_outline, onPressed: () {
        showDialog(context: context, builder: (_) => RestrictDriversAlert());
      }),
      iconBtn(Icons.attach_money, onPressed: () {
        showDialog(
          context: context,
          builder: (_) => ChildSeatsAlert(),
        );
      }),
      iconBtn(Icons.note_add_outlined, onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ExtraFaresAlert(),
        );
      }),
      iconBtn(Icons.calculate_outlined, onPressed: () {
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
      card(icon: Icons.schedule, label: 'ETA', value: '1 h 37 mins'),
      card(icon: Icons.timer_outlined, label: 'JOURNEY', value: '0.0 mins'),
      card(icon: Icons.place_outlined, label: 'DISTANCE', value: '78.21 miles'),
      card(
          icon: Icons.payments_outlined,
          label: 'FARE',
          value: '£ 226.00',
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
      25,
      itemLabel: (p) => p.name ?? '',
      hint: 'Select Driver',
    );

    final clear = ElevatedButton(
      onPressed: _onClear,
      style: ElevatedButton.styleFrom(
        backgroundColor: _red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle:
        const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsField),
      ),
      child: Text('CLEAR[F7]'.toUpperCase()),
    );

    final home = ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.home_outlined, size: 16),
      label: const Text('SAVE[HOME]'),
      style: ElevatedButton.styleFrom(
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle:
        const TextStyle(fontWeight: FontWeight.w700, fontSize: _fsField),
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
            style:
            TextStyle(fontSize: _fsField, fontWeight: FontWeight.w600)),
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
        padding: const EdgeInsets.only(bottom: 8),
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
      Text(label.toUpperCase(),
          style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
      const SizedBox(height: 2),
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
    ]);
  }

  // ────────── date / time pickers (calendar + clock)
  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final first = DateTime(now.year - 5);
    final last = DateTime(now.year + 5);
    var initial = now;
    final parts = controller.text.split('/').map((e) => e.trim()).toList();
    if (parts.length == 3) {
      final d = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final y = int.tryParse(parts[2]);
      if (d != null && m != null && y != null) {
        final parsed = DateTime(y, m, d);
        if (!parsed.isBefore(first) && !parsed.isAfter(last)) initial = parsed;
      }
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      final d = picked.day.toString().padLeft(2, '0');
      final m = picked.month.toString().padLeft(2, '0');
      controller.text = '$d / $m / ${picked.year}';
    }
  }

  Widget _timeField(String label,
      {required int tab, required TextEditingController controller}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(),
          style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
      const SizedBox(height: 2),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: _GlowFocus(
          child: _TimePickerField(
            controller: controller,
            decoration: _inputDecoration(),
          ),
        ),
      ),
    ]);
  }

  Widget _field(String label,
      {required int tab,
        IconData? prefix,
        VoidCallback? onPrefixTap,
        TextEditingController? controller}) {
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
      Text(label.toUpperCase(),
          style: const TextStyle(fontSize: _fsLabel, color: Colors.black)),
      const SizedBox(height: 2),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: _GlowFocus(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: _fsField),
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
          Text(label.toUpperCase(),
              style:
              const TextStyle(fontSize: _fsLabel, color: Colors.black)),
          const SizedBox(height: 2),
        ],
        FocusTraversalOrder(
          order: NumericFocusOrder(tab.toDouble()),
          child: _GlowFocus(
            child: DropdownButtonFormField<T>(
              value: value,
              isExpanded: isExpanded,
              style: const TextStyle(
                  fontSize: _fsField, color: Colors.black87),
              hint: hint != null
                  ? Text(hint,
                  style: const TextStyle(
                      fontSize: _fsField, color: Colors.black))
                  : null,
              decoration: _inputDecoration(),
              items: items
                  .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(
                  labelOf(e),
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
      const SizedBox(height: 16),
      Row(children: [
        Switch(
          value: controller.dropDownShow.value,
          onChanged: (v) => setState(() => controller.dropDownShow.value = v),
          activeColor: _purple,
        ),
        const SizedBox(width: 4),
        const Text('Quotation',
            style:
            TextStyle(fontWeight: FontWeight.w500, fontSize: _fsField)),
      ]),
    ]);
  }

  InputDecoration _inputDecoration() => InputDecoration(
    isDense: true,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _border)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _border)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _purple, width: 1.8)),
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
  });

  final TextEditingController controller;
  final List<AllAddressesModel> items;
  final InputDecoration decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<AllAddressesModel>? onSelected;
  final ValueChanged<int>? onPickIndex;

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
        _filter(widget.controller.text);
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
    if (!_focusNode.hasFocus) return;
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

  void _filter(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) {
      _filtered = const [];
    } else {
      _filtered = widget.items.where((a) {
        final n = (a.name ?? '').toLowerCase();
        final p = (a.postcode ?? '').toLowerCase();
        return n.contains(query) || p.contains(query);
      }).toList();
    }
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

  void _pick(AllAddressesModel a) {
    final text = _display(a);
    _userTyped = false;
    widget.controller.text = text;
    widget.controller.selection = TextSelection.collapsed(offset: text.length);
    final idx = widget.items.indexOf(a);
    if (idx >= 0) widget.onPickIndex?.call(idx);

    widget.onSelected?.call(a);
    _focusNode.unfocus();
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
        child: TapRegion(
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
                    style: TextStyle(
                        color: Colors.black, fontSize: 12)),
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
                    style: TextStyle(
                        color: Colors.black, fontSize: 12)),
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
        _filter(widget.controller.text);
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
    if (!_focusNode.hasFocus) return;
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

  void _filter(String q) {
    final query = q.trim().toLowerCase();
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

  void _pick(CustomerObject c) {
    final text = c.mobile ?? '';
    _userTyped = false;
    widget.controller.text = text;
    widget.controller.selection =
        TextSelection.collapsed(offset: text.length);
    widget.onSelected?.call(c);
    _focusNode.unfocus();
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
        child: TapRegion(
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
                    style: TextStyle(
                        color: Colors.black, fontSize: 12)),
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
                              mainAxisAlignment:
                              MainAxisAlignment.center,
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
// Time field — inline dropdown panel (HOURS + MINUTES + OK) below field
// ════════════════════════════════════════════════════════════════════
class _TimePickerField extends StatefulWidget {
  const _TimePickerField({
    required this.controller,
    required this.decoration,
  });

  final TextEditingController controller;
  final InputDecoration decoration;

  @override
  State<_TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<_TimePickerField> {
  final _layerLink = LayerLink();
  final _fieldKey = GlobalKey();
  OverlayEntry? _entry;

  int _hour = 0;
  int _minute = 0;

  static const _accent = Color(0xFF4F46E5);
  static const _border = Color(0xFFE5E7EB);

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  void _seedFromText() {
    final now = TimeOfDay.now();
    _hour = now.hour;
    _minute = now.minute;
    final parts = widget.controller.text.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0].trim());
      final m = int.tryParse(parts[1].trim());
      if (h != null && h >= 0 && h < 24) _hour = h;
      if (m != null && m >= 0 && m < 60) _minute = m;
    }
  }

  void _toggle() {
    if (_entry != null) {
      _hide();
      return;
    }
    _seedFromText();
    _entry = OverlayEntry(builder: _buildPanel);
    Overlay.of(context).insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  void _apply() {
    final hh = _hour.toString().padLeft(2, '0');
    final mm = _minute.toString().padLeft(2, '0');
    widget.controller.text = '$hh:$mm';
    _hide();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.escape) {
      if (_entry != null) {
        _hide();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      if (_entry == null) _toggle();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget _buildPanel(BuildContext context) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth = box?.size.width ?? 240.0;
    final fieldHeight = box?.size.height ?? 40.0;
    final panelWidth = fieldWidth < 250.0 ? 250.0 : fieldWidth;

    return Positioned(
      width: panelWidth,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, fieldHeight + 4),
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(8),
          child: StatefulBuilder(
            builder: (context, setPanel) {
              Widget dd(String title, int value, int count,
                  ValueChanged<int> onPicked) {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                      const SizedBox(height: 4),
                      _TimeNumberDropdown(
                        value: value,
                        count: count,
                        onChanged: (v) => setPanel(() => onPicked(v)),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: _border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dd('HOURS', _hour, 24, (v) => _hour = v),
                        const SizedBox(width: 12),
                        dd('MINUTES', _minute, 60, (v) => _minute = v),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _hide,
                          child: const Text('CANCEL'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _apply,
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: _handleKey,
        child: TextField(
          key: _fieldKey,
          controller: widget.controller,
          readOnly: true,
          style: const TextStyle(fontSize: 12),
          onTap: _toggle,
          decoration: widget.decoration.copyWith(
            prefixIconConstraints:
                const BoxConstraints(minWidth: 28, minHeight: 0),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 8, right: 4),
              child: Icon(Icons.access_time, size: 15, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// Web-style number dropdown — custom overlay list (no native Material
// menu). Used for HOURS / MINUTES inside the time picker panel.
// ════════════════════════════════════════════════════════════════════
class _TimeNumberDropdown extends StatefulWidget {
  const _TimeNumberDropdown({
    required this.value,
    required this.count,
    required this.onChanged,
  });

  final int value;
  final int count;
  final ValueChanged<int> onChanged;

  @override
  State<_TimeNumberDropdown> createState() => _TimeNumberDropdownState();
}

class _TimeNumberDropdownState extends State<_TimeNumberDropdown> {
  final _layerLink = LayerLink();
  final _fieldKey = GlobalKey();
  final _focusNode = FocusNode();
  OverlayEntry? _entry;
  late final ScrollController _scrollController;
  int _highlighted = 0;
  bool _focused = false;

  static const _accent = Color(0xFF4F46E5);
  static const _purple = Color(0xFF312E81);
  static const _border = Color(0xFFE5E7EB);
  static const _itemHeight = 36.0;
  static const _panelHeight = 220.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _hide();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted && _focused != _focusNode.hasFocus) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  void _toggle() {
    if (_entry != null) {
      _hide();
    } else {
      _open();
    }
  }

  void _open() {
    if (_entry != null) return;
    _highlighted = widget.value;
    _entry = OverlayEntry(builder: _buildPanel);
    Overlay.of(context).insert(_entry!);
    _focusNode.requestFocus();
    _scrollToSelected();
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final target = (widget.value * _itemHeight) -
          (_panelHeight / 2) +
          (_itemHeight / 2);
      _scrollController.jumpTo(
        target.clamp(0.0, _scrollController.position.maxScrollExtent),
      );
    });
  }

  void _moveHighlight(int delta) {
    final next = (_highlighted + delta).clamp(0, widget.count - 1);
    if (next == _highlighted) return;
    _highlighted = next;
    _entry?.markNeedsBuild();
    _scrollHighlightedIntoView();
  }

  void _scrollHighlightedIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final c = _scrollController;
      final itemTop = _highlighted * _itemHeight;
      final itemBottom = itemTop + _itemHeight;
      final viewTop = c.offset;
      final viewBottom = viewTop + _panelHeight;
      final maxScroll = c.position.maxScrollExtent;
      if (itemTop < viewTop) {
        c.jumpTo(itemTop.clamp(0.0, maxScroll));
      } else if (itemBottom > viewBottom) {
        c.jumpTo((itemBottom - _panelHeight).clamp(0.0, maxScroll));
      }
    });
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown) {
      if (_entry == null) {
        _open();
      } else {
        _moveHighlight(1);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (_entry == null) {
        _open();
      } else {
        _moveHighlight(-1);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      if (_entry == null) {
        _open();
      } else {
        _pick(_highlighted);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape && _entry != null) {
      _hide();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _pick(int v) {
    _hide();
    widget.onChanged(v);
  }

  Widget _buildPanel(BuildContext context) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 110.0;
    final height = box?.size.height ?? 36.0;
    return Positioned(
      width: width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, height + 4),
        child: TapRegion(
          onTapOutside: (_) => _hide(),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: _panelHeight),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.count,
                itemBuilder: (_, i) {
                  final active = i == _highlighted;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      if (_highlighted == i) return;
                      _highlighted = i;
                      _entry?.markNeedsBuild();
                    },
                    child: InkWell(
                      onTap: () => _pick(i),
                      child: Container(
                        height: _itemHeight,
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        color: active
                            ? const Color(0xFFEEF2FF)
                            : Colors.white,
                        child: Text(
                          i.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: active ? _accent : Colors.black87,
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
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: _handleKey,
        child: InkWell(
          key: _fieldKey,
          canRequestFocus: false,
          onTap: () {
            _focusNode.requestFocus();
            _toggle();
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              border: Border.all(
                color: _focused ? _purple : _border,
                width: _focused ? 1.8 : 1,
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: _purple.withValues(alpha: 0.30),
                        blurRadius: 7,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    size: 18, color: Colors.grey),
              ],
            ),
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
class _GlowFocus extends StatefulWidget {
  const _GlowFocus({required this.child});

  final Widget child;

  @override
  State<_GlowFocus> createState() => _GlowFocusState();
}

class _GlowFocusState extends State<_GlowFocus> {
  static const _purple = Color(0xFF312E81);
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (hasFocus) {
        if (mounted && _focused != hasFocus) {
          setState(() => _focused = hasFocus);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: _purple.withValues(alpha: 0.32),
                    blurRadius: 7,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: _purple.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: 3,
                  ),
                ]
              : const [],
        ),
        child: widget.child,
      ),
    );
  }
}
