import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/vehicles_view/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../component/datatable_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../drivers_view/controller/driver_controller.dart';
import 'create_company_vehicle.dart';

class CompanyVehiclesScreen extends StatefulWidget {
  CompanyVehiclesScreen({super.key});

  @override
  State<CompanyVehiclesScreen> createState() => _CompanyVehiclesScreenState();
}

class _CompanyVehiclesScreenState extends State<CompanyVehiclesScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  VehicleController controller = Get.isRegistered<VehicleController>()
      ? Get.find<VehicleController>()
      : Get.put(VehicleController());
  final DashboardController _controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "driversList";
    controller.companyVehicle();
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
      child: GetBuilder<VehicleController>(builder: (controller) {
        final listToShow = controller.filteredCompanyVehicle.isNotEmpty
            ? controller.filteredCompanyVehicle
            : controller.companyAllVehicle;

        return controller.isCompanyVehicle.value == true
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "COMPANY VEHICLES" +
                              " (${controller.companyVehicleModel?.count})",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        SizedBox(
                          width: 20,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0.0),
                            child: Icon(
                              Icons.refresh,
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
                    SizedBox(
                      width: Get.width,
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(
                            title: "VEHICLE #",
                            onChanged: (v) {
                              controller.searchVehicle.value = v;
                              controller.SearchingOnCompany();
                            },
                          ),
                          buildHeaderWithSearch(
                              title: "VEHICLE TYPE",
                              onChanged: (v) {
                                controller.searchVehicleType.value = v;
                                controller.SearchingOnCompany();
                              }),
                          buildHeaderWithSearch(
                              title: "OWNER",
                              onChanged: (v) {
                                controller.searchOwner.value = v;
                                controller.SearchingOnCompany();
                              }),
                          buildHeaderWithSearch(
                              title: "MAKE",
                              onChanged: (v) {
                                controller.searchMake.value = v;
                                controller.SearchingOnCompany();
                              }),
                          buildHeaderWithSearch(
                              title: "MODEL",
                              onChanged: (v) {
                                controller.searchModel.value = v;
                                controller.SearchingOnCompany();
                              }),
                          buildHeaderWithSearch(
                              title: "COLOR",
                              onChanged: (v) {
                                controller.searchColor.value = v;
                                controller.SearchingOnCompany();
                              }),
                          buildHeaderWithSearch(
                              title: "ACTIONS", removeSearching: true),
                        ],
                        totalRow:
                            controller.companyVehicleModel?.vehicles?.length ??
                                0,
                        rows: (controller.companyVehicleModel?.vehicles ?? [])
                            .map((item) {
                          return DataRow(
                            cells: [
                              DataCell(Center(
                                  child: Text(item.vehicleNumber.toString()))),
                              DataCell(Center(
                                  child: Text(
                                      item.vehicleType?.name.toString() ??
                                          "no data"))),
                              DataCell(Center(
                                  child: Text(
                                      item.owner.toString() ?? "no data"))),
                              DataCell(Center(
                                  child:
                                      Text(item.make.toString() ?? "no data"))),
                              DataCell(Center(
                                  child: Text(
                                      item.model.toString() ?? "no data"))),
                              DataCell(Center(
                                  child: Text(
                                      item.color.toString() ?? "no data"))),
                              DataCell(
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                          ), // border color & thickness
                                        ),
                                        onPressed: () {
                                          controller.companyDataBinding(
                                              data: item);
                                          // controller.bindLocationUpdateLocation(locationUpdate: item);
                                          int index = _controller
                                              .selectedMenuItems
                                              .indexWhere((element) =>
                                                  element.title ==
                                                  "LocationForm");
                                          if (index != -1) {
                                            _controller.selectedMenuItems[index]
                                                .selectedItem = true;
                                            _controller.currentPage.value =
                                                CreateCompanyVehicle();
                                          } else {
                                            _controller.currentPage.value =
                                                CreateCompanyVehicle();
                                            _controller.menuBarRefresh(
                                                title: "CREATE COMPANY VEHICLE",
                                                pageName:
                                                    CreateCompanyVehicle());
                                          }
                                          controller.update();
                                        },
                                        child: Icon(
                                          Icons.edit,
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
                                          color: DynamicColors.redClr,
                                          size: 28,
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
                    PaginationWidget(
                        currentPage: controller.companycurrentPage.value,
                        totalPages: controller.companytotalPages.value,
                        onPageChange: controller.PageOnCompany)
                  ],
                ),
              );
      }),
    );
  }
}
