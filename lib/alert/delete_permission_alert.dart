import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/dashboard_view/Controller/dashboard_controller.dart';

class DeletePermissionAlert extends StatefulWidget {
  final Function deleteFunctionName;
  DeletePermissionAlert({super.key, required this.deleteFunctionName});
  @override
  State<DeletePermissionAlert> createState() => _DeletePermissionAlertState();
}

class _DeletePermissionAlertState extends State<DeletePermissionAlert> {
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 150,
        width: 150,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Are you sure to delete",
              style: mozillaTextRegularText(
                  fontSize: 20, color: DynamicColors.black),
            ),
            SizedBox(height: 60),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  verticalPadding: 0.0,
                  width: 70,
                  height: 40,
                  borderRadius: 4,
                  btnText: "Yes",
                  style: mozillaTextRegularText(
                      fontSize: 10, color: DynamicColors.whiteClr),
                  onTap: () {
                    widget.deleteFunctionName;
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 30),
                CustomButton(
                  verticalPadding: 0.0,
                  width: 70,
                  height: 40,
                  borderRadius: 4,
                  btnText: "No",
                  style: mozillaTextRegularText(
                      fontSize: 10, color: DynamicColors.whiteClr),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
