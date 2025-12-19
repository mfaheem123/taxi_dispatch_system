
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
import 'models/dashboard_model.dart';

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
                    itemCount: controller.bookingTabsList!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal, // <-- enable horizontal
                    physics: const BouncingScrollPhysics(), // smooth scrolling
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: controller.bookingTabsList![index].dropDownList!.isEmpty? CustomButton(
                          width: 175,
                          verticalPadding: 0,
                          borderRadius: 4,
                          style: mozillaTextRegularText(
                            fontSize: 13,
                            color: controller.bookingTabsList![index].deletedClr!.value == true?DynamicColors.whiteClr: DynamicColors.textClr,
                          ),
                          btnText: controller.bookingTabsList![index].deletedClr!.value == true ?controller.bookingTabsList![index].bookingTabs:
                          "${controller.bookingTabsList![index].bookingTabs}(${controller.bookingTabsList![index].bookingCount.toString()})",
                          btnColor: controller.bookingTabsList![index].deletedClr!.value == true ? DynamicColors.redClr:
                          controller.bookingTabsList![index].selectedClr!.value == true ? DynamicColors.primaryClr.withOpacity(0.4) : DynamicColors.secondaryClr,
                          onTap: () {
                            if(controller.bookingTabsList![index].deletedClr!.value == false) {
                              int selectedIndex =
                              controller.bookingTabsList!.indexWhere((
                                  test) => test.selectedClr!.value == true);
                              if (selectedIndex != -1) {
                                controller.bookingTabsList![selectedIndex]
                                    .selectedClr!.value = false;
                              }
                              controller.bookingTabsList![index].selectedClr!
                                  .value = true; // <-- fix selection}
                              controller.update();
                            }
                          },
                        ):

                        SizedBox(
                          width: 150,
                          child: Container(color: DynamicColors.secondaryClr,
                            child: DropdownButton<String>(
                              value: controller.bookingTabsList![index].selectedDropDownValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              hint: Text("JOB DUE BY",
                                style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: DynamicColors.textClr
                                ),
                              ),
                              underline: const SizedBox(),
                              items: controller.bookingTabsList![index].dropDownList!.map((item) {
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
                                controller.bookingTabsList!.indexWhere((test) => test.selectedClr!.value == true);
                                if (selectedIndex != -1) {
                                  controller.bookingTabsList![selectedIndex].selectedClr!.value = false;
                                }
                                setState(() {

                                  controller.bookingTabsList![index].selectedDropDownValue = value;
                                  controller.bookingTabsList![index].selectedClr!.value = true; // <-- fix selection

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
                  rows: List.generate(
                    controller.dashboardTableModelData!.data!.length,
                        (index) {
                      final item = controller.dashboardTableModelData!.data![index];
                      bool isSelected = index == selectedRowIndex;

                      return DataRow(
                        selected: isSelected,
                        cells: [

                          /// Checkbox
                          DataCell(
                            Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  selectedRowIndex = value! ? index : -1;
                                });
                              },
                            ),
                          ),

                          /// TYPE
                          DataCell(
                            Icon(Icons.laptop_chromebook_outlined,
                              color: Colors.blue,
                            ),
                          ),

                          /// REF #
                          DataCell(Text(item.referenceNumber ?? "-")),

                          /// DATETIME
                          DataCell(Text(item.pickupDate.toString())),

                          /// CUSTOMER
                          DataCell(Text(item.name!)),

                          /// PICKUP
                          DataCell(
                            SizedBox(
                              width: 160,
                              child: Text(
                                item.pickup ?? "-",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          /// DROPOFF
                          DataCell(
                            SizedBox(
                              width: 160,
                              child: Text(
                                item.dropoff ?? "-",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          /// ACCOUNT
                          DataCell(Text(item.account!.name??"")),

                          /// DRIVER
                          DataCell(Text(item.driver!.name ?? "")),

                          /// VEHICLE
                          DataCell(Text(item.vehicleType!.name ?? "-")),

                          /// NOTE
                          DataCell(
                            SizedBox(
                              width: 180,
                              child: Text(
                                item.notes!.isEmpty?"": item.notes![0].note ?? "-",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          /// FARE
                          DataCell(Text("£ ${item.fares ?? "0.00"}")),

                          /// STATUS
                          DataCell(
                            Text(
                              /*item.status ??*/ "-",
                              style: TextStyle(
                                color:/* item.status == "WAITING"
                                    ? Colors.orange
                                    :*/ Colors.green,
                              ),
                            ),
                          ),

                          /// J/T
                          DataCell(Text(item.journeyType!.journeyType ?? "-")),

                          /// P/T
                          DataCell(Text(item.paymentType!.name ?? "-")),

                          /// ACTIONS
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward, color: Colors.green),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => DispatchBookingAlert(),
                                    );
                                  },
                                ),
                                const Text("|"),
                                IconButton(
                                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                                  onPressed: () {
                                    showShortcutDialog(
                                      context,
                                      title: "Delete",
                                      contentWidget: const Text("Are you sure?"),
                                    );
                                  },
                                ),
                                const Text("|"),
                                IconButton(
                                  icon: const Icon(Icons.more_horiz, color: Colors.green),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  //
                  // rows: List.generate(controller.dashboardTableModelData!.data!.length, (index) {
                  //   bool isSelected = index == selectedRowIndex;
                  //   return DataRow(
                  //     cells: [
                  //       DataCell(Checkbox(
                  //         value: isSelected,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             selectedRowIndex = value! ? index : -1;
                  //           });
                  //         },
                  //       )),
                  //       DataCell(Icon(Icons.laptop_chromebook_outlined, color: Colors.blue)),
                  //       DataCell(Text("BCB74867")),
                  //       DataCell(Text("02-05-25 23:36")),
                  //       DataCell(Text("NADEEM")),
                  //       DataCell(Text("FLAT 10 BLANDFORD COURT ...")),
                  //       DataCell(Text("65 JEDBURGH ROAD, LONDON")),
                  //       DataCell(Text("DRV")),
                  //       DataCell(Text("CAPITA BUSI ...")),
                  //       DataCell(Text("SALOON")),
                  //       DataCell(Text("Lorem ipsum dolor sit amet...")),
                  //       DataCell(Text("£ 14.00")),
                  //       DataCell(Text("WAITING")),
                  //       DataCell(Text("o/w")),
                  //       DataCell(Text("CASH")),
                  //       DataCell(
                  //         Row(
                  //           children: [
                  //             OutlinedButton(
                  //               style: OutlinedButton.styleFrom(
                  //                 padding: EdgeInsets.zero,
                  //                 minimumSize: Size.zero,
                  //                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //                 side: BorderSide.none,
                  //               ),
                  //               onPressed: () {
                  //                 showDialog(
                  //                   context: context,
                  //                   builder: (_) => DispatchBookingAlert(),
                  //                 );
                  //               },
                  //               child: ImageIcon(
                  //                   AssetImage(Images.fowardIcon),
                  //                   color: Colors.green, size: 20),
                  //             ),
                  //             Padding(
                  //                 padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  //                 child: Text("|")),
                  //             OutlinedButton(
                  //               style: OutlinedButton.styleFrom(
                  //                 padding: EdgeInsets.zero,
                  //                 minimumSize: Size.zero,
                  //                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //                 side: BorderSide.none,
                  //               ),
                  //               onPressed: () {
                  //                 showShortcutDialog(
                  //                   context,
                  //                   title: "testing",
                  //                   contentWidget: Center(child: Text("Testing"),),
                  //                 );
                  //               },
                  //               child: Icon(Icons.delete_forever, color: Colors.red, size: 20),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  //               child: Text("|"),
                  //             ),
                  //             OutlinedButton(
                  //               style: OutlinedButton.styleFrom(
                  //                 padding: EdgeInsets.zero,
                  //                 minimumSize: Size.zero,
                  //                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //                 side: BorderSide.none,
                  //               ),
                  //               onPressed: () {
                  //                 showShortcutDialog(
                  //                   context,
                  //                   title: "testing",
                  //                   contentWidget: Center(child: Text("Testing"),),
                  //                 );
                  //               },
                  //               child: Icon(Icons.more_horiz, color: Colors.green, size: 20),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   );
                  // }),
                ),
              )
            ],
          ),
        );
      }
    );
  }
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