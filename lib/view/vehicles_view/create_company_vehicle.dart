



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
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
                const Placeholder(),
              ],
            );
          }
        );
      }
    );
  }
}
