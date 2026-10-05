import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../component/color.dart';
// import 'controller/cli_controller.dart';
import 'controller/new_controller.dart';
import 'dashboard_view/Controller/dashboard_controller.dart';
import 'dashboard_view/models/dashboard_model.dart';
import 'dashboard_view/models/dashboard_table_model.dart';

/// Opens the CLI (incoming call) screen for [extensionNumber] — the caller's
/// phone number from the CLI_OPEN socket event. Completes when it closes.
Future<void> showCliNewDesigningAlert(String extensionNumber) async {
  await Get.dialog(
    CliNewDesigning(extensionNumber: extensionNumber),
    barrierColor: Colors.black54,
  );
}

class CliNewDesigning extends StatefulWidget {
  const CliNewDesigning({super.key, required this.extensionNumber});

  /// The caller's phone number; the customer and their bookings are looked
  /// up by it.
  final String extensionNumber;

  @override
  State<CliNewDesigning> createState() => _CliNewDesigningState();
}

class _CliNewDesigningState extends State<CliNewDesigning> {
  static const Color border = Color(0xFFE1E7F0);
  static const Color fieldFill = Color(0xFFF2F5F9);
  static const Color subtle = Color(0xFF6B7C8F);

  /// Booking data, selection and the pickup / dropoff / submit / new-booking
  /// actions all live in [CliController]; this State only holds what is purely
  /// about the dialog itself (full screen, the header clock).
  final CliController cli = Get.put(CliController(), permanent: true);

  int get selectedTab => cli.selectedTab;
  bool isFullScreen = false;

  DateTime _now = DateTime.now();
  Timer? _clock;

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

  @override
  void initState() {
    super.initState();
    cli.startCall(widget.extensionNumber);
    _clock = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    cli.disconnectSocket();
    super.dispose();
  }

