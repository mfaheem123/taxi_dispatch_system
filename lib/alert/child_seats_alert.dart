import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/escape_dismissible.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';
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
            return SizedBox(
              width: 550,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      child: Row(
                        children: [
                          Icon(Icons.child_friendly, color: DynamicColors.primaryClr, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "CHILD SEAT REQUIREMENTS",
                            style: mozillaTextSemiBoldText(fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          const Spacer(),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          padding: EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel("SEATS COUNT"),
                                    CustomTextField(
                                      hintText: "E.G. 1",
                                      controller: controller.noOfChildren,
                                      borderRadius: 6,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel("AGE GROUP"),
                                    CustomTextField(
                                      hintText: "E.G. 2-3",
                                      controller: controller.childAge,
                                      borderRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              CustomButton(
                                width: editingIndex != null ? 90 : 80,
                                height: 30,
                                onTap: () {
                                  // onTap: (){
                                  //   controller.childSeatAlert.add(ChildSeatClass(
                                  //     sets: controller.noOfChildren.text,
                                  //     age: controller.childAge.text,
                                  //   ));
                                  //   controller.noOfChildren.clear();
                                  //   controller.childAge.clear();
                                  //   controller.update();
                                  // },
                                  if (controller.noOfChildren.text.isNotEmpty ||
                                      controller.childAge.text.isNotEmpty) {
                                    if (editingIndex != null) {
                                      controller.childSeatAlert[editingIndex!] =
                                          ChildSeatClass(
                                        sets: controller.noOfChildren.text,
                                        age: controller.childAge.text,
                                      );
                                      setState(() {
                                        editingIndex = null;
                                      });
                                    } else {
                                      controller.childSeatAlert
                                          .add(ChildSeatClass(
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
                                widget: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(editingIndex != null ? Icons.check : Icons.add, color: Colors.white, size: 16),
                                    const SizedBox(width: 2),
                                    Text(
                                        editingIndex != null ? "UPDATE" : "ADD",
                                        style: mozillaTextSemiBoldText(fontSize: 12, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            children: [
                              // TABLE HEADER
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  border: Border(
                                      bottom: BorderSide(color: Color(0xFFE2E8F0))),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "COUNT",
                                        style: mozillaTextSemiBoldText(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: 1,
                                        height: 16,
                                        color: const Color(0xFFE2E8F0)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "AGE",
                                        style: mozillaTextSemiBoldText(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: 1,
                                        height: 16,
                                        color: const Color(0xFFE2E8F0)),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        "ACTION",
                                        textAlign: TextAlign.center,
                                        style: mozillaTextSemiBoldText(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // SizedBox(
                              //   height: 180,
                              //   child: ListView.builder(
                              //       itemCount: controller.childSeatAlert.length,
                              //       physics: AlwaysScrollableScrollPhysics(),
                              //       itemBuilder: (BuildContext context, index) {
                              if (controller.childSeatAlert.isNotEmpty)
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 200),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: controller.childSeatAlert.length,
                                    physics: const ClampingScrollPhysics(),
                                    separatorBuilder: (_, __) => const Divider(
                                        height: 1, color: Color(0xFFE2E8F0)),
                                    itemBuilder: (BuildContext context, index) {
                                      return Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                controller.childSeatAlert[index].sets.toString(),
                                                style: mozillaTextSemiBoldText(fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                                width: 1,
                                                height: 40,
                                                color: const Color(0xFFE2E8F0)),
                                            const SizedBox(width: 8),

                                            // AGE DATA
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                controller.childSeatAlert[index].age.toString(),
                                                style: mozillaTextSemiBoldText(fontSize: 12),
                                              ),
                                            ),

                                            Container(
                                                width: 1,
                                                height: 40,
                                                color: const Color(0xFFE2E8F0)),

                                            // ACTION BUTTONS
                                            SizedBox(
                                              width: 70,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CustomButton(
                                                    width: 28,
                                                    height: 25,
                                                    onTap: () {
                                                      controller.noOfChildren.text = controller.childSeatAlert[index].sets.toString();
                                                      controller.childAge.text = controller.childSeatAlert[index].age.toString();
                                                      setState(() {
                                                        editingIndex = index;
                                                      });
                                                      controller.update();
                                                    },
                                                    verticalPadding: 0.0,
                                                    borderRadius: 6,
                                                    widget: Icon(
                                                      Icons.edit_calendar,
                                                      color: DynamicColors.whiteClr,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  CustomButton(
                                                    width: 28,
                                                    height: 25,
                                                    onTap: () {
                                                      controller.childSeatAlert.remove(
                                                        controller.childSeatAlert[index],
                                                      );
                                                      controller.update();
                                                    },
                                                    verticalPadding: 0.0,
                                                    btnColor:
                                                        DynamicColors.redClr,
                                                    borderRadius: 6,
                                                    widget: Icon(
                                                      Icons.delete_forever,
                                                      color: DynamicColors
                                                          .whiteClr,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // CLOSE BUTTON (Bottom Right)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              width: 80,
                              height: 34,
                              btnColor: const Color(0xFFE2E8F0),
                              borderRadius: 6,
                              verticalPadding: 0,
                              onTap: () => Get.back(),
                              style: mozillaTextSemiBoldText(
                                fontSize: 12,
                                color: const Color(0xFF475569),
                              ),
                              btnText: "CLOSE",
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // SizedBox(
  //   height: 180,
  //   child: ListView.builder(
  //       itemCount: controller.childSeatAlert.length,
  //       physics: AlwaysScrollableScrollPhysics(),
  //       itemBuilder: (BuildContext context, index) {
  //         return Column(
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   child: Container(
  //                     height: 45,
  //                     alignment: Alignment.center,
  //                     child: Text(controller
  //                         .childSeatAlert[index].sets
  //                         .toString()),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Container(
  //                     height: 45,
  //                     alignment: Alignment.center,
  //                     child: Text(controller
  //                         .childSeatAlert[index].age
  //                         .toString()),
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Padding(
  //                       padding:
  //                           const EdgeInsets.only(left: 8.0),
  //                       child: CustomButton(
  //                         width: 30,
  //                         height: 25,
  //                         onTap: () {
  //                           controller.noOfChildren.text =
  //                               controller
  //                                   .childSeatAlert[index]
  //                                   .sets
  //                                   .toString();
  //                           controller.childAge.text =
  //                               controller
  //                                   .childSeatAlert[index].age
  //                                   .toString();
  //                           setState(() {
  //                             editingIndex = index;
  //                           });
  //                           controller.update();
  //                         },
  //                         verticalPadding: 0.0,
  //                         borderRadius: 6,
  //                         widget: Icon(
  //                           Icons.edit_document,
  //                           color: DynamicColors.whiteClr,
  //                           size: 15,
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding:
  //                           const EdgeInsets.only(left: 8.0),
  //                       child: CustomButton(
  //                         width: 30,
  //                         height: 25,
  //                         onTap: () {
  //                           controller.childSeatAlert.remove(
  //                               controller
  //                                   .childSeatAlert[index]);
  //                           controller.update();
  //                         },
  //                         verticalPadding: 0.0,
  //                         btnColor: DynamicColors.redClr,
  //                         borderRadius: 6,
  //                         widget: Icon(
  //                           Icons.delete_forever,
  //                           color: DynamicColors.whiteClr,
  //                           size: 15,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //             Divider(
  //               height: 10,
  //             )
  //           ],
  //         );
  //       }),
  // )

  Widget _buildFieldLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        labelText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class ChildSeatClass {
  String? age, sets;
  ChildSeatClass({this.age, this.sets});
}

class NoteClass {
  String? note, title;
  NoteClass({this.note, this.title});
}
