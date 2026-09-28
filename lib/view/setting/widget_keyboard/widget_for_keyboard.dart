import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardNavigationHandler extends StatefulWidget {
  final Widget child;
  final VoidCallback? onEnterPressed;
  final VoidCallback? onSpacePressed;

  const KeyboardNavigationHandler({
    super.key,
    required this.child,
    this.onEnterPressed,
    this.onSpacePressed,
  });

  @override
  State<KeyboardNavigationHandler> createState() =>
      _KeyboardNavigationHandlerState();
}

class _KeyboardNavigationHandlerState
    extends State<KeyboardNavigationHandler> {
  final FocusNode _mainFocusNode = FocusNode();

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(), // Field indexing basis par nav karne ke liye
      child: Focus(
        focusNode: _mainFocusNode,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            // 1. Arrow Down / Enter se agle field par jana (jab multiline na ho)
            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              FocusScope.of(context).nextFocus();
              return KeyEventResult.handled;
            }

            // 2. Arrow Up se pichle field par jana
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              FocusScope.of(context).previousFocus();
              return KeyEventResult.handled;
            }

            // 3. Enter key handling (Submit ya Action ke liye)
            if (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.numpadEnter) {
              if (widget.onEnterPressed != null) {
                widget.onEnterPressed!();
                return KeyEventResult.handled;
              }
            }

            // 4. Space key handling
            if (event.logicalKey == LogicalKeyboardKey.space) {
              if (widget.onSpacePressed != null) {
                widget.onSpacePressed!();
                return KeyEventResult.handled;
              }
            }
          }
          return KeyEventResult.ignored;
        },
        child: widget.child,
      ),
    );
  }
}