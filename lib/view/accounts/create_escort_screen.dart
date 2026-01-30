

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/image_pick_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import 'controller/account_controller.dart';

class CreateEscortScreen extends StatefulWidget {
  const CreateEscortScreen({super.key});

  @override
  State<CreateEscortScreen> createState() => _CreateEscortScreenState();
}

class _CreateEscortScreenState extends State<CreateEscortScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

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

    return GetBuilder<AccountController>(builder: (controller) {
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

        return Wrap(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  runSpacing: 16,
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.profileImg == null) {
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
                          image: controller.profileImg == null
                              ? null
                              : DecorationImage(
                                  image: MemoryImage(controller
                                      .profileImg!.bytes), // ✅ correct provider
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
                      width: fieldWidth * 2.9,
                      child: Column(
                        children: [
                          Container(
                            // height: screenHeight / 20,
                            width: Get.width,
                            color: DynamicColors.gryClr,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 12),
                              child: Row(
                                children: [
                                  Text(
                                    AppText.escortInformation,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.escortName,
                                width: fieldWidth / 1.5,
                                hintText: AppText.name,
                                columnText: true,
                                height: 35,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.escortEmail,
                                width: fieldWidth / 1.5,
                                hintText: AppText.email,
                                columnText: true,
                                height: 35,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.escortMobile,
                                width: fieldWidth / 1.5,
                                hintText: AppText.mobile,
                                columnText: true,
                                height: 35,
                              ),
                              labeledField(
                                column: true,
                                context: context,
                                isMobile: isMobile,
                                label: AppText.dob,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35, child: KeyboardDatePicker()),
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller:
                                    controller.escortAddress,
                                width: fieldWidth / 1.5,
                                hintText: AppText.address,
                                columnText: true,
                                height: 35,
                              ),
                              labeledField(
                                column: true,
                                context: context,
                                isMobile: isMobile,
                                label: AppText.safeguardingExpiry,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35, child: KeyboardDatePicker()),
                              ),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                column: true,
                                label: AppText.patExpiry,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35, child: KeyboardDatePicker()),
                              ),
                              labeledField(
                                column: true,
                                context: context,
                                isMobile: isMobile,
                                label: AppText.firstAid,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35, child: KeyboardDatePicker()),
                              ),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                column: true,
                                label: AppText.dbsExpiry,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35, child: CustomTimePicker()),
                              ),

                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.safeguardingBatch,
                                width: fieldWidth / 1.5,
                                hintText: AppText.safeguardingBatch,
                                columnText: true,
                                height: 35,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.PATBatch,
                                width: fieldWidth / 1.5,
                                hintText: AppText.patPicBatch,
                                columnText: true,
                                height: 35,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.firstAidBatch,
                                width: fieldWidth / 1.5,
                                hintText: AppText.firstAidBatch,
                                columnText: true,
                                height: 35,
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.DBSBatch,
                                width: fieldWidth / 1.5,
                                hintText: AppText.dbsBatch,
                                columnText: true,
                                height: 35,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: Get.width,
              color: DynamicColors.gryClr,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Text(
                  AppText.escortAttachment,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        AppText.safeguardingDocument,
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
                              image:  controller.safeguardingDocPic == null ? null : DecorationImage(
                                image: MemoryImage(controller.safeguardingDocPic!), // ✅ correct provider
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: controller.safeguardingDocPic != null
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
                              if (controller.safeguardingDocPic == null) {
                                final image =
                                    await ImagePickerHelper.pickImage();
                                if (image != null) {
                                  controller.safeguardingDocPic = image.bytes ;
                                }
                              } else {
                                controller.safeguardingDocPic = null;
                              }
                              controller.update();
                            },
                            child: Icon(
                              controller.safeguardingDocPic != null
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
                        AppText.patDocument,
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
                              image: controller.patDocPic == null
                                  ? null
                                  : DecorationImage(
                                      image: MemoryImage(controller
                                          .patDocPic! ), // ✅ correct provider
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            child: controller.patDocPic != null
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
                              if (controller.patDocPic == null) {
                                final image =
                                    await ImagePickerHelper.pickImage();
                                if (image != null) {
                                  controller.patDocPic = image.bytes ;
                                }
                              } else {
                                controller.patDocPic = null;
                              }
                              controller.update();
                            },
                            child: Icon(
                              controller.patDocPic != null
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
                        AppText.firstAidDocument,
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
                              image: controller.firstAidDocPic == null
                                  ? null
                                  : DecorationImage(
                                      image: MemoryImage(controller
                                          .firstAidDocPic! ), // ✅ correct provider
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            child: controller.firstAidDocPic != null
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
                              if (controller.firstAidDocPic == null) {
                                final image =
                                    await ImagePickerHelper.pickImage();
                                if (image != null) {
                                  controller.firstAidDocPic = image.bytes;
                                }
                              } else {
                                controller.firstAidDocPic = null;
                              }
                              controller.update();
                            },
                            child: Icon(
                              controller.firstAidDocPic != null
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
                        AppText.dbsDocument,
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
                              image: controller.dbsDocPic == null
                                  ? null
                                  : DecorationImage(
                                      image: MemoryImage(controller.dbsDocPic!), // ✅ correct provider
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            child: controller.dbsDocPic != null
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
                              if (controller.dbsDocPic == null) {
                                final image =
                                    await ImagePickerHelper.pickImage();
                                if (image != null) {
                                  controller.dbsDocPic = image.bytes ;
                                }
                              } else {
                                controller.dbsDocPic = null;
                              }
                              controller.update();
                            },
                            child: Icon(
                              controller.dbsDocPic != null
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
            Center(
              child: CustomButton(
                width: Get.width / 2,
                btnText: AppText.save,
                verticalPadding: 0.0,
                height: 40,
                borderRadius: 4,
              ),
            )
          ],
        );

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //       ],
        // );
      });
    });
  }
}
