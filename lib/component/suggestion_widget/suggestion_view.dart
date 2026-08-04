


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
  List allListData = [];
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
    super.initState();
    controller.allListData.assignAll(widget.allListData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dashboardController.selectedTextFieldsValue.value == "New Custom Field") {
        dashboardController.suggestionNewCustomFocusNode.value.requestFocus();
      } else {
        dashboardController.suggestionPhoneFocusNode.value.requestFocus();
      }
    });
    controller.updateKeys();
  }

  @override
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Obx(() {
      if (controller.allListData.isEmpty) {
        return const SizedBox();
      }

      final double fieldWidth = dashboardController.mobileFieldLink.leaderSize?.width ?? (screenWidth * 0.3);
      final double fieldHeight = dashboardController.mobileFieldLink.leaderSize?.height ?? 40;

      const double itemHeight = 55.0;
      final double maxListHeight = screenHeight * 0.3;
      final double listHeight = (controller.allListData.length * itemHeight)
          .clamp(itemHeight, maxListHeight);

      return Positioned.fill(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  controller.allListData.clear();
                  dashboardController.dropDownShow.value = false;
                },
              ),
            ),
            CompositedTransformFollower(
              link: dashboardController.mobileFieldLink,
              showWhenUnlinked: false,
              offset: Offset(0, fieldHeight),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: listHeight,
                  width: fieldWidth,
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

                      return Obx(() {
                        final isHighlighted = controller.highlightedIndex.value == index;
                        return Container(
                          key: (controller.suggestionItemKeys.length > index)
                              ? controller.suggestionItemKeys[index]
                              : UniqueKey(),
                          color: isHighlighted ? const Color(0xffA0DCFF) : Colors.transparent,
                          width: fieldWidth,
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
            ),
          ],
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


