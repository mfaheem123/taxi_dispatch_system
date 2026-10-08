import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../alert/cli_extention_alert.dart';
import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../administration/model/user_model.dart';
import '../../auth/Controller/auth_controller.dart';
import '../../setting/chat_with_driver_passenger.dart';

const Color _kIndigo = Color(0xff424899);
const Color _kInk = Color(0xFF4A4A4A);
const Color _kMintFill = Color(0xFFE8F2EF);
const Color _kMintBorder = Color(0xFFC4D9D4);

/// The phone version of the shell's bottom status bar ([MainBottomBar]).
///
/// On a phone that bar is hidden — one row of badges does not fit — and its
/// contents live here instead, as cards: who is signed in, the live clock,
/// the extension (tap to change it) and MESSAGES, which opens the driver /
/// passenger chat full screen because the desktop side panel is 680px wide.
class MobileStatusScreen extends StatefulWidget {
  const MobileStatusScreen({super.key});

  @override
  State<MobileStatusScreen> createState() => _MobileStatusScreenState();
}

class _MobileStatusScreenState extends State<MobileStatusScreen> {
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  void _openMessages() {
    Get.to(() => Scaffold(
          appBar: AppBar(
            backgroundColor: DynamicColors.primaryClr,
            foregroundColor: Colors.white,
            title: Text('MESSAGES',
                style: mozillaTextRegularText(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          body: const ChatWithDriverAndPassenger(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: DynamicColors.primaryClr,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('MY STATUS',
            style: mozillaTextRegularText(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
      body: GetBuilder<AuthController>(
        builder: (_) {
          final username =
              Employee.selectedEmployee?.username?.toUpperCase() ?? 'GUEST';
          final extension = Employee.selectedEmployee?.extensionNumber;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---- Operator ----
              _Card(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: _kIndigo,
                      child: Text(
                        username.isNotEmpty ? username[0] : '?',
                        style: mozillaTextRegularText(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SIGNED IN AS',
                              style: mozillaTextRegularText(
                                  color: Colors.grey, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: mozillaTextRegularText(
                                color: _kInk,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _kMintFill,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _kMintBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                              radius: 4, backgroundColor: Color(0xFF16A34A)),
                          const SizedBox(width: 6),
                          Text('ONLINE',
                              style: mozillaTextRegularText(
                                  color: _kInk,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ---- Clock ----
              _Card(
                child: Column(
                  children: [
                    Text(
                      DateFormat('hh:mm:ss a').format(now),
                      style: mozillaTextRegularText(
                          color: _kIndigo,
                          fontSize: 34,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('EEEE, MMM dd yyyy')
                          .format(now)
                          .toUpperCase(),
                      style: mozillaTextRegularText(
                          color: _kInk,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ---- Extension + messages ----
              Row(
                children: [
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.headset_mic_outlined,
                      label: 'EXTENSION',
                      value: '# ${extension ?? '---'}',
                      onTap: ExtensionAlert.show,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.message,
                      label: 'MESSAGES',
                      value: 'OPEN CHAT',
                      onTap: _openMessages,
                      filled: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: Text('NEXUS © 2026',
                    style: mozillaTextRegularText(
                        color: Colors.grey, fontSize: 12)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3E6F0)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : _kIndigo;
    return Material(
      color: filled ? _kIndigo : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: filled ? _kIndigo : const Color(0xFFE3E6F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: fg, size: 26),
              const SizedBox(height: 12),
              Text(label,
                  style: mozillaTextRegularText(
                      color: filled ? Colors.white70 : Colors.grey,
                      fontSize: 11)),
              const SizedBox(height: 4),
              Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mozillaTextRegularText(
                      color: fg, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
