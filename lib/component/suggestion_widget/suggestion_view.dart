


import 'package:dashboard_new1/component/suggestion_widget/suggestion_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SuggestionView extends StatefulWidget {
  SuggestionView({super.key, required this.allListData});
  List allListData = [].obs;

  @override
  State<SuggestionView> createState() => _SuggestionViewState();
}

class _SuggestionViewState extends State<SuggestionView> {

  SuggestionController controller = Get.isRegistered<SuggestionController>()
      ? Get.find<SuggestionController>()
      : Get.put(SuggestionController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.allListData = widget.allListData;
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      if (controller.allListData.isEmpty) return const SizedBox();

      final activeKey = controller.activeFieldKey.value;
      final fieldBox = activeKey?.currentContext?.findRenderObject() as RenderBox?;
      final stackBox = controller.stackKey.currentContext?.findRenderObject() as RenderBox?;

      double top = 0.0;
      double left = 0.0;
      double width = screenWidth; // define early

      if (fieldBox != null && stackBox != null) {
        final localOffset = fieldBox.localToGlobal(Offset.zero, ancestor: stackBox);
        width = fieldBox.size.width;
        top = localOffset.dy + fieldBox.size.height;
        left = localOffset.dx;
      }

      return Positioned(
        top: top,
        left: left,
        width: width,
        child: RawKeyboardListener(
          focusNode: controller.suggestionFocusNode,
          autofocus: true,
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                controller.moveHighlightDown();
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                controller.moveHighlightUp();
              } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                controller.tapSelect(controller.suggestionSelectedIndex.value);
                print("Enter pressed");
              }
            }
          },
          child: Container(
            height: screenHeight * 0.3,
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
                final isHighlighted = controller.highlightedIndex.value == index;

                return Obx(() {
                  final isHighlighted = controller.highlightedIndex.value == index;
                  return Container(
                    key: controller.suggestionItemKeys[index],
                    color: isHighlighted ? const Color(0xffA0DCFF) : Colors.transparent,
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
                        child: Text("${item.name} ${item.postcode}"),
                      ),
                      onTap: () => controller.tapSelect(index),
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
