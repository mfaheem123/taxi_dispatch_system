import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/accounts/CompanyAddressAlert.dart';
import 'package:dashboard_new1/view/accounts/ContactAlert.dart';
import 'package:dashboard_new1/view/accounts/DepartmentAlert.dart';
import 'package:dashboard_new1/view/accounts/OrderAlert.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'
    hide UpperCaseTextFormatter;
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
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "accountView";
    if (controller.accountObjectData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.clearAccountForm();
      });
    }
  }

  List permissions = [];

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    // double width = WidgetsBinding
    //         .instance.platformDispatcher.views.first.physicalSize.width /
    //     WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return PageScrollWrapper(
      child: GetBuilder<AccountController>(
        initState: (v) {
          permissions = Api().sp.read('all_permissions') ?? [];
          controller.getSubsdairyBank();
        },
        builder: (controller) {
          return controller.SubsdairyBankLoader.value == true
              ? SizedBox.shrink()
              : LayoutBuilder(builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth;

                  final double leftWidth = maxWidth * 0.61;
                  final double rightWidth = maxWidth * 0.37;

                  final double leftFieldWidth = leftWidth / 6.7;
                  final double rightFieldWidth = rightWidth / 4.6;

                  const double fieldHeight = 30.0;
                  final double dropDownHeight = maxWidth < 1300 ? 34.0 : 28.0;

                  final double checkboxSpacing = maxWidth < 1300 ? 10.0 : 40.0;
                  final double chargesSpacing = maxWidth < 1300 ? 8.0 : 40.0;

                  final bool isMobile = maxWidth < 600;
                  final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                        padding: const EdgeInsetsGeometry.all(8.0),
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
                                            // HEADER ROW
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                              color: DynamicColors.gryClr.withOpacity(0.5),
                                              child: Row(
                                                children: [
                                                  Text(AppText.account, style: titleDesign()),
                                                  const Spacer(),
                                                  controller.accountObjectData != null
                                                      ? Row(
                                                          children: [
                                                            Checkbox(
                                                                value: controller.postactiveDrivers.value,
                                                                onChanged: (v) {
                                                                  controller.postactiveDrivers.value = v!;
                                                                  controller.update();
                                                                }),
                                                            Text(
                                                              "CLOSED",
                                                              style: mozillaTextSemiBoldText(
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 14,
                                                                  color: DynamicColors.redClr),
                                                            )
                                                          ],
                                                        )
                                                      : SizedBox.shrink(),
                                                  Spacer(),
                                                  if (permissions.contains('read_account_web_login'))
                                                    _headerBtn(AppText.webLogin, () => WebLoginAlert.show()),
                                                  if (permissions.contains('read_account_department'))
                                                    _headerBtn(AppText.department, () => DepartmentAlert.show()),
                                                  if (permissions.contains('read_account_contact'))
                                                    _headerBtn(AppText.contact, () => ContactAlert.show()),
                                                  if (permissions.contains('read_account_order_number'))
                                                    _headerBtn(AppText.order, () => OrderAlert.show()),
                                                  if (permissions.contains('read_account_company_address'))
                                                    _headerBtn(AppText.companyAddress, () => CompanyAddressAlert.show(), width: 150),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsetsGeometry.all(8.0),
                                              child: Column(
                                                spacing: 12,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    spacing: maxWidth < 1300 ? 2 : 8,
                                                    children: [
                                                      Focus(
                                                        autofocus: true,
                                                        child: _buildTextField(
                                                          controller.accountNameController,
                                                          AppText.name,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                                            UpperCaseTextFormatter()
                                                          ]),
                                                      ),
                                                      _buildTextField(
                                                          controller.accountCodeController,
                                                          AppText.code,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [FilteringTextInputFormatter.digitsOnly
                                                          ]),
                                                      _buildTextField(
                                                          controller.accountEmailController,
                                                          AppText.email,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                                            UpperCaseTextFormatter()
                                                          ]),
                                                      _buildTextField(
                                                          controller.accountPasswordController,
                                                          AppText.password,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [UpperCaseTextFormatter()
                                                          ]),
                                                      _buildDropdown(
                                                          AppText.subsidiary,
                                                          "SELECT SUBSIDIARY",
                                                          MediaQuery.of(context).size.width < 1300
                                                              ? leftFieldWidth * 1.3
                                                              : leftFieldWidth * 1.1,
                                                          dropDownHeight,
                                                          controller.subsidairyBankModel?.subsidiariesList ?? [],
                                                          controller.subsidiaryStoreValue,
                                                          (val) {
                                                        controller.subsidiaryStoreValue = val;
                                                        controller.update();
                                                      },
                                                          (item) => item.name!.toUpperCase()),
                                                      _buildDropdown(
                                                          AppText.accountType,
                                                          "SELECT ACCOUNT",
                                                          MediaQuery.of(context).size.width < 1300
                                                              ? leftFieldWidth * 1.1
                                                              : leftFieldWidth * 0.95,
                                                          dropDownHeight,
                                                          ["Cash", "Account"],
                                                          controller.accountType,
                                                          (val) {
                                                        controller.accountType = val;
                                                        controller.update();
                                                      }, (item) => item),
                                                    ],
                                                  ),
                                                  Row(
                                                    spacing: 8,
                                                    children: [
                                                      _buildTextField(
                                                          controller.accountMobileController,
                                                          AppText.mobile,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [FilteringTextInputFormatter.digitsOnly
                                                          ]),
                                                      _buildTextField(
                                                          controller.accountTelController,
                                                          AppText.tel,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [FilteringTextInputFormatter.digitsOnly
                                                          ]),
                                                      _buildTextField(
                                                          controller.accountFaxController,
                                                          AppText.fax,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [UpperCaseTextFormatter()
                                                          ]),
                                                      _buildTextField(
                                                          controller.accountWebSiteController,
                                                          AppText.website,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [UpperCaseTextFormatter()
                                                          ]),
                                                      _buildTextField(
                                                          controller.accountNumberController,
                                                          AppText.accountNumber,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [FilteringTextInputFormatter.digitsOnly
                                                          ]),
                                                      _buildTextField(
                                                          controller.accountCreditCardController,
                                                          AppText.creditCard,
                                                          leftFieldWidth,
                                                          fieldHeight,
                                                          [FilteringTextInputFormatter.digitsOnly
                                                          ]),
                                                    ],
                                                  ),
                                                  Row(
                                                    spacing: 8,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      _buildTextField(
                                                          controller.accountAddressController,
                                                          AppText.address,
                                                          leftFieldWidth,
                                                          82,
                                                          [UpperCaseTextFormatter()],
                                                          maxLines: 6),
                                                      _buildTextField(
                                                          controller.accountInformationController,
                                                          AppText.information,
                                                          leftFieldWidth,
                                                          82,
                                                          [UpperCaseTextFormatter()
                                                          ],
                                                          maxLines: 6),
                                                      Column(
                                                        spacing: 12,
                                                        children: [
                                                          _buildDropdown(
                                                              AppText.paymentType,
                                                              "SELECT TYPE",
                                                              leftFieldWidth,
                                                              dropDownHeight,
                                                              ["Cash", "Account"],
                                                              ["Cash",
                                                                "Account"].contains(controller.paymentType)
                                                                  ? controller.paymentType : null, (val) {
                                                            controller.paymentType = val;
                                                            controller.update();
                                                          }, (item) => item),
                                                          // _buildTextField(bankAccountController, "BANK ACCOUNT", leftFieldWidth, fieldHeight, []),
                                                        ],
                                                      ),
                                                      Column(
                                                        spacing: 12,
                                                        children: [
                                                          _buildTextField(

                                                              controller.accountContactNameController,
                                                              AppText.contactName,
                                                              leftFieldWidth,
                                                              fieldHeight,
                                                              [UpperCaseTextFormatter()
                                                              ]),
                                                        ],
                                                      ),
                                                      Column(
                                                        spacing: 12,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(AppText.backgroundClr,
                                                                  style: mozillaTextSemiBoldText(context: context, fontSize: 11)),
                                                               SizedBox(
                                                                width: leftFieldWidth,
                                                                height: fieldHeight,
                                                                child: ColorPickerWidget(
                                                                    width: leftFieldWidth - 5,
                                                                    pickerColor: controller.pickerColor,
                                                                    onColorChanged: (Color newColor) {
                                                                      setState(() {
                                                                        controller.pickerColor = newColor;
                                                                      });
                                                                    },
                                                                  ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        spacing: 12,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(AppText.foregroundClr,
                                                                  style: mozillaTextSemiBoldText(context: context, fontSize: 11)),
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
                                                                    child: Container(
                                                                        color: controller.foregroundClr,
                                                                        height: 6,
                                                                        width: leftFieldWidth - 15),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              width: leftFieldWidth,
                                                              height: fieldHeight),
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
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      spacing: checkboxSpacing,
                                                      runSpacing: 6,
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      children: [
                                                        _buildCheckbox(
                                                            controller.orderCheckBox,
                                                            AppText.order),
                                                        _buildCheckbox(
                                                            controller.bookedByCheckBox,
                                                            AppText.bookedBy),
                                                        _buildCheckbox(
                                                            controller.escoptCheckBox,
                                                            AppText.escopt),
                                                        _buildCheckbox(
                                                            controller.fareControllerCheckBox,
                                                            AppText.fareController),
                                                        _buildCheckbox(
                                                            controller.bankInfoCheckBox,
                                                            AppText.bankInfo),
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
                                                      spacing: chargesSpacing,
                                                      runSpacing: 6,
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      children: [
                                                        _buildCheckbox(
                                                            controller.adminFeeCheckBox,
                                                            AppText.adminFee),
                                                        _buildCheckbox(
                                                            controller.accountFeeCheckBox,
                                                            AppText.accountFee),
                                                        _buildCheckbox(
                                                            controller.vatCheckBox,
                                                            AppText.vat),
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
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              color: DynamicColors.gryClr.withOpacity(0.5),
                                              child: Text(AppText.feeSection, style: titleDesign()),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                spacing: 8,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: _buildDropdown(
                                                        AppText.adminFeeType,
                                                        "SELECT TYPE",
                                                        double.infinity,
                                                        dropDownHeight,
                                                        ["PERCENTAGE", "AMOUNT"],
                                                        controller.adminFeesDropDown,
                                                        (val) {
                                                      controller.adminFeesDropDown = val;
                                                      controller.update();
                                                    }, (item) => item),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: _buildTextField(
                                                        controller.accountAdminFeeController,
                                                        AppText.adminFee,
                                                        double.infinity,
                                                        fieldHeight,
                                                        [FilteringTextInputFormatter.digitsOnly
                                                        ]),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: _buildDropdown(
                                                        AppText.accountFeeType,
                                                        "SELECT TYPE",
                                                        double.infinity,
                                                        dropDownHeight,
                                                        ["PERCENTAGE", "AMOUNT"],
                                                        controller.accountTypeDropDown,
                                                        (val) {
                                                      controller.accountTypeDropDown =
                                                          val;
                                                      controller.update();
                                                    }, (item) => item),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: _buildTextField(
                                                        controller.accountAccountFeeController,
                                                        AppText.accountFee,
                                                        double.infinity,
                                                        fieldHeight,
                                                        [FilteringTextInputFormatter.digitsOnly
                                                        ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                          ],
                                        ),
                                      ),

                                      // AGENT COMMISSION CONTAINER
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: DynamicColors.textClr),
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
                                                  _buildDropdown(
                                                      AppText.agentCommissionType,
                                                      "SELECT COMMISSION TYPE",
                                                      rightFieldWidth * 2,
                                                      dropDownHeight,
                                                      ["PERCENTAGE", "AMOUNT"],
                                                      controller.commissionDropDown,
                                                      (val) {
                                                    controller.commissionDropDown = val;
                                                    controller.update();
                                                  }, (item) => item),
                                                  SizedBox(width: 10),
                                                  _buildTextField(
                                                      controller.accountAgentCommissionController,
                                                      AppText.agentCommission,
                                                      rightFieldWidth * 1.5,
                                                      fieldHeight,
                                                      [
                                                        FilteringTextInputFormatter.digitsOnly,
                                                        LengthLimitingTextInputFormatter(6),
                                                      ]),
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
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              color: DynamicColors.gryClr.withOpacity(0.5),
                                              child: Text(AppText.smsControl, style: titleDesign()),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Wrap(
                                                spacing: checkboxSpacing,
                                                runSpacing: 6,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                  _buildCheckbox(
                                                      controller.dispatchSmsCheckBox,
                                                      AppText.dispatchSms),
                                                  _buildCheckbox(
                                                      controller.confirmSmsCheckBox,
                                                      AppText.confirmSms),
                                                  _buildCheckbox(
                                                      controller.arrivalSmsCheckBox,
                                                      AppText.arrivalSms),
                                                  _buildCheckbox(
                                                      controller.clearJobSmsCheckBox,
                                                      AppText.clearJobSms),
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
                                btnText: controller.accountObjectData != null
                                    ? "UPDATE"
                                    : AppText.save,
                                verticalPadding: 0.0,
                                fontSize: 13,
                                onTap: () {
                                  String email = controller.accountEmailController.text.trim();
                                  if (email.isEmpty) {
                                    BotToast.showText(text: "EMAIL IS REQUIRED");
                                  } else if (!email.contains('@')) {
                                    BotToast.showText(
                                        text: "INVALID EMAIL FORMAT");
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
      ),
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

  Widget _buildTextField(TextEditingController ctrl, String hint, double width,
      double height, List<TextInputFormatter> formatters, {int maxLines = 1}) {
    return CustomTextField(
      borderRadius: 4,
      controller: ctrl,
      width: width,
      hintText: hint,
      columnText: true,
      maxLines: maxLines,
      contentPadding: maxLines > 1
          ? const EdgeInsets.only(top: 15, left: 5)
          : const EdgeInsets.only(left: 5),
      height: height,
      inputFormatters: formatters,
    );
  }

  Widget _buildDropdown<T>(String title, String label, double width, double height, List<T> items, T? value,
      ValueChanged<T?> onChanged, String Function(T) itemLabel) {
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
              label, style: mozillaTextRegularText(fontSize: 10, color: DynamicColors.textClr),
            ),
          ],
        ));
  }

  void _showColorPickerDialog(
      BuildContext context, AccountController controller) {
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
