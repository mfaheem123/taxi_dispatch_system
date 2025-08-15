


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'color.dart';

class CustomDropdownButton extends StatefulWidget {
  CustomDropdownButton({
    super.key,
    this.hintText,
    required this.itemList,
    this.selectedDropDownValue,
    this.onSelected,
  });

  String? selectedDropDownValue;
  String? hintText;
  List<String> itemList = [];
  final ValueChanged<String?>? onSelected;

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
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

  void _openDropdownByKeyboard() {
    // DropdownButton2 automatically opens when button is tapped
    // So we simulate a tap using GestureDetector's callback
    _dropdownKey.currentContext?.findRenderObject()?.sendSemanticsEvent(
      TapSemanticEvent(),
    );
  }

  final GlobalKey _dropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          _openDropdownByKeyboard();
        }
      },
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isFocused ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButton2<String>(
          key: _dropdownKey,
          value: widget.selectedDropDownValue,
          underline: const SizedBox(),
          iconStyleData: const IconStyleData(
            icon: SizedBox.shrink(), // remove dropdown icon
          ),
          isExpanded: true,
          hint: Text(
            widget.hintText ?? "JOB DUE BY",
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
            widget.onSelected?.call(value);
          },
          buttonStyleData: const ButtonStyleData(
            height: 40,
            width: 150,
          ),
          dropdownStyleData: DropdownStyleData(
            offset: const Offset(0, 15),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(8),
            // ),
          ),
        ),
      ),
    );
  }
}

