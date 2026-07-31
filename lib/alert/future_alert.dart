import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class DispatchFutureBookingAlert extends StatefulWidget {
  final dynamic bookingItem;

  const DispatchFutureBookingAlert({Key? key, required this.bookingItem})
      : super(key: key);

  @override
  State<DispatchFutureBookingAlert> createState() =>
      _DispatchFutureBookingAlertState();
}

class _DispatchFutureBookingAlertState
    extends State<DispatchFutureBookingAlert> {
  late final DashboardController controller;

  @override
  void initState() {
    controller = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());
    controller.getAvailableDriversForFutureDispatch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(16),
        child: GetBuilder<DashboardController>(
          builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  children: [
                    const Icon(Icons.send, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      "DISPATCH FB (${widget.bookingItem.referenceNumber ?? '-'})",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),

                /// Sub Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.person_search, size: 18),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SELECT DRIVER TO DISPATCH",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            "FUTURE BOOKING DISPATCH LIST.",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// Table
                SizedBox(
                  height: 300,
                  child: controller.futureDispatchLoader.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.futureDispatchDriversList.isEmpty
                      ? const Center(child: Text("No drivers available"))
                      : SingleChildScrollView(
                    child: DataTable(
                      headingRowColor:
                      MaterialStateProperty.all(Colors.grey[100]),
                      columns: const [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("DRIVER")),
                        DataColumn(label: Text("ATTRIBUTES")),
                        DataColumn(label: Text("STATUS")),
                        DataColumn(label: Text("ACTION")),
                      ],
                      rows: controller.futureDispatchDriversList
                          .map((driver) {
                        return DataRow(cells: [
                          DataCell(Text(driver.id.toString())),
                          DataCell(Text(
                              (driver.name ?? "-").toUpperCase())),
                          DataCell(Text(driver.vehicleType ?? "-")),
                          DataCell(Text(
                              (driver.driverStatus ?? "-").toUpperCase())),
                          DataCell(
                            controller.futureDispatchSubmitLoader.value
                                ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            )
                                : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () {
                                controller.dispatchFutureBooking(
                                  bookingId:
                                  widget.bookingItem.id,
                                  driverId: driver.id,
                                );
                              },
                              child: const Text(
                                "DISPATCH",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Footer
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CLOSE"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}