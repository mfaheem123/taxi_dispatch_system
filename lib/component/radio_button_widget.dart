


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusRadioGroup extends StatefulWidget {
  final List<String> options;
  final Function(int, String) onChanged; // 👈 callback

  const StatusRadioGroup({
    super.key,
    required this.options,
    required this.onChanged,
  });

  @override
  State<StatusRadioGroup> createState() => _StatusRadioGroupState();
}

class _StatusRadioGroupState extends State<StatusRadioGroup> {
  int selectedValue = 0;
  final FocusNode _focusNode = FocusNode();

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          selectedValue = (selectedValue + 1) % widget.options.length;
        });
        widget.onChanged(selectedValue, widget.options[selectedValue]);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          selectedValue =
              (selectedValue - 1 + widget.options.length) % widget.options.length;
        });
        widget.onChanged(selectedValue, widget.options[selectedValue]);
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        debugPrint("ENTER pressed → Selected: ${widget.options[selectedValue]}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: _handleKeyEvent,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(widget.options.length, (index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<int>(
                value: index,
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                  widget.onChanged(selectedValue, widget.options[selectedValue]);
                },
              ),
              Text(
                widget.options[index],
                style: mozillaTextRegularText(fontSize: 12,fontWeight: FontWeight.w900),
              ),
            ],
          );
        }),
      ),
    );
  }
}