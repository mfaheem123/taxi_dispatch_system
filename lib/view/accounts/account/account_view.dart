import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/color_picker_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../controller/account_controller.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "accountView";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
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

            return Column(
              children: [
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    Container(
                      width: fieldWidth*2.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.textClr),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Wrap(
                            children: [
                              Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                child: Row(
                                  children: [
                                    Text(AppText.account, style: titleDesign()),
                                    Spacer(),
                                    CustomButton(
                                      verticalPadding: 0.0,
                                      width: 80,
                                      height: 30,
                                      borderRadius: 4,
                                      btnText: AppText.webLogin,
                                      style: mozillaTextRegularText(
                                        fontSize: 10,
                                        color: DynamicColors.whiteClr
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: CustomButton(
                                        verticalPadding: 0.0,
                                        width: 80,
                                        height: 30,
                                        borderRadius: 4,
                                        btnText: AppText.department,
                                        style: mozillaTextRegularText(
                                          fontSize: 10,
                                          color: DynamicColors.whiteClr
                                        ),
                                      ),
                                    ),
                                    CustomButton(
                                      verticalPadding: 0.0,
                                      width: 60,
                                      height: 30,
                                      borderRadius: 4,
                                      btnText: AppText.contact,
                                      style: mozillaTextRegularText(
                                        fontSize: 10,
                                        color: DynamicColors.whiteClr
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: CustomButton(
                                        verticalPadding: 0.0,
                                        width: 60,
                                        height: 30,
                                        borderRadius: 4,
                                        btnText: AppText.order,
                                        style: mozillaTextRegularText(
                                          fontSize: 10,
                                          color: DynamicColors.whiteClr
                                        ),
                                      ),
                                    ),
                                    CustomButton(
                                      verticalPadding: 0.0,
                                      width: 125,
                                      height: 30,
                                      borderRadius: 4,
                                      btnText: AppText.companyAddress,
                                      style: mozillaTextRegularText(
                                        fontSize: 10,
                                        color: DynamicColors.whiteClr
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerNameController,
                                    width: fieldWidth/3,
                                    hintText: AppText.name,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerCodeController,
                                    width: fieldWidth/3,
                                    hintText: AppText.code,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerEmailController,
                                    width: fieldWidth/3,
                                    hintText: AppText.email,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerPasswordController,
                                    width: fieldWidth/3,
                                    hintText: AppText.password,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.subsidiary, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      RestrictedDrivers(
                                        width: fieldWidth/2.5,
                                        // height: 35,
                                        padding: 0.0,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        titleText: "DEMO COMPANY",
                                        driversList: [
                                          "DEMO COMPANY 01",
                                          "DEMO COMPANY 02",
                                          "DEMO COMPANY 03",
                                          "DEMO COMPANY 04",
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.accountType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      RestrictedDrivers(
                                        width: fieldWidth/2.5,
                                        // height: 35,
                                        padding: 0.0,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        titleText: "SELECT ACCOUNT",
                                        driversList: [
                                          "SELECT ACCOUNT 01",
                                          "SELECT ACCOUNT 02",
                                          "SELECT ACCOUNT 03",
                                          "SELECT ACCOUNT 04",
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerMobileController,
                                    width: fieldWidth/3,
                                    hintText: AppText.mobile,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerTelephoneController,
                                    width: fieldWidth/3,
                                    hintText: AppText.tel,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerFaxController,
                                    width: fieldWidth/3,
                                    hintText: AppText.fax,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerWebsiteController,
                                    width: fieldWidth/3,
                                    hintText: AppText.website,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerAccountNumberController,
                                    width: fieldWidth/3,
                                    hintText: AppText.accountNumber,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerCreditCardController,
                                    width: fieldWidth/3,
                                    hintText: AppText.creditCard,
                                    columnText: true,
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerAddressController,
                                    width: fieldWidth/3,
                                    hintText: AppText.address,
                                    columnText: true,
                                    maxLines: 3,
                                    contentPadding: EdgeInsets.only(top: 6,left: 3),
                                    height: 30,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.paymentType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      RestrictedDrivers(
                                        width: fieldWidth/2.5,
                                        // height: 35,
                                        padding: 0.0,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        titleText: "",
                                        driversList: [
                                          "CASH",
                                          "CREDIT CARD",
                                          "ACCOUNT",
                                          "CREDIT CARD PAID",
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerInformationController,
                                    width: fieldWidth/3,
                                    hintText: AppText.information,
                                    columnText: true,
                                    maxLines: 3,
                                    contentPadding: EdgeInsets.only(top: 6,left: 3),
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerContactNameController,
                                    width: fieldWidth/3,
                                    hintText: AppText.contactName,
                                    columnText: true,
                                    contentPadding: EdgeInsets.only(top: 6,left: 3),
                                    height: 30,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.backgroundClr, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                      ColorPickerWidget(
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
                        width: fieldWidth/3,
                        borderColor: Colors.grey,
                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.foregroundClr, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Pick a color!'),
                                                content: SingleChildScrollView(
                                                  child: ColorPicker(
                                                    pickerColor: controller.foregroundClr,
                                                    onColorChanged: controller.foregroundColor,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: const Text('Got it'),
                                                    onPressed: () {
                                                      controller.foregroundCurrentColor = controller.foregroundClr;
                                                      controller.update();
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 30,
                                          width: fieldWidth/3,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: DynamicColors.primaryClr),
                                          ),
                                          child: Center(
                                            child: Container(
                                              color: controller.foregroundClr,
                                              height: 5,width: fieldWidth/3.5,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.bankAccount, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                      RestrictedDrivers(
                                        width: fieldWidth/2.5,
                                        // height: 35,
                                        padding: 0.0,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        titleText: "",
                                        driversList: [
                                          "BANK ACCOUNT 01",
                                          "BANK ACCOUNT 02",
                                          "BANK ACCOUNT 03",
                                          "BANK ACCOUNT 04",
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                    Container(
                    width: fieldWidth*1.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.textClr),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(AppText.feeSection, style: titleDesign()),
                          ),
                          Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppText.adminFeeType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                  RestrictedDrivers(
                                    width: fieldWidth/2.5,
                                    // height: 35,
                                    padding: 0.0,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    titleText: "",
                                    driversList: [
                                      "SELECT ADMIN FEES TYPE",
                                      "PERCENTAGE",
                                      "AMOUNT",
                                    ],
                                  ),
                                ],
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.customerAdminFeeController,
                                width: fieldWidth/3,
                                hintText: AppText.adminFee,
                                columnText: true,
                                contentPadding: EdgeInsets.only(top: 6,left: 3),
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppText.accountFeeType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                  RestrictedDrivers(
                                    width: fieldWidth/2.5,
                                    // height: 35,
                                    padding: 0.0,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    titleText: "",
                                    driversList: [
                                      "SELECT ADMIN FEES TYPE",
                                      "PERCENTAGE",
                                      "AMOUNT",
                                    ],
                                  ),
                                ],
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.customerAccountFeeController,
                                width: fieldWidth/3,
                                hintText: AppText.accountFee,
                                columnText: true,
                                contentPadding: EdgeInsets.only(top: 6,left: 3),
                                height: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: fieldWidth*1.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.textClr),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(AppText.agentCommission, style: titleDesign()),
                          ),
                          Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppText.agentCommissionType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                                  RestrictedDrivers(
                                    width: fieldWidth/2.0,
                                    // height: 35,
                                    padding: 0.0,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    titleText: "",
                                    driversList: [
                                      "SELECT AGENT COMMISSION TYPE 01",
                                      "SELECT AGENT COMMISSION TYPE 02",
                                      "SELECT AGENT COMMISSION TYPE 03",
                                    ],
                                  ),
                                ],
                              ),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.customerAgentCommissionController,
                                width: fieldWidth/2,
                                hintText: AppText.agentCommission,
                                columnText: true,
                                contentPadding: EdgeInsets.only(top: 6,left: 3),
                                height: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: fieldWidth*1.6,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.textClr),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(AppText.informationControl, style: titleDesign()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.orderCheckBox.value,
                                      onChanged: (v){
                                        controller.orderCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.order,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.bookedByCheckBox.value,
                                      onChanged: (v){
                                        controller.bookedByCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.bookedBy,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.escoptCheckBox.value,
                                      onChanged: (v){
                                        controller.escoptCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.escopt,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.fareControllerCheckBox.value,
                                      onChanged: (v){
                                        controller.fareControllerCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.fareController,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.bankInfoCheckBox.value,
                                      onChanged: (v){
                                        controller.bankInfoCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.bankInfo,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: fieldWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.textClr),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(AppText.chargesControl, style: titleDesign()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.adminFeeCheckBox.value,
                                      onChanged: (v){
                                        controller.adminFeeCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.adminFee,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.accountFeeCheckBox.value,
                                      onChanged: (v){
                                        controller.accountFeeCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.accountFee,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.vatCheckBox.value,
                                      onChanged: (v){
                                        controller.vatCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.vat,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: fieldWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.textClr),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            color: DynamicColors.gryClr.withOpacity(0.5),
                            child: Text(AppText.smsControl, style: titleDesign()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.dispatchSmsCheckBox.value,
                                      onChanged: (v){
                                        controller.dispatchSmsCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.dispatchSms,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.confirmSmsCheckBox.value,
                                      onChanged: (v){
                                        controller.confirmSmsCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.confirmSms,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.arrivalSmsCheckBox.value,
                                      onChanged: (v){
                                        controller.arrivalSmsCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.arrivalSms,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                      value: controller.clearJobSmsCheckBox.value,
                                      onChanged: (v){
                                        controller.clearJobSmsCheckBox.value = v!;
                                        controller.update();
                                      }),
                                ),
                                Text(AppText.clearJobSms,
                                  style: mozillaTextRegularText(
                                      fontSize: 10,
                                      color: DynamicColors.textClr
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
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  height: 30,
                  borderRadius: 4,
                  btnText: AppText.save,
                  verticalPadding: 0.0,
                  fontSize: 13,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          }
        );
      }
    );
  }
}
