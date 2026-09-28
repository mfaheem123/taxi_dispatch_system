import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../component/color.dart';

void showCliNewDesigningAlert() {
  Get.dialog(
    const CliNewDesigning(),
    barrierColor: Colors.black54,
  );
}

class CliNewDesigning extends StatefulWidget {
  const CliNewDesigning({super.key});

  @override
  State<CliNewDesigning> createState() => _CliNewDesigningState();
}

class _CliNewDesigningState extends State<CliNewDesigning> {
  static const Color border = Color(0xFFE1E7F0);
  static const Color fieldFill = Color(0xFFF2F5F9);
  static const Color subtle = Color(0xFF6B7C8F);

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();

  String? selectedDriver;
  String? selectedVehicle;
  int selectedTab = 0;
  bool isFullScreen = false;

  // Checked table rows, keyed as "tabIndex-rowIndex"
  final Set<String> checkedRows = {};

  // Placeholder data for design only
  final List<String> drivers = ['Driver 1', 'Driver 2', 'Driver 3'];
  final List<String> vehicles = ['Saloon', 'Estate', 'MPV', 'Executive'];
  final List<String> tabs = [
    'Current Booking',
    'Past Booking',
    'Quoted Booking'
  ];
  final List<String> columns = [
    'DATETIME',
    'PICKUP',
    'DROPOFF',
    'VEHICLE',
    'FARES',
    'ACCOUNT',
    'DRV',
    'P/T',
    'STATUS',
    'ACTIONS',
  ];
  final List<int> columnFlex = [3, 4, 4, 2, 2, 2, 1, 2, 2, 2];

