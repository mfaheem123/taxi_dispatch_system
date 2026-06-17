import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/color.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';

class PdaDetailsWidget extends StatelessWidget {
  PdaDetailsWidget({super.key});


  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
    //     WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<DriverController>(
      builder: (controller) {
        return LayoutBuilder(
            builder: (context, constraints) {
              double availableWidth = constraints.maxWidth;

              double itemWidth = availableWidth > 1350
                  ? (availableWidth - 70) / 6
                  : availableWidth > 450
                  ? (availableWidth - 120) / 4
                  : (availableWidth - 30) / 2;
              // final bool isMobile = constraints.maxWidth < 600;
              // final bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
              //
              // final double fieldWidth = isMobile
              //     ? constraints.maxWidth * 0.9
              //     : isTablet
              //     ? 150
              //     : 150;

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.textClr)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15),
                        height: kToolbarHeight,
                        decoration: BoxDecoration(
                            color: DynamicColors.gryClr.withOpacity(0.2),
                            border: Border.all(color: DynamicColors.textClr)
                        ),
                        child: Text(AppText.pdaSimDetails,
                            style: mozillaTextSemiBoldText(
                                fontSize: 16
                            )
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.019),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 12,
                          children: [
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(1),
                                child: textFieldsWidget(
                                  context,
                                  controller.imeController,
                                  width: itemWidth,
                                  label: AppText.ime,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(2),
                                child: textFieldsWidget(
                                  context,
                                  controller.makeController,
                                  width: itemWidth,
                                  label: AppText.make,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(3),
                                child:
                                textFieldsWidget(
                                  context,
                                  controller.modelController,
                                  label: AppText.model,
                                  width: itemWidth,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(4),
                                child:
                                textFieldsWidget(
                                  context,
                                  controller.simNetworkController,
                                  label: AppText.simNetwork,
                                  width: itemWidth,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(5),
                                child:
                                textFieldsWidget(
                                  context,
                                  controller.simNumberController,
                                  label: AppText.simNumber,
                                  width: itemWidth,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(6),
                                child:
                                textFieldsWidget(
                                  context,
                                  controller.networkProviderController,
                                  label: AppText.networkProvider,
                                  width: itemWidth,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(7),
                                child:
                                textFieldsWidget(
                                  context,
                                  controller.dataAllowanceController,
                                  label: AppText.dataAllowance,
                                  width: itemWidth,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(8),
                                child:
                                textFieldsWidget(
                                  context,
                                  controller.pdaDepositController,
                                  label: AppText.pdaDeposit,
                                  width: itemWidth,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(8),
                                child:
                                textFieldsWidget(
                                  context,
                                  controller.commentsController,
                                  label: AppText.comments,
                                  width: itemWidth,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: screenHeight * 0.019),
                    ],
                  ),
                );
              }
        );
      },
    );
  }
}

Widget textFieldsWidget(
    BuildContext context,
    TextEditingController controller, {
      required double width,
      String? label,
    }) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? AppText.make,
          style: mozillaTextSemiBoldText(context: context, fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        CustomTextField(
          width: width,
          borderRadius: 4,
          controller: controller,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            if (value.isNotEmpty) {
              controller.value = controller.value.copyWith(
                text: value.toUpperCase(),
                selection: TextSelection.collapsed(offset: value.length),
              );
            }
          },
        ),
      ],
    ),
  );
}