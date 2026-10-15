import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/textStyle.dart';

class MultiReservationAlert extends StatefulWidget {
  final Map<String, String> item;

  const MultiReservationAlert({
    super.key,
    required this.item,
  });

  @override
  State<MultiReservationAlert> createState() => _MultiReservationAlertState();
}

class _MultiReservationAlertState extends State<MultiReservationAlert> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Match the image: a wide dialog on desktop, shrinking to fit smaller
    // screens instead of overflowing.
    final double dialogWidth =
        screenWidth < 1080 ? screenWidth - 40 : 1040;

    const double hPad = 16;
    const double spacing = 12;
    // 4 columns like the image on desktop, dropping to 2 / 1 when narrow.
    final int columns = dialogWidth > 820 ? 4 : (dialogWidth > 520 ? 2 : 1);
    final double contentWidth = dialogWidth - hPad * 2;
    final double fieldWidth =
        (contentWidth - spacing * (columns - 1)) / columns;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ────────── Header Title & Close Icon ──────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Text(
                      'REFERENCE #: ',
                      style: outFitRegular(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      widget.item['ref'] ?? '',
                      style: outFitRegular(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(THIS INFORMATION IS FOR VIEW ONLY)',
                      style: outFitRegular(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Spacer(),
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(999),
                      child: const AlertCloseButton(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ────────── Form Fields Grid (Using TextField for native Web resize handle) ──────────
              Padding(
                padding: const EdgeInsets.all(hPad),
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    _buildPopupField('PICKUP', 'PITTENWEEM ROAD ST. MONANS ANSTRUTHER KY10 2AJ', fieldWidth, maxLines: 3),
                    _buildPopupField('PICKUP NOTES', '', fieldWidth),
                    _buildPopupField('DROPOFF', 'CANMORE ROAD GLENROTHES KY7 4BD', fieldWidth, maxLines: 3),
                    _buildPopupField('DROPOFF NOTES', '', fieldWidth, maxLines: 3),
                    _buildPopupField('NAME', 'ROWDEN', fieldWidth),
                    _buildPopupField('EMAIL', '', fieldWidth),
                    _buildPopupField('MOBILE', '07485464242', fieldWidth),
                    _buildPopupField('TELEPHONE', '', fieldWidth),
                    _buildPopupField('DATE', '2026-10-12', fieldWidth),
                    _buildPopupField('TIME', '09:00:00', fieldWidth),
                    _buildPopupField('LEAD', '', fieldWidth),
                    _buildPopupField('JOURNEY TYPE', widget.item['jt'] ?? 'R/N', fieldWidth),
                    _buildPopupField('PAYMENT TYPE', 'ACCOUNT', fieldWidth),
                    _buildPopupField('FARES', '45', fieldWidth),
                    _buildPopupField('VEHICLE', 'SALOON', fieldWidth),
                    _buildPopupField('DRIVER', '()', fieldWidth),
                    _buildPopupField('PASSENGERS', '', fieldWidth),
                    _buildPopupField('LUGGAGES', '', fieldWidth),
                    _buildPopupField('HAND LUGGAGES', '', fieldWidth),
                    _buildPopupField('ACCOUNT', 'CAPITA BUSINESS PLS', fieldWidth),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ────────── Bottom Close Button ──────────
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Light, outlined button like the image (not the red one).
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          "CLOSE",
                          style: mozillaTextSemiBoldText(
                            fontSize: 13,
                            color: const Color(0xFF334155),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildPopupField(String label, String value, double width,
      {int maxLines = 1}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: outFitRegular(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: TextEditingController(text: value),
            maxLines: maxLines,
            readOnly: true,
            style: outFitRegular(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}