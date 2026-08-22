import 'package:dashboard_new1/alert/delete_permission_alert.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/networks/api.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/locations_controller.dart';
import 'location_formScreen.dart';

class LocationListScreen extends StatefulWidget {
  LocationListScreen({super.key});

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  LocationController controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  final DashboardController _controller = Get.find();

    List permissions = [];
  @override
  void initState() {
    // TODO: implement initState
    permissions = Api().sp.read('all_permissions') ?? [];
    super.initState();
    shortCutKeyValue.value = "locationListScreen";
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
    final listToShow = controller.locationsFiltered.isNotEmpty
        ? controller.locationsFiltered
        : controller.locationsAll;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;


    return
       RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: PageScrollWrapper(
        child: GetBuilder<LocationController>(
            initState: (v) {
          controller.getLocationList();
        }, builder: (controller) {
          return

            controller.getLocationLoader.value
                ? CircularProgressIndicator()
                :
            SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "LOCATIONS" + "(${controller.locationListModel?.count})",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.w800, fontSize: 17),
                          ),
                          Checkbox(
                              value: controller.blackList.value,
                            onChanged: (v) {
                              controller.blackList.value = v ?? false;
                              controller.locationCurrentPage.value = 1;
                              controller.getLocationList();
                            },),
                          Text(
                            AppText.blackList,
                            style: mozillaTextRegularText(
                                color: DynamicColors.redClr),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Spacer(),
                          CustomButton(
                            onTap: () {
                              controller.getLocationList();

                            },
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(
                                title: "Name",
                                onChanged: (v) {
                                  controller.searchLocationName.value = v;
                                  controller.SearchLocation();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "PostCode",
                                onChanged: (v) {
                                  controller.searchPostCode.value = v;
                                  controller.SearchLocation();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "ShortCuts",
                                onChanged: (v) {
                                  controller.searchShortCuts.value = v;
                                  controller.SearchLocation();
                                },
                              ),
                              buildHeaderWithSearch(
                                title: "Address",
                                onChanged: (v) {
                                  controller.searchAddress.value = v;
                                  controller.SearchLocation();
                                },
                              ),

                              buildHeaderWithSearch(
                                title: "Location Type",
                                onChanged: (v) {
                                  controller.searchLocationType.value = v;
                                  controller.SearchLocation();
                                },
                              ),

                              buildHeaderWithSearch(
                                title: "Zone",
                                onChanged: (v) {
                                  controller.searchZone.value = v;
                                  controller.SearchLocation();
                                },
                              ),

                              buildHeaderWithSearch(
                                  title: "ACTIONS", removeSearching: true),
                            ],
                            totalRow: listToShow.length,
                            rows: listToShow.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Center(child: Text((item.name ?? '—').toUpperCase()))),
                                  DataCell(Center(child: Text((item.postcode ?? '—').toUpperCase()))),
                                  DataCell(Center(child: Text((item.shortcut ?? '—').toUpperCase()))),
                                  DataCell(Center(child: Text((item.address ?? '—').toUpperCase()))),
                                  DataCell(Center(child: Text((item.locationType?.name ?? 'N/A').toUpperCase()))),
                                  DataCell(Center(child: Text((item.zone ?? 'N/A').toUpperCase()))),
                                  DataCell(
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if(permissions.contains('update_location')) OutlinedButton(
                                            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.transparent),),
                                            onPressed: () {

                                              controller
                                                  .bindLocationUpdateLocation(locationUpdate: item);

                                              int index = _controller
                                                  .selectedMenuItems
                                                  .indexWhere((element) =>
                                                      element.title == "UPDATE LOCATION");
                                              if (index != -1) {
                                                _controller
                                                    .selectedMenuItems[index]
                                                    .selectedItem = true;
                                                _controller.currentPage.value =
                                                    LocationForm();
                                              } else {
                                                _controller.currentPage.value =
                                                    LocationForm();
                                                _controller.menuBarRefresh(
                                                    title: "UPDATE LOCATION",
                                                    pageName: LocationForm());
                                              }

                                              controller.update();

                                            },
                                            child: Icon(Icons.edit_calendar,
                                                size: 28),
                                          ),
                                          Text("|"),
                                          if(permissions.contains('delete_location')) OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: Colors.transparent),
                                            ),
                                            onPressed: () {
                                              controller.deleteLocation(
                                                  item.id!);

                                            },
                                            child: Icon(Icons.delete_forever,
                                                size: 28),
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
                          currentPage: controller.locationCurrentPage.value,
                          totalPages: controller.locationTotalPages.value,
                          onPageChange: controller.PageLocation),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
