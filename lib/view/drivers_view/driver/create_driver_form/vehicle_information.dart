
import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../component/dropdown_button.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';
import '../../model/driver_form_model.dart';

class VehicleInformation extends StatelessWidget {
  VehicleInformation({super.key});

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        double containerWidth = Get.width / 2.6;
        double fieldWidth = (containerWidth - 60) / 4;

        ///
        return Container(
          width: Get.width / 2.6,
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
                    AppText.vehicleInformation,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Divider(height: 1),

              Wrap(
                spacing: 7,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(18),
                    child: Checkbox(
                      value: controller.vehicleInformation.value,
                      onChanged: (val) {
                        controller.vehicleInformation.value = val!;
                        controller.update();
                      },
                    ),
                  ),
                  Text(AppText.usedCompanyVehicle),
                  FocusTraversalOrder(

                    order: const NumericFocusOrder(19),
                    child: CustomDropdownField<CompanyVehicleObject>(
                      text: "COMPANY TYPE",
                      label: "SELECT COMPANY ",
                      width: fieldWidth/2,
                      height: 35,
                      // items: controller.vehicleInformation.value ==false?[]: controller.getCombineVehicleData!.companyVehicles!,
                      items: (controller.vehicleInformation.value == false || controller.getCombineVehicleData == null)
                          ? []
                          : controller.getCombineVehicleData?.companyVehicles ?? [],
                      // items: controller.locationtypezoneModel!
                      //     .zonesList!,
                      value: controller.vehicleType,
                      itemLabel: (templateList) =>
                          templateList.vehicleTypeName!.toUpperCase(),
                      onChanged: (val) {
                        controller.vehicleType = val;
                        controller.update();
                      },
                    ),
                  ),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(20),
                    child: labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.startDate,
                        width: fieldWidth / 1.4,
                        child:
                        SizedBox(height: 30, child:
                        KeyboardDatePicker(
                          key: ValueKey("vehicle_start_date${controller.datePickerKey}"),
                          initialDate: DateTime.tryParse(controller.vehicleStartDate ?? '') ?? DateTime.now(),
                          onChanged: (date) => controller.vehicleStartDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                          onSubmitted: (date) => controller.vehicleStartDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                        )
                          // KeyboardDatePicker(
                          //   initialDate: DateTime.now(),
                          //   onChanged: (date) {
                          //     // jab bhi user change kare
                          //     controller.vehicleStartDate = "${date.year}-${date.month}-${date.day}";
                          //     print(date);
                          //   },
                          //   onSubmitted: (date) {
                          //     // jab user enter press kare
                          //     controller.vehicleStartDate = "${date.year}-${date.month}-${date.day}";
                          //     print("User pressed enter: $date");
                          //   },
                          // )
                        ),
                        column: true),
                  ),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(21),
                    child: labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.endDate,
                        width: fieldWidth / 1.4,
                        child:
                        SizedBox(height: 30, child:
                        KeyboardDatePicker(
                          key: ValueKey("vehicle_end_date${controller.datePickerKey}"),
                          initialDate: DateTime.tryParse(controller.vehicleEndeDate ?? '') ?? DateTime.now(),
                          onChanged: (date) => controller.vehicleEndeDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                          onSubmitted: (date) => controller.vehicleEndeDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                        )
                        ),
                        column: true),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(22),
                    child: labeledTextField(context, isMobile, AppText.vehicle,
                        controller.vehicleNameController,
                        width: fieldWidth / 1.4,
                        textInputAction: TextInputAction.next,
                        readOnly:controller.vehicleInformation.value,
                        borderWidth: controller.vehicleInformation.value?0:2,
                        borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
                        column: true),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(23),
                    child: labeledTextField(context, isMobile, AppText.make,
                        controller.vehicleMakeController,
                        width: fieldWidth / 1.4,
                        textInputAction: TextInputAction.next,
                        readOnly:controller.vehicleInformation.value,
                        borderWidth: controller.vehicleInformation.value?0:2,
                        borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
                        column: true),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(24),
                    child: labeledTextField(context, isMobile, AppText.model,
                        controller.vehicleModelController,
                        width: fieldWidth / 1.4,
                        textInputAction: TextInputAction.next,
                        readOnly:controller.vehicleInformation.value,
                        borderWidth: controller.vehicleInformation.value?0:2,
                        borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
                        column: true),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(25),
                    child: labeledTextField(context, isMobile, AppText.color,
                      controller.vehicleColorController,
                      width: fieldWidth / 1.4,
                      textInputAction: TextInputAction.next,
                      readOnly:controller.vehicleInformation.value,
                      borderWidth: controller.vehicleInformation.value?0:2,
                      borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
                      column: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                        UpperCaseTextFormatter(),
                      ],
                    ),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(26),
                    child: labeledTextField(context, isMobile, AppText.owner,
                        controller.vehicleOwnerController,
                        width: fieldWidth / 1.4,
                        textInputAction: TextInputAction.next,
                        readOnly:controller.vehicleInformation.value,
                        borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
                        borderWidth: controller.vehicleInformation.value?0:2,
                        column: true),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(27),
                    child: labeledTextField(context, isMobile, AppText.logBook,
                        controller.vehicleLogBookController,
                        width: fieldWidth / 1.4,
                        textInputAction: TextInputAction.next,
                        readOnly:controller.vehicleInformation.value,
                        borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
                        borderWidth: controller.vehicleInformation.value?0:2,
                        column: true),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(28),
                    child: CustomDropdownField<SubsidiaryObject>(
                      label: "VEHICLE TYPE",
                      width: fieldWidth/2,
                      height: 35,
                      // items: controller.vehicleInformation.value?[]: controller.getCombineVehicleData!.vehicleTypes!,
                      items: (controller.vehicleInformation.value == true || controller.getCombineVehicleData == null)
                          ? []
                          : controller.getCombineVehicleData?.vehicleTypes ?? [],
                      // items: controller.locationtypezoneModel!
                      //     .zonesList!,
                      // value: controller.selectCompanyVehicle,
                      value: (controller.vehicleInformation.value == true || controller.getCombineVehicleData == null)
                          ? null
                          : controller.selectCompanyVehicle,
                      itemLabel: (templateList) =>
                          templateList.name!.toUpperCase(),
                      onChanged: (val) {
                        controller.selectCompanyVehicle = val;
                        controller.update();
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 6,
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 150,
                            width: Get.width / 6,
                            // width: 150,
                            child: (controller.imageList.isEmpty) && ((controller.singleDriverData == null)||(controller.singleDriverData!.driver!.vehicle == null))?SizedBox.shrink():
                            controller.imageList.isNotEmpty? Image.memory(
                              controller.imageList[0].bytes,
                              width: 500,
                              height: 150,
                              fit: BoxFit.fill,
                            ):Image(image: NetworkImage(controller.singleDriverData?.driver?.vehicle?.logBook?.logBookDocument ?? "")),
                          ),
                          controller.imageList.isEmpty?SizedBox.shrink():
                          GestureDetector(
                            onTap: () {
                              controller.imageList.remove(controller.imageList[0]);
                              controller.update();
                            },
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: DynamicColors.whiteClr,
                              child: Icon(
                                Icons.close,
                                color: DynamicColors.primaryClr,
                                size: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              FocusTraversalOrder(
                order: NumericFocusOrder(29),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 15),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        // Choose File
                        GestureDetector(
                          onTap: () {
                            if(controller.vehicleInformation.value == false){
                              controller.pickImage();
                            }
                          },
                          child: Container(
                            height: double.infinity,
                            color: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            child: const Text(
                              "CHOOSE FILE",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "NO FILE CHOSEN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            controller.imageList.clear();
                            controller.update();
                          },
                          child: Container(
                            height: double.infinity,
                            color: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        );
      });
    });
  }
}

