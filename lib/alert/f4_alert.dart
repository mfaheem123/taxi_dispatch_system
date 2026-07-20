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

  // Local dates controllers
  late DateTime localFromDate;
  late DateTime localToDate;

  @override
  void initState() {
    super.initState();

    localFromDate = DateTime.now();
    localToDate = DateTime.now();

    controller.fetchRestrictedDrivers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 950,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(() {

          if (controller.isRestrictedDriverLoading.value) {
            return const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final drivers = controller.fetchDriver?.drivers ?? [];
          final currentDriver = controller.selectedDriver.value;

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
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, size: 22, color: Colors.grey),
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
                              initialDate: localFromDate,
                              onChanged: (date) => setState(() => localFromDate = date),
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
                              initialDate: localToDate,
                              onChanged: (date) => setState(() => localToDate = date),
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
                          itemLabel: (driver) => "${driver.id} ${driver.name ?? ''}".trim().toUpperCase(),
                          onChanged: (val) {
                            controller.selectedDriver.value = val;
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
                            setState(() {
                              localFromDate = DateTime.now();
                              localToDate = DateTime.now();
                              controller.selectedDriver.value = null;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: AppText.drivers.toString().toUpperCase()),
                            buildHeaderWithSearch(title: "TOTAL BOOKINGS", removeSearching: true),
                            buildHeaderWithSearch(title: "TOTAL EARNINGS", removeSearching: true),
                            buildHeaderWithSearch(title: "", removeSearching: true),
                          ],
                          totalRow: 1,
                          rows: [
                            DataRow(
                              cells: [
                                DataCell(
                                  Center(
                                    child: Text(
                                      currentDriver != null
                                          ? "${currentDriver.id} ${currentDriver.name ?? ''}".trim().toUpperCase()
                                          : "NO DRIVER SELECTED",
                                      style: mozillaTextRegularText(fontSize: 13, color: Colors.black87),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      "0",
                                      style: mozillaTextRegularText(fontSize: 13, color: Colors.black87),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      "£0.00",
                                      style: mozillaTextRegularText(fontSize: 13, color: Colors.black87),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: CustomButton(
                                      onTap: () {
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}