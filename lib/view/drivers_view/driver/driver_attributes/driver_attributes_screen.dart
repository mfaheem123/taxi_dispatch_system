import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';

import '../../../../component/responsive_datatable_widget.dart';
import 'attribute_add_alert.dart';


class DriverAttributeModel {
  final String id;
  final String name;
  final String shortName;

  DriverAttributeModel({required this.id, required this.name, required this.shortName});
}

class DriverAttributesScreen extends StatefulWidget {
  const DriverAttributesScreen({super.key});

  @override
  State<DriverAttributesScreen> createState() => _DriverAttributesScreenState();
}

class _DriverAttributesScreenState extends State<DriverAttributesScreen> {
  List<DriverAttributeModel> attributesList = [
    DriverAttributeModel(id: "1", name: "PET FRIENDLY", shortName: "PF"),
    DriverAttributeModel(id: "2", name: "WHEEL CHAIR", shortName: "WC"),
    DriverAttributeModel(id: "1", name: "PET FRIENDLY", shortName: "PF"),
    DriverAttributeModel(id: "2", name: "WHEEL CHAIR", shortName: "WC"),
    DriverAttributeModel(id: "1", name: "PET FRIENDLY", shortName: "PF"),
    DriverAttributeModel(id: "2", name: "WHEEL CHAIR", shortName: "WC"),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double totalAvailableWidth = constraints.maxWidth;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "DRIVER ATTRIBUTES ",
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: DynamicColors.textClr,
                        ),
                      ),
                      TextSpan(
                        text: "(${attributesList.length})",
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: DynamicColors.primaryClr,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: CustomButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AttributeAddAlert(
                          onSave: (name, shortName) {
                            // TODO: Add logic to save new attribute
                          },
                        ),
                      );
                    },
                    height: 30,
                    width: 35,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: CustomButton(
                    onTap: () {
                      // Refresh Action
                    },
                    height: 30,
                    width: 35,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            ResponsiveDataTableWidget(
              totalWidth: totalAvailableWidth,
              items: attributesList,
              columnConfigs: [
                TableColumnConfig(
                  title: "S.NO",
                  sizeType: ColumnSizeType.small,
                  removeSearching: true,
                ),
                TableColumnConfig(
                  title: "NAME",
                  sizeType: ColumnSizeType.large,
                  onChanged: (v) {},
                ),
                TableColumnConfig(
                  title: "SHORT NAME",
                  sizeType: ColumnSizeType.large,
                  onChanged: (v) {},
                ),
                TableColumnConfig(
                  title: "ACTIONS",
                  sizeType: ColumnSizeType.medium,
                  removeSearching: true,
                ),
              ],
              rowBuilder: (item, widths) {
                DriverAttributeModel attr = item as DriverAttributeModel;
                return [
                  Center(child: Text(attr.id, style: const TextStyle(fontWeight: FontWeight.bold))),
                  attr.name,
                  attr.shortName,
                  Center(
                    child: SizedBox(
                      width: widths["ACTIONS"]!,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.edit,
                                size: 16, color: DynamicColors.primaryClr),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AttributeAddAlert(
                                  id: attr.id,
                                  initialName: attr.name,
                                  initialShortName: attr.shortName,
                                  onSave: (name, shortName) {
                                    // TODO: Add logic to update attribute
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 2),
                          const Text("|",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(width: 2),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.delete,
                                size: 16, color: DynamicColors.redClr),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      );
    });
  }
}
