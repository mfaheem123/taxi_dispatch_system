import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:ui_web' as ui;

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
  late final Map<String, TextEditingController> _controllers;
  final Map<String, html.TextAreaElement> _textAreas = {};
  final Map<String, double> _fieldHeights = {};
  final Map<String, double> _fieldWidths = {};
  final Map<String, html.ResizeObserver> _resizeObservers = {};
  static const double _initialFieldHeight = 48;

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    if (kIsWeb) {
      _registerHtmlTextAreas();
    }
  }

  void _initializeControllers() {
    _controllers = {
      'PICKUP': TextEditingController(text: 'PITTENWEEM ROAD ST. MONANS ANSTRUTHER KY10 2AJ'),
      'PICKUP NOTES': TextEditingController(text: widget.item['pickup_notes'] ?? ''),
      'DROPOFF': TextEditingController(text: 'CANMORE ROAD GLENROTHES KY7 4BD'),
      'DROPOFF NOTES': TextEditingController(text: widget.item['dropoff_notes'] ?? ''),
      'NAME': TextEditingController(text: 'ROWDEN'),
      'EMAIL': TextEditingController(text: widget.item['email'] ?? ''),
      'MOBILE': TextEditingController(text: '07485464242'),
      'TELEPHONE': TextEditingController(text: widget.item['telephone'] ?? ''),
      'DATE': TextEditingController(text: '2026-10-12'),
      'TIME': TextEditingController(text: '09:00:00'),
      'LEAD': TextEditingController(text: widget.item['lead'] ?? ''),
      'JOURNEY TYPE': TextEditingController(text: widget.item['jt'] ?? 'R/N'),
      'PAYMENT TYPE': TextEditingController(text: 'ACCOUNT'),
      'FARES': TextEditingController(text: '45'),
      'VEHICLE': TextEditingController(text: 'SALOON'),
      'DRIVER': TextEditingController(text: '()'),
      'PASSENGERS': TextEditingController(text: widget.item['passengers'] ?? ''),
      'LUGGAGES': TextEditingController(text: widget.item['luggages'] ?? ''),
      'HAND LUGGAGES': TextEditingController(text: widget.item['hand_luggages'] ?? ''),
      'ACCOUNT': TextEditingController(text: 'CAPITA BUSINESS PLS'),
    };
  }

  void _registerHtmlTextAreas() {
    // bottom-right resize grip.
    final style = html.StyleElement()
      ..innerText = '''
        textarea {
          resize: vertical !important;
          overflow: hidden !important;
          overflow-y: hidden !important;
          overflow-x: hidden !important;
          scrollbar-width: none !important;
          -ms-overflow-style: none !important;
        }
        textarea::-webkit-scrollbar { display: none !important; width: 0 !important; height: 0 !important; }
      ''';
    html.document.head?.append(style);

    for (final entry in _controllers.entries) {
      final label = entry.key;
      final viewType = 'reservation-textarea-${identityHashCode(this)}-${label.hashCode}';
      _fieldHeights[label] = _initialFieldHeight;
      _fieldWidths[label] = 0;

      ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        final area = html.TextAreaElement()
          ..value = entry.value.text
          ..readOnly = true
          ..spellcheck = false
          ..style.width = '100%'
          ..style.height = '${_fieldHeights[label]}px'
          ..style.minHeight = '${_initialFieldHeight}px'
          ..style.boxSizing = 'border-box'
          ..style.resize = 'vertical'
          ..style.overflow = 'hidden'
          ..style.overflowY = 'hidden'
          ..style.overflowX = 'hidden'
          ..style.maxWidth = '100%'
          ..style.minWidth = '100%'
          ..style.setProperty('scrollbar-width', 'none')
          ..style.setProperty('-ms-overflow-style', 'none')
          ..style.padding = '8px'
          ..style.border = '1px solid #E1E7F0'
          ..style.borderRadius = '5px'
          ..style.backgroundColor = '#F8FAFC'
          ..style.color = '#475569'
          ..style.fontFamily = 'Outfit, sans-serif'
          ..style.fontSize = '11px'
          ..style.fontWeight = '600'
          ..style.lineHeight = '15px'
          ..style.outline = 'none';

        _textAreas[label] = area;

        final observer = html.ResizeObserver((entries, observer) {
          final newHeight = area.clientHeight.toDouble();
          if (mounted && newHeight >= _initialFieldHeight &&
              (_fieldHeights[label] ?? _initialFieldHeight) != newHeight) {
            setState(() {
              _fieldHeights[label] = newHeight;
            });
            // Keep the HTML textarea width locked to its grid column.
            area.style.width = '100%';
            area.style.maxWidth = '100%';
            area.style.minWidth = '100%';
          }
        });
        observer.observe(area);
        _resizeObservers[label] = observer;
        return area;
      });
      _viewTypes[label] = viewType;
    }
  }

  final Map<String, String> _viewTypes = {};

  @override
  void dispose() {
    for (final observer in _resizeObservers.values) {
      observer.disconnect();
    }
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double dialogWidth =
    screenWidth < 1080 ? screenWidth - 40 : 1040;

    const double hPad = 16;
    const double spacing = 12;
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
                        color: DynamicColors.primaryClr,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(THIS INFORMATION IS FOR VIEW ONLY)',
                      style: outFitRegular(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: DynamicColors.primaryClr,
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

              // ────────── Form Fields Grid ──────────
              Padding(
                padding: const EdgeInsets.all(hPad),
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    _buildPopupField('PICKUP', fieldWidth),
                    _buildPopupField('PICKUP NOTES', fieldWidth),
                    _buildPopupField('DROPOFF', fieldWidth),
                    _buildPopupField('DROPOFF NOTES', fieldWidth),
                    _buildPopupField('NAME', fieldWidth),
                    _buildPopupField('EMAIL', fieldWidth),
                    _buildPopupField('MOBILE', fieldWidth),
                    _buildPopupField('TELEPHONE', fieldWidth),
                    _buildPopupField('DATE', fieldWidth),
                    _buildPopupField('TIME', fieldWidth),
                    _buildPopupField('LEAD', fieldWidth),
                    _buildPopupField('JOURNEY TYPE', fieldWidth),
                    _buildPopupField('PAYMENT TYPE', fieldWidth),
                    _buildPopupField('FARES', fieldWidth),
                    _buildPopupField('VEHICLE', fieldWidth),
                    _buildPopupField('DRIVER', fieldWidth),
                    _buildPopupField('PASSENGERS', fieldWidth),
                    _buildPopupField('LUGGAGES', fieldWidth),
                    _buildPopupField('HAND LUGGAGES', fieldWidth),
                    _buildPopupField('ACCOUNT', fieldWidth),
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
                          fontWeight: FontWeight.bold),
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

  Widget _buildPopupField(String label, double width) {
    final height = _fieldHeights[label] ?? _initialFieldHeight;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: outFitRegular(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: height,
            child: HtmlElementView(viewType: _viewTypes[label]!),
          ),
        ],
      ),
    );
  }
}