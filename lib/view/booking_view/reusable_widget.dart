




import 'package:flutter/material.dart';

import '../../component/textStyle.dart';
import '../../component/text_widget.dart';

Widget customWidget({value, ValueChanged<bool?>? onChanged, String? text}){
  return SizedBox(
    width: 120,
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
            fontSize: 12,
          ),
        )
      ],
    ),
  );
}