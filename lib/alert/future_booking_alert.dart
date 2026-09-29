import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../view/dashboard_view/Controller/booking_dispatch_controller.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

void showFutureBookingAlert(dynamic bookingItem, {bool isDispatch = false}) {
  Get.dialog(
    FutureBookingAlert(bookingItem: bookingItem),
    barrierColor: Colors.black54,
  );
}

class FutureBookingAlert extends StatefulWidget {
  final dynamic bookingItem;
  const FutureBookingAlert({super.key, this.bookingItem});

  @override
  State<FutureBookingAlert> createState() => _FutureBookingAlertState();
}

class _FutureBookingAlertState extends State<FutureBookingAlert> {
  final controller = Get.put(DispatchController());

  @override
  void initState() {
    super.initState();
    controller.getDispatchDrivers();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isSmallScreen = screenSize.width < 600;
    final dialogWidth = screenSize.width < 900
        ? screenSize.width * 0.96
        : (screenSize.width * 0.9).clamp(0.0, 1200.0);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 24,
        vertical: 12,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(maxHeight: screenSize.height * 0.92),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Icon(Icons.near_me_rounded, color: DynamicColors.primaryClr),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: mozillaTextSemiBoldText(
                          fontSize: isSmallScreen ? 14 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: "DISPATCH FUTURE BOOKING ("),
                          TextSpan(
                            text: widget.bookingItem?.referenceNumber ?? "N/A",
                            style: outFitRegular(
                              color: DynamicColors.primaryClr,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: ")"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(999),
                    child: const AlertCloseButton(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 10 : 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: isSmallScreen ? 10 : 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.person, size: 20, color: Colors.black87),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "SELECT DRIVER TO DISPATCH",
                                    style: mozillaTextSemiBoldText(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "CHOOSE A DRIVER, THEN PRESS DISPATCH",
                                    style: outFitRegular(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Obx(() {
                        return Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowHeight: 45,
                                columnSpacing: isSmallScreen ? 12 : 25,
                                headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                                border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                                columns: [
                                  _buildDataColumn("USERNAME", Icons.badge_outlined, isSmallScreen),
                                  _buildDataColumn("DRIVER NAME", Icons.person_outline, isSmallScreen),
                                  _buildDataColumn("VEHICLE", Icons.car_rental_sharp, isSmallScreen),
                                  _buildDataColumn("STATUS", Icons.bar_chart_rounded, isSmallScreen),
                                  _buildDataColumn("ATTRIBUTES", Icons.local_offer_outlined, isSmallScreen),
                                  _buildDataColumn("ACTION", Icons.bolt_rounded, isSmallScreen),
                                ],
                                rows: controller.drivers.map((driver) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text("${(driver.username ?? '').toUpperCase()}", style: outFitRegular(fontSize: isSmallScreen ? 12 : 14)))),
                                      DataCell(Center(child: Text((driver.name ?? '').toUpperCase(), style: outFitRegular(fontSize: isSmallScreen ? 12 : 14)))),
                                      DataCell(Center(child: Text((driver.vehicle?.vehicleType?.name ?? '').toUpperCase(), style: outFitRegular(fontSize: isSmallScreen ? 12 : 14)))),
                                      DataCell(Center(child: Text((driver.bookingStatus ?? '').toUpperCase(), style: outFitRegular(fontSize: isSmallScreen ? 12 : 14, color: Colors.green)))),
                                      DataCell(Center(child: Text("-", style: outFitRegular(fontSize: isSmallScreen ? 12 : 14)))),
                                      DataCell(
                                        Center(
                                          child: CustomButton(
                                            width: 80,
                                            height: 28,
                                            verticalPadding: 0.0,
                                            borderRadius: 4,
                                            btnText: "DISPATCH",
                                            style: mozillaTextSemiBoldText(fontSize: 13, color: Colors.white),
                                            onTap: () {
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
                                child: Center(child: Text("No drivers found")),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  width: 65,
                  height: 30,
                  btnText: "CLOSE",
                  btnColor: Colors.red,
                  verticalPadding: 0.0,
                  borderRadius: 6,
                  onTap: () => Get.back(),
                  style: mozillaTextSemiBoldText(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label, IconData icon, bool isSmallScreen) {
    return DataColumn(
      label: Row(
        children: [
          Icon(icon, size: isSmallScreen ? 14 : 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(label, style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 12 : 16)),
        ],
      ),
    );
  }
}
