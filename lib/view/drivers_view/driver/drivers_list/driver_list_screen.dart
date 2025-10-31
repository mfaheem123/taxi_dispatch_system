import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../component/datatable_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../controller/driver_controller.dart';

class DriverListScreen extends StatefulWidget {
  DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "driversList";
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          selectedRowIndex = (selectedRowIndex + 1) % totalRows; // move down
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          selectedRowIndex =
              (selectedRowIndex - 1 + totalRows) % totalRows; // move up
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        // Enter dabane par row ke action button ka kaam
        debugPrint("Row $selectedRowIndex Enter Pressed (Search/Delete)");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<DriverController>(builder: (controller) {
        final listToShow = controller.driverFilter.isNotEmpty
            ? controller.driverFilter
            : controller.driverAll;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppText.drivers + " (${controller.listDriverModel?.count})",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Checkbox(
                    value: controller.activeDrivers.value,
                    onChanged: (v) {
                      controller.activeDrivers.value = v!;
                      controller.getDriverList();
                    },
                  ),
                  Text(
                    AppText.active,
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: DynamicColors.redClr),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: CustomButton(
                      onTap: () => controller.getDriverList(),
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
                height: 12,
              ),
              controller.driverLoading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width,
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(
                              title: "USERNAME",
                              onChanged: (v) {
                                controller.searchDriverUserName.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "NAME",
                              onChanged: (v) {
                                controller.searchDriverName.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "VEHICLE",
                              onChanged: (v) {
                                controller.searchVehicleName.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "VEHICLE EXPIRY",
                              onChanged: (v) {
                                controller.searchVehicleExpiry.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "DRIVER EXPIRY",
                              onChanged: (v) {
                                controller.searchDriverExpiry.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "MOT EXPIRY",
                              onChanged: (v) {
                                controller.searchMOTExpiry.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "MOT2 EXPIRY",
                              onChanged: (v) {
                                controller.searchMOT2Expiry.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "INSURANCE EXPIRY",
                              onChanged: (v) {
                                controller.searchInsuranceExpiry.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "LICENSE EXPIRY",
                              onChanged: (v) {
                                controller.searchLicenseExpiry.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "MOBILE #",
                              onChanged: (v) {
                                controller.searchMobile.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "SUBSIDIARY",
                              onChanged: (v) {
                                controller.searchSubsiDiary.value = v;
                                controller.driverSearch();
                              },
                            ),
                            buildHeaderWithSearch(
                                title: "ACTIONS", removeSearching: true),
                          ],
                          totalRow: listToShow.length ?? 0,
                          rows: listToShow.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(Center(
                                    child: Text(item.username ?? "no data"))),
                                DataCell(Center(
                                    child: Text(item.name ?? "no data"))),
                                DataCell(Center(
                                    child: Text(
                                        item.vehicle?.vehicleType?.name ??
                                            "no data"))),
                                DataCell(Center(
                                    child: Text(
                                        item.vehicle?.endDate ?? "no data"))),
                                DataCell(Center(
                                    child: Text(item.endDate ?? "no data"))),
                                DataCell(Center(
                                    child: Text(item.motExpiry ?? "no data"))),
                                DataCell(Center(
                                    child: Text(item.mot2Expiry ?? "no data"))),
                                DataCell(Center(
                                    child: Text(
                                        item.insuranceExpiry ?? "no data"))),
                                DataCell(Center(
                                    child:
                                        Text(item.licenceExpiry ?? "no data"))),
                                DataCell(Center(
                                    child: Text(item.mobile ?? "no data"))),
                                DataCell(Center(
                                    child: Text(
                                        item.subsidiary?.name ?? "no data"))),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: Colors.transparent,
                                            ), // border color & thickness
                                          ),
                                          onPressed: () {},
                                          child: Icon(
                                            Icons.edit_calendar,
                                            size: 28,
                                          ),
                                        ),
                                        Text("|"),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: Colors.transparent,
                                            ), // border color & thickness
                                          ),
                                          onPressed: () {},
                                          child: Icon(
                                            Icons.delete_forever,
                                            size: 28,
                                            color: DynamicColors.redClr,
                                          ),
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
                currentPage: controller.driverCurrentPage.value,
                totalPages: controller.driverTotalPage.value,
                onPageChange: controller.driverPage,
              ),
            ],
          ),
        );
      }),
    );
  }
}
