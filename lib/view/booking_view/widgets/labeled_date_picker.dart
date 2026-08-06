// labeled_date_picker.dart
//
// Date field backed by a react-datepicker-style dropdown calendar.
//
// Ported from the dashboard booking form so both forms behave identically:
//   * a single Tab stop — icon, border and value take the accent color;
//   * Enter / Space / Down (or a click) opens an Overlay panel under the field,
//     NOT a modal dialog;
//   * inside the panel: ‹ › page the month, the title toggles the month / year
//     grids, arrows move the selection, PageUp/PageDown page, Enter confirms,
//     Esc closes.
//
// See create_new_booking_form.dart for how this fits into the wider form.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'booking_form_layout.dart';

/// Date field backed by the same dropdown calendar the dashboard booking form
/// uses: one Tab stop, Enter / Space / Down opens a calendar anchored under the
/// field, arrow keys move the day, Enter confirms and Esc closes.
class LabeledDatePicker extends StatefulWidget implements LabelledField {
  @override
  final String label;
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onChanged;
  const LabeledDatePicker(this.label,
      {super.key, this.initialDate, this.onChanged});

  @override
  State<LabeledDatePicker> createState() => _LabeledDatePickerState();
}

class _LabeledDatePickerState extends State<LabeledDatePicker> {
  late DateTime _date = widget.initialDate ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return FieldShell(
      label: widget.label,
      child: _CalendarDropdownField(
        value: _date,
        accent: accent,
        accentSoft: accent.withValues(alpha: 0.12),
        idleColor: Colors.grey,
        textStyle: const TextStyle(
            fontSize: Density.fieldFont, color: Colors.black87),
        onChanged: (d) {
          setState(() => _date = d);
          widget.onChanged?.call(d);
        },
      ),
    );
  }
}

class _CalendarDropdownField extends StatefulWidget {
  const _CalendarDropdownField({
    required this.value,
    required this.onChanged,
    required this.textStyle,
    required this.accent,
    required this.accentSoft,
    required this.idleColor,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final TextStyle textStyle;
  final Color accent;
  final Color accentSoft;
  final Color idleColor;

  @override
  State<_CalendarDropdownField> createState() => _CalendarDropdownFieldState();
}

class _CalendarDropdownFieldState extends State<_CalendarDropdownField> {
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', //
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  static const _weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  // 0 = days, 1 = months, 2 = years
  static const _viewDays = 0;
  static const _viewMonths = 1;
  static const _viewYears = 2;

  final LayerLink _link = LayerLink();
  final FocusNode _fieldFocus = FocusNode(debugLabel: 'dateField');
  final FocusNode _calendarFocus = FocusNode(debugLabel: 'dateCalendar');
  final GlobalKey _fieldKey = GlobalKey();
  // Shared so a tap on the field is NOT treated as "outside" the calendar
  // (otherwise the field click closes via TapRegion AND reopens via InkWell).
  final Object _tapGroupId = Object();
  OverlayEntry? _entry;

  bool _focused = false;
  int _view = _viewDays;
  late DateTime _visibleMonth; // first-of-month being displayed
  DateTime? _selected;
  late int _yearPageStart;

  @override
  void initState() {
    super.initState();
    _fieldFocus.addListener(_onFocusChange);
    _selected = widget.value;
    final base = widget.value ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
    _yearPageStart = base.year - 5;
  }

  @override
  void didUpdateWidget(covariant _CalendarDropdownField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _selected = widget.value;
      if (widget.value != null) {
        _visibleMonth = DateTime(widget.value!.year, widget.value!.month);
      }
    }
  }

  @override
  void dispose() {
    _closeCalendar(notify: false);
    _fieldFocus.removeListener(_onFocusChange);
    _fieldFocus.dispose();
    _calendarFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focused != _fieldFocus.hasFocus) {
      setState(() => _focused = _fieldFocus.hasFocus);
    }
  }

  bool get _isOpen => _entry != null;

  void _toggleCalendar() => _isOpen ? _closeCalendar() : _openCalendar();

