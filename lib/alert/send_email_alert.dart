


import 'package:dashboard_new1/alert/restrict_drivers_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../component/text_widget.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class SendEmailAlert extends StatefulWidget {
  const SendEmailAlert({super.key});

  @override
  State<SendEmailAlert> createState() => _SendEmailAlertState();
}

class _SendEmailAlertState extends State<SendEmailAlert> {
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  List<String> sendEmailRoleList = [
    "DRIVER",
    "CUSTOMER",
    "ACCOUNT",
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 350,
        width: 650,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppText.sendEmail,
                  style: mozillaTextSemiBoldText(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.close,
                    color: DynamicColors.textClr,
                  ),
                )
              ],
            ),
            Divider(),
            CustomTextField(
              hintText: "",
              controller: dashBoardCntrl.sendEmailController,
              borderRadius: 0,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: CustomTextField(
                    hintText: AppText.emailTo,
                    controller: dashBoardCntrl.emailToController,
                    borderRadius: 0,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: CustomTextField(
                        borderRadius: 0,
                        hintText: AppText.nameOrMobil,
                        controller: dashBoardCntrl.mobileNoController
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: RestrictedDrivers(
                    driversList: sendEmailRoleList,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomButton(
                    width: 60,
                    height: 30,
                    verticalPadding: 0.0,
                    borderRadius: 6,
                    style: mozillaTextSemiBoldText(
                        fontSize: 13,
                        color: DynamicColors.whiteClr),
                    btnText: AppText.save,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomTextField(
                  borderRadius: 0,
                  hintText: AppText.subject,
                  controller: dashBoardCntrl.subjectController
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomTextField(
                  borderRadius: 0,
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 6),
                  maxLines: 6,
                  height: 100,
                  hintText: AppText.typeYourEmail,
                  controller: dashBoardCntrl.typeEmailController
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CustomButton(
                // width: 80,
                height: 30,
                verticalPadding: 0.0,
                borderRadius: 6,
                style: mozillaTextSemiBoldText(
                    fontSize: 13,
                    color: DynamicColors.whiteClr),
                btnText: AppText.sendEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class SendMessageAlert extends StatefulWidget {
  const SendMessageAlert({super.key});

  @override
  State<SendMessageAlert> createState() => _SendMessageAlertState();
}

class _SendMessageAlertState extends State<SendMessageAlert> {
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  List<String> sendEmailRoleList = [
    "DRIVER",
    "CUSTOMER",
    "ACCOUNT",
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 350,
        width: 650,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppText.sendMessage,
                  style: mozillaTextSemiBoldText(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.close,
                    color: DynamicColors.textClr,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: CustomTextField(
                        borderRadius: 0,
                        hintText: AppText.usernameMobile,
                        controller: dashBoardCntrl.mobileNoController
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    height: 30,
                    child: RestrictedDrivers(
                      driversList: sendEmailRoleList,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomButton(
                    width: 60,
                    height: 30,
                    verticalPadding: 0.0,
                    borderRadius: 6,
                    style: mozillaTextSemiBoldText(
                        fontSize: 13,
                        color: DynamicColors.whiteClr),
                    btnText: AppText.pick,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomTextField(
                  borderRadius: 0,
                  hintText: AppText.smsTo,
                  controller: dashBoardCntrl.smsToController
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomTextField(
                  borderRadius: 0,
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 6),
                  maxLines: 6,
                  height: 100,
                  hintText: AppText.typeYourMessage,
                  controller: dashBoardCntrl.typeYourMessageController
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CustomButton(
                // width: 80,
                height: 30,
                verticalPadding: 0.0,
                borderRadius: 6,
                style: mozillaTextSemiBoldText(
                    fontSize: 13,
                    color: DynamicColors.whiteClr),
                btnText: AppText.send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
