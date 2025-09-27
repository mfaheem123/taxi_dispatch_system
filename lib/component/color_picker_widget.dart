
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color pickerColor;
  final void Function(Color) onColorChanged;
  final double? width;
  final double? height;
  final Color? borderColor;
  final void Function(Color)? onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.width,
    this.height,
    this.borderColor = Colors.black,
    this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Color tempColor = pickerColor;

            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: tempColor,
                  onColorChanged: (color) {
                    tempColor = color;
                    onColorChanged(color);
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    // Call callback if provided
                    if (onColorSelected != null) {
                      onColorSelected!(tempColor);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: height ?? 30,
        width: width ?? 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor!),
        ),
        child: Center(
          child: Container(
            color: pickerColor,
            height: 5,
            width: (width ?? 100) / 1.2,
          ),
        ),
      ),
    );
  }
}

