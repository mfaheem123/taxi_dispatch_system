import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String? label;
  final List<T> items;
  final double? width;
  final double? height;
  final T? value;
  final String Function(T) itemLabel; // 👈 how to display text
  final Function(T?) onChanged;
  String? text;

  CustomDropdownField({
    super.key,
    this.label,
    required this.items,
    this.width,
    this.height,
    this.text,
    this.value,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text != null ? Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(text!, style: mozillaTextRegularText(context: context, fontSize: 13, fontWeight: FontWeight.bold)),
        ) : const SizedBox.shrink(),
        SizedBox(
          width: width ?? Get.width / 4,
          height: height ?? 30,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: label ,
              fillColor: Colors.transparent,
              hintStyle: mozillaTextRegularText(fontSize: 13,fontWeight: FontWeight.bold),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:  DynamicColors.primaryClr),
              ),


            ),
            child: DropdownButtonHideUnderline(

              child: DropdownButton<T>(

                value: value,
                isDense: true,
                hint: Text(
                  label ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: mozillaTextRegularText(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                isExpanded: true,
                alignment: Alignment.center,
                icon: const Icon(Icons.arrow_drop_down, size: 16),

                selectedItemBuilder: (BuildContext context) {
                  return items.map((T val) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        itemLabel(val),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: mozillaTextRegularText(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList();
                },

                items: items.map((T val) {
                  return DropdownMenuItem<T>(
                    value: val,
                    child: Text(
                      itemLabel(val), // ✅ how we display dynamic object
                      softWrap: true,
                      style: mozillaTextRegularText(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,

              ),
            ),
          ),
        ),
      ],
    );
  }
}


class DropdownModel {
  int? id;
  String? name;
  String? templateValue;

  DropdownModel({this.id, this.name, this.templateValue});
}