import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/booking_view/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/pagination.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'controller.dart';

class CompleteBookingsScreen extends StatefulWidget {
  const CompleteBookingsScreen({super.key});

  @override
  State<CompleteBookingsScreen> createState() => _CompleteBookingsScreenState();
}

class _CompleteBookingsScreenState extends State<CompleteBookingsScreen> {
  BookingController controller = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows =
      50; // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "completeBookingsScreen";
    controller.getcompletedBookingData();
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = controller.completedBookingFiltered.isNotEmpty
        ? controller.completedBookingFiltered
        : controller.completedBookingAll;
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
          controller.completedBookingLoad == true? Center(child: CircularProgressIndicator()):
          SingleChildScrollView(
          child: Container(
            color: const Color(0xFFF7F9FC),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      AppText.completeBooking + " (${controller.completedBookingModelData?.total.toString()})",
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
                // Wrap(
                //   spacing: 10,
                //   runSpacing: 16,
                //   crossAxisAlignment: WrapCrossAlignment.center,
                //   children: [
                //     CustomTextField(
                //       controller: controller.enterKeyboardController,
                //       hintText: AppText.enterKeyboard,
                //       height: 30,
                //       width: fieldWidth / 2.5,
                //       borderRadius: 4,
                //     ),
                //     RestrictedDrivers(
                //       width: fieldWidth / 3,
                //       height: 30,
                //       padding: 0.0,
                //       titleText: "REFERENCE:",
                //       driversList: [
                //         'NAME',
                //         'EMAIL',
                //         'MOBILE',
                //         'TELEPHONE',
                //         'PICKUP',
                //         'DROPOFF',
                //         'ACCOUNT',
                //         'DRIVER',
                //       ],
                //     ),
                //     labeledField(
                //       context: context,
                //       isMobile: isMobile,
                //       label: AppText.date,
                //       width: fieldWidth / 2.3,
                //       child: SizedBox(
                //         height: 30,
                //         child: KeyboardDatePicker(),
                //       ),
                //     ),
                //     labeledField(
                //       context: context,
                //       isMobile: isMobile,
                //       label: AppText.time,
                //       width: fieldWidth / 3.0,
                //       child: SizedBox(height: 30, child: CustomTimePicker()),
                //     ),
                //     Text(
                //       AppText.to,
                //       style: mozillaTextRegularText(fontSize: 15),
                //     ),
                //     labeledField(
                //       context: context,
                //       isMobile: isMobile,
                //       label: AppText.date,
                //       width: fieldWidth / 2.3,
                //       child: SizedBox(
                //         height: 30,
                //         child: KeyboardDatePicker(),
                //       ),
                //     ),
                //     labeledField(
                //       context: context,
                //       isMobile: isMobile,
                //       label: AppText.time,
                //       width: fieldWidth / 3,
                //       child: SizedBox(height: 30, child: CustomTimePicker()),
                //     ),
                //     // SizedBox(
                //     //   width: fieldWidth/3,
                //     // ),
                //     CustomButton(
                //       width: 100,
                //       height: 30,
                //       borderRadius: 4,
                //       btnColor: DynamicColors.redClr,
                //       verticalPadding: 0.0,
                //       fontSize: 11,
                //       btnText: AppText.clear,
                //     ),
                //     CustomButton(
                //       width: 100,
                //       height: 30,
                //       borderRadius: 4,
                //       verticalPadding: 0.0,
                //       fontSize: 11,
                //       btnText: AppText.search,
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Wrap(
                //   spacing: 10,
                //   runSpacing: 16,
                //   children: [
                //     customWidget(
                //         value: controller.completeValue.value,
                //         onChanged: (v) {
                //           controller.completeValue.value = v!;
                //           controller.update();
                //         }),
                //     customWidget(
                //         value: controller.cancelledValue.value,
                //         onChanged: (v) {
                //           controller.cancelledValue.value = v!;
                //           controller.update();
                //         },
                //         text: AppText.cancelled),
                //     customWidget(
                //         value: controller.incompleteValue.value,
                //         onChanged: (v) {
                //           controller.incompleteValue.value = v!;
                //           controller.update();
                //         },
                //         text: AppText.incomplete),
                //     customWidget(
                //         value: controller.missedValue.value,
                //         onChanged: (v) {
                //           controller.missedValue.value = v!;
                //           controller.update();
                //         },
                //         text: AppText.missed),
                //     customWidget(
                //         value: controller.declinedValue.value,
                //         onChanged: (v) {
                //           controller.declinedValue.value = v!;
                //           controller.update();
                //         },
                //         text: AppText.declined),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),

                // 📋 Data Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "SOURCE",
                          onChanged: (v) {
                            controller.completedSource.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),  buildHeaderWithSearch(title: "REF #",
                          onChanged: (v) {
                            controller.completedreferenceNumber.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "DATETIME",
                          onChanged: (v) {
                            controller.completedpickupDate.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),

                        buildHeaderWithSearch(title: "CUSTOMER",
                          onChanged: (v) {
                            controller.completedname.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "PICKUP",
                          onChanged: (v) {
                            controller.completedpickup.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "DROPOFF",
                          onChanged: (v) {
                            controller.completeddropOff.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "ACC",
                          onChanged: (v) {
                            controller.completedaccountName.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "DRV",
                          onChanged: (v) {
                            controller.completeddriverName.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "P/T",
                          onChanged: (v) {
                            controller.completedpaymentType.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "VEH",
                          onChanged: (v) {
                            controller.completedvehicleTypeName.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "NOTE",
                          onChanged: (v) {
                            controller.completednotes.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "FARE",
                          onChanged: (v) {
                            controller.completedfares.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "STATUS",
                          onChanged: (v) {
                            controller.completedbookingStatus.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "J/T",
                          onChanged: (v) {
                            controller.completedjourneyType.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),
                        buildHeaderWithSearch(title: "SUBS",

                          onChanged: (v) {
                            controller.completedsubsidiary.text = v;
                            controller.completedBookingonSearch();
                          },
                        ),

                        buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                      ],
                      totalRow: listToShow.length,
                      rows: listToShow.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Center(child: Text(item.bookingSource ?? '—'))),
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
                            DataCell(Center(child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
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
                                      onPressed: () {},
                                      child: Icon(Icons.edit_calendar,
                                          size: 28),
                                    ),
                                    Text("|"),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.transparent),
                                      ),
                                      onPressed: () {},
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
                    currentPage: controller.completedBookingCurrentPage.value,
                    totalPages: controller.completedBookingTotalPages.value,
                    onPageChange: controller.completedBookingPageChange,),
              ],
            ),
          ),
        );
      });
    });
  }
}
