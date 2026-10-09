import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/administration/controller/administration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../page_scroller.dart';
import 'controller/extension_controller.dart';
import 'controller/setting_controller.dart';

class BookingClearingUtilityScreen extends StatefulWidget {
  const BookingClearingUtilityScreen({super.key});

  @override
  State<BookingClearingUtilityScreen> createState() =>
      _BookingClearingUtilityScreenState();
}

class _BookingClearingUtilityScreenState
    extends State<BookingClearingUtilityScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "BookingClearingUtilityScreen";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return PageScrollWrapper(
      child: GetBuilder<SettingController>(initState: (state) {
      controller.getBookingsToClear();
    }, builder: (controller) {
      if (controller.isLoadingBooking || controller.clearBookingModel == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final bookings = controller.clearBookingModel!.bookings ?? [];

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

        return Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: DynamicColors.gryClr.withOpacity(0.5),
              child: Row(
                children: [
                  Text(
                    "${AppText.clearBooking} (${controller?.clearBookingModel!.count.toString()})",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  Spacer(),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: screenWidth / 15,
                    height: 40,
                    borderRadius: 4,
                    btnText: AppText.clearSelected,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {
                      controller.clearSelectedBookings();
                    },
                  ),
                  SizedBox(width: 12),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: screenWidth / 15,
                    height: 40,
                    borderRadius: 4,
                    btnText: AppText.clearAll,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {
                      controller.clearAllBookings();
                    },
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
             // scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: Get.width,
                child: DatatableWidget(
                  columns: [
                    DataColumn(
                      label: Checkbox(
                        value: bookings.isNotEmpty && controller.selectedBookingIds.length == bookings.length,
                        onChanged: (val) {
                          if (val == true) {
                            controller.selectedBookingIds = bookings.map((b) => b.id.toString()).toList();
                          } else {
                            controller.selectedBookingIds.clear();
                          }
                          controller.update();
                        },
                      ),
                    ),
                    buildHeaderWithSearch(title: "REF #",
                        onChanged: (v) {
                      controller.searchRefNo.value = v;
                      controller.onSearchBooking();
                    }),
                    buildHeaderWithSearch(title: "DATEtIME",
                        onChanged: (v) {
                      controller.searchDateTime.value = v;
                      controller.onSearchBooking();
                    }),
                    buildHeaderWithSearch(title: "CUSTOMER",
                        onChanged: (v) {
                      controller.searchCustomer.value = v;
                      controller.onSearchBooking();
                    }),
                    buildHeaderWithSearch(title: "PICKUP",
                        onChanged: (v) {
                      controller.searchPickup.value = v;
                      controller.onSearchBooking();
                    }),
                    buildHeaderWithSearch(title: "DROPOFF",
                        onChanged: (v) {
                      controller.searchDropOff.value = v;
                      controller.onSearchBooking();
                    }),
                    buildHeaderWithSearch(title: "DRIVER",
                        onChanged: (v) {
                      controller.searchDriver.value = v;
                      controller.onSearchBooking();
                    }),
                    buildHeaderWithSearch(title: "STATUS",
                        onChanged: (v) {
                      controller.searchStatus.value = v;
                      controller.onSearchBooking();
                    }),
                  ],
                  rows: bookings.map((booking) {
                    final bookingId = booking.id.toString();
                    final isSelected = controller.selectedBookingIds.contains(bookingId);

                    return DataRow(
                      cells: [
                        DataCell(
                          Center(child:
                          Checkbox(
                            value: isSelected,
                            onChanged: (val) {
                              controller.toggleSelection(bookingId);
                            },
                          ),
                        )),
                        DataCell(Center(child: Text((booking.referenceNumber ?? "").toUpperCase()))),
                        DataCell(Center(child: Text(
                            "${booking.pickupDate ?? ""} ${booking.pickupTime ?? ""}"))),
                        DataCell(Center(child: Text((booking.name ?? "").toUpperCase()))),
                        DataCell(Center(child: Text((booking.pickup ?? "").toUpperCase()))),
                        DataCell(Center(child: Text((booking.dropoff ?? "").toUpperCase()))),
                        DataCell(Center(child: Text((booking.driver?.name ?? "N/A").toUpperCase()))),
                        DataCell(Center(child: Text((booking.bookingStatus?.bookingStatus ?? "").toUpperCase()))),
                        ],
                    );
                  }).toList(),
                ),
              ),
            )),
          ],
        );
      });
    }));
  }
}
