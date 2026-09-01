import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;
  final double? order;

  const ActionIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 18,
    this.order,
  });

  @override
  Widget build(BuildContext context) {
    Widget btn = Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
             event.logicalKey == LogicalKeyboardKey.space)) {
          onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isFocused ? color : Colors.transparent,
                  width: 1.5,
                ),
                color: isFocused ? color.withOpacity(0.12) : Colors.transparent,
              ),
              child: Icon(
                icon,
                size: size,
                color: color,
              ),
            ),
          );
        },
      ),
    );

    if (order != null) {
      btn = FocusTraversalOrder(
        order: NumericFocusOrder(order!),
        child: btn,
      );
    }

    return btn;
  }
}
