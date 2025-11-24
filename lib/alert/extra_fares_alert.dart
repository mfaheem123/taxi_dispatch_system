


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../component/text_widget.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class ExtraFaresAlert extends StatefulWidget {
  const ExtraFaresAlert({super.key});

  @override
  State<ExtraFaresAlert> createState() => _ExtraFaresAlertState();
}

class _ExtraFaresAlertState extends State<ExtraFaresAlert> {
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(Icons.close,
                        color: DynamicColors.textClr,
                      ),
                    )
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
                        controller: dashBoardCntrl.partingChargesController,
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
              ],
            ),
          );
        }
      ),
    );
  }
}