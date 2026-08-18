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
  int _highlightedIndex = -1;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });

    if (widget.value != null) {
      _highlightedIndex = widget.items.indexOf(widget.value as T);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _openDropdown() {
    if (_isOpen) return;

    if (widget.value != null) {
      _highlightedIndex = widget.items.indexOf(widget.value as T);
    } else if (widget.items.isNotEmpty && _highlightedIndex == -1) {
      _highlightedIndex = 0;
    }

    setState(() => _isOpen = true);
    _focusNode.requestFocus();

    final RenderBox renderBox =
    _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
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
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final isHighlighted = index == _highlightedIndex;
                return GestureDetector(
                  onTap: () => _selectItem(widget.items[index]),
                  child: Container(
                    color: isHighlighted
                        ? DynamicColors.primaryClr.withOpacity(0.2)
                        : Colors.transparent,
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.itemLabel(widget.items[index]),
                      style: mozillaTextRegularText(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: isHighlighted ? DynamicColors.primaryClr : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (!_isOpen) return;

    setState(() => _isOpen = false);
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(T item) {
    widget.onChanged(item);
    _highlightedIndex = widget.items.indexOf(item);
    _closeDropdown();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Sirf key down par kaam karein
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // 1. Jab Dropdown CLOSED ho
    if (!_isOpen) {
      if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.enter) {
        _openDropdown();
        return KeyEventResult.handled;
      }

      // Arrow keys ko yahan HANDLED return karein taake Page scroll NA ho aur log na aaye
      if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.arrowUp) {
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    // 2. Jab Dropdown OPEN ho
    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _highlightedIndex = (_highlightedIndex + 1) % widget.items.length;
        _overlayEntry?.markNeedsBuild();
      });
      return KeyEventResult.handled;
    }
    // else if (key == LogicalKeyboardKey.arrowUp) {
    //   setState(() {
    //     _highlightedIndex = _highlightedIndex <= 0
    //         ? widget.items.length - 1
    //         : _highlightedIndex - 1;
    //     _overlayEntry?.markNeedsBuild();
    //   });
    //   return KeyEventResult.handled;
    // }
    else if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      if (_highlightedIndex >= 0 && _highlightedIndex < widget.items.length) {
        _selectItem(widget.items[_highlightedIndex]);
      }
      return KeyEventResult.handled;
    }
    else if (key == LogicalKeyboardKey.escape) {
      _closeDropdown();
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
        widget.text != null
            ? Text(
          widget.text!,
          style: mozillaTextSemiBoldText(context: context, fontSize: 13),
        )
            : const SizedBox.shrink(),
        Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: GestureDetector(
            key: _key,
            onTap: () {
              _focusNode.requestFocus();
              if (_isOpen) {
                _closeDropdown();
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
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

