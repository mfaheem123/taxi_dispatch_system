import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';
import '../component/datatable_widget.dart';
import '../view/dashboard_view/booking_table.dart';
import '../view/drivers_view/controller/driver_attribute_controller.dart';
import '../view/drivers_view/controller/driver_controller.dart';

class AttributeAlert {
  static void show({Set<int>? initialSelectedIds, Function(Set<int>)? onSave}) {
    final DriverAttributeController controller =
        Get.isRegistered<DriverAttributeController>()
            ? Get.find<DriverAttributeController>()
            : Get.put(DriverAttributeController());

    final DriverController driverController =
        Get.isRegistered<DriverController>()
            ? Get.find<DriverController>()
            : Get.put(DriverController());

    // Fetch driver attributes from API
    controller.getDriverAttributes();

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: DynamicColors.gryClr.withValues(alpha: 0.5),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.local_offer,
                              color: DynamicColors.primaryClr, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "ATTRIBUTES",
                            style: mozillaTextSemiBoldText(
                                fontSize: 15, color: DynamicColors.textClr),
                          ),
                          const Spacer(),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 15),

                    // Table Section using DatatableWidget
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Obx(() {
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
                              final item = entry.value;
                              final itemId = item.id;
                              final isSelected = driverController.selectedAttributeList
                                  .any((a) => a.id == itemId);

                              return DataRow(
                                cells: [
                                  DataCell(Center(
                                      child: Text(
                                          (item.attributeName ?? '').toUpperCase()))),
                                  DataCell(Center(
                                      child:
                                          Text((item.shortName ?? '').toUpperCase()))),
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
                                              if (val == true) {
                                                if (!driverController.selectedAttributeList
                                                    .any((a) => a.id == itemId)) {
                                                  driverController.selectedAttributeList
                                                      .add(item);
                                                }
                                              } else {
                                                driverController.selectedAttributeList
                                                    .removeWhere((a) => a.id == itemId);
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
                    ),
                    const SizedBox(height: 20),

                    // Footer
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            width: 80,
                            height: 28,
                            verticalPadding: 0.0,
                            btnText: "CLOSE",
                            btnColor: Colors.red,
                            borderRadius: 4,
                            style: mozillaTextSemiBoldText(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            onTap: () {
                              if (onSave != null) {
                                onSave(driverController.selectedAttributeList
                                    .where((e) => e.id != null)
                                    .map((e) => e.id!)
                                    .toSet());
                              }
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
