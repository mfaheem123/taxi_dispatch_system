import 'package:dashboard_new1/alert/restrict_drivers_alert.dart';
import 'package:flutter/material.dart';

import '../component/alert_close_button.dart';
import '../component/color.dart';
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
          // padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 1. Header
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child:  Row(
                children: [
                  const Icon(Icons.tune, color: Color(0xFF15803D), size: 20),
                  const SizedBox(width: 10),
                  Text("SETTINGS", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Spacer(),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(999),
                    child: const AlertCloseButton(),
                  ),
                ],
              )),
              const Divider(height: 1, thickness: 1),
              // SizedBox(height: 30),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                          _navBtn(1, Icons.person_off_sharp, "RESTRICTIONS"),
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
                          const ExtraFaresAlert(),
                          RestrictDriversAlert(),
                          const DriverAttributesAlert(),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
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
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: Colors.grey.shade300) : null,
          boxShadow: isSelected
              ? [ BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.black87 : Colors.black54),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : Colors.black87,)),
          ],
        ),
      ),
    );
  }
}