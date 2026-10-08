import 'package:dashboard_new1/alert/update_driver_commission_email.dart';
import 'package:dashboard_new1/component/action_icon_button.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/networks/api.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../view/drivers_view/controller/driver_controller.dart';
import '../view/drivers_view/driver/driver_commission/update_driver_commission.dart';

class DriverCommissionAlt {
  static void show({required int id}) async {
    final controller = Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : Get.put(DriverController());
    final DashboardController _controller = Get.find();
    List permissions = [];
    permissions = Api().sp.read('all_permissions') ?? [];

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        backgroundColor: Colors.transparent,
        child: GetBuilder<DriverController>(builder: (controller) {
          bool isLaptop = Get.width <= 1400;
          double headerFontSize = isLaptop ? 12 : 16;
          double cellFontSize = isLaptop ? 11 : 14;
          double iconSize = isLaptop ? 15 : 18;

          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: Get.width * 0.98,
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
                    child: Row(
                      children: [
                        Text("DRIVER COMMISSION OF DRIVER (${controller.driverCommissionAlert!.count})",
                          style: titleDesign(),
                        ),
                        const Spacer(),
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(999),
                          child: const AlertCloseButton(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  SizedBox(height: 15),

                  controller.isLoadingDriverCommission
                      ? const Center(child: CircularProgressIndicator())
                      : Flexible(
                      child: SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: Get.width,
                            child: DatatableWidget(
                              columns: [
                                buildCenterColumn("TRANSACTION #", headerFontSize),
                                buildCenterColumn("TRANSACTION DATE", headerFontSize),
                                buildCenterColumn("DRIVER", headerFontSize),
                                buildCenterColumn("JOB TOTAL", headerFontSize),
                                buildCenterColumn("COMMISSION TOTAL", headerFontSize),
                                buildCenterColumn("PREVIOUS BALANCE", headerFontSize),
                                buildCenterColumn("CURRENT BALANCE", 18),
                                buildCenterColumn("ACTIONS", headerFontSize),
                              ],
                              totalRow: controller.driverCommissionAlert!.driverCommissions?.length,
                              rows: controller.driverCommissionAlert!.driverCommissions?.map((item) {
                                return DataRow(
                                  cells: [
                                    DataCell(Center(
                                        child: Text((item.transactionNumber ?? "-").toUpperCase(),
                                            style: outFitRegular(fontSize: cellFontSize)))),
                                    DataCell(Center(
                                        child: Text(
                                            item.transactionDate?.toIso8601String().split('T')[0] ??
                                                "-",
                                            style: outFitRegular(fontSize: cellFontSize)))),
                                    DataCell(Center(
                                        child: Text(item.driverId.toString() ?? "-",
                                            style: outFitRegular(fontSize: cellFontSize)))),
                                    DataCell(Center(
                                        child: Text("£${item.jobsTotal ?? "0"}",
                                            style: outFitRegular(fontSize: cellFontSize)))),
                                    DataCell(Center(
                                        child: Text("£${item.commissionTotal ?? "0"}",
                                            style: outFitRegular(fontSize: cellFontSize)))),
                                    DataCell(Center(
                                        child: Text("£${item.oldBalance ?? "0"}",
                                            style: outFitRegular(fontSize: cellFontSize)))),
                                    DataCell(Center(
                                        child: Text("£${item.currentBalance ?? "0"}",
                                            style: outFitRegular(fontSize: cellFontSize)))),
                                    DataCell(Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (permissions.contains('update_driver_commission'))
                                              ActionIconButton(
                                                icon: Icons.edit,
                                                size: iconSize,
                                                color: Color(0xFF43489A),
                                                onPressed: () {
                                                  Get.back();
                                                  controller.getDriverCommissionData(selectedId: item.id);
                                                  int index = _controller.selectedMenuItems
                                                      .indexWhere((element) => element.title ==
                                                      "DRIVER COMMISSION UPDATE");
                                                  if (index != -1) {
                                                    _controller.selectedMenuItems[index]
                                                        .selectedItem = true;
                                                    _controller.currentPage.value =
                                                        UpdateDriverCommissionScreen();
                                                  } else {
                                                    _controller.currentPage.value =
                                                        UpdateDriverCommissionScreen();
                                                    _controller.menuBarRefresh(
                                                        title: "DRIVER COMMISSION UPDATE",
                                                        pageName: UpdateDriverCommissionScreen());
                                                  }
                                                  controller.update();
                                                },
                                              ),
                                            Text("|"),
                                            if (permissions.contains('delete_driver_commission'))
                                              ActionIconButton(
                                                  icon: Icons.delete,
                                                  color: Colors.red,
                                                  size: iconSize,
                                                  onPressed: () {
                                                    Get.back();
                                                    controller.driverCommissionDelete(item.id);
                                                    controller.getDriverCommission();
                                                  }),
                                            Text("|"),
                                            ActionIconButton(
                                                icon: Icons.picture_as_pdf,
                                                size: iconSize,
                                                color: Colors.black,
                                                onPressed: () {
                                                  // Get.back();
                                                  controller.exportToPdf(selectedId: item.id);
                                                }),
                                            Text("|"),
                                            ActionIconButton(
                                                icon: Icons.mail,
                                                size: iconSize,
                                                color: Colors.black,
                                                onPressed: () {
                                                  // Get.back();
                                                  EmailDriverCommissionAlt.show();
                                                }),
                                          ],
                                        ))),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  static DataColumn buildCenterColumn(String label, double fontSize) {
    return DataColumn(
      label: Expanded(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: outFitRegular(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
