



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'controller.dart';

class CreateCompanyVehicle extends StatefulWidget {
  const CreateCompanyVehicle({super.key});

  @override
  State<CreateCompanyVehicle> createState() => _CreateCompanyVehicleState();
}

class _CreateCompanyVehicleState extends State<CreateCompanyVehicle> {

  VehicleController controller = Get.isRegistered<VehicleController>()
      ? Get.find<VehicleController>()
      : Get.put(VehicleController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "createCompanyVehicle";
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  // height: screenHeight / 20,
                  width: Get.width,
                  color: Colors.grey.withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                    child: Text(AppText.companyVehicle,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
        Wrap(
        runSpacing: 16,
        spacing: 10,
          children: [
            CustomTextField(
              borderRadius: 4,
              controller: controller.vehicleTypeController,
              width: fieldWidth,
              hintText: AppText.vehicleType,
              columnText: true,
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.vehicleType, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                RestrictedDrivers(
                  width: fieldWidth/1.5,
                  // height: 35,
                  padding: 0.0,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  titleText: "ESTAT",
                  driversList: [
                    "25 GEORGE HAMPTON",
                    "26 PAUL DOUBLEDAY",
                    "27 RICHARD HARDWICK",
                    "28 LANRE OKERJO",
                  ],
                ),
              ],
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.colorController,
              width: fieldWidth,
              hintText: AppText.color,
              columnText: true,
              height: 30,
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.vehicleMakeController,
              width: fieldWidth,
              hintText: AppText.make,
              columnText: true,
              height: 30,
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.vehicleModelController,
              width: fieldWidth,
              hintText: AppText.model,
              columnText: true,
              height: 30,
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.logBookingDocController,
              width: fieldWidth,
              hintText: AppText.logBookingDoc,
              columnText: true,
              height: 30,
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.phcVehicleExpire,
              column: true,
              width: fieldWidth,
              child: SizedBox(height: 30, child: KeyboardDatePicker()),
            ),

            CustomTextField(
              borderRadius: 4,
              controller: controller.phcVehicleNumberController,
              width: fieldWidth,
              hintText: AppText.phcVehicleNumber,
              columnText: true,
              height: 30,
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
