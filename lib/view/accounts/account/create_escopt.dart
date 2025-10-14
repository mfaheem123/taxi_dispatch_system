


import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../controller/account_controller.dart';

class CreateEscopt extends StatefulWidget {
  const CreateEscopt({super.key});

  @override
  State<CreateEscopt> createState() => _CreateEscoptState();
}

class _CreateEscoptState extends State<CreateEscopt> {


  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "createEscopt";
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
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  child: Center(
                    child: Text(AppText.escopt, style: titleDesign()),
                  ),
                ),
                Container(
                width: fieldWidth,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: DynamicColors.gryClr)
                  ),
                    child: Text(AppText.uploadImage),
                ),
              ],
            );
          }
        );
      }
    );
  }
}
