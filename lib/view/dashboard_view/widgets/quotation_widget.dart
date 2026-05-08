


import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';



class DynamicSwitch extends StatefulWidget {
  final ValueNotifier<bool> controller;
  final Color activeColor;
  final Color inactiveColor;
  final double width;
  final double height;
  final double focusScale;
  final BorderRadius borderRadius;
  final VoidCallback? onToggle;
  final ValueChanged? onChanged;

  DynamicSwitch({
    super.key,
    required this.controller,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.width = 40,
    this.height = 20,
    this.focusScale = 1.3,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.onToggle,
    this.onChanged,
  });

  @override
  State<DynamicSwitch> createState() => _DynamicSwitchState();
}

class _DynamicSwitchState extends State<DynamicSwitch> {
  final FocusNode switchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    switchFocus.addListener(() {
      setState(() {}); // rebuild on focus change
    });
  }

  @override
  void dispose() {
    switchFocus.dispose();
    super.dispose();
  }

  void _toggle() {
    widget.controller.value = !widget.controller.value;
    if (widget.onToggle != null) widget.onToggle!();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: switchFocus,
      onKey: (event) {
        if (event is RawKeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          _toggle();
        }
      },
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedScale(
          scale: switchFocus.hasFocus ? widget.focusScale : 1.0,
          duration: Duration(milliseconds: 200),
          child: AdvancedSwitch(
            controller: widget.controller,
            activeColor: widget.activeColor,
            inactiveColor: widget.inactiveColor,
            // borderRadius: widget.borderRadius,
            width: 30,
            height: 15,
            onChanged: widget.onChanged, // handled by ValueNotifier + _toggle
          ),
        ),
      ),
    );
  }
}


