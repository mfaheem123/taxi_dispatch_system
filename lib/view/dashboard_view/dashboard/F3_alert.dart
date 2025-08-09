


import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/calender.dart';
import '../../../component/keyboard_dropdown_widget.dart';
import '../../../component/textStyle.dart';
import 'booking_form_widget.dart';

class F3AlertWidget extends StatelessWidget {
  F3AlertWidget({super.key});

  List<String> list = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Elderberry",
    "Fig",
    "Grape"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: Get.height/2,
      width: Get.width/3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KeyboardDropdown(
            containerWidth: Get.width/6,
            initialValue: list.first,
            onChanged: (v){

            },
            items: list,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                        key: AppText.make,
                        value: "Blue"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                        key: AppText.clr,
                        value: "White"
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                        key: AppText.vehicleType,
                        value: "saloon"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                          key: AppText.model,
                          value: "2020"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                          key: AppText.mobileNo,
                          value: "+12313232"
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  customKeyValue({key,value}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(key??AppText.vehicle,
          style: mozillaTextSemiBoldText(
              fontSize: 14,
              color: DynamicColors.textClr.withOpacity(0.7)
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(value??"vehicle Value",
            style: mozillaTextSemiBoldText(
                fontSize: 14,
                color: DynamicColors.textClr.withOpacity(0.7)
            ),
          ),
        ),
      ],
    );
  }

}


class F4AlertWidget extends StatelessWidget {
  F4AlertWidget({super.key});

  List<String> list = [
    "SELECT DRIVER",
    "25 GEORGE HAMPTON",
    "26 PAUL DOUBLEDAY",
    "27 RICHARD HARDWICK",
    "28 LANRE OKERJO",
    "29 NICOLAS GREY",
    "50 NADEEM",
    "60 EDWARD",
    "TEST TEST DRIVER",
    "X1 ANDRE",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: Get.height/2,
      width: Get.width/3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(AppText.from),
                  SizedBox(
                      height: 45,
                      width: Get.width/10,
                      child: CalendarDropdown()),
                ],
              ),
              Column(
                children: [
                  Text(AppText.to),
                ],
              ),
              Column(
                children: [
                  Text(AppText.drivers),
                  KeyboardDropdown(
                    containerWidth: Get.width/10,
                    initialValue: list.first,
                    onChanged: (v){

                    },
                    items: list,
                  ),
                ],
              ),
            ],
          ),



          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                          key: AppText.make,
                          value: "Blue"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                          key: AppText.clr,
                          value: "White"
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                          key: AppText.vehicleType,
                          value: "saloon"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                          key: AppText.model,
                          value: "2020"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: customKeyValue(
                          key: AppText.mobileNo,
                          value: "+12313232"
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  customKeyValue({key,value}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(key??AppText.vehicle,
          style: mozillaTextSemiBoldText(
              fontSize: 14,
              color: DynamicColors.textClr.withOpacity(0.7)
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(value??"vehicle Value",
            style: mozillaTextSemiBoldText(
                fontSize: 14,
                color: DynamicColors.textClr.withOpacity(0.7)
            ),
          ),
        ),
      ],
    );
  }
}
