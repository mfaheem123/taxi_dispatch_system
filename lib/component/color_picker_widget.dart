
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color pickerColor; // Keep this as Color
  final void Function(Color) onColorChanged;
  final double? width;
  final double? height;
  final Color? borderColor;
  final void Function(Color)? onColorSelected;
  final double? colorContainerHeight; // Marked as final for StatelessWidget

  ColorPickerWidget({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.width,
    this.height,
    this.borderColor = Colors.black,
    this.onColorSelected,
    this.colorContainerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Use the Color object directly
            Color tempColor = pickerColor;

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
                        // Optional: Live preview update
                        onColorChanged(color);
                      },
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        // Pass the Color object back
                        onColorChanged(tempColor);

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
            color: pickerColor, // Direct usage
            height: colorContainerHeight ?? 5,
            width: (width ?? 100) / 1.2,
          ),
        ),
      ),
    );
  }
}

