
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import '../../component/customButton.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../../routes/app_pages.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppText.login,
          style: headingText(
              fontWeight: FontWeight.w700),
        ),
            SizedBox(
              height: 40,
            ),
            CustomTextField(
              hintText: AppText.username,
              controller: TextEditingController(),),
            SizedBox(
              height: 30,
            ),
            CustomTextField(
              controller: TextEditingController(),
              hintText: AppText.password,
            ),
            SizedBox(
              height: 35,
            ),
            CustomButton(
              onTap: (){
                Get.offAllNamed(Routes.dashBoarScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
