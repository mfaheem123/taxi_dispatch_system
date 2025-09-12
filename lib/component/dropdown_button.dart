import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String? label;
  final List<T> items;
  final double? width;
  final double? height;
  final T? value;
  final String Function(T) itemLabel; // 👈 how to display text
  final Function(T?) onChanged;

  const CustomDropdownField({
    super.key,
    this.label,
    required this.items,
    this.width,
    this.height,
    this.value,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width / 4,
      height: height ?? 30,
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: label,
          hintStyle: mozillaTextRegularText(fontSize: 10),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isDense: true,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, size: 16),
            items: items.map((T val) {
              return DropdownMenuItem<T>(
                value: val,
                child: Text(
                  itemLabel(val), // ✅ how we display dynamic object
                  style: mozillaTextRegularText(fontSize: 10),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}


class DropdownModel {
  int? id;
  String? name;

  DropdownModel({this.id, this.name});
}