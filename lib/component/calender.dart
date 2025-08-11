import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
/*
class CustomCalendarDropdown extends StatefulWidget {
  const CustomCalendarDropdown({Key? key}) : super(key: key);

  @override
  State<CustomCalendarDropdown> createState() => _CustomCalendarDropdownState();
}

class _CustomCalendarDropdownState extends State<CustomCalendarDropdown> {
  final TextEditingController _controller = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  OverlayEntry? _calendarOverlay;
  final LayerLink _layerLink = LayerLink();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller.text = _dateFormat.format(selectedDate);
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
          showWhenUnlinked: true,
          child: SizedBox(
            width: 250, // <-- width change here
            height: 250, // <-- height change here
            child: TableCalendar(
              focusedDay: selectedDate,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(

                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) =>
                  isSameDay(selectedDate, day),
              onDaySelected: (selected, focused) {
                setState(() {
                  selectedDate = selected;
                  _controller.text = _dateFormat.format(selected);
                });
                _toggleCalendar();
              },
            ),
          ),*//*Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 250, // <-- width change here
              height: 250, // <-- height change here
              child: TableCalendar(
                focusedDay: selectedDate,
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                selectedDayPredicate: (day) =>
                    isSameDay(selectedDate, day),
                onDaySelected: (selected, focused) {
                  setState(() {
                    selectedDate = selected;
                    _controller.text = _dateFormat.format(selected);
                  });
                  _toggleCalendar();
                },
              ),
            ),
          )*//*
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: 30,
        child: TextFormField(
          controller: _controller,
          readOnly: true,
          onTap: _toggleCalendar,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 8),
            suffixIcon: Icon(Icons.calendar_today, size: 15),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}*/

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
            child: ClipRect(
              child: SizedBox(
                height: 250, // calendar ka final height
                width: 250,
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




// class CustomDropdownCalendar extends StatefulWidget {
//   @override
//   State<CustomDropdownCalendar> createState() => _CustomDropdownCalendarState();
// }
//
// class _CustomDropdownCalendarState extends State<CustomDropdownCalendar> {
//   DateTime selectedDate = DateTime.now();
//   DateTime displayMonth = DateTime.now();
//   bool showCalendar = false;
//
//   List<String> months = [
//     "January",
//     "February",
//     "March",
//     "April",
//     "May",
//     "June",
//     "July",
//     "August",
//     "September",
//     "October",
//     "November",
//     "December"
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 showCalendar = !showCalendar;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     DateFormat("dd/MM/yyyy").format(selectedDate),
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(width: 10),
//                   Icon(Icons.calendar_today, size: 18),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//         // Dropdown Calendar
//         if (showCalendar)
//           Positioned(
//             left: 20,
//             top: 80,
//             child: Material(
//               elevation: 4,
//               child: Container(
//                 width: 280,
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(6),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   children: [
//                     // Month-Year Selector with arrows
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 displayMonth = DateTime(displayMonth.year,
//                                     displayMonth.month - 1);
//                               });
//                             },
//                             icon: Icon(Icons.arrow_upward)),
//                         DropdownButton<String>(
//                           value: months[displayMonth.month - 1],
//                           items: months
//                               .map((m) =>
//                               DropdownMenuItem(value: m, child: Text(m)))
//                               .toList(),
//                           onChanged: (val) {
//                             if (val != null) {
//                               setState(() {
//                                 displayMonth = DateTime(
//                                     displayMonth.year,
//                                     months.indexOf(val) + 1);
//                               });
//                             }
//                           },
//                         ),
//                         DropdownButton<int>(
//                           value: displayMonth.year,
//                           items: List.generate(
//                               50, (i) => DateTime.now().year - 25 + i)
//                               .map((y) =>
//                               DropdownMenuItem(value: y, child: Text("$y")))
//                               .toList(),
//                           onChanged: (val) {
//                             if (val != null) {
//                               setState(() {
//                                 displayMonth =
//                                     DateTime(val, displayMonth.month);
//                               });
//                             }
//                           },
//                         ),
//                         IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 displayMonth = DateTime(displayMonth.year,
//                                     displayMonth.month + 1);
//                               });
//                             },
//                             icon: Icon(Icons.arrow_downward)),
//                       ],
//                     ),
//                     Divider(),
//
//                     // Weekdays Row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
//                           .map((d) => Expanded(
//                           child: Center(
//                             child: Text(d,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                           )))
//                           .toList(),
//                     ),
//
//                     // Days Grid
//                     ..._buildCalendarDays(),
//
//                     Divider(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 selectedDate = DateTime.now();
//                                 displayMonth = DateTime.now();
//                                 showCalendar = false;
//                               });
//                             },
//                             child: Text("Today")),
//                         TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 selectedDate = DateTime.now();
//                                 showCalendar = false;
//                               });
//                             },
//                             child: Text("Clear")),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   List<Widget> _buildCalendarDays() {
//     List<Widget> rows = [];
//     DateTime firstDayOfMonth =
//     DateTime(displayMonth.year, displayMonth.month, 1);
//     int weekday = firstDayOfMonth.weekday % 7; // Sunday = 0
//     int daysInMonth =
//         DateTime(displayMonth.year, displayMonth.month + 1, 0).day;
//
//     List<Widget> currentRow = [];
//     for (int i = 0; i < weekday; i++) {
//       currentRow.add(Expanded(child: Container()));
//     }
//
//     for (int day = 1; day <= daysInMonth; day++) {
//       currentRow.add(Expanded(
//         child: GestureDetector(
//           onTap: () {
//             setState(() {
//               selectedDate = DateTime(displayMonth.year, displayMonth.month, day);
//               showCalendar = false;
//             });
//           },
//           child: Container(
//             margin: EdgeInsets.all(2),
//             decoration: BoxDecoration(
//               color: selectedDate.day == day &&
//                   selectedDate.month == displayMonth.month &&
//                   selectedDate.year == displayMonth.year
//                   ? Colors.blue
//                   : null,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             padding: EdgeInsets.symmetric(vertical: 8),
//             child: Center(
//               child: Text(
//                 "$day",
//                 style: TextStyle(
//                     color: selectedDate.day == day &&
//                         selectedDate.month == displayMonth.month &&
//                         selectedDate.year == displayMonth.year
//                         ? Colors.white
//                         : Colors.black),
//               ),
//             ),
//           ),
//         ),
//       ));
//
//       if (currentRow.length == 7) {
//         rows.add(Row(children: currentRow));
//         currentRow = [];
//       }
//     }
//
//     if (currentRow.isNotEmpty) {
//       while (currentRow.length < 7) {
//         currentRow.add(Expanded(child: Container()));
//       }
//       rows.add(Row(children: currentRow));
//     }
//
//     return rows;
//   }
// }

