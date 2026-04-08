import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../view/dashboard_view/Controller/booking_dispatch_controller.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class DispatchBooking extends StatefulWidget {
  final dynamic bookingItem;
  const DispatchBooking({super.key, this.bookingItem});

  @override
  State<DispatchBooking> createState() => _DispatchBookingState();
}

class _DispatchBookingState extends State<DispatchBooking> {

  final controller = Get.put(DispatchController());
  final _controller = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  controller.getDispatchDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.only(top: 100, left: 40, right: 40),
      backgroundColor: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
            Text("DISPATCH BOOKING ${widget.bookingItem?.referenceNumber ?? "N/A"}",
                        style: mozillaTextSemiBoldText(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, size: 22, color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1),
                // Sub-Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SELECT DRIVER TO DISPATCH",
                        style: mozillaTextSemiBoldText(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
                    CustomButton(
                      width: 165, height: 35, verticalPadding: 0.0, borderRadius: 4,
                      btnText: "CALCULATE DISTANCE",
                      style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.white),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Data Table Section with GetX Obx
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
                      child: Center(child: Text("No Drivers Found")),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 45,
                      columnSpacing: 25,
                      headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                      columns: [
                        _buildDataColumn("ID"),
                        _buildDataColumn("DRIVER NAME"),
                        _buildDataColumn("SUBSIDIARY"),
                        _buildDataColumn("STATUS"),
                        _buildDataColumn("ATTRIBUTES"),
                        _buildDataColumn("DISTANCE"),
                        _buildDataColumn("ACTION"),
                      ],
                      rows: controller.drivers.map((driver) {
                        return DataRow(
                          cells: [
                            DataCell(Text("${driver.id ?? ''}", style: mozillaTextRegularText(fontSize: 14))),
                            DataCell(Text(driver.name ?? '', style: mozillaTextRegularText(fontSize: 14))),
                            DataCell(Text(driver.subsidiary?.name ?? '', style: mozillaTextRegularText(fontSize: 14))),
                            DataCell(Text(driver.bookingStatus ?? '', style: mozillaTextRegularText(fontSize: 14, color: Colors.green))),
                            DataCell(Center(child: Text("-", style: mozillaTextRegularText(fontSize: 14)))),
                            DataCell(Center(child: Text("-", style: mozillaTextRegularText(fontSize: 14)))),
                            DataCell(
                              Center(
                                child: CustomButton(
                                  width: 80, height: 28, verticalPadding: 0.0, borderRadius: 4,
                                  btnText: "DISPATCH",
                                  style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.white),
                                  onTap: () {
                                   controller.assignDriverToBooking(_controller.dashboardTableModelData?.data!.first.id, driver.id);
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


                const SizedBox(height: 10),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: 80, height: 28, btnText: "CLOSE",
                      btnColor: Colors.grey.shade600,
                      verticalPadding: 0.0, borderRadius: 4,
                      onTap: () => Get.back(),
                      style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Column Helper
  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(label, style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}