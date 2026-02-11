import 'package:dashboard_new1/component/oldDropDown.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/controller/cli_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:html_editor_enhanced/utils/utils.dart';
import '../alert/delete_permission_alert.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/dropdown_button.dart';
import 'dashboard_view/booking_table.dart';

/// Drop this widget anywhere. It renders inside a Container (no Scaffold).
// class ResponsivePassengerScreen extends StatefulWidget {
//   const ResponsivePassengerScreen({super.key});
//
//   @override
//   State<ResponsivePassengerScreen> createState() => _ResponsivePassengerScreenState();
// }
//
// class _ResponsivePassengerScreenState extends State<ResponsivePassengerScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFFF7F9FC),
//       padding: const EdgeInsets.all(16),
//       alignment: Alignment.topCenter,
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 1400),
//         child: LayoutBuilder(
//           builder: (context, c) {
//
//             final w = c.maxWidth;
//
//             // Breakpoints
//             final isDesktop = w >= 1200;
//             final isTablet = w >= 820 && w < 1200;
//             final isMobile = w < 820;
//             final leftWidth = isDesktop ? 280.0 : (isTablet ? 260.0 : 220.0);
//             final rightWidth = isDesktop ? 360.0 : (isTablet ? 320.0 : 300.0);
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: const [
//                   BoxShadow(blurRadius: 20, color: Color(0x14000000))
//                 ],
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: isMobile
//                   ? _MobileLayout(leftWidth: leftWidth, rightWidth: rightWidth)
//                   : _WideLayout(leftWidth: leftWidth, rightWidth: rightWidth),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class ResponsivePassengerScreen extends StatefulWidget {
  final String extensionNumber;
  const ResponsivePassengerScreen({super.key, required this.extensionNumber});

  @override
  State<ResponsivePassengerScreen> createState() =>
      _ResponsivePassengerScreenState();
}

