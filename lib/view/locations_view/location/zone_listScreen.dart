import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/locations_view/location/zone_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../component/datatable_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../drivers_view/controller/driver_controller.dart';
import '../controller/locations_controller.dart';

class ZoneListScreen extends StatefulWidget {
  ZoneListScreen({super.key});

  @override
  State<ZoneListScreen> createState() => _ZoneListScreenState();
}

class _ZoneListScreenState extends State<ZoneListScreen> {
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
    final listToShow = controller.zoneFiltered.isNotEmpty
        ? controller.zoneFiltered
        : controller.zoneAll;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<LocationController>(initState: (v) {
        controller.getZoneList();
      }, builder: (controller) {
        return controller.getZoneLoader.value == true
            ? SizedBox.shrink()
            : SingleChildScrollView(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Zones",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w800, fontSize: 17),
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
                              title: "NAME",
                              onChanged: (v) {
                                controller.searchZoneName.value = v;
                                controller.onSearchChanged();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "SHORT NAME",
                              onChanged: (v) {
                                controller.searchShortName.value = v;
                                controller.onSearchChanged();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "TYPES",
                              onChanged: (v) {
                                controller.searchType.value = v;
                                controller.onSearchChanged();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "CATEGORY",
                              onChanged: (v) {
                                controller.searchCategory.value = v;
                                controller.onSearchChanged();
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
                                DataCell(Center(
                                    child: Text(item.secondaryName ?? '—'))),
                                DataCell(Center(child: Text(item.type ?? '—'))),
                                DataCell(
                                    Center(child: Text(item.category ?? '—'))),
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
                                            // controller.bindLocationUpdateLocation(locationUpdate: item);
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
                                                  ZoneScreen();
                                            } else {
                                              _controller.currentPage.value =
                                                  ZoneScreen();
                                              _controller.menuBarRefresh(
                                                  title: "CREATE ZONE",
                                                  pageName: ZoneScreen());
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
                                            // controller.deleteZoneList(item.id);
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
                     currentPage: controller.zoneCurrentPage.value,
                     totalPages: controller.zoneTotalPages.value,
                     onPageChange: controller.zonePageChange),
                  ],
                ),
              );
      }),
    );
  }
}
