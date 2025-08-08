



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../Controller/dashboard_controller.dart';
import '../widgets/via_location.dart';

class FormShortCutKey extends StatelessWidget {
  FormShortCutKey({super.key});
  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding:
      EdgeInsets.symmetric(vertical: 6,horizontal: 6),
      decoration: BoxDecoration(
        color: DynamicColors.primaryClr,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
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
    );
  }
}
