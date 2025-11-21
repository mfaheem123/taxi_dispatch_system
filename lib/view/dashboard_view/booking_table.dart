
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../alert/dispatch_booking_alert.dart';
import '../../component/images.dart';
import 'Controller/dashboard_controller.dart';
import 'dashboard/F3_alert.dart';

class BookingTable extends StatefulWidget {

  @override
  State<BookingTable> createState() => _BookingTableState();
}

class _BookingTableState extends State<BookingTable> {

  DashboardController controller = Get.find();

  int selectedRowIndex = 0; // currently selected row
  int totalRows = 10; // total rows (dynamic list ke hisaab se change hoga)

  @override
  Widget build(BuildContext context) {

    // if(controller.allAddressesData.isNotEmpty){
    //   totalRows = 4;
    // }else{
    //   totalRows = 10;
    // }

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width,
                child: SizedBox(
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
                          btnColor: tabList[index].deletedClr==true?DynamicColors.redClr: tabList[index].selectedClr!.value == true?DynamicColors.primaryClr.withOpacity(0.4): DynamicColors.secondaryClr,
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
              ),
              // _buildTabs(),

              const SizedBox(height: 10),


              SizedBox(
                width: Get.width,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  columnSpacing: 12, // 👈 default 56 hota hai, isko chhota kardo
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 48,
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                  dataTextStyle: const TextStyle(

                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      width: 0.5,
                      color: Colors.grey.shade400,
                    ),
                    verticalInside: BorderSide(
                      width: 0.5,
                      color: Colors.grey.shade400, // 👈 vertical lines added
                    ),
                    borderRadius: BorderRadius.circular(4),
                    top: BorderSide(
                      width: 1,
                      color: DynamicColors.textClr.withOpacity(0.5),
                    ),
                    left: BorderSide(
                      width: 1,
                      color: DynamicColors.textClr.withOpacity(0.5),
                    ),
                    right: BorderSide(
                      width: 1,
                      color: DynamicColors.textClr.withOpacity(0.5),
                    ),
                    bottom: BorderSide(
                      width: 1,
                      color: DynamicColors.textClr.withOpacity(0.5),
                    ),
                  ),
                  /*decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: DynamicColors.textClr.withOpacity(0.5),
                    ),
                  ),*/
                  columns: [
                    buildHeaderWithSearch(widget: Checkbox(value: false, onChanged: (v){

                    })),
                    buildHeaderWithSearch(title: "TYPE"),
                    buildHeaderWithSearch(title: "REF #"),
                    buildHeaderWithSearch(title: "DATETIME"),
                    buildHeaderWithSearch(title: "CUS"),
                    buildHeaderWithSearch(title: "PICKUP"),
                    buildHeaderWithSearch(title: "DROPOFF"),
                    buildHeaderWithSearch(title: "ACC"),
                    buildHeaderWithSearch(title: "DRV"),
                    buildHeaderWithSearch(title: "VEH"),
                    buildHeaderWithSearch(title: "NOTE"),
                    buildHeaderWithSearch(title: "FARE"),
                    buildHeaderWithSearch(title: "STATUS"),
                    buildHeaderWithSearch(title: "J/T"),
                    buildHeaderWithSearch(title: "P/T"),
                    buildHeaderWithSearch(title: "ACC"),
                  ],
                  rows: List.generate(totalRows, (index) {
                    bool isSelected = index == selectedRowIndex;
                    return DataRow(
                      cells: [
                        DataCell(Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              selectedRowIndex = value! ? index : -1;
                            });
                          },
                        )),
                        DataCell(Icon(Icons.laptop_chromebook_outlined, color: Colors.blue)),
                        DataCell(Text("BCB74867")),
                        DataCell(Text("02-05-25 23:36")),
                        DataCell(Text("NADEEM")),
                        DataCell(Text("FLAT 10 BLANDFORD COURT ...")),
                        DataCell(Text("65 JEDBURGH ROAD, LONDON")),
                        DataCell(Text("DRV")),
                        DataCell(Text("CAPITA BUSI ...")),
                        DataCell(Text("SALOON")),
                        DataCell(Text("Lorem ipsum dolor sit amet...")),
                        DataCell(Text("£ 14.00")),
                        DataCell(Text("WAITING")),
                        DataCell(Text("o/w")),
                        DataCell(Text("CASH")),
                        DataCell(
                          Row(
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  side: BorderSide.none,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => DispatchBookingAlert(),
                                  );
                                },
                                child: ImageIcon(
                                    AssetImage(Images.fowardIcon),
                                    color: Colors.green, size: 20),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                  child: Text("|")),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                  side: BorderSide.none,
                                ),
                                onPressed: () {
                                  showShortcutDialog(
                                    context,
                                    title: "testing",
                                    contentWidget: Center(child: Text("Testing"),),
                                  );
                                },
                                child: Icon(Icons.delete_forever, color: Colors.red, size: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                child: Text("|"),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  side: BorderSide.none,
                                ),
                                onPressed: () {
                                  showShortcutDialog(
                                    context,
                                    title: "testing",
                                    contentWidget: Center(child: Text("Testing"),),
                                  );
                                },
                                child: Icon(Icons.more_horiz, color: Colors.green, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}


