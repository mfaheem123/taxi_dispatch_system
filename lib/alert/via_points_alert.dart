import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/escape_dismissible.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../component/alert_close_button.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class ViaPointsAlert extends StatefulWidget {
  const ViaPointsAlert({super.key, this.formController});

  final DashboardController? formController;


  @override
  State<ViaPointsAlert> createState() => _ViaPointsAlertState();
}

class _ViaPointsAlertState extends State<ViaPointsAlert> {

  late final DashboardController dashBoardCntrl =
      widget.formController ?? Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  @override
  Widget build(BuildContext context) {
    return EscapeDismissible(
        child: Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: GetBuilder<DashboardController>(
            tag: dashBoardCntrl.formTag,
              builder: (controller) {

                final bool isReturnJourney = controller.jourValue == 'R/N';

              return Container(
                width: isReturnJourney ? 850 : 550,
                // child: Padding(padding: EdgeInsets.all(20),
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            color: DynamicColors.gryClr.withOpacity(0.5),

                          child: Row(
                            children: [
                              Icon(Icons.route, color: DynamicColors.primaryClr),
                              const SizedBox(width: 10),
                              Text("VIAPOINT(S) MANAGEMENT",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const Spacer(),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(999),
                                child: const AlertCloseButton(),
                              ),
                            ],
                          )),

                        const SizedBox(height: 16),

                        Flexible(child: SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                            ],
                          ),
                        ),

                        ),



                      ],
                ),
                // ),
              );

              }
          ),
        ));
  }
}
