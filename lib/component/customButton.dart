


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'color.dart';

import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'color.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    this.onTap,
    this.width,
    this.btnText,
    this.height,
    this.borderRadius,
    this.style,
    this.verticalPadding,
    this.btnColor,
    this.key,
    this.widget,
    this.fontSize,
    this.focusBorderColor,
    this.focusBorderWidth = 3,
    this.focusNode,
  });

  final double focusBorderWidth;
  final Color? focusBorderColor;
  final GestureTapCallback? onTap;
  double? width;
  double? height;
  double? fontSize;
  double? borderRadius;
  double? verticalPadding;
  String? btnText;
  final TextStyle? style;
  final Color? btnColor;
  Key? key;
  Widget? widget;
  final FocusNode? focusNode;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  late final FocusNode _focusNode;
  bool _isFocused = false;
  late final bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  // Modern Focus Key Handler
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // 1. Enter ya Space press hone par button hit ho
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      widget.onTap?.call();
      return KeyEventResult.handled;
    }

    // 2. Up / Down Arrow keys ko ignore kar rahe hain taake event parent/page tak jaye
    // Aur aapka page scroll handler screen ko move kar sake.
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.arrowDown) {
      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final Widget button = Container(
      padding: EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 13),
      decoration: BoxDecoration(
        color: widget.btnColor ?? DynamicColors.primaryClr,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
      ),
      child: Center(
        child: widget.widget ??
            Text(
              widget.btnText ?? AppText.login,
              style: widget.style ??
                  mozillaTextSemiBoldText(
                    fontSize: widget.fontSize ?? 20,
                    color: DynamicColors.whiteClr,
                    fontWeight: FontWeight.w700,
                  ),
            ),
      ),
    );

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: GestureDetector(
        key: widget.key,
        onTap: () {
          _focusNode.requestFocus();
          widget.onTap?.call();
        },
        child: SizedBox(
          width: widget.width ?? Get.width / 2.5,
          height: widget.height ?? 45,
          child: widget.focusBorderColor != null
              ? Container(
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                color: _isFocused
                    ? widget.focusBorderColor!
                    : Colors.transparent,
                width: widget.focusBorderWidth,
              ),
              borderRadius:
              BorderRadius.circular(widget.borderRadius ?? 20),
            ),
            child: button,
          )
              : AnimatedScale(
            scale: _isFocused ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: button,
          ),
        ),
      ),
    );
  }
}

onKeyBoardEnter({GestureTapCallback? onTap}) {
  return onTap;
  // Yahan aap apna existing onTap wala function call kar do
}
