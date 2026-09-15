import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/escape_dismissible.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../component/text_widget.dart';
import '../component/time_duration_method.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class ExtraFaresAlert extends StatefulWidget {
  const ExtraFaresAlert({super.key, this.formController});

  /// Which booking form opened this dialog.
  ///
  /// Left null on the dashboard, where the bare `Get.find` below resolves the
  /// permanent controller exactly as it always did. The edit screen passes its
  /// own tagged instance in: a dialog is pushed on a route of its own, so it
  /// sits outside the [BookingFormScope] the rest of that screen is wrapped in
  /// and cannot look the controller up from context.
  final DashboardController? formController;

  @override
  State<ExtraFaresAlert> createState() => _ExtraFaresAlertState();
}

class _ExtraFaresAlertState extends State<ExtraFaresAlert> {
  /// The form that opened this dialog — the edit screen's private instance
  /// when it passed one, the dashboard's permanent controller otherwise.
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
    // Escape closes the alert. This one is opened with
    // `barrierDismissible: false`, which also switches OFF Flutter's built-in
    // Escape handling — see EscapeDismissible.
    return EscapeDismissible(
      child: Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GetBuilder<DashboardController>(
        // Follows whichever form opened the dialog.
        tag: dashBoardCntrl.formTag,
        builder: (controller) {
          return Container(
            height: 350,
            width: 650,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppText.extraFears,
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(999),
                      child: const AlertCloseButton(),
                    ),
                  ],
                ),

                Divider(),

                SizedBox(height: 15,),

                Row(
                  children: [
                    _buildFareField(label: "PARKING", controller: dashBoardCntrl.parkingChargesController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "CONGESTION", controller: dashBoardCntrl.congestionChargesController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "WAITING", controller: dashBoardCntrl.waitingChargesController),
                  ],
                ),

                SizedBox(height: 15),

                Row(
                  children: [
                    _buildFareField(label: "EXTRA DROP", controller: dashBoardCntrl.extraDropChargesController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "CREDIT CARD", controller: dashBoardCntrl.creditCardChargesController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "MEET & GREET ", controller: dashBoardCntrl.meetGreetController),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    _buildFareField(label: "COMPANY PRICE", controller: dashBoardCntrl.companyPriceController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "RETURN COMPANY PRICE", controller: dashBoardCntrl.returnCompanyPriceController),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text("Cancel",
                          style: TextStyle(
                              color: DynamicColors.whiteClr
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 90,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () async{
                          controller.getFaresCalculation();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DynamicColors.primaryClr,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text("Save",
                          style: TextStyle(
                              color: DynamicColors.whiteClr
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        }
      ),
      ),
    );
  }
  Widget _buildFareField({
    required String label,
    required TextEditingController controller,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF374151)),
          ),
          const SizedBox(height: 4),
          CustomTextField(
            hintText: "0.00",
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            borderRadius: 4,
            prefixIcon: Container(
              width: 22,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border(
                  left: BorderSide(color: DynamicColors.primaryClr),
                  right: BorderSide(color: DynamicColors.primaryClr),
                  top: BorderSide(color: DynamicColors.primaryClr),
                  bottom: BorderSide(color: DynamicColors.primaryClr),
                ),
              ),
              child: const Center(
                child: Text(
                  '£',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}