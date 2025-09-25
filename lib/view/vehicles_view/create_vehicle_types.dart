

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/vehicles_view/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/color_picker_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../booking_view/reusable_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';


class CreateVehicleTypes extends StatefulWidget {
  const CreateVehicleTypes({super.key});

  @override
  State<CreateVehicleTypes> createState() => _CreateVehicleTypesState();
}

class _CreateVehicleTypesState extends State<CreateVehicleTypes> {

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

  VehicleController controller = Get.isRegistered<VehicleController>()
      ? Get.find<VehicleController>()
      : Get.put(VehicleController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "vehicleTypes";
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<VehicleController>(builder: (controller) {

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

          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Wrap(
                runSpacing: 16,
                spacing: 10,
                children: [
                  GestureDetector(
                    onTap: (){
                      if(controller.profileImg == null){
                        controller.pickImage();
                      }
                    },
                    child: Container(
                      height: isMobile ? 200 : 400,
                      width: fieldWidth,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        image:  controller.profileImg == null ? null : DecorationImage(
                          image: MemoryImage(controller.profileImg!.bytes), // ✅ correct provider
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: controller.profileImg != null? Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: (){
                            controller.profileImg = null;
                            controller.update();
                          },
                          child: Icon(Icons.close_rounded,
                            color: DynamicColors.redClr,
                          ),
                        ),
                      ): Center(
                        child: Text(
                          "UPLOAD IMAGE",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth*2.7,
                    child: Column(
                      children: [
                        Container(
                          // height: screenHeight / 20,
                          width: Get.width,
                          color: Colors.grey.withOpacity(0.3),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                            child: Text(
                              AppText.vehicleType,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        customWidget(
                          value: controller.defaultVehicleValue.value,
                          onChanged: (v){
                            controller.defaultVehicleValue.value = v!;
                            controller.update();
                          },
                          text: AppText.defaultVehicle,
                          width: 140,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          runSpacing: 16,
                          spacing: 10,
                          children: [
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.vehicleTypeController,
                              width: fieldWidth/2,
                              hintText: AppText.vehicleType,
                              columnText: true,
                              height: 35,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.passengersController,
                              width: fieldWidth/2,
                              hintText: AppText.passengers,
                              columnText: true,
                              height: 35,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.luggagesController,
                              width: fieldWidth/2,
                              hintText: AppText.luggages,
                              columnText: true,
                              height: 35,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.handLuggagesController,
                              width: fieldWidth/2,
                              hintText: AppText.handLuggages,
                              columnText: true,
                              height: 35,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customWidget(
                                  value: controller.minimumMilesValue.value,
                                  onChanged: (v){
                                    controller.minimumMilesValue.value = v!;
                                    controller.update();
                                  },
                                  text: AppText.minimumMiles,
                                  width: 140,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.minimumMilesController,
                                  width: fieldWidth/2,
                                  hintText: "",
                                  readOnly: !controller.minimumMilesValue.value,
                                  columnText: false,
                                  height: 35,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customWidget(
                                  value: controller.minimumMilesValue.value,
                                  onChanged: (v){
                                    controller.minimumMilesValue.value = v!;
                                    controller.update();
                                  },
                                  text: AppText.minimumMiles,
                                  width: 140,
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.minimumFaresController,
                                  width: fieldWidth/2,
                                  hintText: "",
                                  readOnly: !controller.minimumMilesValue.value,
                                  columnText: false,
                                  height: 35,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppText.backgroundClr, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                ColorPickerWidget(
                                  width: fieldWidth/2,
                                  pickerColor: controller.pickerColor,
                                  onColorChanged: (color) {
                                    setState(() {
                                      controller.pickerColor = color; // live preview
                                    });
                                  },
                                  onColorSelected: (color) {
                                    setState(() {
                                      controller.pickerColor = color; // final selected
                                    });
                                  },
                                  borderColor: Colors.grey,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppText.foregroundClr, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                ColorPickerWidget(
                                  width: fieldWidth/2,
                                  pickerColor: controller.foregroundColor,
                                  onColorChanged: (color) {
                                    setState(() {
                                      controller.foregroundColor = color; // live preview
                                    });
                                  },
                                  onColorSelected: (color) {
                                    setState(() {
                                      controller.foregroundColor = color; // final selected
                                    });
                                  },
                                  borderColor: Colors.grey,
                                ),
                              ],
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.driverWaitingChargesController,
                              width: fieldWidth/2,
                              hintText: AppText.driverWaitingCharges,
                              columnText: true,
                              height: 35,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.accountWaitingChargesController,
                              width: fieldWidth/2,
                              hintText: AppText.accountWaitingCharges,
                              columnText: true,
                              height: 35,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.waitingTimeController,
                              width: fieldWidth/2,
                              hintText: AppText.waitingTime,
                              columnText: true,
                              height: 35,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          height: 30,
                          width: fieldWidth,
                          btnText: AppText.save,
                          fontSize: 11,
                          verticalPadding: 0.0,
                          borderRadius: 4,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      );
      }
    );
  }
}
