import 'package:dashboard_new1/alert/restrict_drivers_alert.dart';
import 'package:flutter/material.dart';

import '../component/alert_close_button.dart';
import '../component/escape_dismissible.dart';
import '../component/textStyle.dart';
import 'driver_attributes_alert.dart';
import 'extra_fares_alert.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return EscapeDismissible(
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 850,
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 1. Header
              Row(
                children: [
                  const Icon(Icons.tune, color: Color(0xFF15803D), size: 20),
                  const SizedBox(width: 8),
                  Text("SETTINGS", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w700, fontSize: 14)),
                  const Spacer(),
                  const AlertCloseButton(),
                ],
              ),
              const Divider(height: 20),

              // 2. Main Area (Left Panel + Right Screen View)
              Expanded(
                child: Row(
                  children: [
                    // Left Panel
                    Container(
                      width: 170,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          _navBtn(0, Icons.attach_money, "EXTRA FARES"),
                          const SizedBox(height: 6),
                          _navBtn(1, Icons.block, "RESTRICTIONS"),
                          const SizedBox(height: 6),
                          _navBtn(2, Icons.manage_accounts, "ATTRIBUTES"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Right Side Dynamic Screen Call
                    Expanded(
                      child: IndexedStack(
                        index: selectedIndex,
                        children: [
                          const ExtraFaresAlert(),          // Screen 1 Call
                          RestrictDriversAlert(),      // Screen 2 Call
                          const DriverAttributesAlert(),     // Screen 3 Call
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Left Panel Navigation Item
  Widget _navBtn(int index, IconData icon, String title) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => selectedIndex = index),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FDF4) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: const Color(0xFFBBF7D0)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? const Color(0xFF15803D) : const Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF15803D) : const Color(0xFF475569))),
          ],
        ),
      ),
    );
  }
}