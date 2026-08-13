

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';

class CustomTimePicker extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onTimeSelected;
  bool readOnly = true;

  CustomTimePicker({
    Key? key,
    this.controller,
    this.onTimeSelected,
    this.readOnly = true,
  }) : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late final TextEditingController _timeController;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  late int selectedHour;
  late int selectedMinute;

  @override
  void initState() {
    super.initState();
    _timeController = widget.controller ?? TextEditingController();


    final now = DateTime.now();


    if (_timeController.text.isEmpty) {
      selectedHour = now.hour;
      selectedMinute = now.minute;
      _updateTimeText();
    } else {

      try {
        List<String> parts = _timeController.text.trim().split(':');
        selectedHour = int.parse(parts[0]);
        selectedMinute = int.parse(parts[1]);
      } catch (e) {
        selectedHour = now.hour;
        selectedMinute = now.minute;
      }
    }
  }


  void _updateTimeText() {
    final hourStr = selectedHour.toString().padLeft(2, '0');
    final minuteStr = selectedMinute.toString().padLeft(2, '0');
    _timeController.text = "$hourStr:$minuteStr ";
  }

  void  _toggleTimeDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _closeDropdown();
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectAndClose({int? hour, int? minute, String? period}) {
    setState(() {
      if (hour != null) selectedHour = hour;
      if (minute != null) selectedMinute = minute;
      // if (period != null) selectedPeriod = period;
      _updateTimeText();
    });

    widget.onTimeSelected?.call(_timeController.text);
    _closeDropdown();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeDropdown,
            ),
          ),

        Positioned(
          left: offset.dx,
          top: offset.dy + 80,
          width: 180,
          height: 200,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  _buildScrollColumn(0, 23, selectedHour, (value) {
                    _selectAndClose(hour: value);
                  }),
                  _buildScrollColumn(0, 59, selectedMinute, (value) {
                    _selectAndClose(minute: value);
                  }),
                  // _buildAmPmColumn(),
                ],
              ),
            ),
          ),
        ),
        ]
    ),
    );
  }

  Widget _buildScrollColumn(
      int start, int end, int selected, Function(int) onSelect) {
    return Expanded(
      child: ListView.builder(
        itemCount: end - start + 1,
        itemBuilder: (context, index) {
          int value = start + index;
          final valueStr = value.toString().padLeft(2, '0');
          final isSelected = value == selected;
          return InkWell(
            onTap: () => onSelect(value),
            child: Container(
              padding: const EdgeInsets.all(12),
              color: isSelected ? Colors.blue : null,
              child: Center(
                child: Text(
                  valueStr,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _timeController.dispose(); // Only dispose if local

    }

    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: 40,
        width: 150,
        child: TextFormField(
          controller: _timeController,
          readOnly: widget.readOnly,
          onTap: _toggleTimeDropdown,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            hintText: "Select Time",
            suffixIcon:


              InkWell(
                onTap: _toggleTimeDropdown,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.access_time, size: 18),
                ),
              ),




            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}


/// Keyboard-driven DatePicker widget (no packages)
// class KeyboardDatePicker extends StatefulWidget {
//   final DateTime initialDate;
//   final void Function(DateTime)? onChanged;
//   final void Function(DateTime)? onSubmitted;
//   final Color? borderClr;
//
//   /// 🔹 NEW
//   final double fontSize;
//   final double iconSize;
//
//   KeyboardDatePicker({
//     Key? key,
//     DateTime? initialDate,
//     this.onChanged,
//     this.onSubmitted,
//     this.borderClr,
//     this.fontSize = 12, // default font size
//     this.iconSize = 14, // default icon size
//   })  : initialDate = initialDate ?? DateTime(2000, 1, 1),
//         super(key: key);
//
//   @override
//   State<KeyboardDatePicker> createState() => _KeyboardDatePickerState();
// }
//
// class _KeyboardDatePickerState extends State<KeyboardDatePicker> {
//   late int day;
//   late int month;
//   late int year;
//
//   int activePart = 0;
//   final List<String> _buffers = ['', '', ''];
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     day = widget.initialDate.day;
//     month = widget.initialDate.month;
//     year = widget.initialDate.year;
//     _clampDay();
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   bool _isLeap(int y) =>
//       (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
//
//   int _daysInMonth(int m, int y) {
//     if (m == 2) return _isLeap(y) ? 29 : 28;
//     if ([1, 3, 5, 7, 8, 10, 12].contains(m)) return 31;
//     return 30;
//   }
//
//   void _clampDay() {
//     final dim = _daysInMonth(month, year);
//     day = day.clamp(1, dim);
//   }
//
//   void _notifyChanged() {
//     widget.onChanged?.call(DateTime(year, month, day));
//   }
//
//   void _onIncrementActive(int delta) {
//     setState(() {
//       if (activePart == 0) {
//         day += delta;
//         final dim = _daysInMonth(month, year);
//         if (day > dim) day = 1;
//         if (day < 1) day = dim;
//       } else if (activePart == 1) {
//         month += delta;
//         if (month > 12) month = 1;
//         if (month < 1) month = 12;
//         _clampDay();
//       } else {
//         year = (year + delta).clamp(1, 9999999);
//         _clampDay();
//       }
//       _buffers[activePart] = '';
//       _notifyChanged();
//     });
//   }
//
//   void _onDigit(int d) {
//     setState(() {
//       final b = _buffers[activePart] + d.toString();
//
//       if (activePart == 0) {
//         final val = int.tryParse(b) ?? 0;
//         if (val == 0) return;
//         final dim = _daysInMonth(month, year);
//         _buffers[0] = val > dim ? d.toString() : b;
//         day = int.parse(_buffers[0]).clamp(1, dim);
//       } else if (activePart == 1) {
//         final val = int.tryParse(b) ?? 0;
//         if (val == 0) return;
//         _buffers[1] = val > 12 ? d.toString() : b;
//         month = int.parse(_buffers[1]).clamp(1, 12);
//         _clampDay();
//       } else {
//         final val = int.tryParse(b);
//         if (val != null && val > 0) {
//           _buffers[2] = b;
//           year = val;
//           _clampDay();
//         }
//       }
//
//       _notifyChanged();
//     });
//   }
//
//   void _onBackspace() {
//     setState(() {
//       final b = _buffers[activePart];
//       if (b.isNotEmpty) {
//         _buffers[activePart] = b.substring(0, b.length - 1);
//       }
//       _notifyChanged();
//     });
//   }
//
//   void _onLeft() {
//     setState(() {
//       activePart = (activePart - 1 + 3) % 3;
//       _buffers[activePart] = '';
//     });
//   }
//
//   void _onRight() {
//     setState(() {
//       activePart = (activePart + 1) % 3;
//       _buffers[activePart] = '';
//     });
//   }
//
//   void _onEnter() {
//     widget.onSubmitted?.call(DateTime(year, month, day));
//   }
//
//   Widget _partBox(String text, bool active, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(6),
//           color: active ? Colors.blue.withOpacity(0.08) : Colors.transparent,
//         ),
//         child: Text(
//           text,
//           style: mozillaTextSemiBoldText(
//             fontSize: widget.fontSize,
//             fontWeight: active ? FontWeight.w700 : FontWeight.w500,
//             color: active ? Colors.blue.shade800 : Colors.black87,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _onRawKey(RawKeyEvent event) {
//     if (event is! RawKeyDownEvent) return;
//     final key = event.logicalKey;
//
//     if (key == LogicalKeyboardKey.arrowUp) return _onIncrementActive(1);
//     if (key == LogicalKeyboardKey.arrowDown) return _onIncrementActive(-1);
//     if (key == LogicalKeyboardKey.arrowLeft) return _onLeft();
//     if (key == LogicalKeyboardKey.arrowRight) return _onRight();
//     if (key == LogicalKeyboardKey.enter ||
//         key == LogicalKeyboardKey.numpadEnter) return _onEnter();
//     if (key == LogicalKeyboardKey.backspace) return _onBackspace();
//
//     final label = key.keyLabel;
//     if (label.length == 1 && RegExp(r'[0-9]').hasMatch(label)) {
//       _onDigit(int.parse(label));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dayText = day.toString().padLeft(2, '0');
//     final monthText = month.toString().padLeft(2, '0');
//     final yearText = year.toString();
//
//     return RawKeyboardListener(
//       focusNode: _focusNode,
//       autofocus: true,
//       onKey: _onRawKey,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(
//             color: widget.borderClr ?? DynamicColors.primaryClr,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 _partBox(dayText, activePart == 0, onTap: () {
//                   setState(() => activePart = 0);
//                   _focusNode.requestFocus();
//                 }),
//                 _separator(),
//                 _partBox(monthText, activePart == 1, onTap: () {
//                   setState(() => activePart = 1);
//                   _focusNode.requestFocus();
//                 }),
//                 _separator(),
//                 _partBox(yearText, activePart == 2, onTap: () {
//                   setState(() => activePart = 2);
//                   _focusNode.requestFocus();
//                 }),
//               ],
//             ),
//             Icon(
//               Icons.calendar_month,
//               size: widget.iconSize,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _separator() => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 6),
//     child: Text(
//       '/',
//       style: mozillaTextSemiBoldText(
//         fontSize: widget.fontSize,
//         fontWeight: FontWeight.w800,
//       ),
//     ),
//   );
// }



/// Keyboard-driven DatePicker widget (no packages)
/// Keyboard-driven DatePicker widget (no packages)
/// Keyboard-driven DatePicker widget (no packages)
// class KeyboardDatePicker extends StatefulWidget {
//   final DateTime initialDate;
//   final void Function(DateTime)? onChanged;
//   final void Function(DateTime)? onSubmitted;
//   Color? borderClr;
//   final double fontSize;
//   final double iconSize;
//   final bool allowPastDates;
//   final bool allowFutureDates;
//
//   static bool isAnyDatePickerFocused = false;
//
//   KeyboardDatePicker({
//     Key? key,
//     DateTime? initialDate,
//     this.onChanged,
//     this.onSubmitted,
//     this.borderClr,
//     this.fontSize = 12,
//     this.iconSize = 14,
//     this.allowPastDates = true,
//     this.allowFutureDates = true,
//   })  : initialDate = initialDate ?? DateTime(2000, 1, 1),
//         super(key: key);
//
//   @override
//   State<KeyboardDatePicker> createState() => _KeyboardDatePickerState();
// }
//
// class _KeyboardDatePickerState extends State<KeyboardDatePicker> {
//   late int day;
//   late int month;
//   late int year;
//
//   int activePart = 0; // 0: Day, 1: Month, 2: Year
//   final List<String> _buffers = ['', '', ''];
//   final FocusNode _focusNode = FocusNode();
//   final FocusNode _iconFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     day = widget.initialDate.day;
//     month = widget.initialDate.month;
//     year = widget.initialDate.year;
//
//     final dim = _daysInMonth(month, year);
//     if (day > dim) day = dim;
//     if (day < 1) day = 1;
//
//     _focusNode.addListener(_onFocusChange);
//     _iconFocusNode.addListener(_onFocusChange);
//   }
//
//   void _onFocusChange() {
//     KeyboardDatePicker.isAnyDatePickerFocused = _focusNode.hasFocus || _iconFocusNode.hasFocus;
//   }
//
//   @override
//   void dispose() {
//     _focusNode.removeListener(_onFocusChange);
//     _iconFocusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     _iconFocusNode.dispose();
//     super.dispose();
//   }
//
//   DateTime get _today {
//     final now = DateTime.now();
//     return DateTime(now.year, now.month, now.day);
//   }
//
//   DateTime? get _minDate => widget.allowPastDates ? null : _today;
//   DateTime? get _maxDate => widget.allowFutureDates ? null : _today;
//   DateTime get _currentDate => DateTime(year, month, day);
//
//   void _setDate(DateTime date) {
//     year = date.year;
//     month = date.month;
//     day = date.day;
//     _buffers[0] = '';
//     _buffers[1] = '';
//     _buffers[2] = '';
//   }
//
//   void _clampToBounds() {
//     final min = _minDate;
//     final max = _maxDate;
//     if (min != null && _currentDate.isBefore(min)) {
//       _setDate(min);
//     } else if (max != null && _currentDate.isAfter(max)) {
//       _setDate(max);
//     }
//   }
//
//   bool _isLeap(int y) {
//     return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
//   }
//
//   int _daysInMonth(int m, int y) {
//     if (m == 2) return _isLeap(y) ? 29 : 28;
//     if (m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12) return 31;
//     return 30;
//   }
//
//   void _notifyChanged() {
//     final dt = DateTime(year, month, day);
//     widget.onChanged?.call(dt);
//   }
//
//   void _onIncrementActive(int delta) {
//     setState(() {
//       if (activePart == 0) {
//         day += delta;
//         final dim = _daysInMonth(month, year);
//         if (day > dim) day = 1;
//         if (day < 1) day = dim;
//         _buffers[0] = '';
//       } else if (activePart == 1) {
//         month += delta;
//         if (month > 12) month = 1;
//         if (month < 1) month = 12;
//         final dim = _daysInMonth(month, year);
//         if (day > dim) day = dim;
//         _buffers[1] = '';
//       } else if (activePart == 2) {
//         year += delta;
//         if (year < 1) year = 1;
//         final dim = _daysInMonth(month, year);
//         if (day > dim) day = dim;
//         _buffers[2] = '';
//       }
//       _clampToBounds();
//       _notifyChanged();
//     });
//   }
//
//   void _onDigit(int d) {
//     setState(() {
//       final currentBuf = _buffers[activePart] + d.toString();
//
//       if (activePart == 0) {
//         int val = int.tryParse(currentBuf) ?? 0;
//         final dim = _daysInMonth(month, year);
//         if (currentBuf.length >= 2) {
//           if (val > dim) val = dim;
//           if (val < 1) val = 1;
//           day = val;
//           _buffers[0] = '';
//           activePart = 1; // 2 digits poore hone per agle part (Month) per jaye
//         } else {
//           _buffers[0] = currentBuf;
//           if (val > 0) day = val.clamp(1, dim);
//         }
//       } else if (activePart == 1) {
//         int val = int.tryParse(currentBuf) ?? 0;
//         if (currentBuf.length >= 2) {
//           if (val > 12) val = 12;
//           if (val < 1) val = 1;
//           month = val;
//           final dim = _daysInMonth(month, year);
//           if (day > dim) day = dim;
//           _buffers[1] = '';
//           activePart = 2; // 2 digits poore hone per Year per jaye
//         } else {
//           _buffers[1] = currentBuf;
//           if (val > 0) {
//             month = val.clamp(1, 12);
//             final dim = _daysInMonth(month, year);
//             if (day > dim) day = dim;
//           }
//         }
//       } else if (activePart == 2) {
//         _buffers[2] = currentBuf;
//         int val = int.tryParse(currentBuf) ?? 0;
//         if (val > 0) year = val;
//         if (_buffers[2].length >= 4) {
//           _buffers[2] = '';
//         }
//         final dim = _daysInMonth(month, year);
//         if (day > dim) day = dim;
//       }
//       _clampToBounds();
//       _notifyChanged();
//     });
//   }
//
//   void _onBackspace() {
//     setState(() {
//       final b = _buffers[activePart];
//       if (b.isNotEmpty) {
//         _buffers[activePart] = b.substring(0, b.length - 1);
//       } else {
//         // Backspace per pichle part per switch kare
//         if (activePart > 0) {
//           activePart--;
//           _buffers[activePart] = '';
//         }
//       }
//       _clampToBounds();
//       _notifyChanged();
//     });
//   }
//
//   void _onLeft() {
//     setState(() {
//       activePart = (activePart - 1 + 3) % 3;
//       _buffers[activePart] = '';
//     });
//   }
//
//   void _onRight() {
//     setState(() {
//       activePart = (activePart + 1) % 3;
//       _buffers[activePart] = '';
//     });
//   }
//
//   void _onEnter() {
//     setState(_clampToBounds);
//     widget.onSubmitted?.call(_currentDate);
//   }
//
//   Widget _partBox(String text, bool active, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4),
//           color: active ? Colors.blue.withOpacity(0.12) : Colors.transparent,
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: widget.fontSize,
//             fontWeight: active ? FontWeight.w700 : FontWeight.w500,
//             color: active ? Colors.blue.shade800 : Colors.black87,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _onRawKey(RawKeyEvent event) {
//     if (event is! RawKeyDownEvent) return;
//     final key = event.logicalKey;
//
//     if (key == LogicalKeyboardKey.arrowUp) {
//       _onIncrementActive(1);
//       return;
//     } else if (key == LogicalKeyboardKey.arrowDown) {
//       _onIncrementActive(-1);
//       return;
//     } else if (key == LogicalKeyboardKey.arrowLeft) {
//       _onLeft();
//       return;
//     } else if (key == LogicalKeyboardKey.arrowRight) {
//       _onRight();
//       return;
//     } else if (key == LogicalKeyboardKey.enter ||
//         key == LogicalKeyboardKey.numpadEnter) {
//       _onEnter();
//       return;
//     } else if (key == LogicalKeyboardKey.backspace) {
//       _onBackspace();
//       return;
//     }
//
//     final label = key.keyLabel;
//     if (label.length == 1 && RegExp(r'^[0-9]$').hasMatch(label)) {
//       final d = int.parse(label);
//       _onDigit(d);
//       return;
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final firstDate = _minDate ?? DateTime(2000);
//     final lastDate = _maxDate ?? DateTime(2101);
//     var initial = _currentDate;
//     if (initial.isBefore(firstDate)) initial = firstDate;
//     if (initial.isAfter(lastDate)) initial = lastDate;
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: firstDate,
//       lastDate: lastDate,
//     );
//
//     if (picked != null) {
//       setState(() {
//         day = picked.day;
//         month = picked.month;
//         year = picked.year;
//       });
//       _notifyChanged();
//       Future.delayed(const Duration(milliseconds: 100), () {
//         FocusScope.of(context).nextFocus();
//       });
//     } else {
//       _focusNode.requestFocus();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dayText = day.toString().padLeft(2, '0');
//     final monthText = month.toString().padLeft(2, '0');
//     final yearText = year.toString();
//
//     return RawKeyboardListener(
//       focusNode: _focusNode,
//       autofocus: true,
//       onKey: _onRawKey,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(color: widget.borderClr ?? Colors.blue),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 _partBox(dayText, activePart == 0, onTap: () {
//                   setState(() {
//                     activePart = 0;
//                     _buffers[0] = '';
//                     _focusNode.requestFocus();
//                   });
//                 }),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 2.0),
//                   child: Text('/', style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//                 _partBox(monthText, activePart == 1, onTap: () {
//                   setState(() {
//                     activePart = 1;
//                     _buffers[1] = '';
//                     _focusNode.requestFocus();
//                   });
//                 }),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 2.0),
//                   child: Text('/', style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//                 _partBox(yearText, activePart == 2, onTap: () {
//                   setState(() {
//                     activePart = 2;
//                     _buffers[2] = '';
//                     _focusNode.requestFocus();
//                   });
//                 }),
//               ],
//             ),
//             const SizedBox(width: 4),
//             Focus(
//               focusNode: _iconFocusNode,
//               onKey: (node, event) {
//                 if (event is RawKeyDownEvent) {
//                   if (event.logicalKey == LogicalKeyboardKey.enter ||
//                       event.logicalKey == LogicalKeyboardKey.space ||
//                       event.logicalKey == LogicalKeyboardKey.numpadEnter) {
//                     _selectDate(context);
//                     return KeyEventResult.handled;
//                   }
//                 }
//                 return KeyEventResult.ignored;
//               },
//               child: Builder(
//                 builder: (context) {
//                   final isIconFocused = Focus.of(context).hasFocus;
//                   return InkWell(
//                     borderRadius: BorderRadius.circular(4),
//                     onTap: () => _selectDate(context),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
//                       decoration: BoxDecoration(
//                         border: isIconFocused ? Border.all(color: Colors.blue, width: 1.5) : null,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Icon(
//                         Icons.calendar_month,
//                         size: widget.iconSize,
//                         color: isIconFocused ? Colors.blue.shade800 : null,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


/// Keyboard-driven DatePicker widget (no packages)
class KeyboardDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final void Function(DateTime)? onChanged;
  final void Function(DateTime)? onSubmitted;
  Color? borderClr;
  final double fontSize;
  final double iconSize;
  final bool allowPastDates;
  final bool allowFutureDates;

  // Static flag - track karega k date picker focused hai ya nahi
  static bool isAnyDatePickerFocused = false;

  KeyboardDatePicker({
    Key? key,
    DateTime? initialDate,
    this.onChanged,
    this.onSubmitted,
    this.borderClr,
    this.fontSize = 12,
    this.iconSize = 14,
    this.allowPastDates = true,
    this.allowFutureDates = true,
  })  : initialDate = initialDate ?? DateTime(2000, 1, 1),
        super(key: key);

  @override
  State<KeyboardDatePicker> createState() => _KeyboardDatePickerState();
}

class _KeyboardDatePickerState extends State<KeyboardDatePicker> {
  late int day;
  late int month;
  late int year;

  int activePart = 0;
  final List<String> _buffers = ['', '', ''];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    day = widget.initialDate.day;
    month = widget.initialDate.month;
    year = widget.initialDate.year;
    _clampDay();
    _clampToBounds();

    // Focus listener add karo
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    // Sirf static flag update karo - setState NAHI karna
    KeyboardDatePicker.isAnyDatePickerFocused = _focusNode.hasFocus;
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime? get _minDate => widget.allowPastDates ? null : _today;
  DateTime? get _maxDate => widget.allowFutureDates ? null : _today;

  DateTime get _currentDate => DateTime(year, month, day);

  void _setDate(DateTime date) {
    year = date.year;
    month = date.month;
    day = date.day;
    _buffers[0] = '';
    _buffers[1] = '';
    _buffers[2] = '';
  }

  void _clampToBounds() {
    final min = _minDate;
    final max = _maxDate;
    if (min != null && _currentDate.isBefore(min)) {
      _setDate(min);
    } else if (max != null && _currentDate.isAfter(max)) {
      _setDate(max);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  bool _isLeap(int y) {
    return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
  }

  int _daysInMonth(int m, int y) {
    if (m == 2) return _isLeap(y) ? 29 : 28;
    if (m == 1 ||
        m == 3 ||
        m == 5 ||
        m == 7 ||
        m == 8 ||
        m == 10 ||
        m == 12) return 31;
    return 30;
  }

  void _clampDay() {
    final dim = _daysInMonth(month, year);
    if (day > dim) day = dim;
    if (day < 1) day = 1;
  }

  void _notifyChanged() {
    final dt = DateTime(year, month, day);
    widget.onChanged?.call(dt);
  }

  void _onIncrementActive(int delta) {
    setState(() {
      final previousActivePart = activePart;

      if (activePart == 0) {
        // DAY
        day += delta;
        final dim = _daysInMonth(month, year);
        if (day > dim) day = 1;
        if (day < 1) day = dim;
      } else if (activePart == 1) {
        // MONTH
        month += delta;
        if (month > 12) month = 1;
        if (month < 1) month = 12;
        final dim = _daysInMonth(month, year);
        if (day > dim) day = dim;
      } else {
        // YEAR
        year += delta;
        if (year < 1) year = 1;
        final dim = _daysInMonth(month, year);
        if (day > dim) day = dim;
      }

      activePart = previousActivePart;
      _buffers[activePart] = '';
      _clampToBounds();
      _notifyChanged();
    });
  }

  void _onDigit(int d) {
    setState(() {
      final b = _buffers[activePart] + d.toString();
      if (activePart == 0) {
        final val = int.tryParse(b) ?? 0;
        if (val == 0) return;
        final dim = _daysInMonth(month, year);
        if (val > dim) {
          _buffers[activePart] = d.toString();
          final v2 = int.parse(_buffers[activePart]);
          day = v2.clamp(1, dim);
        } else {
          _buffers[activePart] = b;
          day = val.clamp(1, dim);
        }
      } else if (activePart == 1) {
        final val = int.tryParse(b) ?? 0;
        if (val == 0) return;
        if (val > 12) {
          _buffers[activePart] = d.toString();
          month = int.parse(_buffers[activePart]).clamp(1, 12);
        } else {
          _buffers[activePart] = b;
          month = val.clamp(1, 12);
        }
        _clampDay();
      } else {
        final val = int.tryParse(b) ?? 0;
        if (val == 0 && b.length > 0) {
          _buffers[activePart] = b.replaceFirst(RegExp(r'^0+'), '');
        } else {
          _buffers[activePart] = b;
          if (val > 0) year = val;
        }
        _clampDay();
      }
      _notifyChanged();
    });
  }

  void _onBackspace() {
    setState(() {
      final b = _buffers[activePart];
      if (b.isNotEmpty) {
        _buffers[activePart] = b.substring(0, b.length - 1);
        final newB = _buffers[activePart];
        if (newB.isNotEmpty) {
          final parsed = int.tryParse(newB);
          if (parsed != null) {
            if (activePart == 0) {
              day = parsed.clamp(1, _daysInMonth(month, year));
            } else if (activePart == 1) {
              month = parsed.clamp(1, 12);
              _clampDay();
            } else {
              year = parsed.clamp(1, 9999999);
              _clampDay();
            }
          }
        }
      }
      _notifyChanged();
    });
  }

  void _onLeft() {
    setState(() {
      activePart = (activePart - 1 + 3) % 3;
      _buffers[activePart] = '';
    });
  }

  void _onRight() {
    setState(() {
      activePart = (activePart + 1) % 3;
      _buffers[activePart] = '';
    });
  }

  void _onEnter() {
    setState(_clampToBounds);
    widget.onSubmitted?.call(_currentDate);
  }

  Widget _partBox(String text, bool active, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: active ? Colors.blue.withOpacity(0.06) : Colors.transparent,
        ),
        child: Text(
          text,
          style: mozillaTextSemiBoldText(
            fontSize: widget.fontSize,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? Colors.blue.shade800 : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _onRawKey(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp) {
      _onIncrementActive(1);
      return;
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _onIncrementActive(-1);
      return;
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      _onLeft();
      return;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _onRight();
      return;
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _onEnter();
      return;
    } else if (key == LogicalKeyboardKey.backspace) {
      _onBackspace();
      return;
    }

    final label = key.keyLabel;
    if (label.length == 1 && RegExp(r'^[0-9]$').hasMatch(label)) {
      final d = int.parse(label);
      _onDigit(d);
      return;
    }

    if (key == LogicalKeyboardKey.minus || key == LogicalKeyboardKey.numpadSubtract) {
      if (activePart == 2) _onIncrementActive(-1);
      return;
    }
    if (key == LogicalKeyboardKey.equal || key == LogicalKeyboardKey.numpadAdd) {
      if (activePart == 2) _onIncrementActive(1);
      return;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final firstDate = _minDate ?? DateTime(2000);
    final lastDate = _maxDate ?? DateTime(2101);
    var initial = _currentDate;
    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(lastDate)) initial = lastDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() {
        day = picked.day;
        month = picked.month;
        year = picked.year;
      });
      _notifyChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayText = day.toString().padLeft(2, '0');
    final monthText = month.toString().padLeft(2, '0');
    final yearText = year.toString();

    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: _onRawKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: widget.borderClr ?? DynamicColors.primaryClr),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _partBox(dayText, activePart == 0, onTap: () {
                  setState(() {
                    activePart = 0;
                    _focusNode.requestFocus();
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text('/', style: mozillaTextSemiBoldText(
                      context: context,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w800
                  ),),
                ),
                _partBox(monthText, activePart == 1, onTap: () {
                  setState(() {
                    activePart = 1;
                    _focusNode.requestFocus();
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text('/', style: mozillaTextSemiBoldText(
                      context: context,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w800
                  ),),
                ),
                _partBox(yearText, activePart == 2, onTap: () {
                  setState(() {
                    activePart = 2;
                    _focusNode.requestFocus();
                  });
                }),
              ],
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Icon(Icons.calendar_month,
                    size: widget.iconSize,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}