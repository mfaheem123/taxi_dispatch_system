import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/booking_view/reusable_widget.dart';
import 'package:dashboard_new1/view/booking_view/update_booking.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
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

  List permissions = [];

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "WebBooking";
    permissions = Api().sp.read('all_permissions') ?? [];
    controller.getWebBookingData();
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = controller.webBookingFiltered.isNotEmpty
        ? controller.webBookingFiltered
        : controller.webBookingAll;
    return PageScrollWrapper(
      child: GetBuilder<BookingController>(
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

                  final double totalAvailableWidth = constraints.maxWidth;

                  return
                    controller.webBookingLoad == true? Center(child: CircularProgressIndicator(),):
                    Container(
                    color: const Color(0xFFF7F9FC),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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


                        ResponsiveDataTableWidget(
                          totalWidth: totalAvailableWidth,
                          items: listToShow,
                          columnConfigs: [
                            TableColumnConfig(
                                title: "REF #",
                                sizeType: ColumnSizeType.small,
                                onChanged: (v) {
                                  controller.webreferenceNumber.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "DATETIME",
                                sizeType: ColumnSizeType.medium,
                                onChanged: (v) {
                                  controller.webpickupDate.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "CUSTOMER",
                                sizeType: ColumnSizeType.medium,
                                onChanged: (v) {
                                  controller.webname.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "PICKUP",
                                sizeType: ColumnSizeType.large,
                                onChanged: (v) {
                                  controller.webpickup.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "DROPOFF",
                                sizeType: ColumnSizeType.large,
                                onChanged: (v) {
                                  controller.webdropOff.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "ACC",
                                sizeType: ColumnSizeType.small,
                                onChanged: (v) {
                                  controller.webaccountName.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "DRV",
                                sizeType: ColumnSizeType.small,
                                onChanged: (v) {
                                  controller.webdriverName.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "P/T",
                                sizeType: ColumnSizeType.small,
                                onChanged: (v) {
                                  controller.webpaymentType.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "VEH",
                                sizeType: ColumnSizeType.small,
                                onChanged: (v) {
                                  controller.webvehicleTypeName.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "NOTE",
                                sizeType: ColumnSizeType.medium,
                                onChanged: (v) {
                                  controller.webnotes.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "FARE",
                                sizeType: ColumnSizeType.small,
                                onChanged: (v) {
                                  controller.webfares.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "STATUS",
                                sizeType: ColumnSizeType.fixed,
                                onChanged: (v) {
                                  controller.webbookingStatus.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "J/T",
                                sizeType: ColumnSizeType.small,
                                onChanged: (v) {
                                  controller.webjourneyType.text = v;
                                  controller.webBookingonSearch();
                                }),
                            TableColumnConfig(
                                title: "SUBS",
                                sizeType: ColumnSizeType.small,
                                onChanged: (v) {
                                  controller.websubsidiary.text = v;
                                  controller.webBookingonSearch();
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
                                      const SizedBox(width: 2),
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
                                                    controller.getWebBookingData();
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
                            currentPage: controller.webBookingCurrentPage.value,
                            totalPages: controller.webBookingTotalPages.value,
                            onPageChange: controller.webBookingPageChange),
                      ],
                    ),
                  );
                }
            );
          }
      ),
    );
  }
}