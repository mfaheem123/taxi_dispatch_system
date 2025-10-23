import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/vehicles_view/model/vehicle_type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../component/color.dart';
import '../../component/datatable_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<VehicleController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        
    //     final listToShow = controller.filteredVehicleTypes.isNotEmpty
    // ? controller.filteredVehicleTypes
    // : controller.allVehicleTypes;


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
                                // onChanged: (v) {
                                //   controller.searchName.value = v;
                                //   controller.applyFilter();
                                 
                                // }
                                ),
                            buildHeaderWithSearch(
                                title: "PASSENGERS",
                                // onChanged: (v) {
                                //   controller.searchPassengers.value = v;
                                //   controller.applyFilter();
                                // }
                                ),
                            buildHeaderWithSearch(
                                title: "LUGGAGES",
                                // onChanged: (v) {
                                //   controller.searchLuggages.value = v;
                                //   controller.applyFilter();
                                // }
                                ),
                            buildHeaderWithSearch(
                                title: "HAND LUGGAGES",
                                // onChanged: (v) {
                                //   controller.searchHandLuggages.value = v;
                                //   controller.applyFilter();
                                // },
                                ),
                            buildHeaderWithSearch(
                                title: "MINIMUM FARES",
                                // onChanged: (v) {
                                //   controller.searchMinFare.value = v;
                                //   controller.applyFilter();
                                // },
                                ),
                            buildHeaderWithSearch(
                                title: "MINIMUM MILES",
                                // onChanged: (v) {
                                //   controller.searchMinMiles.value = v;
                                //   controller.applyFilter();
                                // },
                                ),
                            buildHeaderWithSearch(
                                title: "ACTIONS", removeSearching: true),
                          ],


                          totalRow: controller.vehicleTypeModel?.vehicleTypes?.length ??
                              0,
                          rows:
                              (controller.vehicleTypeModel?.vehicleTypes ?? [])
                                  .map(
                            (item) {
                              return DataRow(cells: [
                                DataCell(Center(
                                    child: Text(item.name ?? 'No Data'))),
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
                                            controller.vehicleDataBinding(item: item);
                                            int index = _controller.selectedMenuItems.indexWhere(
                                                    (element) => element.title == "CREATE VEHICLE TYPE");
                                            if (index != -1) {
                                              _controller.selectedMenuItems[index].selectedItem = true;
                                              _controller.currentPage.value = CreateVehicleTypes();
                                            }else{
                                              _controller.currentPage.value = CreateVehicleTypes();
                                              _controller.menuBarRefresh(
                                                  title: "CREATE VEHICLE TYPE", pageName: CreateVehicleTypes());
                                            }
                                            controller.update();
                                          },
                                          child: Icon(Icons.edit_calendar,
                                              size: 20),
                                        ),
                                        const SizedBox(width: 4),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(24, 24),
                                            side: BorderSide.none,
                                          ),
                                          onPressed: () {},
                                          child: Icon(
                                            Icons.delete_forever,
                                            size: 20,
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
                    
                  ],
                ),
              );
      });
    });
  }
}
