

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

  int selectedHour = 9;
  int selectedMinute = 8;
  // String selectedPeriod = "AM";

  @override
  void initState() {
    super.initState();
    _timeController = widget.controller ?? TextEditingController();
    _updateTimeText();
  }

  void _updateTimeText() {
    final hourStr = selectedHour.toString().padLeft(2, '0');
    final minuteStr = selectedMinute.toString().padLeft(2, '0');
    _timeController.text = "$hourStr:$minuteStr ";
  }

  void _toggleTimeDropdown() {
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
      builder: (context) => Positioned(
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

  //
  // Widget _buildAmPmColumn() {
  //   return Expanded(
  //     child: Column(
  //       children: ['AM', 'PM'].map((period) {
  //         final isSelected = period == selectedPeriod;
  //         return InkWell(
  //           onTap: () => _selectAndClose(period: period),
  //           child: Container(
  //             padding: EdgeInsets.all(12),
  //             color: isSelected ? Colors.blue : null,
  //             child: Center(
  //               child: Text(
  //                 period,
  //                 style: TextStyle(
  //                   color: isSelected ? Colors.white : Colors.black,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

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
            suffixIcon: const Icon(Icons.access_time, size: 18),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}



/// Keyboard-driven DatePicker widget (no packages)
class KeyboardDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final void Function(DateTime)? onChanged;
  final void Function(DateTime)? onSubmitted; // optional enter press
  Color? borderClr;

  KeyboardDatePicker({
    Key? key,
    DateTime? initialDate,
    this.onChanged,
    this.onSubmitted,
    this.borderClr,
  })  : initialDate = initialDate ?? DateTime(2000, 1, 1),
        super(key: key);

  @override
  State<KeyboardDatePicker> createState() => _KeyboardDatePickerState();
}

class _KeyboardDatePickerState extends State<KeyboardDatePicker> {
  late int day;
  late int month;
  late int year;

  /// 0 = day, 1 = month, 2 = year
  int activePart = 0;

  /// typed digits buffer per part (to allow multi-digit typing).
  final List<String> _buffers = ['', '', ''];

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    day = widget.initialDate.day;
    month = widget.initialDate.month;
    year = widget.initialDate.year;
    // normalize in case initial invalid
    _clampDay();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Leap year check
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
      if (activePart == 0) {
        day += delta;
        final dim = _daysInMonth(month, year);
        if (day > dim) day = 1;
        if (day < 1) day = dim;
      } else if (activePart == 1) {
        month += delta;
        if (month > 12) month = 1;
        if (month < 1) month = 12;
        _clampDay();
      } else {
        year += delta;
        if (year < 1) year = 1;
        _clampDay();
      }
      _buffers[activePart] = ''; // clear buffer when using arrows
      _notifyChanged();
    });
  }

  void _onDigit(int d) {
    setState(() {
      final b = _buffers[activePart] + d.toString();
      // max sensible length: day(2), month(2), year(4+)
      if (activePart == 0) {
        // day
        final val = int.tryParse(b) ?? 0;
        if (val == 0) return; // ignore leading zeros -> user can type 0 then 5 etc.
        final dim = _daysInMonth(month, year);
        if (val > dim) {
          // if typed > allowed, replace buffer with single digit
          _buffers[activePart] = d.toString();
          final v2 = int.parse(_buffers[activePart]);
          day = v2.clamp(1, dim);
        } else {
          _buffers[activePart] = b;
          day = val.clamp(1, dim);
        }
      } else if (activePart == 1) {
        // month
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
        // year - allow many digits, but limit to positive int
        final val = int.tryParse(b) ?? 0;
        if (val == 0 && b.length > 0) {
          // started with 0 -> ignore leading zero
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
        if (newB.isEmpty) {
          // revert to current value but don't change numeric value
        } else {
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
      } else {
        // if buffer empty then clear value back to defaults? We'll keep current value.
      }
      _notifyChanged();
    });
  }

  void _onLeft() {
    setState(() {
      activePart = (activePart - 1 + 3) % 3;
      // clear buffer when moving
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
    widget.onSubmitted?.call(DateTime(year, month, day));
  }

  Widget _partBox(String text, bool active, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        decoration: BoxDecoration(
          // border: Border.all(color: active ? Colors.blue : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(6),
          color: active ? Colors.blue.withOpacity(0.06) : Colors.transparent,
        ),
        child: Text(
          text,
          style: mozillaTextSemiBoldText(
            fontSize: 10,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? Colors.blue.shade800 : Colors.black87,
          ),
        ),
      ),
    );
  }

  // handle physical keyboard
  void _onRawKey(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;
    final key = event.logicalKey;
    // arrows
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

    // digits (both numpad and top row)
    final label = key.keyLabel;
    if (label.length == 1 && RegExp(r'^[0-9]$').hasMatch(label)) {
      final d = int.parse(label);
      _onDigit(d);
      return;
    }

    // optionally allow +/- keys to change year quickly
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        day = picked.day;
        month = picked.month;
        year = picked.year;
      });
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
          border: Border.all(color: widget.borderClr?? DynamicColors.primaryClr),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
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
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text('/', style: mozillaTextSemiBoldText(
                      context: context,
                      fontSize: 10,
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
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text('/', style: mozillaTextSemiBoldText(
                      context: context,
                      fontSize: 10,
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
            GestureDetector(
              onTap: (){
                _selectDate(context);
              },
              child: Icon(Icons.calendar_month,
              size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
