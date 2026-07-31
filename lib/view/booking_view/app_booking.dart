import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/pagination.dart';
import '../../component/responsive_datatable_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'controller.dart';

class AppBooking extends StatefulWidget {
  const AppBooking({super.key});

  @override
  State<AppBooking> createState() => _AppBookingState();
}

class _AppBookingState extends State<AppBooking> {
  BookingController controller = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows =
      50; // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "AppBooking";
    controller.getAppBookingData();

  }

  @override
  Widget build(BuildContext context) {
    final listToShow = controller.appBookingFiltered.isNotEmpty
        ? controller.appBookingFiltered
        : controller.appBookingAll;
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

        return
          controller.appBookingLoad == true? CircularProgressIndicator():
          Container(
          color: const Color(0xFFF7F9FC),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    AppText.appBookings + " (${controller.appBookingModelData?.total.toString()})",
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
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
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

              ResponsiveDataTableWidget(
                totalWidth: totalAvailableWidth,
                items: listToShow,
                columnConfigs: [
                  TableColumnConfig(
                      title: "REF #",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.appreferenceNumber.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "DATETIME",
                      sizeType: ColumnSizeType.medium,
                      onChanged: (v) {
                        controller.apppickupDate.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "CUSTOMER",
                      sizeType: ColumnSizeType.medium,
                      onChanged: (v) {
                        controller.appname.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "PICKUP",
                      sizeType: ColumnSizeType.large,
                      onChanged: (v) {
                        controller.apppickup.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "DROPOFF",
                      sizeType: ColumnSizeType.large,
                      onChanged: (v) {
                        controller.appdropOff.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "ACC",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.appaccountName.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "DRV",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.appdriverName.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "P/T",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.apppaymentType.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "VEH",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.appvehicleTypeName.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "NOTE",
                      sizeType: ColumnSizeType.medium,
                      onChanged: (v) {
                        controller.appnotes.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "FARE",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.appfares.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "STATUS",
                      sizeType: ColumnSizeType.fixed,
                      onChanged: (v) {
                        controller.appbookingStatus.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "J/T",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.appjourneyType.text = v;
                        controller.appBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "SUBS",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.appsubsidiary.text = v;
                        controller.appBookingonSearch();
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
                    item.referenceNumber ?? '',
                    formattedDateTime,
                    (item.name ?? '').toUpperCase(),
                    (item.pickup ?? '').toUpperCase(),
                    (item.dropoff ?? '').toUpperCase(),
                    (item.account?.name ?? '').toUpperCase(),
                    (item.driver?.name ?? '').toUpperCase(),
                    (item.paymentType?.name ?? '').toUpperCase(),
                    (item.vehicleType?.name ?? '').toUpperCase(),
                    firstNote.toUpperCase(),
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
                    (item.subsidiary?.name ?? '').toUpperCase(),
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
                  currentPage: controller.preBookingCurrentPage.value,
                  totalPages: controller.preBookingTotalPages.value,
                  onPageChange: controller.preBookingPageChange),
            ],
          ),
        );
      });
    });
  }
}
