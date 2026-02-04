import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/color_picker_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/administration/controller/administration_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/vehicles_view/controller/controller.dart';
import 'package:get/get.dart';

import '../../../alert/bank_details_alert.dart';
import '../../../alert/shift_alert.dart';

class CreateSubsiDiary extends StatefulWidget {
  const CreateSubsiDiary({super.key});

  @override
  State<CreateSubsiDiary> createState() => _CreateSubsiDiaryState();
}

class _CreateSubsiDiaryState extends State<CreateSubsiDiary> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  AdministrationController controller =
      Get.isRegistered<AdministrationController>()
          ? Get.find<AdministrationController>()
          : Get.put(AdministrationController());

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
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width / WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<AdministrationController>(builder: (controller) {
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
                                  .profileImg!.bytes),
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
                          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                AppText.subsidiary,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  // Icon(Icons.other_houses_outlined),
                                  CustomButton(
                                    onTap: (){
                                      BankDetailsAlert.show();
                                    },
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
                            controller: controller.emailController,
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
                                pickerColor: controller.subsiDiarypickerColor,
                                onColorChanged: (color) {
                                  setState(() {
                                    controller.subsiDiarypickerColor =
                                        color; // live preview
                                  });

                                },
                                onColorSelected: (color) {
                                  setState(() {
                                    controller.subsiDiarypickerColor =
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
                                pickerColor:
                                    controller.subsiDiaryforegroundColor,
                                onColorChanged: (color) {
                                  setState(() {
                                    controller.subsiDiaryforegroundColor =
                                        color; // live preview
                                  });
                                },
                                onColorSelected: (color) {
                                  setState(() {
                                    controller.subsiDiaryforegroundColor =
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
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      CustomButton(
                        onTap: () {
                          controller.createSubsiDiary();
                        },
                        height: 30,
                        width: fieldWidth,
                        btnText: controller.isSubsiDiaryUpdating.value ? "UPDATE USER" : "SAVE",
                        fontSize: 11,
                        verticalPadding: 0.0,
                        borderRadius: 4,
                      ),
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


class BankDetailsAlertClass{
  String? bank;
  String? accountTitle;
  String? account;
  String? iban;
  String? sortCode;
  String? vat;


  BankDetailsAlertClass({this.bank ,this.accountTitle ,this.account, this.iban, this.sortCode, this.vat});
}
