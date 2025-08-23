


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
  });

  final GestureTapCallback? onTap;
  double? width;
  double? height;
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
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKey,
      child: GestureDetector(
        key: widget.key,
        onTap: widget.onTap,
        child: SizedBox(
          width: widget.width ?? Get.width/2.5,
          height:widget.height?? 45,
          child: AnimatedScale(
            scale: _isFocused ? 1.1 : 1.0, // zoom when focused
            duration: Duration(milliseconds: 150),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: widget.verticalPadding??13),
              decoration: BoxDecoration(
                color:widget.btnColor?? DynamicColors.primaryClr,
                borderRadius: BorderRadius.circular(widget.borderRadius??20),
              ),
              child: Center(
                child: widget.widget??Text( widget.btnText??AppText.login,
                  style:widget.style?? mozillaTextSemiBoldText(
                      fontSize: 20,
                      color: DynamicColors.whiteClr,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
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
