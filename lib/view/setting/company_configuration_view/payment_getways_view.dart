import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../controller/setting_controller.dart';

class PaymentConfigurationView extends StatefulWidget {
  const PaymentConfigurationView({super.key});

  @override
  State<PaymentConfigurationView> createState() =>
      _PaymentConfigurationViewState();
}

class _PaymentConfigurationViewState extends State<PaymentConfigurationView> {
  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  List permissions = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      initState: (v) {
        permissions = Api().sp.read('all_permissions') ?? [];
      },
      builder: (controller) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

            // Instead of fixed width, we calculate flexible field widths
            final double fieldWidth = isMobile
                ? maxWidth // full width
                : isTablet
                    ? maxWidth / 2
                    : maxWidth / 4;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: DynamicColors.secondaryClr,
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: Get.width,
                        height: kToolbarHeight,
                        color: DynamicColors.secondaryClr,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 12.0),
                            child: Text(AppText.paymentGateWays,
                                style: titleDesign()))),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: isMobile
                          ? buildLeftFields()
                          : IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: buildLeftFields(),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildLeftFields() {
    const double horizontalSpacing = 16.0;
    const double runSpacing = 26.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: CustomTextField(
                borderRadius: 4,
                controller: controller.stripePublicKey,
                hintText: AppText.strippublickey,
                columnText: true,
                inputFormatters: [UpperCaseTextFormatter()]
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
                borderRadius: 4,
                controller: controller.stripeSecretKey,
                hintText: AppText.stripSecretKey,
                columnText: true,
                inputFormatters: [UpperCaseTextFormatter()]
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
                borderRadius: 4,
                controller: controller.endPointKey,
                hintText: AppText.endPointKey,
                columnText: true,
                inputFormatters: [UpperCaseTextFormatter()]
            )),
            const SizedBox(width: horizontalSpacing),
            Expanded(child: CustomTextField(
                borderRadius: 4,
                controller: controller.invoiceEndPointKey,
                hintText: "INVOICE ENDPOINT KEY",
                columnText: true,
                inputFormatters: [UpperCaseTextFormatter()]
            )),
          ],
        ),
      ],
    );
  }
}
