



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../controller/controller.dart';

class CreateFixedFareSetting extends StatefulWidget {
  const CreateFixedFareSetting({super.key});

  @override
  State<CreateFixedFareSetting> createState() => _CreateFixedFareSettingState();
}

class _CreateFixedFareSettingState extends State<CreateFixedFareSetting> {

  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "createFixedFareSetting";
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
