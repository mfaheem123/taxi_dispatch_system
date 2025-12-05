


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestionController extends GetxController {

  List allListData = [].obs;
  final highlightedIndex = 0.obs;
  List<GlobalKey> suggestionItemKeys = [];
  final GlobalKey suggestionListKey = GlobalKey();
  final suggestionScrollController = ScrollController();

  final activeFieldKey = Rx<GlobalKey?>(null);
  final stackKey = GlobalKey();
  final Rx<FocusNode> suggestionFocusNode = FocusNode().obs;
  var inputText = ''.obs;
  final selectedTextController = TextEditingController();


  void updateKeys() {

    // FocusScope.of(Get.context!).requestFocus(suggestionFocusNode.value);
    suggestionItemKeys = List.generate(allListData.length, (_) => GlobalKey());
  }

  void onInputChanged(String value) {
    inputText.value = value;
    if (value.isEmpty) {
      allListData.clear();
    } else {
      allListData = allListData
          .where((loc) => loc.name!.toUpperCase().contains(value.toLowerCase()))
          .toList();
      highlightedIndex.value = 0;
    }
  }

  Future<void> selectSuggestion(String? value) async {
    // viaLocation2Controller.text = value!;
    selectedTextController.selection =
        TextSelection.collapsed(offset: value!.length);

    inputText.value = value;
    return allListData.clear();
  }


// change move functions to scroll after change:
  void moveHighlightDown({bool viaConditionValue = false}) {
    if (allListData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value + 1) % allListData.length;
    highlightedIndex.refresh();
    _scrollToHighlighted(scrollDown: true); // 👈 scroll to bottom when down
  }

  void moveHighlightUp({bool viaConditionValue = false}) {
    if (allListData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value - 1 + allListData.length) %
            allListData.length;
    highlightedIndex.refresh();
    _scrollToHighlighted(
        scrollDown: false,
        viaCondition: viaConditionValue); // 👈 scroll to top when up
  }

  void _scrollToHighlighted(
      {bool scrollDown = true, bool viaCondition = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {

      final i = highlightedIndex.value;

      if (i < 0 || i >= suggestionItemKeys.length) return;

      final itemCtx = suggestionItemKeys[i].currentContext;

      final listCtx = /*selectedTextFieldsValue.value !=
          "via"?*/
      suggestionListKey
          .currentContext /*:suggestionListKeyVia.currentContext*/;

      if (itemCtx != null &&
          listCtx != null &&

          suggestionScrollController.hasClients) {

        final RenderBox itemBox = itemCtx.findRenderObject() as RenderBox;

        final RenderBox listBox = listCtx.findRenderObject() as RenderBox;

        final Offset itemOffset = itemBox.localToGlobal(Offset.zero, ancestor: listBox);

        final double itemTopLocal = itemOffset.dy;

        final double itemBottomLocal = itemTopLocal + itemBox.size.height;

        final double viewportHeight = listBox.size.height;

        final double currentOffset = suggestionScrollController.offset;

        double targetOffset = currentOffset;

        const double edgeMargin = 8.0;

        if (itemBottomLocal > viewportHeight - edgeMargin) {

          final double delta = itemBottomLocal - (viewportHeight - edgeMargin);

          targetOffset = (currentOffset + delta).clamp(

            suggestionScrollController.position.minScrollExtent,
            suggestionScrollController.position.maxScrollExtent,

          );
        } else if (itemTopLocal < edgeMargin) {

          final double delta = itemTopLocal - edgeMargin; // negative

          targetOffset = (currentOffset + delta).clamp(

            suggestionScrollController.position.minScrollExtent,
            suggestionScrollController.position.maxScrollExtent,

          );
        } else {
          return; // already visible
        }

        _instantOrSmoothScroll(targetOffset, currentOffset);

      } else {

        _fallbackScroll(i, scrollDown);

      }
    });
  }

  void _fallbackScroll(int index, bool scrollDown) {
    if (!suggestionScrollController.hasClients) return;

    const double itemHeight = 48.0;
    const double topPadding = 15.0;
    final currentOffset = suggestionScrollController.offset;
    final viewport = suggestionScrollController.position.viewportDimension;
    final visibleStart = currentOffset;
    final visibleEnd = currentOffset + viewport;

    final itemTop = topPadding + index * itemHeight;
    final itemBottom = itemTop + itemHeight;

    double target = currentOffset;
    const double margin = itemHeight * 0.12;

    if (itemBottom > visibleEnd) {
      target = itemBottom - viewport + margin;
    } else if (itemTop < visibleStart) {
      target = itemTop - margin;
    } else {
      return;
    }

    target = target.clamp(
      suggestionScrollController.position.minScrollExtent,
      suggestionScrollController.position.maxScrollExtent,
    );

    _instantOrSmoothScroll(target, currentOffset);
  }

  void _instantOrSmoothScroll(double targetOffset, double currentOffset) {
    if (!suggestionScrollController.hasClients) return;

    // difference between current & target
    final double diff = (targetOffset - currentOffset).abs();

    // if small distance -> jump instantly
    if (diff < 60) {
      suggestionScrollController.jumpTo(targetOffset);
    } else {
      // if bigger move -> smooth scroll
      suggestionScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }



  Future tapSelect(int index) async {
    if (allListData.isEmpty) return null;

    final selected = allListData[index];

    allListData.clear();
    highlightedIndex.value = 0;
    return selected;
  }

}
