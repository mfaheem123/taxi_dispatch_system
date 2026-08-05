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
        return LayoutBuilder(builder: (context, constraints) {
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
            decoration:
                BoxDecoration(border: Border.all(color: DynamicColors.textClr)),
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
                      border: Border.all(color: DynamicColors.textClr)),
                  child: Text(AppText.pdaSimDetails,
                      style: mozillaTextSemiBoldText(fontSize: 16)),
                ),
                SizedBox(height: screenHeight * 0.019),
                // ================= Row 1: Name, Email, Mobile, Tel =================
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
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
                      // const SizedBox(width: 12),
                      // _gap(isMobile),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(2),
                        child: textFieldsWidget(
                          context,
                          controller.makeController,
                          width: itemWidth,
                          label: AppText.make,
                        ),
                      ),
                      // const SizedBox(width: 12),
                      // _gap(isMobile),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(3),
                        child: textFieldsWidget(
                          context,
                          controller.modelController,
                          label: AppText.model,
                          width: itemWidth,
                        ),
                      ),
                      // const SizedBox(width: 12),
                      // _gap(isMobile),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(4),
                        child: textFieldsWidget(
                          context,
                          controller.simNetworkController,
                          label: AppText.simNetwork,
                          width: itemWidth,
                        ),
                      ),
                      // const SizedBox(width: 12),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(5),
                        child: textFieldsWidget(
                          context,
                          controller.simNumberController,
                          label: AppText.simNumber,
                          width: itemWidth,
                        ),
                      ),
                      // const SizedBox(width: 12),
                      // _gap(isMobile),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: screenHeight * 0.019),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 15.0),
                      //   child: SingleChildScrollView(
                      //     scrollDirection: Axis.vertical,
                      //     child: Flex(
                      //       direction: Axis.vertical,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(6),
                        child: textFieldsWidget(
                          context,
                          controller.networkProviderController,
                          label: AppText.networkProvider,
                          width: itemWidth,
                        ),
                      ),
                      // const SizedBox(width: 12),
                      // _gap(isMobile),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(7),
                        child: textFieldsWidget(
                          context,
                          controller.dataAllowanceController,
                          label: AppText.dataAllowance,
                          width: itemWidth,
                        ),
                      ),
                      // const SizedBox(width: 12),
                      // _gap(isMobile),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(8),
                        child: textFieldsWidget(
                          context,
                          controller.pdaDepositController,
                          label: AppText.pdaDeposit,
                          width: itemWidth,
                        ),
                      ),
                      // const SizedBox(width: 12),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(9),
                        child: textFieldsWidget(
                          context,
                          controller.commentsController,
                          label: AppText.comments,
                          width: itemWidth,
                        ),
                      ),
                      // _gap(isMobile),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.019),
              ],
            ),
          );
        });
      },
    );
  }
}
// return Container(
//   width: Get.width,
//   decoration: BoxDecoration(
//       border: Border.all(color: DynamicColors.textClr)
//   ),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Container(
//         width: Get.width,
//         alignment: Alignment.centerLeft,
//         padding: EdgeInsets.only(left: 15),
//         height: kToolbarHeight,
//         decoration: BoxDecoration(
//             color: DynamicColors.gryClr.withOpacity(0.2),
//             border: Border.all(color: DynamicColors.textClr)
//         ),
//         child: Text(AppText.pdaSimDetails,
//             style: mozillaTextSemiBoldText(
//                 fontSize: 16
//             )
//         ),
//       ),
//       SizedBox(height: screenHeight * 0.019),
//       // ================= Row 1: Name, Email, Mobile, Tel =================
//       Padding(
//         padding: const EdgeInsets.only(left: 15.0),
//         child: SingleChildScrollView(
//           scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
//           child: Flex(
//             direction: isMobile ? Axis.vertical : Axis.horizontal,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               FocusTraversalOrder(
//                 order: const NumericFocusOrder(1),
//                 child: textFieldsWidget(
//                   context, controller.imeController,
//                   label: AppText.ime,
//                   width: width,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // _gap(isMobile),
//               FocusTraversalOrder(
//                 order: const NumericFocusOrder(2),
//                 child: textFieldsWidget(
//                   context,
//                     controller.makeController,
//                   label: AppText.make,
//                   width: width,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // _gap(isMobile),
//               FocusTraversalOrder(
//                 order: const NumericFocusOrder(3),
//                 child:
//                 textFieldsWidget(
//                   context,
//                   controller.modelController,
//                   label: AppText.model,
//                   width: width,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // _gap(isMobile),
//               FocusTraversalOrder(
//                 order: const NumericFocusOrder(4),
//                 child:
//                 textFieldsWidget(
//                   context,
//                   controller.simNetworkController,
//                   label: AppText.simNetwork,
//                   width: width,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               FocusTraversalOrder(
//                 order: const NumericFocusOrder(5),
//                 child:
//                 textFieldsWidget(
//                   context,
//                   controller.simNumberController,
//                   label: AppText.simNumber,
//                   width: width,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // _gap(isMobile),
//             ],
//           ),
//         ),
//       ),
//       SizedBox(height: screenHeight * 0.019),
//       Padding(
//         padding: const EdgeInsets.only(left: 15.0),
//         child: SingleChildScrollView(
//           scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
//           child: Flex(
//             direction: isMobile ? Axis.vertical : Axis.horizontal,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               FocusTraversalOrder(
//                 order: const NumericFocusOrder(6),
//                 child:
//                 textFieldsWidget(
//                   context,
//                   controller.networkProviderController,
//                   label: AppText.networkProvider,
//                   width: width,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // _gap(isMobile),
//               FocusTraversalOrder(
//                 order: const NumericFocusOrder(7),
//                 child:
//                 textFieldsWidget(
//                   context,
//                   controller.dataAllowanceController,
//                   label: AppText.dataAllowance,
//                   width: width,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // _gap(isMobile),
//               FocusTraversalOrder(
//                 order: const NumericFocusOrder(8),
//                 child:
//                 textFieldsWidget(
//                   context,
//                   controller.pdaDepositController,
//                   label: AppText.pdaDeposit,
//                   width: width,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // _gap(isMobile),
//               FocusTraversalOrder(
//                 order: const NumericFocusOrder(8),
//                 child:
//                 textFieldsWidget(
//                   context,
//                   controller.commentsController,
//                   label: AppText.comments,
//                   width: width,
//                 ),
//               ),
//
//               // _gap(isMobile),
//             ],
//           ),
//         ),
//       ),
//       SizedBox(height: screenHeight * 0.019),
//     ],
//   ),
//             );
//           }
//         );
//       }
//     );
//   }
// }

Widget textFieldsWidget(
  BuildContext context,
  TextEditingController controller, {
  // label, width,
  required double width,
  String? label,
}) {
  return SizedBox(
    width: width,
    // child: Padding(
    //   padding: EdgeInsets.symmetric(vertical: width < 1920?8.0:0.0),
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
          // < 1920 ? Get.width : Get.width/9,
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
