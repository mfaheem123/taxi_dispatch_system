


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../Controller/dashboard_controller.dart';
import '../models/all_addresses_model.dart';


class PickupWidget extends StatefulWidget {
  const PickupWidget({super.key});

  @override
  State<PickupWidget> createState() => _PickupWidgetState();
}

class _PickupWidgetState extends State<PickupWidget> {

  final FocusNode swap1FN = FocusNode();
  final FocusNode swap2FN = FocusNode();


  @override
  void dispose() {
    swap1FN.dispose();
    swap2FN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: GetBuilder<DashboardController>(
        builder: (controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

              double pickupWidth = isMobile
                  ? constraints.maxWidth * 0.9
                  : isTablet
                  ? constraints.maxWidth / 2.5
                  : constraints.maxWidth / 3.5;

              double notesWidth = isMobile
                  ? constraints.maxWidth * 0.9
                  : isTablet
                  ? constraints.maxWidth / 6
                  : constraints.maxWidth / 8;

              return Column(
                children: [
                  // ================= PICKUP ROW =================
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection:
                      isMobile ? Axis.vertical : Axis.horizontal,
                      child: Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              AppText.pick,
                              style: mozillaTextSemiBoldText(
                                context: context,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          // (1) Pickup textfield
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(1),
                            child: SizedBox(
                              width: pickupWidth,
                              height: 30,
                              child: RawKeyboardListener(
                                focusNode: controller.pickupKeyboardFocusNode,
                                onKey: (event) {
                                  if (event is RawKeyDownEvent) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowDown &&
                                        controller.highlightedIndex.value <
                                            controller.suggestions.length - 1) {
                                      controller.highlightedIndex.value++;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowUp &&
                                        controller.highlightedIndex.value > 0) {
                                      controller.highlightedIndex.value--;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.enter) {
                                      final selected = controller.suggestions[
                                      controller.highlightedIndex.value];
                                      // controller.selectSuggestion(selected);
                                    }
                                  }
                                },

                                child: CustomTextField(
                                  key: controller.pickupFieldKey,
                                  controller: controller.pickupController,
                                  focusNode:
                                  controller.pickupTextFieldFocusNode,
                                  hintText: 'PICKUP LOCATION',
                                  borderRadius: 4,
                                  prefixIcon: const Icon(Icons.location_pin,
                                      color: Colors.red,size: 20,),
                                  textInputAction: TextInputAction.next,
                                  onChanged: (v){
                                    controller.onChangeHandler(fieldName: "PICKUP LOCATION",searchingText: v);
                                  },
                                  onTap: (){
                                    // shortCutKeyValue.value = "formKey";
                                  },
                                  onSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  suffixIcon: KbdActivatable(
                                    focusNode: swap1FN,
                                    onActivate: () {
                                      String tempPic = controller.pickupController.text;
                                      String tempDrop = controller.dropOffController.text;
                                      controller.pickupController.text = tempDrop;
                                      controller.dropOffController.text = tempPic;
                                      controller.update();
                                    },
                                    child: const Icon(Icons.swap_vert,
                                        color: Color(0xFF575797), size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                              width: isMobile  ? 0 : 10,
                              height: isMobile ? 10 : 0),
                          // (2) Select plot button
                          FocusTraversalOrder(

                            order: const NumericFocusOrder(2),
                            child: RestrictedDrivers(
                              width: notesWidth,
                              height: 30,
                              padding: 0.0,
                              titleText: "SELECT PLOT",
                              driversList: [
                                "BASE NE7", "WILLESDEN"
                              ],
                            ),
                          ),


                         /* FocusTraversalOrder(
                            order: const NumericFocusOrder(2),
                            child: KbdActivatable(
                              focusNode: plot1FN,
                              onActivate: () {
                                // open first dropdown
                              },
                              child: Container(
                                width: notesWidth,
                                height: 30,
                                // padding:
                                // const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: DynamicColors.primaryClr,
                                      width: 1.2),
                                ),
                                child: CustomDropdownButton(
                                  itemList: const ["BASE NE7", "WILLESDEN"],
                                  hintText: "SELECT PLOT",
                                ),
                              ),
                            ),
                          ),*/

                          SizedBox(
                              width: isMobile ? 0 : 10,
                              height: isMobile ? 10 : 0),

                          // (3) Pickup notes
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(3),
                            child: SizedBox(
                              width: notesWidth,
                              height: 30,
                              child: CustomTextField(
                                controller: TextEditingController(),
                                hintText: "PICKUP NOTES",
                                borderRadius: 6,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.019),

                  // ================= DROPOFF ROW =================
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection:
                      isMobile ? Axis.vertical : Axis.horizontal,
                      child: Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              AppText.drop,
                              style: mozillaTextSemiBoldText(
                                context: context,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          // (4) Dropoff textfield
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(4),
                            child: SizedBox(
                              width: pickupWidth,
                              height: 30,
                              child: RawKeyboardListener(
                                focusNode: controller.dropOffKeyboardFocusNode,
                                onKey: (event) {
                                  if (event is RawKeyDownEvent) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowDown &&
                                        controller.highlightedIndex.value <
                                            controller.suggestions.length - 1) {
                                      controller.highlightedIndex.value++;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowUp &&
                                        controller.highlightedIndex.value > 0) {
                                      controller.highlightedIndex.value--;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.enter) {
                                      final selected = controller.suggestions[
                                      controller.highlightedIndex.value];
                                      // controller.selectSuggestion(selected);
                                    }
                                  }
                                },
                                child: CustomTextField(
                                  key: controller.dropOffFieldKey,
                                  controller: controller.dropOffController,
                                  focusNode:
                                  controller.dropOffTextFieldFocusNode,
                                  hintText: 'DROP LOCATION',
                                  borderRadius: 4,
                                  prefixIcon: const Icon(Icons.location_pin,
                                      color: Colors.red,size: 20,),
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  suffixIcon: KbdActivatable(
                                    focusNode: swap2FN,
                                    onActivate: () {
                                      String tempPic =
                                          controller.pickupController.text;
                                      String tempDrop =
                                          controller.dropOffController.text;
                                      controller.pickupController.text =
                                          tempDrop;
                                      controller.dropOffController.text =
                                          tempPic;
                                      controller.update();
                                    },
                                    child: const Icon(Icons.swap_vert,
                                        color: Color(0xFF575797), size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                              width: isMobile ? 0 : 10,
                              height: isMobile ? 10 : 0),

                          // (5) Select plot button
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(5),
                            child: RestrictedDrivers(
                              width: notesWidth,
                              height: 30,
                              padding: 0.0,
                              titleText: "SELECT PLOT",
                              driversList: [
                                "BASE NE7", "WILLESDEN"
                              ],
                            ),
                          ),

                          SizedBox(
                              width: isMobile ? 0 : 10,
                              height: isMobile ? 10 : 0),

                          // (6) Drop notes
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(6),
                            child: SizedBox(
                              width: notesWidth,
                              height: 30,
                              child: CustomTextField(
                                controller: TextEditingController(),
                                hintText: "DROP NOTES",
                                borderRadius: 6,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).unfocus(),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  if (controller.jourValue == 'W/R') ...[
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    SingleChildScrollView(
                      scrollDirection:
                      isMobile ? Axis.vertical : Axis.horizontal,
                      child: Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              AppText.pick,
                              style: mozillaTextSemiBoldText(
                                context: context,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          // (1) Pickup textfield
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(1),
                            child: SizedBox(
                              width: pickupWidth,
                              height: 30,
                              child: RawKeyboardListener(
                                focusNode: controller.via1KeyboardFocusNode,
                                onKey: (event) {
                                  if (event is RawKeyDownEvent) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowDown &&
                                        controller.highlightedIndex.value <
                                            controller.suggestions.length - 1) {
                                      controller.highlightedIndex.value++;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowUp &&
                                        controller.highlightedIndex.value > 0) {
                                      controller.highlightedIndex.value--;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.enter) {
                                      final selected = controller.suggestions[
                                      controller.highlightedIndex.value];
                                      // controller.selectSuggestion(selected);
                                    }
                                  }
                                },

                                child: CustomTextField(
                                  key: controller.via1FieldKey,
                                  controller: controller.viaLocation1Controller,
                                  focusNode:
                                  controller.via1TextFieldFocusNode,
                                  hintText: 'PICKUP LOCATION',
                                  borderRadius: 4,
                                  prefixIcon: const Icon(Icons.location_pin,
                                      color: Colors.red,size: 20,),
                                  textInputAction: TextInputAction.next,
                                  onTap: (){
                                    shortCutKeyValue.value = "formKey";
                                  },
                                  onSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  suffixIcon: KbdActivatable(
                                    focusNode: swap1FN,
                                    onActivate: () {
                                      String tempPic =
                                          controller.viaLocation1Controller.text;
                                      String tempDrop =
                                          controller.viaLocation2Controller.text;
                                      controller.viaLocation1Controller.text =
                                          tempDrop;
                                      controller.viaLocation2Controller.text =
                                          tempPic;
                                      controller.update();
                                    },
                                    child: const Icon(Icons.swap_vert,
                                        color: Color(0xFF575797), size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                              width: isMobile ? 0 : 10,
                              height: isMobile ? 10 : 0),

                          // (2) Select plot button
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(2),
                            child: RestrictedDrivers(
                              width: notesWidth,
                              height: 30,
                              padding: 0.0,
                              titleText: "SELECT PLOT",
                              driversList: [
                                "BASE NE7", "WILLESDEN"
                              ],
                            ),
                          ),

                          SizedBox(
                              width: isMobile ? 0 : 10,
                              height: isMobile ? 10 : 0),

                          // (3) Pickup notes
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(3),
                            child: SizedBox(
                              width: notesWidth,
                              height: 30,
                              child: CustomTextField(
                                controller: TextEditingController(),
                                hintText: "PICKUP NOTES",
                                borderRadius: 6,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.019),

                    // ================= DROPOFF ROW =================
                    SingleChildScrollView(
                      scrollDirection:
                      isMobile ? Axis.vertical : Axis.horizontal,
                      child: Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              AppText.drop,
                              style: mozillaTextSemiBoldText(
                                context: context,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          // (4) Dropoff textfield
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(4),
                            child: SizedBox(
                              width: pickupWidth,
                              height: 30,
                              child: RawKeyboardListener(
                                focusNode: controller.via2KeyboardFocusNode,
                                onKey: (event) {
                                  if (event is RawKeyDownEvent) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowDown &&
                                        controller.highlightedIndex.value <
                                            controller.suggestions.length - 1) {
                                      controller.highlightedIndex.value++;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.arrowUp &&
                                        controller.highlightedIndex.value > 0) {
                                      controller.highlightedIndex.value--;
                                    } else if (event.logicalKey ==
                                        LogicalKeyboardKey.enter) {
                                      final selected = controller.suggestions[
                                      controller.highlightedIndex.value];
                                      // controller.selectSuggestion(selected);
                                    }
                                  }
                                },
                                child: CustomTextField(
                                  key: controller.via2FieldKey,
                                  controller: controller.viaLocation2Controller,
                                  focusNode: controller.dropOffTextFieldFocusNode,
                                  hintText: 'DROP LOCATION',
                                  borderRadius: 4,
                                  prefixIcon: const Icon(Icons.location_pin, color: Colors.red,size: 20,),
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                  suffixIcon: KbdActivatable(
                                    focusNode: swap2FN,
                                    onActivate: () {
                                      String tempPic = controller.viaLocation1Controller.text;
                                      String tempDrop = controller.viaLocation2Controller.text;
                                      controller.viaLocation1Controller.text = tempDrop;
                                      controller.viaLocation2Controller.text = tempPic;
                                      controller.update();
                                    },
                                    child: const Icon(Icons.swap_vert,
                                        color: Color(0xFF575797), size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                              width: isMobile ? 0 : 10,
                              height: isMobile ? 10 : 0),
                          // (5) Select plot button
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(5),
                            child: RestrictedDrivers(
                              width: notesWidth,
                              height: 30,
                              padding: 0.0,
                              titleText: "SELECT PLOT",
                              driversList: [
                                "BASE NE7", "WILLESDEN"
                              ],
                            ),
                          ),

                          SizedBox(
                              width: isMobile ? 0 : 10,
                              height: isMobile ? 10 : 0),

                          // (6) Drop notes
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(6),
                            child: SizedBox(
                              width: notesWidth,
                              height: 30,
                              child: CustomTextField(
                                controller: TextEditingController(),
                                hintText: "DROP NOTES",
                                borderRadius: 6,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).unfocus(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                ],
              );
            },
          );
        },
      ),
    );
  }
}

// ================= KEYBOARD ACTIVATABLE WRAPPER =================
class KbdActivatable extends StatelessWidget {
  final FocusNode focusNode;
  final VoidCallback onActivate;
  final Widget child;

  const KbdActivatable({
    super.key,
    required this.focusNode,
    required this.onActivate,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
          LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) {
                onActivate();
                return null;
              },
            ),
          },
          child: GestureDetector(
            onTap: onActivate,
            behavior: HitTestBehavior.opaque,
            child: child,
          ),
        ),
      ),
    );
  }
}

