import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/textStyle.dart';
import '../view/dashboard_view/booking_table.dart';
import '../view/drivers_view/controller/driver_attribute_controller.dart';

class DriverAttributesAlert extends StatefulWidget {
  const DriverAttributesAlert({super.key});

  @override
  State<DriverAttributesAlert> createState() => _DriverAttributesAlertState();
}

class _DriverAttributesAlertState extends State<DriverAttributesAlert> {
  final DriverAttributeController controller =
      Get.isRegistered<DriverAttributeController>()
          ? Get.find<DriverAttributeController>()
          : Get.put(DriverAttributeController());

  final Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    controller.getDriverAttributes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DRIVER ATTRIBUTES",
            style: mozillaTextSemiBoldText(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),

          Obx(() {
            if (controller.isLoading.value &&
                controller.allAttributes.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(30.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (controller.allAttributes.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "NO ATTRIBUTES FOUND",
                    style: mozillaTextRegularText(
                        fontSize: 13, color: Colors.grey),
                  ),
                ),
              );
            }

            return SizedBox(
              width: double.infinity,
              child: DatatableWidget(
                headingRowHeight: 38,
                dataRowMinHeight: 40,
                dataRowMaxHeight: 40,
                columns: [
                  buildHeaderWithSearch(
                    title: "#",
                    removeSearching: true,
                  ),
                  buildHeaderWithSearch(
                    title: "ATTRIBUTE NAME",
                    removeSearching: true,
                  ),
                  buildHeaderWithSearch(
                    title: "SHORT CODE",
                    removeSearching: true,
                  ),
                  buildHeaderWithSearch(
                    title: "ACTION",
                    removeSearching: true,
                  ),
                ],
                totalRow: controller.allAttributes.length,
                rows: controller.allAttributes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final itemId = item.id;
                  final isSelected =
                      itemId != null && selectedIds.contains(itemId);

                  return DataRow(
                    cells: [
                      DataCell(Center(child: Text("${itemId ?? (index + 1)}"))),
                      DataCell(Text((item.attributeName ?? '').toUpperCase())),
                      DataCell(Text((item.shortName ?? '').toUpperCase())),
                      DataCell(
                        Center(
                          child: Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              value: isSelected,
                              shape: const CircleBorder(),
                              activeColor: DynamicColors.primaryClr,
                              side: const BorderSide(
                                  color: Color(0xFFCBD5E1), width: 1.5),
                              onChanged: (val) {
                                setState(() {
                                  if (itemId != null) {
                                    if (val == true) {
                                      selectedIds.add(itemId);
                                    } else {
                                      selectedIds.remove(itemId);
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
