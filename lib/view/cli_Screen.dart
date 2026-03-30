import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/oldDropDown.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/controller/cli_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../alert/delete_permission_alert.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/dropdown_button.dart';
import '../component/textStyle.dart';
import '../component/text_widget.dart';
import '../routes/app_pages.dart';
import 'dashboard_view/Controller/dashboard_controller.dart';
import 'dashboard_view/booking_table.dart';
import 'dashboard_view/models/dashboard_model.dart';
import 'dashboard_view/models/dashboard_table_model.dart';
import 'dashboard_view/widgets/user_info_widget.dart';

class ResponsivePassengerScreen extends StatefulWidget {
  final String extensionNumber;
  const ResponsivePassengerScreen({super.key, required this.extensionNumber});

  @override
  State<ResponsivePassengerScreen> createState() =>
      _ResponsivePassengerScreenState();
}

class _ResponsivePassengerScreenState extends State<ResponsivePassengerScreen> {

  /// ✅ Socket Controller
  final CliController socketController =
  Get.put(CliController(), permanent: true);

  @override
  void initState() {
    super.initState();
    print("PHONEEEEEEEEEEEEEEEEE${widget.extensionNumber}");

    /// ✅ CLI screen open hote hi socket connect
    // socketController.connectSocket(widget.extensionNumber);
    socketController.findCustomerApi(widget.extensionNumber);
  }

  @override
  void dispose() {
    socketController.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F9FC),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600), // increased max width
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final isDesktop = w >= 1200;
            final isTablet = w >= 820 && w < 1200;
            final isMobile = w < 820;

            final leftWidth = isDesktop ? 280.0 : (isTablet ? 260.0 : 220.0);
            final rightWidth = isDesktop ? 360.0 : (isTablet ? 320.0 : 300.0);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(blurRadius: 20, color: Color(0x14000000))
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: isMobile
                  ? _MobileLayout(
                leftWidth: leftWidth,
                rightWidth: rightWidth,
              )
                  : _WideLayout(
                leftWidth: leftWidth,
                rightWidth: rightWidth,
                maxWidth: w, // pass full width
              ),
            );
          },
        ),
      ),
    );
  }
}

/// --------- Wide (Web/Tablet landscape) ----------
class _WideLayout extends StatelessWidget {
  const _WideLayout(
      {required this.leftWidth, required this.rightWidth, required this.maxWidth});

  final double leftWidth;
  final double rightWidth;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final centerWidth = maxWidth - leftWidth - rightWidth - 1.5;
    return Row(
      children: [
        // LEFT SIDEBAR
        SizedBox(width: leftWidth, child: _LeftSidebar()),

        // CENTER
        SizedBox(width: centerWidth > 400 ? centerWidth : 400, child: _CenterArea()),

        // VERTICAL DIVIDER
        Container(width: 1.5, color: Color(0xFFE1E7F0)),

        // RIGHT SIDEBAR
        SizedBox(width: rightWidth, child: _RightSidebar()),
      ],
    );
  }
}

/// --------- Mobile (Stacked) ----------
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.leftWidth, required this.rightWidth});

  final double leftWidth;
  final double rightWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: double.infinity, child: _LeftSidebar()),
        Divider(height: 2, thickness: 2, color: Color(0xFFE1E7F0)),
        _CenterArea(),
        Divider(height: 2, thickness: 2, color: Color(0xFFE1E7F0)),
        SizedBox(width: double.infinity, child: _RightSidebar()),
      ],
    );
  }
}

/// --------- LEFT SIDEBAR ----------
class _LeftSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF5C7EA6), // slate-blue similar to screenshot
      padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top brand row
          Row(
            children: [
              Icon(Icons.local_taxi, color: Colors.yellow, size: 28),
              SizedBox(width: 8),
              Text(
                "SEA CARZ",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              Spacer(),
              Icon(Icons.close, color: Colors.white70),
            ],
          ),

          SizedBox(height: 28),

          // Profile Card
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6C8CB0),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: Color(0xFF5C7EA6)),
                ),
                SizedBox(height: 12),
                Text(
                  "Mr Mareevan",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  "04:08 PM",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70, letterSpacing: .2),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Table headers for recent rides (left column labels)
          Row(
            children: [
              Text("Date / Time",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.white70)),
            ],
          ),

          SizedBox(height: 12),

          // Tiny preview thumb (placeholder)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 26,
              width: 26,
              color: Colors.white24,
              child: Icon(Icons.image, size: 18, color: Colors.white70),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

