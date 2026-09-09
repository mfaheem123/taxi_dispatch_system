import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../view/dashboard_view/Controller/booking_dispatch_controller.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class DispatchBooking extends StatefulWidget {
  final dynamic bookingItem;
  const DispatchBooking({super.key, this.bookingItem});

  @override
  State<DispatchBooking> createState() => _DispatchBookingState();
}

class _DispatchBookingState extends State<DispatchBooking> {

  final controller = Get.put(DispatchController());
  final _controller = Get.find<DashboardController>();

  final FocusNode closeButtonFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  controller.getDispatchDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.only(top: 100, left: 40, right: 40),
      backgroundColor: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
          child: Container(
            // padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: DynamicColors.gryClr.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child:
                Row(
                  children: [
                    Icon(Icons.near_me_rounded, color: DynamicColors.primaryClr),
                    const SizedBox(width: 10),
                    RichText(
                      text: TextSpan(
                        style: mozillaTextSemiBoldText(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          const TextSpan(text: "DISPATCH BOOKING ("),
                          TextSpan(
                            text: widget.bookingItem?.referenceNumber ?? "N/A",
                            style: TextStyle(color: DynamicColors.primaryClr, fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ")"),
                        ],
                      ),
                    ),
                    // Text("DISPATCH BOOKING ${widget.bookingItem?.referenceNumber ?? "N/A"}",
                    //     style: mozillaTextSemiBoldText(
                    //         fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: closeButtonFocusNode,
                      builder: (context, child) {
                        final isFocused = closeButtonFocusNode.hasFocus;
                        return Container(
                          decoration: BoxDecoration(shape: BoxShape.circle,
                            border: Border.all(color: isFocused ? DynamicColors.primaryClr : Colors.transparent,
                              width: 2,
                            ),
                            color: isFocused ? DynamicColors.primaryClr.withOpacity(0.15) : Colors.transparent,
                          ),
                          child: IconButton(
                            focusNode: closeButtonFocusNode,
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close, size: 22, color: Colors.grey),
                            splashRadius: 20,
                          ),
                        );
                      },
                    ),
                  ],
                )),
                const Divider(height: 30, thickness: 1),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.person, size: 20, color: Colors.black87),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("SELECT DRIVER TO DISPATCH",
                        style: mozillaTextSemiBoldText(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                    Text("CHOOSE A DRIVER, THEN PRESS DISPATCH",
                      style: mozillaTextRegularText(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    ]),
                    const Spacer(),
                    // const SizedBox(width: 40),
                    CustomButton(
                      width: 195, height: 36, verticalPadding: 0.0, borderRadius: 6,
                      btnText: "CALCULATE DISTANCE",
                      style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.white),
                      onTap: () {},
                    ),
                  ],
                )),
                const SizedBox(height: 15),
                // Data Table Section with GetX Obx
                Obx(() {
                  // if (controller.isLoading.value) {
                  //   return const SizedBox(
                  //     height: 200,
                  //     child: Center(child: CircularProgressIndicator()),
                  //   );
                  // }
                  //
                  // if (controller.drivers.isEmpty) {
                  //   return const SizedBox(
                  //     height: 100,
                  //     child: Center(child: Text("No Drivers Found")),
                  //   );
                  // }

                  return Column(
                    children: [
                    SingleChildScrollView(
                    // scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 45,
                      columnSpacing: 25,
                      headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                      columns: [
                        _buildDataColumn("USERNAME", Icons.badge_outlined),
                        _buildDataColumn("DRIVER NAME", Icons.person_outline),
                        _buildDataColumn("SUBSIDIARY", Icons.apartment_rounded),
                        _buildDataColumn("STATUS", Icons.bar_chart_rounded),
                        _buildDataColumn("ATTRIBUTES", Icons.local_offer_outlined),
                        _buildDataColumn("DISTANCE", Icons.alt_route_rounded),
                        _buildDataColumn("ACTION", Icons.bolt_rounded),
                      ],
                      rows: controller.drivers.map((driver) {
                        return DataRow(
                          cells: [
                            DataCell(Text("${(driver.username ?? '').toUpperCase()}", style: mozillaTextRegularText(fontSize: 14))),
                            DataCell(Text((driver.name ?? '').toUpperCase(), style: mozillaTextRegularText(fontSize: 14))),
                            DataCell(Text((driver.subsidiary?.name ?? '').toUpperCase(), style: mozillaTextRegularText(fontSize: 14))),
                            DataCell(Text(driver.bookingStatus ?? '', style: mozillaTextRegularText(fontSize: 14, color: Colors.green))),
                            DataCell(Center(child: Text("-", style: mozillaTextRegularText(fontSize: 14)))),
                            DataCell(Center(child: Text("-", style: mozillaTextRegularText(fontSize: 14)))),
                            DataCell(
                              Center(
                                child: CustomButton(
                                  width: 80, height: 28, verticalPadding: 0.0, borderRadius: 4,
                                  btnText: "DISPATCH",
                                  style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.white),
                                  onTap: () {
                                    print(widget.bookingItem.id);
                                   controller.assignDriverToBooking(widget.bookingItem.id, driver.id);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    ),
                      if (controller.isLoading.value)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (controller.drivers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: Text("NO DRIVERS FOUND")),
                        ),
                    ],
                  );
                }),



                const SizedBox(height: 20),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Focus(
                      child: Builder(
                        builder: (context) {
                          final isFocused = Focus.of(context).hasFocus;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () => Get.back(),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isFocused ? Colors.grey.shade300 : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isFocused ? DynamicColors.primaryClr : Colors.grey.shade300,
                                    width: isFocused ? 2 : 1,
                                  ),
                                  boxShadow: isFocused
                                      ? [
                                    BoxShadow(
                                      color: DynamicColors.primaryClr.withOpacity(0.3),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    )
                                  ]
                                      : [],
                                ),
                                child: Text(
                                  "CLOSE",
                                  style: mozillaTextSemiBoldText(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                    // InkWell(
                    //   onTap: () => Get.back(),
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey.shade200,
                    //       borderRadius: BorderRadius.circular(6),
                    //       border: Border.all(color: Colors.grey.shade300),
                    //     ),
                    //     child: Text(
                    //       "CLOSE",
                    //       style: mozillaTextSemiBoldText(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ]),
      ),
    )));
  }

  // Column Helper
  DataColumn _buildDataColumn(String label, IconData icon) {
    return DataColumn(
      label: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black87),
      const SizedBox(width: 6),
      Text(label, style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 16)),
      ]),
    );
  }
}