
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Controller/dashboard_controller.dart';

class BookingTable extends StatelessWidget {
  // final DashboardController controller = Get.find();

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            value: selectedValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            hint: Text("JOB DUE BY",
                              style: mozillaTextRegularText(
                                  fontSize: 13,
                                  color: DynamicColors.textClr
                              ),
                            ),
                            underline: const SizedBox(),
                            items: tabList[index].dropDownList!.map((item) {
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
                              selectedValue = value;
                              tabList[index].selectedClr!.value = true; // <-- fix selection
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
              // _buildTabs(),
              const SizedBox(height: 10),


              SizedBox(
                height: 500,
                width: double.infinity,
                child:
                TableScreen(),
                /*Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
                      border: TableBorder.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      columnSpacing: 60,
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 56,
                      columns: const [
                        DataColumn(label: Text('S.NO', style: _headerStyle)),
                        DataColumn(label: Text('REF#', style: _headerStyle)),
                        DataColumn(label: Text('DATE', style: _headerStyle)),
                        DataColumn(label: Text('TIME', style: _headerStyle)),
                        DataColumn(label: Text('CUSTOMER NAME', style: _headerStyle)),
                        DataColumn(label: Text('PICKUP POINT', style: _headerStyle)),
                        DataColumn(label: Text('DROPOFF POINT', style: _headerStyle)),
                        DataColumn(label: Text('PHONE', style: _headerStyle)),
                        DataColumn(label: Text('VEHICLE', style: _headerStyle)),
                        DataColumn(label: Text('STATUS', style: _headerStyle)),
                        DataColumn(label: Text('DRIVER', style: _headerStyle)),
                        DataColumn(label: Text('ACCOUNT', style: _headerStyle)),
                        DataColumn(label: Text('FARES', style: _headerStyle)),
                        DataColumn(label: Text('ACTION', style: _headerStyle)),
                      ],
                      rows: List.generate(controller.bookings.length, (index) {
                        final booking = controller.bookings[index];
                        return DataRow(cells: [
                          DataCell(Text('${booking.sno}')),
                          DataCell(Text(booking.ref)),
                          DataCell(Text(booking.date)),
                          DataCell(Text(booking.time)),
                          DataCell(Text(booking.customerName)),
                          DataCell(Text(booking.pickupPoint)),
                          DataCell(Text(booking.dropoffPoint)),
                          DataCell(Text(booking.phone)),
                          DataCell(Text(booking.vehicle)),
                          DataCell(Text(booking.status)),
                          DataCell(_buildStatus(booking.driver)),
                          DataCell(Text(booking.account)),
                          DataCell(Text('\$${booking.fares.toStringAsFixed(2)}')),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Color(0xFF43489A)),
                                onPressed: () => controller.editBooking(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => controller.deleteBooking(index),
                              ),
                            ],
                          )),
                        ]);
                      }),
                    ),
                  ),*/
        ),
            ],
          ),
        );
      }
    );
  }
}


List<TableSelectClass> tabList = [
  TableSelectClass(titleText: "TODAY BOOKINGS", selectedClr: false.obs),
  TableSelectClass(titleText: "BOOKINGS", selectedClr: false.obs),
  TableSelectClass(titleText: "COMPLETED", selectedClr: false.obs),
  TableSelectClass(titleText: "PRE BOOKINGS", selectedClr: false.obs),
  TableSelectClass(titleText: "RECENT BOOKINGS", selectedClr: false.obs),
  TableSelectClass(titleText: "QUOTED BOOKINGS", selectedClr: false.obs),
  TableSelectClass(titleText: "WEB BOOKINGS", selectedClr: false.obs),
  TableSelectClass(titleText: "APP BOOKINGS", selectedClr: false.obs),
  TableSelectClass(titleText: "IVR BOOKINGS", selectedClr: false.obs),
  TableSelectClass(titleText: "JOB DUE BY", selectedClr: false.obs,dropDown: true,dropDownList: [
    "JOB DUE BY",
    "15 MIN",
    "30 MIN",
    "15 MIN",
    "60 MIN",]),
];

class TableSelectClass{
  RxBool? selectedClr = false.obs;
  String? titleText;
  bool dropDown = false;
  List<String>? dropDownList = [];
  TableSelectClass({this.selectedClr, this.dropDown = false,this.titleText,this.dropDownList});
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
      columnSpacing: 10,
      horizontalMargin: 7,
      // minWidth: 1400,
      headingRowHeight: 70,
      columns: [
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
            DataCell(Row(
              children: [
                Icon(Icons.reply, color: Colors.blue),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text("|")),
                Icon(Icons.edit_calendar_rounded, color: Colors.red),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),child: Text("|")),
                Icon(Icons.delete_forever, color: Colors.green),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text("|"),
                ),
                Icon(Icons.more_horiz, color: Colors.green),
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
          title== "TYPE"?SizedBox.shrink():  SizedBox(
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

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}



