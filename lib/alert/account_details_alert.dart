import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

class AccountDetailsAlert extends StatefulWidget {
  const AccountDetailsAlert({super.key});

  @override
  State<AccountDetailsAlert> createState() => _AccountDetailsAlertState();
}

class _AccountDetailsAlertState extends State<AccountDetailsAlert> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: DynamicColors.primaryClr),
                  const SizedBox(width: 10),
                  Text ( "ACCOUNT DETAILS", style: titleDesign()),
                  const Spacer(),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(999),
                    child: const AlertCloseButton(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: TextField(
                maxLines: null,
                readOnly: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "API data will appear here...",
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
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