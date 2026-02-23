
import 'dart:convert';
import 'dart:ui';
import 'dart:ui' as html show window;
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../alert/dispatch_booking_alert.dart';
import '../../component/images.dart';
import '../../component/pagination.dart';
import '../../routes/app_pages.dart';
import '../booking_view/update_booking.dart';
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
                            if(controller.bookingTabsList![index].deletedClr!.value == true){
                              controller.deleteJobs();
                            }else{
                              controller.temSelectedTab = index;
                              controller.getTableDataStatus(index: index);
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
                                print(controller.bookingTabsList![index].id);
                                print(index);
                                controller.getTableDataStatus(index: index, value: value);
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


              controller.dashboardTableModelData == null?SizedBox(): SizedBox(
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
                  ),
                  columns: [
                    buildHeaderWithSearch(widget: Checkbox(value: false, onChanged: (v){
                    })),
                    buildHeaderWithSearch(title: "TYPE"),
                    buildHeaderWithSearch(title: "REF #", onChanged: (v){
                      controller.referenceNumber.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "DATETIME", onChanged: (v){
                      controller.pickupDate.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "CUS", onChanged: (v){
                      controller.name.text = v;
                      controller.getDashboardTableData(tableId: controller.selectedTabId);
                    }),
                    buildHeaderWithSearch(title: "PICKUP", onChanged: (v){
                      controller.pickup.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "DROPOFF", onChanged: (v){
                      controller.dropOff.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "ACC", onChanged: (v){
                      controller.accountName.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "DRV", onChanged: (v){
                      controller.driverName.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "VEH", onChanged: (v){
                      controller.vehicleTypeName.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "NOTE", onChanged: (v){
                      controller.notes.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "FARE", onChanged: (v){
                      controller.fares.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "STATUS", onChanged: (v){
                      controller.bookingStatus.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "J/T", onChanged: (v){
                      controller.journeyType.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "P/T", onChanged: (v){
                      controller.paymentType.text = v;
                      controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                    }),
                    buildHeaderWithSearch(title: "Action"),
                  ],
                  rows: List.generate(
                    controller.dashboardTableModelData!.data!.length,
                        (index) {
                      final item = controller.dashboardTableModelData!.data![index];
                      bool isSelected = index == selectedRowIndex;
                      return DataRow.byIndex(
                        index: index,
                        selected: isSelected,
                        cells: [

                          /// Checkbox ❌ (NO right click)
                          DataCell(
                            Checkbox(
                              value: controller.selectedDeletesItems?.contains(item) ?? false,
                              onChanged: (bool? value) { // Checkbox value is nullable bool
                                if (value == null) return;

                                setState(() {
                                  // 2. Ensure the list exists before using it
                                  controller.selectedDeletesItems ??= [];

                                  if (value) {
                                    // If checked, add to list
                                    controller.selectedDeletesItems!.add(item);
                                    selectedRowIndex = index;
                                  } else {
                                    // If unchecked, remove from list
                                    controller.selectedDeletesItems!.remove(item);
                                    selectedRowIndex = -1;
                                  }
                                });
                              },
                              // onChanged: (value) {
                              //   setState(() {
                              //     print(item);
                              //     if(controller.selectedDeletesItems!.contains(item)){
                              //       controller.selectedDeletesItems!.remove(item);
                              //     }else{
                              //       controller.selectedDeletesItems!.add(item);
                              //     }
                              //     selectedRowIndex = value! ? index : -1;
                              //   });
                              // },
                            ),
                          ),

                          /// TYPE ❌
                          DataCell(
                            Icon(
                              item.bookingSource == "dashboard"
                                  ? Icons.laptop_chromebook_outlined
                                  : Icons.mobile_screen_share,
                              color: Colors.blue,
                            ),
                          ),

                          /// REF # ✅
                          DataCell(
                            rightClickTextCell(
                              item: item,
                              onRightClick: () {
                                print("RIGHT CLICK REF #: ${item.referenceNumber}");
                              },
                              child: Text(item.referenceNumber ?? "-"),
                            ),
                          ),

                          /// DATETIME ✅
                          DataCell(
                            rightClickTextCell(
                              item: item,
                              onRightClick: () {
                                print("RIGHT CLICK DATETIME: ${item.pickupDate}");
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,

                                // APPLY YOUR COLOR HERE
                                decoration: BoxDecoration(
                                  color: DynamicColors.secondaryClr.withOpacity(0.7),
                                  // Optional: borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text("${DateFormat('dd-MM-yyyy')
                                    .format(item.pickupDate!)} ${item.pickupTime}"),
                              ),
                            ),
                          ),

                          /// CUSTOMER ✅
                          DataCell(
                            rightClickTextCell(
                              item: item,
                              onRightClick: () {
                                print("RIGHT CLICK CUSTOMER: ${item.name}");
                              },
                              child: Text(item.name ?? "-"),
                            ),
                          ),

                          /// PICKUP ✅
                          DataCell(
                            rightClickTextCell(
                              item: item,
                              onRightClick: () {
                                print("RIGHT CLICK PICKUP: ${item.pickup}");
                                showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                    // event.position.dx,
                                    // event.position.dy,
                                    0,
                                    0,
                                    0,
                                    0,
                                  ),
                                  items: [
                                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                  ],
                                );

                              },
                              child: Container(
                                width: 160,
                                // width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                // APPLY YOUR COLOR HERE
                                decoration: BoxDecoration(
                                  color: item.airport!.pickup!.locationType!.backgroundColor == null?DynamicColors.whiteClr:
                                  Color(int.parse("0xFF${item.airport!.pickup!.locationType!.backgroundColor}")),
                                  // Optional: borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  item.pickup ?? "-",
                                  style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: item.airport!.pickup!.locationType!.foregroundColor == null?DynamicColors.black:
                                    Color(int.parse("0xFF${item.airport!.pickup!.locationType!.foregroundColor}")),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),

                          /// DROPOFF ✅
                          DataCell(
                            rightClickTextCell(
                              item: item,
                              onRightClick: () {
                                print("RIGHT CLICK DROPOFF: ${item.dropoff}");
                              },
                              child: Container(
                                width: 160,
                                // width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                // APPLY YOUR COLOR HERE
                                decoration: BoxDecoration(
                                  color: item.airport!.dropoff!.locationType!.backgroundColor == null?DynamicColors.whiteClr:
                                  Color(int.parse("0xFF${item.airport!.dropoff!.locationType!.backgroundColor}")),
                                  // Optional: borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  item.dropoff ?? "-",
                                  style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: item.airport!.dropoff!.locationType!.foregroundColor == null?DynamicColors.black:
                                    Color(int.parse("0xFF${item.airport!.dropoff!.locationType!.foregroundColor}")),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),

                          /// ACCOUNT ✅
                          DataCell(
                            rightClickTextCell(
                              item: item,

                              onRightClick: () {
                                print("RIGHT CLICK ACCOUNT: ${item.account?.name}");
                              },
                              child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,

                                  // APPLY YOUR COLOR HERE
                                  decoration: BoxDecoration(
                                    color: item.account!.backgroundColor == null?DynamicColors.whiteClr: Color(int.parse("0xFF${item.account!.backgroundColor}")),
                                    // Optional: borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(item.account?.name ?? "",
                                    style: mozillaTextRegularText(
                                      fontSize: 13,
                                      color: item.account!.foregroundColor == null?DynamicColors.black: Color(int.parse("0xFF${item.account!.foregroundColor}")),
                                    ),
                                  )),
                            ),
                          ),

                          /// DRIVER ✅
                          DataCell(
                            rightClickTextCell(
                              item: item,
                              onRightClick: () {
                                print("RIGHT CLICK DRIVER: ${item.driver?.name}");
                              },
                              child: Text(item.driver?.name ?? ""),
                            ),
                          ),

                          /// VEHICLE ✅
                          DataCell(
                            rightClickTextCell(
                               item: item,
                              onRightClick: () {
                                print("RIGHT CLICK VEHICLE: ${item.vehicleType?.name}");
                              },
                              child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,

                                  // APPLY YOUR COLOR HERE
                                  decoration: BoxDecoration(
                                    color: item.vehicleType!.backgroundColor == null?DynamicColors.whiteClr: Color(int.parse("0xFF${item.vehicleType!.backgroundColor}")),
                                    // Optional: borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(item.vehicleType?.name ?? "-",
                                  style: mozillaTextRegularText(
                                    fontSize: 13,
                                    color: item.vehicleType!.foregroundColor == null?DynamicColors.black: Color(int.parse("0xFF${item.vehicleType!.foregroundColor}")),
                                  ),
                                  ),
                              ),
                            ),
                          ),

                          /// NOTE ✅
                          DataCell(
                            rightClickTextCell(
                               item: item,
                              onRightClick: () {
                                print("RIGHT CLICK NOTE");
                              },
                              child: SizedBox(
                                width: 180,
                                child: Text(
                                  item.notes!.isEmpty ? "" : item.notes![0].note ?? "-",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),

                          /// FARE ✅
                          DataCell(
                            rightClickTextCell(
                               item: item,
                              onRightClick: () {
                                print("RIGHT CLICK FARE: ${item.fares}");
                              },
                              child: Text("£ ${item.fares ?? "0.00"}"),
                            ),
                          ),

                          /// STATUS ✅
                          DataCell(
                            rightClickTextCell(
                               item: item,
                              onRightClick: () {
                                print("RIGHT CLICK STATUS");
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,

                                // APPLY YOUR COLOR HERE
                                decoration: BoxDecoration(
                                  color: DynamicColors.statusColor,
                                  // Optional: borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  "${item.bookingStatus!.bookingStatus}",
                                  style: TextStyle(color: DynamicColors.whiteClr),
                                ),
                              ),
                            ),
                          ),

                          /// J/T ✅
                          DataCell(
                            rightClickTextCell(
                              item: item,
                              onRightClick: () {
                                print("RIGHT CLICK JOURNEY TYPE");
                              },
                              child: Text(item.journeyType?.journeyType ?? "-"),
                            ),
                          ),

                          /// P/T ✅
                          DataCell(
                            rightClickTextCell(
                              item: item,
                              onRightClick: () {

                                print("RIGHT CLICK PAYMENT TYPE");
                              },
                              child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,

                                  // APPLY YOUR COLOR HERE
                                  decoration: BoxDecoration(
                                    color: DynamicColors.primaryClr,
                                    // Optional: borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(item.paymentType?.name ?? "-",
                                  style: TextStyle(
                                    color: DynamicColors.whiteClr
                                  ),
                                  )),
                            ),
                          ),

                          /// ACTIONS ❌
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
                                  onPressed: () async {
                                    // controller.dashBoardDataBinding(id: item.id!);


                                    final newTabUrl =
                                        "${Uri.base.origin}${Routes.updateBooking}?data=${item.id}";
                                      // final newTabUrl = Uri.base.origin + Routes.updateBooking;
                                  if (await canLaunchUrl(Uri.parse(newTabUrl))) {
                                    await launchUrl(
                                    Uri.parse(newTabUrl),
                                    mode: LaunchMode.externalApplication,
                                    );
                                    } else {
                                    throw 'Could not launch $newTabUrl';
                                    }


                                    // Instead of launchUrl
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   Routes.updateBooking,
                                    //   arguments: item.id,
                                    // );

                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                          // return DataRow(
                      //   selected: isSelected,
                      //   cells: [
                      //     /// Checkbox
                      //     DataCell(
                      //       Checkbox(
                      //         value: isSelected,
                      //         onChanged: (value) {
                      //           setState(() {
                      //             selectedRowIndex = value! ? index : -1;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //
                      //     /// TYPE
                      //     DataCell(
                      //       Icon(
                      //         item.bookingSource == "dashboard"?Icons.laptop_chromebook_outlined:
                      //             Icons.mobile_screen_share,
                      //         color: Colors.blue,
                      //       ),
                      //     ),
                      //
                      //     /// REF #
                      //     DataCell(Text(item.referenceNumber ?? "-")),
                      //
                      //     /// DATETIME
                      //     DataCell(Text(item.pickupDate.toString())),
                      //
                      //     /// CUSTOMER
                      //     DataCell(Text(item.name!)),
                      //
                      //     /// PICKUP
                      //     DataCell(
                      //       SizedBox(
                      //         width: 160,
                      //         child: Text(
                      //           item.pickup ?? "-",
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //       ),
                      //     ),
                      //
                      //     /// DROPOFF
                      //     DataCell(
                      //       SizedBox(
                      //         width: 160,
                      //         child: Text(
                      //           item.dropoff ?? "-",
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //       ),
                      //     ),
                      //
                      //     /// ACCOUNT
                      //     DataCell(Text(item.account!.name??"")),
                      //
                      //     /// DRIVER
                      //     DataCell(Text(item.driver!.name ?? "")),
                      //
                      //     /// VEHICLE
                      //     DataCell(Text(item.vehicleType!.name ?? "-")),
                      //
                      //     /// NOTE
                      //     DataCell(
                      //       SizedBox(
                      //         width: 180,
                      //         child: Text(
                      //           item.notes!.isEmpty?"": item.notes![0].note ?? "-",
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //       ),
                      //     ),
                      //
                      //     /// FARE
                      //     DataCell(Text("£ ${item.fares ?? "0.00"}")),
                      //
                      //     /// STATUS
                      //     DataCell(
                      //       Text(
                      //         /*item.status ??*/ "-",
                      //         style: TextStyle(
                      //           color:/* item.status == "WAITING"
                      //               ? Colors.orange
                      //               :*/ Colors.green,
                      //         ),
                      //       ),
                      //     ),
                      //
                      //     /// J/T
                      //     DataCell(Text(item.journeyType!.journeyType ?? "-")),
                      //
                      //     /// P/T
                      //     DataCell(Text(item.paymentType!.name ?? "-")),
                      //
                      //     /// ACTIONS
                      //     DataCell(
                      //       Row(
                      //         children: [
                      //           IconButton(
                      //             icon: const Icon(Icons.arrow_forward, color: Colors.green),
                      //             onPressed: () {
                      //               showDialog(
                      //                 context: context,
                      //                 builder: (_) => DispatchBookingAlert(),
                      //               );
                      //             },
                      //           ),
                      //           const Text("|"),
                      //           IconButton(
                      //             icon: const Icon(Icons.delete_forever, color: Colors.red),
                      //             onPressed: () {
                      //               showShortcutDialog(
                      //                 context,
                      //                 title: "Delete",
                      //                 contentWidget: const Text("Are you sure?"),
                      //               );
                      //             },
                      //           ),
                      //           const Text("|"),
                      //           IconButton(
                      //             icon: const Icon(Icons.more_horiz, color: Colors.green),
                      //             onPressed: () {},
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // );
                    },
                  ),
                ),
              ),
              PaginationWidget(
                  currentPage: controller.dashboardTableCurrentPage.value,
                  totalPages: controller.dashboardTableTotalPages.value,
                  onPageChange: controller.dashboardTablePageChange),
            ],
          ),
        );
      }
    );
  }

  Widget rightClickTextCell({
    required Widget child,
    required VoidCallback onRightClick,
    required dynamic item,
  }) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {
          final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;

          final RelativeRect position = RelativeRect.fromRect(
            Rect.fromPoints(
              event.position,
              event.position,
            ),
            Offset.zero & overlay.size,
          );
          // onRightClick();
          showRowContextMenu(
            context: context,
            position: position,
            item: item,
          );
        }
      },
      child: child,
    );
  }

  List<NestedMenuItem> _makeMenus(BuildContext context) {
    return [
      NestedMenuItem(title: "CUSTOMERS", children: [
        NestedMenuItem(
          title: "ADD CUSTOMER",
          onTap: () {

          },
        ),
      ]),
    ];
  }

  void showRowContextMenu({
    required BuildContext context,
    required RelativeRect position,
    required dynamic item,
  }) {
    showMenu(
      context: context,
      position: position
      /*RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        0,
        0,
      )*/,
      items: const [
        PopupMenuItem(value: 'accept', child: Text('ACCEPT')),
        PopupMenuItem(value: 'decline', child: Text('DECLINE')),
        PopupMenuItem(value: 'copy', child: Text('COPY')),
        PopupMenuItem(value: 'audit', child: Text('AUDIT REPORT')),
      ],

    ).then((value) {
      if (value == null) return;

      switch (value) {
        case 'accept':
          print("ACCEPT ${item.referenceNumber}");
          break;
        case 'decline':
          print("DECLINE ${item.referenceNumber}");
          break;
        case 'copy':
          print("COPY ${item.referenceNumber}");
          break;
        case 'audit':
          print("AUDIT REPORT ${item.referenceNumber}");
          break;
        case 'update':
          print("UPDATE ${item.referenceNumber}");
          break;
        case 'edit_fare':
          print("EDIT FARE ${item.referenceNumber}");
          break;
        case 'call':
          print("CALL CUSTOMER ${item.name}");
          break;
      }
    });
  }


}


DataColumn buildHeaderWithSearch({String? title,removeSearching = false, Widget? widget, textFieldHeight, double? fontSize, Widget? customWidget, Function(String)? onChanged,
  TextEditingController? controller,
}) {
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
              : customWidget
              ?? SizedBox(
            width: 100,
            height: textFieldHeight??28,
            child: TextField(
              controller: controller,
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