import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/color_picker_widget.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/setting/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../alert/bank_details_alert.dart';
import '../../component/networks/api.dart';
import '../administration/controller/administration_controller.dart';

class CompanyInformationScreen extends StatefulWidget {
  const CompanyInformationScreen({super.key});

  @override
  State<CompanyInformationScreen> createState() =>
      _CompanyInformationScreenState();
}

class _CompanyInformationScreenState extends State<CompanyInformationScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  final AdministrationController adminController = Get.isRegistered<AdministrationController>()
      ? Get.find<AdministrationController>()
      : Get.put(AdministrationController());


  List permissions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "vehicleTypes";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<SettingController>(initState: (v) {
      permissions = Api().sp.read('all_permissions') ?? [];
      print(permissions);
      // final AdministrationController adminController = Get.isRegistered<AdministrationController>()
      //     ? Get.find<AdministrationController>()
      //     : Get.put(AdministrationController());

      if (adminController.subsiDiaryAll.isEmpty) {
        adminController.listSubsDiary();
      }
    }, builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        final bool isDesktop = maxWidth >= 1024;

        final double fieldWidth = isMobile
            ? maxWidth
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        final double formulaWidth =
            isDesktop ? (maxWidth * 0.74 - 60) / 4 : fieldWidth - 12;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Wrap(
                runSpacing: 16,
                spacing: 10,
                children: [

                  GestureDetector(
                    onTap: () {
                      if (controller.profileImg == null && controller.networkLogoUrl == null) {
                        controller.pickImage();
                      }
                    },
                    child: Container(
                      height: isMobile ? 200 : 420,
                      width: isDesktop ? maxWidth * 0.22 : maxWidth,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        image: controller.profileImg != null
                            ? DecorationImage(
                          image: MemoryImage(controller.profileImg!.bytes),
                          fit: BoxFit.fill,
                        )
                            : (controller.networkLogoUrl != null && controller.networkLogoUrl!.isNotEmpty)
                            ? DecorationImage(
                          image: NetworkImage(controller.networkLogoUrl!),
                          fit: BoxFit.fill,
                        )
                            : null,
                      ),
                      child: (controller.profileImg != null || controller.networkLogoUrl != null)
                          ? Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            controller.profileImg = null;
                            controller.networkLogoUrl = null;
                            controller.update();
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: DynamicColors.redClr,
                          ),
                        ),
                      )
                          : const Center(
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

                  Container(
                    width: isDesktop ? maxWidth * 0.74 : maxWidth,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: DynamicColors.gryClr),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      spacing: 16,
                      children: [
                        // Header Bar
                        Container(
                          width: Get.width,
                          color: DynamicColors.gryClr,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 12),
                            child: Row(
                              children: [
                                Text(
                                  AppText.companyinformation,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                CustomButton(
                                  verticalPadding: 0.0,
                                  width: screenWidth / 15 < 110
                                      ? 110
                                      : screenWidth / 15,
                                  height: 40,
                                  borderRadius: 4,
                                  btnText: AppText.bankDetails,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.whiteClr),
                                  onTap: () {
                                    BankDetailsAlert.show();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            CustomTextField(
                                borderRadius: 4,
                                controller: controller.nameController,
                                width: formulaWidth,
                                hintText: AppText.name,
                                columnText: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s0-9]')),
                                  UpperCaseTextFormatter(),
                                ],
                                height: 35),
                            CustomTextField(
                                borderRadius: 4,
                                controller: controller.emailCompanyController,
                                width: formulaWidth,
                                hintText: AppText.email,
                                columnText: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                  UpperCaseTextFormatter(),
                                ],
                                height: 35),
                            CustomTextField(
                                borderRadius: 4,
                                controller: controller.faxController,
                                width: formulaWidth,
                                hintText: AppText.fax,
                                columnText: true,
                                inputFormatters: [UpperCaseTextFormatter()],
                                height: 35),
                            CustomTextField(
                                borderRadius: 4,
                                controller: controller.websiteController,
                                width: formulaWidth,
                                hintText: AppText.website,
                                columnText: true,
                                inputFormatters: [UpperCaseTextFormatter()],
                                height: 35),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            CustomTextField(
                                borderRadius: 4,
                                controller: controller.telephoneController,
                                width: formulaWidth,
                                hintText: AppText.tel,
                                columnText: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                height: 35),
                            CustomTextField(
                                borderRadius: 4,
                                controller:
                                    controller.emergencyContactController,
                                width: formulaWidth,
                                hintText: AppText.emergencyContactHash,
                                columnText: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                height: 35),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppText.backgroundClr,
                                    style: mozillaTextSemiBoldText(
                                        context: context, fontSize: 13)),
                                const SizedBox(height: 4),
                                ColorPickerWidget(
                                  width: formulaWidth,
                                  pickerColor: controller.pickerColor,
                                  onColorChanged: (color) => setState(
                                      () => controller.pickerColor = color),
                                  onColorSelected: (color) => setState(
                                      () => controller.pickerColor = color),
                                  borderColor: DynamicColors.gryClr,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppText.foregroundClr,
                                    style: mozillaTextSemiBoldText(
                                        context: context, fontSize: 13)),
                                const SizedBox(height: 4),
                                ColorPickerWidget(
                                  width: formulaWidth,
                                  pickerColor: controller.foregroundColor,
                                  onColorChanged: (color) => setState(
                                      () => controller.foregroundColor = color),
                                  onColorSelected: (color) => setState(
                                      () => controller.foregroundColor = color),
                                  borderColor: DynamicColors.gryClr,
                                ),
                              ],
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            CustomTextField(
                                borderRadius: 4,
                                controller: controller.companyController,
                                width: formulaWidth,
                                hintText: AppText.company,
                                columnText: true,
                                inputFormatters: [UpperCaseTextFormatter()],
                                height: 35),
                            CustomTextField(
                                borderRadius: 4,
                                controller: controller.currencyController,
                                width: formulaWidth,
                                hintText: AppText.currency,
                                columnText: true,
                                inputFormatters: [UpperCaseTextFormatter()],
                                height: 35),

                            CustomTextField(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 10.0,
                                ),
                                borderRadius: 4,
                                controller: controller.addressController,
                                width: formulaWidth,
                                hintText: AppText.address,
                                columnText: true,
                                inputFormatters: [UpperCaseTextFormatter()],
                                maxLines: 10,
                                height: 100),

                            SizedBox(
                              width: formulaWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                      borderRadius: 4,
                                      controller: controller.balanceController,
                                      width: formulaWidth,
                                      hintText: AppText.balance,
                                      columnText: true,
                                      inputFormatters: [UpperCaseTextFormatter()],
                                      height: 35),
                                  const SizedBox(
                                      height:
                                          5),
                                  CustomTextField(
                                      borderRadius: 4,
                                      controller:
                                          controller.abbreviationController,
                                      width: formulaWidth,
                                      hintText: AppText.abbreviation,
                                      columnText: true,
                                      inputFormatters: [UpperCaseTextFormatter()],
                                      height: 35),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Center(
                          child: CustomButton(
                            height: 36,
                            width: isMobile ? maxWidth : formulaWidth,
                            btnText: AppText.save,
                            fontSize: 12,
                            verticalPadding: 0.0,
                            borderRadius: 4,
                            onTap: () async {
                              final adminCtrl = Get.find<AdministrationController>();
                              adminCtrl.nameController.text = controller.nameController.text;
                              adminCtrl.emailController.text = controller.emailCompanyController.text;
                              adminCtrl.faxController.text = controller.faxController.text;
                              adminCtrl.websiteController.text = controller.websiteController.text;
                              adminCtrl.telephoneController.text = controller.telephoneController.text;
                              adminCtrl.emergencyContactController.text = controller.emergencyContactController.text;
                              adminCtrl.companyController.text = controller.companyController.text;
                              adminCtrl.currencyController.text = controller.currencyController.text;
                              adminCtrl.addressController.text = controller.addressController.text;
                              adminCtrl.balanceController.text = controller.balanceController.text;

                              adminCtrl.bankController.text = controller.bankController.text;
                              adminCtrl.accountController.text = controller.accountController.text;
                              adminCtrl.accountTitleController.text = controller.accountTitleController.text;
                              adminCtrl.sortCodeController.text = controller.sortCodeController.text;
                              adminCtrl.ibanController.text = controller.ibanController.text;
                              adminCtrl.vatController.text = controller.vatController.text;

                              adminCtrl.subsidiaryImg = controller.profileImg;
                              adminCtrl.subsiDiarypickerColor = controller.pickerColor;
                              adminCtrl.subsiDiaryforegroundColor = controller.foregroundColor;

                              adminCtrl.isSubsiDiaryUpdating.value = true;
                              if (adminCtrl.subsidiaryToUpdate == null && adminCtrl.subsiDiaryAll.isNotEmpty) {
                                adminCtrl.subsidiaryToUpdate = adminCtrl.subsiDiaryAll.first;
                              }

                              await adminCtrl.createSubsiDiary();
                              controller.update();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    });
  }
}

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     double width = WidgetsBinding
//             .instance.platformDispatcher.views.first.physicalSize.width /
//         WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
//
//     return GetBuilder<SettingController>(
//         initState: (v){
//           permissions = Api().sp.read('all_permissions') ?? [];
//           print(permissions);
//         },
//         builder: (controller) {
//       return LayoutBuilder(builder: (context, constraints) {
//         final double maxWidth = constraints.maxWidth;
//         final bool isMobile = maxWidth < 600;
//         final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
//
//         // Instead of fixed width, we calculate flexible field widths
//         final double fieldWidth = isMobile
//             ? maxWidth // full width
//             : isTablet
//                 ? maxWidth / 2
//                 : maxWidth / 4;
//
//         return Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             Wrap(
//               runSpacing: 16,
//               spacing: 10,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     if (controller.profileImg == null) {
//                       controller.pickImage();
//                     }
//                   },
//                   child: Container(
//                     height: isMobile ? 200 : 400,
//                     width: fieldWidth,
//                     margin: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey),
//                       image: controller.profileImg == null
//                           ? null
//                           : DecorationImage(
//                               image: MemoryImage(controller
//                                   .profileImg!.bytes), // ✅ correct provider
//                               fit: BoxFit.fill,
//                             ),
//                     ),
//                     child: controller.profileImg != null
//                         ? Align(
//                             alignment: Alignment.topRight,
//                             child: GestureDetector(
//                               onTap: () {
//                                 controller.profileImg = null;
//                                 controller.update();
//                               },
//                               child: Icon(
//                                 Icons.close_rounded,
//                                 color: DynamicColors.redClr,
//                               ),
//                             ),
//                           )
//                         : Center(
//                             child: Text(
//                               "UPLOAD IMAGE",
//                               style: TextStyle(
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: fieldWidth * 2.7,
//                   child: Column(
//                     children: [
//                       Container(
//                         // height: screenHeight / 20,
//                         width: Get.width,
//                         color: DynamicColors.gryClr,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 18.0, vertical: 12),
//                           child: Row(
//                             children: [
//                               Text(
//                                 AppText.companyinformation,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               Spacer(),
//                               Row(
//                                 children: [
//                                   // Icon(Icons.other_houses_outlined),
//                                   CustomButton(
//                                     verticalPadding: 0.0,
//                                     width: screenWidth / 15,
//                                     height: 40,
//                                     borderRadius: 4,
//                                     btnText: AppText.bankDetails,
//                                     style: mozillaTextRegularText(
//                                         fontSize: 10,
//                                         color: DynamicColors.whiteClr),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Wrap(
//                         runSpacing: 16,
//                         spacing: 10,
//                         children: [
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.nameController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.name,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.emailCompanyController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.email,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.faxController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.fax,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.websiteController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.website,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.telephoneController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.tel,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.emergencyContactController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.emergencyContactHash,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(AppText.backgroundClr,
//                                   style: mozillaTextSemiBoldText(
//                                       context: context, fontSize: 13)),
//                               ColorPickerWidget(
//                                 width: fieldWidth / 2,
//                                 pickerColor: controller.pickerColor,
//                                 onColorChanged: (color) {
//                                   setState(() {
//                                     controller.pickerColor =
//                                         color; // live preview
//                                   });
//                                 },
//                                 onColorSelected: (color) {
//                                   setState(() {
//                                     controller.pickerColor =
//                                         color; // final selected
//                                   });
//                                 },
//                                 borderColor: DynamicColors.gryClr,
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(AppText.foregroundClr,
//                                   style: mozillaTextSemiBoldText(
//                                       context: context, fontSize: 13)),
//                               ColorPickerWidget(
//                                 width: fieldWidth / 2,
//                                 pickerColor: controller.foregroundColor,
//                                 onColorChanged: (color) {
//                                   setState(() {
//                                     controller.foregroundColor =
//                                         color; // live preview
//                                   });
//                                 },
//                                 onColorSelected: (color) {
//                                   setState(() {
//                                     controller.foregroundColor =
//                                         color; // final selected
//                                   });
//                                 },
//                                 borderColor: DynamicColors.gryClr,
//                               ),
//                             ],
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.companyController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.company,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.currencyController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.currency,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.addressController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.address,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.balanceController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.balance,
//                             columnText: true,
//                             height: 35,
//                           ),
//                           CustomTextField(
//                             borderRadius: 4,
//                             controller: controller.abbreviationController,
//                             width: fieldWidth / 2,
//                             hintText: AppText.abbreviation,
//                             columnText: true,
//                             height: 35,
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       CustomButton(
//                         height: 30,
//                         width: fieldWidth,
//                         btnText: AppText.save,
//                         fontSize: 11,
//                         verticalPadding: 0.0,
//                         borderRadius: 4,
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       });
//     });
//   }
// }
