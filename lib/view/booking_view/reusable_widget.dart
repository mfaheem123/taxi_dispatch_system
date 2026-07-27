




import 'package:flutter/material.dart';

import '../../component/textStyle.dart';
import '../../component/text_widget.dart';

Widget customWidget({value, ValueChanged<bool?>? onChanged, String? text, double? width}){
  return SizedBox(
    width: width?? 120,
    child: Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
          ),
        ),
        Text(text ?? AppText.completed,
          style: mozillaTextRegularText(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        )
      ],
    ),
  );
}