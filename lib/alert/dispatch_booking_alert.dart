import 'package:dashboard_new1/alert/restrict_drivers_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../component/text_widget.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class DispatchBookingAlert extends StatefulWidget {
  const DispatchBookingAlert({super.key});
  @override
  State<DispatchBookingAlert> createState() => _DispatchBookingAlertState();
}
class _DispatchBookingAlertState extends State<DispatchBookingAlert> {
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  List<String> sendEmailRoleList = [
    "DRIVER",
    "CUSTOMER",
    "ACCOUNT",
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 350,
        width: 650,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppText.dispatchBooking,
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

            Container(
              decoration: BoxDecoration(
                  color: DynamicColors.gryClr.withOpacity(0.4)
              ),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(AppText.id,
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 115,
                    child: Text(AppText.name,
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 115,
                    child: Text(AppText.subsidiary,
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 115,
                    child: Text(AppText.status,
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 115,
                    child: Text(AppText.distance,
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 80,
                    child: Text(""
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 220,
              child: ListView.builder(
                  itemCount: 150,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context,index){
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text("29",
                            style: mozillaTextRegularText(
                              fontSize: 11,
                            ),
                          ), 
                        ),

                        SizedBox(
                          width: 115,
                          child: Text("NICOLAS GREY",
                            style: mozillaTextRegularText(
                              fontSize: 11,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 115,
                          child: Text("DEMO COMPANY",
                            style: mozillaTextRegularText(
                              fontSize: 11,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 115,
                          child: Text("AVAILABLE",
                            style: mozillaTextRegularText(
                              fontSize: 11,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 115,
                          child: Text("3435.08 MI",
                            style: mozillaTextRegularText(
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomButton(
                              width: 70,
                              height: 25,
                              verticalPadding: 0.0,
                              borderRadius: 4,
                              btnText: AppText.dispatch,
                              style: mozillaTextSemiBoldText(
                              fontSize: 13,
                              color: DynamicColors.whiteClr
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider()
                  ],
                );
              }),
            ),

          ],
        ),
      ),
    );
  }
}
