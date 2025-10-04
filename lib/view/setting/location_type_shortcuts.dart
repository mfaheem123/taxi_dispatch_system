


import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/setting/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/color.dart';
import '../../component/color_picker_widget.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/booking_table.dart';

class LocationTypeShortcuts extends StatefulWidget {
  const LocationTypeShortcuts({super.key});

  @override
  State<LocationTypeShortcuts> createState() => _LocationTypeShortcutsState();
}

class _LocationTypeShortcutsState extends State<LocationTypeShortcuts> {

  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
        builder: (controller) {

          return LayoutBuilder(builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

            // Instead of fixed width, we calculate flexible field widths
            final double fieldWidth = isMobile
                ? maxWidth // full width
                : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

            return Column(
              children: [
                SizedBox(
                height: 8,
              ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(AppText.locationTypeShortcuts, style: titleDesign()),
                    SizedBox(
                      width: 50,
                    ),
                    CustomButton(
                      height: 35,
                      btnText: AppText.save,
                      verticalPadding: 0.0,
                      width: 100,
                      borderRadius: 4,
                    ),
                  ],
                ),
                SizedBox(
                height: 8,
              ),
            SizedBox(
              width: Get.width,
              child: DatatableWidget(
              totalRow: locationShortcutKey.length,
              columns: [
              buildHeaderWithSearch(title: "LOCATION TYPE",
              removeSearching: true,
              ),
              buildHeaderWithSearch(title: "SHORTCUT",
                removeSearching: true,
              ),
              buildHeaderWithSearch(title: "BACKGROUND COLOR",
                removeSearching: true,
              ),
              buildHeaderWithSearch(title: "FOREGROUND COLOR",
                removeSearching: true,
              ),
              ],

              // 🔹 Create a list of DataRow, each having 4 DataCell
              rows: locationShortcutKey.map((item) {
              return DataRow(
                  cells: [
              DataCell(Center(child: Text(item.title!))),
              DataCell(
              Center(
                child: TextField(
                controller: item.shortcutKey,
                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.all(8),
                ),
                ),
              ),
              ),
             DataCell(Center(
               child: ColorPickerWidget(
                 pickerColor: item.backgroundColor,
                 onColorChanged: (color) {
                   setState(() {
                     item.backgroundColor = color; // live preview
                   });
                 },
                 onColorSelected: (color) {
                   setState(() {
                     item.backgroundColor = color; // final selected
                   });
                 },
                 width: fieldWidth,
                 // height: 10,
                 colorContainerHeight: 10,
                 borderColor: DynamicColors.gryClr,
               ),
             )),
             DataCell(Center(
               child: ColorPickerWidget(
                 pickerColor: item.foregroundColor,
                 onColorChanged: (color) {
                   setState(() {
                     item.foregroundColor = color; // live preview
                   });
                 },
                 onColorSelected: (color) {
                   setState(() {
                     item.foregroundColor = color; // final selected
                   });
                 },
                 width: fieldWidth,
                 // height: 10,
                 colorContainerHeight: 10,
                 borderColor: DynamicColors.gryClr,
               ),
             )),
              ]);
              }).toList(),
              ),
            )
            ],
            );
          }
        );
      }
    );
  }


  List<ShowCutKeyValue> locationShortcutKey = [
    ShowCutKeyValue(
      title: "ADDRESS",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "AIRPORT",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "BANK",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "BASE",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "CARE HOME",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "CHURCHES",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "CLINIC",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "CLUB/BAR",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "CORPORATE",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "DENTAL CLINIC",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "HOSPITAL",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
    ShowCutKeyValue(
      title: "HOTELS",
      shortcutKey: TextEditingController(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.blue
    ),
  ];
}

class ShowCutKeyValue {

  String? title;
  TextEditingController shortcutKey = TextEditingController();
  Color backgroundColor = Colors.blue;
  Color foregroundColor = Colors.blue;

  ShowCutKeyValue({this.title,required this.backgroundColor,required this.foregroundColor,required this.shortcutKey});
}
