import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../component/color.dart';
import '../component/dropdown_button.dart';
import 'controller/cli_controller.dart';
import 'dashboard_view/Controller/dashboard_controller.dart';
import 'dashboard_view/models/dashboard_model.dart';
import 'dashboard_view/models/dashboard_table_model.dart';

Future<void> showCliNewDesigningAlert(String extensionNumber) async {
  await Get.dialog(
    CliNewDesigning(extensionNumber: extensionNumber),
    barrierColor: Colors.black54,
  );
}

class CliNewDesigning extends StatefulWidget {
  const CliNewDesigning({super.key, required this.extensionNumber});

  final String extensionNumber;

  @override
  State<CliNewDesigning> createState() => _CliNewDesigningState();
}

class _CliNewDesigningState extends State<CliNewDesigning> {
  CliController controller = Get.isRegistered<CliController>()
      ? Get.find<CliController>()
      : Get.put(CliController());

  static const Color border = Color(0xFFE1E7F0);
  static const Color fieldFill = Color(0xFFF2F5F9);
  static const Color subtle = Color(0xFF6B7C8F);

  bool isFullScreen = false;

  DateTime _now = DateTime.now();
  Timer? _clock;

  final List<String> tabs = [
    'CURRENT BOOKING',
    'PAST BOOKING',
    'QUOTED BOOKING'
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

    _clock = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboard = Get.find<DashboardController>();
      dashboard.selectDriverValue = null;
      final cliController = Get.find<CliController>();
      cliController.startCall(widget.extensionNumber);
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    controller.disconnectSocket();
    super.dispose();
  }

