import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/networks/api.dart';
import '../../component/pagination.dart';
import '../../component/responsive_datatable_widget.dart';
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

    List permissions = [];
  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "TrashBooking";
        permissions = Api().sp.read('all_permissions') ?? [];
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
        final double totalAvailableWidth = constraints.maxWidth;

        return Container(
          color: const Color(0xFFF7F9FC),
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width,
              //     child: DatatableWidget(
              //       columns: [
              //         DataColumn(
              //           label: Checkbox(
              //             value: false, // a bool you keep in state
              //             onChanged: (val) {},
              //           ),
              //         ),
              //         buildHeaderWithSearch(
              //           title: "REF #",
              //           onChanged: (v) {
              //             controller.trashreferenceNumber.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //         buildHeaderWithSearch(
              //           title: "DATETIME",
              //           onChanged: (v) {
              //             controller.trashpickupDate.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //         buildHeaderWithSearch(
              //           title: "CUSTOMER",
              //           onChanged: (v) {
              //             controller.trashname.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //         buildHeaderWithSearch(
              //           title: "PICKUP",
              //           onChanged: (v) {
              //             controller.trashpickup.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //         buildHeaderWithSearch(
              //           title: "DROPOFF",
              //           onChanged: (v) {
              //             controller.trashdropOff.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //         buildHeaderWithSearch(
              //           title: "ACC",
              //           onChanged: (v) {
              //             controller.trashaccountName.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //         buildHeaderWithSearch(
              //           title: "DRV",
              //           onChanged: (v) {
              //             controller.trashdriverName.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //
              //         buildHeaderWithSearch(
              //           title: "VEH",
              //           onChanged: (v) {
              //             controller.trashvehicleTypeName.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //
              //         buildHeaderWithSearch(
              //           title: "FARE",
              //           onChanged: (v) {
              //             controller.trashfares.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //         buildHeaderWithSearch(
              //           title: "STATUS",
              //           onChanged: (v) {
              //             controller.trashbookingStatus.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //         buildHeaderWithSearch(
              //           title: "J/T",
              //           onChanged: (v) {
              //             controller.trashjourneyType.text = v;
              //             controller.trashBookingonSearch();
              //           },
              //         ),
              //
              //         buildHeaderWithSearch(
              //             title: "ACTIONS", removeSearching: true),
              //       ],
              //       totalRow: listToShow.length,
              //       rows: listToShow.map((item) {
              //         return DataRow(
              //           cells: [
              //             DataCell(
              //               Checkbox(
              //                 value: false,
              //                 onChanged: (val) {},
              //               ),
              //             ),
              //             DataCell(
              //                 Center(child: Text(item.referenceNumber ?? ''))),
              //             DataCell(Center(
              //                 child: Text(
              //                     "${DateFormat('dd-MM-yyyy').format(item.pickupDate!)} ${item.pickupTime}"))),
              //             DataCell(Center(child: Text((item.name ?? '').toUpperCase()))),
              //             DataCell(Center(child: Text((item.pickup ?? '').toUpperCase()))),
              //             DataCell(Center(child: Text((item.dropoff ?? '').toUpperCase()))),
              //             DataCell(Center(
              //                 child: Text((item.account?.name ?? '').toUpperCase()))),
              //             DataCell(Center(
              //                 child: Text((item.driver?.name ?? '').toUpperCase()))),
              //
              //             DataCell(Center(
              //                 child: Text((item.vehicleType?.name ?? '').toUpperCase()))),
              //
              //             DataCell(Center(
              //                 child: Text(item.fares?.toString() ?? ''))),
              //             DataCell(Center(
              //                 child: Container(
              //                     width: double.infinity,
              //                     height: double.infinity,
              //                     alignment: Alignment.center,
              //                     decoration: BoxDecoration(
              //                         color: DynamicColors.statusColor),
              //                     child: Text((item.bookingStatus?.bookingStatus.toString() ?? '').toUpperCase(),
              //                         style: TextStyle(color: DynamicColors.whiteClr))))),
              //             DataCell(Center(
              //                 child:
              //                     Text((item.journeyType?.journeyType ?? '').toUpperCase()))),
              //
              //             DataCell(
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   if(permissions.contains('update_trash_booking')) OutlinedButton(
              //                     style: OutlinedButton.styleFrom(
              //                       side: BorderSide(color: Colors.transparent),
              //                     ),
              //                     onPressed: () {},
              //                     child: Icon(Icons.edit_calendar, size: 28),
              //                   ),
              //                   Text("|"),
              //                   if(permissions.contains('delete_trash_booking'))  OutlinedButton(
              //                     style: OutlinedButton.styleFrom(
              //                       side: BorderSide(color: Colors.transparent),
              //                     ),
              //                     onPressed: () {},
              //                     child: Icon(Icons.delete_forever, size: 28),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
              ResponsiveDataTableWidget(
                totalWidth: totalAvailableWidth,
                items: listToShow,
                columnConfigs: [
                  TableColumnConfig(
                    title: "checkbox_col", // Unique key ki tarah kaam karega width calculation me
                    sizeType: ColumnSizeType.fixed,
                    fixedWidth: 40.0,
                    removeSearching: true,
                    customHeader: Checkbox(
                      value: false,
                      onChanged: (val) {},
                    ),
                  ),
                  TableColumnConfig(
                      title: "REF #",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.pendingreferenceNumber.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "DATETIME",
                      sizeType: ColumnSizeType.medium,
                      onChanged: (v) {
                        controller.pendingpickupDate.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "CUSTOMER",
                      sizeType: ColumnSizeType.medium,
                      onChanged: (v) {
                        controller.pendingname.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "PICKUP",
                      sizeType: ColumnSizeType.large,
                      onChanged: (v) {
                        controller.pendingpickup.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "DROPOFF",
                      sizeType: ColumnSizeType.large,
                      onChanged: (v) {
                        controller.pendingdropOff.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "ACC",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.pendingaccountName.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "DRV",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.pendingdriverName.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "VEH",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.pendingvehicleTypeName.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "FARE",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.pendingfares.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "STATUS",
                      sizeType: ColumnSizeType.fixed,
                      onChanged: (v) {
                        controller.pendingbookingStatus.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "J/T",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.pendingjourneyType.text = v;
                        controller.pendingBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "ACTIONS",
                      sizeType: ColumnSizeType.small,
                      fixedWidth: 70.0,
                      removeSearching: true),
                ],
                rowBuilder: (item, widths) {
                  String formattedDateTime = "-";
                  if (item.pickupDate != null) {
                    formattedDateTime =
                        "${DateFormat('dd-MM-yyyy').format(item.pickupDate!)} ${item.pickupTime ?? ''}"
                            .trim();
                  }
                  String firstNote =
                  (item.notes != null && item.notes!.isNotEmpty)
                      ? item.notes!.first.note ?? ''
                      : '';
                  return [
                    Checkbox(
                      value: false,
                      onChanged: (val) {},
                    ),
                    item.referenceNumber ?? '',
                    formattedDateTime,
                    (item.name ?? '').toUpperCase(),
                    (item.pickup ?? '').toUpperCase(),
                    (item.dropoff ?? '').toUpperCase(),
                    (item.account?.name ?? '').toUpperCase(),
                    (item.driver?.name ?? '').toUpperCase(),
                    (item.vehicleType?.name ?? '').toUpperCase(),
                    "£${item.fares?.toString() ?? ''}",
                    Container(
                      width: widths["STATUS"]!,
                      height: double.infinity,
                      alignment: Alignment.center,
                      color: DynamicColors.statusColor,
                      child: Text(
                        (item.bookingStatus?.bookingStatus
                            .toString() ??
                            '')
                            .toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: DynamicColors.whiteClr,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    (item.journeyType?.journeyType ?? '')
                        .toUpperCase(),
                    Center(
                      child: SizedBox(
                        width: widths["ACTIONS"]!,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.edit_calendar,
                                  size: 16, color: DynamicColors.primaryClr),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 2),
                            const Text("|",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12)),
                            const SizedBox(width: 2),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.delete_forever,
                                  size: 16, color: DynamicColors.primaryClr),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
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
