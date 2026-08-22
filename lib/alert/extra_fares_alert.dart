


import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/escape_dismissible.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../component/text_widget.dart';
import '../component/time_duration_method.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class ExtraFaresAlert extends StatefulWidget {
  const ExtraFaresAlert({super.key});

  @override
  State<ExtraFaresAlert> createState() => _ExtraFaresAlertState();
}

class _ExtraFaresAlertState extends State<ExtraFaresAlert> {

  final dashBoardCntrl = Get.find<DashboardController>();
  final FocusNode closeButtonFocusNode = FocusNode();

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
                    AnimatedBuilder(
                      animation: closeButtonFocusNode,
                      builder: (context, child) {
                        final isFocused = closeButtonFocusNode.hasFocus;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFocused ? DynamicColors.primaryClr : Colors.transparent,
                              width: 2,
                            ),
                            color: isFocused ? DynamicColors.primaryClr.withOpacity(0.15) : Colors.transparent,
                          ),
                          child: IconButton(
                            focusNode: closeButtonFocusNode,
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close, size: 22, color: Colors.grey),
                            splashRadius: 20,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                Divider(),

                SizedBox(
                  height: 15,
                ),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "PARKING CHARGES",
                        controller: dashBoardCntrl.parkingChargesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(
                              2),
                        ],
                        borderRadius: 0,
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomTextField(
                            borderRadius: 0,
                            hintText: "CONGESTION CHARGES",
                            controller: dashBoardCntrl.congestionChargesController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                            LengthLimitingTextInputFormatter(
                                2),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: CustomTextField(
                          borderRadius: 0,
                          hintText: "MEET & GREET",
                          controller: dashBoardCntrl.meetGreetController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(
                              2),
                        ],
                      ),
                    ),

                  ],
                ),

                SizedBox(
                  height: 15,
                ),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "WAITING CHARGES",
                        controller: dashBoardCntrl.waitingChargesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(
                              2),
                        ],
                        borderRadius: 0,
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomTextField(
                            borderRadius: 0,
                            hintText: "EXTRA DROP CHARGES",
                            controller: dashBoardCntrl.extraDropChargesController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                            LengthLimitingTextInputFormatter(
                                2),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: CustomTextField(
                          borderRadius: 0,
                          hintText: "CREDIT CARD CHARGES",
                          controller: dashBoardCntrl.creditCardChargesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(
                              2),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "COMPANY PRICE",
                        controller: dashBoardCntrl.companyPriceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(
                              2),
                        ],
                        borderRadius: 0,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomTextField(
                            borderRadius: 0,
                            hintText: "RETURN COMPANY PRICE",
                            controller: dashBoardCntrl.returnCompanyPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                            LengthLimitingTextInputFormatter(
                                2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 150,
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
                      width: 150,
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
}