

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/vehicles_view/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/textStyle.dart';
import '../booking_view/reusable_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';

class VehicleTypes extends StatefulWidget {
  const VehicleTypes({super.key});

  @override
  State<VehicleTypes> createState() => _VehicleTypesState();
}

class _VehicleTypesState extends State<VehicleTypes> {

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

  VehicleController controller = Get.isRegistered<VehicleController>()
      ? Get.find<VehicleController>()
      : Get.put(VehicleController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "vehicleTypes";
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<VehicleController>(builder: (controller) {

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

          return Column(
            children: [
              Wrap(
                runSpacing: 16,
                spacing: 10,
                children: [
                  GestureDetector(
                    onTap: (){
                      if(controller.profileImg == null){
                        controller.pickImage();
                      }
                    },
                    child: Container(
                      height: isMobile ? 200 : 400,
                      width: fieldWidth,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        image:  controller.profileImg == null ? null : DecorationImage(
                          image: MemoryImage(controller.profileImg!.bytes), // ✅ correct provider
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: controller.profileImg != null? Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: (){
                            controller.profileImg = null;
                            controller.update();
                          },
                          child: Icon(Icons.close_rounded,
                            color: DynamicColors.redClr,
                          ),
                        ),
                      ): Center(
                        child: Text(
                          "UPLOAD IMAGE",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth*2.7,
                    child: Column(
                      children: [
                        Container(
                          // height: screenHeight / 20,
                          width: Get.width,
                          color: Colors.grey.withOpacity(0.3),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                            child: Text(
                              AppText.vehicleType,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Wrap(
                          children: [
                            customWidget(
                              value: controller.defaultVehicleValue.value,
                              onChanged: (v){
                                controller.defaultVehicleValue.value = v!;
                                controller.update();
                              },
                              text: AppText.defaultVehicle,
                              width: 140,
                            ),
                            customWidget(
                              value: controller.minimumMilesValue.value,
                              onChanged: (v){
                                controller.minimumMilesValue.value = v!;
                                controller.update();
                              },
                              text: AppText.minimumMiles,
                              width: 140,
                            ),

                          ],
                        ),
                        Wrap(
                          children: [

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      );
      }
    );
  }
}
