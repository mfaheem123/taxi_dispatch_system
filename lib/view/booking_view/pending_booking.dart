


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

class PendingBooking extends StatefulWidget {
  const PendingBooking({super.key});

  @override
  State<PendingBooking> createState() => _PendingBookingState();
}

class _PendingBookingState extends State<PendingBooking> {

  BookingController controller = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "pendingBooking";
    controller.getPendingBookingData();
  }

  @override
  Widget build(BuildContext context) {

    final listToShow = controller.pendingBookingFiltered.isNotEmpty
        ? controller.pendingBookingFiltered
        : controller.pendingBookingAll;

    return GetBuilder<BookingController>(
      initState: (state) {

      },
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
                  controller.pendingBookingLoad == true? Center(child: CircularProgressIndicator()):
                  Container(
                  color: const Color(0xFFF7F9FC),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     Text(AppText.pendingBookings+" (10)",
                      //       style: mozillaTextSemiBoldText(
                      //           fontWeight: FontWeight.w800,
                      //           fontSize: 17
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 20,
                      //     ),
                      //
                      //     Container(
                      //       decoration: BoxDecoration(
                      //           color: DynamicColors.primaryClr,
                      //           borderRadius: BorderRadius.circular(8)
                      //       ),
                      //       child: IconButton(
                      //           padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                      //           onPressed: (){
                      //
                      //           }, icon: Icon(Icons.refresh,
                      //         color: DynamicColors.whiteClr,
                      //         size: 25,
                      //       )),
                      //     )
                      //   ],
                      // ),SizedBox(
                      //   height: 10,
                      // ),
                      // Wrap(
                      //   spacing: 10,
                      //   runSpacing: 16,
                      //   crossAxisAlignment: WrapCrossAlignment.center,
                      //   children: [
                      //     CustomTextField(
                      //       controller: controller.enterKeyboardController,
                      //       hintText: AppText.enterKeyboard,
                      //       height: 30,
                      //       width: fieldWidth/2.5,
                      //       borderRadius: 4,
                      //     ),
                      //     RestrictedDrivers(
                      //       width: fieldWidth/3,
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
                      //       width: fieldWidth/2.3,
                      //       child: SizedBox(
                      //         height: 30,
                      //         child: KeyboardDatePicker(),
                      //       ),
                      //     ),
                      //     labeledField(
                      //       context: context,
                      //       isMobile: isMobile,
                      //       label: AppText.time,
                      //       width: fieldWidth/3.0,
                      //       child: SizedBox(height: 30, child: CustomTimePicker()),
                      //     ),
                      //     Text(AppText.to,
                      //       style: mozillaTextRegularText(
                      //           fontSize: 15
                      //       ),
                      //     ),
                      //     labeledField(
                      //       context: context,
                      //       isMobile: isMobile,
                      //       label: AppText.date,
                      //       width: fieldWidth/2.3,
                      //       child: SizedBox(
                      //         height: 30,
                      //         child: KeyboardDatePicker(),
                      //       ),
                      //     ),
                      //     labeledField(
                      //       context: context,
                      //       isMobile: isMobile,
                      //       label: AppText.time,
                      //       width: fieldWidth/3,
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
                      //         onChanged: (v){
                      //           controller.completeValue.value = v!;
                      //           controller.update();
                      //         }
                      //     ),
                      //     customWidget(
                      //         value: controller.cancelledValue.value,
                      //         onChanged: (v){
                      //           controller.cancelledValue.value = v!;
                      //           controller.update();
                      //         },
                      //         text: AppText.cancelled
                      //     ),
                      //     customWidget(
                      //         value: controller.incompleteValue.value,
                      //         onChanged: (v){
                      //           controller.incompleteValue.value = v!;
                      //           controller.update();
                      //         },
                      //         text: AppText.incomplete
                      //     ),
                      //     customWidget(
                      //         value: controller.missedValue.value,
                      //         onChanged: (v){
                      //           controller.missedValue.value = v!;
                      //           controller.update();
                      //         },
                      //         text: AppText.missed
                      //     ),
                      //     customWidget(
                      //         value: controller.declinedValue.value,
                      //         onChanged: (v){
                      //           controller.declinedValue.value = v!;
                      //           controller.update();
                      //         },
                      //         text: AppText.declined
                      //     ),
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
                              buildHeaderWithSearch(title: "REF #",
                                onChanged: (v) {
                                  controller.pendingreferenceNumber.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "DATETIME",
                                onChanged: (v) {
                                  controller.pendingpickupDate.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),

                              buildHeaderWithSearch(title: "CUSTOMER",
                                onChanged: (v) {
                                  controller.pendingname.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "PICKUP",
                                onChanged: (v) {
                                  controller.pendingpickup.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "DROPOFF",
                                onChanged: (v) {
                                  controller.pendingdropOff.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "ACC",
                                onChanged: (v) {
                                  controller.pendingaccountName.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "DRV",
                                onChanged: (v) {
                                  controller.pendingdriverName.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "P/T",
                                onChanged: (v) {
                                  controller.pendingpaymentType.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "VEH",
                                onChanged: (v) {
                                  controller.pendingvehicleTypeName.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "NOTE",
                                onChanged: (v) {
                                  controller.pendingnotes.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "FARE",
                                onChanged: (v) {
                                  controller.pendingfares.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "STATUS",
                                onChanged: (v) {
                                  controller.pendingbookingStatus.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "J/T",
                                onChanged: (v) {
                                  controller.pendingjourneyType.text = v;
                                  controller.pendingBookingonSearch();
                                },
                              ),
                              buildHeaderWithSearch(title: "SUBS",

                                onChanged: (v) {
                                  controller.pendingsubsidiary.text = v;
                                  controller.pendingBookingonSearch();
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
                        currentPage: controller.pendingBookingCurrentPage.value,
                        totalPages: controller.pendingBookingTotalPages.value,
                        onPageChange: controller.pendingBookingPageChange,),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}