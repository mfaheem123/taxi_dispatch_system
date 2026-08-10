


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'color.dart';

class CustomButton extends StatefulWidget {
  
  CustomButton({this.onTap,
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
  });

  /// Thickness of the focus ring. Only used when [focusBorderColor] is set.
  final double focusBorderWidth;

  /// When set, keyboard focus is shown as a ring in this colour instead of the
  /// default zoom. Opt-in, so every existing call site keeps the zoom cue.
  ///
  /// Use it wherever the button sits in a tightly-clipped viewport — e.g. a
  /// short horizontal ListView — because there the scaled-up button is cropped
  /// by the viewport and the zoom reads as no feedback at all. A ring drawn on
  /// the unscaled bounds always stays fully visible.
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

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget button = Container(
      padding: EdgeInsets.symmetric(vertical: widget.verticalPadding??13),
      decoration: BoxDecoration(
        color:widget.btnColor?? DynamicColors.primaryClr,
        borderRadius: BorderRadius.circular(widget.borderRadius??20),
      ),
      child: Center(
        child: widget.widget??Text( widget.btnText??AppText.login,
          style:widget.style?? mozillaTextSemiBoldText(
              fontSize: widget.fontSize?? 20,
              color: DynamicColors.whiteClr,
              fontWeight: FontWeight.w700),
        ),
      ),
    );

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKey,
      child: GestureDetector(
        key: widget.key,
        onTap: widget.onTap,
        child: SizedBox(
          width: widget.width ?? Get.width/2.5,
          height:widget.height?? 45,
          child: widget.focusBorderColor != null
              // Ring drawn as a foregroundDecoration on the UNSCALED bounds:
              // painting over the child means the label never reflows (a
              // BoxDecoration.border would inset it), and staying unscaled
              // means a tight parent viewport cannot crop the outline.
          // foregroundDecoration is ALWAYS supplied and only its colour changes.
          // Toggling it between null and a decoration would add/remove a
          // DecoratedBox, remounting the child subtree on every focus change.
          // It paints over the child, and Container derives padding only from
          // `decoration`, so a transparent border costs nothing in layout.
              ? Container(
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                  color: _isFocused
                      ? widget.focusBorderColor!
                      : Colors.transparent,
                  width: widget.focusBorderWidth),
              borderRadius:
              BorderRadius.circular(widget.borderRadius ?? 20),
            ),
            child: button,
          )
              : AnimatedScale(
            scale: _isFocused ? 1.1 : 1.0, // zoom when focused
            duration: Duration(milliseconds: 150),
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
