


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/escape_dismissible.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../component/text_widget.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import 'child_seats_alert.dart';

class ExtraInfoAlert extends StatefulWidget {
  const ExtraInfoAlert({super.key, this.formController});

  /// Which booking form opened this dialog.
  ///
  /// Left null on the dashboard, where the bare `Get.find` below resolves the
  /// permanent controller exactly as it always did. The edit screen passes its
  /// own tagged instance in: a dialog is pushed on a route of its own, so it
  /// sits outside the [BookingFormScope] the rest of that screen is wrapped in
  /// and cannot look the controller up from context.
  final DashboardController? formController;


  @override
  State<ExtraInfoAlert> createState() => _ExtraInfoAlertState();
}

class _ExtraInfoAlertState extends State<ExtraInfoAlert> {

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
            height: 500,
            width: 650,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ADDITIONAL BOOKING INFO",
                        style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
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
                  // SizedBox(
                  //   height: 15,
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IntrinsicWidth(
                        child: SizedBox(
                          width: controller.jourValue == 'W/R'? 295: 600.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(AppText.specialRequirements,
                                  style: mozillaTextSemiBoldText(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              CustomTextField(
                                maxLines: 3,
                                height: 50,
                                hintText: AppText.specialRequirements,
                                controller: dashBoardCntrl.specialRequirementsController,
                                hintStyle: mozillaTextRegularText(
                                  fontSize: 10
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                                borderRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.jourValue == 'W/R'?true:false,
                        child: SizedBox(
                          width: 295,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Text('RETURN SPECIAL REQUIREMENTS',
                                  style: mozillaTextSemiBoldText(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              CustomTextField(
                                maxLines: 3,
                                height: 50,
                                hintText: 'RETURN SPECIAL REQUIREMENTS',
                                controller: dashBoardCntrl.specialRequirementsReturnController,
                                hintStyle: mozillaTextRegularText(
                                  fontSize: 10
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                                borderRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Divider(),

                  // SizedBox(
                  //   height: 15,
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: controller.jourValue == 'W/R'? 295: 600.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(AppText.controllerNotes,
                                style: mozillaTextSemiBoldText(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    contentPadding: EdgeInsets.only(left: 12.0),
                                    hintText: "ENTER YOUR NOTE HERE",
                                    controller: controller.controllerNoteController,
                                    hintStyle: mozillaTextRegularText(fontSize: 10),
                                    borderRadius: 4,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                CustomButton(
                                  width: 35,
                                  height: 35,
                                  // onTap: (){
                                  //   if(controller.controllerNoteController.text.isNotEmpty){
                                  //     controller.controllerAlert.add(
                                  //       NoteClass(
                                  //           note: controller.controllerNoteController.text,
                                  //           title: 'controller note'
                                  //       ),
                                  //     );
                                  //     controller.controllerNoteController.clear();
                                  //     controller.update();
                                  //   }
                                  // },
                                  onTap: (){
                                    if(controller.controllerNoteController.text.isNotEmpty){
                                      if (editingIndex != null) {
                                        controller.controllerAlert[editingIndex!] = NoteClass(
                                          note: controller.controllerNoteController.text,
                                          title: 'controller note',
                                        );
                                        editingIndex = null;
                                      } else {
                                        controller.controllerAlert.add(
                                          NoteClass(
                                            note: controller.controllerNoteController.text,
                                            title: 'controller note',
                                          ),
                                        );
                                      }
                                      controller.controllerNoteController.clear();
                                      controller.update();
                                    }
                                  },
                                  verticalPadding: 0.0,
                                  borderRadius: 4,
                                  widget: Icon(Icons.add, size: 18, color: DynamicColors.whiteClr),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.jourValue == 'W/R' ? true : false,
                        child: SizedBox(
                          width: 295,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Text('CONTROLLER RETURN NOTES',
                                  style: mozillaTextSemiBoldText(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      contentPadding: EdgeInsets.only(left: 12),
                                      hintText: "ENTER YOUR RETURN NOTES HERE",
                                      controller: controller.controllerNoteReturnController,
                                      hintStyle: mozillaTextRegularText(fontSize: 10),
                                      borderRadius: 4,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  CustomButton(
                                    width: 35,
                                    height: 35,
                                    btnColor: DynamicColors.greenClr,
                                    onTap: (){
                                      if(controller.controllerNoteReturnController.text.isNotEmpty){
                                        controller.controllerAlert.add(NoteClass(
                                            note: controller.controllerNoteReturnController.text,
                                            title: 'controller return note'
                                        ));
                                        controller.controllerNoteReturnController.clear();
                                        controller.update();
                                      }
                                    },
                                    verticalPadding: 0.0,
                                    borderRadius: 4,
                                    widget: Icon(Icons.add, size: 18, color: DynamicColors.whiteClr),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        itemCount: controller.controllerAlert.length,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context,index){
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  child: Text(controller.controllerAlert[index].note!),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: CustomButton(
                                      // onTap: (){
                                      //   controller.controllerNoteController.text = controller.controllerAlert[index].note!;
                                      //   controller.update();
                                      // },
                                      onTap: (){
                                        controller.controllerNoteController.text = controller.controllerAlert[index].note!;
                                        setState(() {
                                          editingIndex = index;
                                        });
                                        controller.update();
                                      },
                                      width: 30,
                                      height: 25,
                                      verticalPadding: 0.0,
                                      borderRadius: 6,
                                      btnColor: controller.controllerAlert[index].title == "controller return note"?DynamicColors.greenClr:
                                      DynamicColors.primaryClr,
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
                                      onTap: () {
                                        controller.controllerAlert.remove(controller.controllerAlert[index]);
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomButton(
                            width: 80,
                            height: 30,
                            onTap: (){
                              Get.back();
                            },
                            verticalPadding: 0.0,
                            borderRadius: 6,
                            btnColor: DynamicColors.redClr,
                            style: mozillaTextSemiBoldText(
                                fontSize: 13,
                                color: DynamicColors.whiteClr),
                            btnText: AppText.cancel,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomButton(
                            width: 80,
                            height: 30,
                            onTap: (){
                              Get.back();
                            },
                            verticalPadding: 0.0,
                            borderRadius: 6,
                            style: mozillaTextSemiBoldText(
                                fontSize: 13,
                                color: DynamicColors.whiteClr),
                         btnText: AppText.save,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
      ),
    );
  }
}
