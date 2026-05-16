import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/models/account_darshboard_model.dart';
import '../dashboard_view/models/all_addresses_model.dart';
import '../dashboard_view/models/dashboard_model.dart';
import '../locations_view/Model/location_types_zoneModel.dart' show ZoneObject;
import '../locations_view/controller/locations_controller.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
// ────────── palette
  static const _purple = Color(0xFF4F46E5);
  static const _purpleDark = Color(0xFF312E81);
  static const _purpleSoft = Color(0xFFEEF2FF);
  static const _border = Color(0xFFE5E7EB);
  static const _surface = Color(0xFFF5F6FA);
  static const _red = Color(0xFFEF4444);
  static const _green = Color(0xFF22C55E);

// ────────── state
  String? driver;
  ZoneObject? dashboardZoneValue, dropZone;

  String? account = 'DEMO';
  String? vehicleType = 'Saloon';
  bool quotation = true, sms = true, email = false;

// selected address models (give you access to lat/lon)
  AllAddressesModel? _selectedPickup;
  AllAddressesModel? _selectedDrop;

  static const _mobileSuggestions = [
    '0123213133213',
    '07123 456789',
    '07700 900123',
    '07911 123456',
    '02071 234567',
  ];

// ────────── controllers (created once)
  late final _pickup =
      TextEditingController(text: 'Hill House, Wild Hill, Hatfield, AL9 6EB');
  late final _drop = TextEditingController(
      text: 'Flat, Ashford Road, St. Michaels, Tenter, TN30 6EJ');
  late final _name = TextEditingController(text: 'Test Passenger');
  late final _email = TextEditingController(text: 't12410@gmail.com');
  late final _mobile = TextEditingController(text: '0123213133213');
  late final _tel = TextEditingController(text: '232132131');
  late final _date = TextEditingController(text: '25 / 04 / 2026');
  late final _time = TextEditingController(text: '01:42');
  late final _lead = TextEditingController(text: 'MINS');
  late final _pax = TextEditingController(text: '1');
  late final _fare = TextEditingController(text: '226.00');
  late final _pass = TextEditingController(text: '0');
  late final _lugg = TextEditingController(text: '0');
  late final _slugg = TextEditingController(text: '0');

  void _onMultiReservation() {
// TODO: open multi-reservation flow
    debugPrint('F8 / Multi Reservation tapped');
  }

  void _onAddVehicles() {
// TODO: open add-vehicles flow
    debugPrint('F9 / Vehicles tapped');
  }

  void _onVia() {
    debugPrint('Via tapped');
  }

  void _onSub() {
    debugPrint('Sub tapped');
  }

  void _onClear() {
// wire up to your existing Clear (F7) button
    debugPrint('F7 / Clear tapped');
  }

  final DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  final LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  @override
  void dispose() {
    for (final c in [
      _pickup,
      _drop,
      _name,
      _email,
      _mobile,
      _tel,
      _date,
      _time,
      _lead,
      _pax,
      _fare,
      _pass,
      _lugg,
      _slugg,
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
// _selectedPickup / _selectedDrop start as null — populated when user picks
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final isTablet = w >= 640 && w < 1024;
    final isDesktop = w >= 1024;
    final cols = isMobile ? 1 : (isTablet ? 2 : 4);

    final formWidth = isDesktop ? w * 0.5 : double.infinity;

    return Scaffold(
      backgroundColor: _surface,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CallbackShortcuts(
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
                    child: Center(
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                          _pickup,
                                          controller.allAddressesData,
                                          controller.dashboardZoneValue,
                                          _controller.updateLocationValue.value ==
                                                  true
                                              ? []
                                              : _controller.locationtypezoneModel!
                                                  .zonesList!,
                                          (v) => setState(() =>
                                              controller.dashboardZoneValue = v),
                                          isMobile,
                                          (value) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              controller.onChangeHandler(
                                                  fieldName: "PICKUP LOCATION",
                                                  searchingText: value);
                                            });
                                          },
                                          (addr) {
                                            setState(() => _selectedPickup = addr);
                                          },
                                          0,
                                          zoneLabel: (z) => z.name!,
                                        ),
                                        const SizedBox(height: 4),
                                        _locationRow<ZoneObject>(
                                          'DROP  ',
                                          _red,
                                          _drop,
                                          controller.allAddressesData,
                                          controller.dashboardDZoneValue,
                                          _controller.updateLocationValue.value ==
                                                  true
                                              ? []
                                              : _controller.locationtypezoneModel!
                                                  .zonesList!,
                                          (v) => setState(() =>
                                              controller.dashboardDZoneValue = v),
                                          isMobile,
                                          (value) {
                                            controller.onChangeHandler(
                                                fieldName: "DROP LOCATION",
                                                searchingText: value);
                                          },
                                          (addr) {
                                            setState(() => _selectedDrop = addr);
                                          },
                                          10,
                                          zoneLabel: (z) => z.name!,
                                        ),
                                        const Divider(height: 20),
                                        _sectionHeader(Icons.person,
                                            'PASSENGER & BOOKING DETAILS'),
          // const SizedBox(height: 4),
                                        _grid(cols, [
                                          _field('Name',
                                              tab: 21, controller: _name),
                                          _field('Email',
                                              tab: 22, controller: _email),
                                          _autocompleteField(
                                            'Mobile',
                                            tab: 23,
                                            controller: _mobile,
                                            suggestions: _mobileSuggestions,
                                          ),
                                          _field('Tel.', tab: 24, controller: _tel),
                                        ]),
          // const SizedBox(height: 4),
                                        _grid(cols, [
                                          _field('Date',
                                              tab: 25,
                                              prefix: Icons.calendar_today,
                                              controller: _date),
                                          _field('Time',
                                              tab: 26,
                                              prefix: Icons.access_time,
                                              controller: _time),
                                          _dropdown<JourneyTypeObject>(
                                            'Journey Type'.toUpperCase(),
                                            controller.selectJourneyTypeValue,
                                            controller.dashboardAllData!.journeyTypes ??
                                                const [],
                                                (v) => setState(() =>
                                            controller.selectJourneyTypeValue = v),
                                            27,
                                            itemLabel: (p) => p.journeyType!,
                                          ),
                                          _field('Lead Time',
                                              tab: 28, controller: _lead),
                                        ]),
          // const SizedBox(height: 4),
                                        _grid(isMobile ? 1 : 3, [
                                          _field('No. of Passengers',
                                              tab: 29,
                                              prefix: Icons.person_outline,
                                              controller: _pax),
                                          _field('Fare',
                                              tab: 30,
                                              prefix: Icons.currency_pound,
                                              controller: _fare),
                                          _dropdown<DashboardAccountObject>(
                                            'Account',
                                            controller.selectAccountValue,
                                            controller.dashboardAccountData
                                                    ?.accounts ??
                                                const [],
                                            (v) => setState(() =>
                                                controller.selectAccountValue = v),
                                            41,
                                            itemLabel: (p) => p.name!,
                                          ),
                                        ]),
                                        const Divider(height: 20),
                                        _sectionHeader(Icons.directions_car,
                                            'VEHICLE & PAYMENT'),
                                        const SizedBox(height: 4),
                                        _grid(isMobile ? 1 : (isTablet ? 2 : 4), [
                                          _dropdown<PaymentTypeObject>(
                                            'Pay By',
                                            controller.selectPaymentTypeValue,
                                            controller.dashboardAllData!
                                                    .paymentTypes ??
                                                const [],
                                            (v) => setState(() => controller
                                                .selectPaymentTypeValue = v),
                                            41,
                                            itemLabel: (p) => p.name!,
                                          ),
                                          _dropdown<DashboardVehicleTypeObject>(
                                            'Vehicle Type',
                                            controller.selectVehicleValue,
                                            controller
                                                .dashboardAllData!.vehicleTypes!,
                                            (v) => setState(() {
                                              controller.selectVehicleValue = v;
                                              controller.getFaresCalculation();
                                            }),
                                            41,
                                            itemLabel: (p) => p.name!,
                                          ),
                                          _dropdown<DepartmentObject>(
                                            'Department',
                                            controller.selectDepartmentData,
                                            controller.selectAccountValue == null
                                                ? []
                                                : controller.selectAccountValue!
                                                    .departments!,
                                            (v) => setState(() {
                                              controller.selectDepartmentData = v;
                                              controller.update();
                                            }),
                                            41,
                                            itemLabel: (p) => p.name!,
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
                    ),
                  );
                },
              ),
            ),
          ),
          Container(color: Colors.red,
            width: formWidth,
          )
        ],
      ),
    );
  }

