import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../controller/driver_controller.dart';

class UpdateDriverCommissionScreen extends StatefulWidget {
  const UpdateDriverCommissionScreen({super.key});

  @override
  State<UpdateDriverCommissionScreen> createState() =>
      _UpdateDriverCommissionScreenState();
}

class _UpdateDriverCommissionScreenState
    extends State<UpdateDriverCommissionScreen> {
  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "UpdateDriverCommissionScreen";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return const Placeholder();
  }
}
