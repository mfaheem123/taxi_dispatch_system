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

              ResponsiveDataTableWidget(
                totalWidth: totalAvailableWidth,
                items: listToShow,
                columnConfigs: [
                  TableColumnConfig(
                    title: "checkbox_col",
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
                        controller.trashreferenceNumber.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "DATETIME",
                      sizeType: ColumnSizeType.medium,
                      onChanged: (v) {
                        controller.trashpickupDate.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "CUSTOMER",
                      sizeType: ColumnSizeType.medium,
                      onChanged: (v) {
                        controller.trashname.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "PICKUP",
                      sizeType: ColumnSizeType.large,
                      onChanged: (v) {
                        controller.trashpickup.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "DROPOFF",
                      sizeType: ColumnSizeType.large,
                      onChanged: (v) {
                        controller.trashdropOff.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "ACC",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.trashaccountName.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "DRV",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.trashdriverName.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "VEH",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.trashvehicleTypeName.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "FARE",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.trashfares.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "STATUS",
                      sizeType: ColumnSizeType.fixed,
                      onChanged: (v) {
                        controller.trashbookingStatus.text = v;
                        controller.trashBookingonSearch();
                      }),
                  TableColumnConfig(
                      title: "J/T",
                      sizeType: ColumnSizeType.small,
                      onChanged: (v) {
                        controller.trashjourneyType.text = v;
                        controller.trashBookingonSearch();
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
                            if(permissions.contains('update_trash_booking'))
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.edit_calendar,
                                  size: 22, color: DynamicColors.primaryClr),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 2),
                            const Text("|",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12)),
                            const SizedBox(width: 2),
                            if(permissions.contains('delete_trash_booking'))
                              IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.delete_forever,
                                  size: 22, color: DynamicColors.primaryClr),
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
