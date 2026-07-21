import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSystemShortcutsAlert() {
  Get.dialog(
    const BackSlashAlert(),
    barrierColor: Colors.black54,
  );
}

class BackSlashAlert extends StatelessWidget {
  const BackSlashAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Container(
        width: 550,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Header ───
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.keyboard, size: 22, color: Colors.black87),
                  const SizedBox(width: 10),
                  Text(
                    "SYSTEM SHORTCUTS",
                    style: mozillaTextSemiBoldText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 22, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // ─── Body ───
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ⚡ Quick Access Keys
                      Row(
                        children: [
                          Text("⚡ ", style: TextStyle(fontSize: 16)),
                          Text(
                            "QUICK ACCESS KEYS",
                            style: mozillaTextSemiBoldText(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: DynamicColors.primaryClr,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // ─── Shortcuts List ───
                      _buildShortcutRow("HELP MENU", ["/"]),
                      _buildShortcutRow("RELEASE NOTES", ["END"]),
                      _buildShortcutRow("BASE ADDRESS", ["F1"]),
                      _buildShortcutRow("CREATE BOOKING", ["F2"]),
                      _buildShortcutRow("SAVE QUOTATION", ["F6"]),
                      _buildShortcutRow("MULTI BOOKINGS", ["F8"]),
                      _buildShortcutRow("MULTI VEHICLES", ["F9"]),
                      _buildShortcutRow("SAVE BOOKING", ["HOME"]),
                      _buildShortcutRowCombo("CLOSE FORM", ["CTRL", "W"]),
                      _buildShortcutRowOr("DRIVER VEHICLE", ["F3"], ["ALT", "V"]),
                      _buildShortcutRowOr("DRIVER EARNING", ["F4"], ["ALT", "E"]),
                      _buildShortcutRowOr("CLEAR BOOKING", ["F7"], ["ALT", "X"]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Single key shortcut row
  Widget _buildShortcutRow(String label, List<String> keys) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                label,
                style: mozillaTextSemiBoldText(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              ...keys.map((key) => _keyBadge(key)),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  /// Combo key shortcut row (e.g. CTRL + W)
  Widget _buildShortcutRowCombo(String label, List<String> keys) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                label,
                style: mozillaTextSemiBoldText(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              _keyBadge(keys[0]),
              _plusSign(),
              _keyBadge(keys[1]),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  /// "or" shortcut row (e.g. F3 or ALT + V)
  Widget _buildShortcutRowOr(
      String label, List<String> primaryKeys, List<String> altKeys) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                label,
                style: mozillaTextSemiBoldText(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              ...primaryKeys.map((key) => _keyBadge(key)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "or",
                  style: mozillaTextRegularText(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              _keyBadge(altKeys[0]),
              _plusSign(),
              _keyBadge(altKeys[1]),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  /// Green key badge widget
  Widget _keyBadge(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: DynamicColors.greenClr,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: mozillaTextSemiBoldText(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: DynamicColors.whiteClr,
        ),
      ),
    );
  }

  /// Plus sign between keys
  Widget _plusSign() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        "+",
        style: mozillaTextSemiBoldText(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}