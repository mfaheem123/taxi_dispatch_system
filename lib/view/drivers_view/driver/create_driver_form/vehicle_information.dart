import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
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
    return PageScrollWrapper(
      child: GetBuilder<DriverController>(builder: (controller) {
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
            width: Get.width / 2.6,
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
                      AppText.vehicleInformation,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        /// vehicleInformation
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
                        /// COMPANY TYPE
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(19),
                          child: CustomDropdownField<CompanyVehicleObject>(
                            text: "COMPANY TYPE",
                            label: "SELECT COMPANY ",
                            width: fieldWidth / 2,
                            height: 35,
                            items: (controller.vehicleInformation.value == false || controller.getCombineVehicleData == null)
                                ? []
                                : controller.getCombineVehicleData?.companyVehicles ?? [],
                            value: controller.vehicleType,
                            itemLabel: (templateList) =>
                                templateList.vehicleTypeName!.toUpperCase(),
                            onChanged: (val) {
                              controller.vehicleType = val;
                              controller.update();
                            },
                          ),
                        ),
                        /// Date
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(20),
                          child: labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.startDate,
                              width: fieldWidth / 1.4,
                              child: SizedBox(
                                height: 30,
                                child: KeyboardDatePicker(
                                  key: ValueKey("vehicle_start_date${controller.datePickerKey}"),
                                  initialDate: DateTime.tryParse(controller.vehicleStartDate ?? '') ?? DateTime.now(),
                                  onChanged: (date) => controller.vehicleStartDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                  onSubmitted: (date) => controller.vehicleStartDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                ),
                              ),
                              column: true),
                        ),
                        /// end date
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(21),
                          child: labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.endDate,
                              width: fieldWidth / 1.4,
                              child: SizedBox(
                                height: 30,
                                child: KeyboardDatePicker(
                                  key: ValueKey("vehicle_end_date${controller.datePickerKey}"),
                                  initialDate: DateTime.tryParse(controller.vehicleEndeDate ?? '') ?? DateTime.now(),
                                  onChanged: (date) => controller.vehicleEndeDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                  onSubmitted: (date) => controller.vehicleEndeDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                ),
                              ),
                              column: true),
                        ),
                        /// vehicle
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(22),
                          child: labeledTextField(context, isMobile, AppText.vehicle,
                              controller.vehicleNameController,
                              width: fieldWidth / 1.4,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              column: true),
                        ),
                        /// make
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(23),
                          child: labeledTextField(context, isMobile, AppText.make,
                              controller.vehicleMakeController,
                              width: fieldWidth / 1.4,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              column: true),
                        ),
                        /// Model
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(24),
                          child: labeledTextField(context, isMobile, AppText.model,
                              controller.vehicleModelController,
                              width: fieldWidth / 1.4,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              column: true),
                        ),
                        /// Color
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(25),
                          child: labeledTextField(context, isMobile, AppText.color,
                            controller.vehicleColorController,
                            width: fieldWidth / 1.4,
                            textInputAction: TextInputAction.next,
                            readOnly: controller.vehicleInformation.value,
                            borderWidth: controller.vehicleInformation.value ? 0 : 2,
                            borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                            column: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                              UpperCaseTextFormatter(),
                            ],
                          ),
                        ),
                        /// owner
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(26),
                          child: labeledTextField(context, isMobile, AppText.owner,
                              controller.vehicleOwnerController,
                              width: fieldWidth / 1.4,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              column: true),
                        ),
                        /// Log book
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(27),
                          child: labeledTextField(context, isMobile, AppText.logBook,
                              controller.vehicleLogBookController,
                              width: fieldWidth / 1.4,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              column: true),
                        ),
                        /// VEHICLE TYPE
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(28),
                          child: CustomDropdownField<SubsidiaryObject>(
                            label: "VEHICLE TYPE",
                            text: "VEHICLE TYPE",
                            width: fieldWidth / 1.4,
                            height: 35,
                            items: (controller.vehicleInformation.value == true || controller.getCombineVehicleData == null)
                                ? []
                                : controller.getCombineVehicleData?.vehicleTypes ?? [],
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
                        /// CHOOSE FILE
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(29),
                          child: Container(
                            height: 130,
                            width: fieldWidth / 1.4,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                /// Choose File Button
                                GestureDetector(
                                  onTap: () {
                                    if (controller.vehicleInformation.value == false) {
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

                                /// Column containing Picture (top) and File Name / NO FILE CHOSEN text (bottom)
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      /// Picture inside CHOOSE FILE container (if image exists)
                                      if (controller.imageList.isNotEmpty ||
                                          ((controller.singleDriverData?.driver?.vehicle?.logBook?.logBookDocument != null) &&
                                              controller.singleDriverData!.driver!.vehicle!.logBook!.logBookDocument!.isNotEmpty)) ...[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 2.0),
                                          child: SizedBox(
                                            height: 50,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(4),
                                                  child: controller.imageList.isNotEmpty
                                                      ? Image.memory(
                                                          controller.imageList[0].bytes,
                                                          width: 160,
                                                          height: 190,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image(
                                                          image: NetworkImage(
                                                            controller.singleDriverData?.driver?.vehicle?.logBook?.logBookDocument ?? "",
                                                          ),
                                                          width: 160,
                                                          height: 250,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                                                        ),
                                                ),
                                                Positioned(
                                                  top: -4,
                                                  right: -4,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller.imageList.clear();
                                                      if (controller.singleDriverData?.driver?.vehicle?.logBook != null) {
                                                        controller.singleDriverData!.driver!.vehicle!.logBook!.logBookDocument = null;
                                                      }
                                                      controller.update();
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 7,
                                                      backgroundColor: DynamicColors.whiteClr,
                                                      child: Icon(
                                                        Icons.close,
                                                        color: DynamicColors.primaryClr,
                                                        size: 11,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],

                                      /// Text: File name or "NO FILE CHOSEN"
                                      Text(
                                        controller.imageList.isNotEmpty
                                            ? controller.imageList[0].name
                                            : (controller.singleDriverData?.driver?.vehicle?.logBook?.logBookDocument != null &&
                                                    controller.singleDriverData!.driver!.vehicle!.logBook!.logBookDocument!.isNotEmpty)
                                                ? controller.singleDriverData!.driver!.vehicle!.logBook!.logBookDocument!.split('/').last
                                                : "NO FILE CHOSEN",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),

                                /// Delete Button
                                GestureDetector(
                                  onTap: () {
                                    controller.imageList.clear();
                                    if (controller.singleDriverData?.driver?.vehicle?.logBook != null) {
                                      controller.singleDriverData!.driver!.vehicle!.logBook!.logBookDocument = null;
                                    }
                                    controller.update();
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    color: Colors.red,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    alignment: Alignment.center,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}
