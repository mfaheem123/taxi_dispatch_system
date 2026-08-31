import 'dart:async';
import 'dart:ui';
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/view/controller/cli_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import 'dashboard_view/Controller/dashboard_controller.dart';
import 'dashboard_view/booking_table.dart';
import 'dashboard_view/models/dashboard_model.dart';
import 'dashboard_view/models/dashboard_table_model.dart';

String temMobileNumber="";


class NewResponsivePassengerScreen extends StatefulWidget {
  final String extensionNumber;

  const NewResponsivePassengerScreen({super.key, required this.extensionNumber});

  @override
  State<NewResponsivePassengerScreen> createState() =>
      _NewResponsivePassengerScreenState();
}

class _NewResponsivePassengerScreenState extends State<NewResponsivePassengerScreen> {
  /// ✅ Socket Controller
  final CliController socketController =
  Get.put(CliController(), permanent: true);

  @override
  void initState() {
    super.initState();
    print("PHONEEEEEEEEEEEEEEEEE${widget.extensionNumber}");
    temMobileNumber = widget.extensionNumber;

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
        constraints: const BoxConstraints(maxWidth: 1600),
        // increased max width
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
      {required this.leftWidth,
        required this.rightWidth,
        required this.maxWidth});

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
        SizedBox(
            width: centerWidth > 400 ? centerWidth : 400, child: _CenterArea()),

        // VERTICAL DIVIDER
        // Container(width: 1.5, color: Color(0xFFE1E7F0)),

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
// class _LeftSidebar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

class _LeftSidebar extends StatefulWidget {
  const _LeftSidebar({Key? key}) : super(key: key);

  @override
  State<_LeftSidebar> createState() => _LeftSidebarState();
}

class _LeftSidebarState extends State<_LeftSidebar> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Formatting Date & Time
    final String dateStr =
        "${_currentTime.year}-${_currentTime.month.toString().padLeft(2, '0')}-${_currentTime.day.toString().padLeft(2, '0')}";
    final String timeStr =
        "${(_currentTime.hour % 12 == 0 ? 12 : _currentTime.hour % 12).toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')} ${_currentTime.hour >= 12 ? 'PM' : 'AM'}";
    return Container(
      // color: Color(0xFF5C7EA6),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF254dbe),
            Color(0xFF345ecc),
            Color(0xFF406ad8),
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 28),

