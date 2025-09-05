

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../drivers_view/controller/driver_controller.dart';

class CompanyVehiclesScreen extends StatefulWidget {
  CompanyVehiclesScreen({super.key});

  @override
  State<CompanyVehiclesScreen> createState() => _CompanyVehiclesScreenState();
}

class _CompanyVehiclesScreenState extends State<CompanyVehiclesScreen> {
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

                      Text(
                        "COMPANY VEHICLES"+" (0)",
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.w800,
                            fontSize: 17
                        ),
                      ),

                      SizedBox
                        (
                        width: 20,
                      ),


                      SizedBox
                        (
                        width: 60,
                      ),

                      Container
                        (
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
                        )
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                          buildHeaderWithSearch(title: "VEHICLE #"),
                          buildHeaderWithSearch(title: "VEHICLE TYPE"),
                          buildHeaderWithSearch(title: "OWNER"),
                          buildHeaderWithSearch(title: "MAKE"),
                          buildHeaderWithSearch(title: "MODEL"),
                          buildHeaderWithSearch(title: "COLOR"),
                          buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                        ],
                        rows: List.generate(totalRows, (index) {
                          bool isSelected = index == selectedRowIndex;
                          return DataRow(
                            cells: [

                              const DataCell(Text("ASJ690")),
                              const DataCell(Text("SALOON")),
                              const DataCell(Text("Faheem")),
                              const DataCell(Text("Honda")),
                              const DataCell(Text("2025")),
                              const DataCell(Text("Black")),

                              DataCell(
                                Row(
                                  children: [

                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.transparent,), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(Icons.search,
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
                            ],
                          );
                        })
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
