





import 'package:dashboard_new1/view/booking_view/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/color.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
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
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "PreBooking";
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
                          Text(AppText.preBookings+" (10)",
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