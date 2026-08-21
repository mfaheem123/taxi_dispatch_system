import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/datatable_widget.dart';
import '../controller/dashboard_alert_controller.dart';
import '../view/customer/model/restricDriver.dart';
import '../view/dashboard_view/booking_table.dart';
import '../view/dashboard_view/widgets/time_picker_widget.dart';
import '../view/dashboard_view/widgets/user_info_widget.dart';
import 'f4_get_booking.dart';

void showDriverEarningsAlert() {
  Get.dialog(
    const DriverEarningsAlert(),
    barrierColor: Colors.black54,
  );
}

class DriverEarningsAlert extends StatefulWidget {
  const DriverEarningsAlert({super.key});

  @override
  State<DriverEarningsAlert> createState() => _DriverEarningsAlertState();
}

class _DriverEarningsAlertState extends State<DriverEarningsAlert> {

  final controller = Get.isRegistered<DashboardAlertController>()
      ? Get.find<DashboardAlertController>()
      : Get.put(DashboardAlertController());

  final FocusNode closeButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.fetchRestrictedDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: FocusScope(
        autofocus: true,
        child: Container(
        width: 950,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: GetBuilder<DashboardAlertController>(
          builder: (controller) {

            if (controller.isRestrictedDriverLoading.value) {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final drivers = controller.fetchDriver?.drivers ?? [];
            final currentDriver = controller.selectedDriver.value;
            final earningModel = controller.driverEarningModel;
            final displayedDriver = controller.displayedDriver;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        AppText.driverEarning,
                        style: mozillaTextSemiBoldText(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      AnimatedBuilder(
                        animation: closeButtonFocusNode,
                        builder: (context, child) {
                          final isFocused = closeButtonFocusNode.hasFocus;
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isFocused ? DynamicColors.primaryClr : Colors.transparent,
                                width: 2,
                              ),
                              color: isFocused ? DynamicColors.primaryClr.withOpacity(0.15) : Colors.transparent,
                            ),
                            child: IconButton(
                              focusNode: closeButtonFocusNode,
                              onPressed: () {
                                controller.clearEarnings();
                                Get.back();
                              },
                              icon: const Icon(Icons.close, size: 22, color: Colors.grey),
                              splashRadius: 20,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [

                          labeledField(
                            context: context,
                            isMobile: false,
                            label: "FROM:",
                            column: false,
                            width: 150,
                            child: SizedBox(
                              height: 30,
                              child: KeyboardDatePicker(
                                initialDate: controller.fromDate.value ?? DateTime(DateTime.now().year, DateTime.now().month, 1),
                                onChanged: (date) {
                                  controller.fromDate.value = date;
                                },
                              ),
                            ),
                          ),

                          labeledField(
                            context: context,
                            isMobile: false,
                            label: "TO:",
                            column: false,
                            width: 150,
                            child: SizedBox(
                              height: 30,
                              child: KeyboardDatePicker(
                                initialDate: controller.toDate.value ?? DateTime.now(),
                                onChanged: (date) => controller.toDate.value = date,
                              ),
                            ),
                          ),

                          CustomDropdownField<DriverObject>(
                            label: "SELECT DRIVERS",
                            width: 280,
                            height: 35,
                            items: drivers,
                            value: drivers.any((d) => d.id == currentDriver?.id)
                                ? drivers.firstWhere((d) => d.id == currentDriver?.id)
                                : null,
                            itemLabel: (driver) => "${driver.username} ${driver.name ?? ''}".trim().toUpperCase(),
                            onChanged: (val) {
                              controller.selectedDriver.value = val;
                              controller.update();
                            },
                          ),

                          CustomButton(
                            verticalPadding: 0.0,
                            width: 90,
                            height: 35,
                            borderRadius: 4,
                            btnText: AppText.view,
                            btnColor: DynamicColors.greenClr,
                            style: mozillaTextSemiBoldText(
                              fontSize: 12,
                              color: DynamicColors.whiteClr,
                              fontWeight: FontWeight.w600,
                            ),
                            onTap: () {
                              controller.getDriverEarnings();
                            },
                          ),

                          CustomButton(
                            verticalPadding: 0.0,
                            width: 90,
                            height: 35,
                            borderRadius: 4,
                            btnText: AppText.clear,
                            btnColor: DynamicColors.redClr,
                            style: mozillaTextSemiBoldText(
                              fontSize: 12,
                              color: DynamicColors.whiteClr,
                              fontWeight: FontWeight.w600,
                            ),
                            onTap: () {
                              controller.clearEarnings();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // TABLE SECTION
                      SizedBox(
                        width: double.infinity,
                        child: controller.isDriverEarningLoading
                            ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                            : SingleChildScrollView(
                          child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(title: AppText.drivers.toString().toUpperCase(), removeSearching: true),
                              buildHeaderWithSearch(title: "TOTAL BOOKINGS", removeSearching: true),
                              buildHeaderWithSearch(title: "TOTAL EARNINGS", removeSearching: true),
                              buildHeaderWithSearch(title: "", removeSearching: true),
                            ],
                            totalRow: earningModel != null ? 1 : 0,
                            rows: earningModel != null
                                ? [
                              DataRow(
                                cells: [
                                  DataCell(
                                    Center(
                                      child: Text(
                                        displayedDriver != null
                                            ? "${displayedDriver.id} ${displayedDriver.name ?? ''}".trim().toUpperCase()
                                            : "NO DRIVER SELECTED",
                                        style: mozillaTextRegularText(fontSize: 13, color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        earningModel.totalBookings?.toString() ?? "0",
                                        style: mozillaTextRegularText(fontSize: 13, color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "£${earningModel.totalEarnings?.toStringAsFixed(2) ?? "0.00"}",
                                        style: mozillaTextRegularText(fontSize: 13, color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: CustomButton(
                                        onTap: () {
                                          if (earningModel.bookings != null && earningModel.bookings!.isNotEmpty) {
                                            DriverBookingsAlert.show(earningModel.bookings!);
                                          } else {
                                            BotToast.showText(text: "NO BOOKINGS FOUND");
                                          }
                                        },
                                        width: 90,
                                        height: 28,
                                        btnText: "BOOKINGS",
                                        btnColor: DynamicColors.primaryClr,
                                        borderRadius: 4,
                                        verticalPadding: 0.0,
                                        style: mozillaTextSemiBoldText(
                                          fontSize: 10,
                                          color: DynamicColors.whiteClr,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                                : [],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      )),
    );
  }
}