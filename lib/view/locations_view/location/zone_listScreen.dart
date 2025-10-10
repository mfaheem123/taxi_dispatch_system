

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
import '../../drivers_view/controller/driver_controller.dart';
import '../controller/lacations_controller.dart';

class ZoneListScreen extends StatefulWidget {
  ZoneListScreen({super.key});

  @override
  State<ZoneListScreen> createState() => _ZoneListScreenState();
}

class _ZoneListScreenState extends State<ZoneListScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

  LocationController controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

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
              (selectedRowIndex - 1 + totalRows) % totalRows;// move up
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
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<LocationController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Zones",
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.w800,
                            fontSize: 17
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
                          buildHeaderWithSearch(title: "NAME"),
                          buildHeaderWithSearch(title: "SHORT NAME"),
                          buildHeaderWithSearch(title: "TYPES"),
                          buildHeaderWithSearch(title: "CATEGORY"),

                          buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                        ],
                        totalRow: totalRows,
                        cells: [

                          const DataCell(Center(child: Text("Action Town Tube Station"))),
                          const DataCell(Center(child: Text("W3BHN"))),
                          const DataCell(Center(child: Text("RA"))),
                          const DataCell(Center(child: Text("Action Town Tube Station W3BHN"))),
                          DataCell(
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.transparent,), // border color & thickness
                                    ),
                                    onPressed: () {},
                                    child: Icon(Icons.edit_calendar,
                                      size: 28,
                                    ),
                                  ),
                                  Text("|"),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.transparent,), // border color & thickness
                                    ),
                                    onPressed: () {},
                                    child: Icon(Icons.delete_forever,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
