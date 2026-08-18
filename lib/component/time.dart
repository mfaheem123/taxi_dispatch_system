import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTimePickerWidget extends StatefulWidget {
  final String label;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay>? onTimeChanged;

  const CustomTimePickerWidget({
    Key? key,
    required this.label,
    this.initialTime = const TimeOfDay(hour: 12, minute: 0),
    this.onTimeChanged,
  }) : super(key: key);

  @override
  State<CustomTimePickerWidget> createState() => _CustomTimePickerWidgetState();
}

class _CustomTimePickerWidgetState extends State<CustomTimePickerWidget> {
  late TimeOfDay _selectedTime;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Time Dialog Open karne ka logic
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      if (widget.onTimeChanged != null) {
        widget.onTimeChanged!(_selectedTime);
      }
    }
  }

  // Arrow Keys se Time (+1 / -1 minute) Change karne ka logic
  void _adjustTime(int minuteDelta) {
    int totalMinutes = _selectedTime.hour * 60 + _selectedTime.minute + minuteDelta;
    if (totalMinutes < 0) totalMinutes += 24 * 60;
    totalMinutes %= 24 * 60;

    setState(() {
      _selectedTime = TimeOfDay(
        hour: totalMinutes ~/ 60,
        minute: totalMinutes % 60,
      );
    });

    if (widget.onTimeChanged != null) {
      widget.onTimeChanged!(_selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const _IncrementIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const _DecrementIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) => _selectTime(context),
          ),
          _IncrementIntent: CallbackAction<_IncrementIntent>(
            onInvoke: (_IncrementIntent intent) => _adjustTime(1),
          ),
          _DecrementIntent: CallbackAction<_DecrementIntent>(
            onInvoke: (_DecrementIntent intent) => _adjustTime(-1),
          ),
        },
        child: Focus(
          focusNode: _focusNode,
          onFocusChange: (hasFocus) {
            setState(() {}); // Highlight border change karne ke liye
          },
          child: GestureDetector(
            onTap: () {
              _focusNode.requestFocus();
              _selectTime(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  // Keyboard Highlight Color
                  color: _focusNode.hasFocus ? Colors.blue : Colors.grey.shade400,
                  width: _focusNode.hasFocus ? 2.5 : 1.0,
                ),
                boxShadow: _focusNode.hasFocus
                    ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    color: _focusNode.hasFocus ? Colors.blue : Colors.grey[700],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _focusNode.hasFocus ? Colors.blue : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedTime.format(context),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Intents for Arrow Keys
class _IncrementIntent extends Intent {
  const _IncrementIntent();
}

class _DecrementIntent extends Intent {
  const _DecrementIntent();
}