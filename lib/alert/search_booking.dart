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
import '../view/dashboard_view/models/pick_booking_alert_model.dart';

// Aapke API helper class aur model ka import Path apne project ke mutabiq adjustment kar lein
// import 'package:dashboard_new1/models/booking_model.dart';
// import 'package:dashboard_new1/services/api.dart';

class SearchBookingAlert extends StatefulWidget {
  const SearchBookingAlert({super.key});

  @override
  State<SearchBookingAlert> createState() => _SearchBookingAlertState();
}

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

  // GetX Reactive Variables
  RxList<BookingModel> bookingsList = <BookingModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  // Mobile enter hone par Auto-Fill hone ka function
  Future<void> autoFillCustomerDetails(String mobileNumber) async {
    if (mobileNumber.trim().length < 3) return;

    try {
      var response = await Api().get(
        'bookings/pick-bookings',
        sendCompanyId: true,
        queryParameters: {
          "mobile": mobileNumber.trim(),
        },
      );

      if (response != null && response['status'] == true) {
        List rawList = response['bookings'] ?? [];
        if (rawList.isNotEmpty) {
          BookingModel firstBooking = BookingModel.fromJson(rawList.first);

          // Customer detail auto fill
          _nameController.text = firstBooking.name ?? '';
          _telephoneController.text = firstBooking.telephone ?? '';
        }
      }
    } catch (e) {
      debugPrint("Auto-fill error: $e");
    }
  }

  // Complete List Filter and Fetch function
  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;

      Map<String, dynamic> params = {};

      if (_nameController.text.trim().isNotEmpty) params['name'] = _nameController.text.trim();
      if (_mobileController.text.trim().isNotEmpty) params['mobile'] = _mobileController.text.trim();
      if (_telephoneController.text.trim().isNotEmpty) params['telephone'] = _telephoneController.text.trim();
      if (_fromDateController.text.trim().isNotEmpty && _fromDateController.text != "MM/DD/YYYY") {
        params['from_date'] = _fromDateController.text.trim();
      }
      if (_toDateController.text.trim().isNotEmpty && _toDateController.text != "MM/DD/YYYY") {
        params['to_date'] = _toDateController.text.trim();
      }

      // Dynamic Column Filters
      if (_searchRefController.text.trim().isNotEmpty) params['search_ref'] = _searchRefController.text.trim();
      if (_searchPickupController.text.trim().isNotEmpty) params['search_pickup'] = _searchPickupController.text.trim();
      if (_searchDropoffController.text.trim().isNotEmpty) params['search_dropoff'] = _searchDropoffController.text.trim();
      if (_searchStatusController.text.trim().isNotEmpty) params['search_status'] = _searchStatusController.text.trim();
      if (_searchVehicleController.text.trim().isNotEmpty) params['search_vehicle'] = _searchVehicleController.text.trim();
      if (_searchPaymentTypeController.text.trim().isNotEmpty) params['search_payment_type'] = _searchPaymentTypeController.text.trim();
      if (_searchFareController.text.trim().isNotEmpty) params['search_fares'] = _searchFareController.text.trim();

      var response = await Api().get(
        'bookings/pick-bookings',
        sendCompanyId: true,
        queryParameters: params,
      );

      if (response != null && response['status'] == true) {
        List rawData = response['bookings'] ?? [];
        bookingsList.value = rawData.map((e) => BookingModel.fromJson(e)).toList();
      } else {
        bookingsList.clear();
      }
    } catch (e) {
      debugPrint("API Fetch Error: $e");
      bookingsList.clear();
    } finally {
      isLoading.value = false;
    }
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
    fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  const Icon(Icons.search, color: Color(0xFF4CAF50), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "SEARCH BOOKINGS",
                    style: mozillaTextSemiBoldText(
                      fontSize: 14,
                      color: const Color(0xFF101B2E),
                      fontWeight: FontWeight.w900,
                    ),
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

            // ── Filter Section ──
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                    _buildButton("FILTER", DynamicColors.primaryClr, Colors.white, isWide: true, onTap: fetchBookings),
                    const SizedBox(width: 8),
                    _buildButton("CLEAR", Colors.grey.shade100, Colors.black87, isWide: false, onTap: _clearFilters),
                  ],
                ),
              ),
            ),

            // ── Data Table Dynamic Section ──
            Flexible(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Obx(() {
                  if (isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minWidth: constraints.maxWidth),
                              child: DatatableWidget(
                                columns: [
                                  _buildDataColumn("REF #"),
                                  _buildDataColumn("DATETIME"),
                                  _buildDataColumn("VEHICLE"),
                                  _buildDataColumn("PICKUP"),
                                  _buildDataColumn("DROPOFF"),
                                  _buildDataColumn("FARES"),
                                  _buildDataColumn("CUSTOMER"),
                                  _buildDataColumn("ACCOUNT"),
                                  _buildDataColumn("DRIVER"),
                                  _buildDataColumn("P/T"),
                                  _buildDataColumn("STATUS"),
                                  _buildDataColumn("ACTIONS"),
                                ],
                                rows: [
                                  // Header Row for Search Inputs inside Table
                                  DataRow(
                                    cells: [
                                      DataCell(_buildTableTextField("REF", _searchRefController, width: 70)),
                                      DataCell(_buildTableTextField("DATE/TIME", _searchDateTimeController, width: 100)),
                                      DataCell(_buildTableTextField("VEHICLE", _searchVehicleController, width: 80)),
                                      DataCell(_buildTableTextField("PICKUP", _searchPickupController, width: 150)),
                                      DataCell(_buildTableTextField("DROPOFF", _searchDropoffController, width: 150)),
                                      DataCell(_buildTableTextField("FARE", _searchFareController, width: 60)),
                                      DataCell(_buildTableTextField("CUSTOMER", _searchCustomerController, width: 90)),
                                      DataCell(_buildTableTextField("ACCOUNT", _searchAccountController, width: 90)),
                                      DataCell(_buildTableTextField("DRIVER", _searchDriverController, width: 90)),
                                      DataCell(_buildTableTextField("P/T", _searchPaymentTypeController, width: 50)),
                                      DataCell(_buildTableTextField("STATUS", _searchStatusController, width: 70)),
                                      const DataCell(SizedBox()),
                                    ],
                                  ),
                                  // Rendered Dynamic Booking Rows via Model
                                  ...bookingsList.map((booking) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(booking.referenceNumber ?? '', style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(Text("${booking.pickupDate ?? ''}\n${booking.pickupTime ?? ''}", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                                        DataCell(Text(booking.vehicleType?.name ?? '', style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(Text(booking.pickup ?? '', style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(Text(booking.dropoff ?? '', style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(Text("£${booking.fares ?? '0.00'}", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(Text(booking.name ?? '', style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(Text(booking.account?.name ?? '-', style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(Text(booking.driver?.name ?? '-', style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(Text(booking.paymentType?.name ?? '', style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(Text(booking.bookingStatus?.bookingStatus ?? '', style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
                                        DataCell(
                                          IconButton(
                                            icon: const Icon(Icons.visibility, size: 16, color: Colors.blue),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),

            const Divider(height: 1, color: Colors.black12),

            // ── Footer Section ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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

  DataColumn _buildDataColumn(String title) {
    return DataColumn(
      label: Text(
        title,
        style: mozillaTextSemiBoldText(
          fontSize: 11,
          color: const Color(0xFF101B2E),
          fontWeight: FontWeight.w900,
        ),
      ),
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

  // Focus blur / onChanged listener input field
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
          style: mozillaTextSemiBoldText(
            fontSize: 10,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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

  Widget _buildTableTextField(String hint, TextEditingController controller, {double width = 80}) {
    return Container(
      height: 30,
      width: width,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        onSubmitted: (_) => fetchBookings(),
        style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: mozillaTextSemiBoldText(fontSize: 10, color: Colors.grey.shade500),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
      ),
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
          style: mozillaTextSemiBoldText(
            fontSize: 12,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}




