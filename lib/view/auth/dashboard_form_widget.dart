import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String? pickupZone, dropZone, department, driver;
  String? journeyType = 'One Way';
  String? account = 'DEMO';
  String? payBy = 'Cash';
  String? vehicleType = 'Saloon';
  bool quotation = true, sms = true, email = false;
  int luggage = 0; // 0 = none, 1 = luggage, 2 = extra

  // ────────── address suggestion sources
  static const _pickupSuggestions = [
    'Hill House, Wild Hill, Hatfield AL9 6EB',
    'Heathrow Airport Terminal 5, TW6',
    'Gatwick Airport South Terminal, RH6 0NP',
    'Luton Airport, LU2 9LY',
    'London Bridge Station, SE1 9SP',
    'Kings Cross St Pancras, N1C 4QP',
    'Stansted Airport, CM24 1QW',
    'Paddington Station, London W2 1HQ',
  ];

  static const _dropSuggestions = [
    'Flat, TN30, Ashford Road, St. Michaels, Tenter',
    '10 Downing Street, London SW1A 2AA',
    'Canary Wharf, London E14 5AB',
    'Westfield Stratford, London E20 1EJ',
    'O2 Arena, Peninsula Square, London SE10 0DX',
    'Wembley Stadium, London HA9 0WS',
    'Tower Bridge, London SE1 2UP',
    'British Museum, Great Russell St, London WC1B 3DG',
  ];

  // ────────── controllers (created once)
  late final _pickup = TextEditingController(text: 'Hill House, Wild Hill, Hatfield AL9 6EB');
  late final _drop = TextEditingController(text: 'Flat, TN30, Ashford Road, St. Michaels, Tenter');
  late final _name = TextEditingController(text: 'Test Passenger');
  late final _email = TextEditingController(text: 't12410@gmail.com');
  late final _mobile = TextEditingController(text: '0123213133213');
  late final _tel = TextEditingController(text: '232132131');
  late final _date = TextEditingController(text: '25 / 04 / 2026');
  late final _time = TextEditingController(text: '01:42');
  late final _lead = TextEditingController(text: 'MINS');
  late final _pax = TextEditingController(text: '1');
  late final _fare = TextEditingController(text: '226.00');

  @override
  void dispose() {
    for (final c in [_pickup, _drop, _name, _email, _mobile, _tel,
      _date, _time, _lead, _pax, _fare]) {
      c.dispose();
    }
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

    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
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
                  borderRadius: BorderRadius.circular(isMobile ? 0 : 10),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _locationRow('PICKUP', _green, _pickup,
                                _pickupSuggestions, pickupZone,
                                    (v) => setState(() => pickupZone = v), isMobile, 0),
                            const SizedBox(height: 10),
                            _locationRow('DROP', _red, _drop,
                                _dropSuggestions, dropZone,
                                    (v) => setState(() => dropZone = v), isMobile, 10),
                            const Divider(height: 32),
                            _sectionHeader(Icons.person, 'PASSENGER & BOOKING DETAILS'),
                            const SizedBox(height: 12),
                            _grid(cols, [
                              _field('Name', tab: 21, controller: _name),
                              _field('Email', tab: 22, controller: _email),
                              _field('Mobile', tab: 23, controller: _mobile),
                              _field('Tel.', tab: 24, controller: _tel),
                            ]),
                            const SizedBox(height: 12),
                            _grid(cols, [
                              _field('Date', tab: 25, prefix: Icons.calendar_today, controller: _date),
                              _field('Time', tab: 26, prefix: Icons.access_time, controller: _time),
                              _dropdown('Journey Type', journeyType, ['One Way', 'Return', 'Hourly'],
                                      (v) => setState(() => journeyType = v), 27),
                              _field('Lead Time', tab: 28, controller: _lead),
                            ]),
                            const SizedBox(height: 12),
                            _grid(isMobile ? 1 : 3, [
                              _field('No. of Passengers', tab: 29,
                                  prefix: Icons.person_outline, controller: _pax),
                              _field('Fare', tab: 30,
                                  prefix: Icons.currency_pound, controller: _fare),
                              _dropdown('Account', account, ['DEMO', 'Account A', 'Account B'],
                                      (v) => setState(() => account = v), 31),
                            ]),
                            const Divider(height: 32),
                            _sectionHeader(Icons.directions_car, 'VEHICLE & PAYMENT'),
                            const SizedBox(height: 12),
                            _grid(isMobile ? 1 : (isTablet ? 2 : 4), [
                              _dropdown('Pay By', payBy, ['Cash', 'Card', 'Invoice'],
                                      (v) => setState(() => payBy = v), 41),
                              _dropdown('Vehicle Type', vehicleType, ['Saloon', 'Estate', 'MPV'],
                                      (v) => setState(() => vehicleType = v), 42),
                              _dropdown('Department', department, ['- Select -', 'Sales', 'Ops'],
                                      (v) => setState(() => department = v), 43),
                              _quotationToggle(),
                            ]),
                            const SizedBox(height: 14),
                            _commsAndLuggageRow(isMobile),
                            const SizedBox(height: 16),
                            _statusCards(isMobile),
                            const SizedBox(height: 14),
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
      ),
    );
  }

  // ────────── top tabs
  Widget _topTabs(bool isMobile) {
    Widget tab(String label, {bool active = false}) => Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: active ? _purple : Colors.white,
        border: Border.all(color: active ? _purple : _border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          )),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          tab('Booking', active: true),
          tab('+ Multi Reservation (F8)'),
          tab('+ Vehicles (F9)'),
          tab('Via (0)'),
          tab('Sub'),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Sea Cars Private Hire Ltd.',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 18),
            ]),
          ),
        ]),
      ),
    );
  }

  // ────────── location row (web-style autocomplete)
  Widget _locationRow(
      String label,
      Color dot,
      TextEditingController controller,
      List<String> suggestions,
      String? zone,
      ValueChanged<String?> onZone,
      bool isMobile,
      int tabBase) {
    final tag = Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.circle, size: 10, color: dot),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
    ]);

    final address = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 1).toDouble()),
      child: _AddressAutocomplete(
        controller: controller,
        suggestions: suggestions,
        decoration: _inputDecoration().copyWith(
          suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
              onPressed: controller.clear,
              splashRadius: 18,
            ),
            const Icon(Icons.my_location, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
          ]),
        ),
      ),
    );

    final zoneDd = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 2).toDouble()),
      child: DropdownButtonFormField<String>(
        value: zone,
        hint: const Text('New Zone'),
        decoration: _inputDecoration(),
        items: ['Zone A', 'Zone B']
            .map((z) => DropdownMenuItem(value: z, child: Text(z)))
            .toList(),
        onChanged: onZone,
      ),
    );

    final notes = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 3).toDouble()),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: _purple,
          side: const BorderSide(color: _purple),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
        Row(children: [Expanded(child: zoneDd), const SizedBox(width: 8), notes]),
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
            width: 22, height: 22,
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

    Widget luggageBtn(String label, IconData icon, int idx) {
      final active = luggage == idx;
      return OutlinedButton.icon(
        onPressed: () => setState(() => luggage = idx),
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: active ? Colors.white : Colors.black87,
          backgroundColor: active ? _purple : Colors.white,
          side: const BorderSide(color: _border),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      );
    }

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

    final left = Wrap(spacing: 8, runSpacing: 8, children: [
      checkbox('SMS', sms, (v) => setState(() => sms = v ?? false)),
      checkbox('Email', email, (v) => setState(() => email = v ?? false)),
      luggageBtn('No Luggage', Icons.person, 0),
      luggageBtn('Luggage', Icons.person, 1),
      luggageBtn('Extra Luggage', Icons.luggage, 2),
    ]);

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: emphasized ? _purpleDark : _purpleSoft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          Icon(icon,
              size: 22,
              color: emphasized ? Colors.white : _purple),
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
      card(icon: Icons.payments_outlined, label: 'FARE',
          value: '£ 226.00', emphasized: true),
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
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: _red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: const Text('Clear (F7)', style: TextStyle(fontWeight: FontWeight.w700)),
    );

    if (isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Driver',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        dd,
        const SizedBox(height: 10),
        clear,
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

  Widget _field(String label,
      {required int tab, IconData? prefix, TextEditingController? controller}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 4),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: TextField(
          controller: controller,
          decoration: _inputDecoration().copyWith(
            prefixIcon: prefix != null
                ? Icon(prefix, size: 18, color: Colors.grey)
                : null,
          ),
        ),
      ),
    ]);
  }

  Widget _dropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged, int tab) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 4),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: _inputDecoration(),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    ]);
  }

  Widget _quotationToggle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 18),
      Row(children: [
        Switch(
          value: quotation,
          onChanged: (v) => setState(() => quotation = v),
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
    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

// ────────── Web-style autocomplete (overlay panel under the field)
// ────────── Web-style autocomplete (overlay panel + keyboard nav)
class _AddressAutocomplete extends StatefulWidget {
  const _AddressAutocomplete({
    required this.controller,
    required this.suggestions,
    required this.decoration,
  });

  final TextEditingController controller;
  final List<String> suggestions;
  final InputDecoration decoration;

  @override
  State<_AddressAutocomplete> createState() => _AddressAutocompleteState();
}

class _AddressAutocompleteState extends State<_AddressAutocomplete> {
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
    widget.controller.selection =
        TextSelection.collapsed(offset: value.length);
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

      const itemHeight = 38.0;
      const panelHeight = 240.0;
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
                    onEnter: (_) {
                      if (_highlighted != i) {
                        _highlighted = i;
                        _entry?.markNeedsBuild();
                      }
                    },
                    child: InkWell(
                      onTap: () => _pick(s),
                      child: Container(
                        width: double.infinity,
                        height: 38,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12),
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
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: widget.decoration,
        ),
      ),
    );
  }
}