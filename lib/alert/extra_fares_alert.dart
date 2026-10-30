import 'package:bot_toast/bot_toast.dart';
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

  /// Every field on this alert, in display order.
  List<TextEditingController> get _fields => [
        dashBoardCntrl.parkingChargesController,
        dashBoardCntrl.congestionChargesController,
        dashBoardCntrl.waitingChargesController,
        dashBoardCntrl.extraDropChargesController,
        dashBoardCntrl.creditCardChargesController,
        dashBoardCntrl.meetGreetController,
        dashBoardCntrl.companyPriceController,
        dashBoardCntrl.returnCompanyPriceController,
      ];

  /// True while CLEAR / SAVE is waiting on the fares call, so a second tap
  /// cannot fire it again.
  bool _busy = false;

  /// getFaresCalculation force-unwraps both of these.
  bool get _canCalculate =>
      dashBoardCntrl.selectJourneyTypeValue != null &&
      dashBoardCntrl.pickUpDate != null;

  /// Recalculates the fares, then closes the alert. Fares used to be
  /// recalculated on every keystroke in every field; now only CLEAR and SAVE
  /// do it, once.
  ///
  /// Closing pops the route this widget sits on: its own dialog when the edit
  /// screen opened it, the whole SettingsDialog when it is that dialog's tab.
  Future<void> _calculateAndClose() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (_canCalculate) await dashBoardCntrl.getFaresCalculation();
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        Navigator.of(context).pop();
      }
    }
  }

  /// Empties every field, recalculates without the charges, and closes.
  void _onClear() {
    for (final c in _fields) {
      c.clear();
    }
    _calculateAndClose();
  }

  /// Recalculates with the charges entered here, and closes. Stays open with a
  /// message when the fare cannot be calculated yet.
  void _onSave() {
    if (!_canCalculate) {
      BotToast.showText(text: "Please select journey type and pickup date first");
      return;
    }
    _calculateAndClose();
  }

  @override
  Widget build(BuildContext context) {
    // Escape closes the alert. This one is opened with
    // `barrierDismissible: false`, which also switches OFF Flutter's built-in
    // Escape handling — see EscapeDismissible.
    return GetBuilder<DashboardController>(
    // return EscapeDismissible(
    //   child: Dialog(
    //   insetPadding: EdgeInsets.all(20),
    //   backgroundColor: Colors.white,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   child: GetBuilder<DashboardController>(
        tag: dashBoardCntrl.formTag,
        builder: (controller) {
          return Container(
            // height: 350,
            // width: 650,
            // The dialog around it already pads by 16 — vertical padding here
            // only added empty space above the fields and under the buttons.
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // Hug the fields: the default (max) stretched this to whatever
              // height the dialog had, leaving the space below empty.
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(AppText.extraFears,
                //       style: mozillaTextSemiBoldText(
                //         fontWeight: FontWeight.w700,
                //         fontSize: 13,
                //       ),
                //     ),
                //     const Spacer(),
                //     FocusTraversalOrder(
                //       order: const NumericFocusOrder(999),
                //       child: const AlertCloseButton(),
                //     ),
                //   ],
                // ),

                // Divider(),
                //
                // SizedBox(height: 15,),

                Row(
                  children: [
                    _buildFareField(label: "PARKING", controller: dashBoardCntrl.parkingChargesController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "CONGESTION", controller: dashBoardCntrl.congestionChargesController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "WAITING", controller: dashBoardCntrl.waitingChargesController),
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  children: [
                    _buildFareField(label: "EXTRA DROP", controller: dashBoardCntrl.extraDropChargesController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "CREDIT CARD", controller: dashBoardCntrl.creditCardChargesController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "MEET & GREET ", controller: dashBoardCntrl.meetGreetController),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _buildFareField(label: "COMPANY PRICE", controller: dashBoardCntrl.companyPriceController),
                    const SizedBox(width: 8),
                    _buildFareField(label: "RETURN COMPANY PRICE", controller: dashBoardCntrl.returnCompanyPriceController),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      verticalPadding: 0.0,
                      width: 90,
                      height: 32,
                      borderRadius: 4,
                      btnText: "CLEAR",
                      btnColor: Colors.red,
                      style: mozillaTextRegularText(
                          fontSize: 11, color: DynamicColors.whiteClr),
                      onTap: _onClear,
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      verticalPadding: 0.0,
                      width: 90,
                      height: 32,
                      borderRadius: 4,
                      btnText: "SAVE",
                      style: mozillaTextRegularText(
                          fontSize: 11, color: DynamicColors.whiteClr),
                      onTap: _onSave,
                    ),
                  ],
                ),
                // Spacer(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     SizedBox(
                //       width: 90,
                //       height: 35,
                //       child: ElevatedButton(
                //         onPressed: () {
                //           Get.back();
                //         },
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.red,
                //           padding: EdgeInsets.zero,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(4),
                //           ),
                //         ),
                //         child: Text("Cancel",
                //           style: TextStyle(
                //               color: DynamicColors.whiteClr
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     SizedBox(
                //       width: 90,
                //       height: 35,
                //       child: ElevatedButton(
                //         onPressed: () async{
                //           controller.getFaresCalculation();
                //           Get.back();
                //         },
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: DynamicColors.primaryClr,
                //           padding: EdgeInsets.zero,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(4),
                //           ),
                //         ),
                //         child: Text("Save",
                //           style: TextStyle(
                //               color: DynamicColors.whiteClr
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
              ],
            ),
          );
        }
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
            style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF374151)),
          ),
          const SizedBox(height: 4),
          CustomTextField(
            hintText: "0.00",
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              LengthLimitingTextInputFormatter(20),
            ],
            borderRadius: 4,
            width: double.infinity,
            // Grey at rest, thick primary when Tab lands on it.
            idleBorderColor: Colors.grey.shade400,
            borderWidth: 2.5,
            prefixIcon: Container(
              width: 22,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                // Divider only: the field's own outline (grey at rest,
                // primary when focused) already frames the £ box.
                border: Border(
                  right: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              child: Center(
                child: Text(
                  '£',
                  style: outFitRegular(
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