

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
              width: Get.width/2.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              margin: EdgeInsets.only(bottom: 12),
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

                  Divider(height: 1),

               Wrap(
                 spacing: 10,
                 runSpacing: 10,
                 crossAxisAlignment: WrapCrossAlignment.center,
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
                       return KeyEventResult.ignored; // Tab ko ignore karo
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
                   const Text("Active"),
                   SizedBox(
                     width: 20,
                   ),
                   FocusTraversalOrder(
                     order: NumericFocusOrder(4),
                     child:
                     CustomDropdownField<SubsidiaryObject>(
                       label: "COMPANY TYPE",
                       text: "COMPANY ACCOUNTS",
                       width: fieldWidth/2,
                       height: 35,
                       items: controller.getCombineVehicleData!.subsidiaries!,
                       // items: controller.locationtypezoneModel!
                       //     .zonesList!,
                       value: controller.companyType,
                       itemLabel: (templateList) =>
                       templateList.name!,
                       onChanged: (val) {
                         controller.companyType = val;
                         controller.update();
                       },
                     ),
                   ),

                   FocusTraversalOrder(
                     order: NumericFocusOrder(5),
                     child: labeledTextField(context, isMobile, AppText.userName, controller.driverUserNameController,
                         width: fieldWidth/1.4,
                         textInputAction: TextInputAction.next,
                         column: true
                     ),
                   ),

                   FocusTraversalOrder(
                     order: const NumericFocusOrder(6),
                     child: labeledTextField(context, isMobile, AppText.password, controller.driverPasswordController,
                         width: fieldWidth/1.4,
                         textInputAction: TextInputAction.next,
                         column: true
                     ),
                   ),

                   FocusTraversalOrder(
                     order: const NumericFocusOrder(7),
                     child: labeledTextField(context, isMobile, AppText.fullName, controller.driverFullNameController,
                         width: fieldWidth/1.4,
                         textInputAction: TextInputAction.next,
                         keyboardType: TextInputType.phone,
                         formatDigitsOnly: false,
                         column: true
                     ),
                   ),
                   FocusTraversalOrder(
                     order: const NumericFocusOrder(8),
                     child: labeledField(
                         context: context,
                         isMobile: isMobile,
                         label: "DATE OF BIRTH",
                         width: fieldWidth/1.4,
                         child: SizedBox(height: 30, child: KeyboardDatePicker(
                           initialDate: DateTime.now(),
                           onChanged: (date) {
                             // jab bhi user change kare
                               controller.dobDate = "${date.year}-${date.month}-${date.day}";
                               print(date);
                           },
                           onSubmitted: (date) {
                             // jab user enter press kare
                               controller.dobDate = "${date.year}-${date.month}-${date.day}";
                             print("User pressed enter: $date");
                           },
                         )
                         ),
                         column: true
                     ),
                   ),
                   FocusTraversalOrder(
                     order: const NumericFocusOrder(9),
                     child: labeledTextField(
                         context, isMobile,
                         AppText.email,
                         controller.driverEmailController,
                         width: fieldWidth/1.4,
                         textInputAction: TextInputAction.next,
                         column: true
                     ),
                   ),
                   FocusTraversalOrder(
                     order: const NumericFocusOrder(10),
                     child: labeledTextField(context,
                         isMobile,
                         AppText.mobile,
                         controller.driverMobileController,
                         width: fieldWidth/1.4,
                         column: true,
                         textInputAction: TextInputAction.next),
                   ),
                   FocusTraversalOrder(
                     order: const NumericFocusOrder(11),
                     child: labeledTextField(context, isMobile,
                         AppText.tel,
                         controller.driverTelController,
                         width: fieldWidth/1.4,
                         column: true,
                         textInputAction: TextInputAction.next,
                         keyboardType: TextInputType.phone,
                         formatDigitsOnly: false),
                   ),

                   FocusTraversalOrder(
                     order: const NumericFocusOrder(12),
                     child: labeledTextField(context, isMobile,
                         AppText.nl,
                         controller.driverNLController,
                         width: fieldWidth/1.4,
                         column: true,
                         textInputAction: TextInputAction.next,
                         keyboardType: TextInputType.phone,
                         formatDigitsOnly: false),
                   ),

                   FocusTraversalOrder(
                     order: const NumericFocusOrder(13),
                     child: labeledField(
                         context: context,
                         isMobile: isMobile,
                         label: "DRIVER TYPE",
                         width: fieldWidth/1.4,
                         child: SizedBox(
                           width: fieldWidth,
                           // height: 30,
                           child:
                           CustomDropdownField<String>(
                             label: "DRIVER TYPE",
                             width: Get.width / 5,
                             height: 35,
                             items: ['Commission', "Rent/Week"],
                             value: controller.driverType,
                             itemLabel: (templateList) =>
                             templateList,
                             onChanged: (val) {
                               controller.driverType = val;
                               controller.update();
                             },
                           ),
                         ),
                         column: true
                     ),
                   ),

                   FocusTraversalOrder(
                     order: const NumericFocusOrder(14),
                     child: labeledTextField(context,
                         isMobile,
                         AppText.commission,
                         formatDigitsOnly: true,
                         controller.driverCommissionController,
                         width: fieldWidth/1.4,
                         column: true,
                         textInputAction: TextInputAction.next),
                   ),

                   FocusTraversalOrder(
                     order: const NumericFocusOrder(15),
                     child: labeledTextField(context, isMobile,
                         AppText.rentLimit,
                         controller.driverRendLimitController,
                         width: fieldWidth/1.4,
                         column: true,
                         formatDigitsOnly: true,
                         textInputAction: TextInputAction.next,
                         keyboardType: TextInputType.phone,),
                   ),

                   FocusTraversalOrder(
                     order: const NumericFocusOrder(16),
                     child: labeledTextField(context, isMobile,
                         AppText.balance,
                         controller.driverBalanceController,
                         width: fieldWidth/1.4,
                         column: true,
                         textInputAction: TextInputAction.next,
                         keyboardType: TextInputType.phone,
                         formatDigitsOnly: true),
                   ),
                   FocusTraversalOrder(
                     order: const NumericFocusOrder(17),
                     child: labeledTextField(context,
                         isMobile,
                         AppText.address,
                         controller.driverAddressController,
                         width: fieldWidth/1.4,
                         column: true,
                         textInputAction: TextInputAction.next,
                         keyboardType: TextInputType.phone,
                         formatDigitsOnly: false),
                   ),
                 ],
               ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        CustomButton(
                          verticalPadding: 0.0,
                          width: fieldWidth/1.4,
                          borderRadius: 4,
                          height: 35,
                        onTap: (){
                            if(controller.driverUserNameController.text.isEmpty
                                || controller.driverPasswordController.text.isEmpty || controller.driverFullNameController.text.isEmpty || controller.driverMobileController.text.isEmpty
                            ){
                              BotToast.showText(text: "Please enter below fields is required\n user name, driver full name, driver mobile number,");
                            }else{
                              if(controller.vehicleInformation.value && controller.vehicleType == null){
                                BotToast.showText(text: "Please select the company vehicle type");
                              }else{
                                controller.addDriverFtn();
                              }
                            }

                        },
                        style: mozillaTextSemiBoldText(
                          fontSize: 16,
                          color: DynamicColors.whiteClr
                        ),
                          btnColor: DynamicColors.primaryClr,
                          btnText: controller.singleDriverData ==null? AppText.save:AppText.update,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
        );
      }
    );
  }
}