// ────────── top tabs
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
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: SingleChildScrollView(
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
              41,
              itemLabel: (p) => p.name ?? '',
            ),
          ),
        ]),
      ),
    );
  }

// ────────── location row (backed by AllAddressesModel)
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
  }) {
    final tag = Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.circle, size: 10, color: dot),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
    ]);

    final address = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 1).toDouble()),
      child: _AddressModelAutocomplete(
        controller: controller,
        items: addresses,
        onChanged: onChanged,
        onSelected: onAddressSelected,
        decoration: _inputDecoration().copyWith(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          suffixIconConstraints:
          const BoxConstraints(minWidth: 60, minHeight: 32),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: controller.clear,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.my_location, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // ← was 14
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
      SizedBox(width: 90, child: tag),
      const SizedBox(width: 8),
      Expanded(flex: 4, child: address),
      const SizedBox(width: 8),
      SizedBox(width: 150, child: zoneDd),
      const SizedBox(width: 8),
      notes,
    ]);
  }

// ────────── SMS / Email / luggage / action icons row
  Widget _commsAndLuggageRow(bool isMobile) {
    Widget checkbox(String label, bool value, ValueChanged<bool?> onChanged) =>
        Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: _purple,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ]);

    Widget luggageField(String label, IconData icon,
        TextEditingController controller, int tab) =>
        SizedBox(
          width: 80,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 2),
            FocusTraversalOrder(
              order: NumericFocusOrder(tab.toDouble()),
              child: TextField(
                controller: controller,
                style: const TextStyle(fontSize: 13),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration().copyWith(
                  prefixIconConstraints:
                  const BoxConstraints(minWidth: 28, minHeight: 0),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 6, right: 2),
                    child: Icon(icon, size: 14, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ]),
        );

    Widget iconBtn(IconData icon) => Container(
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _border),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(icon, size: 18, color: Colors.black87),
            splashRadius: 20,
          ),
        );

    final left = Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        checkbox('SMS', sms, (v) => setState(() => sms = v ?? false)),
        checkbox('EMAIL', email, (v) => setState(() => email = v ?? false)),
        luggageField('PASS', Icons.work_outline, _pass, 31),
        luggageField('LUGG', Icons.luggage, _lugg, 32),
        luggageField('SLUGG', Icons.luggage, _slugg, 33),
      ],
    );

    final right = Row(mainAxisSize: MainAxisSize.min, children: [
      iconBtn(Icons.person_outline),
      iconBtn(Icons.attach_money),
      iconBtn(Icons.note_add_outlined),
      iconBtn(Icons.calculate_outlined),
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
          Icon(icon, size: 22, color: emphasized ? Colors.white : _purple),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: emphasized ? Colors.white70 : _purpleDark,
                    )),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                      fontSize: 15,
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

