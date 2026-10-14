import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 760,
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
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildPopupField('PICKUP', 'PITTENWEEM ROAD ST. MONANS ANSTRUTHER KY10 2AJ', maxLines: 3),
                    _buildPopupField('PICKUP NOTES', ''),
                    _buildPopupField('DROPOFF', 'CANMORE ROAD GLENROTHES KY7 4BD', maxLines: 3),
                    _buildPopupField('DROPOFF NOTES', '', maxLines: 3),
                    _buildPopupField('NAME', 'ROWDEN'),
                    _buildPopupField('EMAIL', ''),
                    _buildPopupField('MOBILE', '07485464242'),
                    _buildPopupField('TELEPHONE', ''),
                    _buildPopupField('DATE', '2026-10-12'),
                    _buildPopupField('TIME', '09:00:00'),
                    _buildPopupField('LEAD', ''),
                    _buildPopupField('JOURNEY TYPE', widget.item['jt'] ?? 'R/N'),
                    _buildPopupField('PAYMENT TYPE', 'ACCOUNT'),
                    _buildPopupField('FARES', '45'),
                    _buildPopupField('VEHICLE', 'SALOON'),
                    _buildPopupField('DRIVER', '()'),
                    _buildPopupField('PASSENGERS', ''),
                    _buildPopupField('LUGGAGES', ''),
                    _buildPopupField('HAND LUGGAGES', ''),
                    _buildPopupField('ACCOUNT', 'CAPITA BUSINESS PLS'),
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
                    CustomButton(
                      width: 80,
                      height: 28,
                      verticalPadding: 0.0,
                      btnText: "CLOSE",
                      btnColor: Colors.red,
                      borderRadius: 4,
                      style: mozillaTextSemiBoldText(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      onTap: () => Get.back(),
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

  Widget _buildPopupField(String label, String value, {int maxLines = 1}) {
    return SizedBox(
      width: 170,
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