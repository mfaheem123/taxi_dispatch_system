


import 'package:dashboard_new1/component/customButton.dart';
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
                          final storedTemFare = await getFares(
                            multiReservationList: controller.multiReservationList,
                            // day: ,
                              dropOff: controller.pickupController.text,
                              pickup: controller.dropOffController.text,
                              miles: controller.totalDistance.value,
                              journeyTypeId: controller.selectJourneyTypeValue!.id,
                              dropoffPlotId: controller.dashboardZoneValue != null? controller.dashboardZoneValue!.id:null,
                              pickupDate: "${controller.pickUpDate!.year}-${controller.pickUpDate!.month}-${controller.pickUpDate!.day}",
                              pickupTime: controller.pickUpTimeController.text,
                              vehicleTypeId: controller.selectVehicleValue!.id,
                              partingCharges: dashBoardCntrl.partingChargesController.text,
                              congestionCharges: dashBoardCntrl.congestionChargesController.text,
                              meetGreet: dashBoardCntrl.meetGreetController.text,
                              waitingCharges: dashBoardCntrl.waitingChargesController.text,
                              extraDropCharges: dashBoardCntrl.extraDropChargesController.text,
                              creditCardCharges: dashBoardCntrl.creditCardChargesController.text,
                              companyPrice: dashBoardCntrl.companyPriceController.text,
                              returnCompanyPrice: dashBoardCntrl.returnCompanyPriceController.text
                          );

                          controller.fixedFare.value = storedTemFare;
                          controller.update();
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
    );
  }
}