import 'package:dashboard_new1/view/booking_view/reusable_widget.dart';
import 'package:dashboard_new1/view/booking_view/update_booking.dart';
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
import '../../routes/app_pages.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'controller.dart';


class WebBooking extends StatefulWidget {
  const WebBooking({super.key});

  @override

  State<WebBooking> createState() => _WebBookingState();
}

class _WebBookingState extends State<WebBooking> {

  BookingController controller = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "WebBooking";
    controller.getWebBookingData();
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = controller.webBookingFiltered.isNotEmpty
        ? controller.webBookingFiltered
        : controller.webBookingAll;
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

                return Container(
                  color: const Color(0xFFF7F9FC),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(AppText.webBookings+ " (${controller.webBookingModelData?.total.toString()})",
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
                          controller.getWebBookingData();
                        },
                        height: 40,
                        width: 80,
                        verticalPadding: 0.0,
                        borderRadius: 4,
                        widget: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                          child:
                          controller.webBookingLoad.value? Icon(
                Icons.circle_outlined,
                color: DynamicColors.whiteClr,
                size: 25,
                ) :
                          Icon(
                            Icons.refresh,
                            color: DynamicColors.whiteClr,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                        ],
                      ),SizedBox(
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
                      //         child: KeyboardDatePicker(
                      //           initialDate: DateTime.now(),
                      //           borderClr: Colors.blue,
                      //           onChanged: (date) {
                      //             // jab bhi user change kare
                      //             setState(() {
                      //               print(date);
                      //             });
                      //           },
                      //           onSubmitted: (date) {
                      //             // jab user enter press kare
                      //             print("User pressed enter: $date");
                      //           },
                      //         ),
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
                      //       onTap: (){
                      //
                      //       },
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
                      //         value: controller.waitingValue.value,
                      //         onChanged: (v){
                      //           controller.waitingValue.value = v!;
                      //           controller.update();
                      //         },
                      //         text: AppText.waiting
                      //     ),
                      //     customWidget(
                      //         value: controller.preDispatchValue.value,
                      //         onChanged: (v){
                      //           controller.preDispatchValue.value = v!;
                      //           controller.update();
                      //         },
                      //         text: AppText.preDispatch
                      //     ),
                      //     CustomButton(
                      //       width: 130,
                      //       height: 30,
                      //       borderRadius: 4,
                      //       btnColor: DynamicColors.redClr,
                      //       verticalPadding: 0.0,
                      //       fontSize: 11,
                      //       btnText: AppText.cancelled,
                      //     ),
                      //     CustomButton(
                      //       width: 150,
                      //       height: 30,
                      //       borderRadius: 4,
                      //       verticalPadding: 0.0,
                      //       fontSize: 11,
                      //       btnColor: DynamicColors.redClr,
                      //       btnText: AppText.deleteSelected,
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
                                  controller.webreferenceNumber.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "DATETIME",
                                onChanged: (v) {
                                  controller.webpickupDate.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "CUSTOMER",
                                onChanged: (v) {
                                  controller.webname.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "PICKUP",
                                onChanged: (v) {
                                  controller.webpickup.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "DROPOFF",
                                onChanged: (v) {
                                  controller.webdropOff.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "ACC",
                                onChanged: (v) {
                                  controller.webaccountName.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "DRV",
                                onChanged: (v) {
                                  controller.webdriverName.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "P/T",
                                onChanged: (v) {
                                  controller.webpaymentType.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "VEH",
                                onChanged: (v) {
                                  controller.webvehicleTypeName.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "NOT",
                                onChanged: (v) {
                                  controller.webnotes.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "FARE",
                                onChanged: (v) {
                                  controller.webfares.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "STATUS",
                                onChanged: (v) {
                                  controller.webbookingStatus.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "J/T",
                                onChanged: (v) {
                                  controller.webjourneyType.text = v;
                                  controller.onSearchpreBooking();
                                },
                              ),
                              buildHeaderWithSearch(title: "SUBS",

                                onChanged: (v) {
                                  controller.websubsidiary.text = v;
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
                          currentPage: controller.webBookingCurrentPage.value,
                          totalPages: controller.webBookingTotalPages.value,
                          onPageChange: controller.webBookingPageChange),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}