/// --------- CENTER AREA ----------

// class _CenterArea extends StatefulWidget {
//   @override
//   State<_CenterArea> createState() => _CenterAreaState();
// }
//
// class _CenterAreaState extends State<_CenterArea> {
//   final CliController controller = Get.find<CliController>();
//
//   final RxInt selectedIndex = (-1).obs;
//
//   TextEditingController pickUpcontroller = TextEditingController();
//   TextEditingController dropOfUpcontroller = TextEditingController();
//
//   /// Dropdown variables
//   String? selectedDriver;
//   String? selectedVehicle;
//
//   final List<String> drivers = [
//     "Driver 1",
//     "Driver 2",
//     "Driver 3",
//   ];
//
//   final List<String> vehicles = [
//     "Toyota Prius",
//     "Honda Civic",
//     "Suzuki WagonR",
//   ];
//
//   /// Flag to control swapping in table
//   bool isSwapped = false;
//
//   DashboardController _controller = Get.find();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (_controller.dashboardAllData == null) {
//       _controller.dashboardData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final subtle = const Color(0xFF6B7C8F);
//
//     return GetBuilder<DashboardController>(
//       builder: (homeController) {
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//
//                 /// ================= HEADER =================
//                 Obx(() => Text(
//                   controller.customerName.value,
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     color: subtle,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 )),
//
//                 const SizedBox(height: 4),
//
//                 Obx(() => Text(
//                   controller.customerMobile.value.isEmpty
//                       ? "Loading..."
//                       : controller.customerMobile.value,
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 )),
//
//                 const SizedBox(height: 16),
//
//                 /// ================= SEARCH =================
//                 SizedBox(
//                   height: 44,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Search",
//                       prefixIcon: const Icon(Icons.search),
//                       filled: true,
//                       fillColor: const Color(0xFFF2F5F9),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 /// ================= PICKUP & DROPOFF =================
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: pickUpcontroller,
//                         decoration: InputDecoration(
//                           labelText: "Pickup",
//                           filled: true,
//                           fillColor: const Color(0xFFF2F5F9),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: TextField(
//                         controller: dropOfUpcontroller,
//                         decoration: InputDecoration(
//                           labelText: "Drop Off",
//                           filled: true,
//                           fillColor: const Color(0xFFF2F5F9),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 28),
//
//                 /// ================= RECENT RIDES =================
//                 Row(
//                   children: [
//                     Text(
//                       "Recent Rides",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(color: subtle, fontWeight: FontWeight.w700),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 /// ================= TABLE with Swap Button =================
//                 Obx(() {
//                   if (controller.isLoading.value) {
//                     return const Padding(
//                       padding: EdgeInsets.all(30),
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//
//                   if (controller.bookings.isEmpty) {
//                     return const Padding(
//                       padding: EdgeInsets.all(30),
//                       child: Text("No Bookings Found"),
//                     );
//                   }
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       // Swap Button near table
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isSwapped = !isSwapped; // Toggle swap flag
//                           });
//                         },
//                         child: const Text("Swap Destination & Pickup"),
//                       ),
//                       const SizedBox(height: 8),
//
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: ConstrainedBox(
//                           constraints: const BoxConstraints(minWidth: 850),
//                           child: DatatableWidget(
//                             columns: [
//                               buildHeaderWithSearch(title: "Pick-up", removeSearching: true),
//                               buildHeaderWithSearch(title: "Drop off", removeSearching: true),
//                               buildHeaderWithSearch(title: "Date", removeSearching: true),
//                               buildHeaderWithSearch(title: "Fare", removeSearching: true),
//                               buildHeaderWithSearch(title: "Action", removeSearching: true),
//                             ],
//                             totalRow: controller.bookings.length,
//                             rows: List.generate(
//                               controller.bookings.length,
//                                   (index) {
//                                 var booking = controller.bookings[index];
//
//                                 return DataRow(
//                                   cells: [
//                                     // ✅ Swap table values
//                                     DataCell(
//                                       rightClickTextCell(
//                                         item: booking,
//                                         onRightClick: () {
//                                           print("RIGHT CLICK REF #: ");
//                                         },
//                                         child:  SizedBox(
//                                           width: 180,
//                                           child: Text(
//                                             isSwapped ? booking["dropoff"] ?? "" : booking["pickup"] ?? "",
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ),
//
//                                     ),
//                                     DataCell(
//
//                                       rightClickTextCell(
//                                         item: booking,
//                                         onRightClick: () {
//                                           print("RIGHT CLICK REF #: ");
//                                         },
//                                         child: Text(
//                                           isSwapped ? booking["pickup"] ?? "" : booking["dropoff"] ?? "",
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ),
//                                     DataCell(Text(booking["pickup_date"] ?? "")),
//                                     DataCell(Text("£${booking["fares"] ?? 0}")),
//
//                                     // ✅ TOGGLE CHECKBOX
//                                     DataCell(
//                                       Obx(() => Checkbox(
//                                         value: selectedIndex.value == index,
//                                         onChanged: (value) {
//                                           if (selectedIndex.value == index) {
//                                             selectedIndex.value = -1; // unselect
//                                           } else {
//                                             selectedIndex.value = index; // select
//                                           }
//                                         },
//                                       )),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }),
//
//                 const SizedBox(height: 30),
//
//                 /// ================= DRIVER + VEHICLE =================
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Select driver"),
//                           Container(
//                             height: 35,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
//                             ),
//                             child: DropdownButtonFormField<DashboardDriverObject>(
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 isDense: true,
//                               ),
//                               value: homeController.selectDriverValue,
//                               items: homeController.dashboardAllData!.drivers!
//                                   .map((driver) => DropdownMenuItem<DashboardDriverObject>(
//                                 value: driver,
//                                 child: Text(
//                                   driver.name ?? "",
//                                   style: mozillaTextRegularText(
//                                     fontSize: 12,
//                                     color: DynamicColors.textClr,
//                                   ),
//                                 ),
//                               ))
//                                   .toList(),
//                               onChanged: (v) {
//                                 homeController.selectDriverValue = v;
//                                 homeController.update();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Select vehicle"),
//                           Container(
//                             // height: 35,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
//                             ),
//                             child: DropdownButtonFormField<DashboardVehicleTypeObject>(
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 isDense: true,
//                               ),
//                               value: homeController.selectVehicleValue,
//                               items: homeController.dashboardAllData!.vehicleTypes!
//                                   .map((vehicle) => DropdownMenuItem<DashboardVehicleTypeObject>(
//                                 value: vehicle,
//                                 child: Text(
//                                   vehicle.name ?? "",
//                                   style: mozillaTextRegularText(
//                                     fontSize: 12,
//                                     color: DynamicColors.textClr,
//                                   ),
//                                 ),
//                               ))
//                                   .toList(),
//                               onChanged: (v) async {
//                                 homeController.selectVehicleValue = v;
//                                 homeController.getFaresCalculation();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 /// ================= SUBMIT =================
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//
//                       },
//                       child: const Text("SUBMIT"),
//                     ),
//                     const SizedBox(width: 12),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (selectedIndex.value == -1) {
//                           Get.snackbar(
//                             "Error",
//                             "Please select a booking",
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//
//                         if (selectedDriver == null || selectedVehicle == null) {
//                           Get.snackbar(
//                             "Error",
//                             "Please select driver and vehicle",
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//
//                         print("Booking Index: ${selectedIndex.value}");
//                         print("Driver: $selectedDriver");
//                         print("Vehicle: $selectedVehicle");
//
//                         Get.snackbar(
//                           "Success",
//                           "Job Assigned Successfully",
//                           backgroundColor: Colors.green,
//                           colorText: Colors.white,
//                         );
//                       },
//                       child: const Text("New Booking"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     );
//   }
//
//
//   Widget rightClickTextCell({
//     required Widget child,
//     required VoidCallback onRightClick,
//     required dynamic item,
//   }) {
//     return Listener(
//       behavior: HitTestBehavior.opaque,
//       onPointerDown: (event) {
//         if (event.kind == PointerDeviceKind.mouse &&
//             event.buttons == kSecondaryMouseButton) {
//           final RenderBox overlay =
//           Overlay.of(context).context.findRenderObject() as RenderBox;
//
//           final RelativeRect position = RelativeRect.fromRect(
//             Rect.fromPoints(
//               event.position,
//               event.position,
//             ),
//             Offset.zero & overlay.size,
//           );
//           // onRightClick();
//           showRowContextMenu(
//             context: context,
//             position: position,
//             item: item,
//           );
//         }
//       },
//       child: child,
//     );
//   }
//
//   void showRowContextMenu({
//     required BuildContext context,
//     required RelativeRect position,
//     required dynamic item,
//   }) {
//     showMenu(
//       context: context,
//       position: position
//       /*RelativeRect.fromLTRB(
//         position.dx,
//         position.dy,
//         0,
//         0,
//       )*/,
//       items: const [
//         PopupMenuItem(value: 'accept', child: Text('DROP OFF')),
//         PopupMenuItem(value: 'decline', child: Text('PICKUP')),
//       ],
//
//     ).then((value) {
//       if (value == null) return;
//
//       switch (value) {
//         case 'accept':
//           print("ACCEPT ${item.referenceNumber}");
//           break;
//         case 'decline':
//           print("DECLINE ${item.referenceNumber}");
//           break;
//       }
//     });
//   }
//
// }

