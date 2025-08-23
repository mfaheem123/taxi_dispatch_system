


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../component/text_widget.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class ExtraInfoAlert extends StatefulWidget {
  const ExtraInfoAlert({super.key});

  @override
  State<ExtraInfoAlert> createState() => _ExtraInfoAlertState();
}

class _ExtraInfoAlertState extends State<ExtraInfoAlert> {

  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashBoardCntrl.shortCutKeyValue.value = "alert";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 475,
        width: 650,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppText.extraFears,
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
            // SizedBox(
            //   height: 15,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(AppText.specialRequirements,
                style: mozillaTextSemiBoldText(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            CustomTextField(
              maxLines: 3,
height: 50,
              hintText: AppText.specialRequirements,
              controller: dashBoardCntrl.companyPriceController,
              hintStyle: mozillaTextRegularText(
                fontSize: 10
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
              borderRadius: 4,
            ),
            Divider(),
            // SizedBox(
            //   height: 15,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(AppText.controllerNotes,
                style: mozillaTextSemiBoldText(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "ENTER YOUR NOTE HERE",
                    controller: dashBoardCntrl.controllerNoteController,
                    hintStyle: mozillaTextRegularText(
                        fontSize: 10
                    ),
                    borderRadius: 4,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomButton(
                    width: 50,
                    height: 30,
                    verticalPadding: 0.0,
                    borderRadius: 6,
                    style: mozillaTextSemiBoldText(
                        fontSize: 13,
                        color: DynamicColors.whiteClr),
           widget: Icon(Icons.add,
           size: 20,
             color: DynamicColors.whiteClr,
           ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                  itemCount: 15,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context,index){
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            alignment: Alignment.centerLeft,
                            child: Text("Jack"),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CustomButton(
                      width: 80,
                      height: 30,
                      verticalPadding: 0.0,
                      borderRadius: 6,
                      btnColor: DynamicColors.redClr,
                      style: mozillaTextSemiBoldText(
                          fontSize: 13,
                          color: DynamicColors.whiteClr),
                      btnText: AppText.cancel,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CustomButton(
                      width: 80,
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
            )
          ],
        ),
      ),
    );
  }
}


Widget deleteAndEditBtn() {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: CustomButton(
          width: 30,
          height: 25,
          verticalPadding: 0.0,
          borderRadius: 6,
          widget: Icon(Icons.edit_document,
            color: DynamicColors.whiteClr,
            size: 15,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: CustomButton(
          width: 30,
          height: 25,
          verticalPadding: 0.0,
          btnColor: DynamicColors.redClr,
          borderRadius: 6,
          widget: Icon(Icons.delete_forever,
            color: DynamicColors.whiteClr,
            size: 15,
          ),
        ),
      ),
    ],
  );
}