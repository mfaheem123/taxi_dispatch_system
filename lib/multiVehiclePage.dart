import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'component/color.dart';
import 'component/dropdown_button.dart';
import 'component/textStyle.dart';
import 'component/text_widget.dart';



class MultiVehiclePage extends StatefulWidget {
   MultiVehiclePage({super.key});

  @override
  State<MultiVehiclePage> createState() => _MultiVehiclePageState();
}

class _MultiVehiclePageState extends State<MultiVehiclePage> {
  @override

  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
            ? maxWidth / 2
            : maxWidth / 4;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 50, horizontal: 80),
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: DynamicColors.whiteClr,
                      border: Border.all(
                        color: DynamicColors.secondaryClr,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: Get.width,
                          height: kToolbarHeight,
                          color: DynamicColors.secondaryClr,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text("Multi Reversation",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black
                                        )
                                    
                                    ),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Icon(
                                            Icons.cancel_presentation_sharp))
                                  ],
                                )),
                          )),
                      Row(
                        children: [
                      Column(
                        children: [
                          Text("Multi Vehicle",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black
                            ),

                          ),
                          CustomDropdownField<String>(
                            width: fieldWidth / 2,
                            label: "Select Car",
                            items: [
                              "SELECT DRIVER 1",
                              "SELECT DRIVER 2",
                              "SELECT DRIVER 3",
                              "SELECT DRIVER 4",
                              "SELECT DRIVER 5",
                            ],
                            value: controller.selectDriver,
                            itemLabel: (val) => val, // just show the string
                            onChanged: (val) {
                              controller.selectDriver = val!;
                              controller.update();
                            },
                          ),
                        ],
                      ),
                          Spacer(),
                          Column(
                            children: [
                              Text("Action",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black
                                ),

                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green
                                ),
                                child: Text("Add",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12
                                ),
                                ),
                              )
                            ],
                          ),

                        ],
                      )

                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      });
    });
  }
}