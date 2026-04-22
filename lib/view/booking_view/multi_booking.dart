import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/pagination.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'complete_bookingview.dart';
import 'controller.dart';

class MultiBooking extends StatefulWidget {
  const MultiBooking({super.key});

  @override
  State<MultiBooking> createState() => _MultiBookingState();
}

class _MultiBookingState extends State<MultiBooking> {
  BookingController controller = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows =
      50; // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "MultiBooking";
    controller.getMultiBookingData();
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = controller.multiBookingFiltered.isNotEmpty
        ? controller.multiBookingFiltered
        : controller.multiBookingAll;
    return GetBuilder<BookingController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        return
          controller.trashBookingLoad == true? Center(child: CircularProgressIndicator(),):
          Container(
          color: const Color(0xFFF7F9FC),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    AppText.multiBookings + " (${controller.multiBookingModelData?.total.toString()})",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                   Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: CustomButton(
                        height: 40,
                        width: 80,
                        verticalPadding: 0.0,
                        borderRadius: 4,
                        widget: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                          child: Icon(
                            Icons.refresh,
                            color: DynamicColors.whiteClr,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // 📋 Data Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DatatableWidget(
                    columns: [

                      buildHeaderWithSearch(title: "DATETIME",
                        onChanged: (v) {
                          controller.multipickupDate.text = v;
                          controller.multiBookingonSearch();
                        },

                      ),

                      buildHeaderWithSearch(title: "CUSTOMER",
                        onChanged: (v) {
                          controller.multiCustomerName.text = v;
                          controller.multiBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(title: "MOBILE",
                        onChanged: (v) {
                          controller.multiMobile.text = v;
                          controller.multiBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(title: "PICKUP"
                      , onChanged: (v) {
                          controller.multipickup.text = v;
                          controller.multiBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(title: "DROPOFF"
                        , onChanged: (v) {
                          controller.multidropOff.text = v;
                          controller.multiBookingonSearch();
                        },),
                      buildHeaderWithSearch(
                          title: "ACTIONS", removeSearching: true),
                    ],

        totalRow: listToShow.length,
        rows: listToShow.map((item) {
        return DataRow(
          cells: [
            DataCell(Center(child: Text("${DateFormat('dd-MM-yyyy').format(item.pickupDate!)} ${item.pickupTime}"))),
            DataCell(Center(child: Text((item.customer.toString() ?? "").toUpperCase()))),
            DataCell(Center(child: Text(item.mobile ?? ""))),
            DataCell(Center(child: Text((item.pickup ?? "").toUpperCase()))),
            DataCell(Center(child: Text((item.dropoff ?? "").toUpperCase()))),
            DataCell(
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding:
                      EdgeInsets.zero, // 👈 remove inner padding
                      minimumSize:
                      Size(24, 24), // 👈 shrink button size
                      side: BorderSide.none, // 👈 remove border
                    ),
                    onPressed: () {
                      setState(() {
                        // _currentPage = CompleteBookingsScreen();
                        controller.menuBarController.menuBarRefresh(title: "COMPLETE BOOKINGS", pageName: CompleteBookingsScreen());
                      });

                    },
                    child: Icon(Icons.edit_calendar, size: 20),
                  ),
                  const SizedBox(
                      width: 4), // 👈 replace "|" with small spacing
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(24, 24),
                      side: BorderSide.none,
                    ),
                    onPressed: () {},
                    child: Icon(Icons.delete_forever, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],    );}).toList(),

                  ),
                ),
              ),
              PaginationWidget(
                currentPage: controller.multiBookingCurrentPage.value,
                totalPages: controller.multiBookingTotalPages.value,
                onPageChange: controller.multiBookingPageChange,),


            ],
          ),
        );
      });
    });
  }
}
