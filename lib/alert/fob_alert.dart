import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../controller/fob_controller.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

// void showDispatchFob() {
//   Get.dialog(
//     DispatchFobAlert(),
//     barrierColor: Colors.black54,
//   );
// }

class DispatchFobAlert extends StatefulWidget {
  final dynamic bookingItem;
  const DispatchFobAlert({super.key, this.bookingItem});

  @override
  State<DispatchFobAlert> createState() => _DispatchFobAlertState();
}

class _DispatchFobAlertState extends State<DispatchFobAlert> {

  final controller = Get.put(FobController());
  final _controller = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    controller.getDispatchFob();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 650,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text("DISPATCH FOB ${widget.bookingItem?.referenceNumber ?? "N/A"}",
                      style: mozillaTextSemiBoldText(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                        Icons.close, size: 22, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.person_search, color: Colors
                              .black54),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SELECT DRIVER TO DISPATCH",
                                style: mozillaTextSemiBoldText(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("CHOOSE A DRIVER, THEN PRESS DISPATCH.",
                                style: mozillaTextRegularText(
                                    fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                        const Spacer(),
                        CustomButton(
                          width: 165,
                          height: 35,
                          verticalPadding: 0.0,
                          borderRadius: 4,
                          btnText: "CALCULATE DISTANCE",
                          style: mozillaTextSemiBoldText(
                              fontSize: 14, color: Colors.white),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.drivers.isEmpty) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: Text("NO DRIVERS FOUND")),
                      );
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowHeight: 45,
                        columnSpacing: 45,
                        headingRowColor: WidgetStateProperty.all(Colors.grey
                            .shade50),
                        border: TableBorder.all(color: Colors.grey.shade300,
                            width: 1),
                        columns: [
                          _buildDataColumn("USERNAME"),
                          _buildDataColumn("DRIVER"),
                          _buildDataColumn("ATTRIBUTES"),
                          _buildDataColumn("STATUS"),
                          _buildDataColumn("ACTION"),
                        ],
                        rows: controller.drivers.map((driver) {
                          return DataRow(
                            cells: [
                              DataCell(Text("${(driver.username ?? '').toUpperCase()}",
                                  style: mozillaTextRegularText(fontSize: 14))),
                              DataCell(Text((driver.name ?? '').toUpperCase(),
                                  style: mozillaTextRegularText(fontSize: 14))),
                              DataCell(Center(child: Text("-",
                                  style: mozillaTextRegularText(
                                      fontSize: 14)))),
                              DataCell(Text(driver.bookingStatus ?? '',
                                  style: mozillaTextRegularText(
                                      fontSize: 14, color: Colors.green))),
                              DataCell(
                                Center(
                                  child: CustomButton(
                                    width: 80,
                                    height: 28,
                                    verticalPadding: 0.0,
                                    borderRadius: 4,
                                    btnText: "DISPATCH",
                                    style: mozillaTextSemiBoldText(
                                        fontSize: 14, color: Colors.white),
                                    onTap: () {
                                      controller.fobBooking(_controller.dashboardTableModelData?.data!.first.id, driver.id);
                                    },
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
            ),

            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  width: 100,
                  height: 35,
                  btnText: "CLOSE",
                  btnColor: DynamicColors.primaryClr,
                  verticalPadding: 0.0,
                  borderRadius: 6,
                  onTap: () => Get.back(),
                  style: mozillaTextSemiBoldText(fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(label, style: mozillaTextSemiBoldText(
          fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}