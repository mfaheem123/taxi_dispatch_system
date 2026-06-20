import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/accounts/CompanyAddressAlert.dart';
import 'package:dashboard_new1/view/accounts/ContactAlert.dart';
import 'package:dashboard_new1/view/accounts/DepartmentAlert.dart';
import 'package:dashboard_new1/view/accounts/OrderAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' hide UpperCaseTextFormatter;
import 'package:get/get.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../../alert/web_login_alert.dart';
import '../../../component/color.dart';
import '../../../component/color_picker_widget.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../controller/account_controller.dart';
import '../model/get_subsidiary_bank.dart';

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
    super.initState();
    shortCutKeyValue.value = "accountView";
  }

  List permissions = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      initState: (v) {
        permissions = Api().sp.read('all_permissions') ?? [];
        controller.getSubsdairyBank();
      },
      builder: (controller) {
        return controller.SubsdairyBankLoader.value == true
            ? const SizedBox.shrink()
            : LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;


          final double leftWidth = maxWidth * 0.61;
          final double rightWidth = maxWidth * 0.37;

          final double leftFieldWidth = leftWidth / 6.7;
          final double rightFieldWidth = rightWidth / 4.6;

          const double fieldHeight = 30.0;
          final double dropDownHeight = maxWidth < 1300 ? 34.0 : 30.0;

          final double checkboxSpacing = maxWidth < 1300 ? 10.0 : 40.0;
          final double chargesSpacing = maxWidth < 1300 ? 8.0 : 40.0;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 61,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // MAIN ACCOUNT CONTAINER
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: DynamicColors.textClr),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: [
                              // Header Row
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                child: Row(
                                  children: [
                                    Text(AppText.account, style: titleDesign()),
                                    const Spacer(),
                                    if (permissions.contains('read_account_web_login')) _headerBtn(AppText.webLogin, () => WebLoginAlert.show()),
                                    if (permissions.contains('read_account_department')) _headerBtn(AppText.department, () => DepartmentAlert.show()),
                                    if (permissions.contains('read_account_contact')) _headerBtn(AppText.contact, () => ContactAlert.show()),
                                    if (permissions.contains('read_account_order_number')) _headerBtn(AppText.order, () => OrderAlert.show()),
                                    if (permissions.contains('read_account_company_address')) _headerBtn(AppText.companyAddress, () => CompanyAddressAlert.show(), width: 150),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  spacing: 12,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: maxWidth < 1300 ? 2 : 8,
                                      children: [
                                        _buildTextField(controller.accountNameController, AppText.name, leftFieldWidth, fieldHeight, [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), UpperCaseTextFormatter()]),
                                        _buildTextField(controller.accountCodeController, AppText.code, leftFieldWidth, fieldHeight, [FilteringTextInputFormatter.digitsOnly]),
                                        _buildTextField(controller.accountEmailController, AppText.email, leftFieldWidth, fieldHeight, [FilteringTextInputFormatter.deny(RegExp(r'\s')), UpperCaseTextFormatter()]),
                                        _buildTextField(controller.accountPasswordController, AppText.password, leftFieldWidth, fieldHeight, [UpperCaseTextFormatter()]),
                                        _buildDropdown(AppText.subsidiary, "SELECT SUBSIDIARY", leftFieldWidth*1.3, dropDownHeight, controller.subsidairyBankModel?.subsidiariesList ?? [], controller.subsidiaryStoreValue, (val) { controller.subsidiaryStoreValue = val; controller.update(); }, (item) => item.name!.toUpperCase()),
                                        _buildDropdown(AppText.accountType, "SELECT ACCOUNT", leftFieldWidth*1.1, dropDownHeight, ["Cash", "Account"], controller.accountType, (val) { controller.accountType = val; controller.update(); }, (item) => item),
                                      ],
                                    ),

                                    Row(
                                      spacing: 8,
                                      children: [
                                        _buildTextField(controller.accountMobileController, AppText.mobile, leftFieldWidth, fieldHeight, [FilteringTextInputFormatter.digitsOnly]),
                                        _buildTextField(controller.accountTelController, AppText.tel, leftFieldWidth, fieldHeight, [FilteringTextInputFormatter.digitsOnly]),
                                        _buildTextField(controller.accountFaxController, AppText.fax, leftFieldWidth, fieldHeight, [UpperCaseTextFormatter()]),
                                        _buildTextField(controller.accountWebSiteController, AppText.website, leftFieldWidth, fieldHeight, [UpperCaseTextFormatter()]),
                                        _buildTextField(controller.accountNumberController, AppText.accountNumber, leftFieldWidth, fieldHeight, [FilteringTextInputFormatter.digitsOnly]),
                                        _buildTextField(controller.accountCreditCardController, AppText.creditCard, leftFieldWidth, fieldHeight, [FilteringTextInputFormatter.digitsOnly]),
                                      ],
                                    ),

                                    Row(
                                      spacing: 8,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildTextField(controller.accountAddressController, AppText.address, leftFieldWidth, 82, [UpperCaseTextFormatter()], maxLines: 6),
                                        _buildTextField(controller.accountInformationController, AppText.information, leftFieldWidth, 82, [], maxLines: 6),

                                        Column(
                                          spacing: 12,
                                          children: [
                                            _buildDropdown(AppText.paymentType, "SELECT TYPE", leftFieldWidth, dropDownHeight, ["Cash", "Account"], ["Cash", "Account"].contains(controller.paymentType) ? controller.paymentType : null, (val) { controller.paymentType = val; controller.update(); }, (item) => item),
                                            // _buildTextField(bankAccountController, "BANK ACCOUNT", leftFieldWidth, fieldHeight, []),
                                          ],
                                        ),
                                        Column(
                                          spacing: 12,
                                          children: [
                                            _buildTextField(controller.accountContactNameController, AppText.contactName, leftFieldWidth, fieldHeight, []),
                                            // _buildTextField(startDateController, "START DATE", leftFieldWidth, fieldHeight, []),
                                          ],
                                        ),
                                        Column(
                                          spacing: 12,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(AppText.backgroundClr, style: mozillaTextSemiBoldText(context: context, fontSize: 11)),
                                                SizedBox(
                                                  width: leftFieldWidth,
                                                  height: fieldHeight,
                                                  child: Focus(
                                                    autofocus: true,
                                                    child: ColorPickerWidget(
                                                      width: leftFieldWidth - 5,
                                                      pickerColor: controller.pickerColor,
                                                      onColorChanged: (Color newColor) {
                                                        setState(() { controller.pickerColor = newColor; });
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            // _buildTextField(endDateController, "END DATE", leftFieldWidth, fieldHeight, []),
                                          ],
                                        ),
                                        Column(
                                          spacing: 12,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(AppText.foregroundClr, style: mozillaTextSemiBoldText(context: context, fontSize: 11)),
                                                GestureDetector(
                                                  onTap: () => _showColorPickerDialog(context, controller),
                                                  child: Container(
                                                    height: fieldHeight,
                                                    width: leftFieldWidth,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(4),
                                                      border: Border.all(color: DynamicColors.primaryClr),
                                                    ),
                                                    child: Center(
                                                      child: Container(color: controller.foregroundClr, height: 6, width: leftFieldWidth - 15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: leftFieldWidth, height: fieldHeight),
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

                        const SizedBox(height: 12),

                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              flex: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: DynamicColors.textClr),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      color: DynamicColors.gryClr.withOpacity(0.5),
                                      child: Text(AppText.informationControl, style: titleDesign()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Wrap(
                                        spacing: checkboxSpacing, runSpacing: 6,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          _buildCheckbox(controller.orderCheckBox, AppText.order),
                                          _buildCheckbox(controller.bookedByCheckBox, AppText.bookedBy),
                                          _buildCheckbox(controller.escoptCheckBox, AppText.escopt),
                                          _buildCheckbox(controller.fareControllerCheckBox, AppText.fareController),
                                          _buildCheckbox(controller.bankInfoCheckBox, AppText.bankInfo),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: DynamicColors.textClr),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      color: DynamicColors.gryClr.withOpacity(0.5),
                                      child: Text(AppText.chargesControl, style: titleDesign()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Wrap(
                                        spacing: chargesSpacing, runSpacing: 6,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          _buildCheckbox(controller.adminFeeCheckBox, AppText.adminFee),
                                          _buildCheckbox(controller.accountFeeCheckBox, AppText.accountFee),
                                          _buildCheckbox(controller.vatCheckBox, AppText.vat),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: maxWidth < 1300 ? 5 : 15),

                  Expanded(
                    flex: 37,
                    child: Column(
                      spacing: maxWidth < 1300 ? 17 : 25,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FEE SECTION CONTAINER
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: DynamicColors.textClr),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                child: Text(AppText.feeSection, style: titleDesign()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                Row(
                                  spacing: 6,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: _buildDropdown(AppText.adminFeeType, "SELECT ADMIN FEES TYPE", rightFieldWidth * 1.9, dropDownHeight, ["PERCENTAGE", "AMOUNT"], controller.adminFeesDropDown, (val) { controller.adminFeesDropDown = val; controller.update(); }, (item) => item),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: _buildTextField(controller.accountAdminFeeController, AppText.adminFee, rightFieldWidth * 1.5, fieldHeight, [FilteringTextInputFormatter.digitsOnly]),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: _buildDropdown(AppText.accountFeeType, "SELECT ACCOUNT TYPE", rightFieldWidth * 2, dropDownHeight, ["PERCENTAGE", "AMOUNT"], controller.accountTypeDropDown, (val) { controller.accountTypeDropDown = val; controller.update(); }, (item) => item),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: _buildTextField(controller.accountAccountFeeController, AppText.accountFee, rightFieldWidth * 1.5, fieldHeight, [FilteringTextInputFormatter.digitsOnly]),
                                    ),
                                  ],
                                )
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),

                        // AGENT COMMISSION CONTAINER
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: DynamicColors.textClr),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                child: Text(AppText.agentCommission, style: titleDesign()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    SizedBox(width: 10),
                                    _buildDropdown(AppText.agentCommissionType, "SELECT COMMISSION TYPE", rightFieldWidth * 2, dropDownHeight, ["PERCENTAGE", "AMOUNT"], controller.commissionDropDown, (val) { controller.commissionDropDown = val; controller.update(); }, (item) => item),
                                    SizedBox(width: 10),
                                    _buildTextField(controller.accountAgentCommissionController, AppText.agentCommission, rightFieldWidth * 1.5, fieldHeight, [FilteringTextInputFormatter.digitsOnly]),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),

                        //  SMS CONTROL CONTAINER
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: DynamicColors.textClr),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                child: Text(AppText.smsControl, style: titleDesign()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  spacing: checkboxSpacing, runSpacing: 6,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    _buildCheckbox(controller.dispatchSmsCheckBox, AppText.dispatchSms),
                                    _buildCheckbox(controller.confirmSmsCheckBox, AppText.confirmSms),
                                    _buildCheckbox(controller.arrivalSmsCheckBox, AppText.arrivalSms),
                                    _buildCheckbox(controller.clearJobSmsCheckBox, AppText.clearJobSms),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            Center(
              child: CustomButton(
                height: 35,
                width: 360,
                borderRadius: 4,
                btnText: controller.accountObjectData != null ? "UPDATE" : AppText.save,
                verticalPadding: 0.0,
                fontSize: 13,
                onTap: () {
                  String email = controller.accountEmailController.text.trim();
                  if (email.isEmpty) {
                    BotToast.showText(text: "Email is required");
                  } else if (!email.contains('@')) {
                    BotToast.showText(text: "Invalid Email Format");
                  } else {
                    controller.postAccount();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
              ],
              )),
          );
        });
      },
    );
  }

  Widget _headerBtn(String text, VoidCallback onTap, {double width = 75}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CustomButton(
        verticalPadding: 0.0,
        width: width,
        height: 26,
        borderRadius: 4,
        btnText: text,
        style: mozillaTextRegularText(fontSize: 10, color: DynamicColors.whiteClr),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, double width, double height, List<TextInputFormatter> formatters, {int maxLines = 1}) {
    return CustomTextField(
      borderRadius: 4,
      controller: ctrl,
      width: width,
      hintText: hint,
      columnText: true,
      maxLines: maxLines,
      contentPadding: maxLines > 1 ? const EdgeInsets.only(top: 15, left: 5) : const EdgeInsets.only(left: 5),
      height: height,
      inputFormatters: formatters,
    );
  }

  Widget _buildDropdown<T>(String title, String label, double width, double height, List<T> items, T? value, ValueChanged<T?> onChanged, String Function(T) itemLabel) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth < 1300 ? 10.0 : 11.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: mozillaTextSemiBoldText(context: context, fontSize: titleFontSize)),
        const SizedBox(height: 2),
        CustomDropdownField<T>(
          label: label,
          width: width,
          height: height,
          items: items,
          value: value,
          itemLabel: itemLabel,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCheckbox(RxBool observableValue, String label) {
    return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 15,
          height: 15,
          child: Checkbox(
            value: observableValue.value,
            onChanged: (v) {
              observableValue.value = v!;
              controller.update();
            },
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: mozillaTextRegularText(fontSize: 10, color: DynamicColors.textClr),
        ),
      ],
    ));
  }

  void _showColorPickerDialog(BuildContext context, AccountController controller) {
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
  }
}

