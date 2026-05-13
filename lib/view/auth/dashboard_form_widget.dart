import 'package:flutter/material.dart';



class BookingForm extends StatefulWidget {
  const BookingForm({super.key});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  String? pickupZone, dropZone, journeyType = 'One Way', account = 'DEMO';
  String? payBy = 'Cash', vehicleType = 'Saloon', department;
  bool quotation = true;

  static const _purple = Color(0xFF4F46E5);
  static const _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final isMobile = w < 640;
        final isTablet = w >= 640 && w < 1024;
        final cols = isMobile ? 1 : (isTablet ? 2 : 4);

        return FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _locationRow('PICKUP', Colors.green, pickupZone,
                        (v) => setState(() => pickupZone = v), isMobile, 0),
                const SizedBox(height: 10),
                _locationRow('DROP', Colors.red, dropZone,
                        (v) => setState(() => dropZone = v), isMobile, 10),
                const Divider(height: 32),
                _sectionHeader(Icons.person, 'PASSENGER & BOOKING DETAILS'),
                const SizedBox(height: 12),
                _grid(cols, [
                  _field('Name', tab: 21, controller: TextEditingController(text: 'Test Passenger')),
                  _field('Email', tab: 22, controller: TextEditingController(text: 't12410@gmail.com')),
                  _field('Mobile', tab: 23, controller: TextEditingController(text: '0123213133213')),
                  _field('Tel.', tab: 24, controller: TextEditingController(text: '232132131')),
                ]),
                const SizedBox(height: 12),
                _grid(cols, [
                  _field('Date', tab: 25, prefix: Icons.calendar_today, controller: TextEditingController(text: '25 / 04 / 2026')),
                  _field('Time', tab: 26, prefix: Icons.access_time, controller: TextEditingController(text: '01:42')),
                  _dropdown('Journey Type', journeyType, ['One Way', 'Return', 'Hourly'],
                          (v) => setState(() => journeyType = v), 27),
                  _field('Lead Time', tab: 28, controller: TextEditingController(text: 'MINS')),
                ]),
                const SizedBox(height: 12),
                _grid(isMobile ? 1 : 3, [
                  _field('No. of Passengers', tab: 29, prefix: Icons.person_outline, controller: TextEditingController(text: '1')),
                  _field('Fare', tab: 30, prefix: Icons.currency_pound, controller: TextEditingController(text: '226.00')),
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _locationRow(String label, Color dot, String? zone,
      ValueChanged<String?> onZone, bool isMobile, int tabBase) {
    final tag = Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.circle, size: 10, color: dot),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
    ]);

    final address = FocusTraversalOrder(
      order: NumericFocusOrder((tabBase + 1).toDouble()),
      child: TextField(
        decoration: _inputDecoration().copyWith(
          suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: const [
            Icon(Icons.close, size: 18, color: Colors.grey),
            SizedBox(width: 8),
            Icon(Icons.my_location, size: 18, color: Colors.grey),
            SizedBox(width: 8),
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
        items: ['Zone A', 'Zone B'].map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
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

  Widget _sectionHeader(IconData icon, String title) => Row(children: [
    Icon(icon, size: 18, color: _purple),
    const SizedBox(width: 6),
    Text(title, style: const TextStyle(color: _purple, fontWeight: FontWeight.w700, fontSize: 13)),
  ]);

  Widget _grid(int cols, List<Widget> children) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final slice = children.sublist(i, (i + cols).clamp(0, children.length));
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            for (var j = 0; j < slice.length; j++) ...[
              Expanded(child: slice[j]),
              if (j < slice.length - 1) const SizedBox(width: 12),
            ],
            for (var k = slice.length; k < cols; k++) ...[
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ],
          ],
        ),
      ));
    }
    return Column(children: rows);
  }

  Widget _field(String label, {required int tab, IconData? prefix, TextEditingController? controller}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 4),
      FocusTraversalOrder(
        order: NumericFocusOrder(tab.toDouble()),
        child: TextField(
          controller: controller,
          decoration: _inputDecoration().copyWith(
            prefixIcon: prefix != null ? Icon(prefix, size: 18, color: Colors.grey) : null,
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
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    ]);
  }

  Widget _quotationToggle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 18),
      Row(children: [
        Switch(value: quotation, onChanged: (v) => setState(() => quotation = v), activeColor: _purple),
        const SizedBox(width: 4),
        const Text('Quotation', style: TextStyle(fontWeight: FontWeight.w500)),
      ]),
    ]);
  }

  InputDecoration _inputDecoration() => InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: _border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: _border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: _purple)),
  );
}