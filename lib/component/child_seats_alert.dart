



import 'package:dashboard_new1/component/restrict_drivers_alert.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/dashboard_view/Controller/dashboard_controller.dart';
import 'color.dart';

class ChildSeatsAlert extends StatefulWidget {
  const ChildSeatsAlert({super.key});

  @override
  State<ChildSeatsAlert> createState() => _ChildSeatsAlertState();
}

class _ChildSeatsAlertState extends State<ChildSeatsAlert> {

  List<String> driversList = [
    "25 GEORGE HAMPTON",
    "26 PAUL DOUBLEDAY",
    "27 RICHARD HARDWICK",
    "28 LANRE OKERJO",
    "29 NICOLAS GREY",
    "50 NADEEM",
    "60 EDWARD",
    "TEST TEST DRIVER",
    "X1 ANDRE",
    "SAVE [HOME]",
  ];

  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    dashBoardCntrl.shortCutKeyValue.value = "alert";
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 350,
        width: 450,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppText.childSeat,
                  style: mozillaTextSemiBoldText(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Icon(Icons.close,
                  color: DynamicColors.textClr,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  customKeyValue({key,value}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(key??AppText.vehicle,
          style: mozillaTextSemiBoldText(
              fontSize: 14,
              color: DynamicColors.textClr.withOpacity(0.7)
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(value??"vehicle Value",
            style: mozillaTextSemiBoldText(
                fontSize: 14,
                color: DynamicColors.textClr.withOpacity(0.7)
            ),
          ),
        ),
      ],
    );
  }
}