// import 'package:bot_toast/bot_toast.dart';
// import 'package:dashboard_new1/component/customButton.dart';
// import 'package:dashboard_new1/component/dropdown_button.dart';
// import 'package:dashboard_new1/view/accounts/CompanyAddressAlert.dart';
// import 'package:dashboard_new1/view/accounts/ContactAlert.dart';
// import 'package:dashboard_new1/view/accounts/DepartmentAlert.dart';
// import 'package:dashboard_new1/view/accounts/OrderAlert.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart'
//     hide UpperCaseTextFormatter;
// import 'package:get/get.dart';
// import '../../../alert/restrict_drivers_alert.dart';
// import '../../../alert/web_login_alert.dart';
// import '../../../component/color.dart';
// import '../../../component/color_picker_widget.dart';
// import '../../../component/networks/api.dart';
// import '../../../component/textStyle.dart';
// import '../../../component/text_field.dart';
// import '../../../component/text_widget.dart';
// import '../../dashboard_view/Controller/dashboard_controller.dart';
// import '../controller/account_controller.dart';
// import '../model/get_subsidiary_bank.dart';
//
// class AccountView extends StatefulWidget {
//   const AccountView({super.key});
//
//   @override
//   State<AccountView> createState() => _AccountViewState();
// }
//
// class _AccountViewState extends State<AccountView> {
//   AccountController controller = Get.isRegistered<AccountController>()
//       ? Get.find<AccountController>()
//       : Get.put(AccountController());
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     shortCutKeyValue.value = "accountView";
//   }
//   List permissions = [];
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     double width = WidgetsBinding
//             .instance.platformDispatcher.views.first.physicalSize.width /
//         WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
//
//     return GetBuilder<AccountController>(initState: (v) {
//            permissions = Api().sp.read('all_permissions') ?? [];
//       controller.getSubsdairyBank();
//     }, builder: (controller) {
//       return controller.SubsdairyBankLoader.value == true
//           ? SizedBox.shrink()
//           : LayoutBuilder(builder: (context, constraints) {
//               final double maxWidth = constraints.maxWidth;
//               final bool isMobile = maxWidth < 600;
//               final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
//
//               // Instead of fixed width, we calculate flexible field widths
//               final double fieldWidth = isMobile
//                   ? maxWidth // full width
//                   : isTablet
//                       ? maxWidth / 2
//                       : maxWidth / 4;
//
//               return Column(
//                 children: [
//                   Wrap(
//                     runSpacing: 10,
//                     spacing: 10,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: fieldWidth * 2.8,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: DynamicColors.textClr),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Wrap(
//                                   children: [
//                                     Container(
//                                       width: Get.width,
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 10, horizontal: 12),
//                                       color:
//                                           DynamicColors.gryClr.withOpacity(0.5),
//                                       child: Row(
//                                         children: [
//                                           Text(AppText.account,
//                                               style: titleDesign()),
//                                           Spacer(),
//                                           if(permissions.contains('read_account_web_login')) CustomButton(
//                                               verticalPadding: 0.0,
//                                               width: 80,
//                                               height: 30,
//                                               borderRadius: 4,
//                                               btnText: AppText.webLogin,
//                                               style: mozillaTextRegularText(
//                                                   fontSize: 10,
//                                                   color:
//                                                       DynamicColors.whiteClr),
//                                               onTap: () {
//                                                 WebLoginAlert.show();
//                                               }),
//                                           if(permissions.contains('read_account_department')) Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0),
//                                             child: CustomButton(
//                                               verticalPadding: 0.0,
//                                               width: 80,
//                                               height: 30,
//                                               borderRadius: 4,
//                                               btnText: AppText.department,
//                                               style: mozillaTextRegularText(
//                                                   fontSize: 10,
//                                                   color:
//                                                       DynamicColors.whiteClr),
//                                               onTap: () {
//                                                 DepartmentAlert.show();
//                                               },
//                                             ),
//                                           ),
//                                           if(permissions.contains('read_account_contact')) CustomButton(
//                                             verticalPadding: 0.0,
//                                             width: 60,
//                                             height: 30,
//                                             borderRadius: 4,
//                                             btnText: AppText.contact,
//                                             style: mozillaTextRegularText(
//                                                 fontSize: 10,
//                                                 color: DynamicColors.whiteClr),
//                                             onTap: () {
//                                               ContactAlert.show();
//                                             },
//                                           ),
//                                           if(permissions.contains('read_account_order_number')) Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0),
//                                             child: CustomButton(
//                                               verticalPadding: 0.0,
//                                               width: 60,
//                                               height: 30,
//                                               borderRadius: 4,
//                                               btnText: AppText.order,
//                                               style: mozillaTextRegularText(
//                                                   fontSize: 10,
//                                                   color:
//                                                       DynamicColors.whiteClr),
//                                               onTap: () {
//                                                 OrderAlert.show();
//                                               },
//                                             ),
//                                           ),
//                                           if(permissions.contains('read_account_company_address')) CustomButton(
//                                             verticalPadding: 0.0,
//                                             width: 125,
//                                             height: 30,
//                                             borderRadius: 4,
//                                             btnText: AppText.companyAddress,
//                                             style: mozillaTextRegularText(
//                                                 fontSize: 10,
//                                                 color: DynamicColors.whiteClr),
//                                             onTap: () {
//                                               CompanyAddressAlert.show();
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Wrap(
//                                       spacing: 10,
//                                       runSpacing: 10,
//                                       children: [
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller:
//                                               controller.accountNameController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.name,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter.allow(
//                                                 RegExp(r'[a-zA-Z\s]')),
//                                             UpperCaseTextFormatter(),
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller:
//                                               controller.accountCodeController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.code,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly,
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller:
//                                               controller.accountEmailController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.email,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter.deny(
//                                                 RegExp(r'\s')),
//                                             UpperCaseTextFormatter(),
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller: controller
//                                               .accountPasswordController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.password,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             UpperCaseTextFormatter(),
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(AppText.subsidiary,
//                                                 style: mozillaTextSemiBoldText(
//                                                     context: context,
//                                                     fontSize: 13)),
//                                             CustomDropdownField<Subsidiary>(
//                                               label: "SELECT SUBSIDIARY",
//                                               width: Get.width / 7,
//                                               height: 35,
//                                               items: controller
//                                                   .subsidairyBankModel!
//                                                   .subsidiariesList!,
//                                               value: controller
//                                                   .subsidiaryStoreValue,
//                                               itemLabel: (templateList) =>
//                                                   templateList.name!
//                                                       .toUpperCase(),
//                                               onChanged: (val) {
//                                                 controller
//                                                     .subsidiaryStoreValue = val;
//                                                 controller.update();
//                                               },
//                                             ),
//                                             // RestrictedDrivers(
//                                             //   width: fieldWidth / 2.5,
//                                             //   // height: 35,
//                                             //   padding: 0.0,
//                                             //   border: Border.all(
//                                             //     color: DynamicColors.gryClr,
//                                             //   ),
//                                             //   titleText: "DEMO COMPANY",
//                                             //   driversList: [
//                                             //     "DEMO COMPANY 01",
//                                             //     "DEMO COMPANY 02",
//                                             //     "DEMO COMPANY 03",
//                                             //     "DEMO COMPANY 04",
//                                             //   ],
//                                             // ),
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(AppText.accountType,
//                                                 style: mozillaTextSemiBoldText(
//                                                     context: context,
//                                                     fontSize: 13)),
//                                             CustomDropdownField<String>(
//                                               label: "SELECT ACCOUNT",
//                                               width: Get.width / 7,
//                                               height: 35,
//                                               items: [
//                                                 "Cash",
//                                                 "Account",
//                                               ],
//                                               value: controller.accountType,
//                                               itemLabel: (templateList) =>
//                                                   templateList,
//                                               onChanged: (val) {
//                                                 controller.accountType = val;
//                                                 controller.update();
//                                               },
//                                             ),
//                                             // RestrictedDrivers(
//                                             //   width: fieldWidth/2.5,
//                                             //   // height: 35,
//                                             //   padding: 0.0,
//                                             //   border: Border.all(
//                                             //     color: DynamicColors.gryClr,
//                                             //   ),
//                                             //   titleText: "SELECT ACCOUNT",
//                                             //   driversList: [
//                                             //     "SELECT ACCOUNT 01",
//                                             //     "SELECT ACCOUNT 02",
//                                             //     "SELECT ACCOUNT 03",
//                                             //     "SELECT ACCOUNT 04",
//                                             //   ],
//                                             // ),
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller: controller
//                                               .accountMobileController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.mobile,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter.digitsOnly,
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller:
//                                               controller.accountTelController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.tel,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter.digitsOnly,
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller:
//                                               controller.accountFaxController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.fax,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             UpperCaseTextFormatter(),
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller: controller
//                                               .accountWebSiteController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.website,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             UpperCaseTextFormatter(),
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller: controller
//                                               .accountNumberController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.accountNumber,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter.digitsOnly,
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller: controller
//                                               .accountCreditCardController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.creditCard,
//                                           columnText: true,
//                                           height: 30,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter.digitsOnly,
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller: controller
//                                               .accountAddressController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.address,
//                                           columnText: true,
//                                           maxLines: 3,
//                                           contentPadding:
//                                               EdgeInsets.only(top: 15, left: 3),
//                                           height: 30,
//                                           inputFormatters: [
//                                             UpperCaseTextFormatter(),
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(AppText.paymentType,
//                                                 style: mozillaTextSemiBoldText(
//                                                     context: context,
//                                                     fontSize: 13)),
//                                             CustomDropdownField<String>(
//                                               label: "SELECT TYPE",
//                                               width: Get.width / 6,
//                                               height: 30,
//                                               items: [
//                                                 "Cash",
//                                                 "Account",
//                                               ],
//                                               // value: controller.paymentType,
//                                               value: [
//                                                 "Cash",
//                                                 "Account"
//                                               ].contains(controller.paymentType)
//                                                   ? controller.paymentType
//                                                   : null,
//                                               itemLabel: (templateList) =>
//                                                   templateList,
//                                               onChanged: (val) {
//                                                 controller.paymentType = val;
//                                                 controller.update();
//                                               },
//                                             ),
//                                             // RestrictedDrivers(
//                                             //   width: fieldWidth/2.5,
//                                             //   // height: 35,
//                                             //   padding: 0.0,
//                                             //   border: Border.all(
//                                             //     color: DynamicColors.gryClr,
//                                             //   ),
//                                             //   titleText: "",
//                                             //   driversList: [
//                                             //     "CASH",
//                                             //     "CREDIT CARD",
//                                             //     "ACCOUNT",
//                                             //     "CREDIT CARD PAID",
//                                             //   ],
//                                             // ),
//                                           ],
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller: controller
//                                               .accountInformationController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.information,
//                                           columnText: true,
//                                           maxLines: 3,
//                                           contentPadding:
//                                               EdgeInsets.only(top: 15, left: 3),
//                                           height: 30,
//                                         ),
//                                         CustomTextField(
//                                           borderRadius: 4,
//                                           controller: controller
//                                               .accountContactNameController,
//                                           width: fieldWidth / 3,
//                                           hintText: AppText.contactName,
//                                           columnText: true,
//                                           contentPadding:
//                                               EdgeInsets.only(top: 6, left: 3),
//                                           height: 30,
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(AppText.backgroundClr,
//                                                 style: mozillaTextSemiBoldText(
//                                                     context: context,
//                                                     fontSize: 13)),
//                                             SizedBox(
//                                               width: fieldWidth / 3,
//                                               child: Focus(
//                                                 autofocus: true,
//                                                 child: ColorPickerWidget(
//                                                   width: fieldWidth / 3.3,
//                                                   pickerColor:
//                                                       controller.pickerColor,
//                                                   onColorChanged:
//                                                       (Color newColor) {
//                                                     // This produces your '0xFF2196F3' format
//                                                     String hexString =
//                                                         '0x${newColor.value.toRadixString(16).toUpperCase()}';
//                                                     print(hexString);
//                                                     setState(() {
//                                                       controller.pickerColor =
//                                                           newColor;
//                                                     });
//                                                   },
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(AppText.foregroundClr,
//                                                 style: mozillaTextSemiBoldText(
//                                                     context: context,
//                                                     fontSize: 13)),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder:
//                                                       (BuildContext context) {
//                                                     return AlertDialog(
//                                                       title: const Text(
//                                                           'Pick a color!'),
//                                                       content:
//                                                           SingleChildScrollView(
//                                                         child: ColorPicker(
//                                                           pickerColor: controller
//                                                               .foregroundClr,
//                                                           onColorChanged:
//                                                               controller
//                                                                   .foregroundColor,
//                                                         ),
//                                                       ),
//                                                       actions: <Widget>[
//                                                         ElevatedButton(
//                                                           child: const Text(
//                                                               'Got it'),
//                                                           onPressed: () {
//                                                             controller
//                                                                     .foregroundCurrentColor =
//                                                                 controller
//                                                                     .foregroundClr;
//                                                             controller.update();
//                                                             Navigator.of(
//                                                                     context)
//                                                                 .pop();
//                                                           },
//                                                         ),
//                                                       ],
//                                                     );
//                                                   },
//                                                 );
//                                               },
//                                               child: Container(
//                                                 height: 30,
//                                                 width: fieldWidth / 3,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(4),
//                                                   border: Border.all(
//                                                       color: DynamicColors
//                                                           .primaryClr),
//                                                 ),
//                                                 child: Center(
//                                                   child: Container(
//                                                     color: controller
//                                                         .foregroundClr,
//                                                     height: 5,
//                                                     width: fieldWidth / 3.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//
//                                         // Column(
//                                         //   crossAxisAlignment: CrossAxisAlignment.start,
//                                         //   children: [
//                                         //     Text(AppText.bankAccount,
//                                         //         style: mozillaTextSemiBoldText(
//                                         //             context: context, fontSize: 13)),
//                                         //
//                                         //     CustomDropdownField<Subsidiary>(
//                                         //       label: "Select Subsidiary",
//                                         //       width: Get.width / 5,
//                                         //       height: 35,
//                                         //       items: controller.subsidairyBankModel!.subsidiariesList!,
//                                         //       value: controller.subsidiaryStoreValue,
//                                         //       itemLabel: (templateList) =>
//                                         //       templateList.name!,
//                                         //       onChanged: (val) {
//                                         //         controller.subsidiaryStoreValue = val;
//                                         //         controller.update();
//                                         //       },
//                                         //     ),
//                                         //     // RestrictedDrivers(
//                                         //     //   width: fieldWidth/2.5,
//                                         //     //   // height: 35,
//                                         //     //   padding: 0.0,
//                                         //     //   border: Border.all(
//                                         //     //     color: DynamicColors.gryClr,
//                                         //     //   ),
//                                         //     //   titleText: "",
//                                         //     //   driversList: [
//                                         //     //     "BANK ACCOUNT 01",
//                                         //     //     "BANK ACCOUNT 02",
//                                         //     //     "BANK ACCOUNT 03",
//                                         //     //     "BANK ACCOUNT 04",
//                                         //     //   ],
//                                         //     // ),
//                                         //   ],
//                                         // ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Container(
//                           width: fieldWidth * 1.5,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: DynamicColors.textClr),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: Get.width,
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 12),
//                                 color: DynamicColors.gryClr.withOpacity(0.5),
//                                 child: Text(AppText.feeSection,
//                                     style: titleDesign()),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Wrap(
//                                   runSpacing: 10,
//                                   spacing: 10,
//                                   crossAxisAlignment: WrapCrossAlignment.start,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(AppText.adminFeeType,
//                                             style: mozillaTextSemiBoldText(
//                                                 context: context,
//                                                 fontSize: 13)),
//                                         CustomDropdownField<String>(
//                                           label: "SELECT ADMIN FEES TYPE",
//                                           width: Get.width / 6,
//                                           height: 30,
//                                           items: [
//                                             "PERCENTAGE",
//                                             "AMOUNT",
//                                           ],
//                                           value: controller.adminFeesDropDown,
//                                           itemLabel: (templateList) =>
//                                               templateList,
//                                           onChanged: (val) {
//                                             controller.adminFeesDropDown = val;
//                                             controller.update();
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     CustomTextField(
//                                       borderRadius: 4,
//                                       controller:
//                                           controller.accountAdminFeeController,
//                                       width: fieldWidth / 3,
//                                       hintText: AppText.adminFee,
//                                       columnText: true,
//                                       contentPadding:
//                                           EdgeInsets.only(top: 6, left: 3),
//                                       height: 30,
//                                       inputFormatters: [
//                                         FilteringTextInputFormatter.digitsOnly,
//                                       ],
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(AppText.accountFeeType,
//                                             style: mozillaTextSemiBoldText(
//                                                 context: context,
//                                                 fontSize: 13)),
//                                         CustomDropdownField<String>(
//                                           label: "SELECT ACCOUNT TYPE",
//                                           width: Get.width / 6,
//                                           height: 30,
//                                           items: [
//                                             "PERCENTAGE",
//                                             "AMOUNT",
//                                           ],
//                                           value: controller.accountTypeDropDown,
//                                           itemLabel: (templateList) =>
//                                               templateList,
//                                           onChanged: (val) {
//                                             controller.accountTypeDropDown =
//                                                 val;
//                                             controller.update();
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     CustomTextField(
//                                       borderRadius: 4,
//                                       controller: controller
//                                           .accountAccountFeeController,
//                                       width: fieldWidth / 3,
//                                       hintText: AppText.accountFee,
//                                       columnText: true,
//                                       contentPadding:
//                                           EdgeInsets.only(top: 6, left: 3),
//                                       height: 30,
//                                       inputFormatters: [
//                                         FilteringTextInputFormatter.digitsOnly,
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Container(
//                           width: fieldWidth * 1.5,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: DynamicColors.textClr),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: Get.width,
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 12),
//                                 color: DynamicColors.gryClr.withOpacity(0.5),
//                                 child: Text(AppText.agentCommission,
//                                     style: titleDesign()),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Wrap(
//                                   runSpacing: 10,
//                                   spacing: 10,
//                                   crossAxisAlignment: WrapCrossAlignment.start,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(AppText.agentCommissionType,
//                                             style: mozillaTextSemiBoldText(
//                                                 context: context,
//                                                 fontSize: 13)),
//                                         CustomDropdownField<String>(
//                                           label: "SELECT COMMISSION TYPE",
//                                           width: Get.width / 6,
//                                           height: 30,
//                                           items: [
//                                             "PERCENTAGE",
//                                             "AMOUNT",
//                                           ],
//                                           value: controller.commissionDropDown,
//                                           itemLabel: (templateList) =>
//                                               templateList,
//                                           onChanged: (val) {
//                                             controller.commissionDropDown = val;
//                                             controller.update();
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     CustomTextField(
//                                       borderRadius: 4,
//                                       controller: controller
//                                           .accountAgentCommissionController,
//                                       width: fieldWidth / 2,
//                                       hintText: AppText.agentCommission,
//                                       columnText: true,
//                                       contentPadding:
//                                           EdgeInsets.only(top: 6, left: 3),
//                                       height: 30,
//                                       inputFormatters: [
//                                         FilteringTextInputFormatter.digitsOnly,
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: Container(
//                           width: fieldWidth * 1.6,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: DynamicColors.textClr),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: Get.width,
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 12),
//                                 color: DynamicColors.gryClr.withOpacity(0.5),
//                                 child: Text(AppText.informationControl,
//                                     style: titleDesign()),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Wrap(
//                                   runSpacing: 10,
//                                   spacing: 10,
//                                   crossAxisAlignment: WrapCrossAlignment.center,
//                                   alignment: WrapAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: Checkbox(
//                                           value: controller.orderCheckBox.value,
//                                           onChanged: (v) {
//                                             controller.orderCheckBox.value = v!;
//                                             controller.update();
//                                           }),
//                                     ),
//                                     Text(
//                                       AppText.order,
//                                       style: mozillaTextRegularText(
//                                           fontSize: 10,
//                                           color: DynamicColors.textClr),
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: Checkbox(
//                                           value:
//                                               controller.bookedByCheckBox.value,
//                                           onChanged: (v) {
//                                             controller.bookedByCheckBox.value =
//                                                 v!;
//                                             controller.update();
//                                           }),
//                                     ),
//                                     Text(
//                                       AppText.bookedBy,
//                                       style: mozillaTextRegularText(
//                                           fontSize: 10,
//                                           color: DynamicColors.textClr),
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: Checkbox(
//                                           value:
//                                               controller.escoptCheckBox.value,
//                                           onChanged: (v) {
//                                             controller.escoptCheckBox.value =
//                                                 v!;
//                                             controller.update();
//                                           }),
//                                     ),
//                                     Text(
//                                       AppText.escopt,
//                                       style: mozillaTextRegularText(
//                                           fontSize: 10,
//                                           color: DynamicColors.textClr),
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: Checkbox(
//                                           value: controller
//                                               .fareControllerCheckBox.value,
//                                           onChanged: (v) {
//                                             controller.fareControllerCheckBox
//                                                 .value = v!;
//                                             controller.update();
//                                           }),
//                                     ),
//                                     Text(
//                                       AppText.fareController,
//                                       style: mozillaTextRegularText(
//                                           fontSize: 10,
//                                           color: DynamicColors.textClr),
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: Checkbox(
//                                           value:
//                                               controller.bankInfoCheckBox.value,
//                                           onChanged: (v) {
//                                             controller.bankInfoCheckBox.value =
//                                                 v!;
//                                             controller.update();
//                                           }),
//                                     ),
//                                     Text(
//                                       AppText.bankInfo,
//                                       style: mozillaTextRegularText(
//                                           fontSize: 10,
//                                           color: DynamicColors.textClr),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: fieldWidth,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: DynamicColors.textClr),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: Get.width,
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 12),
//                               color: DynamicColors.gryClr.withOpacity(0.5),
//                               child: Text(AppText.chargesControl,
//                                   style: titleDesign()),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Wrap(
//                                 runSpacing: 10,
//                                 spacing: 10,
//                                 crossAxisAlignment: WrapCrossAlignment.center,
//                                 alignment: WrapAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: Checkbox(
//                                         value:
//                                             controller.adminFeeCheckBox.value,
//                                         onChanged: (v) {
//                                           controller.adminFeeCheckBox.value =
//                                               v!;
//                                           controller.update();
//                                         }),
//                                   ),
//                                   Text(
//                                     AppText.adminFee,
//                                     style: mozillaTextRegularText(
//                                         fontSize: 10,
//                                         color: DynamicColors.textClr),
//                                   ),
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: Checkbox(
//                                         value:
//                                             controller.accountFeeCheckBox.value,
//                                         onChanged: (v) {
//                                           controller.accountFeeCheckBox.value =
//                                               v!;
//                                           controller.update();
//                                         }),
//                                   ),
//                                   Text(
//                                     AppText.accountFee,
//                                     style: mozillaTextRegularText(
//                                         fontSize: 10,
//                                         color: DynamicColors.textClr),
//                                   ),
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: Checkbox(
//                                         value: controller.vatCheckBox.value,
//                                         onChanged: (v) {
//                                           controller.vatCheckBox.value = v!;
//                                           controller.update();
//                                         }),
//                                   ),
//                                   Text(
//                                     AppText.vat,
//                                     style: mozillaTextRegularText(
//                                         fontSize: 10,
//                                         color: DynamicColors.textClr),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         width: fieldWidth,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: DynamicColors.textClr),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: Get.width,
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 12),
//                               color: DynamicColors.gryClr.withOpacity(0.5),
//                               child: Text(AppText.smsControl,
//                                   style: titleDesign()),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Wrap(
//                                 runSpacing: 10,
//                                 spacing: 10,
//                                 crossAxisAlignment: WrapCrossAlignment.center,
//                                 alignment: WrapAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: Checkbox(
//                                         value: controller
//                                             .dispatchSmsCheckBox.value,
//                                         onChanged: (v) {
//                                           controller.dispatchSmsCheckBox.value =
//                                               v!;
//                                           controller.update();
//                                         }),
//                                   ),
//                                   Text(
//                                     AppText.dispatchSms,
//                                     style: mozillaTextRegularText(
//                                         fontSize: 10,
//                                         color: DynamicColors.textClr),
//                                   ),
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: Checkbox(
//                                         value:
//                                             controller.confirmSmsCheckBox.value,
//                                         onChanged: (v) {
//                                           controller.confirmSmsCheckBox.value =
//                                               v!;
//                                           controller.update();
//                                         }),
//                                   ),
//                                   Text(
//                                     AppText.confirmSms,
//                                     style: mozillaTextRegularText(
//                                         fontSize: 10,
//                                         color: DynamicColors.textClr),
//                                   ),
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: Checkbox(
//                                         value:
//                                             controller.arrivalSmsCheckBox.value,
//                                         onChanged: (v) {
//                                           controller.arrivalSmsCheckBox.value =
//                                               v!;
//                                           controller.update();
//                                         }),
//                                   ),
//                                   Text(
//                                     AppText.arrivalSms,
//                                     style: mozillaTextRegularText(
//                                         fontSize: 10,
//                                         color: DynamicColors.textClr),
//                                   ),
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: Checkbox(
//                                         value: controller
//                                             .clearJobSmsCheckBox.value,
//                                         onChanged: (v) {
//                                           controller.clearJobSmsCheckBox.value =
//                                               v!;
//                                           controller.update();
//                                         }),
//                                   ),
//                                   Text(
//                                     AppText.clearJobSms,
//                                     style: mozillaTextRegularText(
//                                         fontSize: 10,
//                                         color: DynamicColors.textClr),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   CustomButton(
//                     height: 30,
//                     borderRadius: 4,
//                     btnText: controller.accountObjectData != null
//                         ? "UPDATE"
//                         : AppText.save,
//                     verticalPadding: 0.0,
//                     fontSize: 13,
//                     onTap: () {
//                       String email =
//                           controller.accountEmailController.text.trim();
//
//                       if (email.isEmpty) {
//                         BotToast.showText(text: "Email is required");
//                       } else if (!email.contains('@')) {
//                         BotToast.showText(text: "Invalid Email Format");
//                       } else {
//                         controller.postAccount();
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               );
//             });
//     });
//   }
// }
