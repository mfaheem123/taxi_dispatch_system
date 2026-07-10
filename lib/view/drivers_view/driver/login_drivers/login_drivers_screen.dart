


import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/pagination.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../controller/driver_controller.dart';

class LoginDriversScreen extends StatefulWidget {
  const LoginDriversScreen({super.key});

  @override
  State<LoginDriversScreen> createState() => _LoginDriversScreenState();
}

class _LoginDriversScreenState extends State<LoginDriversScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

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
          selectedRowIndex =
              (selectedRowIndex + 1) % totalRows; // move down
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
    final listToShow = controller.driverLoginFilter.isNotEmpty
        ? controller.driverLoginFilter
        : controller.driverLoginAll;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 400;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
            ? maxWidth / 2
            : maxWidth / 4;
          return GetBuilder<DriverController>(

            initState: (state) {
              controller.getDriverLoginLogout();
            },
              builder: (controller) {
                return

                  controller.driverLoginLogoutModel == null? CircularProgressIndicator():
                  SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(AppText.loggedInDrivers+" (${controller.driverLoginLogoutModel!.count.toString() ?? 0})",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.w800,
                                fontSize: 17
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Obx(() => Checkbox(
                            value: controller.activeLogout.value,
                            onChanged: (v) {
                              controller.activeLogout.value = v!;
                              controller.driverloginSearch(); // Refresh data on toggle
                            },
                          )),
                          Text(AppText.loggedOut,
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: DynamicColors.redClr
                            ),
                          ),

                          SizedBox(
                            width: 60,
                          ),
                          CustomButton(
                            height: 40,
                            width: 80,
                            verticalPadding: 0.0,
                            borderRadius: 4,
                            widget: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                              child: Icon(Icons.refresh,
                                color: DynamicColors.whiteClr,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),

                              // buildHeaderWithSearch(title: "USERNAME"),
                              // buildHeaderWithSearch(title: "NAME"),
                              // buildHeaderWithSearch(title: "VEHICLE"),
                              // buildHeaderWithSearch(title: "VEHICLE EXPIRY"),
                              // buildHeaderWithSearch(title: "DRIVER EXPIRY"),
                              // buildHeaderWithSearch(title: "MOT EXPIRY"),
                              // buildHeaderWithSearch(title: "MOT2 EXPIRY"),
                              // buildHeaderWithSearch(title: "INSURANCE EXPIRY"),
                              // buildHeaderWithSearch(title: "LICENSE EXPIRY"),
                              // buildHeaderWithSearch(title: "MOBILE #"),
                              // buildHeaderWithSearch(title: "SUBSIDIARY"),
                              // buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: isMobile || isTablet
                              ? Get.width + 700
                              : Get.width,
                          child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(
                                title: "USERNAME",
                                onChanged: (v) {
                                  controller.searchUsername.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "NAME",
                                onChanged: (v) {
                                  controller.searchName.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "VEHICLE",
                                onChanged: (v) {
                                  controller.searchLoginVehicleName.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "VEHICLE EXPIRY",
                                onChanged: (v) {
                                  controller.searchVehicleloginExpiry.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "DRIVER EXPIRY",
                                onChanged: (v) {
                                  controller.searchDriverloginExpiry.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "MOT EXPIRY",
                                onChanged: (v) {
                                  controller.searchMOTLoginExpiry.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "MOT2 EXPIRY",
                                onChanged: (v) {
                                  controller.searchMOT2LoginExpiry.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "INSURANCE EXPIRY",
                                onChanged: (v) {
                                  controller.searchInsuranceLoginExpiry.value =
                                      v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "LICENSE EXPIRY",
                                onChanged: (v) {
                                  controller.searchLicenseLoginExpiry.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "MOBILE #",
                                onChanged: (v) {
                                  controller.searchMobileLogin.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "DRIVER ACCESS",
                                onChanged: (v) {
                                  controller.searchSubsiDiaryLogin.value = v;
                                  controller.driverloginSearch();
                                },
                              ),
                              // buildHeaderWithSearch(
                              //     title: "ACTIONS", removeSearching: true),
                            ],
                            totalRow: listToShow.length ?? 0,
                            rows: listToShow.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Center(
                                      child: Text(
                                          (item.username ?? "-").toUpperCase()))),
                                  DataCell(Center(
                                      child: Text((item.name ?? "-").toUpperCase()))),
                                  DataCell(Center(
                                      child: Text(
                                          (item.vehicle?.vehicleType?.name ??
                                              "-").toUpperCase()))),
                                  DataCell(Center(
                                      child: Text(item.vehicle?.endDate ??
                                          "-"))),
                                  DataCell(Center(
                                      child:
                                      Text(item.endDate ?? "-"))),
                                  DataCell(Center(
                                      child: Text(
                                          item.motExpiry ?? "-"))),
                                  DataCell(Center(
                                      child: Text(
                                          item.mot2Expiry ?? "-"))),
                                  DataCell(Center(
                                      child: Text(item.insuranceExpiry ??
                                          "-"))),
                                  DataCell(Center(
                                      child: Text(item.licenceExpiry ??
                                          "-"))),
                                  DataCell(Center(
                                      child:
                                      Text(item.mobile ?? "-"))),
                                  DataCell(Center(
                                      child: Text(item.driverAccessToken ??
                                          "-"))),
                                  // DataCell(
                                  //   Center(
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //       MainAxisAlignment.center,
                                  //       children: [
                                  //         OutlinedButton(
                                  //           style: OutlinedButton.styleFrom(
                                  //             side: BorderSide(
                                  //               color: Colors.transparent,
                                  //             ), // border color & thickness
                                  //           ),
                                  //           onPressed: () {
                                  //             controller.getCombineVehicle(
                                  //                 id: item.id);
                                  //           },
                                  //           child: Icon(
                                  //             Icons.edit_calendar,
                                  //             size: 28,
                                  //           ),
                                  //         ),
                                  //         Text("|"),
                                  //         OutlinedButton(
                                  //           style: OutlinedButton.styleFrom(
                                  //             side: BorderSide(
                                  //               color: Colors.transparent,
                                  //             ), // border color & thickness
                                  //           ),
                                  //           onPressed: () {
                                  //             controller.driverLoginLogoutDelete(item.id);
                                  //           },
                                  //           child: Icon(
                                  //             Icons.delete_forever,
                                  //             size: 28,
                                  //             color: DynamicColors.redClr,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
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
              }
          );
        }
      ),
    );
  }
}

