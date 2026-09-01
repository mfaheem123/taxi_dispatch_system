import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color pickerColor;
  final void Function(Color) onColorChanged;
  final double? width;
  final double? height;
  final Color? borderColor;
  final void Function(Color)? onColorSelected;
  final double? colorContainerHeight;
  final FocusNode? focusNode;

  const ColorPickerWidget({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.width,
    this.height,
    this.borderColor = Colors.black,
    this.onColorSelected,
    this.colorContainerHeight,
    this.focusNode,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  FocusNode? _internalFocusNode;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = widget.pickerColor;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: tempColor,
                  onColorChanged: (Color color) {
                    setDialogState(() {
                      tempColor = color;
                    });
                    widget.onColorChanged(color);
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    widget.onColorChanged(tempColor);
                    if (widget.onColorSelected != null) {
                      widget.onColorSelected!(tempColor);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _effectiveFocusNode,
      canRequestFocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
             event.logicalKey == LogicalKeyboardKey.space)) {
          _openDialog();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: ListenableBuilder(
        listenable: _effectiveFocusNode,
        builder: (context, _) {
          final isFocused = _effectiveFocusNode.hasFocus;
          return GestureDetector(
            onTap: () {
              _effectiveFocusNode.requestFocus();
              _openDialog();
            },
            child: Container(
              height: widget.height ?? 30,
              width: widget.width ?? 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isFocused ? DynamicColors.primaryClr : (widget.borderColor ?? Colors.black),
                  width: isFocused ? 2.0 : 1.0,
                ),
              ),
              child: Center(
                child: Container(
                  color: widget.pickerColor,
                  height: widget.colorContainerHeight ?? 5,
                  width: (widget.width ?? 100) / 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
