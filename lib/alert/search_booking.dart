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
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';

import '../component/networks/api.dart';
import '../view/auth/edit_jobs.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../view/dashboard_view/booking_table.dart';
import '../view/dashboard_view/models/pick_booking_alert_model.dart';
import '../view/dashboard_view/models/users_phone_numbers_model.dart';

class SearchBookingAlert extends StatefulWidget {
  final String? pickMobileNumber; // Add this line
  final String? pickName; // Add this line
  final String? pickTeleNumber; // Add this line

  const SearchBookingAlert({
    Key? key,
    this.pickMobileNumber,
    this.pickName,
    this.pickTeleNumber, // Add this line
  }) : super(key: key);

  @override
  State<SearchBookingAlert> createState() => _SearchBookingAlertState();
}

class _SearchBookingAlertState extends State<SearchBookingAlert> {
  // Top Filter Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
  final ScrollController _horizontalScrollController = ScrollController();
  DashboardController deshController = Get.put(DashboardController());

  // Focus Nodes for Keyboard Navigation & Glow Effect
  final FocusNode _dialogFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _telephoneFocusNode = FocusNode();
  final FocusNode _filterButtonFocusNode = FocusNode();
  final FocusNode _clearButtonFocusNode = FocusNode();
  final FocusNode _fromDateFocusNode = FocusNode();
  final FocusNode _toDateFocusNode = FocusNode();

  // ── GetX Reactive Variables for Search & Data ──
  PickBookingModel? _bookingModel;
  RxList<Bookings> PickBookingListAll = <Bookings>[].obs;
  RxList<Bookings> PickBookingfiltered = <Bookings>[].obs;

  RxBool isLoading = false.obs;
  RxBool isCustomerLoading = false.obs;

  RxList<CustomerObject> customerList = <CustomerObject>[].obs;

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
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    _fromDateController.text = firstDayOfMonth.toIso8601String().split("T").first;
    _toDateController.text = now.toIso8601String().split("T").first;
    // // Default current date selection
    // DateTime now = DateTime.now();
    // _fromDateController.text =
    //     "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    // _toDateController.text =
    //     "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Pre-fill mobile number if passed from Dashboard
    if (widget.pickMobileNumber != null &&
        widget.pickMobileNumber!.isNotEmpty) {
      _mobileController.text = widget.pickMobileNumber!;
      searchMobile.value = widget.pickMobileNumber!.trim();
    }
    if (widget.pickName != null && widget.pickName!.isNotEmpty) {
      _nameController.text = widget.pickName!;
      searchName.value = widget.pickName!.trim();
    }
    if (widget.pickTeleNumber != null && widget.pickTeleNumber!.isNotEmpty) {
      _telephoneController.text = widget.pickTeleNumber!;
      searchTele.value = widget.pickTeleNumber!.trim();
    }

