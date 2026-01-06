


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
      initState: (v){
        controller.getShortCut();
      },
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

            return
              controller.getShortCutLoader.value?
              SizedBox.shrink():
            Column(
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
              totalRow: controller.locationShortCut!.locationTypes!.length,
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
              rows: controller.locationShortCut!.locationTypes!.map((item) {
              return DataRow(
                  cells: [
              DataCell(Center(child: Text(item.name!))),
              DataCell(
              Center(
                child: TextField(
                controller: item.controller,
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
                 pickerColor: item.backgroundColor!,
                 // pickerColor: (0xff item.backgroundColor),
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
                 pickerColor: item.foregroundColor!,
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
}