// ────────── driver row
  Widget _driverRow(bool isMobile) {
    final dd = DropdownButtonFormField<String>(
      value: driver,
      hint: const Text('Select Driver'),
      decoration: _inputDecoration(),
      items: ['Driver 1', 'Driver 2']
          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
          .toList(),
      onChanged: (v) => setState(() => driver = v),
    );

    final clear = ElevatedButton(
      onPressed: _onClear,
      style: ElevatedButton.styleFrom(
        backgroundColor: _red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: const Text('Clear (F7)',
          style: TextStyle(fontWeight: FontWeight.w700)),
    );

    final home = ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.home_outlined, size: 18),
      label: const Text('Home', style: TextStyle(fontWeight: FontWeight.w700)),
      style: ElevatedButton.styleFrom(
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );

    if (isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Driver',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
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
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
        Icon(icon, size: 18, color: _purple),
        const SizedBox(width: 6),
        Text(title,
            style: const TextStyle(
                color: _purple, fontWeight: FontWeight.w700, fontSize: 13)),
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

  Widget _autocompleteField(
      String label, {
        required int tab,
        required TextEditingController controller,
        required List<String> suggestions,
        IconData? prefix,
      }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 2),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: _StringAutocomplete(
          controller: controller,
          suggestions: suggestions,
          decoration: _inputDecoration().copyWith(
            prefixIconConstraints:
            const BoxConstraints(minWidth: 30, minHeight: 0),
            prefixIcon: prefix != null
                ? Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: Icon(prefix, size: 16, color: Colors.grey),
            )
                : null,
          ),
        ),
      ),
    ]);
  }

  Widget _field(String label,
      {required int tab, IconData? prefix, TextEditingController? controller}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 2),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: TextField(
          controller: controller,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration().copyWith(
            prefixIconConstraints:
            const BoxConstraints(minWidth: 30, minHeight: 0),
            prefixIcon: prefix != null
                ? Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: Icon(prefix, size: 16, color: Colors.grey),
            )
                : null,
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
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
        ],
        FocusTraversalOrder(
          order: NumericFocusOrder(tab.toDouble()),
          child: DropdownButtonFormField<T>(
            value: value,
            isExpanded: isExpanded,
            hint: hint != null ? Text(hint) : null,
            decoration: _inputDecoration(),
            items: items
                .map((e) => DropdownMenuItem<T>(
                      value: e,
                      child: Text(
                        labelOf(e),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _quotationToggle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 18),
      Row(children: [
        Switch(
          value: controller.dropDownShow.value,
          onChanged: (v) => setState(() => controller.dropDownShow.value = v),
          activeColor: _purple,
        ),
        const SizedBox(width: 4),
        const Text('Quotation', style: TextStyle(fontWeight: FontWeight.w500)),
      ]),
    ]);
  }

  InputDecoration _inputDecoration() => InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: _border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: _border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: _purple)),
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
  });

  final TextEditingController controller;
  final List<AllAddressesModel> items;
  final InputDecoration decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<AllAddressesModel>? onSelected;

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
// intentionally do NOT auto-open on focus
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

      const itemHeight = 52.0;
      const panelHeight = 280.0;
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
              constraints: const BoxConstraints(maxHeight: 280),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _filtered.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('No data',
                          style: TextStyle(color: Colors.black54)),
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
                              height: 52,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              color: active
                                  ? const Color(0xFFEEF2FF)
                                  : Colors.white,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                Icon(Icons.place_outlined,
                                    size: 18,
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
                                        a.name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: active
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        a.postcode ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54,
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
      child: Focus(
        onKeyEvent: _handleKey,
        child: TextField(
          key: _fieldKey,
          onChanged: widget.onChanged,
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: widget.decoration,
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
              constraints: const BoxConstraints(maxHeight: 240),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _filtered.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('No matches',
                          style: TextStyle(color: Colors.black54)),
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
                              height: 38,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              color: active
                                  ? const Color(0xFFEEF2FF)
                                  : Colors.white,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                Icon(Icons.place_outlined,
                                    size: 16,
                                    color: active
                                        ? const Color(0xFF4F46E5)
                                        : Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(s,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
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
      child: Focus(
        onKeyEvent: _handleKey,
        child: TextField(
          key: _fieldKey,
          onChanged: widget.onChanged,
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: widget.decoration,
        ),
      ),
    );
  }
}
