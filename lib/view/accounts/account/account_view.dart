
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/account_controller.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

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

            return Wrap(
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
                                CustomButton(
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
                                CustomButton(
                                  verticalPadding: 0.0,
                                  width: 60,
                                  height: 30,
                                  borderRadius: 4,
                                  btnText: "ORDER #",
                                  style: mozillaTextRegularText(
                                    fontSize: 10,
                                    color: DynamicColors.whiteClr
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
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    child: Text(AppText.feeSection, style: titleDesign()),
                  ),
                ),
              ],
            );
          }
        );
      }
    );
  }
}
