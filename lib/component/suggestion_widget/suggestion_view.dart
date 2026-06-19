


import 'package:dashboard_new1/component/suggestion_widget/suggestion_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SuggestionView extends StatefulWidget {
  SuggestionView({super.key, required this.allListData,
    required this.onSelect,
    this.topPositions,
    this.leftPositions,
  });
  List allListData = [].obs;
  final Function(dynamic value) onSelect;
  double? topPositions;
  double? leftPositions;

  @override
  State<SuggestionView> createState() => _SuggestionViewState();
}

class _SuggestionViewState extends State<SuggestionView> {

  SuggestionController controller = Get.isRegistered<SuggestionController>()
      ? Get.find<SuggestionController>()
      : Get.put(SuggestionController());

  DashboardController dashboardController = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.allListData = widget.allListData;
    // FocusScope.of(Get.context!).requestFocus(dashboardController.phoneNumberFieldKey);
    controller.updateKeys();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Obx(() {
      if (controller.allListData.isEmpty) {
        return const SizedBox();
      }

      final activeKey = controller.activeFieldKey.value;
      final fieldBox = activeKey?.currentContext?.findRenderObject() as RenderBox?;
      final stackBox = controller.stackKey.currentContext?.findRenderObject() as RenderBox?;

      double top = 0.0;
      double left = 0.0;
      double right = 0.0;
      double width = screenWidth; // define early

      if (fieldBox != null && stackBox != null) {
        final localOffset = fieldBox.localToGlobal(Offset.zero, ancestor: stackBox);
        width = fieldBox.size.width;
        top = localOffset.dy + fieldBox.size.height;
        left = localOffset.dx;
        right = localOffset.dx;
      }

      return Positioned(
        top: widget.topPositions ??  screenHeight * 0.2,
        left: widget.leftPositions ?? width/3.5,
        width: width/8,
        child: RawKeyboardListener(
          focusNode: dashboardController.suggestionPhoneFocusNode.value,
          // autofocus: true,
          onKey: (RawKeyEvent event) async {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                controller.moveHighlightDown();
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                controller.moveHighlightUp();
              } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                print("controller.highlightedIndex.value");
                print(controller.highlightedIndex.value);
                print(controller.highlightedIndex.value);
                print(controller.highlightedIndex.value);
                print(controller.highlightedIndex.value);
                print(controller.highlightedIndex.value);
                print(controller.highlightedIndex.value);
                print(controller.highlightedIndex.value);
                print(controller.highlightedIndex.value);
                final data = await controller.tapSelect(controller.highlightedIndex.value);
                widget.onSelect(data);
              }
            }
          },
          child: Container(
            height: screenHeight * 0.3,
            width: screenWidth * 0.3,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF0F2),
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
              ],
            ),
            child: ListView.builder(
              key: controller.suggestionListKey,
              controller: controller.suggestionScrollController,
              itemCount: controller.allListData.length,
              padding: const EdgeInsets.only(top: 15),
              itemBuilder: (context, index) {
                final item = controller.allListData[index];
                // final isHighlighted = controller.highlightedIndex.value == index;

                return Obx(() {
                  final isHighlighted = controller.highlightedIndex.value == index;
                  return Container(
                    key: controller.suggestionItemKeys[index],
                    color: isHighlighted ? const Color(0xffA0DCFF) : Colors.transparent,
                    width: screenWidth * 0.3,
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 120),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                          color: isHighlighted ? Colors.blue : Colors.black,
                        ),
                        child: Text("${item.name} -  ${item.mobile}"),
                      ),
                        onTap: () async {
                          final data = await controller.tapSelect(index);
                          widget.onSelect(data);
                          print("Selected value --> $data");
                        }
                    ),
                  );
                });
              },
            ),
          ),
        ),
      );
    });
  }
}



// class _SuggestionViewState extends State<SuggestionView> {
//
//   SuggestionController controller = Get.isRegistered<SuggestionController>()
//       ? Get.find<SuggestionController>()
//       : Get.put(SuggestionController());
//
//   DashboardController dashboardController = Get.isRegistered<DashboardController>()
//       ? Get.find<DashboardController>()
//       : Get.put(DashboardController());
//
//   @override
//   void initState() {
//     super.initState();
//     controller.allListData = widget.allListData;
//     controller.updateKeys();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Obx(() {
//       if (controller.allListData.isEmpty) {
//         return const SizedBox();
//       }
//
//       // TextField ki width auto-calculate karne ke liye
//       final activeKey = controller.activeFieldKey.value;
//       final fieldBox = activeKey?.currentContext?.findRenderObject() as RenderBox?;
//       double calculatedWidth = fieldBox?.size.width ?? (screenWidth * 0.12);
//
//       // Positioned aur Stack calculation ki jagah CompositedTransformFollower use kiya hai
//       return CompositedTransformFollower(
//         link: dashboardController.mobileFieldLayerLink,
//         showWhenUnlinked: false,
//         targetAnchor: Alignment.bottomLeft,
//         followerAnchor: Alignment.topLeft,
//         offset: const Offset(0, 5), // Field ke bilkul 5 pixels neeche chipka rahega
//         child: Material(
//           color: Colors.transparent,
//           child: RawKeyboardListener(
//             focusNode: dashboardController.suggestionPhoneFocusNode.value,
//             onKey: (RawKeyEvent event) async {
//               if (event is RawKeyDownEvent) {
//                 if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
//                   controller.moveHighlightDown();
//                 } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
//                   controller.moveHighlightUp();
//                 } else if (event.logicalKey == LogicalKeyboardKey.enter) {
//                   final data = await controller.tapSelect(controller.highlightedIndex.value);
//                   widget.onSelect(data);
//                 }
//               }
//             },
//             child: Container(
//               height: screenHeight * 0.3,
//               width: calculatedWidth, // Auto width adjustment according to textfield
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEFF0F2),
//                 borderRadius: BorderRadius.circular(5),
//                 boxShadow: const [
//                   BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
//                 ],
//               ),
//               child: ListView.builder(
//                 key: controller.suggestionListKey,
//                 controller: controller.suggestionScrollController,
//                 itemCount: controller.allListData.length,
//                 padding: const EdgeInsets.only(top: 15),
//                 itemBuilder: (context, index) {
//                   final item = controller.allListData[index];
//
//                   return Obx(() {
//                     final isHighlighted = controller.highlightedIndex.value == index;
//                     return Container(
//                       key: controller.suggestionItemKeys[index],
//                       color: isHighlighted ? const Color(0xffA0DCFF) : Colors.transparent,
//                       width: calculatedWidth,
//                       child: ListTile(
//                           dense: true,
//                           visualDensity: VisualDensity.compact,
//                           title: AnimatedDefaultTextStyle(
//                             duration: const Duration(milliseconds: 120),
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
//                               color: isHighlighted ? Colors.blue : Colors.black,
//                             ),
//                             child: Text("${item.name} -  ${item.mobile}"),
//                           ),
//                           onTap: () async {
//                             final data = await controller.tapSelect(index);
//                             widget.onSelect(data);
//                             print("Selected value --> $data");
//                           }
//                       ),
//                     );
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }


