import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/responsive_datatable_widget.dart';
import '../view/dashboard_view/booking_table.dart';

// class DriverExpiryDocumentsAlert {
//   static void show() {
//   int selectedRowIndex = 0;
//   final int totalRows = 5;
//     Get.dialog(
//       Dialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         child: Container(
//           width: 1100, // Adjusted for 7 columns to fit comfortably
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "DRIVER EXPIRY DOCUMENTS",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: DynamicColors.primaryClr,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.black),
//                     onPressed: () => Get.back(),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               // Table
//               // ── Data Table ──
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: DatatableWidget(
//                     columns: [
//                       buildHeaderWithSearch(title: "DATE"),
//                       buildHeaderWithSearch(title: "DRIVER"),
//                       buildHeaderWithSearch(title: "DRIVING SKILL"),
//                       buildHeaderWithSearch(title: "ROUTE KNOWLEDGE"),
//                       buildHeaderWithSearch(title: "CUSTOMER BEHAVIOUR"),
//                       buildHeaderWithSearch(title: "VEHICLE CONDITION"),
//                       buildHeaderWithSearch(title: "COMMENTS"),
//                     ],
//                     totalRow: totalRows,
//                     cells: [
//                       const DataCell(Center(child: Text("driver"))),
//                       const DataCell(Center(child: Text("bookings"))),
//                       const DataCell(Center(child: Text("loginDate"))),
//                       const DataCell(Center(child: Text("loginTime"))),
//                       const DataCell(Center(child: Text("logoutDate"))),
//                       const DataCell(Center(child: Text("logoutTime"))),
//                       const DataCell(Center(child: Text("logoutTime"))),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: true,
//     );
//   }
//
//   static Widget _headerCell(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       child: Text(
//         text,
//         textAlign: TextAlign.left,
//         style: const TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   static TableRow _buildRow(String username, List<_DocData> docs) {
//     return TableRow(
//       children: [
//         _dataCell(username, _DocState.valid, isUsername: true),
//         ...docs.map((d) => _dataCell(d.date, d.state)),
//       ],
//     );
//   }
//
//   static Widget _dataCell(String text, _DocState state, {bool isUsername = false}) {
//     Color? bgColor;
//     Color textColor = Colors.black;
//
//     if (state == _DocState.expired) {
//       bgColor = Colors.white;
//       textColor = Colors.black;
//     } else if (state == _DocState.warning) {
//       bgColor = Colors.orange.shade400; // Warning/Soon color
//       textColor = Colors.white;
//     } else {
//       bgColor = Colors.white;
//       textColor = Colors.black;
//     }
//
//     return Container(
//       color: bgColor,
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 13,
//           fontWeight: isUsername ? FontWeight.bold : FontWeight.normal,
//           color: textColor,
//         ),
//       ),
//     );
//   }
// }

// enum _DocState { valid, warning, expired }
//
// class _DocData {
//   final String date;
//   final _DocState state;
//   _DocData(this.date, this.state);
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../view/dashboard_view/booking_table.dart';

class DriverExpiryDocumentsAlert {
  static void show(BuildContext context) {
    int selectedRowIndex = 0;
    final int totalRows = 5;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 1100, // Table display width
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DRIVER EXPIRY DOCUMENTS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DynamicColors.primaryClr,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // ── Data Table ──
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 1060, // Fixed width inside container
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(title: "USERNAME"),
                          buildHeaderWithSearch(title: "VEHICLE EXPIRY"),
                          buildHeaderWithSearch(title: "DRIVER EXPIRY"),
                          buildHeaderWithSearch(title: "MOT EXPIRY"),
                          buildHeaderWithSearch(title: "MOT2 EXPIRY"),
                          buildHeaderWithSearch(title: "INSURANCE EXPIRY"),
                          buildHeaderWithSearch(title: "LICENSE EXPIRY"),
                        ],
                        totalRow: totalRows,
                        cells: const [
                          DataCell(Center(child: Text("E01"))),
                          DataCell(Center(child: Text("31-10-2024 14:59"))),
                          DataCell(Center(child: Text("31-10-2024 23:59"))),
                          DataCell(Center(child: Text("26-10-2024 23:59"))),
                          DataCell(Center(child: Text("29-09-2024 23:59"))),
                          DataCell(Center(child: Text("10-11-2024 23:59"))),
                          DataCell(Center(child: Text("03-11-2024 23:59"))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}