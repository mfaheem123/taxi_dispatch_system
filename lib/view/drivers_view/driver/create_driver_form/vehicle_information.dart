
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
                    AppText.vehicleInformation,
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
                        const Spacer(),
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(19),
                          child: CustomDropdownField<CompanyVehicleObject>(
                            text: "COMPANY ACCOUNTS",
                            label: "SELECT COMPANY VEHICLE",
                            width: fieldWidth * 1.9,
                            height: 35,
                            items: (controller.vehicleInformation.value == false || controller.getCombineVehicleData == null)
                                ? []
                                : controller.getCombineVehicleData?.companyVehicles ?? [],
                            value: controller.vehicleType,
                            itemLabel: (templateList) => templateList.vehicleTypeName!.toUpperCase(),
                            onChanged: (val) {
                              controller.vehicleType = val;
                              controller.update();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(20),
                          child: labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.startDate,
                              width: fieldWidth * 1.9,
                              child: SizedBox(
                                  height: 30,
                                  child:   KeyboardDatePicker(
                                    key: ValueKey("vehicle_start_date${controller.datePickerKey}"),
                                    initialDate: DateTime.tryParse(controller.vehicleStartDate ?? '') ?? DateTime.now(),
                                    onChanged: (date) => controller.vehicleStartDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                    onSubmitted: (date) => controller.vehicleStartDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                  )),
                              column: true),
                        ),
                        const Spacer(),
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(21),
                          child: labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.endDate,
                              width: fieldWidth * 1.9,
                              child: SizedBox(
                                  height: 30,
                                  child:   KeyboardDatePicker(
                                    key: ValueKey("vehicle_end_date${controller.datePickerKey}"),
                                    initialDate: DateTime.tryParse(controller.vehicleEndeDate ?? '') ?? DateTime.now(),
                                    onChanged: (date) => controller.vehicleEndeDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                    onSubmitted: (date) => controller.vehicleEndeDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
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
                          order: const NumericFocusOrder(22),
                          child: labeledTextField(context, isMobile, AppText.vehicle, controller.vehicleNameController,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              column: true),
                        ),
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(23),
                          child: labeledTextField(context, isMobile, AppText.make, controller.vehicleMakeController,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              column: true),
                        ),
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(24),
                          child: labeledTextField(context, isMobile, AppText.model, controller.vehicleModelController,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              column: true),
                        ),
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(25),
                          child: labeledTextField(context, isMobile, AppText.color, controller.vehicleColorController,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              column: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                UpperCaseTextFormatter(),
                              ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Row: Vehicle Type dropdown + Owner field
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// Tab order 26 - Vehicle Type dropdown (sequential after Color)
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(26),
                          child: CustomDropdownField<SubsidiaryObject>(
                            label: "VEHICLE TYPE",
                            width: fieldWidth * 1.9,
                            height: 35,
                            items: (controller.vehicleInformation.value == true || controller.getCombineVehicleData == null)
                                ? []
                                : controller.getCombineVehicleData?.vehicleTypes ?? [],
                            value: (controller.vehicleInformation.value == true || controller.getCombineVehicleData == null)
                                ? null
                                : controller.selectCompanyVehicle,
                            itemLabel: (templateList) => templateList.name!.toUpperCase(),
                            onChanged: (val) {
                              controller.selectCompanyVehicle = val;
                              controller.update();
                            },
                          ),
                        ),
                        const Spacer(),
                        /// Tab order 27 - Owner field (sequential after Vehicle Type)
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(27),
                          child: labeledTextField(context, isMobile, AppText.owner, controller.vehicleOwnerController,
                              width: fieldWidth * 1.9,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              column: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (controller.imageList.isEmpty &&
                        (controller.singleDriverData?.driver?.vehicle?.logBook?.logBookDocument == null ||
                            controller.singleDriverData!.driver!.vehicle!.logBook!.logBookDocument!.isEmpty))
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(28),
                            child: labeledTextField(context, isMobile, AppText.logBook, controller.vehicleLogBookController,
                                width: fieldWidth * 1.9,
                                textInputAction: TextInputAction.next,
                                readOnly: controller.vehicleInformation.value,
                                borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                                borderWidth: controller.vehicleInformation.value ? 0 : 2,
                                column: true),
                          ),
                          const Spacer(),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(29),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "LOG BOOK DOCUMENT",
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 35,
                                  width: fieldWidth * 1.9,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
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
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          controller.imageList.isNotEmpty
                                              ? "FILE SELECTED (1)"
                                              : "NO FILE CHOSEN",
                                          style: const TextStyle(fontSize: 11, color: Colors.black54),
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
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        /// Tab order 28 - Log Book field (sequential after Owner)
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(28),
                          child: labeledTextField(context, isMobile, AppText.logBook, controller.vehicleLogBookController,
                              width: fieldWidth * 1.9,
                              textInputAction: TextInputAction.next,
                              readOnly: controller.vehicleInformation.value,
                              borderColor: controller.vehicleInformation.value ? Colors.grey : DynamicColors.primaryClr,
                              borderWidth: controller.vehicleInformation.value ? 0 : 2,
                              column: true),
                        ),
                        const SizedBox(height: 16),

                        FocusTraversalOrder(
                          order: const NumericFocusOrder(29),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "LOG BOOK DOCUMENT",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 35,
                                width: fieldWidth * 1.9,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
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
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        controller.imageList.isNotEmpty
                                            ? "FILE SELECTED (1)"
                                            : "NO FILE CHOSEN",
                                        style: const TextStyle(fontSize: 11, color: Colors.black54),
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
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                          SizedBox(
                            width: fieldWidth * 1.9,
                            height: 140,
                            child: Stack(
                              children: [
                                Container(
                                  width: fieldWidth * 1.9,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: controller.imageList.isNotEmpty
                                        ? Image.memory(
                                      controller.imageList[0].bytes,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.network(
                                      controller.singleDriverData!.driver!.vehicle!.logBook!.logBookDocument!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (controller.imageList.isNotEmpty)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.imageList.removeAt(0);
                                        controller.update();
                                      },
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: DynamicColors.whiteClr,
                                        child: Icon(
                                          Icons.close,
                                          color: DynamicColors.primaryClr,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      });
    });
  }
}