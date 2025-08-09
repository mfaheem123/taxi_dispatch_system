


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../view/dashboard_view/Controller/dashboard_controller.dart';
import 'customButton.dart';

class KeyboardDropdown extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String? initialValue;
  double? containerWidth;

  KeyboardDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.containerWidth,
  });

  @override
  State<KeyboardDropdown> createState() => _KeyboardDropdownState();
}

class _KeyboardDropdownState extends State<KeyboardDropdown> {
  late FocusNode _focusNode;
  int _selectedIndex = 0;
  bool _isOpen = false;
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    if (widget.initialValue != null &&
        widget.items.contains(widget.initialValue)) {
      _selectedIndex = widget.items.indexOf(widget.initialValue!);
    }
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      print("Pressed key: ${event.logicalKey}");
      print("Key label: ${event.logicalKey.keyLabel}");
      if(event.logicalKey.keyLabel == "F3"){
        dashBoardCntrl.shortCutKeyValue.value = "alert";
      }
      if(event.logicalKey.keyLabel == "Escape" &&
          dashBoardCntrl.shortCutKeyValue.value == "alert"){
        dashBoardCntrl.shortCutKeyValue.value = "shortCutKey";
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % widget.items.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _selectedIndex =
              (_selectedIndex - 1 + widget.items.length) % widget.items.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_isOpen && widget.items.isNotEmpty) {
          widget.onChanged(widget.items[_selectedIndex]);
        }
        setState(() {
          _isOpen = !_isOpen; // Enter se open/close toggle
        });
        onKeyBoardEnter();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isOpen = !_isOpen;
              });
              _focusNode.requestFocus();
            },
            child: Container(
              width:widget.containerWidth?? 250,
              padding: const EdgeInsets.only(top: 6,bottom: 6,left: 3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.items.isNotEmpty
                    ? widget.items[_selectedIndex]
                    : "No Data",
                style: mozillaTextRegularText(
                  fontSize: 13,

                ),
              ),
            ),
          ),
          if (_isOpen && widget.items.isNotEmpty)
            Container(
              width: Get.width/6,
              height: Get.height/6,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.items.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  bool isSelected = index == _selectedIndex;
                  return InkWell(
                    onTap: () {
                      widget.onChanged(widget.items[index]);
                      setState(() {
                        _selectedIndex = index;
                        _isOpen = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: isSelected
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.transparent,
                      child: Text(widget.items[index]),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
