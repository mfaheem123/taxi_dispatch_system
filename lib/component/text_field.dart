

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../view/dashboard_view/Controller/dashboard_controller.dart';

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
    this.hintStyle,
    this.suffixIcon,
    this.onSubmitted,
    this.textInputAction,
    this.onTap,
    this.borderColor,
    this.fillColor,
    this.maxLines = 1,
    this.height,
    this.width,
    this.columnText = false,
  });

  String? labelText;
  String? hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  double? borderRadius = 25;
  final EdgeInsetsGeometry? contentPadding;
  TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final GestureTapCallback? onTap;
  Color? borderColor;
  final int? maxLines;
  double? height;
  double? width;
  Color? fillColor;
  bool columnText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        columnText?Text(hintText!, style: mozillaTextSemiBoldText(context: context, fontSize: 13)):SizedBox.shrink(),
        SizedBox(
              width: width?? Get.width/2.5,
            height: height?? 30,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                keyboardType: keyboardType,
                onSubmitted: onSubmitted,
                textInputAction: textInputAction,
                onTap: onTap??
                        () {
                      // Get.find<DashboardController>().
                      shortCutKeyValue.value = "formKey";
                    },
                style: hintStyle?? mozillaTextSemiBoldText(
                    context: context,
                    fontSize: 10,
                    fontWeight: FontWeight.w800
                ),
                inputFormatters: inputFormatters,
                maxLines: maxLines,
                minLines: maxLines,
                decoration: InputDecoration(
                  prefixIcon: prefixIcon,
                  hintText: hintText,
                  fillColor: fillColor,
                  filled: fillColor != null?true: false,
                  hintStyle: hintStyle?? mozillaTextSemiBoldText(
                    context: context,
                    fontSize: 10,
                    fontWeight: FontWeight.w800
                  ),
                  labelText: labelText,
                  suffixIcon: suffixIcon,
                  contentPadding: contentPadding?? EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius??20), // Rounded corners
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius??20),
                    borderSide: BorderSide(color: borderColor ?? DynamicColors.primaryClr),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius??20),
                    borderSide: BorderSide(color: borderColor ?? DynamicColors.primaryClr, width: 2),
                  ),
                ),
              )

          ),
      ],
    );
  }
}
