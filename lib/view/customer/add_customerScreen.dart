import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/alert/restricted_driver.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import 'controller/customer_controller.dart';

class CustomerFormScreen extends StatefulWidget {
  CustomerFormScreen({super.key});

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  CustomerController controller = Get.isRegistered<CustomerController>()
      ? Get.find<CustomerController>()
      : Get.put(CustomerController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "customerFormScreen";
  }

// Example API se data aaya

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<CustomerController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        return Container(
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Container(
                    color: DynamicColors.secondaryClr,
                    padding: const EdgeInsets.all(12),
                    child: Center(
                        child: Text(AppText.customer, style: titleDesign())),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWide = constraints.maxWidth > 600;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value: controller.enableSms.value,
                                    onChanged: (v) {
                                      controller.enableSms.value = v!;
                                      controller.update();
                                    }),
                                Text(AppText.enableSms),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    await controller
                                        .getRestricDriver(); // load API data
                                    showDialog(
                                      context: context,
                                      builder: (_) => RestrictedDriversDialog(
                                        drivers: controller.apiDriversList
                                            .map((e) => {
                                                  'id': e['id'].toString(),
                                                  'username': e['username']
                                                      .toString()
                                                      .toUpperCase(),
                                                  'name': e['name']
                                                      .toString()
                                                      .toUpperCase(),
                                                })
                                            .toList(),
                                      ),
                                    );
                                  },
                                  child: CustomButton(
                                    height: 30,
                                    width: 160,
                                    verticalPadding: 0.0,
                                    btnText: AppText.restrictionDrivers,
                                    borderRadius: 4,
                                    fontSize: 11,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing:
                                  MediaQuery.of(context).devicePixelRatio >=
                                          1.25
                                      ? fieldWidth / 2
                                      : fieldWidth / 5.5,
                              runSpacing: 16,
                              children: [
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.nameController,
                                  width: fieldWidth,
                                  hintText: AppText.name,
                                  columnText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z\s]')),
                                    UpperCaseTextFormatter(),
                                  ],
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.emailController,
                                  width: fieldWidth,
                                  hintText: AppText.email,
                                  columnText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')),
                                    UpperCaseTextFormatter(),
                                  ],
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.mobileController,
                                  width: fieldWidth,
                                  hintText: "MOBILE",
                                  columnText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.telController,
                                  width: fieldWidth,
                                  hintText: "TELEPHONE",
                                  columnText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ],
                            ),
                            //         ],
                            //       );
                            //     },
                            //   ),
                            // ),
                            SizedBox(height: 15),
                            Container(
                              color: DynamicColors.secondaryClr,
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                  child: Text(AppText.other,
                                      style: titleDesign())),
                            ),
                            Wrap(
                              spacing:
                                  MediaQuery.of(context).devicePixelRatio >=
                                          1.25
                                      ? fieldWidth / 2
                                      : fieldWidth / 5.5,
                              runSpacing: 16,
                              children: [
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.doorController,
                                  width: fieldWidth,
                                  hintText: AppText.door,
                                  columnText: true,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.noteController,
                                  width: fieldWidth,
                                  hintText: AppText.note,
                                  columnText: true,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.address1Controller,
                                  width: fieldWidth,
                                  hintText: AppText.address1,
                                  columnText: true,
                                  height: 80,
                                  maxLines: 5,
                                  contentPadding:
                                      EdgeInsets.only(top: 15, left: 6),
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.address2Controller,
                                  width: fieldWidth,
                                  hintText: AppText.address2,
                                  columnText: true,
                                  height: 80,
                                  maxLines: 5,
                                  contentPadding:
                                      EdgeInsets.only(top: 15, left: 6),
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    onTap: () {
                      String email = controller.emailController.text.trim();

                      if (email.isEmpty) {
                        BotToast.showText(text: "EMAIL IS REQUIRED");
                      } else if (!email.contains('@')) {
                        BotToast.showText(text: "INVALID EMAIL FORMAT");
                      } else {
                        controller.postCustomer();
                      }
                    },
                    height: 35,
                    fontSize: 12,
                    borderRadius: 4,
                    // width: fieldWidth * 1.5,
                    width: MediaQuery.of(context).devicePixelRatio >= 1.25
                        ? fieldWidth * 1.1
                        : fieldWidth * 1.5,
                    btnText: controller.updateCustomerValue.value == false
                        ? AppText.save
                        : "UPDATE",
                    verticalPadding: 0.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
