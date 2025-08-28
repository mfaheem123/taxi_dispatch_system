



import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/drivers_view/driver/driver_app_features/pda_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';

class AppVersionWidget extends StatelessWidget {
  AppVersionWidget({super.key});

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return GetBuilder<DriverController>(
        builder: (controller) {
          if( width < 1920 ){
            return Column(
              children: [
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.textClr)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        alignment: Alignment.centerLeft,
                        height: kToolbarHeight,
                        decoration: BoxDecoration(
                            color: DynamicColors.gryClr.withOpacity(0.2),
                            border: Border.all(color: DynamicColors.textClr)
                        ),
                        child: Text(AppText.appVersion,
                            style: mozillaTextSemiBoldText(
                                fontSize: 16
                            )
                        ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          KeyboardCheckbox(
                            value: controller.showCustomerValue.value,
                            onChanged: (v) {
                              controller.showCustomerValue.value = v;
                              controller.update();
                            },
                            label: AppText.showCustomer,
                          ),
                          KeyboardCheckbox(
                            value: controller.enableCustomerValue.value,
                            onChanged: (v) {
                              controller.enableCustomerValue.value = v;
                              controller.update();
                            },
                            label: AppText.enableCustomer,
                          ),
                          KeyboardCheckbox(
                            value: controller.enableFlagDownValue.value,
                            onChanged: (v) {
                              controller.enableFlagDownValue.value = v;
                              controller.update();
                            },
                            label: AppText.enableFlagDown,
                          ),
                          KeyboardCheckbox(
                            value: controller.showAccountFareValue.value,
                            onChanged: (v) {
                              controller.showAccountFareValue.value = v;
                              controller.update();
                            },
                            label: AppText.showAccountFare,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideBreakValue.value,
                            onChanged: (v) {
                              controller.hideBreakValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideBreak,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideDeclineValue.value,
                            onChanged: (v) {
                              controller.hideDeclineValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideDecline,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideRecoverValue.value,
                            onChanged: (v) {
                              controller.hideRecoverValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideRecover,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideNoPickUpValue.value,
                            onChanged: (v) {
                              controller.hideNoPickUpValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideNoPickUp,
                          ),
                          KeyboardCheckbox(
                            value: controller.hidePickUpValue.value,
                            onChanged: (v) {
                              controller.hidePickUpValue.value = v;
                              controller.update();
                            },
                            label: AppText.hidePickUp,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideDropOffValue.value,
                            onChanged: (v) {
                              controller.hideDropOffValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideDropOff,
                          ),
                          KeyboardCheckbox(
                            value: controller.fareMeterValue.value,
                            onChanged: (v) {
                              controller.fareMeterValue.value = v;
                              controller.update();
                            },
                            label: AppText.fareMeter,
                          ),
                          KeyboardCheckbox(
                            value: controller.diableFareMeterValue.value,
                            onChanged: (v) {
                              controller.diableFareMeterValue.value = v;
                              controller.update();
                            },
                            label: AppText.diableFareMeter,
                          ),
                          KeyboardCheckbox(
                            value: controller.fareMeterWaitingValue.value,
                            onChanged: (v) {
                              controller.fareMeterWaitingValue.value = v;
                              controller.update();
                            },
                            label: AppText.fareMeterWaiting,
                          ),
                          KeyboardCheckbox(
                            value: controller.payByCardValue.value,
                            onChanged: (v) {
                              controller.payByCardValue.value = v;
                              controller.update();
                            },
                            label: AppText.payByCard,
                          ),
                          KeyboardCheckbox(
                            value: controller.waitingAfterArrivalValue.value,
                            onChanged: (v) {
                              controller.waitingAfterArrivalValue.value = v;
                              controller.update();
                            },
                            label: AppText.waitingAfterArrival,
                          ),
                          KeyboardCheckbox(
                            value: controller.disablePanicButtonValue.value,
                            onChanged: (v) {
                              controller.disablePanicButtonValue.value = v;
                              controller.update();
                            },
                            label: AppText.disablePanicButton.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.showCompleteJobValue.value,
                            onChanged: (v) {
                              controller.showCompleteJobValue.value = v;
                              controller.update();
                            },
                            label: AppText.disablePanicButton.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.showNavigationValue.value,
                            onChanged: (v) {
                              controller.showNavigationValue.value = v;
                              controller.update();
                            },
                            label: AppText.showNavigation.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.showSwipeArriveValue.value,
                            onChanged: (v) {
                              controller.showSwipeArriveValue.value = v;
                              controller.update();
                            },
                            label: AppText.showSwipeArrive.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.shawFareValue.value,
                            onChanged: (v) {
                              controller.shawFareValue.value = v;
                              controller.update();
                            },
                            label: AppText.shawFare.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.hasCompanyCarValue.value,
                            onChanged: (v) {
                              controller.hasCompanyCarValue.value = v;
                              controller.update();
                            },
                            label: AppText.hasCompanyCar.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.hidePaymentTypeValue.value,
                            onChanged: (v) {
                              controller.hidePaymentTypeValue.value = v;
                              controller.update();
                            },
                            label: AppText.hidePaymentType.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.enableTollChargesValue.value,
                            onChanged: (v) {
                              controller.enableTollChargesValue.value = v;
                              controller.update();
                            },
                            label: AppText.enableTollCharges.toString().toUpperCase(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: labeledTextField(
                            context, false, AppText.bookingTimer,
                            controller.bookingTimerController,
                            width: Get.width/10,
                            column: true,
                            formatDigitsOnly: false,
                            hintTex: AppText.bookingTimer,
                            textInputAction: TextInputAction.next
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Expanded(
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.textClr)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15),
                        height: kToolbarHeight,
                        decoration: BoxDecoration(
                            color: DynamicColors.gryClr.withOpacity(0.2),
                            border: Border.all(color: DynamicColors.textClr)
                        ),
                        child: Text(AppText.appVersion,
                            style: mozillaTextSemiBoldText(
                                fontSize: 16
                            )
                        ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          KeyboardCheckbox(
                            value: controller.showCustomerValue.value,
                            onChanged: (v) {
                              controller.showCustomerValue.value = v;
                              controller.update();
                            },
                            label: AppText.showCustomer,
                          ),
                          KeyboardCheckbox(
                            value: controller.enableCustomerValue.value,
                            onChanged: (v) {
                              controller.enableCustomerValue.value = v;
                              controller.update();
                            },
                            label: AppText.enableCustomer,
                          ),
                          KeyboardCheckbox(
                            value: controller.enableFlagDownValue.value,
                            onChanged: (v) {
                              controller.enableFlagDownValue.value = v;
                              controller.update();
                            },
                            label: AppText.enableFlagDown,
                          ),
                          KeyboardCheckbox(
                            value: controller.showAccountFareValue.value,
                            onChanged: (v) {
                              controller.showAccountFareValue.value = v;
                              controller.update();
                            },
                            label: AppText.showAccountFare,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideBreakValue.value,
                            onChanged: (v) {
                              controller.hideBreakValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideBreak,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideDeclineValue.value,
                            onChanged: (v) {
                              controller.hideDeclineValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideDecline,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideRecoverValue.value,
                            onChanged: (v) {
                              controller.hideRecoverValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideRecover,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideNoPickUpValue.value,
                            onChanged: (v) {
                              controller.hideNoPickUpValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideNoPickUp,
                          ),
                          KeyboardCheckbox(
                            value: controller.hidePickUpValue.value,
                            onChanged: (v) {
                              controller.hidePickUpValue.value = v;
                              controller.update();
                            },
                            label: AppText.hidePickUp,
                          ),
                          KeyboardCheckbox(
                            value: controller.hideDropOffValue.value,
                            onChanged: (v) {
                              controller.hideDropOffValue.value = v;
                              controller.update();
                            },
                            label: AppText.hideDropOff,
                          ),
                          KeyboardCheckbox(
                            value: controller.fareMeterValue.value,
                            onChanged: (v) {
                              controller.fareMeterValue.value = v;
                              controller.update();
                            },
                            label: AppText.fareMeter,
                          ),
                          KeyboardCheckbox(
                            value: controller.diableFareMeterValue.value,
                            onChanged: (v) {
                              controller.diableFareMeterValue.value = v;
                              controller.update();
                            },
                            label: AppText.diableFareMeter,
                          ),
                          KeyboardCheckbox(
                            value: controller.fareMeterWaitingValue.value,
                            onChanged: (v) {
                              controller.fareMeterWaitingValue.value = v;
                              controller.update();
                            },
                            label: AppText.fareMeterWaiting,
                          ),
                          KeyboardCheckbox(
                            value: controller.payByCardValue.value,
                            onChanged: (v) {
                              controller.payByCardValue.value = v;
                              controller.update();
                            },
                            label: AppText.payByCard,
                          ),
                          KeyboardCheckbox(
                            value: controller.waitingAfterArrivalValue.value,
                            onChanged: (v) {
                              controller.waitingAfterArrivalValue.value = v;
                              controller.update();
                            },
                            label: AppText.waitingAfterArrival,
                          ),
                          KeyboardCheckbox(
                            value: controller.disablePanicButtonValue.value,
                            onChanged: (v) {
                              controller.disablePanicButtonValue.value = v;
                              controller.update();
                            },
                            label: AppText.disablePanicButton.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.showCompleteJobValue.value,
                            onChanged: (v) {
                              controller.showCompleteJobValue.value = v;
                              controller.update();
                            },
                            label: AppText.disablePanicButton.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.showNavigationValue.value,
                            onChanged: (v) {
                              controller.showNavigationValue.value = v;
                              controller.update();
                            },
                            label: AppText.showNavigation.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.showSwipeArriveValue.value,
                            onChanged: (v) {
                              controller.showSwipeArriveValue.value = v;
                              controller.update();
                            },
                            label: AppText.showSwipeArrive.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.shawFareValue.value,
                            onChanged: (v) {
                              controller.shawFareValue.value = v;
                              controller.update();
                            },
                            label: AppText.shawFare.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.hasCompanyCarValue.value,
                            onChanged: (v) {
                              controller.hasCompanyCarValue.value = v;
                              controller.update();
                            },
                            label: AppText.hasCompanyCar.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.hidePaymentTypeValue.value,
                            onChanged: (v) {
                              controller.hidePaymentTypeValue.value = v;
                              controller.update();
                            },
                            label: AppText.hidePaymentType.toString().toUpperCase(),
                          ),
                          KeyboardCheckbox(
                            value: controller.enableTollChargesValue.value,
                            onChanged: (v) {
                              controller.enableTollChargesValue.value = v;
                              controller.update();
                            },
                            label: AppText.enableTollCharges.toString().toUpperCase(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      labeledTextField(
                        context, false, AppText.bookingTimer, controller.bookingTimerController,
                          width: Get.width/10,
                          column: true,
                          hintTex: AppText.bookingTimer,
                        textInputAction: TextInputAction.next
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                PdaDetailsWidget(),
              ],
            ),
          );
        }
    );
  }
}

class KeyboardCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const KeyboardCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) {
            onChanged(!value);
            return null;
          },
        ),
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15, bottom: 8), // gap between items
        child: Row(
          mainAxisSize: MainAxisSize.min, // 👈 important
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: value,
              onChanged: (v) => onChanged(v!),
            ),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: mozillaTextRegularText(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

