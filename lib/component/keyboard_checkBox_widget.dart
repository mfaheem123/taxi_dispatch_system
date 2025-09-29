


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardCheckbox extends StatelessWidget {
  final FocusNode focusNode;
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;
  final TextStyle? textStyle;
  double? width;

  KeyboardCheckbox({
    super.key,
    required this.focusNode,
    required this.value,
    required this.label,
    required this.onChanged,
    this.textStyle,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width??100, // 👈 adjust as needed
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: RawKeyboardListener(
              focusNode: focusNode,
              onKey: (event) {
                if (event is RawKeyDownEvent &&
                    (event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.space)) {
                  onChanged(!value); // ✅ toggle on key press
                }
              },
              child: Checkbox(
                value: value,
                onChanged: (val) {
                  if (val != null) {
                    onChanged(val);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: textStyle ?? mozillaTextRegularText(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
