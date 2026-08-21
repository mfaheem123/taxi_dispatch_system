import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'color.dart';


class CustomDropdownField<T> extends StatefulWidget {
  final String? label;
  final List<T> items;
  final double? width;
  final double? height;
  final T? value;
  final String Function(T) itemLabel;
  final Function(T?) onChanged;
  final String? text;

  const CustomDropdownField({
    super.key,
    this.label,
    required this.items,
    this.width,
    this.height,
    this.text,
    this.value,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  late FocusNode _focusNode;
  late ScrollController _scrollController;

  final LayerLink _layerLink = LayerLink();

  int _highlightedIndex = -1;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;

  final double _itemHeight = 38.0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isOpen) {
        _closeDropdown(retainFocus: false);
      }
      if (mounted) setState(() {});
    });

    if (widget.value != null) {
      _highlightedIndex = widget.items.indexOf(widget.value as T);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _closeDropdown(retainFocus: false);
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients || widget.items.isEmpty) return;

    final double targetOffset = index * _itemHeight;
    final double currentOffset = _scrollController.offset;
    final double maxExtent = _scrollController.position.maxScrollExtent;
    final double viewportHeight = _scrollController.position.viewportDimension;

    if (index == 0 && currentOffset > maxExtent / 2) {
      _scrollController.jumpTo(0);
      return;
    }
    if (index == widget.items.length - 1 && currentOffset < maxExtent / 2) {
      _scrollController.jumpTo(maxExtent);
      return;
    }

    if (targetOffset < currentOffset) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    } else if (targetOffset + _itemHeight > currentOffset + viewportHeight) {
      _scrollController.animateTo(
        targetOffset + _itemHeight - viewportHeight,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }
  }

  void _openDropdown() {
    if (_isOpen || widget.items.isEmpty) return;

    if (widget.value != null) {
      _highlightedIndex = widget.items.indexOf(widget.value as T);
    } else if (_highlightedIndex == -1) {
      _highlightedIndex = 0;
    }

    setState(() => _isOpen = true);
    _focusNode.requestFocus();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width ?? Get.width / 4,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, (widget.height ?? 30) + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(color: DynamicColors.primaryClr),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final isHighlighted = index == _highlightedIndex;
                  return GestureDetector(
                    onTap: () => _selectItem(widget.items[index]),
                    child: Container(
                      height: _itemHeight,
                      color: isHighlighted
                          ? DynamicColors.primaryClr.withOpacity(0.2)
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.itemLabel(widget.items[index]),
                        style: mozillaTextRegularText(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: isHighlighted ? DynamicColors.primaryClr : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_highlightedIndex >= 0) {
        _scrollToIndex(_highlightedIndex);
      }
    });
  }

  // Parameter retainFocus add kiya hai focus maintain rakhne ke liye
  void _closeDropdown({bool retainFocus = true}) {
    if (!_isOpen) return;

    setState(() => _isOpen = false);
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (retainFocus) {
      _focusNode.requestFocus();
    }
  }

  void _selectItem(T item) {
    widget.onChanged(item);
    _highlightedIndex = widget.items.indexOf(item);
    _closeDropdown(retainFocus: true);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;

    if (!_isOpen) {
      if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
        _openDropdown();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      if (event is KeyDownEvent || event is KeyRepeatEvent) {
        setState(() {
          _highlightedIndex = (_highlightedIndex + 1) % widget.items.length;
          _overlayEntry?.markNeedsBuild();
          _scrollToIndex(_highlightedIndex);
        });
      }
      return KeyEventResult.handled;
    }
    else if (key == LogicalKeyboardKey.arrowUp) {
      if (event is KeyDownEvent || event is KeyRepeatEvent) {
        setState(() {
          _highlightedIndex = _highlightedIndex <= 0
              ? widget.items.length - 1
              : _highlightedIndex - 1;
          _overlayEntry?.markNeedsBuild();
          _scrollToIndex(_highlightedIndex);
        });
      }
      return KeyEventResult.handled;
    }
    else if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      if (_highlightedIndex >= 0 && _highlightedIndex < widget.items.length) {
        _selectItem(widget.items[_highlightedIndex]);
      }
      return KeyEventResult.handled;
    }
    else if (key == LogicalKeyboardKey.escape) {
      // Escape press hone par dropdown close hoga aur focus issi field par retain rahega
      _closeDropdown(retainFocus: true);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.text != null)
          Text(
            widget.text!,
            style: mozillaTextSemiBoldText(context: context, fontSize: 13),
          ),
        Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: () {
                if (_isOpen) {
                  _closeDropdown(retainFocus: true);
                } else {
                  _openDropdown();
                }
              },
              child: SizedBox(
                width: widget.width ?? Get.width / 4,
                height: widget.height ?? 30,
                child: InputDecorator(
                  isFocused: isFocused,
                  decoration: InputDecoration(
                    hintText: widget.label,
                    fillColor: Colors.transparent,
                    hintStyle: mozillaTextRegularText(fontSize: 10),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isFocused ? DynamicColors.primaryClr : Colors.grey,
                        width: isFocused ? 2.0 : 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: DynamicColors.primaryClr,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.value != null
                              ? widget.itemLabel(widget.value as T)
                              : widget.label ?? "",
                          style: mozillaTextRegularText(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        size: 16,
                        color: isFocused ? DynamicColors.primaryClr : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DropdownModel {
  int? id;
  String? name;
  String? templateValue;
  DropdownModel({this.id, this.name, this.templateValue});
}