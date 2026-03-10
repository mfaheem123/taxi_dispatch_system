


import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/drivers_view/driver/driver_app_features/pda_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../controller/driver_controller.dart';
import 'app_version_widget.dart';
import 'drivers_list_feature.dart';

class DriverAppFeatureScreen extends StatefulWidget {
  const DriverAppFeatureScreen({super.key});

  @override
  State<DriverAppFeatureScreen> createState() => _DriverAppFeatureScreenState();
}

class _DriverAppFeatureScreenState extends State<DriverAppFeatureScreen> {

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  Widget build(BuildContext context) {

    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;


    return GetBuilder<DriverController>(
      builder: (controller) {
        return Container(

          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        // height: 30,
                        child: RestrictedDrivers(
                          width: 200,
                          titleText: "SELECT DRIVER",
                          driversList: [
                            "25 GEORGE HAMPTON",
                            "26 PAUL DOUBLEDAY",
                            "27 RICHARD HARDWICK",
                            "28 LANRE OKERJO",
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 15,
                      ),

                      Text(AppText.currentVersion,
                        style: mozillaTextSemiBoldText(
                            fontSize: 16,
                            fontWeight: FontWeight.w800
                        ),
                      ),
                    ],
                  ),

                  Text(AppText.driverAppFeatures,
                    style: mozillaTextSemiBoldText(
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                    ),
                  ),

                  CustomButton(
                    height: 35,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    width: 170,
                    btnText: AppText.save,
                  )
                ],
              ),

              SizedBox(
                height: 10,
              ),

              width < 1920 ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DriversListFeature(),
                  SizedBox(
                    height: 10,
                  ),
                  AppVersionWidget(),
                  PdaDetailsWidget(),
                ],
              )
                  :

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DriversListFeature(),
                  AppVersionWidget(),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
