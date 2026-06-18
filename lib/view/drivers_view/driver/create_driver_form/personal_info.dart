//
//
// import 'package:bot_toast/bot_toast.dart';
// import 'package:dashboard_new1/component/color.dart';
// import 'package:dashboard_new1/component/customButton.dart';
// import 'package:dashboard_new1/component/textStyle.dart';
// import 'package:dashboard_new1/component/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import '../../../../alert/restrict_drivers_alert.dart';
// import '../../../../component/dropdown_button.dart';
// import '../../../../component/text_field.dart';
// import '../../../dashboard_view/widgets/time_picker_widget.dart';
// import '../../../dashboard_view/widgets/user_info_widget.dart';
// import '../../controller/driver_controller.dart';
// import '../../model/driver_form_model.dart';
//
// class DriverPersonalInfo extends StatelessWidget {
//   DriverPersonalInfo({super.key});
//
//   DriverController controller = Get.isRegistered<DriverController>()
//       ? Get.find<DriverController>()
//       : Get.put(DriverController());
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<DriverController>(
//       builder: (controller) {
//         return LayoutBuilder(
//             builder: (context, constraints) {
//               final double maxWidth = constraints.maxWidth;
//               final bool isMobile = maxWidth < 600;
//                final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
//
//               // Instead of fixed width, we calculate flexible field widths
//               final double fieldWidth = isMobile
//                   ? maxWidth // full width
//                   : isTablet
//                   ? maxWidth / 2
//                   : maxWidth / 4;
//
//             return Container(
//               width: Get.width/2.5,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(color: Colors.grey.shade400, width: 1),
//               ),
//               margin: EdgeInsets.only(bottom: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Header
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.all(14),
//                       child: Text(
//                         AppText.personalInformation,
//                         style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//
//                   Divider(height: 1),
//
//                Wrap(
//                  spacing: 10,
//                  runSpacing: 10,
//                  crossAxisAlignment: WrapCrossAlignment.center,
//                  children: [
//                    Focus(
//                      onKeyEvent: (node, event) {
//                        if (event is KeyDownEvent) {
//                          if (event.logicalKey == LogicalKeyboardKey.space ||
//                              event.logicalKey == LogicalKeyboardKey.enter ||
//                              event.logicalKey == LogicalKeyboardKey.numpadEnter) {
//                            controller.hasPDA.value = !controller.hasPDA.value;
//                            controller.update();
//                            return KeyEventResult.handled;
//                          }
//                        }
//                        return KeyEventResult.ignored; // Tab ko ignore karo
//                      },
//                      child: FocusTraversalOrder(
//                        order: NumericFocusOrder(1),
//                        child: Checkbox(
//                          autofocus: true,
//                          value: controller.hasPDA.value,
//                          onChanged: (val) {
//                            controller.hasPDA.value = val!;
//                            controller.update();
//                          },
//                        ),
//                      ),
//                    ),
//
//                    Text(AppText.hasPDA),
//                    FocusTraversalOrder(
//                      order: NumericFocusOrder(2),
//                      child: Checkbox(
//                        value: controller.rentPaid.value,
//                        onChanged: (val) {
//                          controller.rentPaid.value = val!;
//                          controller.update();
//                        },
//                      ),
//                    ),
//                    Text(AppText.rentPaid),
//
//                    FocusTraversalOrder(
//                      order: NumericFocusOrder(3),
//                      child: Checkbox(
//                        value: controller.isActive.value,
//                        onChanged: (val) {
//                          controller.isActive.value = val!;
//                          controller.update();
//                        },
//                      ),
//                    ),
//                    Text(AppText.active),
//                    SizedBox(
//                      width: 20,
//                    ),
//                    FocusTraversalOrder(
//                      order: NumericFocusOrder(4),
//                      child:
//                      CustomDropdownField<SubsidiaryObject>(
//                        label: "COMPANY TYPE",
//                        text: "COMPANY ACCOUNTS",
//                        width: fieldWidth/2,
//                        height: 35,
//                        items: controller.getCombineVehicleData!.subsidiaries!,
//                        // items: controller.locationtypezoneModel!
//                        //     .zonesList!,
//                        value: controller.companyType,
//                        itemLabel: (templateList) =>
//                        templateList.name!.toUpperCase(),
//                        onChanged: (val) {
//                          controller.companyType = val;
//                          controller.update();
//                        },
//                      ),
//                    ),
//
//                    FocusTraversalOrder(
//                      order: NumericFocusOrder(5),
//                      child: labeledTextField(context, isMobile, "USERNAME", controller.driverUserNameController,
//                          width: fieldWidth/1.4,
//                          textInputAction: TextInputAction.next,
//                          column: true
//                      ),
//                    ),
//
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(6),
//                      child: labeledTextField(context, isMobile, "PASSWORD", controller.driverPasswordController,
//                          width: fieldWidth/1.4,
//                          textInputAction: TextInputAction.next,
//                          column: true
//                      ),
//                    ),
//
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(7),
//                      child: labeledTextField(context, isMobile, "FULL NAME", controller.driverFullNameController,
//                          width: fieldWidth/1.4,
//                          textInputAction: TextInputAction.next,
//                          keyboardType: TextInputType.name,
//                          inputFormatters: [
//                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
//                            UpperCaseTextFormatter(),
//                          ],
//                          column: true
//                      ),
//                    ),
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(8),
//                      child: labeledField(
//                          context: context,
//                          isMobile: isMobile,
//                          label: "DATE OF BIRTH",
//                          width: fieldWidth/1.4,
//                          child: SizedBox(height: 30, child: KeyboardDatePicker(
//                            initialDate: DateTime.now(),
//                            onChanged: (date) {
//                              // jab bhi user change kare
//                                controller.dobDate = "${date.year}-${date.month}-${date.day}";
//                                print(date);
//                            },
//                            onSubmitted: (date) {
//                              // jab user enter press kare
//                                controller.dobDate = "${date.year}-${date.month}-${date.day}";
//                              print("User pressed enter: $date");
//                            },
//                          )
//                          ),
//                          column: true
//                      ),
//                    ),
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(9),
//                      child: labeledTextField(
//                          context, isMobile,
//                          AppText.email,
//                          controller.driverEmailController,
//                          width: fieldWidth/1.4,
//                          textInputAction: TextInputAction.next,
//                          column: true
//                      ),
//                    ),
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(10),
//                      child: labeledTextField(context,
//                          isMobile,
//                          "MOBILE",
//                          controller.driverMobileController,
//                          width: fieldWidth/1.4,
//                          formatDigitsOnly: true,
//                          column: true,
//                          textInputAction: TextInputAction.next),
//                    ),
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(11),
//                      child: labeledTextField(context, isMobile,
//                          "TELEPHONE",
//                          controller.driverTelController,
//                          width: fieldWidth/1.4,
//                          column: true,
//                          textInputAction: TextInputAction.next,
//                          keyboardType: TextInputType.phone,
//                          formatDigitsOnly: true),
//                    ),
//
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(12),
//                      child: labeledTextField(context, isMobile,
//                          AppText.nl,
//                          controller.driverNLController,
//                          width: fieldWidth/1.4,
//                          column: true,
//                          textInputAction: TextInputAction.next,
//                          keyboardType: TextInputType.phone,
//                          formatDigitsOnly: false),
//                    ),
//
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(13),
//                      child: labeledField(
//                          context: context,
//                          isMobile: isMobile,
//                          label: "DRIVER TYPE",
//                          width: fieldWidth/1.4,
//                          child: SizedBox(
//                            width: fieldWidth,
//                            // height: 30,
//                            child:
//                            CustomDropdownField<String>(
//                              label: "DRIVER TYPE",
//                              width: Get.width / 5,
//                              height: 35,
//                              items: ['Commission', "Rent/Week"],
//                              value: controller.driverType,
//                              itemLabel: (templateList) =>
//                              templateList,
//                              onChanged: (val) {
//                                controller.driverType = val;
//                                controller.update();
//                              },
//                            ),
//                          ),
//                          column: true
//                      ),
//                    ),
//
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(14),
//                      child: labeledTextField(context,
//                          isMobile,
//                          "COMMISSION",
//                          formatDigitsOnly: true,
//                          controller.driverCommissionController,
//                          width: fieldWidth/1.4,
//                          column: true,
//                          textInputAction: TextInputAction.next),
//                    ),
//
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(15),
//                      child: labeledTextField(context, isMobile,
//                          "RENT LIMIT",
//                          controller.driverRendLimitController,
//                          width: fieldWidth/1.4,
//                          column: true,
//                          formatDigitsOnly: true,
//                          textInputAction: TextInputAction.next,
//                          keyboardType: TextInputType.phone,),
//                    ),
//
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(16),
//                      child: labeledTextField(context, isMobile,
//                          "BALANCE",
//                          controller.driverBalanceController,
//                          width: fieldWidth/1.4,
//                          column: true,
//                          textInputAction: TextInputAction.next,
//                          keyboardType: TextInputType.phone,
//                          formatDigitsOnly: true),
//                    ),
//                    FocusTraversalOrder(
//                      order: const NumericFocusOrder(17),
//                      child: labeledTextField(context,
//                          isMobile,
//                          AppText.address,
//                          controller.driverAddressController,
//                          width: fieldWidth/1.4,
//                          column: true,
//                          textInputAction: TextInputAction.next,
//                          keyboardType: TextInputType.phone,
//                          formatDigitsOnly: false),
//                    ),
//                  ],
//                ),
//                   SizedBox(height: 10),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 23),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//
//                         CustomButton(
//                           verticalPadding: 0.0,
//                           width: fieldWidth/1.4,
//                           borderRadius: 4,
//                           height: 35,
//                         onTap: (){
//                             if(controller.driverUserNameController.text.isEmpty
//                                 || controller.driverPasswordController.text.isEmpty || controller.driverFullNameController.text.isEmpty || controller.driverMobileController.text.isEmpty
//                             ){
//                               BotToast.showText(text: "Please enter below fields is required\n user name, driver full name, driver mobile number,");
//                             }else if (!controller.driverEmailController.text.contains('@')) {
//                               BotToast.showText(text: "Invalid Email Format");
//                             }
//                             else{
//                               if(controller.vehicleInformation.value && controller.vehicleType == null){
//                                 BotToast.showText(text: "Please select the company vehicle type");
//                               }else{
//                                 controller.addDriverFtn();
//                               }
//                             }
//
//                         },
//                         style: mozillaTextSemiBoldText(
//                           fontSize: 16,
//                           color: DynamicColors.whiteClr
//                         ),
//                           btnColor: DynamicColors.primaryClr,
//                           btnText: controller.singleDriverData ==null? AppText.save:AppText.update,
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//             );
//           }
//         );
//       }
//     );
//   }
// }
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../component/dropdown_button.dart';
import '../../../../component/text_field.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';
import '../../model/driver_form_model.dart';

class DriverPersonalInfo extends StatelessWidget {
  DriverPersonalInfo({super.key});

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverController>(
      builder: (controller) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double globalWidth = MediaQuery.of(context).size.width;
            bool isMobile = globalWidth < 600;
            double containerWidth = Get.width / 2.5;
            double fieldWidth = (containerWidth - 60) / 4;

            return Container(
              width: containerWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        AppText.personalInformation,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Focus(
                              onKeyEvent: (node, event) {
                                if (event is KeyDownEvent) {
                                  if (event.logicalKey == LogicalKeyboardKey.space ||
                                      event.logicalKey == LogicalKeyboardKey.enter ||
                                      event.logicalKey == LogicalKeyboardKey.numpadEnter) {
                                    controller.hasPDA.value = !controller.hasPDA.value;
                                    controller.update();
                                    return KeyEventResult.handled;
                                  }
                                }
                                return KeyEventResult.ignored;
                              },
                              child: FocusTraversalOrder(
                                order: NumericFocusOrder(1),
                                child: Checkbox(
                                  autofocus: true,
                                  value: controller.hasPDA.value,
                                  onChanged: (val) {
                                    controller.hasPDA.value = val!;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                            Text(AppText.hasPDA),
                            const SizedBox(width: 8),
                            FocusTraversalOrder(
                              order: NumericFocusOrder(2),
                              child: Checkbox(
                                value: controller.rentPaid.value,
                                onChanged: (val) {
                                  controller.rentPaid.value = val!;
                                  controller.update();
                                },
                              ),
                            ),
                            Text(AppText.rentPaid),
                            const SizedBox(width: 8),
                            FocusTraversalOrder(
                              order: NumericFocusOrder(3),
                              child: Checkbox(
                                value: controller.isActive.value,
                                onChanged: (val) {
                                  controller.isActive.value = val!;
                                  controller.update();
                                },
                              ),
                            ),
                            Text(AppText.active),
                            const SizedBox(width: 24),
                            Expanded(
                              child: FocusTraversalOrder(
                                order: NumericFocusOrder(4),
                                child: CustomDropdownField<SubsidiaryObject>(
                                  label: "COMPANY TYPE",
                                  text: "COMPANY ACCOUNTS",
                                  width: double.infinity,
                                  height: 28,
                                  items: controller.getCombineVehicleData!.subsidiaries!,
                                  value: controller.companyType,
                                  itemLabel: (templateList) => templateList.name!.toUpperCase(),
                                  onChanged: (val) {
                                    controller.companyType = val;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FocusTraversalOrder(
                              order: NumericFocusOrder(5),
                              child: labeledTextField(context, isMobile, "USERNAME", controller.driverUserNameController,
                                  width: fieldWidth, textInputAction: TextInputAction.next, column: true),
                            ),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(6),
                              child: labeledTextField(context, isMobile, "PASSWORD", controller.driverPasswordController,
                                  width: fieldWidth, textInputAction: TextInputAction.next, column: true),
                            ),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(7),
                              child: labeledTextField(context, isMobile, "FULL NAME", controller.driverFullNameController,
                                  width: fieldWidth,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                    UpperCaseTextFormatter(),
                                  ],
                                  column: true),
                            ),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(8),
                              child: labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: "DATE OF BIRTH",
                                  width: fieldWidth,
                                  child: SizedBox(
                                      height: 30,
                                      child: KeyboardDatePicker(
                                        initialDate: DateTime.now(),
                                        onChanged: (date) {
                                          controller.dobDate = "${date.year}-${date.month}-${date.day}";
                                        },
                                        onSubmitted: (date) {
                                          controller.dobDate = "${date.year}-${date.month}-${date.day}";
                                        },
                                      )),
                                  column: true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(9),
                              child: labeledTextField(context, isMobile, AppText.email, controller.driverEmailController,
                                  width: fieldWidth, textInputAction: TextInputAction.next, column: true),
                            ),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(10),
                              child: labeledTextField(context, isMobile, "MOBILE", controller.driverMobileController,
                                  width: fieldWidth, formatDigitsOnly: true, column: true, textInputAction: TextInputAction.next),
                            ),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(11),
                              child: labeledTextField(context, isMobile, "TELEPHONE", controller.driverTelController,
                                  width: fieldWidth, column: true, textInputAction: TextInputAction.next, keyboardType: TextInputType.phone, formatDigitsOnly: true),
                            ),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(12),
                              child: labeledTextField(context, isMobile, AppText.nl, controller.driverNLController,
                                  width: fieldWidth, column: true, textInputAction: TextInputAction.next, keyboardType: TextInputType.phone, formatDigitsOnly: false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(13),
                              child: labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: "DRIVER TYPE",
                                  width: fieldWidth,
                                  child: SizedBox(
                                    width: fieldWidth,
                                    child: CustomDropdownField<String>(
                                      label: "DRIVER TYPE",
                                      width: fieldWidth,
                                      height: 35,
                                      items: const ['Commission', "Rent/Week"],
                                      value: controller.driverType,
                                      itemLabel: (templateList) => templateList,
                                      onChanged: (val) {
                                        controller.driverType = val;
                                        controller.update();
                                      },
                                    ),
                                  ),
                                  column: true),
                            ),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(14),
                              child: labeledTextField(context, isMobile, "COMMISSION", formatDigitsOnly: true, controller.driverCommissionController,
                                  width: fieldWidth, column: true, textInputAction: TextInputAction.next),
                            ),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(15),
                              child: labeledTextField(context, isMobile, "RENT LIMIT", controller.driverRendLimitController,
                                  width: fieldWidth, column: true, formatDigitsOnly: true, textInputAction: TextInputAction.next, keyboardType: TextInputType.phone),
                            ),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(16),
                              child: labeledTextField(context, isMobile, "BALANCE", controller.driverBalanceController,
                                  width: fieldWidth, column: true, textInputAction: TextInputAction.next, keyboardType: TextInputType.phone, formatDigitsOnly: true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: FocusTraversalOrder(
                                order: const NumericFocusOrder(17),
                                child: labeledTextField(context, isMobile, AppText.address, controller.driverAddressController,
                                    width: double.infinity,
                                    column: true,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    formatDigitsOnly: false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: CustomButton(
                      verticalPadding: 0.0,
                      width: 180,
                      borderRadius: 4,
                      height: 38,
                      onTap: () {
                        if (controller.driverUserNameController.text.isEmpty ||
                            controller.driverPasswordController.text.isEmpty ||
                            controller.driverFullNameController.text.isEmpty ||
                            controller.driverMobileController.text.isEmpty) {
                          BotToast.showText(text: "Please enter below fields is required\n user name, driver full name, driver mobile number,");
                        } else if (!controller.driverEmailController.text.contains('@')) {
                          BotToast.showText(text: "Invalid Email Format");
                        } else {
                          if (controller.vehicleInformation.value && controller.vehicleType == null) {
                            BotToast.showText(text: "Please select the company vehicle type");
                          } else {
                            controller.addDriverFtn();
                          }
                        }
                      },
                      style: mozillaTextSemiBoldText(fontSize: 16, color: DynamicColors.whiteClr),
                      btnColor: DynamicColors.primaryClr,
                      btnText: controller.singleDriverData == null ? AppText.save : AppText.update,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}