List<TableSelectClass> tabList = [ 
  TableSelectClass(titleText: "TODAY BOOKINGS", selectedClr: false.obs, dropDownList: [], deletedClr: false),
  TableSelectClass(titleText: "BOOKINGS", selectedClr: false.obs, dropDownList: [],deletedClr: false),
  TableSelectClass(titleText: "PRE BOOKINGS", selectedClr: false.obs, dropDownList: [],deletedClr: false),
  TableSelectClass(titleText: "RECENT BOOKINGS", selectedClr: false.obs, dropDownList: [],deletedClr: false),
  TableSelectClass(titleText: "COMPLETED", selectedClr: false.obs, dropDownList: [],deletedClr: false),
  TableSelectClass(titleText: "WEB BOOKINGS", selectedClr: false.obs, dropDownList: [],deletedClr: false),
  TableSelectClass(titleText: "QUOTED BOOKINGS", selectedClr: false.obs, dropDownList: [],deletedClr: false),
  TableSelectClass(titleText: "APP BOOKINGS", selectedClr: false.obs, dropDownList: [],deletedClr: false),
  TableSelectClass(titleText: "IVR BOOKINGS", selectedClr: false.obs, dropDownList: [],deletedClr: false),
  TableSelectClass(titleText: "JOB DUE BY", selectedClr: false.obs,dropDown: true,dropDownList: [

    "JOB DUE BY",
    "15 MIN",
    "30 MIN",
    "60 MIN",
  ],
      deletedClr: false),
  TableSelectClass(titleText: "DELETE SELECTION", selectedClr: false.obs, dropDownList: [],deletedClr: true),
];

class TableSelectClass{
  RxBool? selectedClr = false.obs;
  String? titleText;
  bool dropDown = false;
  List<String> dropDownList = [];
  String? selectedDropDownValue;
  bool deletedClr = false;
  TableSelectClass({this.selectedClr, this.dropDown = false,this.titleText,required this.dropDownList,this.selectedDropDownValue,this.deletedClr = false});
}


DataColumn buildHeaderWithSearch({String? title,removeSearching = false, Widget? widget, textFieldHeight, double? fontSize, Widget? customWidget, Function(String)? onChanged, }  ) {
  return DataColumn(
    label: Expanded(
      child: widget?? Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(title!, style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 13
          )),

          SizedBox(height: 4),
          title == "TYPE" || removeSearching == true
              ? SizedBox.shrink()
              : customWidget ?? SizedBox(
            width: 100,
            height: textFieldHeight??28,
            child: TextField(
             onChanged: onChanged,
              onTap: () {
                shortCutKeyValue.value = "tableSelected";
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
    ),
  );
}