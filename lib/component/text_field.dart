

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({super.key,
  this.labelText,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.prefixIcon,
    this.borderRadius,
    this.contentPadding,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
  });

  String? labelText;
  String? hintText;
  TextEditingController controller = TextEditingController();
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  double? borderRadius = 25;
  final EdgeInsetsGeometry? contentPadding;
  TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: Get.width/2.5,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              labelText: labelText,
              contentPadding: contentPadding?? EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius??20), // Rounded corners
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius??20),
                borderSide: BorderSide(color: DynamicColors.primaryClr),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius??20),
                borderSide: BorderSide(color: DynamicColors.primaryClr, width: 2),
              ),
            ),
          )

      );
  }
}
