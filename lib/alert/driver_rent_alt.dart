import 'package:dashboard_new1/alert/update_driver_rent_email.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../component/action_icon_button.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/textStyle.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../view/drivers_view/controller/driver_controller.dart';
import '../view/drivers_view/driver/driver_commission/update_driver_rent.dart';

class DriverRentAlt {
  static void show({required int id}) async {
    final controller = Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : Get.put(DriverController());
    final DashboardController _controller = Get.find();

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: GetBuilder<DriverController>(builder: (controller) {
          bool isLaptop = Get.width <= 1400;
          double headerFontSize = isLaptop ? 12 : 16;
          double cellFontSize = isLaptop ? 11 : 14;
          double iconSize = isLaptop ? 15 : 18;

          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: Get.width * 0.95,
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
                        Text("DRIVER RENT OF DRIVER (${controller.driverRentAlert?.count ?? 0})",
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

                  controller.isLoadingDriverRent
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
                                    buildCenterColumn("RENT TOTAL", headerFontSize),
                                    buildCenterColumn("PREVIOUS BALANCE", headerFontSize),
                                    buildCenterColumn("CURRENT BALANCE", 18),
                                    buildCenterColumn("ACTIONS", headerFontSize),
                                  ],
                                  totalRow: controller.driverRentAlert!.driverRents?.length,
                                  rows: controller.driverRentAlert!.driverRents
                                      ?.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(
                                            child: Text((item.transactionNumber ?? "-").toUpperCase(),
                                                style: outFitRegular(fontSize: cellFontSize)))),
                                        DataCell(Center(
                                            child: Text(item.transactionDate?.toIso8601String().split('T')[0] ??
                                                    "-",
                                                style: outFitRegular(fontSize: cellFontSize)))),
                                        DataCell(Center(
                                            child: Text(item.driverId.toString() ?? "-",
                                                style: outFitRegular(fontSize: cellFontSize)))),
                                        DataCell(Center(
                                            child: Text("£${item.jobsTotal ?? "0"}",
                                                style: outFitRegular(fontSize: cellFontSize)))),
                                        DataCell(Center(
                                            child: Text("£${item.rentTotal ?? "0"}",
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
                                            ActionIconButton(
                                              icon: Icons.edit,
                                              size: iconSize,
                                              color: Color(0xFF43489A),
                                              onPressed: () {
                                                Get.back();
                                                controller.getDriverRentData(
                                                    selectedId: item.id);
                                                int index = _controller.selectedMenuItems
                                                    .indexWhere((element) => element.title ==
                                                        "DRIVER RENT UPDATE");
                                                if (index != -1) {
                                                  _controller.selectedMenuItems[index]
                                                      .selectedItem = true;
                                                  _controller.currentPage.value =
                                                      UpdateDriverRentScreen();
                                                } else {
                                                  _controller.currentPage.value = UpdateDriverRentScreen();
                                                  _controller.menuBarRefresh(
                                                      title: "DRIVER RENT UPDATE",
                                                      pageName: UpdateDriverRentScreen());
                                                }
                                                controller.update();
                                              },
                                            ),
                                            Text("|"),
                                            ActionIconButton(
                                                icon: Icons.delete,
                                                size: iconSize,
                                                color: Colors.red,
                                                onPressed: () {
                                                  Get.back();
                                                  controller.driverRentDelete(
                                                      item.id);
                                                }),
                                            Text("|"),
                                            ActionIconButton(
                                                icon: Icons.picture_as_pdf,
                                                size: iconSize,
                                                color: Colors.black,
                                                onPressed: () {
                                                  // Get.back();
                                                  controller.exportPdf(
                                                      selectedId: item.id);
                                                }),
                                            Text("|"),
                                            ActionIconButton(
                                                icon: Icons.mail,
                                                size: iconSize,
                                                color: Colors.black,
                                                onPressed: () {
                                                  Get.back();
                                                  EmailDriverRentAlt.show();
                                                }),
                                          ],
                                        ))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              )),
                        )),
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
