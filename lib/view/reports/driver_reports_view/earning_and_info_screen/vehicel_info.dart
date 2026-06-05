//
// import 'package:dashboard_new1/component/color.dart';
// import 'package:dashboard_new1/component/textStyle.dart';
// import 'package:dashboard_new1/component/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../../controller/report_controller.dart';
//
// class VehiclesScreen extends StatelessWidget {
//   final String driverName;
//   const VehiclesScreen({super.key, required this.driverName});
//
//   @override
//   Widget build(BuildContext context) {
//     ReportController controller = Get.isRegistered<ReportController>()
//         ? Get.find<ReportController>()
//         : Get.put(ReportController());
//
//     final driver = controller.selectDriverObject;
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Center(
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: double.infinity),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.green, width: 2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// HEADER (Image Section)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: SizedBox(
//                       width: 300,
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 350,
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade200,
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.grey.shade400),
//                             ),
//                             child: (driver?.image != null && driver!.image!.isNotEmpty)
//                                 ? ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.network(
//                                 driver.image!,
//                                 alignment: Alignment.topCenter,
//                                 fit: BoxFit.fill,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     Center(child: Text(AppText.upload_image, textAlign: TextAlign.center)),
//                               ),
//                             )
//                                 : Center(
//                               child: Text(
//                                 AppText.upload_image,
//                                 style: mozillaTextSemiBoldText(fontSize: 14),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   /// RIGHT DETAILS SECTION
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Wrap(
//                           children: [
//                             Text(
//                               driver?.name?.toUpperCase() ?? "",
//                               style: mozillaTextSemiBoldText(fontSize: 18),
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               (driver?.driverStatus ?? "").toString().toUpperCase(),
//                               style: mozillaTextSemiBoldText(
//                                 color: (() {
//                                   final status = (driver?.driverStatus ?? "").toString().toLowerCase().trim();
//
//                                   if (status == "available" || status == "login" || status == "avail") {
//                                     return Colors.green;
//                                   } else if (status == "unavailable" || status == "logged_out" || status == "unavail") {
//                                     return DynamicColors.redClr;
//                                   }
//                                   if (status.contains("unavail")) {
//                                     return DynamicColors.redClr;
//                                   } else if (status.contains("avail")) {
//                                     return Colors.green;
//                                   }
//
//                                   return Colors.grey;
//                                 })(),
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 10),
//
//                         /// VEHICLE INFO
//                         Text(
//                           AppText.vehicleinfo,
//                           style: mozillaTextRegularText(fontSize: 16),
//                         ),
//                         const SizedBox(height: 15),
//
//                         Wrap(
//                           spacing: 20,
//                           runSpacing: 10,
//                           alignment: WrapAlignment.center,
//                           children: [
//                             _infoTileWithoutExpanded(AppText.vehicle, driver?.vehicle?.vehicleNumber ?? "-"),
//                             _infoTileWithoutExpanded(AppText.startDate, driver?.startDate ?? "-"),
//                             _infoTileWithoutExpanded(AppText.vehicleType, driver?.vehicle?.vehicleType?.name.toString() ?? "SALOON"),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Wrap(
//                           spacing: 20,
//                           runSpacing: 10,
//                           alignment: WrapAlignment.center,
//                           children: [
//                             _infoTileWithoutExpanded(AppText.make, driver?.vehicle?.make ?? "-"),
//                             _infoTileWithoutExpanded(AppText.model, driver?.vehicle?.model ?? "-"),
//                             _infoTileWithoutExpanded(AppText.color, driver?.vehicle?.color ?? "-"),
//                           ],
//                         ),
//                         const SizedBox(height: 15),
//
//                         /// DOCUMENTS SECTION
//                         Text(
//                           AppText.documents,
//                           style: mozillaTextSemiBoldText(),
//                         ),
//                         const SizedBox(height: 6),
//                         const Text(
//                           "EXPIRY",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         const SizedBox(height: 6),
//                         const Divider(indent: 20, endIndent: 20),
//                         const SizedBox(height: 6),
//
//                         /// DOCUMENTS EXPIRY LINE
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Expanded(child: _infoTile(AppText.phcdriver, driver?.phcDriverExpiry ?? "00-00-0000")),
//                               const SizedBox(width: 5),
//                               Expanded(child: _infoTile(AppText.phcvehicle, driver?.phcVehicleExpiry ?? "00-00-0000")),
//                               const SizedBox(width: 5),
//                               Expanded(child: _infoTile(AppText.insurance, driver?.insuranceExpiry ?? "00-00-0000")),
//                               Expanded(child: _infoTile(AppText.mot2, driver?.mot2Expiry ?? "00-00-0000")),
//                               Expanded(child: _infoTile(AppText.mot, driver?.motExpiry ?? "00-00-0000")),
//                             ],
//                           ),
//                         ),
//
//                         const SizedBox(height: 15),
//
//                         Text(AppText.document_hash, style: mozillaTextRegularText(fontSize: 15)),
//                         const Divider(indent: 20, endIndent: 20),
//                         const SizedBox(height: 6),
//
//                         /// DOCUMENT NUMBERS LINE
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Expanded(child: _infoTile(AppText.phcdriver, driver?.phcDriverNumber ?? "N/A")),
//                               const SizedBox(width: 5),
//                               Expanded(child: _infoTile(AppText.phcvehicle, driver?.phcVehicleNumber ?? "N/A")),
//                               const SizedBox(width: 5),
//                               Expanded(child: _infoTile(AppText.insurance, driver?.insuranceNumber ?? "N/A")),
//                               Expanded(child: _infoTile(AppText.mot2, driver?.mot2Number ?? "N/A")),
//                               Expanded(child: _infoTile(AppText.mot, driver?.motNumber ?? "N/A")),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 25),
//
//               /// FOOTER
//               Obx(() {
//                 final selectedId = controller.selectDriverObject?.id;
//                 final specificDriverData = controller.earningInfoListModel?.data?.drivers?.firstWhereOrNull(
//                         (d) => d.driverId == selectedId
//                 );
//
//                 return Container(
//                   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//                   color: Colors.grey.shade100,
//                   child: Wrap(
//                     spacing: 40,
//                     runSpacing: 10,
//                     alignment: WrapAlignment.start,
//                     children: [
//                       _footerInfo(
//                           Icons.money,
//                           AppText.totalamount,
//                           "£ ${specificDriverData?.totalEarnings ?? '0.00'}"
//                       ),
//                       _footerInfo(
//                           Icons.directions_car,
//                           AppText.totalBookings,
//                           "${specificDriverData?.totalBookings ?? '0'}"
//                       ),
//                       _footerInfo(
//                           Icons.calendar_today,
//                           AppText.period,
//                           "${controller.fromDate.value != null ? DateFormat('dd-MM-yy').format(controller.fromDate.value!) : 'N/A'} - ${controller.toDate.value != null ? DateFormat('dd-MM-yy').format(controller.toDate.value!) : 'N/A'}"
//                       ),
//                     ],
//                   ),
//                 );
//               })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _infoTile(String title, String value) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Text(
//             title,
//             style: mozillaTextRegularText(fontSize: 11),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const SizedBox(height: 2),
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Text(
//             value,
//             style: mozillaTextSemiBoldText(fontSize: 12),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
//   Widget _infoTileWithoutExpanded(String title, String value) {
//     return SizedBox(
//       width: 80,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(
//               title,
//               style: mozillaTextRegularText(fontSize: 11),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(
//               value,
//               style: mozillaTextSemiBoldText(fontSize: 12),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _footerInfo(IconData icon, String title, String value) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 18, color: Colors.black54),
//         const SizedBox(width: 5),
//         Text("$title: ", style: mozillaTextSemiBoldText(fontSize: 13)),
//         Text(value, style: mozillaTextRegularText(fontSize: 12)),
//       ],
//     );
//   }
// }