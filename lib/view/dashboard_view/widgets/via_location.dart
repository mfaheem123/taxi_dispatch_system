import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../Model/via_point.dart';
import '../../../component/alert_close_button.dart';
import '../../../component/escape_dismissible.dart';
import '../../../component/text_field.dart';
import '../models/all_addresses_model.dart';

const _kFontFamily = 'Outfit-Regular';

class ViaTextEditingControllerClass {
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  ViaTextEditingControllerClass(this.name, this.mobile);
}

class ViaLocation extends StatefulWidget {
  const ViaLocation({super.key, this.formController});

  /// The booking form this dialog edits the via points of.
  ///
  /// A dialog is its own route, so it is NOT under the opening screen's
  /// [BookingFormScope] and cannot read the form off its context. Screens that
  /// run a detached form of their own — the edit screen — therefore pass their
  /// instance in at the call site. Left null it falls back to the dashboard's
  /// permanent instance, which is what every dashboard-side caller wants.
  final DashboardController? formController;

  @override
  State<ViaLocation> createState() => _ViaLocationState();
}

class _ViaLocationState extends State<ViaLocation> {

//   final TextEditingController addressController = TextEditingController();
//
//   FocusNode textFieldFocusNode = FocusNode();
//   FocusNode searchFocusNode = FocusNode();
//   Timer? _debounce;
//
//   /// This dialog's form: the caller's instance, or the dashboard's.
//   late final DashboardController _controller =
//       widget.formController ?? Get.find<DashboardController>();
//
//   // CHANGE INFO: Dialog ke persistent scrollbar ko properly render aur manage karne ke liye explicit controller banaya gaya hai.
//   final ScrollController _viaDialogScrollController = ScrollController();
//
//
//   @override
//   void dispose() {
//     // CHANGE INFO: Memory leaks se bachne ke liye _viaDialogScrollController ko dispose routine me add kiya gaya hai.
//     _viaDialogScrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Dialog(
//       insetPadding: EdgeInsets.all(20),
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: GetBuilder<DashboardController>(
//           // The form this dialog was opened for, not whichever instance is
//           // registered untagged — a detached form keeps its via points on its
//           // own instance, so an untagged lookup read an empty list.
//           tag: _controller.formTag,
//           builder: (controller) {
//             return SizedBox(
//               height: 400,
//               width: 650,
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     // CHANGE INFO: Pure Dialog wrapper me se 'SingleChildScrollView' ko hata kar yahan static Column lagaya taake header aur search input fields upar hi fix rahein aur look clean ho jaye.
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // --- FIXED HEADER SECTION ---
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "VIA POINT(S)",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.close),
//                               onPressed: () {
//                                 controller.viaMilsCondition = false;
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // --- FIXED INPUT & ADD BUTTON SECTION ---
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(top: 10),
//                               child: Text(
//                                 "#",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 22),
//                               ),
//                             ),
//
//                             SizedBox(width: 12),
//
//                             RawKeyboardListener(
//                               focusNode: controller.searchingAddressViaFocusNode,
//                               onKey: (event) {
//                                 if (event is RawKeyDownEvent) {
//                                   if (event.logicalKey ==
//                                       LogicalKeyboardKey.arrowDown &&
//                                       controller.highlightedIndex.value <
//                                           controller.suggestions.length -
//                                               1) {
//                                     controller.highlightedIndex.value++;
//                                   } else if (event.logicalKey ==
//                                       LogicalKeyboardKey.arrowUp &&
//                                       controller.highlightedIndex.value >
//                                           0) {
//                                     controller.highlightedIndex.value--;
//                                   } else if (event.logicalKey ==
//                                       LogicalKeyboardKey.enter) {
//                                     final selected = controller.suggestions[controller.highlightedIndex.value].name;
//                                     controller.selectSuggestion(selected);
//                                   }else if(event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.tab){
//                                     FocusScope.of(Get.context!).requestFocus(controller.viaFocusNode);
//                                   }
//                                 }
//                               },
//
//                               child: SizedBox(
//                                 width: Get.width/4,
//                                 child: TextField(
//                                     focusNode: controller.viaFieldFocusNode,
//                                     controller: addressController,
//                                     onTap: (){
//                                       if(controller.selectedTextFieldsValue.value != "via"){
//                                         controller.selectedTextFieldsValue.value = "via";
//                                       }
//                                     },
//                                     onChanged: (v){
//                                       controller.onChangeHandler(
//                                           fieldName:
//                                           "via",
//                                           searchingText: v);
//                                     },
//
//                                     decoration: InputDecoration(
//                                       hintText: "Search Address",
//                                       border: OutlineInputBorder(),
//                                       isDense: true,
//                                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                                     )),
//                               ),
//                             ),
//
//                             SizedBox(width: 12),
//
//                             SizedBox(
//                               width: 30,
//                               height: 30,
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   bool isViaWithReturn = !controller.viaSelectionOneWay.value;
//                                   String currentTypeName = isViaWithReturn ? 'via with return' : 'via';
//
//                                   int currentTypeCount = controller.viaPoints.where((p) => p.withReturnWay == currentTypeName).length;
//
//                                   if (currentTypeCount < 6) {
//                                     controller.polylinePoints.add(
//                                       LatLng(controller.selectedModel!.lat!, controller.selectedModel!.lon!),
//                                     );
//                                     controller.viaPoints.add(ViaPoint(
//                                       withReturnWay: currentTypeName,
//                                       address: controller.selectedModel!.name!,
//                                       lat: controller.selectedModel!.lat!,
//                                       lng: controller.selectedModel!.lon!,
//                                     ));
//
//                                     addressController.clear();
//                                     controller.viaTextEditingController.add(
//                                         ViaTextEditingControllerClass(TextEditingController(), TextEditingController())
//                                     );
//                                     controller.update();
//                                   } else {
//                                     BotToast.showText(text: "Maximum 6 of '$currentTypeName' allowed");
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   padding: EdgeInsets.zero,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                                 child: Icon(Icons.add, color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         SizedBox(height: 16),
//
//                         // --- SCROLLABLE CONTAINER AREA WITH VISIBLE DESKTOP SCROLLBAR ---
//                         // CHANGE INFO: 'Expanded' widget ka use kar ke central space ko dynamic kiya aur andeone content par modern desktop style Custom Theme and Scrollbar implement kiya.
//                         Expanded(
//                           child: Theme(
//                             data: Theme.of(context).copyWith(
//                               scrollbarTheme: ScrollbarThemeData(
//                                 thumbColor: MaterialStateProperty.all(Colors.grey[400]), // Modern grey color for the handler
//                                 trackColor: MaterialStateProperty.all(Colors.grey[100]), // Visible light track line background
//                                 trackBorderColor: MaterialStateProperty.all(Colors.transparent),
//                                 radius: Radius.circular(8), // Perfectly circular track border edges
//                                 thickness: MaterialStateProperty.all(8), // Standard prominent thickness level for clear desktop visibility
//                               ),
//                             ),
//                             child: Scrollbar(
//                               controller: _viaDialogScrollController,
//                               thumbVisibility: true, // Permanent visibility constraint applied
//                               trackVisibility: true, // Show navigation path line
//                               interactive: true,   // Allow direct mouse drag interaction
//                               child: SingleChildScrollView(
//                                 controller: _viaDialogScrollController,
//                                 padding: EdgeInsets.only(right: 14), // CHANGE INFO: Right padding barhai taake dynamic textfields scroller thumb ke piche hide na hon
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     // --- LEFT COLUMN (O/W) ---
//                                     SizedBox(
//                                       // CHANGE INFO: Width ko slightly modify kiya (600->580, 280->265) taake newly embedded right scrollbar layout ko overlap na kare aur padding balanced rhey.
//                                       width: controller.jourValue != 'R/N'? 580 : 265,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Visibility(
//                                             visible: controller.jourValue != 'R/N'?false:true,
//                                             child: Row(
//                                               children: [
//                                                 Text("O/W"),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 SizedBox(
//                                                   width: 70,
//                                                   height: 25,
//                                                   child: ElevatedButton(
//                                                     onPressed: () {
//                                                       controller.viaSelectionOneWay.value = !controller.viaSelectionOneWay.value;
//                                                       controller.update();
//                                                     },
//                                                     style: ElevatedButton.styleFrom(
//                                                       backgroundColor: controller.viaSelectionOneWay.value?DynamicColors.primaryClr :
//                                                       DynamicColors.primaryClr.withOpacity(0.2),
//                                                       padding: EdgeInsets.zero,
//                                                       shape: RoundedRectangleBorder(
//                                                         borderRadius: BorderRadius.circular(4),
//                                                       ),
//                                                     ),
//                                                     child: Text("O/W",
//                                                       style: TextStyle(
//                                                           color: DynamicColors.whiteClr
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//
//                                           ListView.builder(
//                                               itemCount: controller.viaPoints.length,
//                                               shrinkWrap: true,
//                                               physics: NeverScrollableScrollPhysics(),
//                                               itemBuilder: (context, index) {
//                                                 final point = controller.viaPoints[index];
//                                                 return point.withReturnWay =="via"? Padding(
//                                                   padding: EdgeInsets.symmetric(vertical: 10),
//                                                   child: Row(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Text(
//                                                         '${index + 1}',
//                                                         style: TextStyle(fontWeight: FontWeight.bold),
//                                                       ),
//                                                       SizedBox(width: 12),
//                                                       Expanded(
//                                                           child: Column(
//                                                             children: [
//                                                               SizedBox(
//                                                                 height: 35,
//                                                                 child: TextField(
//                                                                   style: TextStyle(fontSize: 13),
//                                                                   readOnly: true,
//                                                                   controller: TextEditingController(text: point.address),
//                                                                   decoration: InputDecoration(
//                                                                     contentPadding: EdgeInsets.zero,
//                                                                     border: OutlineInputBorder(),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(height: 10),
//                                                               Row(
//                                                                 children: [
//                                                                   Expanded(
//                                                                       child: SizedBox(
//                                                                         height: 35,
//                                                                         child: TextField(
//                                                                           style: TextStyle(fontSize: 13),
//                                                                           controller: controller.viaTextEditingController[index].name,
//                                                                           decoration: InputDecoration(
//                                                                             contentPadding: EdgeInsets.zero,
//                                                                             hintText: "Name",
//                                                                             border: OutlineInputBorder(),
//                                                                           ),
//                                                                         ),
//                                                                       )),
//                                                                   SizedBox(width: 8),
//                                                                   Expanded(
//                                                                       child: SizedBox(
//                                                                         height: 35,
//                                                                         child: TextField(
//
//                                                                           style: TextStyle(fontSize: 13),
//                                                                           controller: controller.viaTextEditingController[index].mobile,
//                                                                           decoration: InputDecoration(
//
//                                                                             contentPadding: EdgeInsets.zero,
//                                                                             hintText: "Mobile",
//                                                                             border: OutlineInputBorder(),
//                                                                           ),
//                                                                         ),
//                                                                       )),
//                                                                 ],
//                                                               ),
//                                                             ],
//                                                           )),
//
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(left: 12.0, top: 8),
//                                                         child: SizedBox(
//                                                           width: 30,
//                                                           height: 30,
//                                                           child: ElevatedButton(
//                                                             onPressed: () {
//                                                               setState(() {
//                                                                 controller.viaPoints.removeAt(index);
//                                                                 controller.update();
//                                                               });
//                                                             },
//
//                                                             style: ElevatedButton.styleFrom(
//                                                               backgroundColor: Colors.red,
//                                                               padding: EdgeInsets.zero,
//                                                               shape: RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius.circular(4),
//                                                               ),
//                                                             ),
//                                                             child: Icon(Icons.delete, color: Colors.white, size: 20),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ):SizedBox.shrink();
//                                               }),
//                                         ],
//                                       ),
//                                     ),
//
//                                     // --- RIGHT COLUMN (R/N) ---
//                                     Visibility(
//                                       visible:
//                                       controller.pickupTwoWayController.text.isNotEmpty &&
//                                           controller.jourValue == 'R/N'  ?true:false,
//                                       child: SizedBox(
//                                         // CHANGE INFO: Width adjust ki taake space management dynamic rhey.
//                                         width: 265,
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text("R/N"),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 SizedBox(
//                                                   width: 70,
//                                                   height: 25,
//                                                   child: ElevatedButton(
//                                                     onPressed: () {
//                                                       controller.viaSelectionOneWay.value = !controller.viaSelectionOneWay.value;
//                                                       controller.update();
//                                                     },
//                                                     style: ElevatedButton.styleFrom(
//                                                       backgroundColor: controller.viaSelectionOneWay.value
//                                                           ?
//                                                       DynamicColors.primaryClr.withOpacity(0.2):DynamicColors.primaryClr,
//                                                       padding: EdgeInsets.zero,
//                                                       shape: RoundedRectangleBorder(
//                                                         borderRadius: BorderRadius.circular(4),
//                                                       ),
//                                                     ),
//                                                     child: Text("R/N",
//                                                       style: TextStyle(
//                                                           color: DynamicColors.whiteClr
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//
//                                             ListView.builder(
//                                                 itemCount: controller.viaPoints.length,
//                                                 shrinkWrap: true,
//                                                 physics: NeverScrollableScrollPhysics(),
//                                                 itemBuilder: (context, index) {
//                                                   final point = controller.viaPoints[index];
//                                                   return point.withReturnWay =="via"?SizedBox.shrink():  Padding(
//                                                     padding: EdgeInsets.symmetric(vertical: 10),
//                                                     child: Row(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Text(
//                                                           '${index + 1}',
//                                                           style: TextStyle(fontWeight: FontWeight.bold),
//                                                         ),
//                                                         SizedBox(width: 12),
//                                                         Expanded(
//                                                             child: Column(
//                                                               children: [
//                                                                 SizedBox(
//                                                                   height: 35,
//                                                                   child: TextField(
//                                                                     readOnly: true,
//                                                                     style: TextStyle(fontSize: 13),
//                                                                     controller: TextEditingController(text: point.address),
//                                                                     decoration: InputDecoration(
//                                                                       contentPadding: EdgeInsets.zero,
//                                                                       border: OutlineInputBorder(),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: 10),
//                                                                 Row(
//                                                                   children: [
//                                                                     Expanded(
//                                                                         child: SizedBox(
//                                                                           height: 35,
//                                                                           child: TextField(
//                                                                             style: TextStyle(fontSize: 13),
//                                                                             controller: controller.viaTextEditingController[index].name,
//                                                                             decoration: InputDecoration(
//                                                                               contentPadding: EdgeInsets.zero,
//                                                                               hintText: "Name",
//                                                                               border: OutlineInputBorder(),
//                                                                             ),
//                                                                           ),
//                                                                         )),
//                                                                     SizedBox(width: 8),
//                                                                     Expanded(
//                                                                         child: SizedBox(
//                                                                           height: 35,
//                                                                           child: TextField(
//                                                                             style: TextStyle(fontSize: 13),
//                                                                             controller: controller.viaTextEditingController[index].mobile,
//                                                                             decoration: InputDecoration(
//                                                                               contentPadding: EdgeInsets.zero,
//                                                                               hintText: "Mobile",
//                                                                               border: OutlineInputBorder(),
//                                                                             ),
//                                                                           ),
//                                                                         )),
//                                                                   ],
//                                                                 ),
//                                                               ],
//                                                             )),
//
//                                                         Padding(
//                                                           padding: const EdgeInsets.only(left: 12.0, top: 8),
//                                                           child: SizedBox(
//                                                             width: 30,
//                                                             height: 30,
//                                                             child: ElevatedButton(
//                                                               onPressed: () {
//                                                                 setState(() {
//                                                                   controller.viaPoints.removeAt(index);
//                                                                   controller.update();
//                                                                 });
//                                                               },
//                                                               style: ElevatedButton.styleFrom(
//                                                                 backgroundColor: Colors.red,
//                                                                 padding: EdgeInsets.zero,
//                                                                 shape: RoundedRectangleBorder(
//                                                                   borderRadius: BorderRadius.circular(4),
//                                                                 ),
//                                                               ),
//                                                               child: Icon(Icons.delete, color: Colors.white, size: 20),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   );
//                                                 }),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: 20),
//
//                         // --- FIXED ACTION BUTTONS ---
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               style: TextButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 padding:
//                                 EdgeInsets.symmetric(horizontal: 15, vertical: 14),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4)),
//                               ),
//                               onPressed: () {
//                                 controller.viaMilsCondition = false;
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//
//                             SizedBox(width: 10),
//
//                             TextButton(
//                               style: TextButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 padding:
//                                 EdgeInsets.symmetric(horizontal: 15, vertical: 14),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4)),
//                               ),
//                               onPressed: () {
//                                 controller.viaMilsCondition = true;
//                                 int len = controller.viaPoints.length;
//                                 for (int a = 0; a < len && a < controller.viaTextEditingController.length; a++) {
//                                   controller.viaPoints[a].name = controller.viaTextEditingController[a].name.text;
//                                   controller.viaPoints[a].mobile = controller.viaTextEditingController[a].mobile.text;
//                                 }
//                                 controller.fetchRouteFromOSRM();
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 " Save ",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//
//                     // --- SUGGESTION OVERLAY BOX (UNCHANGED ORIGINAL LOGIC) ---
//                     Obx(() {
//                       if (controller.selectedTextFieldsValue.value != "via") {
//                         return SizedBox.shrink();
//                       }
//                       if (controller.allAddressesData.isEmpty) {
//                         return SizedBox.shrink();
//                       }
//                       final GlobalKey<State<StatefulWidget>>? activeKey = controller.activeFieldKey.value;
//                       final RenderBox? fieldBox = activeKey?.currentContext?.findRenderObject() as RenderBox?;
//                       final RenderBox? stackBox = controller.stackKey.currentContext?.findRenderObject() as RenderBox?;
//                       double top = 0.0;
//                       double left = 0.0;
//                       double width = Get.width/4;
//                       if (fieldBox != null && stackBox != null) {
//                         final Offset localOffset = fieldBox.localToGlobal(Offset.zero, ancestor: stackBox);
//                         final double fieldHeight = fieldBox.size.height;
//                         width = fieldBox.size.width;
//                         top = localOffset.dy + fieldHeight;
//                         left = localOffset.dx;
//                       }
//                       WidgetsBinding.instance.addPostFrameCallback((_) {});
//                       return Positioned(
//                         top: 100,
//                         left: left,
//                         width: Get.width/4,
//                         child: RawKeyboardListener(
//                           focusNode: controller.viaFocusNode,
//                           autofocus: true,
//                           onKey: (RawKeyEvent event) {
//                             if (event is RawKeyDownEvent) {
//                               if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
//                                 controller.moveHighlightDown(viaConditionValue: false);
//                                 return;
//                               } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
//                                 controller.moveHighlightUp(viaConditionValue: false);
//                                 return;
//                               } else if (event.logicalKey == LogicalKeyboardKey.enter){
//                                 controller.selectedModel = controller.allAddressesData[controller.suggestionSelectedIndex.value];
//                                 addressController.text = "${controller.allAddressesData[controller.suggestionSelectedIndex.value].name} ${controller.allAddressesData[controller.suggestionSelectedIndex.value].postcode}";
//                                 controller.allAddressesData.clear();
//                                 controller.update();
//                                 print("enter press");
//                               }
//                             }
//                           },
//                           child: Container(
//                             height: screenHeight * 0.3,
//                             width: Get.width/4,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFEFF0F2),
//                               borderRadius: BorderRadius.circular(5),
//                               boxShadow: const [
//                                 BoxShadow(
//                                     color: Colors.black12,
//                                     blurRadius: 5,
//                                     offset: Offset(0, 2)),
//                               ],
//                             ),
//                             child: Obx(() => ListView.builder(
//                               key: controller.suggestionListKey,
//                               controller: controller.suggestionScrollController,
//                               itemCount: controller.allAddressesData.length,
//                               padding: EdgeInsets.only(top: 15),
//                               itemBuilder: (context, index) {
//                                 final item = controller.allAddressesData[index];
//                                 return Obx(
//                                       () {
//                                     final isHighlighted = controller.highlightedIndex.value == index;
//                                     return Container(
//                                       key: controller.suggestionItemKeys[index],
//                                       color: isHighlighted ? const Color(0xffA0DCFF) : Colors.transparent,
//                                       child: ListTile(
//                                           dense: true,
//                                           visualDensity: VisualDensity.compact,
//                                           title: AnimatedDefaultTextStyle(
//                                             duration: const Duration(milliseconds: 120),
//                                             style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
//                                               color: isHighlighted ? Colors.blue : Colors.black,
//                                             ),
//                                             child: Text("${item.name} ${item.postcode}"),
//                                           ),
//                                           onTap: (){
//                                             controller.selectedModel = item;
//                                             addressController.text = "${item.name} ${item.postcode}";
//                                             controller.allAddressesData.clear();
//                                             controller.update();
//                                           }
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             )),
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             );
//           }
//       ),
//     );
//   }
// }

  final TextEditingController outboundAddressController = TextEditingController();
  final TextEditingController returnAddressController = TextEditingController();

  final FocusNode outboundFocusNode = FocusNode();
  final FocusNode returnFocusNode = FocusNode();

  final GlobalKey outboundKey = GlobalKey();
  final GlobalKey returnKey = GlobalKey();

  late final DashboardController _controller =
      widget.formController ?? Get.find<DashboardController>();

  final ScrollController _viaDialogScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.allAddressesData.clear();
      _controller.selectedModel = null;
      _controller.selectedTextFieldsValue.value = "";
      _controller.activeFieldKey.value = null;
    });
  }

  @override
  void dispose() {
    _viaDialogScrollController.dispose();
    outboundAddressController.dispose();
    returnAddressController.dispose();
    super.dispose();
  }

  void _addViaPoint({required bool isReturnWay, required TextEditingController addressCtrl}) {
    String currentTypeName = isReturnWay ? 'via with return' : 'via';
    int currentTypeCount = _controller.viaPoints.where((p) => p.withReturnWay == currentTypeName).length;

    if (currentTypeCount < 6) {
      if (_controller.selectedModel != null) {
        _controller.polylinePoints.add(
          LatLng(_controller.selectedModel!.lat!, _controller.selectedModel!.lon!),
        );
        _controller.viaPoints.add(ViaPoint(
          withReturnWay: currentTypeName,
          address: _controller.selectedModel!.name!,
          lat: _controller.selectedModel!.lat!,
          lng: _controller.selectedModel!.lon!,
        ));

        addressCtrl.clear();
        _controller.selectedModel = null;
        _controller.allAddressesData.clear();
        _controller.selectedTextFieldsValue.value = "";

        _controller.viaTextEditingController.add(
          ViaTextEditingControllerClass(TextEditingController(), TextEditingController()),
        );
        _controller.update();
      } else {
        BotToast.showText(text: "PLEASE SELECT AN ADDRESS FROM SUGGESTION LIST FIRST");
      }
    } else {
      BotToast.showText(text: "MAXIMUM 6 OF '$currentTypeName' ALLOWED");
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return EscapeDismissible(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: GetBuilder<DashboardController>(
          tag: _controller.formTag,
          builder: (controller) {
            final bool isReturnJourney = controller.jourValue == 'R/N';

            return Container(
              key: controller.stackKey,
              width: isReturnJourney ? 850 : 550,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          color: DynamicColors.gryClr.withOpacity(0.5),
                          child: Row(
                            children: [
                              Icon(Icons.route, color: DynamicColors.primaryClr),
                              const SizedBox(width: 10),
                              Text("VIAPOINT(S) MANAGEMENT",
                                  style: TextStyle(fontFamily: _kFontFamily, fontWeight: FontWeight.bold, fontSize: 18)),
                              const Spacer(),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(999),
                                child: const AlertCloseButton(),
                              ),
                            ],
                          )),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
                              child: SingleChildScrollView(
                                controller: _viaDialogScrollController,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // OUTBOUND TRIP
                                    Expanded(
                                      child: _buildTripColumn(
                                        title: "OUTBOUND TRIP",
                                        addressCtrl: outboundAddressController,
                                        focusNode: outboundFocusNode,
                                        fieldKey: outboundKey,
                                        isReturnSection: false,
                                        controller: controller,
                                      ),
                                    ),

                                    // RETURN TRIP
                                    if (isReturnJourney) ...[
                                      const SizedBox(width: 16),
                                      Container(width: 1, color: Colors.grey.shade300),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildTripColumn(
                                          title: "RETURN TRIP",
                                          addressCtrl: returnAddressController,
                                          focusNode: returnFocusNode,
                                          fieldKey: returnKey,
                                          isReturnSection: true,
                                          controller: controller,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            Divider(),
                            SizedBox(height: 12),
                            //  ACTION BUTTONS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onPressed: () {
                                      controller.viaMilsCondition = false;
                                      Navigator.pop(context);
                                    },
                                    child: const Text("CANCEL", style: TextStyle(fontFamily: _kFontFamily, color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 30,
                                  child: TextButton.icon(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF4CAF50),
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onPressed: () {
                                      controller.viaMilsCondition = true;
                                      int len = controller.viaPoints.length;
                                      for (int a = 0; a < len && a < controller.viaTextEditingController.length; a++) {
                                        controller.viaPoints[a].name = controller.viaTextEditingController[a].name.text;
                                        controller.viaPoints[a].mobile = controller.viaTextEditingController[a].mobile.text;
                                      }
                                      controller.fetchRouteFromOSRM();
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check, color: Colors.white, size: 18),
                                    label: const Text("APPLY CHANGES", style: TextStyle(fontFamily: _kFontFamily, color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // --- SUGGESTIONS OVERLAY ---
                  Obx(() {
                    if (controller.selectedTextFieldsValue.value != "via") {
                      return const SizedBox.shrink();
                    }
                    if (controller.allAddressesData.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final GlobalKey<State<StatefulWidget>>? activeKey = controller.activeFieldKey.value;
                    final RenderBox? fieldBox = activeKey?.currentContext?.findRenderObject() as RenderBox?;
                    final RenderBox? stackBox = controller.stackKey.currentContext?.findRenderObject() as RenderBox?;
                    double top = 100.0;
                    double left = 0.0;
                    double width = Get.width / 4;

                    if (fieldBox != null && stackBox != null) {
                      final Offset localOffset = fieldBox.localToGlobal(Offset.zero, ancestor: stackBox);
                      width = fieldBox.size.width;
                      top = localOffset.dy + fieldBox.size.height;
                      left = localOffset.dx;
                    }

                    final activeAddressController = (activeKey == returnKey)
                        ? returnAddressController
                        : outboundAddressController;

                    return Positioned(
                      top: top,
                      left: left,
                      width: width,
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        autofocus: true,
                        onKeyEvent: (KeyEvent event) {
                          if (event is KeyDownEvent) {
                            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                              controller.moveHighlightDown(viaConditionValue: false);
                            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                              controller.moveHighlightUp(viaConditionValue: false);
                            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                              final selected = controller.allAddressesData[controller.suggestionSelectedIndex.value];
                              controller.selectedModel = selected;
                              activeAddressController.text = "${selected.name} ${selected.postcode}".toUpperCase();

                              controller.allAddressesData.clear();
                              controller.update();
                            }
                          }
                        },
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFEFF0F2),
                          child: SizedBox(
                            height: screenHeight * 0.3,
                            child: Obx(() => ListView.builder(
                              key: controller.suggestionListKey,
                              controller: controller.suggestionScrollController,
                              itemCount: controller.allAddressesData.length,
                              padding: const EdgeInsets.only(top: 5),
                              itemBuilder: (context, index) {
                                final item = controller.allAddressesData[index];
                                return Obx(() {
                                  final isHighlighted = controller.highlightedIndex.value == index;
                                  return Material(
                                    key: controller.suggestionItemKeys[index],
                                    color: isHighlighted ? const Color(0xffA0DCFF) : Colors.transparent,
                                    child: ListTile(
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      title: Text(
                                        "${item.name} ${item.postcode}".toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: _kFontFamily,
                                          fontSize: 12,
                                          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                          color: isHighlighted ? Colors.blue : Colors.black,
                                        ),
                                      ),
                                      onTap: () {
                                        controller.selectedModel = item;
                                        activeAddressController.text = "${item.name} ${item.postcode}".toUpperCase();
                                        controller.allAddressesData.clear();
                                        controller.selectedTextFieldsValue.value = "";
                                        controller.update();
                                      },
                                    ),
                                  );
                                });
                              },
                            )),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildTripColumn({
    required String title,
    required TextEditingController addressCtrl,
    required bool isReturnSection,
    required DashboardController controller, required FocusNode focusNode, required GlobalKey<State<StatefulWidget>> fieldKey,
  }) {
    final String targetType = isReturnSection ? 'via with return' : 'via';
    final filteredList = controller.viaPoints.where((p) => p.withReturnWay == targetType).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontFamily: _kFontFamily, fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            children: [
              // TABLE HEADER
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 32,
                        child: Center(
                          child: Text("#", style: TextStyle(fontFamily: _kFontFamily, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                      Container(width: 1, color: const Color(0xFFCBD5E1)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: RawKeyboardListener(
                            focusNode: controller.searchingAddressViaFocusNode,
                            onKey: (event) {
                              if (event is RawKeyDownEvent) {
                                if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                                    controller.highlightedIndex.value < controller.suggestions.length - 1) {
                                  controller.highlightedIndex.value++;
                                } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                                    controller.highlightedIndex.value > 0) {
                                  controller.highlightedIndex.value--;
                                } else if (event.logicalKey == LogicalKeyboardKey.enter &&
                                    controller.suggestions.isNotEmpty) {
                                  final selected = controller.suggestions[controller.highlightedIndex.value].name;
                                  controller.selectSuggestion(selected);
                                }
                              }
                            },
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Focus(
                                      onKeyEvent: (node, event) {
                                        if (event is KeyDownEvent) {
                                          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {

                                            controller.moveHighlightDown(viaConditionValue: false);
                                            return KeyEventResult.handled;
                                          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                                            controller.moveHighlightUp(viaConditionValue: false);
                                            return KeyEventResult.handled;
                                          }
                                        }
                                        return KeyEventResult.ignored;
                                      },
                                      child: TextField(
                                        key: fieldKey,
                                        focusNode: focusNode,
                                        controller: addressCtrl,
                                        textCapitalization: TextCapitalization.characters,
                                        inputFormatters: [UpperCaseTextFormatter()],
                                        onTap: () {
                                          controller.selectedTextFieldsValue.value = "via";
                                          controller.activeFieldKey.value = fieldKey;
                                        },
                                        onChanged: (v) {
                                          if (v.isEmpty) {
                                            controller.allAddressesData.clear();
                                            controller.selectedModel = null;
                                            controller.selectedTextFieldsValue.value = "";
                                          } else {
                                            controller.selectedTextFieldsValue.value = "via";
                                            controller.activeFieldKey.value = fieldKey;
                                            controller.onChangeHandler(fieldName: "via", searchingText: v);
                                          }
                                        },
                                        onSubmitted: (_) {
                                          if (controller.allAddressesData.isNotEmpty) {
                                            final index = controller.highlightedIndex.value;
                                            if (index >= 0 && index < controller.allAddressesData.length) {
                                              final selected = controller.allAddressesData[index];
                                              controller.selectedModel = selected;
                                              addressCtrl.text = "${selected.name} ${selected.postcode}".toUpperCase();

                                              controller.allAddressesData.clear();
                                              controller.selectedTextFieldsValue.value = "";
                                              controller.update();
                                            }
                                          }
                                        },
                                        style: const TextStyle(fontFamily: _kFontFamily, fontSize: 12),
                                        decoration: InputDecoration(
                                          hintText: isReturnSection ? "SEARCH RETURN ADDRESS..." : "SEARCH ADDRESS...",
                                          hintStyle: const TextStyle(fontFamily: _kFontFamily, fontSize: 11, color: Colors.grey),
                                          fillColor: Colors.white,
                                          filled: true,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                                          border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 34,
                                    height: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => _addViaPoint(isReturnWay: isReturnSection, addressCtrl: addressCtrl),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4CAF50),
                                        padding: EdgeInsets.zero,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(width: 1, color: const Color(0xFFCBD5E1)),
                      const SizedBox(
                        width: 52,
                        child: Center(
                          child: Text(
                            "ACTION",
                            style: TextStyle(fontFamily: _kFontFamily, fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // TABLE
              if (filteredList.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFCBD5E1)),
                  itemBuilder: (context, index) {
                    final point = filteredList[index];
                    final mainIndex = controller.viaPoints.indexOf(point);

                    return Container(
                      color: Colors.white,
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: Center(
                                child: Text('${index + 1}', style: const TextStyle(fontFamily: _kFontFamily, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                            Container(width: 1, color: const Color(0xFFCBD5E1)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: TextField(
                                        style: const TextStyle(fontFamily: _kFontFamily, fontSize: 11, fontWeight: FontWeight.w600),
                                        readOnly: true,
                                        controller: TextEditingController(text: point.address.toUpperCase()),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                          fillColor: Color(0xFFFAFAFA),
                                          filled: true,
                                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 30,
                                            child: TextField(
                                              textCapitalization: TextCapitalization.characters,
                                              inputFormatters: [UpperCaseTextFormatter()],
                                              style: const TextStyle(fontFamily: _kFontFamily, fontSize: 11),
                                              controller: mainIndex < controller.viaTextEditingController.length
                                                  ? controller.viaTextEditingController[mainIndex].name
                                                  : TextEditingController(),
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                                hintText: "NAME",
                                                hintStyle: TextStyle(fontFamily: _kFontFamily, fontSize: 10),
                                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: SizedBox(
                                            height: 30,
                                            child: TextField(
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              style: const TextStyle(fontFamily: _kFontFamily, fontSize: 11),
                                              controller: mainIndex < controller.viaTextEditingController.length
                                                  ? controller.viaTextEditingController[mainIndex].mobile
                                                  : TextEditingController(),
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                                hintText: "MOBILE",
                                                hintStyle: TextStyle(fontFamily: _kFontFamily, fontSize: 10),
                                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(width: 1, color: const Color(0xFFCBD5E1)),
                            SizedBox(
                              width: 52,
                              child: Center(
                                child: SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (mainIndex != -1) {
                                        controller.viaPoints.removeAt(mainIndex);
                                        if (mainIndex < controller.viaTextEditingController.length) {
                                          controller.viaTextEditingController.removeAt(mainIndex);
                                        }
                                        controller.update();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF4D4D),
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    child: const Icon(Icons.delete, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}