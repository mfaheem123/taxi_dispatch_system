
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
import '../../alert/cancel_booking_alert.dart';
import '../../alert/complete_alert.dart';
import '../../alert/delete_permission_alert.dart';
import '../../alert/dispatch_booking.dart';
import '../../alert/dispatch_booking_alert.dart';
import '../../alert/edit_booking_fare.dart';
import '../../alert/fob_alert.dart';
import '../../component/images.dart';
import '../../component/networks/api.dart';
import '../../component/pagination.dart';
import '../../component/text_field.dart';
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

  List permissions = [];

  @override
  void initState() {
    // TODO: implement initState
    permissions = Api().sp.read('all_permissions') ?? [];
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
double widthss = MediaQuery.of(context).size.width;
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
                            width: widthss/11.5,
                            verticalPadding: 0,
                            borderRadius: 4,
                            style: mozillaTextRegularText(
                              fontSize: widthss/135,
                              color: controller.bookingTabsList![index].deletedClr!.value == true?DynamicColors.whiteClr: DynamicColors.textClr,
                            ),
                            btnText: controller.bookingTabsList![index].deletedClr!.value == true ?controller.bookingTabsList![index].bookingTabs:
                            "${controller.bookingTabsList![index].bookingTabs}(${controller.bookingTabsList![index].bookingCount.toString()})",
                            btnColor: controller.bookingTabsList![index].deletedClr!.value == true ? DynamicColors.redClr:
                            controller.bookingTabsList![index].selectedClr!.value == true ? DynamicColors.primaryClr.withOpacity(0.4) : DynamicColors.secondaryClr,
                            onTap: () {
                              controller.dropDownShow.value = false;
                              if(controller.bookingTabsList![index].deletedClr!.value == true){
                                controller.deleteJobs();
                              }else{
                                controller.selectionIndex = index;
                                controller.temSelectedTab = index;
                                controller.getTableDataStatus(index: index);
                              }
                            },
                          ):

                          SizedBox(
                            width: widthss/11.5,
                            child: Container(color: DynamicColors.secondaryClr,
                              child: DropdownButton<String>(
                                value: controller.bookingTabsList![index].selectedDropDownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                hint: Text("JOB DUE BY",
                                  style: mozillaTextRegularText(
                                      fontSize: widthss/135,
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
                                  controller.dropDownShow.value = false;
                                  print(controller.bookingTabsList![index].id);
                                  print(index);
                                  controller.selectionIndex = index;
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


                if(permissions.contains('read_booking'))
                  controller.dashboardTableModelData == null?SizedBox():
                  SizedBox(
                  width: Get.width,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                    columnSpacing: widthss/80,
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
                      buildHeaderWithSearch(widget: SizedBox(
                        width: 20,
                        child: Checkbox(value: false, onChanged: (v){
                        }),
                      )),
                      buildHeaderWithSearch(title: "TYPE"),
                      buildHeaderWithSearch(
                          widhtss: widthss/20.5,
                          title: "REF #", onChanged: (v){
                        controller.referenceNumber.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(
                          widhtss: widthss/20.5,
                          title: "DATETIME", onChanged: (v){
                        controller.pickupDate.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(
                          widhtss: widthss/20.5,
                          title: "CUS", onChanged: (v){
                        controller.name.text = v;
                        controller.getDashboardTableData(tableId: controller.selectedTabId);
                      }),
                      buildHeaderWithSearch(
                          widhtss: widthss/20.5,
                          title: "PICKUP", onChanged: (v){
                        controller.pickup.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(
                          widhtss: widthss/20.5,
                          title: "DROPOFF", onChanged: (v){
                        controller.dropOff.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(widhtss: widthss/20.5,title: "ACC", onChanged: (v){
                        controller.accountName.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(widhtss: widthss/20.5,title: "DRV", onChanged: (v){
                        controller.driverName.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(widhtss: widthss/20.5,title: "VEH", onChanged: (v){
                        controller.vehicleTypeName.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(widhtss: widthss/20.5,title: "NOTE", onChanged: (v){
                        controller.notes.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(widhtss: widthss/20.5,title: "FARE", onChanged: (v){
                        controller.fares.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(widhtss: widthss/20.5,title: "STATUS", onChanged: (v){
                        controller.bookingStatus.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(widhtss: widthss/20.5,title: "J/T", onChanged: (v){
                        controller.journeyType.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(widhtss: widthss/20.5,title: "P/T", onChanged: (v){
                        controller.paymentType.text = v;
                        controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                      }),
                      buildHeaderWithSearch(widhtss: widthss/20.5,title: "Action"),
                    ],
                    rows: List.generate(
                      controller.dashboardTableModelData!.data!.length,
                          (index) {
                        final item = controller.dashboardTableModelData!.data![index];
                        bool isSelected = index == selectedRowIndex;
                        return DataRow(
                          key: ValueKey(item.id),
                          // index: index,
                          selected: isSelected,
                          color: MaterialStateProperty.resolveWith<Color?>(
                                (states) {
                              if (isSelected) {
                                return Colors.blue.withOpacity(0.2);
                              }
                              return null;
                            },
                          ),

                          cells: [

                            /// Checkbox ❌ (NO right click)
                            DataCell(
                              permissions.contains('create_trash_booking')?SizedBox.shrink(): Checkbox(
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
                            tabIndex: controller.selectionIndex,
                                onRightClick: () {
                                  print("RIGHT CLICK REF #: ${item.referenceNumber}");
                                },
                                child: Text(item.referenceNumber ?? "-",
                                style: TextStyle(
                                  fontSize: widthss/140,
                                ),
                                ),
                              ),
                            ),

                            /// DATETIME ✅
                            DataCell(
                              rightClickTextCell(
                                item: item,
                                tabIndex: controller.selectionIndex,
                                onRightClick: () {
                                  print("RIGHT CLICK DATETIME: ${item.pickupDate}");
                                },
                                child: Container(
                                  width: widthss/20.5,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  // APPLY YOUR COLOR HERE
                                  decoration: BoxDecoration(
                                    color: DynamicColors.secondaryClr.withOpacity(0.7),
                                    // Optional: borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text("${DateFormat('dd-MM-yyyy')
                                      .format(item.pickupDate!)} ${item.pickupTime}",
                                    style: TextStyle(
                                      fontSize: widthss/140,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// CUSTOMER ✅
                            DataCell(
                              SizedBox(
                                width: widthss/20.5,
                                child: rightClickTextCell(
                                  item: item,
                                  tabIndex: controller.selectionIndex,
                                  onRightClick: () {
                                    print("RIGHT CLICK CUSTOMER: ${item.name}");
                                  },
                                  child: Text(item.name ?? "-",
                                    style: TextStyle(
                                      fontSize: widthss/140,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// PICKUP ✅
                            DataCell(
                              rightClickTextCell(
                                item: item,
                                tabIndex: controller.selectionIndex,
                                // onRightClick: () {
                                //   print("RIGHT CLICK PICKUP: ${item.pickup}");
                                //   showMenu(
                                //     context: context,
                                //     position: RelativeRect.fromLTRB(
                                //       // event.position.dx,
                                //       // event.position.dy,
                                //       15,
                                //       0,
                                //       0,
                                //       0,
                                //     ),
                                //     items: [
                                //       const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                //       const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                //     ],
                                //   );
                                //
                                // },
                                child: Container(
                                  width: widthss/20.5,
                                  // width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  // APPLY YOUR COLOR HERE
                                  decoration: BoxDecoration(
                                    color: item.airport!.pickup!.locationType!.backgroundColor == null?Colors.transparent:
                                    Color(int.parse("0xFF${item.airport!.pickup!.locationType!.backgroundColor}")),
                                    // Optional: borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    item.pickup ?? "-",
                                    style: mozillaTextRegularText(
                                      fontSize: widthss/140,
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
                                tabIndex: controller.selectionIndex,
                                onRightClick: () {
                                  print("RIGHT CLICK DROPOFF: ${item.dropoff}");
                                },
                                child: Container(
                                  width: widthss/20.5,
                                  // width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  // APPLY YOUR COLOR HERE
                                  decoration: BoxDecoration(
                                    color: item.airport!.dropoff!.locationType!.backgroundColor == null?Colors.transparent:
                                    Color(int.parse("0xFF${item.airport!.dropoff!.locationType!.backgroundColor}")),
                                    // Optional: borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    item.dropoff ?? "-",
                                    style: mozillaTextRegularText(
                                      fontSize: widthss/140,
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
                                tabIndex: controller.selectionIndex,
                                onRightClick: () {
                                  print("RIGHT CLICK ACCOUNT: ${item.account?.name}");
                                },
                                child: Container(
                                    width: widthss/20.5,
                                    height: double.infinity,
                                    alignment: Alignment.center,

                                    // APPLY YOUR COLOR HERE
                                    decoration: BoxDecoration(
                                      color: item.account!.backgroundColor == null?Colors.transparent: Color(int.parse("0xFF${item.account!.backgroundColor}")),
                                      // Optional: borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(item.account?.name ?? "",
                                      style: mozillaTextRegularText(
                                        fontSize: widthss/140,
                                        color: item.account!.foregroundColor == null?DynamicColors.black: Color(int.parse("0xFF${item.account!.foregroundColor}")),
                                      ),
                                    )),
                              ),
                            ),

                            /// DRIVER ✅
                            DataCell(
                              SizedBox(
                                width: widthss/20.5,
                                child: rightClickTextCell(
                                  item: item,
                                  tabIndex: controller.selectionIndex,
                                  onRightClick: () {
                                    print("RIGHT CLICK DRIVER: ${item.driver?.name}");
                                  },
                                  child: Text(item.driver?.name ?? "",
                                    style: TextStyle(
                                      fontSize: widthss/140,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// VEHICLE ✅
                            DataCell(
                              rightClickTextCell(
                                item: item,
                                tabIndex: controller.selectionIndex,
                                onRightClick: () {
                                  print("RIGHT CLICK VEHICLE: ${item.vehicleType?.name}");
                                },
                                child: Container(
                                  width: widthss/20.5,
                                  height: double.infinity,
                                  alignment: Alignment.center,

                                  // APPLY YOUR COLOR HERE
                                  decoration: BoxDecoration(
                                    color: item.vehicleType!.backgroundColor == null?Colors.transparent: Color(int.parse("0xFF${item.vehicleType!.backgroundColor}")),
                                    // Optional: borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(item.vehicleType?.name ?? "-",
                                    style: mozillaTextRegularText(
                                      fontSize: widthss/140,
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
                                tabIndex: controller.selectionIndex,
                                // onRightClick: () {
                                //   print("RIGHT CLICK NOTE");
                                // },
                                child: SizedBox(
                                  width: widthss/20.5,
                                  child: Text(
                                    item.notes!.isEmpty ? "" : item.notes![0].note ?? "-",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: widthss/140,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// FARE ✅
                            DataCell(
                              SizedBox(
                                width: widthss/20.5,
                                child: rightClickTextCell(
                                  item: item,
                                  tabIndex: controller.selectionIndex,
                                  // onRightClick: () {
                                  //   print("RIGHT CLICK FARE: ${item.fares}");
                                  // },
                                  child: Text("£ ${item.totalCharges ?? "0.00"}",
                                    style: TextStyle(
                                      fontSize: widthss/140,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// STATUS ✅
                            DataCell(
                              rightClickTextCell(
                                item: item,
                                tabIndex: controller.selectionIndex,
                                // onRightClick: () {
                                //   print("RIGHT CLICK STATUS");
                                // },
                                child: Container(
                                  width: widthss/20.5,
                                  height: double.infinity,
                                  alignment: Alignment.center,

                                  // APPLY YOUR COLOR HERE
                                  decoration: BoxDecoration(
                                    color: DynamicColors.statusColor,
                                    // Optional: borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    "${item.bookingStatus!.bookingStatus}",
                                    style: TextStyle(color: DynamicColors.whiteClr,
                                      fontSize: widthss/140,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// J/T ✅
                            DataCell(
                              SizedBox(
                                width: widthss/20.5,
                                child: rightClickTextCell(
                                  item: item,
                                  tabIndex: controller.selectionIndex,
                                  onRightClick: () {
                                    print("RIGHT CLICK JOURNEY TYPE");
                                  },
                                  child: Text(item.journeyType?.journeyType ?? "-",
                                    style: TextStyle(
                                      fontSize: widthss/140,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// P/T ✅
                            DataCell(
                              rightClickTextCell(
                                item: item,
                                tabIndex: controller.selectionIndex,
                                onRightClick: () {

                                  print("RIGHT CLICK PAYMENT TYPE");
                                },
                                child: Container(
                                    width: widthss/19.5,
                                    height: double.infinity,
                                    alignment: Alignment.center,

                                    // APPLY YOUR COLOR HERE
                                    decoration: BoxDecoration(
                                      color: DynamicColors.primaryClr,
                                      // Optional: borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(item.paymentType?.name ?? "-",
                                      style: TextStyle(
                                          color: DynamicColors.whiteClr,
                                        fontSize: widthss/140,
                                      ),
                                    )),
                              ),
                            ),

                            /// ACTIONS ❌
                            DataCell(
                              Row(

                                children: [
                                  IconButton(
                                    icon:  Icon(Icons.arrow_forward, color: Colors.green),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => DispatchBooking(bookingItem: item),
                                      );
                                    },
                                  ),
                                   Text("|"),
                                  if(permissions.contains('delete_booking'))  IconButton(
                                    icon:  Icon(Icons.delete_forever, color: Colors.red),
                                    onPressed: () {
                                      // showShortcutDialog(
                                      //   context,
                                      //   title: "Delete",
                                      //   contentWidget: const Text("Are you sure?"),
                                      // );
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                            DeletePermissionAlert(
                                              deleteFunctionName: (){
                                                controller.deleteBooking(item.id);
                                              },
                                            ),
                                      );
                                    },
                                  ),
                                   Text("|"),
                                  if(permissions.contains('update_booking')) Expanded(
                                    child: IconButton(
                                      icon:  Icon(Icons.more_horiz, color: Colors.green),
                                      onPressed: () async {
                                        controller.dashBoardDataBinding(id: item.id!);
                                        // Get.to(UpdateBooking(data: item.id,));

                                        //   final newTabUrl =
                                        //       "${Uri.base.origin}${Routes.updateBooking}?data=${item.id}";
                                        //     // final newTabUrl = Uri.base.origin + Routes.updateBooking;
                                        // if (await canLaunchUrl(Uri.parse(newTabUrl))) {
                                        //   await launchUrl(
                                        //   Uri.parse(newTabUrl),
                                        //   mode: LaunchMode.externalApplication,
                                        //   );
                                        //   } else {
                                        //   throw 'Could not launch $newTabUrl';
                                        //   }


                                        // Instead of launchUrl
                                        // Navigator.pushNamed(
                                        //   context,
                                        //   Routes.updateBooking,
                                        //   arguments: item.id,
                                        // );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
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






  // 1. Right Click Wrapper
  Widget rightClickTextCell({
    required Widget child,
    required dynamic item,
    required tabIndex,
    VoidCallback? onRightClick,

  }) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {

          if (onRightClick != null) onRightClick();

          final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
          final RelativeRect position = RelativeRect.fromRect(
            Rect.fromPoints(event.position, event.position),
            Offset.zero & overlay.size,
          );

          showRowContextMenu(
            context: context,
            position: position,
            globalPosition: event.position,
            item: item,
            tabIndex: tabIndex
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

// 1. Pehle context menu dikhane wala main function
  void showRowContextMenu({
    required BuildContext context,
    required RelativeRect position,
    required Offset globalPosition,
    required dynamic item,
    required tabIndex
  }) async {
    print("--- Context Menu Debug ---");
    print("TabIndex Value: $tabIndex");
    print("TabIndex Type: ${tabIndex.runtimeType}");
    print("--------------------------");
    print("DEBUG: tabIndex is $tabIndex and type is ${tabIndex.runtimeType}");


    _hideSubMenu();

    // Humne width fix rakhi hai taake submenu ki calculation asaan ho
    const double menuWidth = 200.0;

    await showMenu<String>(
      context: context,
      position: position,
      color: Colors.white,
      constraints: const BoxConstraints(minWidth: menuWidth, maxWidth: menuWidth),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        if (tabIndex != 2 && tabIndex != 3 && tabIndex != 4)
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          child: Builder(
              builder: (innerContext) {
                return MouseRegion(
                  onEnter: (_) {
                    // Yahan hum innerContext use kar rahe hain jo menu item ki location dega
                    _showSubMenu(innerContext, [
                      if (tabIndex != 1) {'title': 'DISPATCH', 'icon': Icons.near_me},
                      if (tabIndex != 1) {'title': 'FOLLOW ON', 'icon': Icons.sync},
                      if (tabIndex != 1) {'title': 'SMS', 'icon': Icons.chat_bubble},
                      if(tabIndex == 1) {'title': 'FUTURE', 'icon': Icons.timelapse},
                    ], item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _buildMenuRow(Icons.local_shipping, "DISPATCH", true),
                  ),
                );
              }
          ),
        ),
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          child: Builder(
              builder: (innerContext) {
                return MouseRegion(
                  onEnter: (_){
                    _showSubMenu(innerContext, [
                      if (tabIndex == 4) {'title': 'ACCEPT', 'icon':Icons.thumb_up_alt_rounded},
                      if (tabIndex == 4) {'title': 'DECLINE', 'icon':Icons.thumb_down},
                      if(tabIndex != 3) {'title': 'COMPLETE', 'icon': Icons.task_alt},
                      {'title': 'COPY', 'icon': Icons.copy},
                      {'title': 'AUDIT REPORT', 'icon': Icons.description},
                      {'title': 'UPDATE', 'icon': Icons.update},
                      if (tabIndex != 2) {'title': 'CANCEL', 'icon': Icons.block},
                      if (tabIndex != 2) {'title': 'ALLOCATE', 'icon': Icons.manage_accounts},
                      if(tabIndex !=3) {'title': 'EDIT FARE', 'icon': Icons.edit_note},
                      if (tabIndex == 0 || tabIndex == 1 || tabIndex == 2) {'title': 'RECOVER', 'icon': Icons.settings_backup_restore},
                      {'title': 'CALL CUSTOMER', 'icon': Icons.phone},
                    ], item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _buildMenuRow(
                        Icons.build_circle_outlined, "ACTIONS", true),
                  ),
                );
              }
          ),
        ),
          if (tabIndex != 4)
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          child: Builder(
             builder: (innerContext) {
               return MouseRegion(
                 onEnter: (_) {
                   _showSubMenu(innerContext, [
                     if (tabIndex == 2) {'title': 'RESEND DISPATCH SMS', 'icon': Icons.send},
                     if (tabIndex != 2) {'title': 'EMAIL', 'icon': Icons.email},
                     if (tabIndex != 2) {'title': 'SMS', 'icon': Icons.sms},
                   ], item);
                   },
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 12),
                   child: _buildMenuRow(Icons.share, "SEND", true),
                 ),
               );
             }
          ),
        ),
        // const PopupMenuDivider(),
        // PopupMenuItem<String>(
        //   onTap: () => _handleSubMenuAction(context, "SMS", item),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 12),
        //     child: _buildMenuRow(Icons.chat_bubble_outline, "SMS", false),
        //   ),
        // ),
      ],
    );
    _hideSubMenu();
  }



  OverlayEntry? _subMenuEntry;

  void _hideSubMenu() {
    _subMenuEntry?.remove();
    _subMenuEntry = null;
  }

// 2. Submenu function jo RenderBox use karega (Dor jane wala masla khatam)
  void _showSubMenu(BuildContext itemContext, List<Map<String, dynamic>> subItems, dynamic item) {
    _hideSubMenu();

    // Ye main menu item ki position nikaal raha hai
    final RenderBox renderBox = itemContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final screenWidth = MediaQuery.of(itemContext).size.width;
    const double subMenuWidth = 200.0;

    // Logic: Menu ke right side par space check karein
    double xPos = offset.dx + size.width - 5; // 5px overlap for smooth feel

    // Agar right side pe jagah nahi hai (Table ke end columns mein), to left side pe dikhayen
    if (xPos + subMenuWidth > screenWidth) {
      xPos = offset.dx - subMenuWidth + 5;
    }

    _subMenuEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: xPos,
        top: offset.dy - 5, // Menu item ke barabar alignment
        child: MouseRegion(
          onExit: (_) => _hideSubMenu(),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Container(
              width: subMenuWidth,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: subItems.map((sub) => InkWell(
                  onTap: () {
                    _hideSubMenu();
                    Navigator.pop(itemContext); // Main menu band karein
                    _handleSubMenuAction(itemContext, sub['title'], item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Icon(sub['icon'], size: 18, color: Colors.blueGrey.shade800),
                        const SizedBox(width: 12),
                        Text(sub['title'],
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(itemContext).insert(_subMenuEntry!);
  }


  void _handleSubMenuAction(BuildContext context, String title, dynamic item) {
    if (title == "DISPATCH") {
      showDialog(
        context: context,
        builder: (context) => DispatchBooking(bookingItem: item), // Aapki existing class
      );
    } else if (title == "SMS") {
      // SMS wala Alert
      showShortcutDialog(
        context,
        title: "Send SMS",
        contentWidget: const Text("Do you want to send a notification?"),
      );
    } else if (title == "FOLLOW ON") {
      // Follow on logic
      showDialog(
        context: context,
        builder: (context) => DispatchFobAlert(bookingItem: item),
      );
    }
    else if (title == "COMPLETE") {
      showDialog(
          context: context,
          builder: (context) => CompleteBookingAlert(bookingId: item.id,
              bookingItem: item),
      );
    }
    else if (title == "CANCEL") {
      showDialog(
        context: context,
        builder: (context) => CancelBookingRequest(bookingId: item.id,
            bookingItem: item),
      );
    }
    else if (title == "EDIT FARE") {
      showDialog(
        context: context,
        builder: (context) => EditBookingFare(bookingId: item.id,
            bookingItem: item),
      );
    }
    else if(title == "RECOVER"){
      controller.recoverBooking(item.id);
    }
  }





// 3. Helper for Menu UI
  Widget _buildMenuRow(IconData icon, String title, bool hasArrow) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey.shade800),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black)
              )
          ),
          if (hasArrow) const Icon(Icons.arrow_right, size: 20, color: Colors.grey),
        ],
      ),
    );
  }


}


DataColumn buildHeaderWithSearch({String? title,removeSearching = false, Widget? widget, textFieldHeight, double? fontSize, Widget? customWidget, Function(String)? onChanged,
  TextEditingController? controller,
  double? widhtss
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
                width: widhtss??100,
                height: textFieldHeight??28,
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  inputFormatters: [UpperCaseTextFormatter()],
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