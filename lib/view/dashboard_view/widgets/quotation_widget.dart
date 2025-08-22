


import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';

class QuotationWidget extends StatefulWidget {
  const QuotationWidget({super.key});

  @override
  State<QuotationWidget> createState() => _QuotationWidgetState();
}

class _QuotationWidgetState extends State<QuotationWidget> {
  final FocusNode switchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    switchFocus.addListener(() {
      setState(() {}); // jab focus aye/jae to rebuild hoga
    });
  }

  @override
  void dispose() {
    switchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return RawKeyboardListener(
          focusNode: switchFocus,
          onKey: (event) {
            if (event is RawKeyDownEvent &&
                (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space)) {
              controller.switchController.value =
              !controller.switchController.value; // toggle
            }
          },
          child: GestureDetector(
            onTap: () {
              // Mouse click se bhi toggle
              controller.switchController.value =
              !controller.switchController.value;
            },
            child: AnimatedScale(
              scale: switchFocus.hasFocus ? 1.4 : 1.0, // zoom when focused
              duration: const Duration(milliseconds: 200),
              child: AdvancedSwitch(
                controller: controller.switchController,
                activeColor: DynamicColors.primaryClr,
                inactiveColor: Colors.grey,
                borderRadius: BorderRadius.circular(15),
                width: 30,
                height: 15,
                onChanged: (v) {},
              ),
            ),
          ),
        );
      },
    );
  }
}