  void _showAddressMenu(
      Offset globalPosition, BookingObjectData b, bool isDropoffCell) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
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
            Text('SET AS PICKUP'),
          ]),
        ),
        PopupMenuItem<String>(
          value: 'dropoff',
          child: Row(children: [
            Icon(Icons.location_on, color: Color(0xFFDC2626), size: 18),
            SizedBox(width: 8),
            Text('SET AS DROPOFF'),
          ]),
        ),
      ],
    ).then((value) {
      if (value == null || !mounted) return;
      controller.setAddressFromBooking(b,
          fromDropoff: isDropoffCell, asPickup: value == 'pickup');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.all(isFullScreen ? 0 : 24),
      child: Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          const SingleActivator(LogicalKeyboardKey.arrowDown): const DirectionalFocusIntent(TraversalDirection.down),
          const SingleActivator(LogicalKeyboardKey.arrowUp): const DirectionalFocusIntent(TraversalDirection.up),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            DirectionalFocusIntent: DirectionalFocusAction(),
          },
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
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 12),
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
          Obx(() {
            final name = controller.customerName.value.isEmpty
                ? 'UNKNOWN'
                : controller.customerName.value.toUpperCase();
            final mobile = controller.customerMobile.value.isEmpty
                ? controller.extensionNumber
                : controller.customerMobile.value;

            return Text(
              '$name | $mobile',
              style: outFitRegular(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            );
          }),
          const Spacer(),
          const Icon(Icons.phone_in_talk, color: Color(0xFF4ADE80), size: 22),
          const SizedBox(width: 8),
          Text(
            'INCOMING / ACTIVE CALL',
            style: outFitRegular(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
              style: outFitRegular(
                color: const Color(0xFF166534),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(width: 1, height: 32, color: Colors.white38),
          const SizedBox(width: 16),
          _HeaderButton(
            icon: isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
            tooltip: isFullScreen ? 'Exit full screen' : 'Full screen',
            onTap: () => setState(() => isFullScreen = !isFullScreen),
          ),
          const SizedBox(width: 8),
          _HeaderButton(
            icon: Icons.phone_disabled,
            tooltip: 'End call',
            onTap: () {},
            iconColor: const Color(0xFFDC2626),
          ),
          const SizedBox(width: 8),
          _HeaderButton(
            icon: Icons.close,
            tooltip: 'Close',
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _headerIconButton(IconData icon, String tooltip, VoidCallback onTap,
      {Color iconColor = const Color(0xFF1E293B)}) {
    // Legacy method, now replaced by _HeaderButton widget in _buildHeader
    return _HeaderButton(icon: icon, tooltip: tooltip, onTap: onTap, iconColor: iconColor);
  }

  // ───────────────────── Pickup / Dropoff ─────────────────────

  Widget _buildLocationRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _labeled(
            'PICKUP LOCATION',
            _textField(
                controller.pickupController, 'ENTER PICKUP LOCATION', Icons.my_location),
          ),
        ),
        // const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Tooltip(
            message: 'SWAP LOCATIONS',
            child: _InteractiveGlow(
              shape: BoxShape.circle,
              child: InkWell(
                onTap: controller.swapLocations,
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
        ),
        Expanded(
          child: _labeled(
            'DROPOFF LOCATION',
            _textField(controller.dropoffController, 'ENTER DROPOFF LOCATION',
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
        final canSubmit = controller.canSubmit;

        return LayoutBuilder(
          builder: (context, constraints) {
            final parentWidth = constraints.maxWidth;
            final dynamicFieldWidth = (parentWidth * 0.28).clamp(220.0, 500.0);
            return Row(
                children: [
                  SizedBox(
                    width: dynamicFieldWidth,
                    child: _labeled(
                      'SELECT DRIVER',
                      _dropdown<DashboardDriverObject>(
                        value: home.selectDriverValue,
                        hint: 'CHOOSE DRIVER',
                        items: home.dashboardAllData?.drivers ?? const [],
                        label: (d) => '${d.username ?? ''} ${d.name ?? ''}'.trim().toUpperCase(),
                        onChanged: controller.selectDriver,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: dynamicFieldWidth,
                    child: _labeled(
                      'SELECT VEHICLE',
                      _dropdown<DashboardVehicleTypeObject>(
                        value: home.selectVehicleValue,
                        hint: 'CHOOSE VEHICLE',
                        items: home.dashboardAllData?.vehicleTypes ?? const [],
                        label: (v) => v.name ?? '',
                        onChanged: controller.selectVehicle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 15),
                        _InteractiveGlow(
                          borderRadius: 8,
                          child: SizedBox(
                            height: 42,
                            child: OutlinedButton.icon(
                              onPressed: controller.newBooking,
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('NEW BOOKING'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: DynamicColors.primaryClr,
                                side: BorderSide(color: DynamicColors.primaryClr),
                                padding: const EdgeInsets.symmetric(horizontal: 35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15),
                      Tooltip(
                        message: canSubmit
                            ? 'DISPATCH THE SELECTED BOOKING NOW'
                            : controller.isSwapped
                            ? 'SWAPPED BOOKINGS GO THROUGH NEW BOOKING'
                            : 'TICK A BOOKING FIRST',
                        child: _InteractiveGlow(
                          borderRadius: 8,
                          child: SizedBox(
                            height: 42,
                            child: ElevatedButton.icon(
                              onPressed: canSubmit ? controller.submitSelectedBooking : null,
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('SUBMIT'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DynamicColors.primaryClr,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]);
          },
        );
      },
    );
  }

  // ───────────────────────── Tabs ─────────────────────────

  Widget _buildTabs() {
    return GetBuilder<CliController>(
        builder: (cli) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: fieldFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = cli.selectedTab == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == tabs.length - 1 ? 0 : 6),
              child: _InteractiveGlow(
                borderRadius: 8,
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
                      (tabs[i]).toUpperCase(),
                      style: outFitRegular(
                        color:
                        isSelected ? Colors.white : const Color(0xFF334155),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  });
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
                      style: outFitRegular(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: border),
            Expanded(
              child: GetBuilder<CliController>(
                builder: (cli) {
                  return Obx(() {
                    if (cli.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final rows = cli.bookingsForTab(cli.selectedTab);
                    if (rows.isEmpty) return _emptyTable();
                    return FocusTraversalGroup(
                      child: ListView.separated(
                        itemCount: rows.length,
                        separatorBuilder: (_, __) =>
                        const Divider(height: 1, thickness: 1, color: border),
                        itemBuilder: (context, index) =>
                            _BookingRow(
                              booking: rows[index],
                              index: index,
                              isChecked: controller.selectedBookingId == rows[index].id,
                              onTap: () => controller.toggleBooking(rows[index]),
                              columnFlex: columnFlex,
                              statusText: controller.bookingStatusText(rows[index]),
                              statusColor: _statusColor(controller.bookingStatusText(rows[index])),
                              showAddressMenu: _showAddressMenu,
                            ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 40, color: subtle),
          const SizedBox(height: 8),
          Text(
            'NO BOOKINGS FOUND',
            style: outFitRegular(color: subtle, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Footer ─────────────────────────

  Widget _buildFooter() {
    return Obx(() {
      final current = controller.currentStats.value;
      final completed = controller.completedStats.value;
      final cancelled = controller.cancelledStats.value;
      final quoted = controller.quotedStats.value;
      final total = controller.totalStats.value != 0
          ? controller.totalStats.value
          : (current + completed + cancelled + quoted);

      return Container(
        color: const Color(0xFFF8FAFC),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOTAL BOOKINGS: $total',
              style: outFitRegular(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
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
    });
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
              style: outFitRegular(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: outFitRegular(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
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
          style: outFitRegular(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
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
      hintStyle: outFitRegular(color: subtle, fontSize: 14),
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
        borderSide: BorderSide(color: DynamicColors.primaryClr, width: 2),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller, String hint, IconData icon) {
    return _InteractiveGlow(
      borderRadius: 8,
      child: TextField(
        readOnly: true,
        controller: controller,
        style: outFitRegular(fontSize: 14),
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
    double? width,
    double height = 48,
  }) {
    return CustomDropdownField<T>(
      height: height,
      width: width,
      label: hint,
      items: items,
      value: value,
      itemLabel: label,
      onChanged: onChanged,
    );
  }
}

// ───────────────────── Support Widgets ─────────────────────

class _InteractiveGlow extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final BoxShape shape;
  final List<BoxShadow>? extraShadows;
  final Color? glowColor;

  const _InteractiveGlow({
    required this.child,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
    this.extraShadows,
    this.glowColor,
  });

  @override
  State<_InteractiveGlow> createState() => _InteractiveGlowState();
}

class _InteractiveGlowState extends State<_InteractiveGlow> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => _isFocused = v),
      canRequestFocus: false, // Child (InkWell/Button/TextField) handles focus
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: widget.shape == BoxShape.circle
              ? null
              : BorderRadius.circular(widget.borderRadius),
          shape: widget.shape,
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: (widget.glowColor ?? DynamicColors.primaryClr).withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                  if (widget.extraShadows != null) ...widget.extraShadows!,
                ]
              : widget.extraShadows,
        ),
        child: widget.child,
      ),
    );
  }
}

class _HeaderButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color iconColor;

  const _HeaderButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.iconColor = const Color(0xFF1E293B),
  });

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            if (_isFocused)
              const BoxShadow(
                color: Colors.white70,
                blurRadius: 10,
                spreadRadius: 3,
              ),
            const BoxShadow(blurRadius: 4, color: Color(0x1A000000)),
          ],
        ),
        child: InkWell(
          onTap: widget.onTap,
          onFocusChange: (v) => setState(() => _isFocused = v),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _isFocused ? DynamicColors.primaryClr : const Color(0xFFE1E7F0),
                width: _isFocused ? 2 : 1,
              ),
            ),
            child: Icon(widget.icon, size: 18, color: widget.iconColor),
          ),
        ),
      ),
    );
  }
}

class _BookingRow extends StatefulWidget {
  final BookingObjectData booking;
  final int index;
  final bool isChecked;
  final VoidCallback onTap;
  final List<int> columnFlex;
  final String statusText;
  final Color statusColor;
  final Function(Offset, BookingObjectData, bool) showAddressMenu;

  const _BookingRow({
    required this.booking,
    required this.index,
    required this.isChecked,
    required this.onTap,
    required this.columnFlex,
    required this.statusText,
    required this.statusColor,
    required this.showAddressMenu,
  });

  @override
  State<_BookingRow> createState() => _BookingRowState();
}

class _BookingRowState extends State<_BookingRow> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final date = b.pickupDate != null
        ? DateFormat('dd-MM-yyyy').format(b.pickupDate!)
        : '';
    final dateTime = '$date ${b.pickupTime ?? ''}'.trim();
    final hasVia = b.viapoints != null && b.viapoints!.isNotEmpty;

    Widget cell(String text, {FontWeight weight = FontWeight.w400, Color? color}) =>
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

    Widget addressCell(String text, bool isDropoff) => Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (e) {
        if (e.kind == PointerDeviceKind.mouse &&
            e.buttons == kSecondaryMouseButton) {
          widget.showAddressMenu(e.position, b, isDropoff);
        }
      },
      child: Tooltip(
        message: text,
        waitDuration: const Duration(milliseconds: 500),
        child: Text(
          text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
      ),
    );

    final cells = <Widget>[
      cell(dateTime),
      addressCell((b.pickup ?? '').toUpperCase(), false),
      Row(children: [
        if (hasVia) ...[
          Tooltip(
            message: b.viapoints != null ? b.viapoints!.where((v) => (v.viapoint ?? '').isNotEmpty).toList().asMap().entries
                .map((e) => '${e.key + 1}. ${(e.value.viapoint ?? '').toUpperCase()}').join('\n')
                : '',
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: const Text('VIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
            ),
          ),
        ],
        Expanded(child: addressCell((b.dropoff ?? '').toUpperCase(), true)),
      ]),
      cell((b.vehicleType?.name ?? '').toUpperCase()),
      cell('£ ${b.fares ?? 0}', weight: FontWeight.w600),
      cell((b.account?.name ?? '').toUpperCase()),
      cell((b.driver?.username ?? '').toUpperCase()),
      cell((b.paymentType?.name ?? '').toUpperCase()),
      cell(widget.statusText, weight: FontWeight.w600, color: widget.statusColor),
    ];

    return Material(
      color: widget.isChecked
          ? const Color(0xFFEFF4FF)
          : widget.index.isEven
          ? Colors.white
          : const Color(0xFFF8FAFC),
      child: InkWell(
        onTap: widget.onTap,
        onFocusChange: (v) => setState(() => _isFocused = v),
        hoverColor: const Color(0xFFEFF4FF),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: _isFocused ? Border.all(color: DynamicColors.primaryClr, width: 2) : null,
            boxShadow: _isFocused ? [
              BoxShadow(
                color: DynamicColors.primaryClr.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ] : null,
          ),
          child: Row(
            children: [
              ...List.generate(cells.length, (i) => Expanded(
                flex: widget.columnFlex[i],
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: cells[i],
                ),
              )),
              Expanded(
                flex: widget.columnFlex.last,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ExcludeFocus(
                    child: Checkbox(
                      value: widget.isChecked,
                      activeColor: DynamicColors.primaryClr,
                      side: const BorderSide(color: Color(0xFF6B7C8F), width: 1.5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (_) => widget.onTap(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}