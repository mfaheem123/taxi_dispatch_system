


import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../alert/restrict_drivers_alert.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';

class VehicleInformation extends StatelessWidget {
  VehicleInformation({super.key});

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverController>(
        builder: (controller) {
          return LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 600;
                final bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

                final double fieldWidth = isMobile
                    ? constraints.maxWidth * 0.9
                    : isTablet
                    ? 175
                    : 150;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  margin: EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            AppText.vehicleInformation,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Divider(height: 1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: controller.vehicleInformation.value,
                                onChanged: (val) {
                                  controller.vehicleInformation.value = val!;
                                  controller.update();
                                },
                              ),
                              Text(AppText.usedCompanyVehicle),
                            ],
                          ),
                          SizedBox(
                            width: 200,
                            // height: 30,
                            child: RestrictedDrivers(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey, // border color
                                  width: 2.0,        // border thickness
                                ),
                              ),
                              driversList: ['Demo Company', "Other Company"],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SingleChildScrollView(
                        scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                        child: Flex(
                          direction: isMobile ? Axis.vertical : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(12),
                              child: labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: AppText.startDate,
                                  width: fieldWidth,
                                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                                  column: true
                              ),
                            ),
                             const SizedBox(width: 12),
                            FocusTraversalOrder(
                              order: const NumericFocusOrder(13),
                              child: labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: AppText.endDate,
                                  width: fieldWidth,
                                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                                  column: true
                              ),
                            ),
                             const SizedBox(width: 12),
                            FocusTraversalOrder(
                              order: NumericFocusOrder(14),
                              child: labeledTextField(context, isMobile, AppText.vehicle, controller.vehicleNameController,
                                  width: fieldWidth,
                                  textInputAction: TextInputAction.next,
                                  column: true
                              ),
                            ),
                             const SizedBox(width: 12),
                            FocusTraversalOrder(
                              order: NumericFocusOrder(15),
                              child: labeledTextField(context, isMobile, AppText.make, controller.vehicleMakeController,
                                  width: fieldWidth,
                                  textInputAction: TextInputAction.next,
                                  column: true
                              ),
                            ),
                            // _gap(isMobile),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                        child: Flex(
                          direction: isMobile ? Axis.vertical : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FocusTraversalOrder(
                              order: NumericFocusOrder(16),
                              child: labeledTextField(context, isMobile, AppText.model, controller.vehicleModelController,
                                  width: fieldWidth,
                                  textInputAction: TextInputAction.next,
                                  column: true
                              ),
                            ),
                            const SizedBox(width: 12),
                            FocusTraversalOrder(
                              order: NumericFocusOrder(17),
                              child: labeledTextField(context, isMobile, AppText.color, controller.vehicleColorController,
                                  width: fieldWidth,
                                  textInputAction: TextInputAction.next,
                                  column: true
                              ),
                            ),
                            const SizedBox(width: 12),
                            FocusTraversalOrder(
                              order: NumericFocusOrder(18),
                              child: labeledTextField(context, isMobile, AppText.owner, controller.vehicleOwnerController,
                                  width: fieldWidth,
                                  textInputAction: TextInputAction.next,
                                  column: true
                              ),
                            ),
                            const SizedBox(width: 12),
                            FocusTraversalOrder(
                              order: NumericFocusOrder(19),
                              child: labeledTextField(context, isMobile, AppText.logBook, controller.vehicleLogBookController,
                                  width: fieldWidth,
                                  textInputAction: TextInputAction.next,
                                  column: true
                              ),
                            ),
                            // _gap(isMobile),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 23),
                            child: SizedBox(
                              width: 200,
                              // height: 30,
                              child: RestrictedDrivers(
                                // border: Border(
                                //   bottom: BorderSide(
                                //     color: Colors.grey, // border color
                                //     width: 2.0,        // border thickness
                                //   ),
                                // ),
                                driversList: ['Saloon', "SUV" ,"Van"],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width/6,
                            height: 60,
                            child: ListView.builder(
                                itemCount: controller.imageList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context,index){
                              return  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 300,
                                      width: 150,
                                      child: Image.memory(controller.imageList[index].bytes, width: 200, height: 200,fit: BoxFit.fill,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        controller.imageList.remove(controller.imageList[index]);
                                        controller.update();
                                      },
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: DynamicColors.whiteClr,
                                        child: Icon(Icons.close,
                                        color: DynamicColors.primaryClr,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 23,vertical: 15),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              // Choose File
                              GestureDetector(
                                onTap: (){
                                  controller.pickImage();
                                },
                                child: Container(
                                  height: double.infinity,
                                  color: Colors.grey[300],
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Choose File",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  "NO FILE CHOSEN",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  controller.imageList.clear();
                                  controller.update();
                                },
                                child: Container(
                                  height: double.infinity,
                                  color: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
           SizedBox(height: 12),
                /*      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 23),
                        child: FocusTraversalOrder(
                          order: const NumericFocusOrder(11),
                          child: labeledTextField(context,
                              isMobile,
                              AppText.address,
                              controller.driverAddressController,
                              width: fieldWidth,
                              column: true,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              formatDigitsOnly: false),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomButton(
                          verticalPadding: 0.0,
                          width: fieldWidth*2,
                          borderRadius: 4,
                          height: 35,

                          btnColor: DynamicColors.primaryClr,
                          btnText: AppText.save,
                        ),
                      )*/
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}
