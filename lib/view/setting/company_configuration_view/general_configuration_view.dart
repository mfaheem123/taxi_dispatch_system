import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/setting/company_configuration_view/alert_createbooking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../controller/setting_controller.dart';

class GeneralConfigurationView extends StatefulWidget {
  const GeneralConfigurationView({super.key});

  @override
  State<GeneralConfigurationView> createState() =>
      _GeneralConfigurationViewState();
}

class _GeneralConfigurationViewState extends State<GeneralConfigurationView> {
  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  List permissions = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
        initState: (v){
          permissions = Api().sp.read('all_permissions') ?? [];
        },
        builder: (controller) {
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
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
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
                              child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0, vertical: 15.0),
                              child:
                              Text(AppText.generalConfiguration,
                                  style: titleDesign()))),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: [
                            Wrap(
                              direction: Axis.horizontal,
                              runSpacing: 40,
                              spacing: 30,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.tabbookingInHouss,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.tabBooksinHours,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.tabBooksinday,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.tabBooksinday,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.tabrecentBooksinday,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.tabrecentBooksinday,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.tabBooksAfterminuts,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.tabBooksAfterminuts,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.bookingExpiryNoties,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.bookingExpiryNoties,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller:
                                      controller.airportBookingExpiryNotice,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.airportBookingExpiryNotice,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.accountBookingExpiry,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.accountBookingExpiry,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.driverExpiryNotice,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.driverExpiryNotice,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.flightTrackerAPI,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.flightTrackerAPI,
                                  columnText: true,
                                ),
                                CustomDropdownField<String>(
                                  text: AppText.type,
                                  width: fieldWidth / 1.5,
                                  label: AppText.type,
                                  items: [
                                    "Amount 1",
                                    "Amount 2",
                                    "Amount 3",
                                    "Amount 4",
                                    "Amount 5",
                                  ],
                                  value: controller.typeAmount,
                                  itemLabel: (val) =>
                                      val,
                                  onChanged: (val) {
                                    controller.typeAmount = val!;
                                    controller.update();
                                  },
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.creditCardCharges,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.creditCardCharges,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.roundOffFares,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.roundOffFares,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.discountOneWay,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.discountOneWay,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.discountReturn,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.discountReturn,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.discountWaitAndReturn,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.discountWaitAndReturn,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.huntGroup,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.huntGroup,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.baseAddress,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.baseAddress,
                                  columnText: true,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.deadMileageMiles,
                                  width: fieldWidth / 1.5,
                                  hintText: AppText.deadMileageMiles,
                                  columnText: true,
                                ),
                                CustomDropdownField<String>(

                                  
                                  text: AppText.deadMileageMethods,
                                  width: fieldWidth / 1.5,
                                  label: AppText.deadMileageMethods,
                                  items: [
                                    "SELECT METHODS 1",
                                    "SELECT METHODS 2",
                                    "SELECT METHODS 3",
                                    "SELECT METHODS 4",
                                    "SELECT METHODS 5",
                                  ],
                                  value: controller.deadMileageMethods,
                                  itemLabel: (val) =>
                                      val,
                                  onChanged: (val) {
                                    controller.deadMileageMethods = val!;
                                    controller.update();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Wrap(
                        runSpacing: 20,
                        spacing: 20,
                        children: [
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.bookingQuotationSMSValue.value = v;
                              controller.update();
                            },
                            label: AppText.bookingQuotationSMS,
                            value: controller.bookingQuotationSMSValue.value,
                            focusNode: controller.bookingQuotationSMSNode,
                            width: 200,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.enableBookingTextValue.value = v;
                              controller.update();
                            },
                            label: AppText.enableBookingText,
                            value: controller.enableBookingTextValue.value,
                            focusNode: controller.enableBookingTextNode,
                            width: 200,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.peakFactorsValue.value = v;
                              controller.update();
                            },
                            label: AppText.peakFactor,
                            value: controller.peakFactorsValue.value,
                            focusNode: controller.peakFactorsNode,
                            width: 200,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.webBookerConfValue.value = v;
                              controller.update();
                            },
                            label: AppText.webBookerConfiguration,
                            value: controller.webBookerConfValue.value,
                            focusNode: controller.webBookerConfNode,
                            width: 200,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.bookingDueNotiValue.value = v;
                              controller.update();
                            },
                            label: AppText.bookingDueNotification,
                            value: controller.bookingDueNotiValue.value,
                            focusNode: controller.bookingDueNotiNode,
                            width: 200,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.enableCustomerValue.value = v;
                              controller.update();
                            },
                            label: AppText.enableCustomText,
                            value: controller.enableCustomerValue.value,
                            focusNode: controller.enableCustomerNode,
                            width: 200,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.notificationValue.value = v;
                              controller.update();
                            },
                            label: AppText.notifictaion,
                            value: controller.notificationValue.value,
                            focusNode: controller.notificationNode,
                            width: 200,
                          ),
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.deadMileageValue.value = v;
                              controller.update();
                            },
                            label: AppText.deadMileage,
                            value: controller.deadMileageValue.value,
                            focusNode: controller.deadMileageNode,
                            width: 200,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      if(permissions.contains('read_company_configuration'))  Align(
                        alignment: Alignment.center,
                        child: CustomButton(
                          onTap: () {

                            showDialog(
                              context: context,
                              builder: (context) {
                                return MultiReservationAlert();
                              },
                            );
                          },
                          height: 35,
                          width: fieldWidth,
                          fontSize: 14,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          btnText: AppText.save,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
