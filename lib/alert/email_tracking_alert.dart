import 'package:flutter/material.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/textStyle.dart';

class EmailContentAlert extends StatelessWidget {
  final String emailContent;

  const EmailContentAlert({
    super.key,
    required this.emailContent,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.email_outlined, color: DynamicColors.primaryClr),
                  const SizedBox(width: 10),
                  Text(
                    "EMAIL CONTENT",
                    style: mozillaTextSemiBoldText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const FocusTraversalOrder(
                    order: NumericFocusOrder(999),
                    child: AlertCloseButton(),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 15),

            // --- CONTENT BODY ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Text(
                    emailContent.isNotEmpty ? emailContent : "No content available",
                    style: mozillaTextRegularText(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}