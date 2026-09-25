import 'package:flutter/material.dart';

import '../component/color.dart';
import '../component/escape_dismissible.dart';
import '../component/textStyle.dart';

class DriverAttributesAlert extends StatefulWidget {
  const DriverAttributesAlert({super.key});

  @override
  State<DriverAttributesAlert> createState() => _DriverAttributesAlertState();
}

class _DriverAttributesAlertState extends State<DriverAttributesAlert> {
  final List<Map<String, dynamic>> attributes = [
    {"id": 1, "name": "PET FRIENDLY", "code": "PF", "isSelected": false},
    {"id": 2, "name": "WHEEL CHAIR", "code": "WC", "isSelected": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
          // width: 550,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DRIVER ATTRIBUTES",
                style: mozillaTextSemiBoldText(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: const Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Column(
                    children: [
                      // Header Row
                      Container(
                        height: 38,
                        color: const Color(0xFFF8FAFC),
                        child: Row(
                          children: [
                            _buildCell("#", width: 45, isHeader: true),
                            _buildCell("ATTRIBUTE NAME", flex: 3, isHeader: true),
                            _buildCell("SHORT CODE", flex: 3, isHeader: true),
                            _buildCell("ACTION", width: 70, isHeader: true, showRightBorder: false, centerAlign: true),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),

                      // Table Rows
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: attributes.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        itemBuilder: (context, index) {
                          final item = attributes[index];
                          return SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                _buildCell("${item['id']}", width: 45),
                                _buildCell(item['name'], flex: 3),
                                _buildCell(item['code'], flex: 3),
                                // Action Checkbox Cell
                                SizedBox(
                                  width: 70,
                                  child: Center(
                                    child: Transform.scale(
                                      scale: 0.8,
                                      child: Checkbox(
                                        value: item['isSelected'],
                                        shape: const CircleBorder(),
                                        activeColor: DynamicColors.primaryClr,
                                        side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                                        onChanged: (val) {
                                          setState(() {
                                            item['isSelected'] = val ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildCell(
      String text, {
        double? width,
        int flex = 1,
        bool isHeader = false,
        bool showRightBorder = true,
        bool centerAlign = false,
      }) {
    final cellChild = Container(
      decoration: BoxDecoration(
        border: showRightBorder
            ? const Border(right: BorderSide(color: Color(0xFFE2E8F0), width: 1))
            : null,
      ),
      alignment: centerAlign ? Alignment.center : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(text,
        style: outFitRegular(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: cellChild);
    }
    return Expanded(flex: flex, child: cellChild);
  }
}