

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CalendarDropdown extends StatefulWidget {
  const CalendarDropdown({Key? key}) : super(key: key);

  @override
  State<CalendarDropdown> createState() => _CalendarDropdownState();
}

class _CalendarDropdownState extends State<CalendarDropdown> {
  final TextEditingController _controller = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  OverlayEntry? _calendarOverlay;
  final LayerLink _layerLink = LayerLink();

  DateTime? selectedDate;
  int _selectedPart = 0; // 0 = day, 1 = month, 2 = year

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _controller.text = _dateFormat.format(selectedDate!);
    _selectPart(0);
  }

  void _toggleCalendar() {
    if (_calendarOverlay == null) {
      _calendarOverlay = _createCalendarOverlay();
      Overlay.of(context).insert(_calendarOverlay!);
    } else {
      _calendarOverlay?.remove();
      _calendarOverlay = null;
    }
  }

  OverlayEntry _createCalendarOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 55),
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: CalendarDatePicker(
              initialDate: selectedDate!,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onDateChanged: (picked) {
                setState(() {
                  selectedDate = picked;
                  _controller.text = _dateFormat.format(picked);
                });
                _toggleCalendar();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _selectPart(int partIndex) {
    _selectedPart = partIndex;
    int start = 0, end = 0;
    switch (partIndex) {
      case 0: // Day
        start = 0;
        end = 2;
        break;
      case 1: // Month
        start = 3;
        end = 5;
        break;
      case 2: // Year
        start = 6;
        end = 10;
        break;
    }
    _controller.selection = TextSelection(baseOffset: start, extentOffset: end);
  }

  void _changeValue(int delta) {
    if (selectedDate == null) return;

    DateTime newDate = selectedDate!;

    if (_selectedPart == 0) {
      // Day increment/decrement
      newDate = DateTime(newDate.year, newDate.month,
          newDate.day + delta); // automatic date adjust
    } else if (_selectedPart == 1) {
      // Month increment/decrement
      int newMonth = (newDate.month + delta).clamp(1, 12);
      newDate = DateTime(newDate.year, newMonth,
          newDate.day.clamp(1, _daysInMonth(newDate.year, newMonth)));
    } else if (_selectedPart == 2) {
      // Year increment/decrement
      int newYear = (newDate.year + delta).clamp(2000, 2100);
      newDate = DateTime(newYear, newDate.month,
          newDate.day.clamp(1, _daysInMonth(newYear, newDate.month)));
    }

    setState(() {
      selectedDate = newDate;
      _controller.text = _dateFormat.format(newDate);
      _selectPart(_selectedPart); // selection maintain
    });
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  void dispose() {
    _controller.dispose();
    _calendarOverlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CompositedTransformTarget(
        link: _layerLink,
        child: SizedBox(
          height: 30,
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              if (event is RawKeyDownEvent) {
                if (event.logicalKey.keyLabel == 'Arrow Left') {
                  setState(() {
                    _selectedPart = (_selectedPart - 1).clamp(0, 2);
                    _selectPart(_selectedPart);
                  });
                } else if (event.logicalKey.keyLabel == 'Arrow Right') {
                  setState(() {
                    _selectedPart = (_selectedPart + 1).clamp(0, 2);
                    _selectPart(_selectedPart);
                  });
                } else if (event.logicalKey.keyLabel == 'Arrow Up') {
                  _changeValue(1);
                } else if (event.logicalKey.keyLabel == 'Arrow Down') {
                  _changeValue(-1);
                }
              }
            },
            child: TextFormField(
              controller: _controller,
              readOnly: true,
              onTap: _toggleCalendar,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 6),
                suffix: Icon(Icons.calendar_today, size: 15),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}