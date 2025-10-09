
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../component/datatable_widget.dart';
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
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "AppBooking";
  }

  @override
  Widget build(BuildContext context) {
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
                          Text(AppText.appBookings+" (10)",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.w800,
                                fontSize: 17
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),

                          Container(
                            decoration: BoxDecoration(
                                color: DynamicColors.primaryClr,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: IconButton(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                                onPressed: (){

                                }, icon: Icon(Icons.refresh,
                              color: DynamicColors.whiteClr,
                              size: 25,
                            )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // 📋 Data Table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                        DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: "SOURCE"),
                            buildHeaderWithSearch(title: "REF #"),
                            buildHeaderWithSearch(title: "DATETIME"),
                            buildHeaderWithSearch(title: "CUSTOMER"),
                            buildHeaderWithSearch(title: "PICKUP"),
                            buildHeaderWithSearch(title: "DROPOFF"),
                            buildHeaderWithSearch(title: "ACC"),
                            buildHeaderWithSearch(title: "DRV"),
                            buildHeaderWithSearch(title: "P/T"),
                            buildHeaderWithSearch(title: "VEH"),
                            buildHeaderWithSearch(title: "NOT"),
                            buildHeaderWithSearch(title: "FARE"),
                            buildHeaderWithSearch(title: "STATUS"),
                            buildHeaderWithSearch(title: "J/T"),
                            buildHeaderWithSearch(title: "SUBS"),
                            buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                          ],
                          totalRow: totalRows,
                          cells: [
                            const DataCell(Text("OPT")),
                            const DataCell(Text("BCB75058")),
                            const DataCell(Text("09-09-25 07:16")),
                            const DataCell(Text("09-09-25 07:16")),
                            const DataCell(Text("NADEEM")),
                            const DataCell(Text("FLAT 12 BLANDFORD COURT 4-6 BRO")),
                            const DataCell(Text("NORTHWICK AVENUE HARROW HA3")),
                            const DataCell(Text("CASH")),
                            const DataCell(Text("CASH")),
                            const DataCell(Text("SAL.")),
                            const DataCell(Text("NOTE")),
                            const DataCell(Text("£ 0.00")),
                            const DataCell(Text("WAITING")),
                            const DataCell(Text("o/w")),
                            const DataCell(Text("DEMO ACCOUNT")),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,   // 👈 remove inner padding
                                      minimumSize: Size(24, 24),  // 👈 shrink button size
                                      side: BorderSide.none,      // 👈 remove border
                                    ),
                                    onPressed: () {},
                                    child: Icon(Icons.edit_calendar, size: 20),
                                  ),
                                  const SizedBox(width: 4), // 👈 replace "|" with small spacing
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(24, 24),
                                      side: BorderSide.none,
                                    ),
                                    onPressed: () {},
                                    child: Icon(Icons.delete_forever, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}