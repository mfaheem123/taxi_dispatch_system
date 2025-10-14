
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/image_pick_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'controller.dart';

class CreateCompanyVehicle extends StatefulWidget {
  const CreateCompanyVehicle({super.key});

  @override
  State<CreateCompanyVehicle> createState() => _CreateCompanyVehicleState();
}

class _CreateCompanyVehicleState extends State<CreateCompanyVehicle> {

  VehicleController controller = Get.isRegistered<VehicleController>()
      ? Get.find<VehicleController>()
      : Get.put(VehicleController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    shortCutKeyValue.value = "createCompanyVehicle";
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
                Container(
                  // height: screenHeight / 20,
                  width: Get.width,
                  color: DynamicColors.gryClr,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                    child: Text(AppText.companyVehicle,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
        Wrap(
        runSpacing: 16,
        spacing: 10,
          children: [
            CustomTextField(
              borderRadius: 4,
              controller: controller.vehicleTypeController,
              width: fieldWidth,
              hintText: AppText.vehicleType,
              columnText: true,
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.vehicleType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                RestrictedDrivers(
                  width: fieldWidth/1.5,
                  // height: 35,
                  padding: 0.0,
                  border: Border.all(
                    color: DynamicColors.gryClr,
                  ),
                  titleText: "ESTAT",
                  driversList: [
                    "25 GEORGE HAMPTON",
                    "26 PAUL DOUBLEDAY",
                    "27 RICHARD HARDWICK",
                    "28 LANRE OKERJO",
                  ],
                ),
              ],
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.colorController,
              width: fieldWidth,
              hintText: AppText.color,
              columnText: true,
              height: 30,
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.vehicleMakeController,
              width: fieldWidth,
              hintText: AppText.make,
              columnText: true,
              height: 30,
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.vehicleModelController,
              width: fieldWidth,
              hintText: AppText.model,
              columnText: true,
              height: 30,
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.logBookingDocController,
              width: fieldWidth,
              hintText: AppText.logBookingDoc,
              columnText: true,
              height: 30,
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.phcVehicleExpire,
              column: true,
              width: fieldWidth/1.5,
              child: SizedBox(height: 30, child: KeyboardDatePicker()),
            ),

            labeledField(
              context: context,
              isMobile: isMobile,
              column: true,
              label: AppText.phcVehicleExpire,
              width: fieldWidth/1.5,
              child: SizedBox(height: 30, child: CustomTimePicker()),
            ),

            CustomTextField(
              borderRadius: 4,
              controller: controller.phcVehicleNumberController,
              width: fieldWidth,
              hintText: AppText.phcVehicleNumber,
              columnText: true,
              height: 30,
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.motExpiry,
              column: true,
              width: fieldWidth/1.5,
              child: SizedBox(height: 30, child: KeyboardDatePicker()),
            ),

            labeledField(
              context: context,
              isMobile: isMobile,
              column: true,
              label: AppText.motExpiry,
              width: fieldWidth/1.5,
              child: SizedBox(height: 30, child: CustomTimePicker()),
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.motNumberController,
              width: fieldWidth,
              hintText: AppText.motNumber,
              columnText: true,
              height: 30,
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.mot2Expiry,
              column: true,
              width: fieldWidth/1.5,
              child: SizedBox(height: 30, child: KeyboardDatePicker()),
            ),

            labeledField(
              context: context,
              isMobile: isMobile,
              column: true,
              label: AppText.mot2Expiry,
              width: fieldWidth/1.5,
              child: SizedBox(height: 30, child: CustomTimePicker()),
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.mot2NumberController,
              width: fieldWidth,
              hintText: AppText.mot2Number,
              columnText: true,
              height: 30,
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.insuranceExpiry,
              column: true,
              width: fieldWidth/1.5,
              child: SizedBox(height: 30, child: KeyboardDatePicker()),
            ),

            labeledField(
              context: context,
              isMobile: isMobile,
              column: true,
              label: AppText.insuranceExpiry,
              width: fieldWidth/1.5,
              child: SizedBox(height: 30, child: CustomTimePicker()),
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.insuranceNumberController,
              width: fieldWidth,
              hintText: AppText.insuranceNumber,
              columnText: true,
              height: 30,
            ),
          ],
        ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  // height: screenHeight / 20,
                  width: Get.width,
                  color: DynamicColors.gryClr,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                    child: Text(AppText.companyVehiclePicture,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.phcVehicleDoc,
                          style: mozillaTextRegularText(fontSize: 11),
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: isMobile ? 100 : 200,
                              width: fieldWidth/1.5,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                image:  controller.phcVehicleDocPic == null ? null : DecorationImage(
                                  image: MemoryImage(controller.phcVehicleDocPic!), // ✅ correct provider
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: controller.phcVehicleDocPic != null ? SizedBox.shrink() : Center(
                                child: Text(
                                  AppText.phcVehicleDoc,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if(controller.phcVehicleDocPic == null){
                              final image = await ImagePickerHelper.pickImage();
                              if (image != null) {
                                controller.phcVehicleDocPic = image.bytes;
                              }
                            }else{
                                  controller.phcVehicleDocPic = null;
                                }
                                controller.update();
                          },
                              child: Icon(controller.phcVehicleDocPic != null ? Icons.remove_circle :Icons.add_circle_outlined,
                              size: 30,
                              color: DynamicColors.primaryClr,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.motDoc,
                          style: mozillaTextRegularText(fontSize: 11),
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: isMobile ? 100 : 200,
                              width: fieldWidth/1.5,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                image:  controller.motDocPic == null ? null : DecorationImage(
                                  image: MemoryImage(controller.motDocPic!), // ✅ correct provider
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: controller.motDocPic != null ? SizedBox.shrink() :Center(
                                child: Text(
                                  AppText.motDoc,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if(controller.motDocPic == null){
                                  final image = await ImagePickerHelper.pickImage();
                                  if (image != null) {
                                    controller.motDocPic = image.bytes;
                                  }
                                }else{
                                  controller.motDocPic = null;
                                }
                                controller.update();
                              },
                              child: Icon(controller.motDocPic != null ? Icons.remove_circle :Icons.add_circle_outlined,
                                size: 30,
                                color: DynamicColors.primaryClr,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.mot2Doc,
                          style: mozillaTextRegularText(fontSize: 11),
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: isMobile ? 100 : 200,
                              width: fieldWidth/1.5,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                image:  controller.mot2DocPic == null ? null : DecorationImage(
                                  image: MemoryImage(controller.mot2DocPic!), // ✅ correct provider
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: controller.mot2DocPic != null ? SizedBox.shrink() : Center(
                                child: Text(AppText.mot2Doc,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if(controller.mot2DocPic == null){
                                  final image = await ImagePickerHelper.pickImage();
                                  if (image != null) {
                                    controller.mot2DocPic = image.bytes;
                                  }
                                }else{
                                  controller.mot2DocPic = null;
                                }
                                controller.update();
                              },
                              child: Icon(controller.mot2DocPic != null ? Icons.remove_circle :Icons.add_circle_outlined,
                                size: 30,
                                color: DynamicColors.primaryClr,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.insuranceDoc,
                          style: mozillaTextRegularText(fontSize: 11),
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: isMobile ? 100 : 200,
                              width: fieldWidth/1.5,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                image:  controller.insuranceDocPic == null ? null : DecorationImage(
                                  image: MemoryImage(controller.insuranceDocPic!), // ✅ correct provider
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: controller.insuranceDocPic != null ? SizedBox.shrink() : Center(
                                child: Text(
                                  AppText.insuranceDoc,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if(controller.insuranceDocPic == null){
                                  final image = await ImagePickerHelper.pickImage();
                                  if (image != null) {
                                    controller.insuranceDocPic = image.bytes;
                                  }
                                }else{
                                  controller.insuranceDocPic = null;
                                }
                                controller.update();
                              },
                              child: Icon(controller.insuranceDocPic != null ? Icons.remove_circle :Icons.add_circle_outlined,
                                size: 30,
                                color: DynamicColors.primaryClr,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  height: 35,
                  verticalPadding: 0.0,
                  borderRadius: 4,
                  fontSize: 12,
                  btnText: AppText.save,
                )
              ],
            );
          }
        );
      }
    );
  }
}
