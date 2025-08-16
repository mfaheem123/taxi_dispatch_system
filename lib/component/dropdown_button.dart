import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
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

  bool _isDropdownOpen = false;
  int _highlightedIndex = 0;

  void _openDropdownByKeyboard() {
    if (!_isDropdownOpen) {
      final RenderBox? renderBox =
          _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final Offset position =
            renderBox.localToGlobal(renderBox.size.center(Offset.zero));
        GestureBinding.instance.handlePointerEvent(
          PointerDownEvent(position: position),
        );
        GestureBinding.instance.handlePointerEvent(
          PointerUpEvent(position: position),
        );
      }
    }
  }

  void _selectHighlightedItem() {
    if (widget.itemList.isNotEmpty) {
      final value = widget.itemList[_highlightedIndex];
      setState(() {
        widget.selectedDropDownValue = value;
      });
      widget.onSelected?.call(value);
    }
  }

  void _closeDropdownByKeyboard() {
    if (_isDropdownOpen) {
      final RenderBox? renderBox =
      _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final Offset position =
        renderBox.localToGlobal(renderBox.size.center(Offset.zero));

        // Dropdown ko ESC se close karna (mouse click simulate)
        GestureBinding.instance.handlePointerEvent(
          PointerDownEvent(position: position),
        );
        GestureBinding.instance.handlePointerEvent(
          PointerUpEvent(position: position),
        );
      }

      setState(() {
        _isDropdownOpen = false;
      });
      _focusNode.unfocus();
    }
  }

  final GlobalKey _dropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) async {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            await Future.delayed(const Duration(milliseconds: 50));
            if (!_isDropdownOpen) {
              _openDropdownByKeyboard();
            } else {
              _selectHighlightedItem();
            }
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            await Future.delayed(const Duration(milliseconds: 50));
            setState(() {
              _highlightedIndex =
                  (_highlightedIndex + 1) % widget.itemList.length;
            });
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            await Future.delayed(const Duration(milliseconds: 50));
            setState(() {
              _highlightedIndex =
                  (_highlightedIndex - 1 + widget.itemList.length) %
                      widget.itemList.length;
            });
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            // 👇 Yahan ESC press par dropdown band hoga
            _closeDropdownByKeyboard();
          }
        }
      },
    /*  onKey: (event) async {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            await Future.delayed(const Duration(milliseconds: 50));
            if (!_isDropdownOpen) {
              _openDropdownByKeyboard();
            } else {
              _selectHighlightedItem();
            }
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            await Future.delayed(const Duration(milliseconds: 50));
            setState(() {
              _highlightedIndex =
                  (_highlightedIndex + 1) % widget.itemList.length;
            });
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            await Future.delayed(const Duration(milliseconds: 50));
            setState(() {
              _highlightedIndex =
                  (_highlightedIndex - 1 + widget.itemList.length) %
                      widget.itemList.length;
            });
          }
        }
      },*/
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isFocused ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButton2<String>(
          onMenuStateChange: (isOpen) {
            setState(() {
              _isDropdownOpen = isOpen;
            });
            if (isOpen) {
              _focusNode.requestFocus();
            } else {
              _focusNode.unfocus();
            }
          },
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