/// --------- CENTER AREA ----------
// class _CenterArea extends StatefulWidget {
//   @override
//   State<_CenterArea> createState() => _CenterAreaState();
// }
//
// class _CenterAreaState extends State<_CenterArea> {
//   final CliController controller = Get.find<CliController>();
//   DashboardController dashboard = Get.find();
//
//   final RxInt selectedIndex = (-1).obs;
//
//   /// ✅ Selected booking
//   Map<String, dynamic>? selectedBooking;
//
//   /// ✅ Selected IDs
//   int? selectedDriverId;
//   int? selectedVehicleId;
//
//   bool isSwapped = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (dashboard.dashboardAllData == null) {
//       dashboard.dashboardData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<DashboardController>(
//       builder: (homeController) {
//         return Padding(
//           padding: const EdgeInsets.all(24),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//
//                 /// HEADER
//                 Obx(() => Text(controller.customerName.value)),
//                 Obx(() => Text(controller.customerMobile.value)),
//
//                 const SizedBox(height: 20),
//
//                 /// BOOKINGS TABLE
//                 Obx(() {
//                   if (controller.isLoading.value) {
//                     return const CircularProgressIndicator();
//                   }
//
//                   if (controller.bookings.isEmpty) {
//                     return const Text("No Bookings");
//                   }
//
//                   return Column(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => setState(() => isSwapped = !isSwapped),
//                         child: const Text("Swap Pickup/Drop"),
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DatatableWidget(
//                           columns: [
//                             buildHeaderWithSearch(title: "Pick-up", removeSearching: true),
//                             buildHeaderWithSearch(title: "Drop off", removeSearching: true),
//                             buildHeaderWithSearch(title: "Date", removeSearching: true),
//                             buildHeaderWithSearch(title: "Fare", removeSearching: true),
//                             buildHeaderWithSearch(title: "Action", removeSearching: true),
//                           ],
//                           totalRow: controller.bookings.length,
//                           rows: List.generate(controller.bookings.length, (index) {
//                             var booking = controller.bookings[index];
//
//                             return DataRow(
//                               cells: [
//                                 DataCell(Text(isSwapped
//                                     ? booking["dropoff"] ?? ""
//                                     : booking["pickup"] ?? "")),
//
//                                 DataCell(Text(isSwapped
//                                     ? booking["pickup"] ?? ""
//                                     : booking["dropoff"] ?? "")),
//
//                                 DataCell(Text(booking["pickup_date"] ?? "")),
//                                 DataCell(Text("£${booking["fares"] ?? 0}")),
//
//                                 /// ACTION
//                                 DataCell(
//                                   Obx(() => Checkbox(
//                                     value: selectedIndex.value == index,
//                                     onChanged: (value) {
//                                       if (selectedIndex.value == index) {
//                                         selectedIndex.value = -1;
//                                         selectedBooking = null;
//                                       } else {
//                                         selectedIndex.value = index;
//                                         selectedBooking = booking;
//
//                                         print("Selected booking: $selectedBooking");
//                                       }
//                                     },
//                                   )),
//                                 ),
//                               ],
//                             );
//                           }),
//                         ),
//                       ),
//                     ],
//                   );
//                 }),
//
//                 const SizedBox(height: 30),
//
//                 /// DRIVER + VEHICLE
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButtonFormField<DashboardDriverObject>(
//                         decoration: const InputDecoration(
//                           labelText: "Select Driver",
//                           border: OutlineInputBorder(),
//                         ),
//                         value: homeController.selectDriverValue,
//                         items: homeController.dashboardAllData!.drivers!
//                             .map((d) => DropdownMenuItem(
//                           value: d,
//                           child: Text(d.name ?? ""),
//                         ))
//                             .toList(),
//                         onChanged: (v) {
//                           homeController.selectDriverValue = v;
//                           selectedDriverId = v?.id; // ✅ SAVE ID
//                           homeController.update();
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: DropdownButtonFormField<DashboardVehicleTypeObject>(
//                         decoration: const InputDecoration(
//                           labelText: "Select Vehicle",
//                           border: OutlineInputBorder(),
//                         ),
//                         value: homeController.selectVehicleValue,
//                         items: homeController.dashboardAllData!.vehicleTypes!
//                             .map((v) => DropdownMenuItem(
//                           value: v,
//                           child: Text(v.name ?? ""),
//                         ))
//                             .toList(),
//                         onChanged: (v) {
//                           homeController.selectVehicleValue = v;
//                           selectedVehicleId = v?.id; // ✅ SAVE ID
//                           homeController.update();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 /// SUBMIT
//                 ElevatedButton(
//                   onPressed: () {
//                     if (selectedBooking == null) {
//                       Get.snackbar("Error", "Select booking first");
//                       return;
//                     }
//
//                     if (selectedDriverId == null || selectedVehicleId == null) {
//                       Get.snackbar("Error", "Select driver & vehicle");
//                       return;
//                     }
//
//                     final bookingId = selectedBooking!["id"];
//                     final bookingDate = selectedBooking!["pickup_date"];
//                     final bookingTime = selectedBooking!["pickup_time"];
//
//                     print("========== SUBMIT ==========");
//                     print("Booking ID: $bookingId");
//                     print("Date: $bookingDate");
//                     print("Time: $bookingTime");
//                     print("Driver ID: $selectedDriverId");
//                     print("Vehicle ID: $selectedVehicleId");
//                     print("============================");
//
//
//                     controller.postCLIJob(bookingId,bookingDate,bookingTime,selectedDriverId,selectedVehicleId);
//                   },
//                   child: const Text("SUBMIT"),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class _CenterArea extends StatefulWidget {
  @override
  State<_CenterArea> createState() => _CenterAreaState();
}

class _CenterAreaState extends State<_CenterArea> {
  final CliController controller = Get.find<CliController>();
  DashboardController dashboard = Get.find();

  final RxInt selectedIndex = (-1).obs;

  /// ✅ Selected booking
  BookingObjectData? selectedBooking;

  /// ✅ Selected IDs
  int? selectedDriverId;
  int? selectedVehicleId;

  bool isSwapped = false;

  /// ✅ NEW TextEditingControllers
  final TextEditingController pickupController = TextEditingController();
  LatLng? pickupPoints;
  String? name;
  String? email;
  String? mobileNumber;
  String? telNumber;
  final TextEditingController dropoffController = TextEditingController();
  LatLng? dropoffPoints;

  bool actionValue = false;
  bool submitBtnValue = false;

  DashboardController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    if (dashboard.dashboardAllData == null) {
      dashboard.dashboardData();
    }
  }

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (homeController) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [

                /// HEADER

                const SizedBox(height: 20),

                /// BOOKINGS TABLE
                Obx(() {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator();
                  }

                  if (controller.bookings.isEmpty) {
                    return Column(
                      children: [
                        Text("Unknown"),
                         Text(controller.customerMobile.value),
                      ],
                    );
                  }else{

                    Obx(() => Text(controller.customerName.value));
                    Obx(() => Text(controller.customerMobile.value));
                  }

                  return Column(
                    children: [

                      /// ✅ PICKUP & DROPOFF TEXTFIELDS
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: pickupController,
                              decoration: InputDecoration(
                                labelText: "Pick Up",
                                border: OutlineInputBorder(),
                              suffixIcon: pickupController.text.isEmpty && dropoffController.text.isEmpty ?SizedBox.shrink() : GestureDetector(
                                onTap: (){
                                  pickupController.clear();
                                  dropoffController.clear();
                                  pickupPoints = null;
                                  dropoffPoints = null;
                                 setState(() {

                                 });
                                },
                                child: Icon(Icons.close,
                                color: Colors.red,
                                ),
                              )
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: dropoffController,
                              decoration: InputDecoration(
                                labelText: "Drop Off",
                                border: OutlineInputBorder(),
                                  suffixIcon: pickupController.text.isEmpty && dropoffController.text.isEmpty ?SizedBox.shrink() : GestureDetector(
                                    onTap: (){
                                      pickupController.clear();
                                      dropoffController.clear();
                                      pickupPoints = null;
                                      dropoffPoints = null;
                                      setState(() {
                                      });
                                    },
                                    child: Icon(Icons.close,
                                      color: Colors.red,
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// SWAP BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isSwapped = !isSwapped;

                                /// swap textfields data also
                                final temp = pickupController.text;
                                pickupController.text = dropoffController.text;
                                dropoffController.text = temp;
                                submitBtnValue = true;
                              });
                            },
                            child: const Text("Swap Pickup/Drop"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Visibility(
                             visible: selectedBooking != null && selectedBooking!.viapoints!.isNotEmpty && actionValue == true && isSwapped == false?true:false,
                             child: ElevatedButton(
                               onPressed: () {
                                 // Use a slight delay to ensure the click event is fully processed
                                 // before the Dialog changes the UI tree.
                                 Future.delayed(const Duration(milliseconds: 50), () {
                                   if (!context.mounted) return; // Safety check

                                   showDialog(
                                     context: context,
                                     builder: (context) {
                                       return AlertDialog(
                                         title: const Text("VIA List"),
                                         content: SizedBox(
                                           width: MediaQuery.of(context).size.width/2.5,
                                           // width: double.maxFinite, // Helps with sizing
                                           child: ListView.builder(
                                             itemCount: selectedBooking!.viapoints!.length,
                                             shrinkWrap: true, // Necessary for ListView inside Alert
                                             physics: const AlwaysScrollableScrollPhysics(), // Scrollable if list is long
                                             itemBuilder: (BuildContext context, index) {
                                               return Column(
                                                 mainAxisSize: MainAxisSize.min,
                                                 children: [
                                                   Row(
                                                     children: [
                                                       Expanded(
                                                           child: Container(
                                                             margin: EdgeInsets.symmetric(horizontal: 6),
                                                             padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                                                             decoration: BoxDecoration(
                                                               border: Border(
                                                                 bottom: BorderSide(
                                                                   color: DynamicColors.black,
                                                                   width: 1.0, // You can adjust the thickness here
                                                                 ),
                                                               ),
                                                             ),
                                                             child: Text(selectedBooking!.viapoints![index].name ?? ""),
                                                           )
                                                       ),
                                                       Expanded(
                                                           child: Container(
                                                             margin: EdgeInsets.symmetric(horizontal: 6),
                                                             padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                                                             decoration: BoxDecoration(
                                                               border: Border(
                                                                 bottom: BorderSide(
                                                                   color: DynamicColors.black,
                                                                   width: 1.0, // You can adjust the thickness here
                                                                 ),
                                                               ),
                                                             ),
                                                             child: Text(selectedBooking!.viapoints![index].mobile??""),
                                                           )
                                                       ),
                                                     ],
                                                   ),
                                                   Container(
                                                     width: MediaQuery.of(context).size.width/2.5,
                                                     padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
                                                     decoration: BoxDecoration(
                                                       border: Border(
                                                         bottom: BorderSide(
                                                           color: DynamicColors.black,
                                                           width: 1.0, // You can adjust the thickness here
                                                         ),
                                                       ),
                                                     ),
                                                     child: Text(selectedBooking!.viapoints![index].viapoint??""),
                                                   )
                                                 ],
                                               );
                                             },
                                           ),
                                         ),
                                         actions: [
                                           TextButton(
                                             onPressed: () => Navigator.pop(context),
                                             child: const Text("Cancel"),
                                           ),
                                           ElevatedButton(
                                             onPressed: () async {
                                               await _controller.dashBoardDataBinding(id: selectedBooking!.id,jobData: selectedBooking);
                                               Get.back();
                                               Get.back();
                                             },
                                             child: const Text("Edit Via"),
                                           ),
                                         ],
                                       );
                                     },
                                   );
                                 });
                               },
                              child: const Text("Show Via"),
                             ),
                           ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: "Pick-up", removeSearching: true),
                            buildHeaderWithSearch(title: "Drop off", removeSearching: true),
                            buildHeaderWithSearch(title: "Date", removeSearching: true),
                            buildHeaderWithSearch(title: "Fare", removeSearching: true),
                            buildHeaderWithSearch(title: "Action", removeSearching: true),
                          ],
                          totalRow: controller.bookings.length,
                          rows: List.generate(controller.bookings.length, (index) {
                            // var booking = controller.bookings[index];
                            BookingObjectData cliBookingData = BookingObjectData.fromJson(controller.bookings[index]);

                            return DataRow(
                              cells: [
                                DataCell(SizedBox(
                                  width: Get.width/6,
                                  child:
                                  rightClickTextCell(
                                    item: cliBookingData,
                                    clickValue: 'pickUpClick',
                                    onRightClick: () {
                                      print("RIGHT CLICK JOURNEY TYPE");
                                    },
                                    child: Text(cliBookingData.pickup!),
                                  ),
                                )),

                                DataCell(SizedBox(
                                  width: Get.width/6,
                                  child: rightClickTextCell(
                                    item: cliBookingData,
                                    clickValue: 'dropoffClick',
                                    onRightClick: () {
                                      print("RIGHT CLICK JOURNEY TYPE");
                                    },
                                    child: Text(cliBookingData.dropoff ?? ""),
                                  ),
                                )),

                                DataCell(Text("${cliBookingData.pickupDate!.year}-${cliBookingData.pickupDate!.month}-${cliBookingData.pickupDate!.day}")),
                                DataCell(Text("£${cliBookingData.fares ?? 0}")),

                                /// ACTION
                                DataCell(
                                  Obx(() => Checkbox(
                                    value: selectedIndex.value == index,
                                    onChanged: (value) {
                                      if (selectedIndex.value == index) {
                                        selectedIndex.value = -1;
                                        selectedBooking = null;
                                        submitBtnValue = false;
                                        pickupController.clear();
                                        dropoffController.clear();
                                        actionValue = false;
                                      } else {
                                        submitBtnValue = true;
                                        selectedIndex.value = index;
                                        selectedBooking = cliBookingData;
                                        actionValue = true;
                                        pickupController.text =
                                            cliBookingData.pickup ?? "";
                                        dropoffController.text =
                                            cliBookingData.dropoff ?? "";
                                        print("Selected booking: $selectedBooking");
                                      }
                                      setState(() {
                                      });
                                    },
                                  )),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 30),

                /// DRIVER + VEHICLE
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<DashboardDriverObject>(
                        decoration: const InputDecoration(
                          labelText: "Select Driver",
                          border: OutlineInputBorder(),
                        ),
                        value: homeController.selectDriverValue,
                        items: homeController.dashboardAllData!.drivers!
                            .map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(d.name ?? ""),
                        ))
                            .toList(),
                        onChanged: (v) {
                          homeController.selectDriverValue = v;
                          selectedDriverId = v?.id;
                          homeController.update();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<DashboardVehicleTypeObject>(
                        decoration: const InputDecoration(
                          labelText: "Select Vehicle",
                          border: OutlineInputBorder(),
                        ),
                        value: homeController.selectVehicleValue,
                        items: homeController.dashboardAllData!.vehicleTypes!
                            .map((v) => DropdownMenuItem(
                          value: v,
                          child: Text(v.name ?? ""),
                        ))
                            .toList(),
                        onChanged: (v) {
                          homeController.selectVehicleValue = v;
                          selectedVehicleId = v?.id;
                          homeController.update();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// SUBMIT
               if(actionValue == true && isSwapped == false) ElevatedButton(
                  onPressed: () {
                    // DashboardController _controller = Get.find();
                    // _controller.dashBoardDataBinding(id: selectedBooking!.id,jobData: selectedBooking);

                    if (selectedBooking == null) {
                      Get.snackbar("Error", "Select booking first");
                      return;
                    }

                    if (selectedDriverId == null || selectedVehicleId == null) {
                      Get.snackbar("Error", "Select driver & vehicle");
                      return;
                    }

                    final bookingId = selectedBooking!.id;
                    final bookingDate = selectedBooking!.pickupDate;
                    final bookingTime = selectedBooking!.pickupTime;

                    print("========== SUBMIT ==========");
                    print("Booking ID: $bookingId");
                    print("Date: $bookingDate");
                    print("Time: $bookingTime");
                    print("Driver ID: $selectedDriverId");
                    print("Vehicle ID: $selectedVehicleId");
                    print("============================");

                    controller.postCLIJob(
                      selectedBooking!.id,
                      selectedBooking!.pickupDate,
                      selectedBooking!.pickupTime,
                      selectedDriverId,
                      selectedVehicleId,
                    );
                  },
                  child: const Text("SUBMIT"),
                ),

                const SizedBox(height: 15),

                /// ✅ EXTRA BUTTON AFTER SUBMIT
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () async {
                    // Scenario 1: Agar TextFields mein data hai aur koi row select nahi ki (Fresh Manual Booking)
                    if (pickupController.text.isNotEmpty && dropoffController.text.isNotEmpty && actionValue == false) {

                      if (pickupController.text == dropoffController.text) {
                        BotToast.showText(text: "Please write different address");
                        return;
                      }

                      await _controller.cliDataBinding(
                        pickup: pickupController.text,
                        dropoff: dropoffController.text,
                        pickupLatitude: pickupPoints?.latitude.toString() ?? "0.0",
                        pickupLongitude: pickupPoints?.longitude.toString() ?? "0.0",
                        dropoffLatitude: dropoffPoints?.latitude.toString() ?? "0.0",
                        dropoffLongitude: dropoffPoints?.longitude.toString() ?? "0.0",
                        name: controller.customerName.value,
                        mobile: controller.customerMobile.value,
                        email: email,
                        phoneNumber: telNumber,
                      );

                      Get.offAllNamed(Routes.myHomePage); // Apne route ka naam yahan likhein

                    }
                    else if (selectedBooking != null) {
                      await _controller.dashBoardDataBinding(id: selectedBooking!.id, jobData: selectedBooking);
                      Get.back();
                    }
                    // Scenario 3: Kuch bhi nahi hai, tab bhi khali dashboard par le jao
                    else {
                      Get.offAllNamed(Routes.myHomePage);
                    }
                  },
                  child: const Text("New Booking"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget rightClickTextCell({
    required Widget child,
    required VoidCallback onRightClick,
    required dynamic item,
    clickValue
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
            clickValue: clickValue
          );
        }
      },
      child: child,
    );
  }

  void showRowContextMenu({
    required BuildContext context,
    required RelativeRect position,
    required dynamic item,
    clickValue
  }) {
    showMenu(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(value: 'pickup', child: Text('pickup')),
        PopupMenuItem(value: 'dropoff', child: Text('dropoff')),
      ],

    ).then((value) {
      if (value == null) return;
      switch (value) {
        case 'pickup':
          if(clickValue == "dropoffClick"){
            pickupController.text = item.dropoff;
            pickupPoints = LatLng(double.parse(item.dropoffLatitude), double.parse(item.dropoffLongitude));
          }else{
            pickupController.text = item.pickup;
            pickupPoints = LatLng(double.parse(item.pickupLatitude), double.parse(item.pickupLongitude));
          }
          name = item.name;
          email = item.email;
          mobileNumber = item.mobile;
          telNumber = item.telephone;
          break;
        case 'dropoff':
          if(clickValue == "dropoffClick"){
            dropoffController.text = item.dropoff;
            dropoffPoints = LatLng(double.parse(item.dropoffLatitude), double.parse(item.dropoffLongitude));
          }else{
            dropoffController.text = item.pickup;
            dropoffPoints = LatLng(double.parse(item.pickupLatitude), double.parse(item.pickupLongitude));
          }
          name = item.name;
          email = item.email;
          mobileNumber = item.mobile;
          telNumber = item.telephone;
          break;
      }
    });
  }

}
/// --------- RIGHT SIDEBAR ----------
class _RightSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final subtle = const Color(0xFF6B7C8F);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Favorite Rides header
          // Row(
          //   children: [
          //     const CircleAvatar(
          //       radius: 20,
          //       backgroundColor: Color(0xFFF4F6FA),
          //       child: Icon(Icons.person, color: Color(0xFF6B7C8F)),
          //     ),
          //     const SizedBox(width: 12),
          //     Text(
          //       "Favorite Rides",
          //       style: Theme.of(context)
          //           .textTheme
          //           .titleMedium
          //           ?.copyWith(color: subtle, fontWeight: FontWeight.w700),
          //     ),
          //     const Spacer(),
          //   ],
          // ),
          const SizedBox(height: 24),

          // Ride History section
          Text(
            "Ride History",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: subtle, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _kv("Used", "0", valueColor: Colors.green.shade600),
          const SizedBox(height: 8),
          _kv("Cancelled", "0", valueColor: Colors.red.shade600),
          const SizedBox(height: 8),
          _kv("Balance Amount", "0"),
          const Spacer(),

          // Bottom border accent (to mirror screenshot spacing)
          Container(
            height: 2,
            margin: const EdgeInsets.only(bottom: 0),
            decoration: BoxDecoration(
              color: const Color(0xFFE1E7F0),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            k,
            style: const TextStyle(
                color: Color(0xFF6B7C8F), fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          v,
          style: TextStyle(
            color: valueColor ?? Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}