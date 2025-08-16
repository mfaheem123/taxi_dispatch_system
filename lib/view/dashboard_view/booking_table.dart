
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../component/images.dart';
import 'Controller/dashboard_controller.dart';
import 'dashboard/F3_alert.dart';

class BookingTable extends StatefulWidget {
  @override
  State<BookingTable> createState() => _BookingTableState();
}

class _BookingTableState extends State<BookingTable> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        itemCount: tabList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal, // <-- enable horizontal
                        physics: const BouncingScrollPhysics(), // smooth scrolling
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: tabList[index].dropDown == false? CustomButton(
                              width: 150,
                              verticalPadding: 0,
                              borderRadius: 4,
                              style: mozillaTextRegularText(
                                fontSize: 13,
                                color: DynamicColors.textClr,
                              ),
                              btnText: tabList[index].titleText,
                              btnColor:tabList[index].selectedClr!.value == true?DynamicColors.primaryClr.withOpacity(0.4): DynamicColors.secondaryClr,
                              onTap: () {
                                int selectedIndex =
                                tabList.indexWhere((test) => test.selectedClr!.value == true);
                                if (selectedIndex != -1) {
                                  tabList[selectedIndex].selectedClr!.value = false;
                                }
                                tabList[index].selectedClr!.value = true; // <-- fix selection
                                controller.update();
                              },
                            ):
                            SizedBox(
                              width: 150,
                              child: Container(color: DynamicColors.secondaryClr,
                                child: DropdownButton<String>(
                                  value: tabList[index].selectedDropDownValue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  isExpanded: true,
                                  hint: Text("JOB DUE BY",
                                    style: mozillaTextRegularText(
                                        fontSize: 13,
                                        color: DynamicColors.textClr
                                    ),
                                  ),
                                  underline: const SizedBox(),
                                  items: tabList[index].dropDownList.map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item,
                                        style: mozillaTextRegularText(
                                            fontSize: 13,
                                            color: DynamicColors.textClr
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    int selectedIndex =
                                    tabList.indexWhere((test) => test.selectedClr!.value == true);
                                    if (selectedIndex != -1) {
                                      tabList[selectedIndex].selectedClr!.value = false;
                                    }
                                   setState(() {
                                     tabList[index].selectedDropDownValue = value;
                                     tabList[index].selectedClr!.value = true; // <-- fix selection

                                   });
                                    controller.update();
                                    // });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        width: 140,
                        verticalPadding: 0,
                        borderRadius: 4,
                        height: 40,
                        btnColor: DynamicColors.redClr,
                        style: mozillaTextRegularText(
                          fontSize: 12,
                          color: DynamicColors.textClr,
                        ),
                        btnText: "DELETE SELECTION",
                      ),
                    )
                  ],
                ),
              ),
              // _buildTabs(),
              const SizedBox(height: 10),


              SizedBox(
                // height: Get.height/1.6,
                width: double.infinity,
                child: TableScreen(),
        ),
            ],
          ),
        );
      }
    );
  }
}


List<TableSelectClass> tabList = [
  TableSelectClass(titleText: "TODAY BOOKINGS", selectedClr: false.obs, dropDownList: []),
  TableSelectClass(titleText: "BOOKINGS", selectedClr: false.obs, dropDownList: []),
  TableSelectClass(titleText: "PRE BOOKINGS", selectedClr: false.obs, dropDownList: []),
  TableSelectClass(titleText: "RECENT BOOKINGS", selectedClr: false.obs, dropDownList: []),
  TableSelectClass(titleText: "COMPLETED", selectedClr: false.obs, dropDownList: []),
  TableSelectClass(titleText: "WEB BOOKINGS", selectedClr: false.obs, dropDownList: []),
  TableSelectClass(titleText: "QUOTED BOOKINGS", selectedClr: false.obs, dropDownList: []),
  TableSelectClass(titleText: "APP BOOKINGS", selectedClr: false.obs, dropDownList: []),
  TableSelectClass(titleText: "IVR BOOKINGS", selectedClr: false.obs, dropDownList: []),
  TableSelectClass(titleText: "JOB DUE BY", selectedClr: false.obs,dropDown: true,dropDownList: [
    "JOB DUE BY",
    "15 MIN",
    "30 MIN",
    "60 MIN",]),
];

class TableSelectClass{
  RxBool? selectedClr = false.obs;
  String? titleText;
  bool dropDown = false;
  List<String> dropDownList = [];
  String? selectedDropDownValue;
  TableSelectClass({this.selectedClr, this.dropDown = false,this.titleText,required this.dropDownList,this.selectedDropDownValue});
}


class TableScreen extends StatefulWidget {
  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final int rowCount = 20; // total rows
  late List<bool> selectedRows;
  late List<List<FocusNode>> rowCellFocusNodes; // har row ke har cell ka focus
  int currentRowIndex = 0;
  int currentColIndex = 0;

