import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/textStyle.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
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

  final DashboardController dashController =
      Get.isRegistered<DashboardController>()
          ? Get.find<DashboardController>()
          : Get.put(DashboardController());

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
                  final isSelected = itemId != null &&
                      dashController.selectedBookingAttributes
                          .any((a) => a.id == itemId);

                  return DataRow(
                    cells: [

                      DataCell(Center(child: Text((item.attributeName ?? '').toUpperCase()))),
                      DataCell(Center(child: Text((item.shortName ?? '').toUpperCase()))),
                      DataCell(
                        Center(
                          child: Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              value: isSelected,
                              shape: const CircleBorder(),
                              activeColor: DynamicColors.primaryClr,
                              // Tab focus: thick primary outline plus a tinted
                              // halo, instead of the faint default overlay.
                              focusColor:
                                  DynamicColors.primaryClr.withValues(alpha: 0.25),
                              side: WidgetStateBorderSide.resolveWith(
                                (states) => states.contains(WidgetState.focused)
                                    ? BorderSide(
                                        color: DynamicColors.primaryClr,
                                        width: 2.5)
                                    : const BorderSide(
                                        color: Color(0xFFCBD5E1), width: 1.5),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  if (itemId != null) {
                                    if (val == true) {
                                      if (!dashController
                                          .selectedBookingAttributes
                                          .any((a) => a.id == itemId)) {
                                        dashController.selectedBookingAttributes
                                            .add(item);
                                      }
                                    } else {
                                      dashController.selectedBookingAttributes
                                          .removeWhere((a) => a.id == itemId);
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
