import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/driver_earning_model.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/textStyle.dart';
import '../view/dashboard_view/booking_table.dart';

class DriverBookingsAlert extends StatelessWidget {
  final List<Booking> bookings;

  const DriverBookingsAlert({super.key, required this.bookings});

  static void show(List<Booking> bookings) {
    Get.dialog(
      DriverBookingsAlert(bookings: bookings),
      barrierColor: Colors.black54,
    );
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
            Text(
              "DRIVER BOOKINGS",
              style: mozillaTextSemiBoldText(
                fontWeight: FontWeight.w900,
                fontSize: 23,
              ),
            ),
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, size: 20),
            ),
          ],
        ),
      ),

      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: DatatableWidget(
              columns: [
                buildHeaderWithSearch(title: "REF #", removeSearching: true),
                buildHeaderWithSearch(title: "DATETIME", removeSearching: true),
                buildHeaderWithSearch(title: "VEHICLE", removeSearching: true),
                buildHeaderWithSearch(title: "PICKUP", removeSearching: true),
                buildHeaderWithSearch(title: "DROPOFF", removeSearching: true),
                buildHeaderWithSearch(title: "FARES", removeSearching: true),
                buildHeaderWithSearch(title: "CUSTOMER", removeSearching: true),
                buildHeaderWithSearch(title: "ACCOUNT", removeSearching: true),
                buildHeaderWithSearch(title: "DRIVER", removeSearching: true),
                buildHeaderWithSearch(title: "P/T", removeSearching: true),
                buildHeaderWithSearch(title: "STATUS", removeSearching: true),
              ],
              totalRow: bookings.length,
              rows: bookings.map((booking) {
                String dateTime = "${booking.pickupDate ?? ''}\n${booking.pickupTime ?? ''}".trim();
                String status = booking.bookingStatus?.bookingStatus ?? (booking.completed == true ? "COMPLETED" : "");

                return DataRow(
                  cells: [
                    DataCell(
                      Center(
                        child: Text(
                          (booking.referenceNumber ?? "").toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          dateTime.toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          (booking.vehicleType?.name ?? "").toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 180,
                        child: Text(
                          (booking.pickup ?? "").toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 200,
                        child: Text(
                          (booking.dropoff ?? "").toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          "£${booking.fares ?? "0.00"}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          (booking.name ?? "").toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          (booking.account?.name ?? "").toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          (booking.driver?.name ?? "").toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          (booking.paymentType?.name ?? "").toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: status.toUpperCase() == "COMPLETED"
                                ? DynamicColors.greenClr.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: status.toUpperCase() == "COMPLETED"
                                  ? DynamicColors.greenClr
                                  : DynamicColors.textClr,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}