  @override
  void initState() {
    super.initState();

    selectedRows = List.generate(rowCount, (index) => false);

    /// har row ke liye cells ke focusNodes bnao
    rowCellFocusNodes = List.generate(
      rowCount,
          (row) => List.generate(15, (col) => FocusNode()), // 15 columns
    );

    // Default: first row first column focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rowCellFocusNodes[0][0].requestFocus();
    });
  }

  void _handleKey(RawKeyEvent event, int row, int col) {
    print(dashBoardCntrl.shortCutKeyValue.value);
    if (dashBoardCntrl.shortCutKeyValue.value == "tableSelected") {
      if (event is RawKeyDownEvent) {
        final key = event.logicalKey;

        if (key == LogicalKeyboardKey.enter) {
          setState(() {
            selectedRows[row] = !selectedRows[row];
          });
        } else if (key == LogicalKeyboardKey.arrowDown) {
          setState(() {
            currentRowIndex = (row + 1) % rowCount;
            rowCellFocusNodes[currentRowIndex][col].requestFocus();
          });
        } else if (key == LogicalKeyboardKey.arrowUp) {
          setState(() {
            currentRowIndex = (row - 1 + rowCount) % rowCount;
            rowCellFocusNodes[currentRowIndex][col].requestFocus();
          });
        } else if (key == LogicalKeyboardKey.arrowRight) {
          setState(() {
            currentColIndex = (col + 1) % rowCellFocusNodes[row].length;
            rowCellFocusNodes[row][currentColIndex].requestFocus();
          });
        } else if (key == LogicalKeyboardKey.arrowLeft) {
          setState(() {
            currentColIndex = (col - 1 + rowCellFocusNodes[row].length) %
                rowCellFocusNodes[row].length;
            rowCellFocusNodes[row][currentColIndex].requestFocus();
          });
        }
      }
    }
  }

  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20,
      horizontalMargin: 10,
      headingRowHeight: 70,
      columns: [
        _buildHeaderWithSearch("TYPE"),
        _buildHeaderWithSearch("REF #"),
        _buildHeaderWithSearch("DATETIME"),
        _buildHeaderWithSearch("CUS"),
        _buildHeaderWithSearch("PICKUP"),
        _buildHeaderWithSearch("DROPOFF"),
        _buildHeaderWithSearch("ACC"),
        _buildHeaderWithSearch("DRV"),
        _buildHeaderWithSearch("VEH"),
        _buildHeaderWithSearch("NOTE"),
        _buildHeaderWithSearch("FARE"),
        _buildHeaderWithSearch("STATUS"),
        _buildHeaderWithSearch("J/T"),
        _buildHeaderWithSearch("P/T"),
        _buildHeaderWithSearch("ACC"),
      ],
      rows: List<DataRow>.generate(
        rowCount,
            (rowIndex) =>
            DataRow(
              selected: selectedRows[rowIndex],
              onSelectChanged: (value) {
                setState(() {
                  selectedRows[rowIndex] = value ?? false;
                });
              },
              cells: List<DataCell>.generate(15, (colIndex) {
                Widget child;
                if (colIndex == 0) {
                  child = Icon(
                      Icons.laptop_chromebook_outlined, color: Colors.blue);
                } else if (colIndex == 1) {
                  child = Text("BCB74867",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 2) {
                  child = Text("02-05-25 23:36",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 3) {
                  child = Text("NADEEM",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 4) {
                  child = Text(
                    "FLAT 10 BLANDFORD COURT ...",
                    maxLines: 1,
                    style: mozillaTextRegularText(
                        fontWeight: FontWeight.w800, fontSize: 12),
                  );
                } else if (colIndex == 5) {
                  child = Text("65 JEDBURGH ROAD, LONDON",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 6) {
                  child = Text("DRV",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 7) {
                  child = Text("CAPITA BUSI ...",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 8) {
                  child = Text("SALOON",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 9) {
                  child = Text("Lorem ipsum dolor sit amet...",
                      maxLines: 1,
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 10) {
                  child = Text("£ 14.00",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 11) {
                  child = Text("WAITING",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 12) {
                  child = Text("o/w",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else if (colIndex == 13) {
                  child = Text("CASH",
                      style: mozillaTextRegularText(
                          fontWeight: FontWeight.w800, fontSize: 12));
                } else {
                  // last cell with icons
                  child = Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          showShortcutDialog(
                            context,
                            title: "testing",
                            contentWidget: Center(child: Text("Testing"),),
                          );
                        },
                        child: ImageIcon(AssetImage(Images.fowardIcon),
                            color: Colors.green, size: 20),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Text("|")),
                      GestureDetector(
                        onTap: (){
                          showShortcutDialog(
                            context,
                            title: "testing",
                            contentWidget: Center(child: Text("Testing"),),
                          );
                        },
                        child: Icon(Icons.edit_calendar_rounded,
                            color: Colors.red, size: 20),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Text("|")),
                      GestureDetector(
                          onTap: (){
                            showShortcutDialog(
                              context,
                              title: "testing",
                              contentWidget: Center(child: Text("Testing"),),
                            );
                          },
                          child: Icon(Icons.delete_forever, color: Colors.green, size: 20)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Text("|"),
                      ),
                      GestureDetector(
                          onTap: (){
                            showShortcutDialog(
                              context,
                              title: "testing",
                              contentWidget: Center(child: Text("Testing"),),
                            );
                          },
                          child: Icon(Icons.more_horiz, color: Colors.green, size: 20)),
                    ],
                  );
                }

                return DataCell(
                  Focus(
                    focusNode: rowCellFocusNodes[rowIndex][colIndex],
                    onKey: (node, event) {
                      _handleKey(event, rowIndex, colIndex);
                      return KeyEventResult.handled;
                    },
                    child: child,
                  ),
                );
              }),
            ),
      ),
    );
  }

  DataColumn _buildHeaderWithSearch(String title) {
    return DataColumn(
      label: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          title == "TYPE"
              ? SizedBox.shrink()
              : SizedBox(
            width: 100,
            height: 28,
            child: TextField(
              onTap: () {
                dashBoardCntrl.shortCutKeyValue.value = "tableSelected";
              },
              style: mozillaTextRegularText(
                  fontWeight: FontWeight.w800, fontSize: 12),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: mozillaTextRegularText(
                    fontWeight: FontWeight.w800,
                    color: DynamicColors.textClr.withOpacity(0.8),
                    fontSize: 12),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
