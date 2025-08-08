


import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/keyboard_dropdown_widget.dart';
import '../../../component/textStyle.dart';

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


void showAnimatedF3Alert(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black54, // background overlay color
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return const SizedBox(); // Required but unused
    },
    transitionBuilder: (context, animation1, animation2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation1, curve: Curves.easeOutBack),
        child: FadeTransition(
          opacity: animation1,
          child: Container(
            width: Get.width/2,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppText.driverInfo),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              content: const Text("Driver details go here..."), // Replace with F3AlertWidget content
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action here
                    Navigator.of(context).pop();
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}