


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../component/text_widget.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import 'child_seats_alert.dart';

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
    shortCutKeyValue.value = "alert";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GetBuilder<DashboardController>(
        builder: (controller) {
          return Container(
            height: 475,
            width: 650,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // AppText.extraFears,
                        "ADDITIONAL BOOKING INFO",
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IntrinsicWidth(
                        child: SizedBox(
                          width: controller.jourValue == 'W/R'? 295: 600.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(AppText.specialRequirements,
                                  style: mozillaTextSemiBoldText(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              CustomTextField(
                                maxLines: 3,
                                height: 50,
                                hintText: AppText.specialRequirements,
                                controller: dashBoardCntrl.specialRequirementsController,
                                hintStyle: mozillaTextRegularText(
                                  fontSize: 10
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                                borderRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.jourValue == 'W/R'?true:false,
                        child: SizedBox(
                          width: 295,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Text('RETURN SPECIAL REQUIREMENTS',
                                  style: mozillaTextSemiBoldText(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              CustomTextField(
                                maxLines: 3,
                                height: 50,
                                hintText: 'RETURN SPECIAL REQUIREMENTS',
                                controller: dashBoardCntrl.specialRequirementsReturnController,
                                hintStyle: mozillaTextRegularText(
                                  fontSize: 10
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                                borderRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Divider(),

                  // SizedBox(
                  //   height: 15,
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: controller.jourValue == 'W/R'? 295: 600.0,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(AppText.controllerNotes,
                                  style: mozillaTextSemiBoldText(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 6),
                                  child: CustomButton(
                                    width: 30,
                                    height: 30,
                                    onTap: (){
                                      if(controller.controllerNoteController.text.isNotEmpty){
                                        controller.controllerAlert.add(
                                          NoteClass(
                                              note: controller.controllerNoteController.text,
                                              title: 'controller note'
                                          ),
                                        );
                                        controller.controllerNoteController.clear();
                                        controller.update();
                                      }
                                    },
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
                            CustomTextField(
                              contentPadding: EdgeInsets.only(left: 12.0),
                              width: controller.jourValue == 'W/R'? 290: 600.0,
                              hintText: "ENTER YOUR NOTE HERE",
                              controller: controller.controllerNoteController,
                              hintStyle: mozillaTextRegularText(
                                  fontSize: 10
                              ),
                              borderRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.jourValue == 'W/R' ? true : false,
                        child: SizedBox(
                          width: controller.jourValue == 'W/R'? 295: 600.0,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('CONTROLLER RETURN NOTES',
                                    style: mozillaTextSemiBoldText(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, bottom: 6),
                                    child: CustomButton(
                                      width: 30,
                                      height: 30,
                                      btnColor: DynamicColors.greenClr,
                                      onTap: (){
                                        if(controller.controllerNoteReturnController.text.isNotEmpty){
                                          controller.controllerAlert.add(NoteClass(
                                            note: controller.controllerNoteReturnController.text,
                                            title: 'controller return note'
                                          ));
                                          controller.controllerNoteReturnController.clear();
                                          controller.update();
                                        }
                                      },
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
                              CustomTextField(
                                width: 290,
                                contentPadding: EdgeInsets.only(left: 12),
                                hintText: "ENTER YOUR RETURN NOTES HERE",
                                controller: controller.controllerNoteReturnController,
                                hintStyle: mozillaTextRegularText(
                                    fontSize: 10
                                ),
                                borderRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        itemCount: controller.controllerAlert.length,
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
                                  child: Text(controller.controllerAlert[index].note!),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: CustomButton(
                                      onTap: (){
                                        controller.controllerNoteController.text = controller.controllerAlert[index].note!;
                                        controller.update();
                                      },
                                      width: 30,
                                      height: 25,
                                      verticalPadding: 0.0,
                                      borderRadius: 6,
                                      btnColor: controller.controllerAlert[index].title == "controller return note"?DynamicColors.greenClr:
                                      DynamicColors.primaryClr,
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
                                      onTap: () {
                                        controller.controllerAlert.remove(controller.controllerAlert[index]);
                                        controller.update();
                                      },
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
                              )
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
                            onTap: (){
                              Get.back();
                            },
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
                            onTap: (){
                              Get.back();
                            },
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
      ),
    );
  }
}