    fetchBookings();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    _dialogFocusNode.dispose();
    _nameFocusNode.dispose();
    _mobileFocusNode.dispose();
    _telephoneFocusNode.dispose();
    _filterButtonFocusNode.dispose();
    _clearButtonFocusNode.dispose();
    _fromDateFocusNode.dispose();
    _toDateFocusNode.dispose();
    super.dispose();
  }

  // ── Customer Phone Search API (Local Method)
  Future<void> getPhoneNumbersOfUsers({
    required String fieldsName,
    required String searchingText,
  }) async {
    try {
      isCustomerLoading.value = true;
      var response = await Api().get(
        "customers/search?mobile=$searchingText",
        sendCompanyId: true,
      );

      if (response != null && response.statusCode == 200) {
        final list = response.data['customer'];
        if (list != null && list is List) {
          customerList.value =
              list.map((e) => CustomerObject.fromJson(e)).toList();
        } else {
          customerList.clear();
        }
      }
    } catch (e) {
      debugPrint("Customer Search Error: $e");
      customerList.clear();
    } finally {
      isCustomerLoading.value = false;
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
        "from_date": _fromDateController.text.trim(),
        "to_date": _toDateController.text.trim(),
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
      queryParams
          .removeWhere((key, value) => value == '' || value == "MM/DD/YYYY");

      dynamic response = await Api().get(
        "bookings/pick-bookings",
        queryParameters: queryParams,
        sendCompanyId: true,
      );

      if (response != null && response.statusCode == 200) {
        _bookingModel = PickBookingModel.fromJson(response.data);
        PickBookingListAll.value = _bookingModel!.bookings ?? [];
        PickBookingfiltered.value = PickBookingListAll;
      }
    } catch (e) {
      debugPrint("API Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Trigger search on change/submit
  void onSearchBooking() {
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
    _emailController.clear();
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

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double dialogHeight = MediaQuery.of(context).size.height * 0.80;
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       insetPadding: const EdgeInsets.all(10),
//       backgroundColor: Colors.white,
//       child: Container(
//         width: screenWidth * 0.96,
//         height: dialogHeight,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
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
//                     style: _kOutfitStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF101B2E)),
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
//             // ── Top Filter Section ──
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     _buildInputWithLabel("NAME", _nameController, width: 130),
//                     const SizedBox(width: 10),
//
//                     // Obx hata diya gaya hai taake improper Obx exception na aaye
//                     SizedBox(
//                       width: 150,
//                       child: _customerAutocompleteField(
//                         'MOBILE',
//                         tab: 2,
//                         controller: _mobileController,
//                         customers: customerList, // Direct list pass karein
//                         onChanged: (q) {
//                           if (q.trim().isEmpty) return;
//                           getPhoneNumbersOfUsers(
//                             fieldsName: "Phone Number",
//                             searchingText: q,
//                           );
//                         },
//                         onPicked: (c) {
//                           setState(() {
//                             _mobileController.text = c.mobile ?? '';
//                             _nameController.text = c.name ?? '';
//                             _emailController.text = c.email ?? '';
//                             _telephoneController.text = c.telephone ?? '';
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     _buildInputWithLabel("TELEPHONE", _telephoneController, width: 130),
//                     const SizedBox(width: 10),
//                     _buildDatePickerWithLabel("FROM DATE", _fromDateController),
//                     const SizedBox(width: 10),
//                     _buildDatePickerWithLabel("TO DATE", _toDateController),
//                     const SizedBox(width: 12),
//                     _buildButton("FILTER", DynamicColors.primaryClr, Colors.white, isWide: true, onTap: onSearchBooking),
//                     const SizedBox(width: 8),
//                     _buildButton("CLEAR", Colors.grey.shade100, Colors.black87, isWide: false, onTap: _clearFilters),
//                   ],
//                 ),
//               ),
//             ),
//
//             const Divider(height: 1, color: Colors.black12),
//
//             // ── Dynamic Data Table Section
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: double.infinity,
//                   color: Colors.white,
//                   child: RawScrollbar(
//                     controller: _scrollController,
//                     thumbVisibility: true,
//                     trackVisibility: true,
//                     thumbColor: Colors.grey.shade800,
//                     trackColor: Colors.grey.shade300,
//                     thickness: 8,
//                     radius: const Radius.circular(8),
//                     child: SingleChildScrollView(
//                       controller: _scrollController,
//                       scrollDirection: Axis.vertical,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       child: SingleChildScrollView(
//                         controller: _horizontalScrollController,
//                         scrollDirection: Axis.horizontal,
//                         child: SizedBox(
//                           // Dialog screen ki full available width occupy karega
//                           width: screenWidth * 0.96 - 20,
//                           child: Obx(() => DatatableWidget(
//                             columnSpacing: 10,
//                             horizontalMargin: 8,
//                             headingRowHeight: 60,
//                             dataRowMinHeight: 50,
//                             dataRowMaxHeight: 65,
//                             columns: [
//
//                               buildHeaderWithSearch(
//                                 title: "REF #",
//
//                                 controller: _searchRefController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "DATE/TIME",
//
//                                 controller: _searchDateTimeController,
//                                 onChanged: (v) => onSearchBooking(),
//
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "VEHICLE",
//
//                                 controller: _searchVehicleController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "PICKUP",
//
//                                 controller: _searchPickupController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "DROPOFF",
//
//                                 controller: _searchDropoffController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "FARES",
//
//                                 controller: _searchFareController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "CUST",
//
//                                 controller: _searchCustomerController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "ACC",
//
//                                 controller: _searchAccountController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "DRIVER",
//
//                                 controller: _searchDriverController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "P/T",
//
//                                 controller: _searchPaymentTypeController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "STATUS",
//
//                                 controller: _searchStatusController,
//                                 onChanged: (v) => onSearchBooking(),
//                               ),
//                               buildHeaderWithSearch(
//                                 title: "ACTION",
//
//                                 removeSearching: true,
//
//                               ),
//                             ],
//                             rows: _buildTableRows(),
//                           )),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const Divider(height: 1, color: Colors.black12),
//
//             // ── Footer Section ──
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Row(
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
//   // ── Helper to render rows or Circular Loader underneath headers ──
//   List<DataRow> _buildTableRows() {
//     if (isLoading.value) {
//       return [
//         DataRow(
//           cells: List.generate(
//             12,
//                 (index) => DataCell(
//               index == 5
//                   ? const SizedBox(
//                 height: 25,
//                 width: 25,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//                   : const SizedBox.shrink(),
//             ),
//           ),
//         )
//       ];
//     }
//
//     if (PickBookingfiltered.isEmpty) {
//       return [
//         DataRow(
//           cells: List.generate(
//             12,
//                 (index) => DataCell(
//               index == 5
//                   ? Center(child: Text("No bookings found.", style: _kOutfitStyle(fontSize: 12, color: Colors.grey)))
//                   : const SizedBox.shrink(),
//             ),
//           ),
//         )
//       ];
//     }
//
//     return PickBookingfiltered.map((booking) {
//       return DataRow(
//         key: ValueKey(booking.referenceNumber ?? booking.id),
//         cells: [
//           DataCell(Center(child: _buildCellText(booking.referenceNumber ?? '', width: 90, isSmall: false))),
//           DataCell(Center(child: _buildCellText("${booking.pickupDate ?? ''}\n${booking.pickupTime ?? ''}", width: 95, isSmall: false))),
//           DataCell(Center(child: _buildCellText(booking.vehicleType?.name ?? '', width: 65))),
//           DataCell(Center(child: _buildCellText(booking.pickup ?? '', width: 180))),
//           DataCell(Center(child: _buildCellText(booking.dropoff ?? '', width: 180))),
//           DataCell(Center(child: _buildCellText("£${booking.fares ?? '0.00'}", width: 65))),
//           DataCell(Center(child: _buildCellText(booking.name ?? '', width: 100))),
//           DataCell(Center(child: _buildCellText(booking.account?.name ?? '-', width: 80))),
//           DataCell(Center(child: _buildCellText(booking.driver?.name ?? '-', width: 80))),
//           DataCell(Center(child: _buildCellText(booking.paymentType?.name ?? '', width: 70))),
//           DataCell(Center(child: _buildCellText(booking.bookingStatus?.bookingStatus ?? '', width: 80))),
//           DataCell(
//             Center(
//               child: SizedBox(
//                 width: 40,
//                 child: Center(
//                   child: TextButton(
//                     style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                     onPressed: () async {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false, // User screen tap karke dismiss na kar sake
//                         builder: (BuildContext context) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         },
//                       );
//                       try {
//                         await deshController.dashBoardDataBinding(
//                           id: booking.id,
//                           pickBooking: true,
//                         );
//                         await Future.delayed(const Duration(seconds: 1));
//                       } catch (e) {
//                         debugPrint("Error loading booking: $e");
//                       } finally {
//                         if (context.mounted) {
//                           Navigator.of(context).pop();
//                           Navigator.of(context).pop();
//                         }
//                       }
//                     },
//                     // onPressed: () {
//                     //   deshController.dashBoardDataBinding(id: booking.id,  pickBooking: true );
//                     //   Navigator.of(context).pop();
//                     // },
//                     child: Text(
//                       "PICK",
//                       style: _kOutfitStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }).toList();
//   }
//
//   // Autocomplete Field Builder
//   Widget _customerAutocompleteField(
//       String label, {
//         required int tab,
//         required TextEditingController controller,
//         required List<CustomerObject> customers,
//         required ValueChanged<CustomerObject> onPicked,
//         ValueChanged<String>? onChanged,
//         IconData? prefix,
//       }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         FocusTraversalOrder(
//           order: NumericFocusOrder(tab.toDouble()),
//           child: CustomerModelAutocomplete(
//
//             controller: controller,
//             items: customers,
//             onSelected: onPicked,
//             onChanged: onChanged,
//             decoration: _inputDecoration().copyWith(
//               label: Text(label.toUpperCase()),
//               labelStyle: _kOutfitStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
//               prefixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 0),
//               prefixIcon: prefix != null
//                   ? Padding(
//                 padding: const EdgeInsets.only(left: 8, right: 4),
//                 child: Icon(prefix, size: 15, color: Colors.grey),
//               )
//                   : null,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//  Widget _buildCellText(String text, {required double width, bool isSmall = false}) {
//     return SizedBox(
//       width: width,
//       child: Center(
//         child: Text(
//           text,
//           maxLines: 2,
//           textAlign: TextAlign.center,
//           overflow: TextOverflow.ellipsis,
//           style: _kOutfitStyle(
//             fontSize: isSmall ? 13 : 15,
//             fontWeight: FontWeight.normal,
//             color: DynamicColors.textClr,
//           ),
//         ),
//       ),
//     );
//   }
//
//  TextStyle _kOutfitStyle({double fontSize = 12, FontWeight fontWeight = FontWeight.normal, Color color = Colors.black}) {
//     return TextStyle(
//       fontFamily: 'Outfit-Regular',
//       fontSize: fontSize,
//       fontWeight: fontWeight,
//       color: color,
//     );
//   }
//
//  Widget _buildInputWithLabel(String label, TextEditingController controller, {double width = 120}) {
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
//  Widget _buildDatePickerWithLabel(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: _kOutfitStyle(fontSize: 10, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 4),
//         SizedBox(
//           width: 130,
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
//  Widget _buildButton(String text, Color bgColor, Color textColor, {bool isWide = false, VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 32,
//         padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(color: bgColor == Colors.white || bgColor == Colors.grey.shade100 ? Colors.grey.shade300 : bgColor),
//         ),
//         child: Text(
//           text,
//           style: _kOutfitStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
//         ),
//       ),
//     );
//   }
//
//  InputDecoration _inputDecoration() {
//     return InputDecoration(
//       isDense: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.grey)),
//       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFF00569A))),
//     );
//   }
//
// }

  ///............................


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxDialogHeight = MediaQuery.of(context).size.height * 0.80;

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (intent) => Navigator.of(context).pop(),
          ),
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              onSearchBooking();
              return null;
            },
          ),
        },
        child: FocusScope(
          autofocus: true,
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            insetPadding: const EdgeInsets.all(10),
            backgroundColor: Colors.white,
            child: Container(
              width: screenWidth * 0.96,
// Minimum height dynamically adapts to content; Maximum height capped at 80%
              constraints: BoxConstraints(
                maxHeight: maxDialogHeight,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Dynamic shrink-wrap effect
                children: [
// ── Title Section ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            color: Color(0xFF00569A), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          "SEARCH BOOKINGS",
                          style: _kOutfitStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF101B2E)),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.grey, size: 20),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildInputWithLabel("NAME", _nameController,
                              focusNode: _nameFocusNode, width: 130),
                          const SizedBox(width: 10),

// ── Matching Mobile Field to Name Field Style ──
                          SizedBox(
                            width: 150,
                            child: _customerAutocompleteField(
                              'MOBILE',
                              tab: 2,
                              controller: _mobileController,
                              focusNode: _mobileFocusNode,
                              customers: customerList,
                              onChanged: (q) {
                                if (q.trim().isEmpty) return;
                                getPhoneNumbersOfUsers(
                                  fieldsName: "Phone Number",
                                  searchingText: q,
                                );
                              },
                              onPicked: (c) {
                                setState(() {
                                  _mobileController.text = c.mobile ?? '';
                                  _nameController.text = c.name ?? '';
                                  _emailController.text = c.email ?? '';
                                  _telephoneController.text = c.telephone ?? '';
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildInputWithLabel(
                              "TELEPHONE", _telephoneController,
                              focusNode: _telephoneFocusNode, width: 130),
                          const SizedBox(width: 10),
                          _buildDatePickerWithLabel(
                            "FROM DATE",
                            _fromDateController,
                            focusNode: _fromDateFocusNode,
                          ),
                          const SizedBox(width: 10),
                          _buildDatePickerWithLabel(
                            "TO DATE",
                            _toDateController,
                            focusNode: _toDateFocusNode,
                          ),
                          const SizedBox(width: 12),
                          _buildButton(
                              "FILTER", DynamicColors.primaryClr, Colors.white,
                              focusNode: _filterButtonFocusNode,
                              isWide: true,
                              onTap: onSearchBooking),
                          const SizedBox(width: 8),
                          _buildButton(
                              "CLEAR", Colors.grey.shade100, Colors.black87,
                              focusNode: _clearButtonFocusNode,
                              isWide: false,
                              onTap: _clearFilters),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 1, color: Colors.black12),

// ── Dynamic Data Table Section ──
// Flexible wraps content smoothly when data is small/empty
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: RawScrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          thumbColor: Colors.grey.shade800,
                          trackColor: Colors.grey.shade300,
                          thickness: 8,
                          radius: const Radius.circular(8),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: screenWidth * 0.96 - 20,
                                child: Obx(() => DatatableWidget(
                                      columnSpacing: 10,
                                      horizontalMargin: 8,
                                      headingRowHeight: 60,
                                      dataRowMinHeight: 50,
                                      dataRowMaxHeight: 65,
                                      columns: [
                                        buildHeaderWithSearch(
                                          title: "REF #",
                                          controller: _searchRefController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "DATE/TIME",
                                          controller: _searchDateTimeController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "VEHICLE",
                                          controller: _searchVehicleController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "PICKUP",
                                          controller: _searchPickupController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "DROPOFF",
                                          controller: _searchDropoffController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "FARES",
                                          controller: _searchFareController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "CUST",
                                          controller: _searchCustomerController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "ACC",
                                          controller: _searchAccountController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "DRIVER",
                                          controller: _searchDriverController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "P/T",
                                          controller:
                                              _searchPaymentTypeController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "STATUS",
                                          controller: _searchStatusController,
                                          onChanged: (v) => onSearchBooking(),
                                        ),
                                        buildHeaderWithSearch(
                                          title: "ACTION",
                                          removeSearching: true,
                                        ),
                                      ],
                                      rows: _buildTableRows(),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Divider(height: 1, color: Colors.black12),

// ── Footer Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        _buildButton(
                            "CLOSE", Colors.grey.shade100, Colors.black87,
                            isWide: false,
                            onTap: () => Navigator.of(context).pop()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// ── Helper to render rows or Circular Loader underneath headers ──
  List<DataRow> _buildTableRows() {
    if (isLoading.value) {
      return [
        DataRow(
          cells: List.generate(
            12,
            (index) => DataCell(
              index == 5
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        )
      ];
    }

    if (PickBookingfiltered.isEmpty) {
      return [
        DataRow(
          cells: List.generate(
            12,
            (index) => DataCell(
              index == 5
                  ? Center(
                      child: Text("No bookings found.",
                          style:
                              _kOutfitStyle(fontSize: 12, color: Colors.grey)))
                  : const SizedBox.shrink(),
            ),
          ),
        )
      ];
    }

    return PickBookingfiltered.map((booking) {
      return DataRow(
        key: ValueKey(booking.referenceNumber ?? booking.id),
        cells: [
          DataCell(Center(
              child: _buildCellText(booking.referenceNumber ?? '',
                  width: 90, isSmall: false))),
          DataCell(Center(
              child: _buildCellText(
                  "${booking.pickupDate ?? ''}\n${booking.pickupTime ?? ''}",
                  width: 95,
                  isSmall: false))),
          DataCell(Center(
              child:
                  _buildCellText(booking.vehicleType?.name ?? '', width: 65))),
          DataCell(
              Center(child: _buildCellText(booking.pickup ?? '', width: 180))),
          DataCell(
              Center(child: _buildCellText(booking.dropoff ?? '', width: 180))),
          DataCell(Center(
              child: _buildCellText("£${booking.fares ?? '0.00'}", width: 65))),
          DataCell(
              Center(child: _buildCellText(booking.name ?? '', width: 100))),
          DataCell(Center(
              child: _buildCellText(booking.account?.name ?? '-', width: 80))),
          DataCell(Center(
              child: _buildCellText(booking.driver?.name ?? '-', width: 80))),
          DataCell(Center(
              child:
                  _buildCellText(booking.paymentType?.name ?? '', width: 70))),
          DataCell(Center(
              child: _buildCellText(booking.bookingStatus?.bookingStatus ?? '',
                  width: 80))),
          DataCell(
            Center(
              child: SizedBox(
                width: 40,
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      try {
                        await deshController.dashBoardDataBinding(
                          id: booking.id,
                          pickBooking: true,
                        );
                        await Future.delayed(const Duration(seconds: 1));
                      } catch (e) {
                        debugPrint("Error loading booking: $e");
                      } finally {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Text(
                      "PICK",
                      style: _kOutfitStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

// ── Autocomplete Field Builder with Focus Highlight Glow & Exact 32px Height ──
// ── Customer Autocomplete Field Wrapper ──
  Widget _customerAutocompleteField(
      String label, {
        required int tab,
        required TextEditingController controller,
        required List<CustomerObject> customers,
        required ValueChanged<CustomerObject> onPicked,
        FocusNode? focusNode,
        ValueChanged<String>? onChanged,
      }) {
    return FocusTraversalOrder(
      order: NumericFocusOrder(tab.toDouble()),
      child: SizedBox(
        width: 150,
        height: 32, // Exact outer height match karne ke liye
        child: CustomerModelAutocomplete(
          controller: controller,
          items: customers,
          focusNode: focusNode,
          onSelected: onPicked,
          onChanged: onChanged,
          decoration: _inputDecoration(label),
        ),
      ),
    );
  }

// ── Common Input Decoration (Fixes Dark Background & Height Mismatch) ──
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      isDense: false, // Extra vertical space allow karne ke liye
      hintText: hint,
      hintStyle: _kOutfitStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
      // Vertical padding badhane se andar ka white textfield vertical stretch ho jayega
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF101B2E), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF00569A), width: 1.8),
      ),
    );
  }

  Widget _buildCellText(String text,
      {required double width, bool isSmall = false}) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          text,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: _kOutfitStyle(
            fontSize: isSmall ? 13 : 15,
            fontWeight: FontWeight.normal,
            color: DynamicColors.textClr,
          ),
        ),
      ),
    );
  }

  TextStyle _kOutfitStyle(
      {double fontSize = 12,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black}) {
    return TextStyle(
      fontFamily: 'Outfit-Regular',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  Widget _buildInputWithLabel(String label, TextEditingController controller,
      {FocusNode? focusNode, double width = 120}) {
    return CustomTextField(
      borderRadius: 4,
      controller: controller,
      focusNode: focusNode,
      width: width,
      height: 32,
      hintText: label,
      columnText: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
  Widget _buildDatePickerWithLabel(
      String label,
      TextEditingController controller, {
        FocusNode? focusNode,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _kOutfitStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 130,
          height: 32,
          child: KeyboardDatePicker(
            // Static Key: dynamic text value key hata di hai taake arrow keys press karne par focus drop na ho
            key: ValueKey(label),
            focusNode: focusNode,
            initialDate: controller.text.isNotEmpty && controller.text != "MM/DD/YYYY"
                ? DateTime.tryParse(controller.text) ?? DateTime.now()
                : DateTime.now(),
            borderClr: Colors.grey.shade300,
            fontSize: 12,
            iconSize: 14,
            onChanged: (date) {
              // Text controller update bina rebuild ke
              controller.text = date.toIso8601String().split("T").first;
            },
            onSubmitted: (date) {
              controller.text = date.toIso8601String().split("T").first;
            },
          ),
        ),
      ],
    );
  }
// ── Button with Tab Focus Glow Highlight ──
  Widget _buildButton(
    String text,
    Color bgColor,
    Color textColor, {
    FocusNode? focusNode,
    bool isWide = false,
    VoidCallback? onTap,
  }) {
    return FocusableActionDetector(
      focusNode: focusNode,
      onShowFocusHighlight: (focused) {},
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) {
            if (onTap != null) onTap();
            return null;
          },
        ),
      },
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 32,
              padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isFocused
                      ? const Color(0xFF00569A)
                      : (bgColor == Colors.white ||
                              bgColor == Colors.grey.shade100
                          ? Colors.grey.shade300
                          : bgColor),
                  width: isFocused ? 2 : 1,
                ),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00569A).withOpacity(0.35),
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: Text(
                text,
                style: _kOutfitStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
          );
        },
      ),
    );
  }

// ── Input Decoration with Active Blue Focus Glow ──
//   InputDecoration _inputDecoration() {
//     return InputDecoration(
//       isDense: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(4),
//           borderSide: const BorderSide(color: Colors.grey)),
//       enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(4),
//           borderSide: BorderSide(color: Colors.grey.shade300)),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(4),
//         borderSide: const BorderSide(color: Color(0xFF00569A), width: 1.8),
//       ),
//     );
//   }
}
