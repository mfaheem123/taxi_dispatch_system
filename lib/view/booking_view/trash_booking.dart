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
import 'controller.dart';

class TrashBooking extends StatefulWidget {
  const TrashBooking({super.key});

  @override
  State<TrashBooking> createState() => _TrashBookingState();
}

class _TrashBookingState extends State<TrashBooking> {
  BookingController controller = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows =
      50; // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "TrashBooking";
    controller.getTrashBookingData();
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = controller.trashBookingFiltered.isNotEmpty
        ? controller.trashBookingFiltered
        : controller.trashBookingAll;
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

        return Container(
          color: const Color(0xFFF7F9FC),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    AppText.trashBookings + " (${controller.trashBookingModelData?.total.toString()})",
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
                      DataColumn(
                        label: Checkbox(
                          value: false, // a bool you keep in state
                          onChanged: (val) {},
                        ),
                      ),
                      buildHeaderWithSearch(
                        title: "REF #",
                        onChanged: (v) {
                          controller.trashreferenceNumber.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "DATETIME",
                        onChanged: (v) {
                          controller.trashpickupDate.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "CUSTOMER",
                        onChanged: (v) {
                          controller.trashname.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "PICKUP",
                        onChanged: (v) {
                          controller.trashpickup.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "DROPOFF",
                        onChanged: (v) {
                          controller.trashdropOff.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "ACC",
                        onChanged: (v) {
                          controller.trashaccountName.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "DRV",
                        onChanged: (v) {
                          controller.trashdriverName.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),

                      buildHeaderWithSearch(
                        title: "VEH",
                        onChanged: (v) {
                          controller.trashvehicleTypeName.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),

                      buildHeaderWithSearch(
                        title: "FARE",
                        onChanged: (v) {
                          controller.trashfares.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "STATUS",
                        onChanged: (v) {
                          controller.trashbookingStatus.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "J/T",
                        onChanged: (v) {
                          controller.trashjourneyType.text = v;
                          controller.trashBookingonSearch();
                        },
                      ),

                      buildHeaderWithSearch(
                          title: "ACTIONS", removeSearching: true),
                    ],
                    totalRow: listToShow.length,
                    rows: listToShow.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Checkbox(
                              value: false,
                              onChanged: (val) {},
                            ),
                          ),
                          DataCell(
                              Center(child: Text(item.referenceNumber ?? ''))),
                          DataCell(Center(
                              child: Text(
                                  "${DateFormat('dd-MM-yyyy').format(item.pickupDate!)} ${item.pickupTime}"))),
                          DataCell(Center(child: Text((item.name ?? '').toUpperCase()))),
                          DataCell(Center(child: Text((item.pickup ?? '').toUpperCase()))),
                          DataCell(Center(child: Text((item.dropoff ?? '').toUpperCase()))),
                          DataCell(Center(
                              child: Text((item.account?.name ?? '').toUpperCase()))),
                          DataCell(Center(
                              child: Text((item.driver?.name ?? '').toUpperCase()))),

                          DataCell(Center(
                              child: Text((item.vehicleType?.name ?? '').toUpperCase()))),

                          DataCell(Center(
                              child: Text(item.fares?.toString() ?? ''))),
                          DataCell(Center(
                              child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: DynamicColors.statusColor),
                                  child: Text((item.bookingStatus?.bookingStatus.toString() ?? '').toUpperCase(),
                                      style: TextStyle(color: DynamicColors.whiteClr))))),
                          DataCell(Center(
                              child:
                                  Text((item.journeyType?.journeyType ?? '').toUpperCase()))),

                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.transparent),
                                  ),
                                  onPressed: () {},
                                  child: Icon(Icons.edit_calendar, size: 28),
                                ),
                                Text("|"),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.transparent),
                                  ),
                                  onPressed: () {},
                                  child: Icon(Icons.delete_forever, size: 28),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              PaginationWidget(
                  currentPage: controller.trashBookingCurrentPage.value,
                  totalPages: controller.trashBookingTotalPages.value,
                  onPageChange: controller.trashBookingPageChange),
            ],
          ),
        );
      });
    });
  }
}