  /// Right-click on a pickup / dropoff cell: use that address as this call's
  /// pickup or dropoff. The menu is UI; the change itself is the controller's.
  void _showAddressMenu(
      Offset globalPosition, BookingObjectData b, bool isDropoffCell) {
    final overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
          Rect.fromPoints(globalPosition, globalPosition),
          Offset.zero & overlay.size),
      items: const [
        PopupMenuItem<String>(
          value: 'pickup',
          child: Row(children: [
            Icon(Icons.location_on, color: Color(0xFF059669), size: 18),
            SizedBox(width: 8),
            Text('Set as Pickup'),
          ]),
        ),
        PopupMenuItem<String>(
          value: 'dropoff',
          child: Row(children: [
            Icon(Icons.location_on, color: Color(0xFFDC2626), size: 18),
            SizedBox(width: 8),
            Text('Set as Dropoff'),
          ]),
        ),
      ],
    ).then((value) {
      if (value == null || !mounted) return;
      cli.setAddressFromBooking(b,
          fromDropoff: isDropoffCell, asPickup: value == 'pickup');
    });
  }

  // ───────────────────────── Build ─────────────────────────

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
          // GetBuilder: selection / tab / swap changes (cli.update()).
          // Obx: bookings / customer arrive from the API after opening.
          child: GetBuilder<CliController>(
            builder: (_) => Obx(() {
              // Read the Rx lists here so Obx rebuilds when they arrive.
              final _ = [cli.currentBookings.length, cli.pastBookings.length,
                cli.quotedBookings.length, cli.stats.value];
              return Column(
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
              );
            }),
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Header ─────────────────────────

  Widget _buildHeader() {
    final customer = cli.customerName.value.trim();
    final phone = cli.customerMobile.value.trim().isNotEmpty
        ? cli.customerMobile.value.trim()
        : cli.extensionNumber;
    final title = [
      customer.isEmpty ? 'UNKNOWN' : customer.toUpperCase(),
      if (phone.isNotEmpty) phone,
    ].join(' | ');
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
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
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
              DateFormat('dd-MM-yyyy HH:mm').format(_now),
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
            _textField(cli.pickupController, 'Enter pickup location',
                Icons.my_location),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Tooltip(
            message: 'Swap locations',
            child: InkWell(
              onTap: cli.swapLocations,
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
            _textField(cli.dropoffController, 'Enter drop off location',
                Icons.location_on_outlined),
          ),
        ),
      ],
    );
  }

  // ─────────────── Driver / Vehicle / Buttons ───────────────

  Widget _buildDriverVehicleRow() {
    return GetBuilder<DashboardController>(
      builder: (home) {
        final canSubmit = cli.canSubmit;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: _labeled(
                'Select Driver',
                _dropdown<DashboardDriverObject>(
                  value: home.selectDriverValue,
                  hint: 'Choose driver',
                  items: home.dashboardAllData?.drivers ?? const [],
                  label: (d) =>
                      '${d.username ?? ''} ${d.name ?? ''}'.trim().toUpperCase(),
                  onChanged: cli.selectDriver,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: _labeled(
                'Select Vehicle',
                _dropdown<DashboardVehicleTypeObject>(
                  value: home.selectVehicleValue,
                  hint: 'Choose vehicle',
                  items: home.dashboardAllData?.vehicleTypes ?? const [],
                  label: (v) => v.name ?? '',
                  onChanged: cli.selectVehicle,
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: cli.newBooking,
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
            Tooltip(
              message: canSubmit
                  ? 'Dispatch the selected booking now'
                  : cli.isSwapped
                  ? 'Swapped bookings go through New Booking'
                  : 'Tick a booking first',
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: canSubmit ? cli.submitSelectedBooking : null,
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
            ),
          ],
        );
      },
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
          final count = cli.bookingsForTab(i).length;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == tabs.length - 1 ? 0 : 6),
              child: InkWell(
                onTap: () => cli.selectTab(i),
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
                    '${tabs[i]} ($count)',
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
    final rows = cli.bookingsForTab(selectedTab);
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
              child: cli.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : rows.isEmpty
                  ? _emptyTable()
                  : ListView.separated(
                itemCount: rows.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1, thickness: 1, color: border),
                itemBuilder: (context, index) =>
                    _tableRow(rows[index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(BookingObjectData b, int index) {
    final date = b.pickupDate != null
        ? DateFormat('dd-MM-yyyy').format(b.pickupDate!)
        : '';
    final dateTime = '$date ${b.pickupTime ?? ''}'.trim();
    final status = cli.bookingStatusText(b);
    final isChecked =
        cli.selectedBookingId != null && cli.selectedBookingId == b.id;
    final hasVia = b.viapoints != null && b.viapoints!.isNotEmpty;

    Widget cell(String text,
        {FontWeight weight = FontWeight.w400, Color? color}) =>
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            color: color ?? const Color(0xFF1E293B),
            fontWeight: weight,
          ),
        );

    // Right-click on an address cell offers "Set as Pickup / Dropoff".
    Widget addressCell(String text, bool isDropoff) => Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (e) {
        if (e.kind == PointerDeviceKind.mouse &&
            e.buttons == kSecondaryMouseButton) {
          _showAddressMenu(e.position, b, isDropoff);
        }
      },
      child: Tooltip(
        message: text,
        waitDuration: const Duration(milliseconds: 500),
        child: cell(text),
      ),
    );

    final cells = <Widget>[
      cell(dateTime),
      addressCell(b.pickup ?? '', false),
      Row(children: [
        if (hasVia) ...[
          Tooltip(
            message: b.viapoints!.map((v) => v.toString()).join('\n'),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: const Text(
                'via',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ),
        ],
        Expanded(child: addressCell(b.dropoff ?? '', true)),
      ]),
      cell((b.vehicleType?.name ?? '').toUpperCase()),
      cell('£ ${b.fares ?? 0}', weight: FontWeight.w600),
      cell(b.account?.name ?? ''),
      cell(b.driver?.username ?? ''),
      cell((b.paymentType?.name ?? '').toUpperCase()),
      cell(status,
          weight: FontWeight.w600, color: _statusColor(status)),
    ];

    return Material(
      color: isChecked
          ? const Color(0xFFEFF4FF)
          : index.isEven
          ? Colors.white
          : const Color(0xFFF8FAFC),
      child: InkWell(
        onTap: () => cli.toggleBooking(b),
        hoverColor: const Color(0xFFEFF4FF),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ...List.generate(cells.length, (i) => Expanded(
                flex: columnFlex[i],
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: cells[i],
                ),
              )),
              Expanded(
                flex: columnFlex.last,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Checkbox(
                    value: isChecked,
                    activeColor: DynamicColors.primaryClr,
                    side: const BorderSide(color: subtle, width: 1.5),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (_) => cli.toggleBooking(b),
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
    if (status.contains('COMPLET')) return const Color(0xFF16A34A);
    if (status.contains('CANCEL')) return const Color(0xFFDC2626);
    return const Color(0xFFEA580C);
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
    // Counts come straight from the response's `stats` block.
    final stats = cli.stats.value;
    final used = cli.cliCustomerModel?.rideHistory?.used;
    final usedCancelled = cli.cliCustomerModel?.rideHistory?.cancelled;

    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'TOTAL BOOKINGS: ${stats.total}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              // Ride history from the customer lookup, when the API sends it.
              if (used != null || usedCancelled != null)
                Text(
                  'RIDE HISTORY  ·  USED ${used ?? 0}  ·  CANCELLED ${usedCancelled ?? 0}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: subtle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard('CURRENT BOOKINGS', stats.current),
              const SizedBox(width: 12),
              _statCard('COMPLETED BOOKINGS', stats.completed),
              const SizedBox(width: 12),
              _statCard('CANCELLED BOOKINGS', stats.cancelled),
              const SizedBox(width: 12),
              _statCard('QUOTED BOOKINGS', stats.quoted),
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

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required String Function(T) label,
    required ValueChanged<T?> onChanged,
  }) {
    return SizedBox(
      height: 48,
      child: DropdownButtonFormField<T>(
        // Key forces a rebuild when the value changes from outside
        key: ValueKey(value),
        initialValue: items.contains(value) ? value : null,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: subtle),
        decoration: _inputDecoration(hint),
        hint: Text(hint, style: const TextStyle(color: subtle, fontSize: 14)),
        style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
        items: items
            .map((e) => DropdownMenuItem<T>(
          value: e,
          child: Text(label(e), maxLines: 1, overflow: TextOverflow.ellipsis),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}