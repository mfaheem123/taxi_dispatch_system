import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditableCellWidget extends StatefulWidget {
  final dynamic initialValue;
  final Function(String) onChanged;

  const EditableCellWidget({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<EditableCellWidget> createState() => _EditableCellWidgetState();
}

class _EditableCellWidgetState extends State<EditableCellWidget> {
  late TextEditingController _controller;
  String _lastValidText = "0";
  bool _isNewFocus = true;

  @override
  void initState() {
    super.initState();
    String valStr = widget.initialValue?.toString() ?? "0";
    if (valStr.isEmpty) valStr = "0";
    _lastValidText = valStr;
    _controller = TextEditingController(text: valStr);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        child: TextFormField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
          ],
          style: const TextStyle(fontSize: 11),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            border: OutlineInputBorder(),
          ),
          onTap: () {
            if (_lastValidText == "0" || _lastValidText == "0.0" || _lastValidText == "0.00") {
              _isNewFocus = true;
              Future.delayed(const Duration(milliseconds: 50), () {
                if (mounted) {
                  _controller.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _controller.text.length,
                  );
                }
              });
            }
          },
          onChanged: (val) {
            if (val.isEmpty) {
              _lastValidText = "";
              widget.onChanged("");
              return;
            }
            // if (val.isEmpty) {
            //   _controller.text = _lastValidText;
            //   _controller.selection = TextSelection.fromPosition(
            //     TextPosition(offset: _controller.text.length),
            //   );
            //   return;
            // }

            if (_lastValidText == "0" || _lastValidText == "0.00" || _lastValidText == "0.0") {
              _isNewFocus = false;
              _lastValidText = val;
              widget.onChanged(val);
              return;
            }

            if (_isNewFocus) {
              _isNewFocus = false;
            }

            _lastValidText = val;
            widget.onChanged(val);
          },
        ),
      ),
    );
  }
}