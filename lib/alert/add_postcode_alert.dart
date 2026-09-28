import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';

import '../component/alert_close_button.dart';

class AddPostcodeDialog extends StatelessWidget {
  final Function(String) onSave;

  const AddPostcodeDialog({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Text(
                      "POSTCODE",
                      style:titleDesign()
                    ),
                    const Spacer(),
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(999),
                      child: const AlertCloseButton(),
                    ),
                  ],
                )),
            const Divider(height: 1, thickness: 1),
            SizedBox(height: 15),

            // Field Label
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "POSTCODE",
                        style: mozillaTextSemiBoldText(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Text Field
                      TextField(
                        controller: textController,
                        inputFormatters: [UpperCaseTextFormatter()],
                        decoration: InputDecoration(
                          hintText: "ENTER POSTCODE",
                          hintStyle: outFitRegular(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: DynamicColors.primaryClr ?? Colors.blue),
                          ),
                        ),
                      )
                    ])),
            SizedBox(height: 15),
            const Divider(height: 1),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    width: 80,
                    height: 28,
                    verticalPadding: 0.0,
                    btnText: AppText.clear,
                    btnColor: Colors.red,
                    onTap: () => Navigator.pop(context),
                    borderRadius: 6,
                    style: mozillaTextSemiBoldText(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    width: 80,
                    height: 28,
                    verticalPadding: 0.0,
                    borderRadius: 6,
                    btnText: AppText.save,
                    onTap: () {
                      final code = textController.text.trim();
                      if (code.isNotEmpty) {
                        onSave(code);
                        Navigator.pop(context);
                      }
                    },
                    style: mozillaTextSemiBoldText(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
