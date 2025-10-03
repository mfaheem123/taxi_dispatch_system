import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';

class VehicelsScreen extends StatelessWidget {
  VehicelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(30),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 5),
          ),
          child: Row(
            children: [
              // ---------------- upload image-----------------------------------
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "UPLOAD\n IMAGE",
                      style: headingText(fontSize: 40),
                    ),
                  )
                ],
              ),
              //------------------------------------------end image
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppText.richard,
                          style: headingText(
                            color: DynamicColors.textClr,
                            fontSize: 25,
                            latterSpacing: 0,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          AppText.logout,
                          style: headingText(
                            color: DynamicColors.redClr,
                            fontSize: 25,
                            latterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppText.vehicleinfo,
                    style: mozillaTextRegularText(
                      color: DynamicColors.textClr,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(AppText.vehicle),
                        Column(
                          children: [
                            Text(AppText.startDate),
                            Text("27-05-25"),
                          ],
                        ),
                        Column(
                          children: [
                            Text(AppText.vehicleType),
                            Text("SALOON"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(AppText.make),
                        Column(
                          children: [
                            Text(AppText.model),
                            Text("COLOR"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppText.documents,
                    style: mozillaTextSemiBoldText(),
                  ),
                  Text(
                    AppText.expiry,
                    style: mozillaTextRegularText(fontSize: 15),
                  ),
                  Divider(
                    thickness: 15,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [Text("PHC DRiver"), Text("PHC DRiver")],
                        ),
                        Column(
                          children: [Text("PHC DRiver"), Text("PHC DRiver")],
                        ),
                        Column(
                          children: [Text("PHC DRiver"), Text("PHC DRiver")],
                        ),
                        Column(
                          children: [Text("PHC DRiver"), Text("PHC DRiver")],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
