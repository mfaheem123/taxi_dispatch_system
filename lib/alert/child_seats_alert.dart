



import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../component/color.dart';
import 'extra_info_alert.dart';

class ChildSeatsAlert extends StatefulWidget {
  const ChildSeatsAlert({super.key});

  @override
  State<ChildSeatsAlert> createState() => _ChildSeatsAlertState();
}

class _ChildSeatsAlertState extends State<ChildSeatsAlert> {


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
                Text(AppText.childSeat,
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
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.4)
              ),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppText.noOfChildren,
                    style: mozillaTextSemiBoldText(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(AppText.age,
                    style: mozillaTextSemiBoldText(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(AppText.actions,
                    style: mozillaTextSemiBoldText(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      hintText: "NO OF CHILDREN",
                      controller: dashBoardCntrl.noOfChildren,
                    borderRadius: 0,
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                      borderRadius: 0,

                      hintText: "AGE",
                      controller: dashBoardCntrl.childAge
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
                    btnText: "SAVE",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: 15,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context,index){
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            alignment: Alignment.centerLeft,
                            child: Text("15"),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 45,
                            alignment: Alignment.centerLeft,
                            child: Text("15"),
                          ),
                        ),
                        deleteAndEditBtn()
                      ],
                    ),
                    Divider(
                      height: 10,
                    )
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
