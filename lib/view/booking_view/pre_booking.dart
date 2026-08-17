import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/booking_view/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../alert/delete_permission_alert.dart';
import '../../alert/restrict_drivers_alert.dart';
import '../../component/color.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/pagination.dart';
import '../../component/responsive_datatable_widget.dart';
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
  final int totalRows =
      50; // total rows (dynamic list ke hisaab se change hoga)

  List permissions = [];

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "PreBooking";
    permissions = Api().sp.read('all_permissions') ?? [];
    controller.getDashboardTableData();
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = controller.preBookingFiltered.isNotEmpty
        ? controller.preBookingFiltered
        : controller.preBookingAll;
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

        return controller.preBookingLoad == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: const Color(0xFFF7F9FC),
          padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppText.preBookings +
                              " (${controller.dashboardTableModelData?.total.toString()})",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: CustomButton(
                            onTap: () {
                              controller.getDashboardTableData();
                              print("Refresh-------------------");
                            },
                            height: 40,
                            width: 80,
                            verticalPadding: 0.0,
                            borderRadius: 4,
                            widget: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0.0),
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

                    ResponsiveDataTableWidget(
                      totalWidth: totalAvailableWidth,
                      items: listToShow,
                      columnConfigs: [
                        TableColumnConfig(
                            title: "REF #",
                            sizeType: ColumnSizeType.small,
                            onChanged: (v) {
                              controller.referenceNumber.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "DATETIME",
                            sizeType: ColumnSizeType.medium,
                            onChanged: (v) {
                              controller.pickupDate.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "CUSTOMER",
                            sizeType: ColumnSizeType.medium,
                            onChanged: (v) {
                              controller.name.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "PICKUP",
                            sizeType: ColumnSizeType.large,
                            onChanged: (v) {
                              controller.pickup.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "DROPOFF",
                            sizeType: ColumnSizeType.large,
                            onChanged: (v) {
                              controller.dropOff.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "ACC",
                            sizeType: ColumnSizeType.small,
                            onChanged: (v) {
                              controller.accountName.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "DRV",
                            sizeType: ColumnSizeType.small,
                            onChanged: (v) {
                              controller.driverName.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "P/T",
                            sizeType: ColumnSizeType.small,
                            onChanged: (v) {
                              controller.paymentType.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "VEH",
                            sizeType: ColumnSizeType.small,
                            onChanged: (v) {
                              controller.vehicleTypeName.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "NOTE",
                            sizeType: ColumnSizeType.medium,
                            onChanged: (v) {
                              controller.notes.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "FARE",
                            sizeType: ColumnSizeType.small,
                            onChanged: (v) {
                              controller.fares.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "STATUS",
                            sizeType: ColumnSizeType.fixed,
                            onChanged: (v) {
                              controller.bookingStatus.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "J/T",
                            sizeType: ColumnSizeType.small,
                            onChanged: (v) {
                              controller.journeyType.text = v;
                              controller.onSearchpreBooking();
                            }),
                        TableColumnConfig(
                            title: "SUBS",
                            sizeType: ColumnSizeType.small,
                            onChanged: (v) {
                              controller.subsidiary.text = v;
                              controller.onSearchpreBooking();
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
                                        size: 22, color: DynamicColors.primaryClr),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 2),
                                  const Text("|",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12)),
                                  const SizedBox(width: 1),
                                  if(permissions.contains('delete_booking'))  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(Icons.delete_forever,
                                        size: 22, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                            DeletePermissionAlert(
                                              deleteFunctionName: () async {
                                                await controller.deleteBooking(item.id);
                                                controller.getDashboardTableData();
                                              },
                                            ),
                                      );
                                    },
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
