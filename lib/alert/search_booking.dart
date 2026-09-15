// import 'package:dashboard_new1/component/color.dart';
// import 'package:dashboard_new1/component/datatable_widget.dart';
// import 'package:dashboard_new1/component/textStyle.dart';
// import 'package:dashboard_new1/component/text_field.dart';
// import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
// import 'package:flutter/material.dart';
// class SearchBookingAlert extends StatefulWidget {
//   const SearchBookingAlert({super.key});
//
//   @override
//   State<SearchBookingAlert> createState() => _SearchBookingAlertState();
// }
//
// class _SearchBookingAlertState extends State<SearchBookingAlert> {
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _telephoneController = TextEditingController();
//   final TextEditingController _fromDateController = TextEditingController(text: "MM/DD/YYYY");
//   final TextEditingController _toDateController = TextEditingController(text: "MM/DD/YYYY");
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       insetPadding: const EdgeInsets.all(20),
//       backgroundColor: Colors.white,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.95,
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.9,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Title Section ──
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF8F9FA), // Slightly off-white header as per image
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(8),
//                   topRight: Radius.circular(8),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.search, color: Color(0xFF4CAF50), size: 24),
//                   const SizedBox(width: 8),
//                   Text(
//                     "SEARCH BOOKINGS",
//                     style: mozillaTextSemiBoldText(
//                       fontSize: 14,
//                       color: const Color(0xFF101B2E),
//                       fontWeight: FontWeight.w900, ),),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.grey, size: 20),
//                     onPressed: () => Navigator.of(context).pop(),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(height: 1, color: Colors.black12),
//
//             // ── Filter Section ──
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     _buildInputWithLabel("NAME", _nameController, width: 140),
//                     const SizedBox(width: 12),
//                     _buildInputWithLabel("MOBILE", _mobileController, width: 140),
//                     const SizedBox(width: 12),
//                     _buildInputWithLabel("TELEPHONE", _telephoneController, width: 140),
//                     const SizedBox(width: 12),
//                     _buildDatePickerWithLabel("FROM DATE", _fromDateController),
//                     const SizedBox(width: 12),
//                     _buildDatePickerWithLabel("TO DATE", _toDateController),
//                     const SizedBox(width: 12),
//                     // Filter Button
//                     _buildButton("FILTER",  DynamicColors.primaryClr, Colors.white, isWide: true),
//                     const SizedBox(width: 8),
//                     // Clear Button
//                     _buildButton("CLEAR", Colors.grey.shade100, Colors.black87, isWide: false),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ── Data Table ──
//             Flexible(
//               child: Container(
//                 width: double.infinity,
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: SingleChildScrollView(
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(minWidth: constraints.maxWidth),
//                             child: DatatableWidget(
//                               columns: [
//                                 _buildDataColumn("REF #"),
//                                 _buildDataColumn("DATETIME"),
//                                 _buildDataColumn("VEHICLE"),
//                                 _buildDataColumn("PICKUP"),
//                                 _buildDataColumn("DROPOFF"),
//                                 _buildDataColumn("FARES"),
//                                 _buildDataColumn("CUSTOMER"),
//                                 _buildDataColumn("ACCOUNT"),
//                                 _buildDataColumn("DRIVER"),
//                                 _buildDataColumn("P/T"),
//                                 _buildDataColumn("STATUS"),
//                                 _buildDataColumn("ACTIONS"),
//                               ],
//                               rows: [
//                                 DataRow(
//                                   cells: [
//                                     DataCell(_buildTableTextField("REF", width: 60)),
//                                     DataCell(_buildTableTextField("DATE/TIME", width: 100)),
//                                     DataCell(_buildTableTextField("VEHICLE", width: 80)),
//                                     DataCell(_buildTableTextField("PICKUP", width: 150)),
//                                     DataCell(_buildTableTextField("DROPOFF", width: 150)),
//                                     DataCell(_buildTableTextField("FARE", width: 60)),
//                                     DataCell(_buildTableTextField("CUSTOMER", width: 90)),
//                                     DataCell(_buildTableTextField("ACCOUNT", width: 90)),
//                                     DataCell(_buildTableTextField("DRIVER", width: 90)),
//                                     DataCell(_buildTableTextField("P/T", width: 50)),
//                                     DataCell(_buildTableTextField("STATUS", width: 70)),
//                                     const DataCell(SizedBox()), // Empty for ACTIONS
//                                   ]
//                                 ),
//                                 // Empty rows to simulate empty space from screenshot if needed,
//                                 // but the container will already expand to fill the modal.
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                   ),
//                 ),
//               ),
//             ),
//
//             const Divider(height: 1, color: Colors.black12),
//
//             // ── Footer Section ──
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   _buildButton("CLOSE", Colors.grey.shade100, Colors.black87, isWide: false, onTap: () => Navigator.of(context).pop()),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   DataColumn _buildDataColumn(String title) {
//     return DataColumn(
//       label: Text(
//         title,
//         style: mozillaTextSemiBoldText(
//           fontSize: 11,
//           color: const Color(0xFF101B2E),
//           fontWeight: FontWeight.w900,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputWithLabel(String label, TextEditingController controller, {double width = 120}) {
//     return CustomTextField(
//       borderRadius: 4,
//       controller: controller,
//       width: width,
//       height: 32,
//       hintText: label,
//       columnText: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//     );
//   }
//
//   Widget _buildDatePickerWithLabel(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: mozillaTextSemiBoldText(
//             fontSize: 10,
//             color: Colors.black,
//             fontWeight: FontWeight.bold
//           )
//         ),
//         const SizedBox(height: 4),
//         SizedBox(
//           width: 140,
//           height: 32,
//           child: KeyboardDatePicker(
//             key: ValueKey(controller.text),
//             initialDate: controller.text.isNotEmpty && controller.text != "MM/DD/YYYY"
//                 ? DateTime.tryParse(controller.text) ?? DateTime.now()
//                 : DateTime.now(),
//             borderClr: Colors.grey.shade300,
//             fontSize: 12,
//             iconSize: 14,
//             onChanged: (date) {
//               setState(() {
//                 controller.text = date.toIso8601String().split("T").first;
//               });
//             },
//             onSubmitted: (date) {
//               setState(() {
//                 controller.text = date.toIso8601String().split("T").first;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTableTextField(String hint, {double width = 80}) {
//     return Container(
//       height: 30,
//       width: width,
//       alignment: Alignment.centerLeft,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(4),
//         color: Colors.white,
//       ),
//       child: TextField(
//         style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: mozillaTextSemiBoldText(fontSize: 10, color: Colors.grey.shade500),
//           border: InputBorder.none,
//           isDense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String text, Color bgColor, Color textColor, {bool isWide = false, VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 32,
//         padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(color: bgColor == Colors.white || bgColor == Colors.grey.shade100 ? Colors.grey.shade300 : bgColor),
//         ),
//         child: Text(
//           text,
//           style: mozillaTextSemiBoldText(
//             fontSize: 12,
//             color: textColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';

import '../component/networks/api.dart';
import '../view/dashboard_view/booking_table.dart';
import '../view/dashboard_view/models/pick_booking_alert_model.dart';

// Aapke API helper class aur model ka import Path apne project ke mutabiq adjustment kar lein
// import 'package:dashboard_new1/models/booking_model.dart';
// import 'package:dashboard_new1/services/api.dart';

class SearchBookingAlert extends StatefulWidget {
  const SearchBookingAlert({super.key});

  @override
  State<SearchBookingAlert> createState() => _SearchBookingAlertState();
}

// class _SearchBookingAlertState extends State<SearchBookingAlert> {
//   // Top Filter Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _telephoneController = TextEditingController();
//   final TextEditingController _fromDateController = TextEditingController();
//   final TextEditingController _toDateController = TextEditingController();
//
//   // Table Column Search Controllers
//   final TextEditingController _searchRefController = TextEditingController();
//   final TextEditingController _searchDateTimeController = TextEditingController();
//   final TextEditingController _searchVehicleController = TextEditingController();
//   final TextEditingController _searchPickupController = TextEditingController();
//   final TextEditingController _searchDropoffController = TextEditingController();
//   final TextEditingController _searchFareController = TextEditingController();
//   final TextEditingController _searchCustomerController = TextEditingController();
//   final TextEditingController _searchAccountController = TextEditingController();
//   final TextEditingController _searchDriverController = TextEditingController();
//   final TextEditingController _searchPaymentTypeController = TextEditingController();
//   final TextEditingController _searchStatusController = TextEditingController();
//
//   // GetX Reactive Variables
//   RxList<BookingModel> bookingsList = <BookingModel>[].obs;
//   RxBool isLoading = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBookings();
//   }
//
//   // Mobile enter hone par Auto-Fill hone ka function
//   Future<void> autoFillCustomerDetails(String mobileNumber) async {
//     if (mobileNumber.trim().length < 3) return;
//
//     try {
//       dynamic rawResponse = await Api().get(
//         'bookings/pick-bookings',
//         sendCompanyId: true,
//         queryParameters: {
//           "mobile": mobileNumber.trim(),
//         },
//       );
//
//       Map<String, dynamic>? data;
//       if (rawResponse is Map<String, dynamic>) {
//         data = rawResponse;
//       } else if (rawResponse != null && rawResponse.data != null) {
//         data = rawResponse.data;
//       }
//
//       if (data != null && data['status'] == true) {
//         List rawList = data['bookings'] ?? [];
//         if (rawList.isNotEmpty) {
//           BookingModel firstBooking = BookingModel.fromJson(rawList.first);
//
//           _nameController.text = firstBooking.name ?? '';
//           _telephoneController.text = firstBooking.telephone ?? '';
//         }
//       }
//     } catch (e) {
//       debugPrint("Auto-fill error: $e");
//     }
//   }
//
//   // Complete List Filter and Fetch function
//   Future<void> fetchBookings() async {
//     try {
//       isLoading.value = true;
//
//       Map<String, dynamic> params = {};
//
//       void addIfValid(String key, String text) {
//         final value = text.trim();
//         if (value.isNotEmpty && value != "MM/DD/YYYY") {
//           params[key] = value;
//         }
//       }
//
//       addIfValid('name', _nameController.text);
//       addIfValid('mobile', _mobileController.text);
//       addIfValid('telephone', _telephoneController.text);
//       addIfValid('from_date', _fromDateController.text);
//       addIfValid('to_date', _toDateController.text);
//
//       // Dynamic Column Filters
//       addIfValid('search_ref', _searchRefController.text);
//       addIfValid('search_pickup', _searchPickupController.text);
//       addIfValid('search_dropoff', _searchDropoffController.text);
//       addIfValid('search_status', _searchStatusController.text);
//       addIfValid('search_vehicle', _searchVehicleController.text);
//       addIfValid('search_payment_type', _searchPaymentTypeController.text);
//       addIfValid('search_fares', _searchFareController.text);
//
//       // Dio call response
//       dynamic rawResponse = await Api().get(
//         'bookings/pick-bookings',
//         sendCompanyId: true,
//         queryParameters: params,
//       );
//
//       // Agar Api() class Dio Response object return karti hai
//       Map<String, dynamic>? data;
//       if (rawResponse is Map<String, dynamic>) {
//         data = rawResponse;
//       } else if (rawResponse != null && rawResponse.data != null) {
//         data = rawResponse.data is Map<String, dynamic>
//             ? rawResponse.data
//             : null;
//       }
//
//       if (data != null && data['status'] == true) {
//         List rawData = data['bookings'] ?? [];
//         bookingsList.value = rawData.map((e) => BookingModel.fromJson(e)).toList();
//       } else {
//         bookingsList.clear();
//       }
//     } catch (e) {
//       debugPrint("API Fetch Error: $e");
//       bookingsList.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _clearFilters() {
//     _nameController.clear();
//     _mobileController.clear();
//     _telephoneController.clear();
//     _fromDateController.clear();
//     _toDateController.clear();
//     _searchRefController.clear();
//     _searchDateTimeController.clear();
//     _searchVehicleController.clear();
//     _searchPickupController.clear();
//     _searchDropoffController.clear();
//     _searchFareController.clear();
//     _searchCustomerController.clear();
//     _searchAccountController.clear();
//     _searchDriverController.clear();
//     _searchPaymentTypeController.clear();
//     _searchStatusController.clear();
//     fetchBookings();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       insetPadding: const EdgeInsets.all(20),
//       backgroundColor: Colors.white,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.95,
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.9,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Title Section ──
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF8F9FA),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(8),
//                   topRight: Radius.circular(8),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.search, color: Color(0xFF00569A), size: 24),
//                   const SizedBox(width: 8),
//                   Text(
//                     "SEARCH BOOKINGS",
//                     style: mozillaTextSemiBoldText(
//                       fontSize: 14,
//                       color: const Color(0xFF101B2E),
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.grey, size: 20),
//                     onPressed: () => Navigator.of(context).pop(),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(height: 1, color: Colors.black12),
//
//             // ── Filter Section ──
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     _buildInputWithLabel("NAME", _nameController, width: 140),
//                     const SizedBox(width: 12),
//                     _buildMobileInputWithAutoFill("MOBILE", _mobileController, width: 140),
//                     const SizedBox(width: 12),
//                     _buildInputWithLabel("TELEPHONE", _telephoneController, width: 140),
//                     const SizedBox(width: 12),
//                     _buildDatePickerWithLabel("FROM DATE", _fromDateController),
//                     const SizedBox(width: 12),
//                     _buildDatePickerWithLabel("TO DATE", _toDateController),
//                     const SizedBox(width: 12),
//                     _buildButton("FILTER", DynamicColors.primaryClr, Colors.white, isWide: true, onTap: fetchBookings),
//                     const SizedBox(width: 8),
//                     _buildButton("CLEAR", Colors.grey.shade100, Colors.black87, isWide: false, onTap: _clearFilters),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ── Data Table Dynamic Section ──
//             Flexible(
//               child: Container(
//                 width: double.infinity,
//                 color: Colors.white,
//                 child: Obx(() {
//                   if (isLoading.value) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         return SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: SingleChildScrollView(
//                             child: ConstrainedBox(
//                               constraints: BoxConstraints(minWidth: constraints.maxWidth),
//                               child: DatatableWidget(
//                                 columns: [
//                                   buildHeaderWithSearch(
//                                     onChanged: (v) {_searchRefController;
//                                     fetchBookings;
//                                     },
//                                   title:
//                                       "REF #",
//                                   ),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {_searchDateTimeController;
//                                       fetchBookings;
//                                         },
//                                       title: "DATETIME"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {
//                                         _searchVehicleController;
//                                         fetchBookings;
//                                         },
//                                       title: "VEHICLE"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {
//                                         _searchPickupController;
//                                         fetchBookings;
//                                       },
//                                       title: "PICKUP"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {
//                                         _searchDropoffController;
//                                         fetchBookings;
//                                       },
//                                       title: "DROPOFF"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {
//                                         _searchFareController;
//                                         fetchBookings;
//
//                                       },
//                                       title: "FARES"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {
//                                         _searchCustomerController;
//                                         fetchBookings;
//                                       },
//                                       title: "CUSTOMER"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {
//                                         _searchAccountController;
//                                         fetchBookings;
//                                       },
//                                       title: "ACCOUNT"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {
//                                         _searchDriverController;
//                                         fetchBookings;
//                                       },
//                                       title: "DRIVER"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {
//                                         _searchPaymentTypeController;
//                                         fetchBookings;
//                                       },
//                                       title: "P/T"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {
//                                         _searchStatusController;
//                                         fetchBookings;
//                                       },
//                                       title: "STATUS"),
//                                   buildHeaderWithSearch(
//                                       onChanged: (v) {},
//                                       title: "ACTIONS"),
//                                 ],
//                                 rows: [
//                                   // Rendered Dynamic Booking Rows via Model
//                                   ...bookingsList.map((booking) {
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(Text(booking.referenceNumber ?? '', style: _kValueTextStyle)),
//                                         DataCell(Text("${booking.pickupDate ?? ''}\n${booking.pickupTime ?? ''}", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
//                                         DataCell(Text(booking.vehicleType?.name ?? '', style: _kValueTextStyle)),
//                                         DataCell(Text(booking.pickup ?? '', style: _kValueTextStyle)),
//                                         DataCell(Text(booking.dropoff ?? '', style: _kValueTextStyle)),
//                                         DataCell(Text("£${booking.fares ?? '0.00'}", style: _kValueTextStyle)),
//                                         DataCell(Text(booking.name ?? '', style: _kValueTextStyle)),
//                                         DataCell(Text(booking.account?.name ?? '-', style: _kValueTextStyle)),
//                                         DataCell(Text(booking.driver?.name ?? '-', style: _kValueTextStyle)),
//                                         DataCell(Text(booking.paymentType?.name ?? '', style: _kValueTextStyle)),
//                                         DataCell(Text(booking.bookingStatus?.bookingStatus ?? '', style: _kValueTextStyle)),
//                                         DataCell(
//                                           TextButton(onPressed: () {  }, child: Text("PICK",style: TextStyle(
//                                             fontFamily: 'Outfit-Regular',
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                           ),),),
//
//                                         ),
//                                       ],
//                                     );
//                                   }),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }),
//               ),
//             ),
//
//             const Divider(height: 1, color: Colors.black12),
//
//             // ── Footer Section ──
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   _buildButton("CLOSE", Colors.grey.shade100, Colors.black87, isWide: false, onTap: () => Navigator.of(context).pop()),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   DataColumn _buildDataColumn(String title) {
//     return DataColumn(
//       label: Text(
//         title,
//         style: mozillaTextSemiBoldText(
//           fontSize: 11,
//           color: const Color(0xFF101B2E),
//           fontWeight: FontWeight.w900,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputWithLabel(String label, TextEditingController controller, {double width = 120}) {
//     return CustomTextField(
//       borderRadius: 4,
//       controller: controller,
//       width: width,
//       height: 32,
//       hintText: label,
//       columnText: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//     );
//   }
//
//   // Focus blur / onChanged listener input field
//   Widget _buildMobileInputWithAutoFill(String label, TextEditingController controller, {double width = 120}) {
//     return SizedBox(
//       width: width,
//       child: Focus(
//         onFocusChange: (hasFocus) {
//           if (!hasFocus && controller.text.isNotEmpty) {
//             autoFillCustomerDetails(controller.text);
//           }
//         },
//         child: CustomTextField(
//           borderRadius: 4,
//           controller: controller,
//           width: width,
//           height: 32,
//           hintText: label,
//           columnText: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//           onChanged: (val) {
//             if (val.length >= 10) {
//               autoFillCustomerDetails(val);
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDatePickerWithLabel(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: mozillaTextSemiBoldText(
//             fontSize: 10,
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         SizedBox(
//           width: 140,
//           height: 32,
//           child: KeyboardDatePicker(
//             key: ValueKey(controller.text),
//             initialDate: controller.text.isNotEmpty && controller.text != "MM/DD/YYYY"
//                 ? DateTime.tryParse(controller.text) ?? DateTime.now()
//                 : DateTime.now(),
//             borderClr: Colors.grey.shade300,
//             fontSize: 12,
//             iconSize: 14,
//             onChanged: (date) {
//               setState(() {
//                 controller.text = date.toIso8601String().split("T").first;
//               });
//             },
//             onSubmitted: (date) {
//               setState(() {
//                 controller.text = date.toIso8601String().split("T").first;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTableTextField(String hint, TextEditingController controller, {double width = 80}) {
//     return Container(
//       height: 30,
//       width: width,
//       alignment: Alignment.centerLeft,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(4),
//         color: Colors.white,
//       ),
//       child: TextField(
//         controller: controller,
//         onSubmitted: (_) => fetchBookings(),
//         style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: mozillaTextSemiBoldText(fontSize: 10, color: Colors.grey.shade500),
//           border: InputBorder.none,
//           isDense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String text, Color bgColor, Color textColor, {bool isWide = false, VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 32,
//         padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(color: bgColor == Colors.white || bgColor == Colors.grey.shade100 ? Colors.grey.shade300 : bgColor),
//         ),
//         child: Text(
//           text,
//           style: mozillaTextSemiBoldText(
//             fontSize: 12,
//             color: textColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

class _SearchBookingAlertState extends State<SearchBookingAlert> {
  // Top Filter Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  // Table Column Search Controllers
  final TextEditingController _searchRefController = TextEditingController();
  final TextEditingController _searchDateTimeController = TextEditingController();
  final TextEditingController _searchVehicleController = TextEditingController();
  final TextEditingController _searchPickupController = TextEditingController();
  final TextEditingController _searchDropoffController = TextEditingController();
  final TextEditingController _searchFareController = TextEditingController();
  final TextEditingController _searchCustomerController = TextEditingController();
  final TextEditingController _searchAccountController = TextEditingController();
  final TextEditingController _searchDriverController = TextEditingController();
  final TextEditingController _searchPaymentTypeController = TextEditingController();
  final TextEditingController _searchStatusController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ── GetX Reactive Variables for Search & Data ──

  PickBookingModel? _bookingModel;
  Bookings? bookings;
  RxList<Bookings> PickBookingListAll = <Bookings>[].obs;
  RxList<Bookings> PickBookingfiltered = <Bookings>[].obs;

  RxBool isLoading = false.obs;

  RxString searchName = ''.obs;
  RxString searchMobile = ''.obs;
  RxString searchTele = ''.obs;
  RxString searchFromDate = ''.obs;
  RxString searchToDate = ''.obs;

  RxString searchRef = ''.obs;
  RxString searchPickup = ''.obs;
  RxString searchDropoff = ''.obs;
  RxString searchStatus = ''.obs;
  RxString searchVehicle = ''.obs;
  RxString searchPaymentType = ''.obs;
  RxString searchFare = ''.obs;
  RxString searchCustomer = ''.obs;
  RxString searchAccount = ''.obs;
  RxString searchDriver = ''.obs;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }


  @override
  void dispose() {
    // 2. Dispose properly to prevent memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  // Mobile Auto-Fill Logic
  Future<void> autoFillCustomerDetails(String mobileNumber) async {
    if (mobileNumber.trim().length < 3) return;

    try {
      dynamic response = await Api().get(
        'bookings/pick-bookings',
        sendCompanyId: true,
        queryParameters: {
          "mobile": mobileNumber.trim(),
        },
      );

      Map<String, dynamic>? data;
      if (response is Map<String, dynamic>) {
        data = response;
      } else if (response != null && response.data != null) {
        data = response.data;
      }

      if (data != null && data['status'] == true) {
        List rawList = data['bookings'] ?? [];
        if (rawList.isNotEmpty) {
          Bookings firstBooking = Bookings.fromJson(rawList.first);
          _nameController.text = firstBooking.name ?? '';
          _telephoneController.text = firstBooking.telephone ?? '';
        }
      }
    } catch (e) {
      debugPrint("Auto-fill error: $e");
    }
  }

  // ── Search & Fetch Function
  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> queryParams = {

        "name": searchName.value.toLowerCase(),
        "mobile": searchMobile.value.toLowerCase(),
        "telephone": searchTele.value.toLowerCase(),
        "from_date": searchFromDate.value,
        "to_date": searchToDate.value,
        "search_ref": searchRef.value.toLowerCase(),
        "search_pickup": searchPickup.value.toLowerCase(),
        "search_dropoff": searchDropoff.value.toLowerCase(),
        "search_status": searchStatus.value.toLowerCase(),
        "search_vehicle": searchVehicle.value.toLowerCase(),
        "search_payment_type": searchPaymentType.value.toLowerCase(),
        "search_fares": searchFare.value.toLowerCase(),
        "search_customer": searchCustomer.value.toLowerCase(),
        "search_account": searchAccount.value.toLowerCase(),
        "search_driver": searchDriver.value.toLowerCase(),
      };
      // Remove Empty Query Params
      queryParams.removeWhere((key, value) => value == '' || value == "MM/DD/YYYY");
      dynamic response = await Api().get(
        "bookings/pick-bookings",
        queryParameters: queryParams,
        sendCompanyId: true,);
      if (response.statusCode == 200) {
        _bookingModel = PickBookingModel.fromJson(response.data);
        PickBookingListAll.value = _bookingModel!.bookings ?? [];
        PickBookingfiltered.value = PickBookingListAll;
        isLoading.value = false;
  }
    } catch (e) {
      debugPrint("API Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Trigger search on change/submit
  void onSearchBooking() {

    // Map controller values to reactive strings
    searchName.value = _nameController.text.trim();
    searchMobile.value = _mobileController.text.trim();
    searchTele.value = _telephoneController.text.trim();
    searchFromDate.value = _fromDateController.text.trim();
    searchToDate.value = _toDateController.text.trim();

    searchRef.value = _searchRefController.text.trim();
    searchVehicle.value = _searchVehicleController.text.trim();
    searchPickup.value = _searchPickupController.text.trim();
    searchDropoff.value = _searchDropoffController.text.trim();
    searchFare.value = _searchFareController.text.trim();
    searchCustomer.value = _searchCustomerController.text.trim();
    searchAccount.value = _searchAccountController.text.trim();
    searchDriver.value = _searchDriverController.text.trim();
    searchPaymentType.value = _searchPaymentTypeController.text.trim();
    searchStatus.value = _searchStatusController.text.trim();

    fetchBookings();
  }

  void _clearFilters() {
    _nameController.clear();
    _mobileController.clear();
    _telephoneController.clear();
    _fromDateController.clear();
    _toDateController.clear();
    _searchRefController.clear();
    _searchDateTimeController.clear();
    _searchVehicleController.clear();
    _searchPickupController.clear();
    _searchDropoffController.clear();
    _searchFareController.clear();
    _searchCustomerController.clear();
    _searchAccountController.clear();
    _searchDriverController.clear();
    _searchPaymentTypeController.clear();
    _searchStatusController.clear();

    onSearchBooking();
  }

  @override
  Widget build(BuildContext context) {
    double dialogHeight = MediaQuery.of(context).size.height * 0.70; // Dialog height thodi extend ki hai scroll space ke liye

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.all(10), // Padding thodi kam ki hai taake max width mile
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.98, // Full dialog width expand ki hai
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // ── Title Section ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF00569A), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "SEARCH BOOKINGS",
                    style: _kOutfitStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF101B2E)),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),

            // ── Top Filter Section ──
            Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 8.0, bottom: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildInputWithLabel("NAME", _nameController, width: 140),
                    const SizedBox(width: 12),
                    _buildMobileInputWithAutoFill("MOBILE", _mobileController, width: 140),
                    const SizedBox(width: 12),
                    _buildInputWithLabel("TELEPHONE", _telephoneController, width: 140),
                    const SizedBox(width: 12),
                    _buildDatePickerWithLabel("FROM DATE", _fromDateController),
                    const SizedBox(width: 12),
                    _buildDatePickerWithLabel("TO DATE", _toDateController),
                    const SizedBox(width: 12),
                    _buildButton("FILTER", DynamicColors.primaryClr, Colors.white, isWide: true, onTap: onSearchBooking),
                    const SizedBox(width: 8),
                    _buildButton("CLEAR", Colors.grey.shade100, Colors.black87, isWide: false, onTap: _clearFilters),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, color: Colors.black12),

            // ── Dynamic Data Table Section (Vertical Scrollable) ──
            // ── Dynamic Data Table Section (Only Rows Update) ──
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Obx(() {
                  // 1. Loading State Check
                  if (isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Empty State Check
                  if (PickBookingfiltered.isEmpty) {
                    return const Center(child: Text("No bookings found."));
                  }

                  // 3. Table UI Base (Yeh Widget Destroy Nahi Hoga)
                  return RawScrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(4),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: DatatableWidget(
                        columnSpacing: 8,
                        horizontalMargin: 4,
                        headingRowHeight: 60,
                        dataRowMinHeight: 50,
                        dataRowMaxHeight: 65,
                        // Headers fixed rahenge:
                        columns: [
                          buildHeaderWithSearch(controller: _searchRefController, onChanged: (v) => onSearchBooking(), title: "REF #"),
                          buildHeaderWithSearch(controller: _searchDateTimeController, onChanged: (v) => onSearchBooking(), title: "DATE/TIME"),
                          buildHeaderWithSearch(controller: _searchVehicleController, onChanged: (v) => onSearchBooking(), title: "VEHICLE"),
                          buildHeaderWithSearch(controller: _searchPickupController, onChanged: (v) => onSearchBooking(), title: "PICKUP"),
                          buildHeaderWithSearch(controller: _searchDropoffController, onChanged: (v) => onSearchBooking(), title: "DROPOFF"),
                          buildHeaderWithSearch(controller: _searchFareController, onChanged: (v) => onSearchBooking(), title: "FARES"),
                          buildHeaderWithSearch(controller: _searchCustomerController, onChanged: (v) => onSearchBooking(), title: "CUST"),
                          buildHeaderWithSearch(controller: _searchAccountController, onChanged: (v) => onSearchBooking(), title: "ACC"),
                          buildHeaderWithSearch(controller: _searchDriverController, onChanged: (v) => onSearchBooking(), title: "DRIVER"),
                          buildHeaderWithSearch(controller: _searchPaymentTypeController, onChanged: (v) => onSearchBooking(), title: "P/T"),
                          buildHeaderWithSearch(controller: _searchStatusController, onChanged: (v) => onSearchBooking(), title: "STATUS"),
                          buildHeaderWithSearch(onChanged: (v) {}, title: "ACTION"),
                        ],
                        // Rows Reactive mapping se bind hongi:
                        rows: PickBookingfiltered.map((booking) {
                          return DataRow(
                            key: ValueKey(booking.referenceNumber ?? booking.id), // Unique Key for Row performance optimization
                            cells: [
                              DataCell(Center(child: _buildCellText(booking.referenceNumber ?? ''))),
                              DataCell(Center(child: _buildCellText("${booking.pickupDate ?? ''}\n${booking.pickupTime ?? ''}", isSmall: true))),
                              DataCell(Center(child: _buildCellText(booking.vehicleType?.name ?? ''))),
                              DataCell(Center(child: _buildCellText(booking.pickup ?? ''))),
                              DataCell(Center(child: _buildCellText(booking.dropoff ?? ''))),
                              DataCell(Center(child: _buildCellText("£${booking.fares ?? '0.00'}"))),
                              DataCell(Center(child: _buildCellText(booking.name ?? ''))),
                              DataCell(Center(child: _buildCellText(booking.account?.name ?? '-'))),
                              DataCell(Center(child: _buildCellText(booking.driver?.name ?? '-'))),
                              DataCell(Center(child: _buildCellText(booking.paymentType?.name ?? ''))),
                              DataCell(Center(child: _buildCellText(booking.bookingStatus?.bookingStatus ?? ''))),
                              DataCell(
                                Center(
                                  child: SizedBox(
                                    width: 30,
                                    child: TextButton(
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                      onPressed: () {},
                                      child: Text(
                                        "PICK",
                                        style: _kOutfitStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const Divider(height: 1, color: Colors.black12),

            // ── Footer Section ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildButton("CLOSE", Colors.grey.shade100, Colors.black87, isWide: false, onTap: () => Navigator.of(context).pop()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// ── Text overflow handling helper function ──
  Widget _buildCellText(String text, {bool isSmall = false}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 90), // Fixed width constraint per cell
      child: Text(
        text,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: _kOutfitStyle(
          fontSize: isSmall ? 12 : 13,
          fontWeight: FontWeight.normal,
          color: DynamicColors.textClr,
        ),
      ),
    );
  }

  // Outfit font helper
  TextStyle _kOutfitStyle({double fontSize = 12, FontWeight fontWeight = FontWeight.normal, Color color = Colors.black}) {
    return TextStyle(
      fontFamily: 'Outfit-Regular',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  Widget _buildInputWithLabel(String label, TextEditingController controller, {double width = 120}) {
    return CustomTextField(
      borderRadius: 4,
      controller: controller,
      width: width,
      height: 32,
      hintText: label,
      columnText: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildMobileInputWithAutoFill(String label, TextEditingController controller, {double width = 120}) {
    return SizedBox(
      width: width,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && controller.text.isNotEmpty) {
            autoFillCustomerDetails(controller.text);
          }
        },
        child: CustomTextField(
          borderRadius: 4,
          controller: controller,
          width: width,
          height: 32,
          hintText: label,
          columnText: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          onChanged: (val) {
            if (val.length >= 10) {
              autoFillCustomerDetails(val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDatePickerWithLabel(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _kOutfitStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 140,
          height: 32,
          child: KeyboardDatePicker(
            key: ValueKey(controller.text),
            initialDate: controller.text.isNotEmpty && controller.text != "MM/DD/YYYY"
                ? DateTime.tryParse(controller.text) ?? DateTime.now()
                : DateTime.now(),
            borderClr: Colors.grey.shade300,
            fontSize: 12,
            iconSize: 14,
            onChanged: (date) {
              setState(() {
                controller.text = date.toIso8601String().split("T").first;
              });
            },
            onSubmitted: (date) {
              setState(() {
                controller.text = date.toIso8601String().split("T").first;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, {bool isWide = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: bgColor == Colors.white || bgColor == Colors.grey.shade100 ? Colors.grey.shade300 : bgColor),
        ),
        child: Text(
          text,
          style: _kOutfitStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }
}




