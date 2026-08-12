import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../component/image_pick_widget.dart';
import '../../component/networks/api.dart';
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
    if (controller.selectedEscort == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.clearEscortFields();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<AccountController>(
        builder: (controller) {
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
                        // Sirf tab pick kare jab dono images null hon
                        if (controller.profileImg == null &&
                            controller.selectedEscort?.image == null) {
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
                          image: controller.profileImg != null
                              ? DecorationImage(
                                  image:
                                      MemoryImage(controller.profileImg!.bytes),
                                  fit: BoxFit.fill,
                                )
                              : (controller.selectedEscort?.image != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          controller.selectedEscort!.image!),
                                      fit: BoxFit.fill,
                                    )
                                  : null),
                        ),
                        // Check karein ke kya koi bhi image (Local ya Network) maujood hai?
                        child: (controller.profileImg != null ||
                                controller.selectedEscort?.image != null)
                            ? Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    // Image remove karne ki logic
                                    controller.profileImg = null;
                                    if (controller.selectedEscort != null) {
                                      controller.selectedEscort!.image =
                                          null; // Purani image hide karne ke liye
                                    }
                                    controller.update();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    color: Colors.white.withOpacity(
                                        0.7), // Icon nazar aaye isliye background
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: DynamicColors.redClr,
                                    ),
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]')),
                                  UpperCaseTextFormatter(),
                                ],
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.escortEmail,
                                width: fieldWidth / 1.5,
                                hintText: AppText.email,
                                columnText: true,
                                height: 35,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s')),
                                  UpperCaseTextFormatter(),
                                ],
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.escortMobile,
                                width: fieldWidth / 1.5,
                                hintText: AppText.mobile,
                                columnText: true,
                                height: 35,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                              labeledField(
                                column: true,
                                context: context,
                                isMobile: isMobile,
                                label: AppText.dob,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35,
                                    child: KeyboardDatePicker(
                                      key: ValueKey("dob_date_${controller.datePickerKey}"),
                                      initialDate: DateTime.tryParse(controller.dobDate ?? '') ?? DateTime.now(),
                                      onChanged: (date) => controller.dobDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                      onSubmitted: (date) => controller.dobDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                    )),
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.escortAddress,
                                width: fieldWidth / 1.5,
                                hintText: AppText.address,
                                columnText: true,
                                height: 35,
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                ],
                              ),
                              labeledField(
                                column: true,
                                context: context,
                                isMobile: isMobile,
                                label: AppText.safeguardingExpiry,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35,
                                    child: KeyboardDatePicker(
                                      key: ValueKey("safeguarding_date_${controller.datePickerKey}"),
                                      initialDate: DateTime.tryParse(controller.safeguardingExpiryExpireDate ?? '') ?? DateTime.now(),
                                      onChanged: (date) => controller.safeguardingExpiryExpireDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                      onSubmitted: (date) => controller.safeguardingExpiryExpireDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                    )),
                              ),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                column: true,
                                label: AppText.patExpiry,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35,
                                    child: KeyboardDatePicker(
                                      key: ValueKey("pat_expiry_date_${controller.datePickerKey}"),
                                      initialDate: DateTime.tryParse(controller.patExpiryDate ?? '') ?? DateTime.now(),
                                      onChanged: (date) => controller.patExpiryDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                      onSubmitted: (date) => controller.patExpiryDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                    )),
                              ),
                              labeledField(
                                column: true,
                                context: context,
                                isMobile: isMobile,
                                label: AppText.firstAid,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35,
                                    child: KeyboardDatePicker(
                                      key: ValueKey("firstaid_expiry_date_${controller.datePickerKey}"),
                                      initialDate: DateTime.tryParse(controller.firstAidDate ?? '') ?? DateTime.now(),
                                      onChanged: (date) => controller.firstAidDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                      onSubmitted: (date) => controller.firstAidDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                    )),
                              ),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                column: true,
                                label: AppText.dbsExpiry,
                                width: fieldWidth / 1.5,
                                child: SizedBox(
                                    height: 35,
                                    child: CustomTimePicker(
                                      controller:
                                          controller.dbsExpireTime, // optional
                                      onTimeSelected: (time) {
                                        setState(() {
                                          print(controller.dbsExpireTime.text);
                                          print(time);
                                        });
                                      },
                                    )),
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.safeguardingBatch,
                                width: fieldWidth / 1.5,
                                hintText: AppText.safeguardingBatch,
                                columnText: true,
                                height: 35,
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                ],
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.PATBatch,
                                width: fieldWidth / 1.5,
                                hintText: AppText.patPicBatch,
                                columnText: true,
                                height: 35,
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                ],
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.firstAidBatch,
                                width: fieldWidth / 1.5,
                                hintText: AppText.firstAidBatch,
                                columnText: true,
                                height: 35,
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                ],
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.DBSBatch,
                                width: fieldWidth / 1.5,
                                hintText: AppText.dbsBatch,
                                columnText: true,
                                height: 35,
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                ],
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
                              image: controller.safeguardingDocPic != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                          controller.safeguardingDocPic!),
                                      fit: BoxFit.fill,
                                    )
                                  : (controller.selectedEscort
                                              ?.safeguardingDocument !=
                                          null
                                      ? DecorationImage(
                                          image: NetworkImage(controller
                                              .selectedEscort!
                                              .safeguardingDocument!),
                                          fit: BoxFit.fill,
                                        )
                                      : null),
                            ),
                            // Agar bytes hain YA server ka image path hai, to text hide kar do
                            child: (controller.safeguardingDocPic != null ||
                                    controller.selectedEscort
                                            ?.safeguardingDocument !=
                                        null)
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
                              // Agar koi bhi image (Local ya Network) maujood hai, to usay remove karo
                              if (controller.safeguardingDocPic != null ||
                                  controller.selectedEscort
                                          ?.safeguardingDocument !=
                                      null) {
                                controller.safeguardingDocPic = null;
                                if (controller.selectedEscort != null) {
                                  controller.selectedEscort!
                                      .safeguardingDocument = null;
                                }
                              } else {
                                // Warna nayi image pick karo
                                final image =
                                    await ImagePickerHelper.pickImage();
                                if (image != null) {
                                  controller.safeguardingDocPic = image.bytes;
                                }
                              }
                              controller.update();
                            },
                            child: Icon(
                              // Icon change logic based on both conditions
                              (controller.safeguardingDocPic != null ||
                                      controller.selectedEscort
                                              ?.safeguardingDocument !=
                                          null)
                                  ? Icons.remove_circle
                                  : Icons.add_circle_outlined,
                              size: 30,
                              color: (controller.safeguardingDocPic != null ||
                                      controller.selectedEscort
                                              ?.safeguardingDocument !=
                                          null)
                                  ? DynamicColors
                                      .redClr // Remove ke liye red color behtar hai
                                  : DynamicColors.primaryClr,
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
                              image: controller.patDocPic != null
                                  ? DecorationImage(
                                      image: MemoryImage(controller.patDocPic!),
                                      fit: BoxFit.fill,
                                    )
                                  : (controller.selectedEscort?.patDocument !=
                                          null
                                      ? DecorationImage(
                                          image: NetworkImage(controller
                                              .selectedEscort!.patDocument!),
                                          fit: BoxFit.fill,
                                        )
                                      : null),
                            ),
                            // Agar image (Local ya Network) mil gayi to text hide kar do
                            child: (controller.patDocPic != null ||
                                    controller.selectedEscort?.patDocument !=
                                        null)
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
                              // Agar pehle se koi image hai to usay remove karo
                              if (controller.patDocPic != null ||
                                  controller.selectedEscort?.patDocument !=
                                      null) {
                                controller.patDocPic = null;
                                if (controller.selectedEscort != null) {
                                  controller.selectedEscort!.patDocument =
                                      null; // Model se path clear karein
                                }
                              } else {
                                // Warna nayi image pick karo
                                final image =
                                    await ImagePickerHelper.pickImage();
                                if (image != null) {
                                  controller.patDocPic = image.bytes;
                                }
                              }
                              controller.update();
                            },
                            child: Icon(
                              (controller.patDocPic != null ||
                                      controller.selectedEscort?.patDocument !=
                                          null)
                                  ? Icons.remove_circle
                                  : Icons.add_circle_outlined,
                              size: 30,
                              color: (controller.patDocPic != null ||
                                      controller.selectedEscort?.patDocument !=
                                          null)
                                  ? DynamicColors.redClr
                                  : DynamicColors.primaryClr,
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
                              image: controller.firstAidDocPic != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                          controller.firstAidDocPic!),
                                      fit: BoxFit.fill,
                                    )
                                  : (controller.selectedEscort
                                              ?.firstaidDocument !=
                                          null
                                      ? DecorationImage(
                                          image: NetworkImage(controller
                                              .selectedEscort!
                                              .firstaidDocument!),
                                          fit: BoxFit.fill,
                                        )
                                      : null),
                            ),
                            // Check for both Local and Network image to hide text
                            child: (controller.firstAidDocPic != null ||
                                    controller
                                            .selectedEscort?.firstaidDocument !=
                                        null)
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
                              // Agar koi bhi image exist karti hai to pehle clear karo
                              if (controller.firstAidDocPic != null ||
                                  controller.selectedEscort?.firstaidDocument !=
                                      null) {
                                controller.firstAidDocPic = null;
                                if (controller.selectedEscort != null) {
                                  controller.selectedEscort!.firstaidDocument =
                                      null; // UI se purani image hatane ke liye
                                }
                              } else {
                                // Warna nayi image pick karo
                                final image =
                                    await ImagePickerHelper.pickImage();
                                if (image != null) {
                                  controller.firstAidDocPic = image.bytes;
                                }
                              }
                              controller.update();
                            },
                            child: Icon(
                              (controller.firstAidDocPic != null ||
                                      controller.selectedEscort
                                              ?.firstaidDocument !=
                                          null)
                                  ? Icons.remove_circle
                                  : Icons.add_circle_outlined,
                              size: 30,
                              color: (controller.firstAidDocPic != null ||
                                      controller.selectedEscort
                                              ?.firstaidDocument !=
                                          null)
                                  ? DynamicColors.redClr
                                  : DynamicColors.primaryClr,
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
                              image: controller.dbsDocPic != null
                                  ? DecorationImage(
                                      image: MemoryImage(controller.dbsDocPic!),
                                      fit: BoxFit.fill,
                                    )
                                  : (controller.selectedEscort?.dbsDocument !=
                                          null
                                      ? DecorationImage(
                                          image: NetworkImage(controller
                                              .selectedEscort!.dbsDocument!),
                                          fit: BoxFit.fill,
                                        )
                                      : null),
                            ),
                            // Dono conditions check karein taake placeholder text hide ho jaye
                            child: (controller.dbsDocPic != null ||
                                    controller.selectedEscort?.dbsDocument !=
                                        null)
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
                              // Agar koi image hai (Local ya Network) to usay remove karein
                              if (controller.dbsDocPic != null ||
                                  controller.selectedEscort?.dbsDocument !=
                                      null) {
                                controller.dbsDocPic = null;
                                if (controller.selectedEscort != null) {
                                  controller.selectedEscort!.dbsDocument =
                                      null; // Purani image path clear karein
                                }
                              } else {
                                // Warna nayi image pick karein
                                final image =
                                    await ImagePickerHelper.pickImage();
                                if (image != null) {
                                  controller.dbsDocPic = image.bytes;
                                }
                              }
                              controller.update();
                            },
                            child: Icon(
                              (controller.dbsDocPic != null ||
                                      controller.selectedEscort?.dbsDocument !=
                                          null)
                                  ? Icons.remove_circle
                                  : Icons.add_circle_outlined,
                              size: 30,
                              color: (controller.dbsDocPic != null ||
                                      controller.selectedEscort?.dbsDocument !=
                                          null)
                                  ? DynamicColors.redClr
                                  : DynamicColors.primaryClr,
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
                onTap: () {
                  String email = controller.escortEmail.text.trim();

                  if (email.isEmpty) {
                    BotToast.showText(text: "Email is required");
                  } else if (!email.contains('@')) {
                    BotToast.showText(text: "Invalid Email Format");
                  } else {
                    controller.createEscort();
                  }
                },
                width: Get.width / 2,
                btnText:
                    controller.selectedEscort != null ? "UPDATE" : AppText.save,
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
