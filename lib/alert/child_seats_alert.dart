



import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/escape_dismissible.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../component/color.dart';
import 'extra_info_alert.dart';

class ChildSeatsAlert extends StatefulWidget {
  const ChildSeatsAlert({super.key, this.formController});

  /// Which booking form opened this dialog.
  ///
  /// Left null on the dashboard, where the bare `Get.find` below resolves the
  /// permanent controller exactly as it always did. The edit screen passes its
  /// own tagged instance in: a dialog is pushed on a route of its own, so it
  /// sits outside the [BookingFormScope] the rest of that screen is wrapped in
  /// and cannot look the controller up from context.
  final DashboardController? formController;


  @override
  State<ChildSeatsAlert> createState() => _ChildSeatsAlertState();
}

class _ChildSeatsAlertState extends State<ChildSeatsAlert> {

  int? editingIndex;
  /// The form that opened this dialog — the edit screen's private instance
  /// when it passed one, the dashboard's permanent controller otherwise.
  late final DashboardController dashBoardCntrl =
      widget.formController ?? Get.find<DashboardController>();
  final FocusNode closeButtonFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  @override
  Widget build(BuildContext context) {
    // Escape closes the alert: see EscapeDismissible for why the framework's
    // own Escape-to-dismiss never reached these dialogs.
    return EscapeDismissible(
      child: Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GetBuilder<DashboardController>(
        // Follows whichever form opened the dialog.
        tag: dashBoardCntrl.formTag,
        builder: (controller) {
          return Container(
            height: 390,
            width: 650,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppText.childSeat,
                      style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: closeButtonFocusNode,
                      builder: (context, child) {
                        final isFocused = closeButtonFocusNode.hasFocus;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFocused ? DynamicColors.primaryClr : Colors.transparent,
                              width: 2,
                            ),
                            color: isFocused ? DynamicColors.primaryClr.withOpacity(0.15) : Colors.transparent,
                          ),
                          child: IconButton(
                            focusNode: closeButtonFocusNode,
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close, size: 22, color: Colors.grey),
                            splashRadius: 20,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: DynamicColors.gryClr.withOpacity(0.4)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppText.noOfChildren,
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      Text(AppText.age,
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      Text(AppText.actions,
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                          hintText: "NO OF CHILDREN",
                          controller: controller.noOfChildren,
                        borderRadius: 0,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(
                              2),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CustomTextField(
                          borderRadius: 0,
                          hintText: "AGE",
                          controller: controller.childAge,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(
                              2),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomButton(
                        width: 60,
                        height: 30,
                        // onTap: (){
                        //   controller.childSeatAlert.add(ChildSeatClass(
                        //     sets: controller.noOfChildren.text,
                        //     age: controller.childAge.text,
                        //   ));
                        //   controller.noOfChildren.clear();
                        //   controller.childAge.clear();
                        //   controller.update();
                        // },
                        onTap: (){
                          if(controller.noOfChildren.text.isNotEmpty || controller.childAge.text.isNotEmpty){
                            if (editingIndex != null) {
                              controller.childSeatAlert[editingIndex!] = ChildSeatClass(
                                sets: controller.noOfChildren.text,
                                age: controller.childAge.text,
                              );
                              editingIndex = null;
                            } else {

                              controller.childSeatAlert.add(ChildSeatClass(
                                sets: controller.noOfChildren.text,
                                age: controller.childAge.text,
                              ));
                            }
                            controller.noOfChildren.clear();
                            controller.childAge.clear();
                            controller.update();
                          }
                        },
                        verticalPadding: 0.0,
                        borderRadius: 6,
                        style: mozillaTextSemiBoldText(
                            fontSize: 13,
                            color: DynamicColors.whiteClr),
                        btnText: "SAVE",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    itemCount: controller.childSeatAlert.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context,index){
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                child: Text(controller.childSeatAlert[index].sets.toString()),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                child: Text(controller.childSeatAlert[index].age.toString()),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CustomButton(
                                    width: 30,
                                    height: 25,
                                    onTap: (){
                                      controller.noOfChildren.text = controller.childSeatAlert[index].sets.toString();
                                      controller.childAge.text = controller.childSeatAlert[index].age.toString();
                                      setState(() {
                                        editingIndex = index;
                                      });
                                      controller.update();
                                    },
                                    verticalPadding: 0.0,
                                    borderRadius: 6,
                                    widget: Icon(Icons.edit_document,
                                      color: DynamicColors.whiteClr,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CustomButton(
                                    width: 30,
                                    height: 25,
                                    onTap: (){
                                      controller.childSeatAlert.remove(controller.childSeatAlert[index]);
                                      controller.update();
                                    },
                                    verticalPadding: 0.0,
                                    btnColor: DynamicColors.redClr,
                                    borderRadius: 6,
                                    widget: Icon(Icons.delete_forever,
                                      color: DynamicColors.whiteClr,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(
                          height: 10,
                        )
                      ],
                    );
                  }),
                )
              ],
            ),
          );
        }
      ),
      ),
    );
  }
}


class ChildSeatClass{
  String? age, sets;
  ChildSeatClass({this.age,this.sets});
}

class NoteClass{
  String? note, title;
  NoteClass({this.note,this.title});
}