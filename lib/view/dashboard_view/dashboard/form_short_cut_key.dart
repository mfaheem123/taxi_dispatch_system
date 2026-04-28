



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../Controller/dashboard_controller.dart';
import '../models/dashboard_model.dart';
import '../widgets/via_location.dart';
import 'F8_widget_alert.dart';
import 'F9_widget_alert.dart';

class FormShortCutKey extends StatelessWidget {
  FormShortCutKey({super.key});
  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Container(
          width: Get.width,
          padding:
          EdgeInsets.symmetric(vertical: 6,horizontal: 6),
          decoration: BoxDecoration(
            color: DynamicColors.primaryClr,
            borderRadius: BorderRadius.circular(5),
          ),
          child:
          Wrap(
            spacing: 10, // horizontal gap
            runSpacing: 8, // vertical gap when wrapped
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(AppText.booking,
                        style: mozillaTextSemiBoldText(
                            context: context,
                            fontSize: 14,
                            color: DynamicColors.whiteClr
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [

                      GestureDetector(
                        onTap: (){
                          if(controller.pickupController.text.isNotEmpty && controller.dropOffController.text.isNotEmpty){
                            DashboardF8Alert.show();
                          }
                        },
                        child: Container(
                          // margin: EdgeInsets.symmetric(
                          //     horizontal: 16, vertical: 3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: dashboardController.isHoveredF8.value == true? Colors.cyanAccent.shade400:Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: Text(
                            '+ MULTI RESERVATION [F8]',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width/130,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          if(controller.pickupController.text.isNotEmpty && controller.dropOffController.text.isNotEmpty)
                          {
                            DashboardF9Alert.show();
                          }
                        },
                        child: Container(
                                // margin: EdgeInsets.symmetric(
                                //     horizontal: 16, vertical: 3),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: dashboardController.isHoveredF9.value == true? Colors.cyanAccent.shade400:Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '+ VEHICLES [F9]',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: MediaQuery.of(context).size.width/130,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),

                      // Obx(
                      //       ()=> MouseRegion(
                      //     onEnter: (_) {
                      //       dashboardController.isHovered = true.obs;
                      //     },
                      //     onExit: (_) {
                      //       dashboardController.isHovered = false.obs;
                      //     },
                      //     child: Container(
                      //       // margin: EdgeInsets.symmetric(
                      //       //     horizontal: 16, vertical: 3),
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 8, vertical: 3),
                      //       decoration: BoxDecoration(
                      //         color: dashboardController.isHovered.value == true? Colors.cyanAccent.shade400:Colors.transparent,
                      //         borderRadius:
                      //         BorderRadius.circular(10),
                      //       ),
                      //       child: Text(
                      //         'MULTI RESERVATION',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 13,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Obx(
                            ()=> MouseRegion(
                          onEnter: (_) {
                            // dashboardController.isHoveredVLA = true.obs;
                          },
                          onExit: (_) {
                            // dashboardController.isHoveredVLA = false.obs;
                          },
                          opaque: true,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      ViaLocation());
                            },
                            child: Container(
                              // margin: EdgeInsets.symmetric(
                              //     horizontal: 16, vertical: 3),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: dashboardController.isHoveredVLA.value == true? Colors.cyanAccent.shade400:Colors.transparent,
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: Text(
                                'VIA (${dashboardController.viaPoints.length})',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width/130,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'SUB',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width/130,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 200,
                        height: 35,
                        child: DropdownButtonFormField<DashboardSubsidiaryObject>(
                          isExpanded: true, // Use true here so text reaches the icon and then clips
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            filled: true,
                            fillColor: DynamicColors.whiteClr,
                            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          ),
                          icon: const Icon(Icons.arrow_drop_down, size: 20),
                          padding: EdgeInsets.zero,
                          value: controller.selectSubsidiariesValue,
                          items: controller.dashboardAllData!
                              .subsidiaries!
                              .map((subsidiaries) =>
                              DropdownMenuItem<DashboardSubsidiaryObject>(
                                value: subsidiaries,
                                child: Text(subsidiaries.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: mozillaTextRegularText(
                                    fontSize: 12,
                                    color: DynamicColors.textClr,
                                  ),
                                ),
                              ))
                              .toList(),
                          onChanged: (v) {
                            controller.selectSubsidiariesValue = v;
                            controller.getAccountData(subsidiariesId: controller.selectSubsidiariesValue!.id);
                          },
                        ),
                      ),
                    ],
                  )

                ],
              )
            ]),
         /* SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppText.booking,
                  style: mozillaTextSemiBoldText(
                      context: context,
                      fontSize: 14,
                      color: DynamicColors.whiteClr
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                          ()=> MouseRegion(
                        onEnter: (_) {
                          dashboardController.isHoveredF8 = true.obs;
                        },
                        onExit: (_) {
                          dashboardController.isHoveredF8 = false.obs;
                        },
                        child: Container(
                          // margin: EdgeInsets.symmetric(
                          //     horizontal: 16, vertical: 3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: dashboardController.isHoveredF8.value == true? Colors.cyanAccent.shade400:Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: Text(
                            '+ BOOKING [F8]',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                          ()=> MouseRegion(
                        onEnter: (_) {
                          dashboardController.isHoveredF9 = true.obs;
                        },
                        onExit: (_) {
                          dashboardController.isHoveredF9 = false.obs;
                        },
                        child: Container(
                          // margin: EdgeInsets.symmetric(
                          //     horizontal: 16, vertical: 3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: dashboardController.isHoveredF9.value == true? Colors.cyanAccent.shade400:Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: Text(
                            '+ VEHICLES [F9]',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                          ()=> MouseRegion(
                        onEnter: (_) {
                          dashboardController.isHovered = true.obs;
                        },
                        onExit: (_) {
                          dashboardController.isHovered = false.obs;
                        },
                        child: Container(
                          // margin: EdgeInsets.symmetric(
                          //     horizontal: 16, vertical: 3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: dashboardController.isHovered.value == true? Colors.cyanAccent.shade400:Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: Text(
                            'MULTI RESERVATION',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                          ()=> MouseRegion(
                        onEnter: (_) {
                          dashboardController.isHoveredVLA = true.obs;
                        },
                        onExit: (_) {
                          dashboardController.isHoveredVLA = false.obs;
                        },
                        opaque: true,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    ViaLocation());
                          },
                          child: Container(
                            // margin: EdgeInsets.symmetric(
                            //     horizontal: 16, vertical: 3),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: dashboardController.isHoveredVLA.value == true? Colors.cyanAccent.shade400:Colors.transparent,
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Text(
                              'VLA (0)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'SUB',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),*/
        );
      }
    );
  }
}