class _ResponsivePassengerScreenState
    extends State<ResponsivePassengerScreen> {

  /// ✅ Socket Controller
  final CliController socketController =
  Get.put(CliController(), permanent: true);

  @override
  void initState() {
    super.initState();
print(widget.extensionNumber);

    /// ✅ CLI screen open hote hi socket connect
    socketController.connectSocket(widget.extensionNumber);
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
        constraints: const BoxConstraints(maxWidth: 1400),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;

            final isDesktop = w >= 1200;
            final isTablet = w >= 820 && w < 1200;
            final isMobile = w < 820;

            final leftWidth =
            isDesktop ? 280.0 : (isTablet ? 260.0 : 220.0);
            final rightWidth =
            isDesktop ? 360.0 : (isTablet ? 320.0 : 300.0);

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
  const _WideLayout({required this.leftWidth, required this.rightWidth});

  final double leftWidth;
  final double rightWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // LEFT SIDEBAR
        SizedBox(width: leftWidth, child: _LeftSidebar()),
        // CENTER
        Expanded(child: _CenterArea()),
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
  @override
  Widget build(BuildContext context) {
    var isChecked = (0).obs;

    RxString selectDriverObject = "SELECT DRIVER 1".obs;
    TextEditingController pickUpcontroller = TextEditingController();
    TextEditingController dropOfUpcontroller = TextEditingController();
    final subtle = const Color(0xFF6B7C8F);
    final int totalRows = 5;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Title'
          Text(
            "Passenger",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: subtle,
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "07795116925",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          // Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Status: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black54)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFE9F5FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xFF94C8FF)),
                ),
                child: Text(
                  "In Use",
                  style: TextStyle(
                    color: Color(0xFF2376D9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Search
          SizedBox(
            height: 44,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                filled: true,
                fillColor: Color(0xFFF2F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ),


          SizedBox(height: 28),

          // Recent Rides header row
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

          SizedBox(height: 50),


          Row(
            children: [
              CustomTextField(controller: pickUpcontroller, width: 200, columnText: true, hintText: "PICK UP", ),
              SizedBox(width: 20),
              CustomTextField(controller: dropOfUpcontroller,  width: 200, columnText: true, hintText: "DROP OFF",),
            ],
          ),
          SizedBox(height: 10),


          // Table header
          // Container(
          //   height: 34,
          //   width: double.infinity,
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   decoration: BoxDecoration(
          //     color: Color(0xFFF7FAFE),
          //     border: Border.all(color: Color(0xFFE3E9F2)),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Row(
          //     children: [
          //       _th(text: "Destination", flex: 3),
          //       _th(text: "Pick-up", flex: 2),
          //       _th(text: "Via", flex: 1),
          //       _th(text: "Fares", flex: 1),
          //       _th(text: "Action", flex: 2, alignEnd: true),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 8),

          // Ride list
          // Expanded(
          //   child: Container(
          //     margin: const EdgeInsets.only(bottom: 12),
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Color(0xFFE3E9F2)),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: ListView.separated(
          //       padding: const EdgeInsets.only(
          //           left: 3, right: 10, top: 5, bottom: 5),
          //       itemCount: 5, // 👈 yahan aap apna data count dal sakte ho
          //       separatorBuilder: (_, __) => const Divider(height: 1),
          //       itemBuilder: (_,i) {
          //         return  Row(
          //           children: [
          //             Expanded(
          //                 flex: 3, child: Text("London City $i")),
          //             Expanded(flex: 3, child: Row(
          //               children: [
          //                 IconButton(
          //                     onPressed: () {},
          //                     icon: Icon(
          //                       Icons.swap_horiz,
          //                       color: const Color(0xFF748399),
          //                     )),
          //                 Text("Pickup $i"),
          //               ],
          //             )),
          //             Expanded(flex: 3, child: Text("Via Point $i")),
          //             Expanded(flex: 1, child: Text("£${10 + i}")),
          //             Expanded(
          //               flex: 2,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.end,
          //                 children: [
          //                   TextButton(
          //                     onPressed: () {
          //                       // TODO: edit callback
          //                     },
          //                     child: const Text("Edit"),
          //                   ),
          //                   const SizedBox(width: 8),
          //                   ElevatedButton(
          //                     onPressed: () {
          //                       // TODO: select callback
          //                     },
          //                     style: ElevatedButton.styleFrom(
          //                       padding: const EdgeInsets.symmetric(
          //                           horizontal: 12, vertical: 6),
          //                       textStyle: const TextStyle(fontSize: 13),
          //                     ),
          //                     child: const Text("Select"),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         );
          //
          //       },
          //     ),
          //   ),
          // ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: DatatableWidget(
                columns: [
                  buildHeaderWithSearch(title: "Destination", removeSearching: true),
                  buildHeaderWithSearch(title: "Pick-up", removeSearching: true),
                  buildHeaderWithSearch(title: "Via", removeSearching: true),
                  buildHeaderWithSearch(title: "Fares", removeSearching: true),
                  buildHeaderWithSearch(title: "Action", removeSearching: true),
                ],
                totalRow: totalRows,
                rows: List.generate(totalRows, (index) {
                  return DataRow(
                    cells: [
                      DataCell(Center(child: Text("London City ${index + 1}"))),
                      DataCell(Center(child: Text("Pickup ${index + 1}"))),
                      DataCell(Center(child: Text("Via Point ${index + 1}"))),
                      DataCell(Center(child: Text("£${10 + index}"))),

                      DataCell(
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [


                              Obx(
                                    () => Checkbox(
                                  value: isChecked.value == index,
                                  onChanged: (v) {
                                    isChecked.value = index; // Sirf ek row select hogi
                                  },
                                ),
                              ),

                              //
                              // Checkbox(
                              //     value: isChecked.value,
                              //     onChanged: (v) {
                              //       isChecked.value = v!;
                              //
                              //     },
                              //     ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),


          // Bottom action row
          SizedBox(height: 20 ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3ECF8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // const SizedBox(width: 8),
              Row(
                children: [

                  // Obx(
                  //       ()=> CustomDropdownField<String>(
                  //     label: "SELECT DRIVERS",
                  //     width: 200,
                  //     height: 35,
                  //     items: ["SELECT DRIVER 1", "SELECT DRIVER 2","SELECT DRIVER 3", "SELECT DRIVER 4"],
                  //     value: selectDriverObject.value,
                  //     itemLabel: (driver) => driver,
                  //     onChanged: (val) {
                  //       selectDriverObject.value = val!;
                  //
                  //     },
                  //   ),
                  // ),



                  // Obx(
                  //       ()=> CustomDropdownField<String>(
                  //     label: "SELECT DRIVERS",
                  //     width: 200,
                  //     height: 35,
                  //     items: ["SELECT DRIVER 1", "SELECT DRIVER 2","SELECT DRIVER 3", "SELECT DRIVER 4"],
                  //     value: selectDriverObject.value,
                  //     itemLabel: (driver) => driver,
                  //     onChanged: (val) {
                  //       selectDriverObject.value = val!;
                  //
                  //     },
                  //   ),
                  // ),
                  ElevatedButton(onPressed: (){}, child:   Text(
                    "SUBMIT",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),),
                  SizedBox(width: 30),
                  Icon(Icons.directions_car),
                  Text(
                    "NEW JOB",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),



                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.add, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _th({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    int flex = 1,
    bool alignEnd = false,
  }) {
    Widget child;

    if (icon != null) {
      child = IconButton(
        icon: Icon(icon),
        onPressed: onPressed ?? () {},
        color: const Color(0xFF748399),
      );
    } else if (text != null) {
      child = Text(
        text,
        style: const TextStyle(
          color: Color(0xFF748399),
          fontWeight: FontWeight.w700,
        ),
        textAlign: alignEnd ? TextAlign.right : TextAlign.left,
      );
    } else {
      child = const SizedBox.shrink(); // agar na text ho na icon
    }

    return Expanded(flex: flex, child: child);
  }
}








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