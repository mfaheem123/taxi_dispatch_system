


import 'package:flutter/material.dart';

import 'color.dart';

class MenueTabView extends StatefulWidget {
  MenueTabView({this.keys,this.icon,this.items,this.label,this.menuKey,this.selectedMenu,
  this.onMenuSelect,
    this.selectedDropdownItem,
  });

  final void Function(String)? onMenuSelect;
  IconData? icon; String? label; String? menuKey;
      List<String>? items; GlobalKey? keys;
  String? selectedMenu = "";
  String? selectedDropdownItem = "";


  @override
  State<MenueTabView> createState() => _MenueTabViewState();
}

class _MenueTabViewState extends State<MenueTabView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          key: widget.key,
          onTap: () async {
            setState(() {
              widget.selectedMenu = widget.menuKey;
            });

            final RenderBox renderBox =
            widget.keys!.currentContext!.findRenderObject() as RenderBox;
            final Offset offset = renderBox.localToGlobal(Offset.zero);
            final Size size = renderBox.size;

            final selected = await showMenu<String>(
              context: context,
              position: RelativeRect.fromLTRB(
                offset.dx,
                offset.dy + size.height,
                offset.dx + size.width,
                offset.dy,
              ),
              items: widget.items!
                  .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
              elevation: 8.0,
            );

            if (selected != null) {
              setState(() {
                widget.selectedDropdownItem = selected;
              });
              if (widget.onMenuSelect != null) {
                widget.onMenuSelect!(selected);
              }
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: widget.selectedMenu == widget.menuKey
                  ? Colors.cyanAccent.shade400
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: DynamicColors.whiteClr,
                  size: 16,
                ),
                SizedBox(width: 5),
                Text(
                  widget.label!,
                  style: TextStyle(
                    color: DynamicColors.whiteClr,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                // Icon(
                //   Icons.arrow_drop_down,
                //   color: selectedMenu == menuKey ? Color(0xFF43489A) : Colors.white,
                // ),
              ],
            ),

          ),
        ),
      ],
    );
  }
}
