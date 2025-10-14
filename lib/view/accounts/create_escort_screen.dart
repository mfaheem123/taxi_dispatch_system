import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:dashboard_new1/view/vehicles_view/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/color_picker_widget.dart';
import '../../component/image_pick_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../booking_view/reusable_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';

class CreateEscortScreen extends StatefulWidget {
  const CreateEscortScreen({super.key});

  @override
  State<CreateEscortScreen> createState() => _CreateEscortScreenState();
}

class _CreateEscortScreenState extends State<CreateEscortScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

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
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              children: [
                SizedBox(
                  width: Get.width,
                  child: Wrap(
                    children: [
                      Container(
                        width: Get.width,
                        // height: screenHeight / 20,
                        color: DynamicColors.gryClr,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 12),
                          child: Text(
                            AppText.escortInformation,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controller.profileImg == null) {
                            controller.pickImage();
                          }
                        },
                        child: Container(
                          height: isMobile ? 200 : 400,
                          width: fieldWidth / 1.5,
                          margin: EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            image: controller.profileImg == null
                                ? null
                                : DecorationImage(
                                    image: MemoryImage(controller.profileImg!
                                        .bytes), // ✅ correct provider
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          child: controller.profileImg != null
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.profileImg = null;
                                      controller.update();
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: DynamicColors.redClr,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    AppText.upload_image,
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
                        width: fieldWidth * 1.5,
                        child: Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.vehicleTypeController,
                              width: fieldWidth / 1.5,
                              hintText: AppText.name,
                              columnText: true,
                              height: 35,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.passengersController,
                              width: fieldWidth / 1.5,
                              hintText: AppText.mobile,
                              columnText: true,
                              height: 35,
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller: controller.luggagesController,
                              width: fieldWidth / 1.5,
                              hintText: AppText.email,
                              columnText: true,
                              height: 35,
                            ),
                            labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.dob,
                              width: fieldWidth / 1.8,
                              child: SizedBox(
                                  height: 30, child: KeyboardDatePicker()),
                            ),
                            CustomTextField(
                              borderRadius: 4,
                              controller:
                                  controller.driverWaitingChargesController,
                              width: fieldWidth / 1.5,
                              hintText: AppText.address,
                              columnText: true,
                              height: 35,
                            ),
                            labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.safeguardingExpiry,
                              width: fieldWidth / 1.8,
                              child: SizedBox(
                                  height: 30, child: KeyboardDatePicker()),
                            ),
                            labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.patExpiry,
                              width: fieldWidth / 1.8,
                              child: SizedBox(
                                  height: 30, child: KeyboardDatePicker()),
                            ),
                            labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.firstAidExpiry,
                              width: fieldWidth / 1.8,
                              child: SizedBox(
                                  height: 30, child: KeyboardDatePicker()),
                            ),
                            labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.dbsExpiry,
                              width: fieldWidth / 1.8,
                              child: SizedBox(
                                  height: 30, child: KeyboardDatePicker()),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: Get.width,
                        // height: screenHeight / 20,
                        color: DynamicColors.gryClr,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 12),
                          child: Text(
                            AppText.escortAttachment,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Center(
                        child: Wrap(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppText.safeguarding,
                                  style: mozillaTextRegularText(fontSize: 11),
                                ),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: isMobile ? 100 : 200,
                                      width: fieldWidth / 1.5,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        image:
                                            controller.phcVehicleDocPic == null
                                                ? null
                                                : DecorationImage(
                                                    image: MemoryImage(controller
                                                        .phcVehicleDocPic!), // ✅ correct provider
                                                    fit: BoxFit.fill,
                                                  ),
                                      ),
                                      child: controller.phcVehicleDocPic != null
                                          ? SizedBox.shrink()
                                          : Center(
                                              child: Text(
                                                AppText.safeguarding,
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
                                        if (controller.phcVehicleDocPic ==
                                            null) {
                                          final image = await ImagePickerHelper
                                              .pickImage();
                                          if (image != null) {
                                            controller.phcVehicleDocPic =
                                                image.bytes;
                                          }
                                        } else {
                                          controller.phcVehicleDocPic = null;
                                        }
                                        controller.update();
                                      },
                                      child: Icon(
                                        controller.phcVehicleDocPic != null
                                            ? Icons.remove_circle
                                            : Icons.add_circle_outlined,
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
                                Text(
                                  AppText.patPic,
                                  style: mozillaTextRegularText(fontSize: 11),
                                ),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: isMobile ? 100 : 200,
                                      width: fieldWidth / 1.5,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        image: controller.motDocPic == null
                                            ? null
                                            : DecorationImage(
                                                image: MemoryImage(controller
                                                    .motDocPic!), // ✅ correct provider
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                      child: controller.motDocPic != null
                                          ? SizedBox.shrink()
                                          : Center(
                                              child: Text(
                                                AppText.patPic,
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
                                        if (controller.motDocPic == null) {
                                          final image = await ImagePickerHelper
                                              .pickImage();
                                          if (image != null) {
                                            controller.motDocPic = image.bytes;
                                          }
                                        } else {
                                          controller.motDocPic = null;
                                        }
                                        controller.update();
                                      },
                                      child: Icon(
                                        controller.motDocPic != null
                                            ? Icons.remove_circle
                                            : Icons.add_circle_outlined,
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
                                Text(
                                  AppText.firstAid,
                                  style: mozillaTextRegularText(fontSize: 11),
                                ),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: isMobile ? 100 : 200,
                                      width: fieldWidth / 1.5,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        image: controller.mot2DocPic == null
                                            ? null
                                            : DecorationImage(
                                                image: MemoryImage(controller
                                                    .mot2DocPic!), // ✅ correct provider
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                      child: controller.mot2DocPic != null
                                          ? SizedBox.shrink()
                                          : Center(
                                              child: Text(
                                                AppText.firstAid,
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
                                        if (controller.mot2DocPic == null) {
                                          final image = await ImagePickerHelper
                                              .pickImage();
                                          if (image != null) {
                                            controller.mot2DocPic = image.bytes;
                                          }
                                        } else {
                                          controller.mot2DocPic = null;
                                        }
                                        controller.update();
                                      },
                                      child: Icon(
                                        controller.mot2DocPic != null
                                            ? Icons.remove_circle
                                            : Icons.add_circle_outlined,
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
                                Text(
                                  AppText.dbs,
                                  style: mozillaTextRegularText(fontSize: 11),
                                ),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: isMobile ? 100 : 200,
                                      width: fieldWidth / 1.5,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        image:
                                            controller.insuranceDocPic == null
                                                ? null
                                                : DecorationImage(
                                                    image: MemoryImage(controller
                                                        .insuranceDocPic!), // ✅ correct provider
                                                    fit: BoxFit.fill,
                                                  ),
                                      ),
                                      child: controller.insuranceDocPic != null
                                          ? SizedBox.shrink()
                                          : Center(
                                              child: Text(
                                                AppText.dbs,
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
                                        if (controller.insuranceDocPic ==
                                            null) {
                                          final image = await ImagePickerHelper
                                              .pickImage();
                                          if (image != null) {
                                            controller.insuranceDocPic =
                                                image.bytes;
                                          }
                                        } else {
                                          controller.insuranceDocPic = null;
                                        }
                                        controller.update();
                                      },
                                      child: Icon(
                                        controller.insuranceDocPic != null
                                            ? Icons.remove_circle
                                            : Icons.add_circle_outlined,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomButton(
              width: Get.width / 2,
              btnText: AppText.save,
              verticalPadding: 0.0,
              height: 40,
              borderRadius: 4,
            )
          ],
        );
      });
    });
  }
}
