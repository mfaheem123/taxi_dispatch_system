import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/textStyle.dart';
import '../view/customer/controller/customer_controller.dart';
import '../view/dashboard_view/booking_table.dart';

class LostPropertyBookingAlert extends StatefulWidget {
  final String searchQuery;
  const LostPropertyBookingAlert({super.key, required this.searchQuery});

  @override
  State<LostPropertyBookingAlert> createState() => _LostPropertyBookingAlertState();
  static void showSearchDialog(BuildContext context, String query) {
    Get.dialog(
      LostPropertyBookingAlert(searchQuery: query),
    );
  }
}

class _LostPropertyBookingAlertState extends State<LostPropertyBookingAlert> {
  final controller = Get.find<CustomerController>();

  @override
  void initState() {
    super.initState();
    controller.getCustomerJobs(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.only(top: 42, left: 12, right: 12, bottom: 30),
      clipBehavior: Clip.antiAlias,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        color: DynamicColors.secondaryClr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("BOOKINGS",
                style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 23)),
            IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, size: 20))
          ],
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: GetBuilder<CustomerController>(builder: (controller) {

          if (controller.bookingsLoader) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.getCustomerBookingModel?.bookings == null ||
              controller.getCustomerBookingModel!.bookings!.isEmpty) {
            return const SizedBox(
              height: 100,
              child: Center(child: Text("No Bookings Found")),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: DatatableWidget(
                    columns: [
                      buildHeaderWithSearch(title: "REF #", removeSearching: true),
                      buildHeaderWithSearch(title: "DATETIME", removeSearching: true),
                      buildHeaderWithSearch(title: "VEHICLE", removeSearching: true),
                      buildHeaderWithSearch(title: "PICKUP", removeSearching: true),
                      buildHeaderWithSearch(title: "DROPOFF", removeSearching: true),
                      buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                    ],
                    rows: controller.getCustomerBookingModel!.bookings!.map((booking) {
                      return DataRow(cells: [
                        DataCell(Center(child: Text(booking.referenceNumber ?? "-"))),
                        DataCell(Center(child: Text("${booking.pickupDate ?? ''} ${booking.pickupTime ?? ''}"))),
                        DataCell(Center(child: Text(booking.vehicleType?.name ?? "-"))),
                        DataCell(Center(child: Text(booking.pickup ?? "-"))),
                        DataCell(Center(child: Text(booking.dropoff ?? "-"))),
                        DataCell(Center(
                          child: InkWell(
                            onTap: () => Get.back(result: booking),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: const Text(
                                "PICK",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}