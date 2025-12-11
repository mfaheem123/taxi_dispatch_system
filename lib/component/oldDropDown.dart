
import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String selecteditem;
  final Function(String?)? onchanged;
  final double width;
  final double? height;
  final double? iconSize;
  final TextStyle? textStyle;
  final Widget? hint;
  final bool isEnabled; // <-- New flag
  final Color? borderColor;
  final FocusNode? focusNode; // ✅ Add this
  final bool isFocused; // ✅ Add this for conditional borderF
  const CustomDropdown({
    super.key,
    required this.items,
    required this.selecteditem,
    this.onchanged,
    required this.width,
    this.height,
    this.iconSize,
    this.textStyle,
    this.hint,
    this.isEnabled = true,
    this.borderColor,
    this.focusNode,
    this.isFocused = false, // default
  });

  @override
  Widget build(BuildContext context) {
    return
//     Opacity(
//       opacity: isEnabled ? 1.0 : 0.6, // dim when disabled
//       child: Container(
//         width: width,
//         height: height ?? MediaQuery.of(context).size.height * 0.045,
//         decoration: BoxDecoration(
//           color: AppColors.lightgreyColor1,
//           border:
//               Border.all(color: borderColor ?? AppColors.primaryGrey, width: 2),
//           borderRadius: BorderRadius.circular(5.0),
//         ),
//         // padding: EdgeInsets.symmetric(horizontal: 8.0),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton(
//             hint: hint,
//             value: selecteditem,
//             style: textStyle ??
//                 TextStyle(
//                     fontSize: MediaQuery.of(context).size.width * 0.0085,
//                     color: AppColors.primaryBlack),
//             icon: Icon(Icons.keyboard_arrow_down,
//                 size: iconSize ?? MediaQuery.of(context).size.width * 0.015),
//             items: items.map((String item) {
//               // Specify the type as String
//               return DropdownMenuItem(
//                 value: item,
//                 child: Text(item),
//               );
//             }).toList(),
//             onChanged:
//                 isEnabled ? onchanged : null, // ✅ this disables it properly
//           ),
//         ),
//       ),
//     );
//   }
// }
      Opacity(
        opacity: isEnabled ? 1.0 : 0.6,
        child: Container(
          width: width,
          height: height ?? MediaQuery.of(context).size.height * 0.045,
          decoration: BoxDecoration(
            color: DynamicColors.whiteClr,
            border: Border.all(
              color: isFocused
                  ? DynamicColors.primaryClr // ✅ Highlight border when focused
                  : (borderColor ?? DynamicColors.gryClr),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: hint,
              value: selecteditem,
              style: textStyle ??
                  TextStyle(

                    fontSize: MediaQuery.of(context).size.width * 0.0085,
                    color: DynamicColors.black,

                  ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: iconSize ?? MediaQuery.of(context).size.width * 0.015,
              ),
              items: items.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: isEnabled ? onchanged : null,
            ),
          ),
        ),
      );
  }
}

// class CustomDropdown extends StatefulWidget {
//   final List<String> items;
//   final String selecteditem;
//   final Function(String?)? onchanged;
//   final double width;
//   final double? height;
//   final double? iconSize;
//   final TextStyle? textStyle;
//   final Widget? hint;
//   final bool isEnabled;
//   final Color? borderColor;

//   const CustomDropdown({
//     super.key,
//     required this.items,
//     required this.selecteditem,
//     this.onchanged,
//     required this.width,
//     this.height,
//     this.iconSize,
//     this.textStyle,
//     this.hint,
//     this.isEnabled = true,
//     this.borderColor,
//   });

//   @override
//   State<CustomDropdown> createState() => _CustomDropdownState();
// }

// class _CustomDropdownState extends State<CustomDropdown> {
//   OverlayEntry? _overlayEntry;
//   final LayerLink _layerLink = LayerLink();
//   int _highlightedIndex = 0;
//   final FocusNode _focusNode = FocusNode();
//   final ScrollController _scrollController = ScrollController();

//   void _toggleDropdown() {
//     if (_overlayEntry == null) {
//       _showOverlay();
//     } else {
//       _removeOverlay();
//     }
//   }

//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//     _focusNode.unfocus();
//   }

//   void _showOverlay() {
//     final renderBox = context.findRenderObject() as RenderBox;
//     final offset = renderBox.localToGlobal(Offset.zero);
//     final size = renderBox.size;

//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height + 4,
//         width: size.width,
//         child: RawKeyboardListener(
//           focusNode: _focusNode,
//           autofocus: true,
//           onKey: (event) {
//             if (event is RawKeyDownEvent) {
//               if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
//                 setState(() {
//                   _highlightedIndex =
//                       (_highlightedIndex + 1) % widget.items.length;
//                 });
//                 _scrollToHighlighted();
//               } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
//                 setState(() {
//                   _highlightedIndex =
//                       (_highlightedIndex - 1 + widget.items.length) %
//                           widget.items.length;
//                 });
//                 _scrollToHighlighted();
//               } else if (event.logicalKey == LogicalKeyboardKey.enter) {
//                 widget.onchanged?.call(widget.items[_highlightedIndex]);
//                 _removeOverlay();
//               } else if (event.logicalKey == LogicalKeyboardKey.escape) {
//                 _removeOverlay();
//               }
//             }
//           },
//           child: Material(
//             elevation: 4,
//             child: Container(
//               constraints: BoxConstraints(maxHeight: 200),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: ListView.builder(
//                 controller: _scrollController,
//                 itemCount: widget.items.length,
//                 itemBuilder: (context, index) {
//                   final item = widget.items[index];
//                   final isHighlighted = index == _highlightedIndex;
//                   return GestureDetector(
//                     onTap: () {
//                       widget.onchanged?.call(item);
//                       _removeOverlay();
//                     },
//                     child: Container(
//                       color: isHighlighted ? Colors.blue[100] : Colors.white,
//                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                       child: Text(
//                         item,
//                         style: widget.textStyle,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//     _focusNode.requestFocus();
//   }

//   void _scrollToHighlighted() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _highlightedIndex * 48.0,
//         duration: Duration(milliseconds: 100),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _removeOverlay();
//     _focusNode.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: _layerLink,
//       child: GestureDetector(
//         onTap: widget.isEnabled ? _toggleDropdown : null,
//         child: Container(
//           width: widget.width,
//           height: widget.height ?? MediaQuery.of(context).size.height * 0.045,
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: AppColors.lightgreyColor1,
//             border: Border.all(
//               color: widget.borderColor ?? AppColors.primaryGrey,
//               width: 2,
//             ),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           alignment: Alignment.centerLeft,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(widget.selecteditem, style: widget.textStyle),
//               Icon(
//                 Icons.keyboard_arrow_down,
//                 size: widget.iconSize ??
//                     MediaQuery.of(context).size.width * 0.015,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
