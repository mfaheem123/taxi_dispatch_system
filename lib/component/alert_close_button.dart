import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AlertCloseButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const AlertCloseButton({
    super.key,
    this.onTap,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
             event.logicalKey == LogicalKeyboardKey.space)) {
          if (onTap != null) {
            onTap!();
          } else {
            Get.back();
          }
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return InkWell(
            onTap: onTap ?? () => Get.back(),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isFocused ? DynamicColors.primaryClr : Colors.transparent,
                  width: isFocused ? 2.0 : 1.0,
                ),
                color: isFocused
                    ? DynamicColors.primaryClr.withOpacity(0.12)
                    : Colors.transparent,
              ),
              child: Icon(
                Icons.close,
                size: size,
                color: isFocused ? DynamicColors.primaryClr : Colors.black54,
              ),
            ),
          );
        },
      ),
    );
  }
}