  void _openCalendar() {
    if (_isOpen) return;
    _view = _viewDays;
    final base = _selected ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
    _entry = OverlayEntry(builder: _buildCalendarPanel);
    Overlay.of(context).insert(_entry!);
    setState(() {}); // refresh field chrome (arrow / accent)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _calendarFocus.requestFocus();
    });
  }

  void _closeCalendar({bool notify = true}) {
    _entry?.remove();
    _entry = null;
    if (notify && mounted) setState(() {});
  }

  void _rebuildPanel() => _entry?.markNeedsBuild();

  void _setView(int v) {
    if (v == _viewYears) _yearPageStart = _visibleMonth.year - 5;
    _view = v;
    _rebuildPanel();
  }

  void _navPrev() {
    if (_view == _viewDays) {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    } else if (_view == _viewMonths) {
      _visibleMonth = DateTime(_visibleMonth.year - 1, _visibleMonth.month);
    } else {
      _yearPageStart -= 12;
    }
    _rebuildPanel();
  }

  void _navNext() {
    if (_view == _viewDays) {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    } else if (_view == _viewMonths) {
      _visibleMonth = DateTime(_visibleMonth.year + 1, _visibleMonth.month);
    } else {
      _yearPageStart += 12;
    }
    _rebuildPanel();
  }

  void _pick(DateTime day) {
    _selected = DateTime(day.year, day.month, day.day);
    widget.onChanged(_selected!);
    _closeCalendar();
    _fieldFocus.requestFocus();
  }

  void _moveSelection(int days) {
    final base = _selected ?? _visibleMonth;
    final next = DateTime(base.year, base.month, base.day + days);
    _selected = next;
    _visibleMonth = DateTime(next.year, next.month);
    _view = _viewDays;
    _rebuildPanel();
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _format(DateTime? v) {
    if (v == null) return '';
    final d = v.day.toString().padLeft(2, '0');
    final m = v.month.toString().padLeft(2, '0');
    return '$d / $m / ${v.year}';
  }

  // ── field key handling: open the calendar
  KeyEventResult _onFieldKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.enter ||
        k == LogicalKeyboardKey.numpadEnter ||
        k == LogicalKeyboardKey.space ||
        k == LogicalKeyboardKey.arrowDown) {
      _openCalendar();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ── calendar key handling: navigate / confirm / close
  KeyEventResult _onCalendarKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.arrowLeft) {
      _moveSelection(-1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowRight) {
      _moveSelection(1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp) {
      _moveSelection(-7);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown) {
      _moveSelection(7);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.pageUp) {
      _navPrev();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.pageDown) {
      _navNext();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.numpadEnter) {
      _pick(_selected ?? _visibleMonth);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.escape) {
      _closeCalendar();
      _fieldFocus.requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ──────────────────────────────── field
  @override
  Widget build(BuildContext context) {
    final highlight = _focused || _isOpen;
    final iconColor = highlight ? widget.accent : widget.idleColor;

    // No `label:` here — FieldShell already renders the caption above or
    // beside the field, exactly like every other field in this form.
    final decoration = InputDecoration(
      prefixIconConstraints:
          const BoxConstraints(minWidth: 28, minHeight: 0),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 8, right: 4),
        child: Icon(Icons.calendar_today, size: 14, color: iconColor),
      ),
      suffixIconConstraints:
          const BoxConstraints(minWidth: 28, minHeight: 0),
      suffixIcon: Icon(
        _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        size: 20,
        color: iconColor,
      ),
    );

    return TapRegion(
      groupId: _tapGroupId,
      child: CompositedTransformTarget(
        link: _link,
        child: Focus(
          focusNode: _fieldFocus,
          onKeyEvent: _onFieldKey,
          child: InkWell(
            key: _fieldKey,
            canRequestFocus: false,
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              _fieldFocus.requestFocus();
              _toggleCalendar();
            },
            child: InputDecorator(
              isFocused: highlight,
              decoration: decoration,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: highlight
                    ? BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(3),
                      )
                    : null,
                child: Text(
                  _format(widget.value),
                  overflow: TextOverflow.ellipsis,
                  style: widget.textStyle.copyWith(
                    color: highlight ? widget.accent : widget.textStyle.color,
                    fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────── calendar popup
  Widget _buildCalendarPanel(BuildContext context) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth = box?.size.width ?? 280.0;
    final fieldHeight = box?.size.height ?? 40.0;
    final panelWidth = fieldWidth < 300 ? 300.0 : fieldWidth;

    return Positioned(
      width: panelWidth,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        offset: Offset(0, fieldHeight + 4),
        child: TapRegion(
          groupId: _tapGroupId,
          onTapOutside: (_) => _closeCalendar(),
          child: Focus(
            focusNode: _calendarFocus,
            onKeyEvent: _onCalendarKey,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _header(),
                    const SizedBox(height: 8),
                    if (_view == _viewDays) ...[
                      _weekdayRow(),
                      const SizedBox(height: 4),
                      _daysGrid(),
                    ] else if (_view == _viewMonths)
                      _monthsGrid()
                    else
                      _yearsGrid(),
                    const SizedBox(height: 6),
                    _footer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final String title = _view == _viewYears
        ? '$_yearPageStart - ${_yearPageStart + 11}'
        : '${_months[_visibleMonth.month - 1]} ${_visibleMonth.year}';
    return Row(
      children: [
        _navButton(Icons.chevron_left, _navPrev),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => _setView(_view == _viewDays ? _viewYears : _viewDays),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: widget.accent,
                  ),
                ),
              ),
            ),
          ),
        ),
        _navButton(Icons.chevron_right, _navNext),
      ],
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) => InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: widget.accent),
        ),
      );

  Widget _weekdayRow() => Row(
        children: [
          for (final w in _weekdays)
            Expanded(
              child: Center(
                child: Text(
                  w,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: widget.accent.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
        ],
      );

  Widget _daysGrid() {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday % 7; // Sunday = 0
    final today = DateTime.now();

    final cells = <Widget>[];
    for (var i = 0; i < leadingBlanks; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var d = 1; d <= daysInMonth; d++) {
      final day = DateTime(_visibleMonth.year, _visibleMonth.month, d);
      final isSelected = _selected != null && _sameDay(_selected!, day);
      final isToday = _sameDay(today, day);
      cells.add(_dayCell(d, isSelected, isToday, () => _pick(day)));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      childAspectRatio: 1.1,
      children: cells,
    );
  }

  Widget _dayCell(int day, bool selected, bool today, VoidCallback onTap) {
    Color bg = Colors.transparent;
    Color fg = Colors.black87;
    if (selected) {
      bg = widget.accent;
      fg = Colors.white;
    } else if (today) {
      bg = widget.accentSoft;
      fg = widget.accent;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: today && !selected
              ? Border.all(color: widget.accent, width: 1)
              : null,
        ),
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 12,
            color: fg,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _monthsGrid() => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.8,
        children: [
          for (var m = 1; m <= 12; m++)
            _chip(
              _months[m - 1].substring(0, 3),
              m == _visibleMonth.month,
              () {
                _visibleMonth = DateTime(_visibleMonth.year, m);
                _setView(_viewDays);
              },
            ),
        ],
      );

  Widget _yearsGrid() => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.8,
        children: [
          for (var i = 0; i < 12; i++)
            _chip(
              '${_yearPageStart + i}',
              (_yearPageStart + i) == _visibleMonth.year,
              () {
                _visibleMonth = DateTime(_yearPageStart + i, _visibleMonth.month);
                _setView(_viewMonths);
              },
            ),
        ],
      );

  Widget _chip(String label, bool selected, VoidCallback onTap) => InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? widget.accent : widget.accentSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : widget.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  Widget _footer() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _pick(DateTime.now()),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Today',
              style: TextStyle(
                  color: widget.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () {
              _closeCalendar();
              _fieldFocus.requestFocus();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
}
