import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/component/suggestion_widget/suggestion_controller.dart';
import 'package:dashboard_new1/view/fare_view/controller/controller.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
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
    this.readOnly = false,
    this.borderWidth = 2,
    this.obscureText = false, // Optional, default is false
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
  final bool readOnly;
  double? height;
  double? width;
  Color? fillColor;
  bool columnText = false;
  double borderWidth = 2;
  final bool obscureText; // Added property

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        columnText
            ? Text(hintText!, style: mozillaTextRegularText(context: context, fontSize: 13))
            : const SizedBox.shrink(),

        SizedBox(
          width: width ?? Get.width / 2.5,
          height: height ?? 30,
          child: TextField(
            obscureText: obscureText, // Applied here
            onTapOutside: (event) {
              bool isTapInsideKey(GlobalKey key) {
                final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  final position = renderBox.localToGlobal(Offset.zero);
                  final size = renderBox.size;
                  final rect = position & size;
                  return rect.contains(event.position);
                }
                return false;
              }

              if (Get.isRegistered<DashboardController>()) {
                final dashboardController = Get.find<DashboardController>();
                if (dashboardController.dropDownShow.value) {
                  if (isTapInsideKey(dashboardController.suggestionListKey) ||
                      isTapInsideKey(dashboardController.suggestionListKeyVia)) {
                    return;
                  }
                }
              }

              if (Get.isRegistered<SuggestionController>()) {
                final sugController = Get.find<SuggestionController>();
                if (isTapInsideKey(sugController.suggestionListKey)) {
                  return;
                }
              }

              if (Get.isRegistered<FareController>()) {
                final fareController = Get.find<FareController>();
                if (isTapInsideKey(fareController.suggestionListKey) ||
                    isTapInsideKey(fareController.suggestionListKeyVia)) {
                  return;
                }
              }

              FocusManager.instance.primaryFocus?.unfocus();

              if (Get.isRegistered<DashboardController>()) {
                Get.find<DashboardController>().dropDownShow.value = false;
                Get.find<DashboardController>().update();
              }
            },
            textCapitalization: TextCapitalization.characters,
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            keyboardType: keyboardType,
            onSubmitted: onSubmitted,
            textInputAction: textInputAction,
            onTap: onTap ??
                    () {
                  shortCutKeyValue.value = "formKey";
                },
            style: hintStyle ??
                mozillaTextRegularText(
                  context: context,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
            inputFormatters: inputFormatters,
            maxLines: obscureText ? 1 : maxLines, // Obscure text requires maxLines to be 1
            minLines: obscureText ? 1 : maxLines,
            readOnly: readOnly,
            decoration: InputDecoration(

              prefixIcon: prefixIcon,
              hintText: hintText,
              fillColor: fillColor,
              filled: fillColor != null ? true : false,
              hintStyle: hintStyle ??
                  mozillaTextRegularText(

                      context: context,
                      fontSize: 13,
                      fontWeight: FontWeight.normal),
              labelText: labelText,
              suffixIcon: suffixIcon,
              contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 20),
                borderSide: BorderSide(color: borderColor ?? DynamicColors.primaryClr.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 20),
                borderSide: BorderSide(color: borderColor ?? DynamicColors.primaryClr, width: borderWidth,),
              ),

            ),
          ),
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}