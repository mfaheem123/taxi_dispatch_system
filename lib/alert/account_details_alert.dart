import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

class AccountDetailsAlert extends StatelessWidget {
  final String? information;
  const AccountDetailsAlert({super.key, this.information});

  @override
  Widget build(BuildContext context) {
    final displayText = (information != null && information!.trim().isNotEmpty)
        ? information!
        : "API data will appear here...";

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: DynamicColors.secondaryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: DynamicColors.primaryClr),
                  const SizedBox(width: 10),
                  Text("ACCOUNT DETAILS", style: titleDesign()),
                  const Spacer(),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(999),
                    child: const AlertCloseButton(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Text(
                displayText,
                style:  outFitRegular(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    width: 80,
                    height: 28,
                    verticalPadding: 0.0,
                    btnText: "CLOSE",
                    btnColor: Colors.red,
                    borderRadius: 4,
                    style: mozillaTextSemiBoldText(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            ),
          ]
        )),
    );
  }
}