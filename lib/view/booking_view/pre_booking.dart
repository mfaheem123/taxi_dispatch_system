





import 'package:dashboard_new1/view/booking_view/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/color.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/pagination.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'controller.dart';

class PreBooking extends StatefulWidget {
  const PreBooking({super.key});

  @override
  State<PreBooking> createState() => _PreBookingState();
}

class _PreBookingState extends State<PreBooking> {

  BookingController controller = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "PreBooking";
      controller.getDashboardTableData();
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = controller.preBookingFiltered.isNotEmpty
        ? controller.preBookingFiltered
        : controller.preBookingAll;
    return GetBuilder<BookingController>(

        builder: (controller) {

          return LayoutBuilder(
              builder: (context, constraints) {
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
                  controller.preBookingLoad == true? Center(child: CircularProgressIndicator()):

                  Container(
                  color: const Color(0xFFF7F9FC),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(AppText.preBookings+ " (${
                                controller.dashboardTableModelData?.total
                                    .toString()
                              })",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.w800,
                                fontSize: 17
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),

                           Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: CustomButton(
                        onTap: (){
                          controller.getDashboardTableData();
                          print("Refresh-------------------");
                        },
                        height: 40,
                        width: 80,
                        verticalPadding: 0.0,
                        borderRadius: 4,
                widget: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                child: controller.preBookingLoad == true
                ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                color: DynamicColors.whiteClr,
                strokeWidth: 2,
                ),
                )
                    : Icon(
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
                        child:
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(title: "REF #",
                                onChanged: (v) {
                                  controller.referenceNumber.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "DATETIME",
                                onChanged: (v) {
                                  controller.pickupDate.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),

                              buildHeaderWithSearch(title: "CUSTOMER",
                                onChanged: (v) {
                                  controller.name.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "PICKUP",
                                onChanged: (v) {
                                  controller.pickup.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "DROPOFF",
                                onChanged: (v) {
                                  controller.dropOff.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "ACC",
                                onChanged: (v) {
                                  controller.accountName.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "DRV",
                                onChanged: (v) {
                                  controller.driverName.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "P/T",
                                onChanged: (v) {
                                  controller.paymentType.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "VEH",
                                onChanged: (v) {
                                  controller.vehicleTypeName.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "NOT",
                                onChanged: (v) {
                                  controller.notes.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "FARE",
                                onChanged: (v) {
                                  controller.fares.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "STATUS",
                                onChanged: (v) {
                                  controller.bookingStatus.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "J/T",
                                onChanged: (v) {
                                  controller.journeyType.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "SUBS",

                                onChanged: (v) {
                                  controller.subsidiary.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),

                              buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                            ],
                            totalRow: listToShow.length,
                            rows: listToShow.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Center(child: Text(item.referenceNumber ?? '—'))),
                                  DataCell(Center(child: Text("${DateFormat('dd-MM-yyyy').format(item.pickupDate!)} ${item.pickupTime}"))),
                                  DataCell(Center(child: Text(item.name ?? '—'))),
                                  DataCell(Center(child: Text(item.pickup ?? 'N/A'))),
                                  DataCell(Center(child: Text(item.dropoff ?? 'N/A'))),
                                  DataCell(Center(child: Text(item.account.toString() ?? 'N/A'))),
                                  DataCell(Center(child: Text(item.toggleDriverText ?? 'N/A'))),
                                  DataCell(Center(child: Text(item.paymentType.toString() ?? 'N/A'))),
                                  DataCell(Center(child: Text(item.vehicleType?.name ?? 'N/A'))),
                                  DataCell(Center(child: Text(item.notes.toString() ?? 'N/A'))),
                                  DataCell(Center(child: Text(item.fares.toString() ?? 'N/A'))),

                                  DataCell(Center(child:

                                   Container(
                                                                  width: double.infinity,
                                                                  height: double.infinity,
                                                                  alignment: Alignment.center,

                                                                  // APPLY YOUR COLOR HERE
                                                                  decoration: BoxDecoration(
                                                                    color: DynamicColors.statusColor,
                                                                    // Optional: borderRadius: BorderRadius.circular(2),
                                                                  ),
                                                                  child: Text(
                                                                    item.bookingStatus?.bookingStatus.toString() ?? 'N/A',
                                                                    style: TextStyle(color: DynamicColors.whiteClr),
                                                                  ),
                                                                ),

                                  )),
                                  DataCell(Center(child: Text(item.journeyType.toString() ?? 'N/A'))),
                                  DataCell(Center(child: Text(item.subsidiary.toString() ?? 'N/A'))),
                                  DataCell(
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.transparent),),
                                            onPressed: () {
                                            },
                                            child: Icon(Icons.edit_calendar,
                                                size: 28),
                                          ),
                                          Text("|"),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: Colors.transparent),
                                            ),
                                            onPressed: () {

                                            },
                                            child: Icon(Icons.delete_forever,
                                                size: 28),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      PaginationWidget(
                          currentPage: controller.preBookingCurrentPage.value,
                          totalPages: controller.preBookingTotalPages.value,
                          onPageChange: controller.preBookingPageChange),
                    ],
                  ),
                );
              }
          );
        }
    );
  }


}