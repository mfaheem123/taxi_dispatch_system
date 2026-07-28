import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/textStyle.dart';
import '../view/customer/controller/customer_controller.dart';
import '../view/dashboard_view/booking_table.dart';

class ComplaintBookingAlert extends StatefulWidget {
  final String searchQuery;

  const ComplaintBookingAlert({super.key, required this.searchQuery});

  @override
  State<ComplaintBookingAlert> createState() => _ComplaintBookingAlertState();

  static void showSearchDialog(BuildContext context, String query) {
    Get.dialog(
      ComplaintBookingAlert(searchQuery: query),
    );
  }
}

class _ComplaintBookingAlertState extends State<ComplaintBookingAlert> {
  final controller = Get.find<CustomerController>();

  @override
  void initState() {
    super.initState();

    /// ❗ SAME API (Booking model use ho raha hai)
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
            Text(
              "COMPLAINT BOOKINGS",
              style: mozillaTextSemiBoldText(
                fontWeight: FontWeight.w900,
                fontSize: 23,
              ),
            ),
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, size: 20),
            )
          ],
        ),
      ),

      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: GetBuilder<CustomerController>(
          builder: (controller) {
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
                child: Center(child: Text("No Records Found")),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: DatatableWidget(
                  columns: [
                    buildHeaderWithSearch(title: "REF #", removeSearching: true),
                    buildHeaderWithSearch(title: "DATE/TIME", removeSearching: true),
                    buildHeaderWithSearch(title: "CUSTOMER", removeSearching: true),
                    buildHeaderWithSearch(title: "MOBILE", removeSearching: true),
                    buildHeaderWithSearch(title: "PICKUP", removeSearching: true),
                    buildHeaderWithSearch(title: "ACTION", removeSearching: true),
                  ],

                  rows: controller.getCustomerBookingModel!.bookings!
                      .map((booking) {
                        
                    String formattedDate = booking.pickupDate ?? '';
                    if (booking.pickupDate != null && booking.pickupDate.toString().isNotEmpty) {
                      try {
                        DateTime parsedDate = DateFormat("yyyy-M-d").parse(booking.pickupDate.toString());
                        formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
                      } catch (_) {
                        formattedDate = booking.pickupDate.toString();
                      }
                    }

                    return DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              (booking.referenceNumber ?? "-").toUpperCase(),
                            ),
                          ),
                        ),

                        DataCell(
                          Center(
                            child: Text(
                              "$formattedDate ${booking.pickupTime ?? ''}"
                                  .toUpperCase(),
                            ),
                          ),
                        ),

                        DataCell(
                          Center(
                            child: Text(
                              (booking.name ?? "-").toUpperCase(),
                            ),
                          ),
                        ),

                        DataCell(
                          Center(
                            child: Text(
                              (booking.mobile ?? "-").toUpperCase(),
                            ),
                          ),
                        ),

                        DataCell(
                          Center(
                            child: Text(
                              (booking.pickup ?? "-").toUpperCase(),
                            ),
                          ),
                        ),

                        /// 🔥 THIS IS IMPORTANT (Complaint style selection)
                        DataCell(
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (formattedDate != "-") {
                                  booking.pickupDate = formattedDate;
                                }
                                Get.back(result: booking);
                              },
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
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}