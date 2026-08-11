import 'package:dashboard_new1/alert/delete_permission_alert.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/view/vehicles_view/model/vehicle_type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../alert/customer_detail_alert.dart';
import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/networks/api.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'controller/controller.dart';
import 'create_vehicle_types.dart';

class ListVehicleType extends StatefulWidget {
  const ListVehicleType({super.key});

  @override
  State<ListVehicleType> createState() => _ListVehicleTypeState();
}

class _ListVehicleTypeState extends State<ListVehicleType> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  VehicleController controller = Get.isRegistered<VehicleController>()
      ? Get.find<VehicleController>()
      : Get.put(VehicleController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "listVehicleType";
    controller.getVehicleTypes();
  }

  final DashboardController _controller = Get.find();

  List permissions = [];




  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<VehicleController>(
      initState: (v){
          permissions = Api().sp.read('all_permissions') ?? [];
      },

        builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final listToShow = controller.filteredVehicleTypes.isNotEmpty
            ? controller.filteredVehicleTypes
            : controller.allVehicleTypes;

        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        return controller.isLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppText.vehicleType +
                              " (${controller.vehicleTypeModel!.count.toString() ?? "0"})",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: CustomButton(
                            height: 40,
                            width: 80,
                            verticalPadding: 0.0,
                            borderRadius: 4,
                            onTap: () {
                              Future.delayed(const Duration(seconds: 10), () {
                                controller.getVehicleTypes();
                                print(
                                    "Refresh ho rha hai -------------- ${controller.getVehicleTypes}");
                              });
                            },
                            widget: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0.0),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width,
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(
                                title: AppText.vehicleType,
                                onChanged: (v) {
                                  controller.searchName.value = v;
                                  controller.onSearchChanged();
                                }),
                            buildHeaderWithSearch(
                                title: "PASSENGERS",
                                onChanged: (v) {
                                  controller.searchPassengers.value = v;
                                  controller.onSearchChanged();
                                }),
                            buildHeaderWithSearch(
                                title: "LUGGAGES",
                                onChanged: (v) {
                                  controller.searchLuggages.value = v;
                                  controller.onSearchChanged();
                                }),
                            buildHeaderWithSearch(
                              title: "HAND LUGGAGES",
                              onChanged: (v) {
                                controller.searchHandLuggages.value = v;
                                controller.onSearchChanged();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "MINIMUM FARES",
                              onChanged: (v) {
                                controller.searchMinFare.value = v;
                                controller.onSearchChanged();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "MINIMUM MILES",
                              onChanged: (v) {
                                controller.searchMinMiles.value = v;
                                controller.onSearchChanged();
                              },
                            ),
                            buildHeaderWithSearch(
                                title: "ACTIONS", removeSearching: true),
                          ],
                          totalRow: listToShow.length ?? 0,
                          rows: (listToShow ?? []).map(
                            (item) {
                              return DataRow(cells: [
                                DataCell(Center(
                                  child:
                                      Text((item.name.toString() ?? 'No Data').toUpperCase()),
                                )),
                                DataCell(Center(
                                    child: Text(item.passengers.toString() ??
                                        'No Data'))),
                                DataCell(Center(
                                    child: Text(item.luggages.toString() ??
                                        'No Data'))),
                                DataCell(Center(
                                    child: Text(item.handLuggages.toString() ??
                                        'No Data'))),
                                DataCell(Center(
                                    child: Text(item.minimumFares.toString() ??
                                        'No Data'))),
                                DataCell(Center(
                                    child: Text(item.minimumMiles.toString() ??
                                        'No Data'))),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(24, 24),
                                            side: BorderSide.none,
                                          ),
                                          onPressed: () {

                                            if(permissions.contains('update_vehicle_type')){

                                              controller.vehicleDataBinding(
                                                  item: item);

                                              int index = _controller
                                                  .selectedMenuItems
                                                  .indexWhere((element) =>
                                              element.title ==
                                                  "UPDATE VEHICLE TYPE");
                                              if (index != -1) {
                                                _controller
                                                    .selectedMenuItems[index]
                                                    .selectedItem = true;
                                                _controller.currentPage.value =
                                                    CreateVehicleTypes();
                                              } else {
                                                _controller.currentPage.value =
                                                    CreateVehicleTypes();
                                                _controller.menuBarRefresh(
                                                    title: "UPDATE VEHICLE TYPE",
                                                    pageName:
                                                    CreateVehicleTypes());
                                              }
                                              controller.update();

                                            }


                                          },
                                          child: Icon(Icons.edit_calendar,
                                              size: 28),
                                        ),
                                        const SizedBox(width: 4),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(24, 24),
                                            side: BorderSide.none,
                                          ),
                                          onPressed: () {
        if(permissions.contains('delete_vehicle_type')){
          controller.deleteVehicleType(item.id!);

        }
                                          },
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
                              ]);
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    PaginationWidget(
                        currentPage: controller.currentPage.value,
                        totalPages: controller.totalPages.value,
                        onPageChange: controller.onPageChange)
                  ],
                ),
              );
      });
    });
  }
}