/// import 'package:dashboard_new1/component/color.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import '../../../../alert/restrict_drivers_alert.dart';
// import '../../../../component/dropdown_button.dart';
// import '../../../../component/text_field.dart';
// import '../../../../component/text_widget.dart';
// import '../../../dashboard_view/widgets/time_picker_widget.dart';
// import '../../../dashboard_view/widgets/user_info_widget.dart';
// import '../../controller/driver_controller.dart';
// import '../../model/driver_form_model.dart';
//
// class VehicleInformation extends StatelessWidget {
//   VehicleInformation({super.key});
//
//   DriverController controller = Get.isRegistered<DriverController>()
//       ? Get.find<DriverController>()
//       : Get.put(DriverController());
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<DriverController>(builder: (controller) {
//       return LayoutBuilder(builder: (context, constraints) {
//         final double maxWidth = constraints.maxWidth;
//         final bool isMobile = maxWidth < 600;
//         final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
//
//         // Instead of fixed width, we calculate flexible field widths
//         final double fieldWidth = isMobile
//             ? maxWidth // full width
//             : isTablet
//             ? maxWidth / 2
//             : maxWidth / 4;
///
//         return Container(
//           width: Get.width / 2.6,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(6),
//             border: Border.all(color: Colors.grey.shade400, width: 1),
//           ),
//           margin: EdgeInsets.only(bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Header
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.all(14),
//                   child: Text(
//                     AppText.vehicleInformation,
//                     style: const TextStyle(
//                         fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//
//               Divider(height: 1),
//
//               Wrap(
//                 spacing: 7,
//                 runSpacing: 10,
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 children: [
//                   FocusTraversalOrder(
//                     order: const NumericFocusOrder(18),
//                     child: Checkbox(
//                       value: controller.vehicleInformation.value,
//                       onChanged: (val) {
//                         controller.vehicleInformation.value = val!;
//                         controller.update();
//                       },
//                     ),
//                   ),
//                   Text(AppText.usedCompanyVehicle),
//                   FocusTraversalOrder(
//
//                     order: const NumericFocusOrder(19),
//                     child: CustomDropdownField<CompanyVehicleObject>(
//                       text: "COMPANY TYPE",
//                       label: "SELECT COMPANY ",
//                       width: fieldWidth/2,
//                       height: 35,
//                       // items: controller.vehicleInformation.value ==false?[]: controller.getCombineVehicleData!.companyVehicles!,
//                       items: (controller.vehicleInformation.value == false || controller.getCombineVehicleData == null)
//                           ? []
//                           : controller.getCombineVehicleData?.companyVehicles ?? [],
//                       // items: controller.locationtypezoneModel!
//                       //     .zonesList!,
//                       value: controller.vehicleType,
//                       itemLabel: (templateList) =>
//                           templateList.vehicleTypeName!.toUpperCase(),
//                       onChanged: (val) {
//                         controller.vehicleType = val;
//                         controller.update();
//                       },
//                     ),
//                   ),
//                   FocusTraversalOrder(
//                     order: const NumericFocusOrder(20),
//                     child: labeledField(
//                         context: context,
//                         isMobile: isMobile,
//                         label: AppText.startDate,
//                         width: fieldWidth / 1.4,
//                         child:
//                         SizedBox(height: 30, child:
//                         KeyboardDatePicker(
//                           key: ValueKey("vehicle_start_date${controller.datePickerKey}"),
//                           initialDate: DateTime.tryParse(controller.vehicleStartDate ?? '') ?? DateTime.now(),
//                           onChanged: (date) => controller.vehicleStartDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//                           onSubmitted: (date) => controller.vehicleStartDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//                         )
//                           // KeyboardDatePicker(
//                           //   initialDate: DateTime.now(),
//                           //   onChanged: (date) {
//                           //     // jab bhi user change kare
//                           //     controller.vehicleStartDate = "${date.year}-${date.month}-${date.day}";
//                           //     print(date);
//                           //   },
//                           //   onSubmitted: (date) {
//                           //     // jab user enter press kare
//                           //     controller.vehicleStartDate = "${date.year}-${date.month}-${date.day}";
//                           //     print("User pressed enter: $date");
//                           //   },
//                           // )
//                         ),
//                         column: true),
//                   ),
//                   FocusTraversalOrder(
//                     order: const NumericFocusOrder(21),
//                     child: labeledField(
//                         context: context,
//                         isMobile: isMobile,
//                         label: AppText.endDate,
//                         width: fieldWidth / 1.4,
//                         child:
//                         SizedBox(height: 30, child:
//                         KeyboardDatePicker(
//                           key: ValueKey("vehicle_end_date${controller.datePickerKey}"),
//                           initialDate: DateTime.tryParse(controller.vehicleEndeDate ?? '') ?? DateTime.now(),
//                           onChanged: (date) => controller.vehicleEndeDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//                           onSubmitted: (date) => controller.vehicleEndeDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//                         )
//                           // KeyboardDatePicker(
//                           //   initialDate: DateTime.now(),
//                           //   onChanged: (date) {
//                           //     // jab bhi user change kare
//                           //     controller.vehicleEndeDate = "${date.year}-${date.month}-${date.day}";
//                           //     print(date);
//                           //   },
//                           //   onSubmitted: (date) {
//                           //     // jab user enter press kare
//                           //     controller.vehicleEndeDate = "${date.year}-${date.month}-${date.day}";
//                           //     print("User pressed enter: $date");
//                           //   },
//                           // )
//                         ),
//                         column: true),
//                   ),
//                   FocusTraversalOrder(
//                     order: NumericFocusOrder(22),
//                     child: labeledTextField(context, isMobile, AppText.vehicle,
//                         controller.vehicleNameController,
//                         width: fieldWidth / 1.4,
//                         textInputAction: TextInputAction.next,
//                         readOnly:controller.vehicleInformation.value,
//                         borderWidth: controller.vehicleInformation.value?0:2,
//                         borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
//                         column: true),
//                   ),
//                   FocusTraversalOrder(
//                     order: NumericFocusOrder(23),
//                     child: labeledTextField(context, isMobile, AppText.make,
//                         controller.vehicleMakeController,
//                         width: fieldWidth / 1.4,
//                         textInputAction: TextInputAction.next,
//                         readOnly:controller.vehicleInformation.value,
//                         borderWidth: controller.vehicleInformation.value?0:2,
//                         borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
//                         column: true),
//                   ),
//                   FocusTraversalOrder(
//                     order: NumericFocusOrder(24),
//                     child: labeledTextField(context, isMobile, AppText.model,
//                         controller.vehicleModelController,
//                         width: fieldWidth / 1.4,
//                         textInputAction: TextInputAction.next,
//                         readOnly:controller.vehicleInformation.value,
//                         borderWidth: controller.vehicleInformation.value?0:2,
//                         borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
//                         column: true),
//                   ),
//                   FocusTraversalOrder(
//                     order: NumericFocusOrder(25),
//                     child: labeledTextField(context, isMobile, AppText.color,
//                       controller.vehicleColorController,
//                       width: fieldWidth / 1.4,
//                       textInputAction: TextInputAction.next,
//                       readOnly:controller.vehicleInformation.value,
//                       borderWidth: controller.vehicleInformation.value?0:2,
//                       borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
//                       column: true,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
//                         UpperCaseTextFormatter(),
//                       ],
//                     ),
//                   ),
//                   FocusTraversalOrder(
//                     order: NumericFocusOrder(26),
//                     child: labeledTextField(context, isMobile, AppText.owner,
//                         controller.vehicleOwnerController,
//                         width: fieldWidth / 1.4,
//                         textInputAction: TextInputAction.next,
//                         readOnly:controller.vehicleInformation.value,
//                         borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
//                         borderWidth: controller.vehicleInformation.value?0:2,
//                         column: true),
//                   ),
//                   FocusTraversalOrder(
//                     order: NumericFocusOrder(27),
//                     child: labeledTextField(context, isMobile, AppText.logBook,
//                         controller.vehicleLogBookController,
//                         width: fieldWidth / 1.4,
//                         textInputAction: TextInputAction.next,
//                         readOnly:controller.vehicleInformation.value,
//                         borderColor: controller.vehicleInformation.value?Colors.grey:DynamicColors.primaryClr,
//                         borderWidth: controller.vehicleInformation.value?0:2,
//                         column: true),
//                   ),
//                   FocusTraversalOrder(
//                     order: NumericFocusOrder(28),
//                     child: CustomDropdownField<SubsidiaryObject>(
//                       label: "VEHICLE TYPE",
//                       width: fieldWidth/2,
//                       height: 35,
//                       // items: controller.vehicleInformation.value?[]: controller.getCombineVehicleData!.vehicleTypes!,
//                       items: (controller.vehicleInformation.value == true || controller.getCombineVehicleData == null)
//                           ? []
//                           : controller.getCombineVehicleData?.vehicleTypes ?? [],
//                       // items: controller.locationtypezoneModel!
//                       //     .zonesList!,
//                       // value: controller.selectCompanyVehicle,
//                       value: (controller.vehicleInformation.value == true || controller.getCombineVehicleData == null)
//                           ? null
//                           : controller.selectCompanyVehicle,
//                       itemLabel: (templateList) =>
//                           templateList.name!.toUpperCase(),
//                       onChanged: (val) {
//                         controller.selectCompanyVehicle = val;
//                         controller.update();
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     width: Get.width / 6,
//                     height: 150,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Stack(
//                         children: [
//                           SizedBox(
//                             height: 150,
//                             width: Get.width / 6,
//                             // width: 150,
//                             child: (controller.imageList.isEmpty) && ((controller.singleDriverData == null)||(controller.singleDriverData!.driver!.vehicle == null))?SizedBox.shrink():
//                             controller.imageList.isNotEmpty? Image.memory(
//                               controller.imageList[0].bytes,
//                               width: 500,
//                               height: 150,
//                               fit: BoxFit.fill,
//                             ):Image(image: NetworkImage(controller.singleDriverData?.driver?.vehicle?.logBook?.logBookDocument ?? "")),
//                           ),
//                           controller.imageList.isEmpty?SizedBox.shrink():
//                           GestureDetector(
//                             onTap: () {
//                               controller.imageList.remove(controller.imageList[0]);
//                               controller.update();
//                             },
//                             child: CircleAvatar(
//                               radius: 10,
//                               backgroundColor: DynamicColors.whiteClr,
//                               child: Icon(
//                                 Icons.close,
//                                 color: DynamicColors.primaryClr,
//                                 size: 15,
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     child: ListView.builder(
//                     //     itemCount: controller.imageList.length,
//                     //     shrinkWrap: true,
//                     //     scrollDirection: Axis.horizontal,
//                     //     physics: AlwaysScrollableScrollPhysics(),
//                     //     itemBuilder: (BuildContext context, index) {
//                     //       return Padding(
//                     //         padding: const EdgeInsets.all(8.0),
//                     //         child: Stack(
//                     //           children: [
//                     //             SizedBox(
//                     //               height: 150,
//                     //               width: Get.width / 6,
//                     //               // width: 150,
//                     //               child: Image.memory(
//                     //                 controller.imageList[index].bytes,
//                     //                 width: 500,
//                     //                 height: 150,
//                     //                 fit: BoxFit.fill,
//                     //               ),
//                     //             ),
//                     //             GestureDetector(
//                     //               onTap: () {
//                     //                 controller.imageList
//                     //                     .remove(controller.imageList[index]);
//                     //                 controller.update();
//                     //               },
//                     //               child: CircleAvatar(
//                     //                 radius: 10,
//                     //                 backgroundColor: DynamicColors.whiteClr,
//                     //                 child: Icon(
//                     //                   Icons.close,
//                     //                   color: DynamicColors.primaryClr,
//                     //                   size: 15,
//                     //                 ),
//                     //               ),
//                     //             )
//                     //           ],
//                     //         ),
//                     //       );
//                     //     }),
//                   )
//                 ],
//               ),
//               FocusTraversalOrder(
//                 order: NumericFocusOrder(29),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 23, vertical: 15),
//                   child: Container(
//                     height: 40,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Row(
//                       children: [
//                         // Choose File
//                         GestureDetector(
//                           onTap: () {
//                             if(controller.vehicleInformation.value == false){
//                               controller.pickImage();
//                             }
//                           },
//                           child: Container(
//                             height: double.infinity,
//                             color: Colors.grey[300],
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             alignment: Alignment.center,
//                             child: const Text(
//                               "CHOOSE FILE",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(width: 8),
//                         const Expanded(
//                           child: Text(
//                             "NO FILE CHOSEN",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 13,
//                               color: Colors.black54,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//
//                         GestureDetector(
//                           onTap: () {
//                             controller.imageList.clear();
//                             controller.update();
//                           },
//                           child: Container(
//                             height: double.infinity,
//                             color: Colors.red,
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             child: const Icon(
//                               Icons.delete,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 12),
//               /*      Container(
//                         alignment: Alignment.centerLeft,
//                         padding: EdgeInsets.only(left: 23),
//                         child: FocusTraversalOrder(
//                           order: const NumericFocusOrder(11),
//                           child: labeledTextField(context,
//                               isMobile,
//                               AppText.address,
//                               controller.driverAddressController,
//                               width: fieldWidth,
//                               column: true,
//                               textInputAction: TextInputAction.next,
//                               keyboardType: TextInputType.phone,
//                               formatDigitsOnly: false),
//                         ),
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: CustomButton(
//                           verticalPadding: 0.0,
//                           width: fieldWidth*2,
//                           borderRadius: 4,
//                           height: 35,
//
//                           btnColor: DynamicColors.primaryClr,
//                           btnText: AppText.save,
//                         ),
//                       )*/
//             ],
//           ),
//         );
//       });
//     });
//   }
// }