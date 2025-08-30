


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../component/color.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../controller/driver_controller.dart';

class DriverRent extends StatefulWidget {
  const DriverRent({super.key});

  @override
  State<DriverRent> createState() => _DriverRentState();
}

class _DriverRentState extends State<DriverRent> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "driverRent";
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<DriverController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(AppText.driverRent+" (3)",
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.w800,
                            fontSize: 17
                        ),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: DynamicColors.primaryClr,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: IconButton(
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                            onPressed: (){

                            }, icon: Icon(Icons.refresh,
                          color: DynamicColors.whiteClr,
                          size: 25,
                        )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: Get.width,
                      child: DataTable(
                          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                          dataRowMinHeight: 48,
                          dataRowMaxHeight: 56,
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                          dataTextStyle: TextStyle(
                            fontSize: 10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: DynamicColors.textClr.withOpacity(0.5))
                          ),
                          columns: [
                            buildHeaderWithSearch(title: "USERNAME"),
                            buildHeaderWithSearch(title: "NAME"),
                            buildHeaderWithSearch(title: "TYPE"),
                            buildHeaderWithSearch(title: "RENT"),
                            buildHeaderWithSearch(title: "LAST MODIFIED"),
                          ],
                          rows: List.generate(totalRows, (index) {
                            bool isSelected = index == selectedRowIndex;
                            return DataRow(
                              cells: [
                                const DataCell(Text("20/10/2025")),
                                const DataCell(Text("#PHC VEHICLE")),
                                const DataCell(Text("PHC VEHICLE")),
                                const DataCell(Text("20/10/2025")),
                                const DataCell(Text("#PHC VEHICLE")),
                              ],
                            );
                          })
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}
