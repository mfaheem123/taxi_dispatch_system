


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'color.dart';

class CustomDropdownButton extends StatefulWidget {
  CustomDropdownButton({super.key,
  this.hintText,
  required this.itemList,
  this.selectedDropDownValue,
  });

  String ? selectedDropDownValue;
  String ? hintText;
  List<String> itemList = [];

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton2<String>(
      value: widget.selectedDropDownValue,
      underline: const SizedBox(), // remove underline
      iconStyleData: const IconStyleData(
        icon: SizedBox.shrink(), // remove dropdown icon
      ),
      isExpanded: true,
      hint: Text(
        widget.hintText??"JOB DUE BY",
        style: mozillaTextRegularText(
          fontSize: 13,
          color: DynamicColors.textClr,
        ),
      ),
      items: widget.itemList
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: mozillaTextRegularText(
            fontSize: 13,
            color: DynamicColors.textClr,
          ),
        ),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.selectedDropDownValue = value;
        });
      },
      buttonStyleData: const ButtonStyleData(
        height: 40,
        width: 150,
      ),
      dropdownStyleData: DropdownStyleData(
        offset: const Offset(0, 15), // 👈 yahan 10px niche shift
        decoration: BoxDecoration(
          // color: DynamicColors.secondaryClr,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