  // Dummy bookings per tab (index matches `tabs`)
  final List<List<Map<String, String>>> bookings = [
    [
      {
        'dateTime': '18-09-2026 17:31',
        'pickup': 'Flat 19, Bentley Court',
        'dropoff': 'Bentley Road, Slough',
        'vehicle': 'SALOON',
        'fare': '£ 34.20',
        'account': '',
        'drv': '',
        'pt': 'CASH',
        'status': 'WAITING'
      },
      {
        'dateTime': '18-09-2026 17:45',
        'pickup': 'Flat 14, Aclane House',
        'dropoff': 'Aclane Street, Slough',
        'vehicle': 'SALOON',
        'fare': '£ 19.20',
        'account': '',
        'drv': '',
        'pt': 'CASH',
        'status': 'WAITING'
      },
      {
        'dateTime': '18-09-2026 18:10',
        'pickup': 'Aclane Street, Slough',
        'dropoff': 'Flat 14, Aclane House',
        'vehicle': 'SALOON',
        'fare': '£ 19.20',
        'account': '',
        'drv': '',
        'pt': 'CASH',
        'status': 'WAITING'
      },
      {
        'dateTime': '18-09-2026 18:30',
        'pickup': 'Bentley Road, Slough',
        'dropoff': 'Flat 19, Bentley Court',
        'vehicle': 'SALOON',
        'fare': '£ 34.20',
        'account': '',
        'drv': '',
        'pt': 'CASH',
        'status': 'WAITING'
      },
    ],
    [
      {
        'dateTime': '17-09-2026 09:15',
        'pickup': 'Heathrow Airport T5',
        'dropoff': 'Flat 19, Bentley Court',
        'vehicle': 'EXECUTIVE',
        'fare': '£ 45.00',
        'account': 'ACC01',
        'drv': 'D07',
        'pt': 'ACCOUNT',
        'status': 'COMPLETED'
      },
      {
        'dateTime': '16-09-2026 18:40',
        'pickup': 'Slough Station',
        'dropoff': 'Aclane Street, Slough',
        'vehicle': 'SALOON',
        'fare': '£ 12.50',
        'account': '',
        'drv': 'D15',
        'pt': 'CASH',
        'status': 'COMPLETED'
      },
      {
        'dateTime': '15-09-2026 07:05',
        'pickup': 'Flat 14, Aclane House',
        'dropoff': 'Windsor Castle',
        'vehicle': 'ESTATE',
        'fare': '£ 22.00',
        'account': '',
        'drv': 'D03',
        'pt': 'CARD',
        'status': 'CANCELLED'
      },
      {
        'dateTime': '14-09-2026 21:30',
        'pickup': 'The Curve, Slough',
        'dropoff': 'Bentley Road, Slough',
        'vehicle': 'MPV',
        'fare': '£ 16.60',
        'account': '',
        'drv': 'D12',
        'pt': 'CASH',
        'status': 'COMPLETED'
      },
    ],
    [],
  ];

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    super.dispose();
  }

  void swapLocations() {
    final temp = pickupController.text;
    pickupController.text = dropoffController.text;
    dropoffController.text = temp;
  }

  void resetForm() {
    pickupController.clear();
    dropoffController.clear();
    setState(() {
      selectedDriver = null;
      selectedVehicle = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.all(isFullScreen ? 0 : 24),
      child: SizedBox(
        width: isFullScreen ? size.width : min(size.width, 1200),
        height: isFullScreen ? size.height : size.height * 0.9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isFullScreen ? 0 : 12),
            border: Border.all(color: border),
            boxShadow: const [
              BoxShadow(blurRadius: 20, color: Color(0x14000000)),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _buildHeader(),
              const Divider(height: 1, thickness: 1, color: border),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  children: [
                    _buildLocationRow(),
                    const SizedBox(height: 20),
                    _buildDriverVehicleRow(),
                    const SizedBox(height: 20),
                    _buildTabs(),
                  ],
                ),
              ),
              Expanded(child: _buildTable()),
              const Divider(height: 1, thickness: 1, color: border),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Header ─────────────────────────

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff424899), Color(0xff424899), Color(0xFF406ad8)],
        ),
      ),
      child: Row(
        children: [
          Image.asset('assets/cabflow_logo.png', height: 36),
          const SizedBox(width: 16),
          Container(width: 1, height: 32, color: Colors.white38),
          const SizedBox(width: 16),
          const Text(
            'NADEM | 07590455507',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(),
          const Icon(Icons.phone_in_talk, color: Color(0xFF4ADE80), size: 22),
          const SizedBox(width: 8),
          const Text(
            'INCOMING / ACTIVE CALL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
              style: const TextStyle(
                color: Color(0xFF166534),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(width: 1, height: 32, color: Colors.white38),
          const SizedBox(width: 16),
          _headerIconButton(
            isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
            isFullScreen ? 'Exit full screen' : 'Full screen',
                () => setState(() => isFullScreen = !isFullScreen),
          ),
          const SizedBox(width: 8),
          _headerIconButton(
            Icons.phone_disabled,
            'End call',
                () {},
            iconColor: const Color(0xFFDC2626),
          ),
          const SizedBox(width: 8),
          _headerIconButton(Icons.close, 'Close', () => Get.back()),
        ],
      ),
    );
  }

  Widget _headerIconButton(IconData icon, String tooltip, VoidCallback onTap,
      {Color iconColor = const Color(0xFF1E293B)}) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: border),
            boxShadow: const [
              BoxShadow(blurRadius: 4, color: Color(0x1A000000)),
            ],
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
      ),
    );
  }

  // ───────────────────── Pickup / Dropoff ─────────────────────

  Widget _buildLocationRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _labeled(
            'Pickup Location',
            _textField(
                pickupController, 'Enter pickup location', Icons.my_location),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Tooltip(
            message: 'Swap locations',
            child: InkWell(
              onTap: swapLocations,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: border),
                ),
                child: Icon(Icons.swap_horiz, color: DynamicColors.primaryClr),
              ),
            ),
          ),
        ),
        Expanded(
          child: _labeled(
            'Drop Off Location',
            _textField(dropoffController, 'Enter drop off location',
                Icons.location_on_outlined),
          ),
        ),
      ],
    );
  }

  // ─────────────── Driver / Vehicle / Buttons ───────────────

  Widget _buildDriverVehicleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: _labeled(
            'Select Driver',
            _dropdown(
              value: selectedDriver,
              hint: 'Choose driver',
              items: drivers,
              onChanged: (v) => setState(() => selectedDriver = v),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _labeled(
            'Select Vehicle',
            _dropdown(
              value: selectedVehicle,
              hint: 'Choose vehicle',
              items: vehicles,
              onChanged: (v) => setState(() => selectedVehicle = v),
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            onPressed: resetForm,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Booking'),
            style: OutlinedButton.styleFrom(
              foregroundColor: DynamicColors.primaryClr,
              side: BorderSide(color: DynamicColors.primaryClr),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: DynamicColors.primaryClr,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────── Tabs ─────────────────────────

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: fieldFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = selectedTab == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == tabs.length - 1 ? 0 : 6),
              child: InkWell(
                onTap: () => setState(() => selectedTab = i),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? DynamicColors.primaryClr : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: isSelected ? DynamicColors.primaryClr : border),
                  ),
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      color:
                      isSelected ? Colors.white : const Color(0xFF334155),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ───────────────────────── Table ─────────────────────────

  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              height: 44,
              color: const Color(0xFFF1F5F9),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(columns.length, (i) {
                  return Expanded(
                    flex: columnFlex[i],
                    child: Text(
                      columns[i],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Color(0xFF475569),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: border),
            Expanded(
              child: bookings[selectedTab].isEmpty
                  ? _emptyTable()
                  : ListView.separated(
                itemCount: bookings[selectedTab].length,
                separatorBuilder: (_, __) =>
                const Divider(height: 1, thickness: 1, color: border),
                itemBuilder: (context, index) =>
                    _tableRow(bookings[selectedTab][index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(Map<String, String> booking, int index) {
    final values = [
      booking['dateTime']!,
      booking['pickup']!,
      booking['dropoff']!,
      booking['vehicle']!,
      booking['fare']!,
      booking['account']!,
      booking['drv']!,
      booking['pt']!,
      booking['status']!,
    ];
    return Material(
      color: index.isEven ? Colors.white : const Color(0xFFF8FAFC),
      child: InkWell(
        onTap: () {},
        hoverColor: const Color(0xFFEFF4FF),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ...List.generate(values.length, (i) {
                final isStatus = i == 8;
                return Expanded(
                  flex: columnFlex[i],
                  child: Text(
                    values[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isStatus
                          ? _statusColor(values[i])
                          : const Color(0xFF1E293B),
                      fontWeight: i == 4 || isStatus
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                );
              }),
              Expanded(
                flex: columnFlex.last,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Checkbox(
                    value: checkedRows.contains('$selectedTab-$index'),
                    activeColor: DynamicColors.primaryClr,
                    side: const BorderSide(color: subtle, width: 1.5),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (v) => setState(() {
                      final key = '$selectedTab-$index';
                      v == true
                          ? checkedRows.add(key)
                          : checkedRows.remove(key);
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return const Color(0xFF16A34A);
      case 'CANCELLED':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFFEA580C);
    }
  }

  Widget _emptyTable() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: subtle),
          SizedBox(height: 8),
          Text(
            'No bookings found',
            style: TextStyle(color: subtle, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Footer ─────────────────────────

  Widget _buildFooter() {
    final current = bookings[0].length;
    final completed =
        bookings[1].where((b) => b['status'] == 'COMPLETED').length;
    final cancelled =
        bookings[1].where((b) => b['status'] == 'CANCELLED').length;
    final quoted = bookings[2].length;
    final total = current + completed + cancelled + quoted;

    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BOOKINGS: $total',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard('CURRENT BOOKINGS', current),
              const SizedBox(width: 12),
              _statCard('COMPLETED BOOKINGS', completed),
              const SizedBox(width: 12),
              _statCard('CANCELLED BOOKINGS', cancelled),
              const SizedBox(width: 12),
              _statCard('QUOTED BOOKINGS', quoted),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, int count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── Helpers ─────────────────────────

  Widget _labeled(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: subtle, fontSize: 14),
      prefixIcon: icon != null ? Icon(icon, size: 20, color: subtle) : null,
      filled: true,
      fillColor: fieldFill,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: DynamicColors.primaryClr, width: 1.5),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller, String hint, IconData icon) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: _inputDecoration(hint, icon: icon),
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      height: 48,
      child: DropdownButtonFormField<String>(
        // Key forces a rebuild so "New Booking" can reset the selection
        key: ValueKey(value),
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: subtle),
        decoration: _inputDecoration(hint),
        hint: Text(hint, style: const TextStyle(color: subtle, fontSize: 14)),
        style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
