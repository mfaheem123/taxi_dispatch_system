import 'package:dashboard_new1/alert/delete_permission_alert.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../component/datatable_widget.dart';
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

  @override
  void initState() {
    // TODO: implement initState
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final listToShow = controller.locationsFiltered.isNotEmpty
        ? controller.locationsFiltered
        : controller.locationsAll;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<LocationController>(initState: (v) {
        controller.getLocationList();
      }, builder: (controller) {
        return controller.getLocationLoader.value == true
            ? SizedBox.shrink()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Location" +
                              "(${controller.locationListModel?.count})",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        Checkbox(
                            value: controller.blackList.value,
                            onChanged: (v) {
                              controller.blackList.value = v!;
                              controller.update();
                            }),
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
                        width: Get.width,
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(
                              title: "Name",
                              onChanged: (v) {
                                controller.searchLocationName.value = v;
                                controller.SearchEscort();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "PostCode",
                              onChanged: (v) {
                                controller.searchPostCode.value = v;
                                controller.SearchEscort();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "ShortCuts",
                              onChanged: (v) {
                                controller.searchShortCuts.value = v;
                                controller.SearchEscort();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "Address",
                              onChanged: (v) {
                                controller.searchAddress.value = v;
                                controller.SearchEscort();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "Location Type",
                              onChanged: (v) {
                                controller.searchLocationType.value = v;
                                controller.SearchEscort();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "Zone",
                              onChanged: (v) {
                                controller.searchZone.value = v;
                                controller.SearchEscort();
                              },
                            ),
                            buildHeaderWithSearch(
                                title: "ACTIONS", removeSearching: true),
                          ],
                          totalRow: listToShow.length,
                          rows: listToShow.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(Center(child: Text(item.name ?? '—'))),
                                DataCell(
                                    Center(child: Text(item.postcode ?? '—'))),
                                DataCell(
                                    Center(child: Text(item.shortcut ?? '—'))),
                                DataCell(
                                    Center(child: Text(item.address ?? '—'))),
                                DataCell(Center(
                                    child: Text(
                                        item.locationType?.name ?? 'N/A'))),
                                DataCell(Center(
                                    child: Text(item.zone?.name ?? 'N/A'))),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          onPressed: () {
                                            controller
                                                .bindLocationUpdateLocation(
                                                    locationUpdate: item);
                                            int index = _controller
                                                .selectedMenuItems
                                                .indexWhere((element) =>
                                                    element.title ==
                                                    "LocationForm");
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
                                                  title: "LocationForm",
                                                  pageName: LocationForm());
                                            }
                                            controller.update();
                                          },
                                          child: Icon(Icons.edit_calendar,
                                              size: 28),
                                        ),
                                        Text("|"),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          onPressed: () {
                                            controller.deleteLocationList(
                                                item.id.toString());
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
                  ],
                ),
              );
      }),
    );
  }
}
