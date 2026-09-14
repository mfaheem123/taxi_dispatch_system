import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';
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
  String? editingType;

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
            final bool isReturnTrip = controller.jourValue == 'W/R';
            final double dialogWidth = isReturnTrip ? 950.0 : 500.0;

            return SizedBox(
                width: dialogWidth,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          color: DynamicColors.gryClr.withOpacity(0.5),
                          child: Row(
                            children: [
                              Icon(Icons.info,
                                  color: DynamicColors.primaryClr, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                "BOOKING ADDITIONAL INFO",
                                style: mozillaTextSemiBoldText(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel(
                                          "SPECIAL REQUIREMENTS (PASSENGER VISIBLE)"),
                                      CustomTextField(
                                        maxLines: 3,
                                        height: 70,
                                        hintText: AppText.specialRequirements,
                                        controller: dashBoardCntrl
                                            .specialRequirementsController,
                                        hintStyle: mozillaTextRegularText(
                                            fontSize: 10),
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        borderRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isReturnTrip) ...[
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildFieldLabel(
                                            "RETURN SPECIAL REQUIREMENTS"),
                                        CustomTextField(
                                          maxLines: 3,
                                          height: 70,
                                          hintText:
                                              'RETURN SPECIAL REQUIREMENTS',
                                          controller: dashBoardCntrl
                                              .specialRequirementsReturnController,
                                          hintStyle: mozillaTextRegularText(
                                              fontSize: 10),
                                          contentPadding: EdgeInsets.all(10),
                                          borderRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.0),
                              child:
                                  Divider(height: 1, color: Color(0xFFE2E8F0)),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel(
                                          "CONTROLLER NOTES (INTERNAL)"),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              hintText: "ENTER NEW NOTE...",
                                              controller: controller
                                                  .controllerNoteController,
                                              hintStyle: mozillaTextRegularText(
                                                  fontSize: 10),
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
                                            onTap: () {
                                              if (controller
                                                  .controllerNoteController
                                                  .text
                                                  .isNotEmpty) {
                                                if (editingIndex != null) {
                                                  controller.controllerAlert[
                                                          editingIndex!] =
                                                      NoteClass(
                                                    note: controller
                                                        .controllerNoteController
                                                        .text,
                                                    title: 'controller note',
                                                  );
                                                  editingIndex = null;
                                                } else {
                                                  controller.controllerAlert
                                                      .add(
                                                    NoteClass(
                                                      note: controller
                                                          .controllerNoteController
                                                          .text,
                                                      title: 'controller note',
                                                    ),
                                                  );
                                                }
                                                controller
                                                    .controllerNoteController
                                                    .clear();
                                                controller.update();
                                              }
                                            },
                                            verticalPadding: 0.0,
                                            borderRadius: 6,
                                            widget: Icon(Icons.add,
                                                size: 18,
                                                color: DynamicColors.whiteClr),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      _buildNotesList(
                                        controller: controller,
                                        filterType: 'controller note',
                                      ),
                                    ],
                                  ),
                                ),
                                if (isReturnTrip) ...[
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildFieldLabel(
                                              "RETURN CONTROLLER NOTES"),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomTextField(
                                                  contentPadding:
                                                      EdgeInsets.only(left: 12),
                                                  hintText:
                                                      "ENTER NEW RETURN NOTES...",
                                                  controller: controller
                                                      .controllerNoteReturnController,
                                                  hintStyle:
                                                      mozillaTextRegularText(
                                                          fontSize: 10),
                                                  borderRadius: 6,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              CustomButton(
                                                width: 35,
                                                height: 35,
                                                btnColor:
                                                    DynamicColors.primaryClr,
                                                onTap: () {
                                                  if (controller
                                                      .controllerNoteReturnController
                                                      .text
                                                      .isNotEmpty) {
                                                    if (editingIndex != null && editingType == 'controller return note') {
                                                      controller.controllerAlert[editingIndex!] = NoteClass(
                                                        note: controller.controllerNoteReturnController.text,
                                                        title: 'controller return note',
                                                      );
                                                      editingIndex = null;
                                                      editingType = null;
                                                    } else {
                                                      // Add new note if not editing
                                                      controller.controllerAlert.add(
                                                        NoteClass(
                                                          note: controller.controllerNoteReturnController.text,
                                                          title: 'controller return note',
                                                        ),
                                                      );
                                                    }
                                                    controller.controllerNoteReturnController.clear();
                                                    controller.update();
                                                  }
                                                },
                                                verticalPadding: 0.0,
                                                borderRadius: 4,
                                                widget: Icon(Icons.add,
                                                    size: 18,
                                                    color:
                                                        DynamicColors.whiteClr),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),

                                          // List of Return Controller Notes
                                          _buildNotesList(
                                            controller: controller,
                                            filterType:
                                                'controller return note',
                                          ),
                                        ]),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 20),

                            // 3. ACTION BUTTONS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomButton(
                                  width: 85,
                                  height: 34,
                                  btnColor: const Color(0xFFE2E8F0),
                                  borderRadius: 6,
                                  verticalPadding: 0,
                                  onTap: () => Get.back(),
                                  style: mozillaTextSemiBoldText(
                                    fontSize: 12,
                                    color: const Color(0xFF475569),
                                  ),
                                  btnText: AppText.cancel.toUpperCase(),
                                ),
                                const SizedBox(width: 8),
                                CustomButton(
                                  width: 120,
                                  height: 34,
                                  btnColor: DynamicColors.primaryClr,
                                  borderRadius: 6,
                                  verticalPadding: 0,
                                  onTap: () => Get.back(),
                                  widget: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check,
                                          color: DynamicColors.whiteClr,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        "APPLY INFO",
                                        style: mozillaTextSemiBoldText(
                                          fontSize: 12,
                                          color: DynamicColors.whiteClr,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]));
          },
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        labelText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNotesList({
    required DashboardController controller,
    required String filterType,
  }) {
    final filteredList = controller.controllerAlert
        .asMap()
        .entries
        .where((entry) => entry.value.title == filterType)
        .toList();

    if (filteredList.isEmpty) return const SizedBox.shrink();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 150),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: filteredList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final originalIndex = filteredList[index].key;
          final noteItem = filteredList[index].value;
          final bool isReturn = filterType == 'controller return note';

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    noteItem.note ?? "",
                    style: mozillaTextSemiBoldText(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // EDIT BUTTON - Opens into its matching TextField
                CustomButton(
                  width: 30,
                  height: 28,
                  btnColor: DynamicColors.primaryClr,
                  borderRadius: 6,
                  verticalPadding: 0,
                  onTap: () {
                    if (isReturn) {
                      controller.controllerNoteReturnController.text =
                          noteItem.note!;
                      controller.controllerNoteController.clear();
                    } else {
                      controller.controllerNoteController.text = noteItem.note!;
                      controller.controllerNoteReturnController.clear();
                    }
                    setState(() {
                      editingIndex = originalIndex;
                      editingType = noteItem.title;
                    });
                    controller.update();
                  },
                  widget:
                      Icon(Icons.edit, color: DynamicColors.whiteClr, size: 14),
                ),
                const SizedBox(width: 4),

                // DELETE BUTTON
                CustomButton(
                  width: 30,
                  height: 28,
                  btnColor: DynamicColors.redClr,
                  borderRadius: 6,
                  verticalPadding: 0,
                  onTap: () {
                    controller.controllerAlert.removeAt(originalIndex);
                    controller.update();
                  },
                  widget: Icon(Icons.delete,
                      color: DynamicColors.whiteClr, size: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
