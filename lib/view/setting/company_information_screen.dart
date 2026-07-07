import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/color_picker_widget.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/setting/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/networks/api.dart';

class CompanyInformationScreen extends StatefulWidget {
  const CompanyInformationScreen({super.key});

  @override
  State<CompanyInformationScreen> createState() =>
      _CompanyInformationScreenState();
}

class _CompanyInformationScreenState extends State<CompanyInformationScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()

      : Get.put(SettingController());


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
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<SettingController>(
        initState: (v){
          permissions = Api().sp.read('all_permissions') ?? [];
          print(permissions);
        },
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
                  width: fieldWidth * 2.7,
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
                                AppText.companyinformation,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  // Icon(Icons.other_houses_outlined),
                                  CustomButton(
                                    verticalPadding: 0.0,
                                    width: screenWidth / 15,
                                    height: 40,
                                    borderRadius: 4,
                                    btnText: AppText.bankDetails,
                                    style: mozillaTextRegularText(
                                        fontSize: 10,
                                        color: DynamicColors.whiteClr),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                            controller: controller.nameController,
                            width: fieldWidth / 2,
                            hintText: AppText.name,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.emailCompanyController,
                            width: fieldWidth / 2,
                            hintText: AppText.email,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.faxController,
                            width: fieldWidth / 2,
                            hintText: AppText.fax,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.websiteController,
                            width: fieldWidth / 2,
                            hintText: AppText.website,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.telephoneController,
                            width: fieldWidth / 2,
                            hintText: AppText.tel,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.emergencyContactController,
                            width: fieldWidth / 2,
                            hintText: AppText.emergencyContactHash,
                            columnText: true,
                            height: 35,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.backgroundClr,
                                  style: mozillaTextSemiBoldText(
                                      context: context, fontSize: 13)),
                              ColorPickerWidget(
                                width: fieldWidth / 2,
                                pickerColor: controller.pickerColor,
                                onColorChanged: (color) {
                                  setState(() {
                                    controller.pickerColor =
                                        color; // live preview
                                  });
                                },
                                onColorSelected: (color) {
                                  setState(() {
                                    controller.pickerColor =
                                        color; // final selected
                                  });
                                },
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
                              ColorPickerWidget(
                                width: fieldWidth / 2,
                                pickerColor: controller.foregroundColor,
                                onColorChanged: (color) {
                                  setState(() {
                                    controller.foregroundColor =
                                        color; // live preview
                                  });
                                },
                                onColorSelected: (color) {
                                  setState(() {
                                    controller.foregroundColor =
                                        color; // final selected
                                  });
                                },
                                borderColor: DynamicColors.gryClr,
                              ),
                            ],
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.companyController,
                            width: fieldWidth / 2,
                            hintText: AppText.company,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.currencyController,
                            width: fieldWidth / 2,
                            hintText: AppText.currency,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.addressController,
                            width: fieldWidth / 2,
                            hintText: AppText.address,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.balanceController,
                            width: fieldWidth / 2,
                            hintText: AppText.balance,
                            columnText: true,
                            height: 35,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.abbreviationController,
                            width: fieldWidth / 2,
                            hintText: AppText.abbreviation,
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
      });
    });
  }
}
