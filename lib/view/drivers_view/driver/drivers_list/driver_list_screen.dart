import 'package:dashboard_new1/alert/delete_permission_alert.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/drivers_view/driver/create_driver_form/driver_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../component/datatable_widget.dart';
import '../../../../component/networks/api.dart';
import '../../../../component/responsive_datatable_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../controller/driver_controller.dart';
import '../create_driver_form/driver_form.dart';

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
    controller.getDriverList();
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

  List permissions = [];


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final listToShow = controller.driverFilter.isNotEmpty
        ? controller.driverFilter
        : controller.driverAll;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: _handleKey,
        child: LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isMobile = maxWidth < 400;
          final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

          final double totalAvailableWidth = constraints.maxWidth;

          // Instead of fixed width, we calculate flexible field widths
          final double fieldWidth = isMobile
              ? maxWidth // full width
              : isTablet
                  ? maxWidth / 2
                  : maxWidth / 4;
          return RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: _handleKey,
            child: GetBuilder<DriverController>(
                initState: (v){
                  permissions = Api().sp.read('all_permissions') ?? [];
                },

                builder: (controller) {
              return controller.driverLoading.value == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "DRIVERS" +
                                    " (${controller.listDriverModel?.count})",
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
                                "IN-ACTIVE",
                                style: mozillaTextSemiBoldText(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: DynamicColors.redClr),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: CustomButton(
                                  onTap: () {
                                    controller.getDriverList();
                                  },
                                  height: 40,
                                  width: 80,
                                  verticalPadding: 0.0,
                                  borderRadius: 4,
                                  widget: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    child: Icon(
                                      Icons.refresh,
                                      color: Colors.white,
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
                          ResponsiveDataTableWidget (
                              totalWidth: totalAvailableWidth,
                              items: listToShow,
                              columnConfigs: [
                                TableColumnConfig(title: "USERNAME",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchDriverUserName.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "NAME",
                                    sizeType: ColumnSizeType.large,
                                    onChanged: (v) {
                                      controller.searchDriverName.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "VEHICLE",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchVehicleName.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "VEHICLE EXPIRY",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchVehicleExpiry.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "DRIVER EXPIRY",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchDriverExpiry.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "MOT EXPIRY",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchMOTExpiry.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "MOT2 EXPIRY",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchMOT2Expiry.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "INSURANCE EXPIRY",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchInsuranceExpiry.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "LICENSE EXPIRY",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchLicenseExpiry.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "MOBILE #",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchMobile.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "DRIVER ACCESS",
                                    sizeType: ColumnSizeType.medium,
                                    onChanged: (v) {
                                      controller.searchSubsiDiary.value = v;
                                      controller.driverSearch();
                                    }),
                                TableColumnConfig(title: "ACTIONS",
                                    sizeType: ColumnSizeType.medium,
                                    removeSearching: true),
                              ],
                              rowBuilder: (item, widths) {
                                return [
                                  (item.username ?? '').toUpperCase(),
                                  (item.name ?? '').toUpperCase(),
                                  (item.vehicle?.vehicleType?.name ?? '').toUpperCase(),
                                  item.vehicle?.endDate ?? '',
                                  item.endDate ?? '',
                                  item.motExpiry ?? '',
                                  item.mot2Expiry ?? '',
                                  item.insuranceExpiry ?? '',
                                  item.licenceExpiry ?? '',
                                  item.mobile ?? '',
                                  (item.driverAccessToken ?? '').toUpperCase(),
                                  Center(
                                    child: SizedBox(
                                      width: widths["ACTIONS"]!,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if(permissions.contains('update_driver'))
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              icon: Icon(Icons.edit_calendar,
                                                  size: 16, color: DynamicColors.primaryClr),
                                              onPressed: () {
                                                controller.getCombineVehicle(id: item.id);
                                              },
                                            ),
                                          const SizedBox(width: 2),
                                          const Text("|",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          const SizedBox(width: 2),
                                          if(permissions.contains('delete_driver'))
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              icon: Icon(Icons.delete_forever,
                                                  size: 16, color: DynamicColors.redClr),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      DeletePermissionAlert(
                                                        deleteFunctionName: () =>
                                                            controller.deleteDriver(item.id!),
                                                      ),
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ];
                              }
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
        }));
  }
}
