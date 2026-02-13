import 'package:dashboard_new1/component/oldDropDown.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/controller/cli_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../alert/delete_permission_alert.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/dropdown_button.dart';
import 'dashboard_view/booking_table.dart';

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
    print(widget.extensionNumber);

    /// ✅ CLI screen open hote hi socket connect
    socketController.connectSocket(widget.extensionNumber);
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

class _CenterArea extends StatefulWidget {
  @override
  State<_CenterArea> createState() => _CenterAreaState();
}

class _CenterAreaState extends State<_CenterArea> {
  final CliController controller = Get.find<CliController>();

  final RxInt selectedIndex = (-1).obs;

  TextEditingController pickUpcontroller = TextEditingController();
  TextEditingController dropOfUpcontroller = TextEditingController();

  /// Dropdown variables
  String? selectedDriver;
  String? selectedVehicle;

  final List<String> drivers = [
    "Driver 1",
    "Driver 2",
    "Driver 3",
  ];

  final List<String> vehicles = [
    "Toyota Prius",
    "Honda Civic",
    "Suzuki WagonR",
  ];

  /// Flag to control swapping in table
  bool isSwapped = false;

  @override
  Widget build(BuildContext context) {
    final subtle = const Color(0xFF6B7C8F);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// ================= HEADER =================
            Obx(() => Text(
              controller.customerName.value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: subtle,
                fontWeight: FontWeight.w700,
              ),
            )),

            const SizedBox(height: 4),

            Obx(() => Text(
              controller.customerMobile.value.isEmpty
                  ? "Loading..."
                  : controller.customerMobile.value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            )),

            const SizedBox(height: 16),

            /// ================= SEARCH =================
            SizedBox(
              height: 44,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFF2F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ================= PICKUP & DROPOFF =================
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: pickUpcontroller,
                    decoration: InputDecoration(
                      labelText: "Pickup",
                      filled: true,
                      fillColor: const Color(0xFFF2F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: dropOfUpcontroller,
                    decoration: InputDecoration(
                      labelText: "Drop Off",
                      filled: true,
                      fillColor: const Color(0xFFF2F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// ================= RECENT RIDES =================
            Row(
              children: [
                Text(
                  "Recent Rides",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: subtle, fontWeight: FontWeight.w700),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ================= TABLE with Swap Button =================
            Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.bookings.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text("No Bookings Found"),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Swap Button near table
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSwapped = !isSwapped; // Toggle swap flag
                      });
                    },
                    child: const Text("Swap Destination & Pickup"),
                  ),
                  const SizedBox(height: 8),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 850),
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(title: "Destination", removeSearching: true),
                          buildHeaderWithSearch(title: "Pick-up", removeSearching: true),
                          buildHeaderWithSearch(title: "Date", removeSearching: true),
                          buildHeaderWithSearch(title: "Fare", removeSearching: true),
                          buildHeaderWithSearch(title: "Action", removeSearching: true),
                        ],
                        totalRow: controller.bookings.length,
                        rows: List.generate(
                          controller.bookings.length,
                              (index) {
                            var booking = controller.bookings[index];

                            return DataRow(
                              cells: [
                                // ✅ Swap table values
                                DataCell(
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      isSwapped ? booking["pickup"] ?? "" : booking["dropoff"] ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      isSwapped ? booking["dropoff"] ?? "" : booking["pickup"] ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(booking["pickup_date"] ?? "")),
                                DataCell(Text("£${booking["fares"] ?? 0}")),

                                // ✅ TOGGLE CHECKBOX
                                DataCell(
                                  Obx(() => Checkbox(
                                    value: selectedIndex.value == index,
                                    onChanged: (value) {
                                      if (selectedIndex.value == index) {
                                        selectedIndex.value = -1; // unselect
                                      } else {
                                        selectedIndex.value = index; // select
                                      }
                                    },
                                  )),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),

            /// ================= DRIVER + VEHICLE =================
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedDriver,
                    decoration: InputDecoration(
                      labelText: "Select Driver",
                      filled: true,
                      fillColor: const Color(0xFFF2F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: drivers
                        .map((driver) => DropdownMenuItem<String>(
                      value: driver,
                      child: Text(driver),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDriver = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedVehicle,
                    decoration: InputDecoration(
                      labelText: "Select Vehicle",
                      filled: true,
                      fillColor: const Color(0xFFF2F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: vehicles
                        .map((vehicle) => DropdownMenuItem<String>(
                      value: vehicle,
                      child: Text(vehicle),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVehicle = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// ================= SUBMIT =================
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedIndex.value == -1) {
                      Get.snackbar(
                        "Error",
                        "Please select a booking",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    if (selectedDriver == null || selectedVehicle == null) {
                      Get.snackbar(
                        "Error",
                        "Please select driver and vehicle",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    print("Booking Index: ${selectedIndex.value}");
                    print("Driver: $selectedDriver");
                    print("Vehicle: $selectedVehicle");

                    Get.snackbar(
                      "Success",
                      "Job Assigned Successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                  child: const Text("SUBMIT"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (selectedIndex.value == -1) {
                      Get.snackbar(
                        "Error",
                        "Please select a booking",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    if (selectedDriver == null || selectedVehicle == null) {
                      Get.snackbar(
                        "Error",
                        "Please select driver and vehicle",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    print("Booking Index: ${selectedIndex.value}");
                    print("Driver: $selectedDriver");
                    print("Vehicle: $selectedVehicle");

                    Get.snackbar(
                      "Success",
                      "Job Assigned Successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                  child: const Text("New Booking"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFF4F6FA),
                child: Icon(Icons.person, color: Color(0xFF6B7C8F)),
              ),
              const SizedBox(width: 12),
              Text(
                "Favorite Rides",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: subtle, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
            ],
          ),
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