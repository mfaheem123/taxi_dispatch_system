
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../component/images.dart';
import 'Controller/dashboard_controller.dart';

class BookingTable extends StatefulWidget {
  @override
  State<BookingTable> createState() => _BookingTableState();
}

class _BookingTableState extends State<BookingTable> {
  // final DashboardController controller = Get.find();


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
                height: 500,
                width: double.infinity,
                child:
                TableScreen(),
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
  List<bool> selectedRows = List.generate(10, (_) => false);
  String? dropdownValue = "Today";

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 20, // columns ke beech ka space
      horizontalMargin: 10, // side margin
      minWidth: 1000, // yeh set karein taki scroll enable ho
      headingRowHeight: 70,
      columns: [
        // Gap column (just for spacing)
        // DataColumn(
        //   label: SizedBox.shrink(), // yaha gap adjust karein
        // ),
        // DataColumn2(
        //   label: Text("")/*Checkbox(
        //     value: false,
        //     onChanged: (_) {},
        //   )*/,
        //   size: ColumnSize.S,
        // ),
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
        10,
            (index) => DataRow(

          selected: selectedRows[index],
          onSelectChanged: (value) {
            setState(() {
              selectedRows[index] = value ?? false;
            });
          },
          cells: [

            // Gap cell
            // DataCell(
            //     SizedBox.shrink()),
            // DataCell(
            //   Icon(Icons.laptop_chromebook_outlined),
            //   /*Checkbox(
            //   value: selectedRows[index],
            //   onChanged: (value) {
            //     setState(() {
            //       selectedRows[index] = value ?? false;
            //     });
            //   },
            // )*/),
            DataCell(Icon(Icons.laptop_chromebook_outlined, color: Colors.blue)),
            DataCell(Text(
              "BCB74867",
              maxLines: 1,
              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
            ),
            ),
            DataCell(Text(
              "02-05-25 23:36",
              maxLines: 1,

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
            ),),
            DataCell(Text(
              "NADEEM",
              maxLines: 1,

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
            ),),
            DataCell(Text(
              "FLAT 10 BLANDFORD COURT 4-6 BRON ... BITTACY HILL, LONDON, NW7 1LB",

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
              maxLines: 1,
            )),
            DataCell(
                Text(
                    "65 JEDBURGH ROAD, LONDON, E13 9LF",

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
              maxLines: 1,
                ),
            ),
            DataCell(
                Text(
                    "DRV",

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
              maxLines: 1,
                ),
            ),
            DataCell(
                Text(
                    "CAPITA BUSI ...",

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
              maxLines: 1,
                ),
            ),
            DataCell(
                Text(
                    "SALOON",

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
              maxLines: 1,
                ),
            ),
            DataCell(
                Text(
                    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu",

                  style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
                  maxLines: 1,
                ),
            ),
            DataCell(
                Text(
                    "£ 14.00",

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
              maxLines: 1,
                ),
            ),
            DataCell(
                Text(
                    "WAITING",

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
              maxLines: 1,
                ),
            ),
            DataCell(
                Text(
                    "o/w",

              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
              maxLines: 1,
                ),
            ),
            DataCell(
                Text(
                    "CASH",
              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
                  maxLines: 1,
                ),
            ),
            DataCell(
                Row(
              children: [
                ImageIcon(AssetImage(Images.fowardIcon),color: Colors.green,size: 20,),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text("|")),
                Icon(Icons.edit_calendar_rounded, color: Colors.red,size: 20,),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),child: Text("|")),
                Icon(Icons.delete_forever, color: Colors.green,size: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Text("|"),
                ),
                Icon(Icons.more_horiz, color: Colors.green,size: 20,),
              ],
            )),
          ],
        ),
      ),
    );
  }

  DataColumn _buildHeaderWithSearch(String title) {
    print(title);
    return DataColumn(
      label: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          title== "TYPE"? SizedBox.shrink() :  SizedBox(
            width: 100,
            height: 28,
            child: TextField(
              style: mozillaTextRegularText(fontWeight: FontWeight.w800, fontSize: 12),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: mozillaTextRegularText(fontWeight: FontWeight.w800,color: DynamicColors.textClr.withOpacity(0.8), fontSize: 12),
                contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
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