          // Profile Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                image: AssetImage('assets/cabflow_logo.png'),
                width: 300,
                height: 60,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 24),
          Center(
            child: Text(
              "CURRENT DATE & TIME",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 6),

          // Date aur Live Time
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time_filled,
                size: 16,
                color: Colors.white70,
              ),
              const SizedBox(width: 8),
              Text(
                "$dateStr  |  $timeStr",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Headset
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.headset_mic_outlined,
                    color: Color(0xFF254dbe),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Need Help?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "+44 20 3603 0511",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF254dbe),
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        "support@cabflow.co.uk",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF254dbe),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
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

  /// ✅ TextControllers & State Variables
  final TextEditingController pickupController = TextEditingController();
  LatLng? pickupPoints;
  String? name;
  String? email;
  String? mobileNumber;
  String? telNumber;
  final TextEditingController dropoffController = TextEditingController();
  LatLng? dropoffPoints;
  bool _isLoading = false;
  bool actionValue = false;
  bool submitBtnValue = false;

  DashboardController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.cliJobHit = false;

    // Helper function to set default vehicle
    void setDefaultVehicle() {
      if (dashboard.dashboardAllData?.vehicleTypes != null &&
          dashboard.dashboardAllData!.vehicleTypes!.isNotEmpty) {
        // Automatically select the first vehicle type by default
        dashboard.selectVehicleValue =
            dashboard.dashboardAllData!.vehicleTypes!.first;
        selectedVehicleId = dashboard.selectVehicleValue?.id;
      }
    }

    if (dashboard.dashboardAllData == null) {
      dashboard.dashboardData().then((_) {
        setDefaultVehicle();
        setState(() {});
      });
    } else {
      setDefaultVehicle();
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
        // Fallback safety for default vehicle selection if not set yet
        if (selectedVehicleId == null &&
            homeController.dashboardAllData?.vehicleTypes != null &&
            homeController.dashboardAllData!.vehicleTypes!.isNotEmpty) {
          homeController.selectVehicleValue ??=
              homeController.dashboardAllData!.vehicleTypes!.first;
          selectedVehicleId = homeController.selectVehicleValue?.id;
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFF1F5F9),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // color: const Color(0xFFF8FAFC),
                // padding: const EdgeInsets.all(16),
                // child: SingleChildScrollView(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                /// HEADER
                // const SizedBox(height: 20),

                /// BOOKINGS TABLE
                Obx(() {
                  if (controller.isLoading.value) {
                    // return const CircularProgressIndicator();
                    return const SizedBox(
                      height: 180,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  /// ✅ WHEN NO BOOKINGS
                  // if (controller.bookings.isEmpty) {
                  //   return Column(
                  //     children: [
                  //       const Text("Unknown"),
                  //       Text(controller.customerMobile.value ?? ""),
                  //     ],
                  //   );
                  // }
                  if (controller.bookings.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 38, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 8),
                          Text(
                            controller.customerName.value.isEmpty
                                ? "UNKNOWN CUSTOMER"
                                : controller.customerName.value,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            controller.customerMobile.value ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  /// ✅ WHEN BOOKINGS AVAILABLE
                  // return Column(
                  //   children: [
                  //     Text(
                  //       controller.customerName.value.isEmpty
                  //           ? "Unknown"
                  //           : controller.customerName.value,
                  //       style: const TextStyle(color: Colors.black),
                  //     ),
                  //     Text(
                  //       controller.customerMobile.value.isEmpty
                  //           ? ""
                  //           : controller.customerMobile.value,
                  //       style: const TextStyle(color: Colors.black),
                  //     ),
                  //     const SizedBox(height: 10),
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child:
                        // Customer info header
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(0xFFEFF6FF),
                              child: Icon(Icons.person,
                                  size: 20, color: Color(0xFF2563EB)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.customerName.value.isEmpty
                                      ? "UNKNOWN"
                                      : controller.customerName.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                if (controller.customerMobile.value.isNotEmpty)
                                  Text(
                                    controller.customerMobile.value,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Column(
                      //   children: [
                      /// PICKUP & DROPOFF TEXTFIELDS
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: pickupController,
                                    decoration: InputDecoration(
                                      labelText: "PICK UP",
                                      prefixIcon: const Icon(
                                          Icons.location_on_outlined,
                                          color: Color(0xFF2563EB)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFCBD5E1)),
                                      ),
                                      suffixIcon:
                                      pickupController.text.isEmpty &&
                                          dropoffController.text.isEmpty
                                          ? const SizedBox.shrink()
                                          : IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red,
                                            size: 20),
                                        onPressed: () {
                                          pickupController.clear();
                                          dropoffController.clear();
                                          pickupPoints = null;
                                          dropoffPoints = null;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // InkWell(
                                //   onTap: () {
                                //     setState(() {
                                //       isSwapped = !isSwapped;
                                //       final temp = pickupController.text;
                                //       pickupController.text =
                                //           dropoffController.text;
                                //       dropoffController.text = temp;
                                //       submitBtnValue = true;
                                //     });
                                //   },
                                //   child: Container(
                                //     padding: const EdgeInsets.all(12),
                                //     decoration: BoxDecoration(
                                //       color: const Color(0xFFF1F5F9),
                                //       borderRadius: BorderRadius.circular(8),
                                //       border: Border.all(
                                //           color: const Color(0xFFCBD5E1)),
                                //     ),
                                //     child: const Icon(Icons.swap_horiz,
                                //         color: Color(0xFF334155)),
                                //   ),
                                // ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: dropoffController,
                                    decoration: InputDecoration(
                                      labelText: "DROPOFF",
                                      prefixIcon: const Icon(
                                          Icons.navigation_outlined,
                                          color: Color(0xFFE11D48)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFCBD5E1)),
                                      ),
                                      suffixIcon:
                                      pickupController.text.isEmpty &&
                                          dropoffController.text.isEmpty
                                          ? const SizedBox.shrink()
                                          : IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red,
                                            size: 20),
                                        onPressed: () {
                                          pickupController.clear();
                                          dropoffController.clear();
                                          pickupPoints = null;
                                          dropoffPoints = null;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            /// SWAP BUTTON
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isSwapped = !isSwapped;
                                      final temp = pickupController.text;
                                      pickupController.text =
                                          dropoffController.text;
                                      dropoffController.text = temp;
                                      submitBtnValue = true;
                                    });
                                  },
                                  child: const Text("SWAP PICKUP/DROP"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// TABLE
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SingleChildScrollView(
                            // scrollDirection: Axis.horizontal,
                            child: DatatableWidget(
                              columns: [
                                buildHeaderWithSearch(
                                    title: "PICKUP", removeSearching: true),
                                buildHeaderWithSearch(
                                    title: "DROPOFF", removeSearching: true),
                                buildHeaderWithSearch(
                                    title: "DATETIME", removeSearching: true),
                                buildHeaderWithSearch(
                                    title: "FARE", removeSearching: true),
                                buildHeaderWithSearch(
                                    title: "ACTION", removeSearching: true),
                              ],
                              totalRow: controller.bookings.length,
                              rows: List.generate(controller.bookings.length,
                                      (index) {
                                    BookingObjectData cliBookingData =
                                    BookingObjectData.fromJson(
                                        controller.bookings[index]);

                                    return DataRow(
                                      cells: [
                                        DataCell(SizedBox(
                                          width: Get.width / 6,
                                          child: rightClickTextCell(
                                            item: cliBookingData,
                                            clickValue: 'pickUpClick',
                                            onRightClick: () {},
                                            child: Text(cliBookingData.pickup ?? "",
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        )),
                                        DataCell(SizedBox(
                                          width: Get.width / 6,
                                          child: rightClickTextCell(
                                            item: cliBookingData,
                                            clickValue: 'dropoffClick',
                                            onRightClick: () {},
                                            child: Text(
                                                cliBookingData.dropoff ?? "",
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        )),
                                        DataCell(Center(child:Text(cliBookingData.pickupDate !=
                                            null
                                            ? "${cliBookingData.pickupDate!.year}-${cliBookingData.pickupDate!.month}-${cliBookingData.pickupDate!.day}"
                                            : ""))),
                                        DataCell(
                                            Text("£${cliBookingData.fares ?? 0}")),
                                        DataCell(Center(child:
                                        Obx(() => Checkbox(
                                          value: selectedIndex.value == index,
                                          onChanged: (value) {
                                            if (selectedIndex.value ==
                                                index) {
                                              selectedIndex.value = -1;
                                              selectedBooking = null;
                                              pickupController.clear();
                                              dropoffController.clear();
                                              actionValue = false;
                                              // cliBookingData.pickupTime=null;
                                              // cliBookingData.pickupDate=null;
                                            } else {
                                              selectedIndex.value = index;
                                              selectedBooking =
                                                  cliBookingData;
                                              actionValue = true;
                                              pickupController.text =
                                                  cliBookingData.pickup ?? "";
                                              dropoffController.text =
                                                  cliBookingData.dropoff ??
                                                      "";
                                            }
                                            setState(() {});
                                          },
                                        )),
                                        )),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ],
                    //   ),
                    // ],
                  );
                }),
                const SizedBox(height: 24),

                /// DRIVER + VEHICLE
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<DashboardDriverObject>(
                          decoration: const InputDecoration(
                            labelText: "SELECT DRIVER",
                            border: OutlineInputBorder(),
                          ),
                          value: homeController.selectDriverValue,
                          items: homeController.dashboardAllData?.drivers
                              ?.map((d) => DropdownMenuItem(
                            value: d,
                            child: Text(
                                "${d.username ?? ""} ${d.name ?? ""}"
                                    .toUpperCase()),
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
                        child:
                        DropdownButtonFormField<DashboardVehicleTypeObject>(
                          decoration: const InputDecoration(
                            labelText: "SELECT VEHICLE",
                            border: OutlineInputBorder(),
                          ),
                          value: homeController.selectVehicleValue,
                          items: homeController.dashboardAllData?.vehicleTypes
                              ?.map((v) => DropdownMenuItem(
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
                ),
                const SizedBox(height: 24),

                /// EXTRA BUTTON ("New Booking")
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: const Color(0xFF64748B),
                        backgroundColor: const Color(0xFF406ad8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        if (_isLoading) return;
                        try {
                          _isLoading = true;
                          if (pickupController.text.isNotEmpty &&
                              dropoffController.text.isNotEmpty &&
                              actionValue == false) {
                            if (pickupController.text ==
                                dropoffController.text) {
                              BotToast.showText(
                                  text: "PLEASE WRITE DIFFERENT ADDRESS");
                              return;
                            }
                            if (pickupPoints == null || dropoffPoints == null) {
                              BotToast.showText(text: "LOCATION DATA MISSING");
                              return;
                            }

                            await _controller.cliDataBinding(
                              pickup: pickupController.text,
                              dropoff: dropoffController.text,
                              pickupLatitude: pickupPoints!.latitude.toString(),
                              pickupLongitude:
                              pickupPoints!.longitude.toString(),
                              dropoffLatitude:
                              dropoffPoints!.latitude.toString(),
                              dropoffLongitude:
                              dropoffPoints!.longitude.toString(),
                              name: name,
                              mobile: mobileNumber,
                              email: email,
                              phoneNumber: telNumber,
                            );
                            if (!mounted) return;
                          } else {
                            if (selectedBooking == null) {
                              _controller.mobileController.text =
                                  temMobileNumber;
                              Get.back();
                              return;
                            }
                            _controller.cliJobHit = true;
                            await _controller.dashBoardDataBinding(
                                id: selectedBooking!.id,
                                jobData: selectedBooking,
                                cliHit: true);
                            if (!mounted) return;
                            Get.back();
                          }
                        } catch (e) {
                          BotToast.showText(text: "SOMETHING WENT WRONG");
                          print(e);
                        } finally {
                          _isLoading = false;
                        }
                      },
                      child: const Text("NEW BOOKING"),
                    ),
                    const SizedBox(width: 12),

                    /// SUBMIT BUTTON
                    if (actionValue == true && isSwapped == false)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (selectedBooking == null) {
                            Get.snackbar("ERROR", "SELECT BOOKING FIRST");
                            return;
                          }

                          // Dynamic vehicle fallback check
                          if (selectedVehicleId == null &&
                              homeController.dashboardAllData?.vehicleTypes !=
                                  null &&
                              homeController
                                  .dashboardAllData!.vehicleTypes!.isNotEmpty) {
                            selectedVehicleId = homeController
                                .dashboardAllData!.vehicleTypes!.first.id;
                          }

                          if (selectedDriverId == null ||
                              selectedVehicleId == null) {
                            Get.snackbar("ERROR", "SELECT DRIVER & VEHICLE");
                            return;
                          }

                          // Get Current Date and Time
                          DateTime now = DateTime.now();
                          String currentDate =
                          DateFormat('yyyy-MM-dd').format(now);
                          String currentTime = DateFormat('HH:mm').format(now);

                          print("========== SUBMIT ==========");
                          print("Booking ID: ${selectedBooking!.id}");
                          print("Current Date Sent: $currentDate");
                          print("Current Time Sent: $currentTime");
                          print("Driver ID: $selectedDriverId");
                          print("Vehicle ID: $selectedVehicleId");
                          print("============================");

                          /// Pass current date and time strictly to postCLIJob
                          controller.postCLIJob(
                            selectedBooking!.id,
                            currentDate,
                            currentTime,
                            selectedDriverId,
                            selectedVehicleId,
                          );
                        },
                        child: const Text("SUBMIT"),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget rightClickTextCell(
      {required Widget child,
        required VoidCallback onRightClick,
        required dynamic item,
        clickValue}) {
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
          showRowContextMenu(
              context: context,
              position: position,
              item: item,
              clickValue: clickValue);
        }
      },
      child: child,
    );
  }

  void showRowContextMenu(
      {required BuildContext context,
        required RelativeRect position,
        required dynamic item,
        clickValue}) {
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
          if (clickValue == "dropoffClick") {
            pickupController.text = item.dropoff.toUpperCase();
            pickupPoints = LatLng(double.parse(item.dropoffLatitude),
                double.parse(item.dropoffLongitude));
          } else {
            pickupController.text = item.pickup.toUpperCase();
            pickupPoints = LatLng(double.parse(item.pickupLatitude),
                double.parse(item.pickupLongitude));
          }
          name = item.name;
          email = item.email;
          mobileNumber = item.mobile.toString();
          telNumber = item.telephone;
          break;
        case 'dropoff':
          if (clickValue == "dropoffClick") {
            dropoffController.text = item.dropoff.toUpperCase();
            dropoffPoints = LatLng(double.parse(item.dropoffLatitude),
                double.parse(item.dropoffLongitude));
          } else {
            dropoffController.text = item.pickup;
            dropoffPoints = LatLng(double.parse(item.pickupLatitude),
                double.parse(item.pickupLongitude));
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 18,
                // backgroundColor: const Color(0xFFF4F6FA),
                backgroundColor: const Color(0xFFF1F5F9),
                //       child: IconButton(
                //         color: const Color(0xFF6B7C8F),
                //         icon: const Icon(Icons.close),
                //         onPressed: () {
                //           Navigator.pop(context);
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 24),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: const Color(0xFF64748B),
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ride History section
          // Text(
          //   "Ride History",
          //   style: Theme.of(context)
          //       .textTheme
          //       .titleMedium
          //       ?.copyWith(color: subtle, fontWeight: FontWeight.w700),
          // ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.show_chart,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "RIDE HISTORY",
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          // const SizedBox(height: 12),
          // _kv("Used", "0", valueColor: Colors.green.shade600),
          // const SizedBox(height: 8),
          // _kv("Cancelled", "0", valueColor: Colors.red.shade600),
          // const SizedBox(height: 8),
          // _kv("Balance Amount", "0"),
          // const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _kv("USED", "0", valueColor: Colors.green.shade600),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                ),
                _kv("CANCELLED", "0", valueColor: Colors.red.shade600),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                ),
                _kv("BALANCE AMOUNT", "£0.00"),
              ],
            ),
          ),

          const Spacer(),

          // Bottom border accent (to mirror screenshot spacing)
          // Container(
          //   height: 2,
          //   margin: const EdgeInsets.only(bottom: 0),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFE1E7F0),
          //     borderRadius: BorderRadius.circular(4),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

//   Widget _kv(String k, String v, {Color? valueColor}) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             k,
//             style: const TextStyle(
//                 color: Color(0xFF6B7C8F), fontWeight: FontWeight.w600),
//           ),
//         ),
//         Text(
//           v,
//           style: TextStyle(
//             color: valueColor ?? Colors.black87,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ],
//     );
//   }
  Widget _kv(String k, String v, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            k,
            style: const TextStyle(
              // color: Color(0xFF64748B),
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          v,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF0F172A),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
