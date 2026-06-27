import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../component/image_pick_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/models/dashboard_model.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'controller/controller.dart';

class CreateCompanyVehicle extends StatefulWidget {
  const CreateCompanyVehicle({super.key});

  @override
  State<CreateCompanyVehicle> createState() => _CreateCompanyVehicleState();
}

class _CreateCompanyVehicleState extends State<CreateCompanyVehicle> {
  DashboardController controllerdesh = Get.find();
  final VehicleController _controller = Get.isRegistered<VehicleController>()
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
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<VehicleController>(initState: (v) {
      // _controller.getAllVehicleType();
    }, builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth - 24
            : isTablet
                ? (maxWidth - 40) / 2
                : (maxWidth - 60) / 4;

        return
            /*controller.getAllVehicleTypeLoader.value == true ? Center(
              child: CircularProgressIndicator(),

            ):*/
            SingleChildScrollView(
                child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              // height: screenHeight / 20,
              width: Get.width,
              color: DynamicColors.gryClr,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Text(
                  AppText.companyVehicle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Center(
                  child: Wrap(
                    runSpacing: 16,
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.vehicleNumberController,
                        width: fieldWidth,
                        hintText: "VEHICLE NUMBER",
                        columnText: true,
                        height: 30,
                        inputFormatters: [UpperCaseTextFormatter()],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppText.vehicleType,
                                style: mozillaTextSemiBoldText(
                                    context: context, fontSize: 13)),
                            const SizedBox(height: 2),
                            Container(
                              height: 35,
                              width: fieldWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: DynamicColors.primaryClr,
                                    width: 1.2),
                              ),
                              child: DropdownButtonFormField<
                                  DashboardVehicleTypeObject>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                value: controller.selectVehicleValue,
                                items: (controllerdesh
                                            .dashboardAllData?.vehicleTypes ??
                                        [])
                                    .map((vehicle) => DropdownMenuItem<
                                            DashboardVehicleTypeObject>(
                                          value: vehicle,
                                          child: Text(
                                            (vehicle.name ?? "").toUpperCase(),
                                            style: mozillaTextRegularText(
                                              fontSize: 12,
                                              color: DynamicColors.textClr,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  controller.selectVehicleValue = v;
                                  controller.update();
                                },
                              ),
                            ),

                            // RestrictedDrivers(
                            //   width: fieldWidth/1.5,
                            //   // height: 35,
                            //   padding: 0.0,
                            //   border: Border.all(
                            //     color: DynamicColors.gryClr,
                            //   ),
                            //   titleText: "ESTAT",
                            //   driversList: [
                            //     "25 GEORGE HAMPTON",
                            //     "26 PAUL DOUBLEDAY",
                            //     "27 RICHARD HARDWICK",
                            //     "28 LANRE OKERJO",
                            //   ],
                            // ),
                          ]),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.colorController,
                        width: fieldWidth,
                        hintText: AppText.color,
                        columnText: true,
                        height: 30,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                          UpperCaseTextFormatter()
                        ],
                      ),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.vehicleMakeController,
                        width: fieldWidth,
                        hintText: AppText.make,
                        columnText: true,
                        height: 30,
                        inputFormatters: [UpperCaseTextFormatter()],
                      ),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.vehicleModelController,
                        width: fieldWidth,
                        hintText: AppText.model,
                        columnText: true,
                        height: 30,
                        inputFormatters: [UpperCaseTextFormatter()],
                      ),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.logBookingDocController,
                        width: fieldWidth,
                        hintText: AppText.logBookingDoc,
                        columnText: true,
                        height: 30,
                        inputFormatters: [UpperCaseTextFormatter()],
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.phcVehicleExpire,
                        column: true,
                        width: fieldWidth,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(
                            initialDate: DateTime.now(),
                            onChanged: (date) {
                              // jab bhi user change kare
                              setState(() {
                                controller.phcVehicleExpireDate =
                                    "${date.year}-${date.month}-${date.day}";
                                print(date);
                              });
                            },
                            onSubmitted: (date) {
                              // jab user enter press kare
                              setState(() {
                                controller.phcVehicleExpireDate =
                                    "${date.year}-${date.month}-${date.day}";
                              });
                              print("User pressed enter: $date");
                            },
                          ),
                        ),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        column: true,
                        label: AppText.phcVehicleExpire,
                        width: fieldWidth,
                        child: SizedBox(
                            height: 30,
                            child: CustomTimePicker(
                              controller: controller
                                  .phcVehicleExpireTimeController, // optional
                              onTimeSelected: (time) {
                                setState(() {
                                  print(controller
                                      .phcVehicleExpireTimeController.text);
                                  print(time);
                                });
                              },
                            )),
                      ),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.phcVehicleNumberController,
                        width: fieldWidth,
                        hintText: AppText.phcVehicleNumber,
                        columnText: true,
                        height: 30,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.motExpiry,
                        column: true,
                        width: fieldWidth,
                        child: SizedBox(
                            height: 30,
                            child: KeyboardDatePicker(
                              initialDate: DateTime.now(),
                              onChanged: (date) {
                                // jab bhi user change kare
                                setState(() {
                                  controller.motExpiryExpireDate =
                                      "${date.year}-${date.month}-${date.day}";
                                  print(date);
                                });
                              },
                              onSubmitted: (date) {
                                // jab user enter press kare
                                setState(() {
                                  controller.motExpiryExpireDate =
                                      "${date.year}-${date.month}-${date.day}";
                                });
                                print("User pressed enter: $date");
                              },
                            )),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        column: true,
                        label: AppText.motExpiry,
                        width: fieldWidth,
                        child: SizedBox(
                            height: 30,
                            child: CustomTimePicker(
                              controller: controller
                                  .motExpiryExpireTimeController, // optional
                              onTimeSelected: (time) {
                                setState(() {
                                  print(controller
                                      .motExpiryExpireTimeController.text);
                                  print(time);
                                });
                              },
                            )),
                      ),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.motNumberController,
                        width: fieldWidth,
                        hintText: AppText.motNumber,
                        columnText: true,
                        height: 30,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.mot2Expiry,
                        column: true,
                        width: fieldWidth,
                        child: SizedBox(
                            height: 30,
                            child: KeyboardDatePicker(
                              initialDate: DateTime.now(),
                              onChanged: (date) {
                                // jab bhi user change kare
                                setState(() {
                                  controller.mot2ExpiryExpireDate =
                                      "${date.year}-${date.month}-${date.day}";
                                  print(date);
                                });
                              },
                              onSubmitted: (date) {
                                // jab user enter press kare
                                setState(() {
                                  controller.mot2ExpiryExpireDate =
                                      "${date.year}-${date.month}-${date.day}";
                                });
                                print("User pressed enter: $date");
                              },
                            )),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        column: true,
                        label: AppText.mot2Expiry,
                        width: fieldWidth,
                        child: SizedBox(
                            height: 30,
                            child: CustomTimePicker(
                              controller: controller
                                  .mot2ExpiryExpireTimeController, // optional
                              onTimeSelected: (time) {
                                setState(() {
                                  print(controller
                                      .mot2ExpiryExpireTimeController.text);
                                });
                              },
                            )),
                      ),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.mot2NumberController,
                        width: fieldWidth,
                        hintText: AppText.mot2Number,
                        columnText: true,
                        height: 30,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.insuranceExpiry,
                        column: true,
                        width: fieldWidth,
                        child: SizedBox(
                            height: 30,
                            child: KeyboardDatePicker(
                              initialDate: DateTime.now(),
                              onChanged: (date) {
                                // jab bhi user change kare
                                setState(() {
                                  controller.insuranceExpiryDate =
                                      "${date.year}-${date.month}-${date.day}";
                                });
                              },
                              onSubmitted: (date) {
                                // jab user enter press kare
                                setState(() {
                                  controller.insuranceExpiryDate =
                                      "${date.year}-${date.month}-${date.day}";
                                });
                              },
                            )),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        column: true,
                        label: AppText.insuranceExpiry,
                        width: fieldWidth,
                        child: SizedBox(
                            height: 30,
                            child: CustomTimePicker(
                              controller: controller
                                  .insuranceExpiryTimeController, // optional
                              onTimeSelected: (time) {
                                setState(() {
                                  print(controller
                                      .insuranceExpiryTimeController.text);
                                });
                              },
                            )),
                      ),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.insuranceNumberController,
                        width: fieldWidth,
                        hintText: AppText.insuranceNumber,
                        columnText: true,
                        height: 30,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 8,
            ),
            Container(
              // height: screenHeight / 20,
              width: Get.width,
              color: DynamicColors.gryClr,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Text(
                  AppText.companyVehiclePicture,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        AppText.phcVehicleDoc,
                        style: mozillaTextRegularText(fontSize: 11),
                      ),
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
                            image: controller.phcVehicleDocPic != null
                                ? DecorationImage(
                                    image: MemoryImage(controller
                                        .phcVehicleDocPic!), // Nayi picked image
                                    fit: BoxFit.fill,
                                  )
                                : (controller.singleVehicleData
                                            ?.phcVehicleDocument !=
                                        null
                                    ? DecorationImage(
                                        // Edit mode ki purani image
                                        // Note: Agar API sirf path bhej rahi hai to Base URL add karein
                                        image: NetworkImage(controller
                                            .singleVehicleData!
                                            .phcVehicleDocument!),
                                        fit: BoxFit.fill,
                                      )
                                    : null),
                          ),
                          // Text tab hide hoga jab local image ho YA network image ho
                          child: (controller.phcVehicleDocPic != null ||
                                  controller.singleVehicleData
                                          ?.phcVehicleDocument !=
                                      null)
                              ? SizedBox.shrink()
                              : Center(
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
                            // Agar pehle se koi image hai (Local ya Network), to usay remove karo
                            if (controller.phcVehicleDocPic != null ||
                                controller.singleVehicleData
                                        ?.phcVehicleDocument !=
                                    null) {
                              controller.phcVehicleDocPic = null;
                              if (controller.singleVehicleData != null) {
                                controller
                                        .singleVehicleData!.phcVehicleDocument =
                                    null; // Model se clear karein
                              }
                            } else {
                              // Nayi image pick karo
                              final image = await ImagePickerHelper.pickImage();
                              if (image != null) {
                                controller.phcVehicleDocPic = image.bytes;
                              }
                            }
                            controller.update();
                          },
                          child: Icon(
                            (controller.phcVehicleDocPic != null ||
                                    controller.singleVehicleData
                                            ?.phcVehicleDocument !=
                                        null)
                                ? Icons.remove_circle
                                : Icons.add_circle_outlined,
                            size: 30,
                            color: (controller.phcVehicleDocPic != null ||
                                    controller.singleVehicleData
                                            ?.phcVehicleDocument !=
                                        null)
                                ? DynamicColors
                                    .redClr // Remove ke liye Red color
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
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        AppText.motDoc,
                        style: mozillaTextRegularText(fontSize: 11),
                      ),
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
                            image: controller.motDocPic != null
                                ? DecorationImage(
                                    image: MemoryImage(controller
                                        .motDocPic!), // Nayi picked image (Bytes)
                                    fit: BoxFit.fill,
                                  )
                                : (controller.singleVehicleData?.motDocument !=
                                        null
                                    ? DecorationImage(
                                        // Edit mode ki purani image (Network URL)
                                        image: NetworkImage(controller
                                            .singleVehicleData!.motDocument!),
                                        fit: BoxFit.fill,
                                      )
                                    : null),
                          ),
                          // Child logic: Agar koi bhi image (Local ya Network) mil gayi to text hide kar do
                          child: (controller.motDocPic != null ||
                                  controller.singleVehicleData?.motDocument !=
                                      null)
                              ? SizedBox.shrink()
                              : Center(
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
                            // Agar pehle se koi image hai (Local ya Network), to usay remove karo
                            if (controller.motDocPic != null ||
                                controller.singleVehicleData?.motDocument !=
                                    null) {
                              controller.motDocPic = null;
                              if (controller.singleVehicleData != null) {
                                controller.singleVehicleData!.motDocument =
                                    null; // Model se path clear karein
                              }
                            } else {
                              // Warna nayi image pick karo
                              final image = await ImagePickerHelper.pickImage();
                              if (image != null) {
                                controller.motDocPic = image.bytes;
                              }
                            }
                            controller.update();
                          },
                          child: Icon(
                            (controller.motDocPic != null ||
                                    controller.singleVehicleData?.motDocument !=
                                        null)
                                ? Icons.remove_circle
                                : Icons.add_circle_outlined,
                            size: 30,
                            color: (controller.motDocPic != null ||
                                    controller.singleVehicleData?.motDocument !=
                                        null)
                                ? DynamicColors
                                    .redClr // Image hai to remove icon red dikhao
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
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        AppText.mot2Doc,
                        style: mozillaTextRegularText(fontSize: 11),
                      ),
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
                            image: controller.mot2DocPic != null
                                ? DecorationImage(
                                    image: MemoryImage(controller
                                        .mot2DocPic!), // Nayi picked image (Bytes)
                                    fit: BoxFit.fill,
                                  )
                                : (controller.singleVehicleData?.mot2Document !=
                                        null
                                    ? DecorationImage(
                                        // Edit mode ki purani image (Network URL)
                                        image: NetworkImage(controller
                                            .singleVehicleData!.mot2Document!),
                                        fit: BoxFit.fill,
                                      )
                                    : null),
                          ),
                          // Child logic: Agar koi bhi image (Local ya Network) mil gayi to text hide kar do
                          child: (controller.mot2DocPic != null ||
                                  controller.singleVehicleData?.mot2Document !=
                                      null)
                              ? SizedBox.shrink()
                              : Center(
                                  child: Text(
                                    AppText.mot2Doc, // ✅ MOT2 text
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
                            // Agar pehle se koi image hai (Local ya Network), to usay remove karo
                            if (controller.mot2DocPic != null ||
                                controller.singleVehicleData?.mot2Document !=
                                    null) {
                              controller.mot2DocPic = null;
                              if (controller.singleVehicleData != null) {
                                controller.singleVehicleData!.mot2Document =
                                    null; // ✅ MOT2 model clear
                              }
                            } else {
                              // Warna nayi image pick karo
                              final image = await ImagePickerHelper.pickImage();
                              if (image != null) {
                                controller.mot2DocPic = image.bytes;
                              }
                            }
                            controller.update();
                          },
                          child: Icon(
                            (controller.mot2DocPic != null ||
                                    controller
                                            .singleVehicleData?.mot2Document !=
                                        null)
                                ? Icons.remove_circle
                                : Icons.add_circle_outlined,
                            size: 30,
                            color: (controller.mot2DocPic != null ||
                                    controller
                                            .singleVehicleData?.mot2Document !=
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
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        AppText.insuranceDoc,
                        style: mozillaTextRegularText(fontSize: 11),
                      ),
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
                            image: controller.insuranceDocPic != null
                                ? DecorationImage(
                                    image: MemoryImage(controller
                                        .insuranceDocPic!), // Nayi picked image (Bytes)
                                    fit: BoxFit.fill,
                                  )
                                : (controller.singleVehicleData
                                            ?.insuranceDocument !=
                                        null
                                    ? DecorationImage(
                                        // Edit mode ki purani image (Network URL)
                                        image: NetworkImage(controller
                                            .singleVehicleData!
                                            .insuranceDocument!),
                                        fit: BoxFit.fill,
                                      )
                                    : null),
                          ),
                          // Child logic: Agar koi bhi image (Local ya Network) mil gayi to text hide kar do
                          child: (controller.insuranceDocPic != null ||
                                  controller.singleVehicleData
                                          ?.insuranceDocument !=
                                      null)
                              ? SizedBox.shrink()
                              : Center(
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
                            // Agar pehle se koi image hai (Local ya Network), to usay remove karo
                            if (controller.insuranceDocPic != null ||
                                controller
                                        .singleVehicleData?.insuranceDocument !=
                                    null) {
                              controller.insuranceDocPic = null;
                              if (controller.singleVehicleData != null) {
                                controller
                                        .singleVehicleData!.insuranceDocument =
                                    null; // Model se path clear karein
                              }
                            } else {
                              // Warna nayi image pick karo
                              final image = await ImagePickerHelper.pickImage();
                              if (image != null) {
                                controller.insuranceDocPic = image.bytes;
                              }
                            }
                            controller.update();
                          },
                          child: Icon(
                            (controller.insuranceDocPic != null ||
                                    controller.singleVehicleData
                                            ?.insuranceDocument !=
                                        null)
                                ? Icons.remove_circle
                                : Icons.add_circle_outlined,
                            size: 30,
                            color: (controller.insuranceDocPic != null ||
                                    controller.singleVehicleData
                                            ?.insuranceDocument !=
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
            SizedBox(
              height: 10,
            ),
            CustomButton(
              height: 35,
              verticalPadding: 0.0,
              borderRadius: 4,
              fontSize: 12,
              btnText: controller.singleVehicleData != null
                  ? "UPDATE"
                  : AppText.save,
              onTap: () {
                controller.postCompanyVehicle();
              },
            )
          ],
        ));
      });
    });
  }
}
