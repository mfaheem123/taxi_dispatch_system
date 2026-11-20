import 'package:flutter/material.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../view/cabflow_stripe_screen.dart';

class PaymentLinkAlert extends StatelessWidget {
  final String fareAmount;
  final VoidCallback? onOpenLink;
  final VoidCallback? onCopy;
  final VoidCallback? onSendSms;
  final VoidCallback? onSendEmail;

  const PaymentLinkAlert({
    super.key,
    this.fareAmount = "146.01",
    this.onOpenLink,
    this.onCopy,
    this.onSendSms,
    this.onSendEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Icon(Icons.credit_card, color: DynamicColors.primaryClr),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PAYMENT LINK READY",
                        style: mozillaTextSemiBoldText(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const AlertCloseButton(),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: DynamicColors.primaryClr.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: DynamicColors.primaryClr.withOpacity(0.35),
                          ),
                        ),
                        child: Icon(
                          Icons.shield,
                          size: 18,
                          color: DynamicColors.primaryClr,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "SHARE THIS LINK WITH THE CUSTOMER TO COMPLETE CARD PAYMENT.",
                          style: mozillaTextSemiBoldText(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: onOpenLink ?? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CabFlowStripeScreen(
                                  gbpAmount: "£$fareAmount",
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: DynamicColors.primaryClr.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: DynamicColors.primaryClr.withOpacity(0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.open_in_new,
                                  size: 15,
                                  color: DynamicColors.primaryClr,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "OPEN PAYMENT LINK",
                                  style: mozillaTextSemiBoldText(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: DynamicColors.primaryClr,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 15,
                                  color: DynamicColors.primaryClr,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: onCopy ?? () {},
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: DynamicColors.primaryClr.withOpacity(0.35),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.copy_all_outlined,
                                size: 15,
                                color: DynamicColors.primaryClr,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "COPY",
                                style: mozillaTextSemiBoldText(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: DynamicColors.primaryClr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Fare
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: DynamicColors.primaryClr.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: DynamicColors.primaryClr.withOpacity(0.35),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "FARE SENT TO CUSTOMER",
                          style: mozillaTextSemiBoldText(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "£ $fareAmount",
                          style: mozillaTextSemiBoldText(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: DynamicColors.primaryClr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Footer Buttons
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 36,
                      verticalPadding: 0.0,
                      btnText: "SEND SMS",
                      btnColor: DynamicColors.primaryClr,
                      borderRadius: 4,
                      style: mozillaTextSemiBoldText(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      onTap: onSendSms ?? () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      height: 36,
                      verticalPadding: 0.0,
                      btnText: "SEND EMAIL",
                      btnColor: DynamicColors.primaryClr,
                      borderRadius: 4,
                      style: mozillaTextSemiBoldText(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      onTap: onSendEmail ?? () {},
                    ),
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