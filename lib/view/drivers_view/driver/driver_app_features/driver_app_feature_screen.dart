


import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/drivers_view/driver/driver_app_features/pda_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../component/dropdown_button.dart';
import '../../../../component/networks/api.dart';
import '../../../customer/model/restricDriver.dart';
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
  List permissions = [];

  @override
  Widget build(BuildContext context) {

    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: GetBuilder<DriverController>(
      initState: (state) {
        permissions = Api().sp.read('all_permissions') ?? [];
        controller.getAllDrivers();
      },
      builder: (controller) {
        if (controller.isDriversLoading || controller.allDriverData == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
                        // width: 200,
                        // height: 30,
                        child:    CustomDropdownField<DriverObject>(
                          label: "SELECT DRIVERS",
                          width: 320,
                          height: 35,
                          items: controller.allDriverData!.drivers!,
                          value: controller.allDriverData!.drivers!.contains(controller.selectDriverObject)
                              ? controller.selectDriverObject
                              : null,
                          itemLabel: (driver) =>
                          driver.name!,
                          onChanged: (val) {
                            controller.selectDriverObject = val;
                            controller.getDriversAppFuture(val!.id!);
                            controller.update();
                          },
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

                  if(permissions.contains('update_app_feature')) CustomButton(
                    onTap: () {
                      controller.saveDriverFeatures();
                    },
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
      })
    );
  }
}
