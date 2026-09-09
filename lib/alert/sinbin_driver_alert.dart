import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../component/alert_close_button.dart';
import '../view/drivers_view/controller/driver_sin_bin_controller.dart';

class SinbinDriverAlert extends StatefulWidget {
  final dynamic driver;
  const SinbinDriverAlert({super.key, this.driver});

  @override
  State<SinbinDriverAlert> createState() => _SinbinDriverAlertState();
}

class _SinbinDriverAlertState extends State<SinbinDriverAlert> {
  DriverSinBinController controller = Get.isRegistered<DriverSinBinController>()
      ? Get.find<DriverSinBinController>()
      : Get.put(DriverSinBinController());

  final TextEditingController _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String driverName = "";
    if (widget.driver != null) {
      try {
        driverName = widget.driver.username?.toString() ?? "";
      } catch (_) {
        driverName = widget.driver.toString();
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 420,
        decoration: BoxDecoration(
          color: DynamicColors.whiteClr,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.person_off_sharp, color: DynamicColors.redClr, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "SINBIN DRIVER",
                    style: mozillaTextSemiBoldText(
                      context: context,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(999),
                    child: const AlertCloseButton(),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [

                  Container(
                    width: double.infinity,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: DynamicColors.gryClr.withOpacity(0.3)),
                    ),
                    child: Text(
                      driverName.isNotEmpty ? "$driverName -" : "-",
                      style: mozillaTextSemiBoldText(
                        context: context,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: buildNumberField(_durationController, "ENTER DURATION (MINUTES)"),
                      ),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_durationController.text.trim().isNotEmpty) {
                              var driverId = widget.driver?.id ?? widget.driver?.driverId;
                              controller.addDriverSinBin(driverId, _durationController.text.trim());
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.access_time_filled, size: 16, color: Colors.white),
                          label: Text(
                            "SINBIN",
                            style: mozillaTextSemiBoldText(
                              context: context,
                              fontSize: 13,
                              color: DynamicColors.whiteClr,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DynamicColors.redClr,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Number Field Widget
  Widget buildNumberField(TextEditingController textCtrl, String hintText) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            controller.updateValue(textCtrl, 1);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            controller.updateValue(textCtrl, -1);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: CustomTextField(
        borderRadius: 0,
        controller: textCtrl,
        hintText: hintText,
        columnText: false,
        height: 38,
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
        ],
        suffixIcon: FocusScope(
          canRequestFocus: false,
          skipTraversal: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                focusNode: FocusNode(canRequestFocus: false),
                onTap: () => controller.updateValue(textCtrl, 1),
                child: const Icon(Icons.arrow_drop_up, size: 15),
              ),
              InkWell(
                focusNode: FocusNode(canRequestFocus: false),
                onTap: () => controller.updateValue(textCtrl, -1),
                child: const Icon(Icons.arrow_drop_down, size: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}