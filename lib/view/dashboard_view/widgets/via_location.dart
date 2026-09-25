import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../Model/via_point.dart';
import '../../../component/alert_close_button.dart';
import '../../../component/escape_dismissible.dart';
import '../../../component/text_field.dart';
import '../models/all_addresses_model.dart';

class ViaTextEditingControllerClass {
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  ViaTextEditingControllerClass(this.name, this.mobile);
}

class ViaLocation extends StatefulWidget {
  const ViaLocation({super.key, this.formController});

  /// The booking form this dialog edits the via points of.
  ///
  /// A dialog is its own route, so it is NOT under the opening screen's
  /// [BookingFormScope] and cannot read the form off its context. Screens that
  /// run a detached form of their own — the edit screen — therefore pass their
  /// instance in at the call site. Left null it falls back to the dashboard's
  /// permanent instance, which is what every dashboard-side caller wants.
  final DashboardController? formController;

  @override
  State<ViaLocation> createState() => _ViaLocationState();
}

class _ViaLocationState extends State<ViaLocation> {

  final TextEditingController outboundAddressController = TextEditingController();
  final TextEditingController returnAddressController = TextEditingController();

  final FocusNode outboundFocusNode = FocusNode();
  final FocusNode returnFocusNode = FocusNode();
  final FocusNode outboundAddBtnFocusNode = FocusNode();
  final FocusNode returnAddBtnFocusNode = FocusNode();

  final GlobalKey outboundKey = GlobalKey();
  final GlobalKey returnKey = GlobalKey();

  late final DashboardController _controller =
      widget.formController ?? Get.find<DashboardController>();

  final ScrollController _viaDialogScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.allAddressesData.clear();
      _controller.selectedModel = null;
      _controller.selectedTextFieldsValue.value = "";
      _controller.activeFieldKey.value = null;

      outboundFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _viaDialogScrollController.dispose();
    outboundAddressController.dispose();
    returnAddressController.dispose();
    outboundAddBtnFocusNode.dispose();
    returnAddBtnFocusNode.dispose();
    super.dispose();
  }

  void _addViaPoint({required bool isReturnWay, required TextEditingController addressCtrl}) {
    String currentTypeName = isReturnWay ? 'via with return' : 'via';
    int currentTypeCount = _controller.viaPoints.where((p) => p.withReturnWay == currentTypeName).length;

    if (currentTypeCount < 6) {
      if (_controller.selectedModel != null) {
        _controller.polylinePoints.add(
          LatLng(_controller.selectedModel!.lat!, _controller.selectedModel!.lon!),
        );
        _controller.viaPoints.add(ViaPoint(
          withReturnWay: currentTypeName,
          address: _controller.selectedModel!.name!,
          lat: _controller.selectedModel!.lat!,
          lng: _controller.selectedModel!.lon!,
        ));

        addressCtrl.clear();
        _controller.selectedModel = null;
        _controller.allAddressesData.clear();
        _controller.selectedTextFieldsValue.value = "";

        _controller.viaTextEditingController.add(
          ViaTextEditingControllerClass(TextEditingController(), TextEditingController()),
        );
        _controller.update();
      } else {
        BotToast.showText(text: "PLEASE SELECT AN ADDRESS FROM SUGGESTION LIST FIRST");
      }
    } else {
      BotToast.showText(text: "MAXIMUM 6 OF '$currentTypeName' ALLOWED");
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Everything the dialog is made of EXCEPT the scrolling list: its inset
    // padding, the title bar, the form's own padding, the gap, the divider and
    // the button row. The list is capped at whatever is left, so a long list
    // scrolls inside the dialog instead of pushing the buttons off the bottom
    // of the screen — the old flat 80% of the screen height did not leave room
    // for any of this and overflowed once a few viapoints were added.
    const double chromeHeight = 240;
    final double listMaxHeight =
        (screenHeight - chromeHeight).clamp(200.0, double.infinity);
    // And a floor, so the dialog opens at a usable size rather than collapsing
    // to a title bar and two buttons when the trip has no viapoints yet.
    final double listMinHeight =
        (screenHeight * 0.45).clamp(0.0, listMaxHeight);
    return EscapeDismissible(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: GetBuilder<DashboardController>(
          tag: _controller.formTag,
          builder: (controller) {
            final bool isReturnJourney = controller.jourValue == 'R/N';

            return Container(
              key: controller.stackKey,
              width: isReturnJourney ? 850 : 550,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          color: DynamicColors.gryClr.withOpacity(0.5),
                          child: Row(
                            children: [
                              Icon(Icons.route, color: DynamicColors.primaryClr),
                              const SizedBox(width: 10),
                              Text("VIAPOINT(S) MANAGEMENT",
                                  style: titleDesign()),
                              const Spacer(),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(999),
                                child: const AlertCloseButton(),
                              ),
                            ],
                          )),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: listMinHeight,
                                maxHeight: listMaxHeight,
                              ),
                              child: SingleChildScrollView(
                                controller: _viaDialogScrollController,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // OUTBOUND TRIP
                                    Expanded(
                                        child: FocusTraversalOrder(
                                          order: const NumericFocusOrder(1),
                                      child: _buildTripColumn(
                                        title: "OUTBOUND TRIP",
                                        addressCtrl: outboundAddressController,
                                        focusNode: outboundFocusNode,
                                        fieldKey: outboundKey,
                                        isReturnSection: false,
                                        controller: controller,
                                      ),
                                    )),

                                    // RETURN TRIP
                                    if (isReturnJourney) ...[
                                      const SizedBox(width: 16),
                                      Container(width: 1, color: Colors.grey.shade300),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: FocusTraversalOrder(
                                            order: const NumericFocusOrder(2),
                                        child: _buildTripColumn(
                                          title: "RETURN TRIP",
                                          addressCtrl: returnAddressController,
                                          focusNode: returnFocusNode,
                                          fieldKey: returnKey,
                                          isReturnSection: true,
                                          controller: controller,
                                        ),
                                      )),
                                    ],
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            Divider(),
                            SizedBox(height: 12),
                            //  ACTION BUTTONS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onPressed: () {
                                      controller.viaMilsCondition = false;
                                      Navigator.pop(context);
                                    },
                                    child: Text("CANCEL", style: mozillaTextSemiBoldText(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 30,
                                  child: TextButton.icon(
                                    style: TextButton.styleFrom(
                                      backgroundColor: DynamicColors.primaryClr,
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onPressed: () {
                                      controller.viaMilsCondition = true;
                                      int len = controller.viaPoints.length;
                                      for (int a = 0; a < len && a < controller.viaTextEditingController.length; a++) {
                                        controller.viaPoints[a].name = controller.viaTextEditingController[a].name.text;
                                        controller.viaPoints[a].mobile = controller.viaTextEditingController[a].mobile.text;
                                      }
                                      controller.fetchRouteFromOSRM();
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check, color: Colors.white, size: 18),
                                    label: Text("APPLY CHANGES", style: mozillaTextSemiBoldText(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // --- SUGGESTIONS OVERLAY ---
                  Obx(() {
                    if (controller.selectedTextFieldsValue.value != "via") {
                      return const SizedBox.shrink();
                    }
                    if (controller.allAddressesData.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final GlobalKey<State<StatefulWidget>>? activeKey = controller.activeFieldKey.value;
                    final RenderBox? fieldBox = activeKey?.currentContext?.findRenderObject() as RenderBox?;
                    final RenderBox? stackBox = controller.stackKey.currentContext?.findRenderObject() as RenderBox?;
                    double top = 100.0;
                    double left = 0.0;
                    double width = Get.width / 4;

                    if (fieldBox != null && stackBox != null) {
                      final Offset localOffset = fieldBox.localToGlobal(Offset.zero, ancestor: stackBox);
                      width = fieldBox.size.width;
                      top = localOffset.dy + fieldBox.size.height;
                      left = localOffset.dx;
                    }

                    final activeAddressController = (activeKey == returnKey)
                        ? returnAddressController
                        : outboundAddressController;

                    return Positioned(
                      top: top,
                      left: left,
                      width: width,
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        autofocus: true,
                        onKeyEvent: (KeyEvent event) {
                          if (event is KeyDownEvent) {
                            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                              controller.moveHighlightDown(viaConditionValue: false);
                            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                              controller.moveHighlightUp(viaConditionValue: false);
                            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                              final selected = controller.allAddressesData[controller.suggestionSelectedIndex.value];
                              controller.selectedModel = selected;
                              activeAddressController.text = "${selected.name} ${selected.postcode}".toUpperCase();

                              controller.allAddressesData.clear();
                              controller.update();

                              if (activeKey == returnKey) {
                                returnFocusNode.requestFocus();
                              } else {
                                outboundFocusNode.requestFocus();
                              }
                            }
                          }
                        },
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFEFF0F2),
                          child: SizedBox(
                            height: screenHeight * 0.3,
                            child: Obx(() => ListView.builder(
                              key: controller.suggestionListKey,
                              controller: controller.suggestionScrollController,
                              itemCount: controller.allAddressesData.length,
                              padding: const EdgeInsets.only(top: 5),
                              itemBuilder: (context, index) {
                                final item = controller.allAddressesData[index];
                                return Obx(() {
                                  final isHighlighted = controller.highlightedIndex.value == index;
                                  return Material(
                                    key: controller.suggestionItemKeys[index],
                                    color: isHighlighted ? const Color(0xffA0DCFF) : Colors.transparent,
                                    child: ListTile(
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      title: Text(
                                        "${item.name} ${item.postcode}".toUpperCase(),
                                        style: outFitRegular(
                                          fontSize: 12,
                                          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                          color: isHighlighted ? Colors.blue : Colors.black,
                                        ),
                                      ),
                                      onTap: () {
                                        controller.selectedModel = item;
                                        activeAddressController.text = "${item.name} ${item.postcode}".toUpperCase();
                                        controller.allAddressesData.clear();
                                        controller.selectedTextFieldsValue.value = "";
                                        controller.update();

                                        if (activeKey == returnKey) {
                                          returnFocusNode.requestFocus();
                                        } else {
                                          outboundFocusNode.requestFocus();
                                        }
                                      },
                                    ),
                                  );
                                });
                              },
                            )),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildTripColumn({
    required String title,
    required TextEditingController addressCtrl,
    required bool isReturnSection,
    required DashboardController controller,
    required FocusNode focusNode,
    required GlobalKey<State<StatefulWidget>> fieldKey,
  }) {
    final String targetType = isReturnSection ? 'via with return' : 'via';
    final filteredList = controller.viaPoints.where((p) => p.withReturnWay == targetType).toList();

    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            children: [
              // TABLE HEADER
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: Center(
                          child: Text("#", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                      Container(width: 1, color: const Color(0xFFCBD5E1)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          // child: RawKeyboardListener(
                          //   focusNode: controller.searchingAddressViaFocusNode,
                          //   onKey: (event) {
                          //     if (event is RawKeyDownEvent) {
                          //       if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                          //           controller.highlightedIndex.value < controller.suggestions.length - 1) {
                          //         controller.highlightedIndex.value++;
                          //       } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                          //           controller.highlightedIndex.value > 0) {
                          //         controller.highlightedIndex.value--;
                          //       } else if (event.logicalKey == LogicalKeyboardKey.enter &&
                          //           controller.suggestions.isNotEmpty) {
                          //         final selected = controller.suggestions[controller.highlightedIndex.value].name;
                          //         controller.selectSuggestion(selected);
                          //       }
                          //     }
                          //   },
                          //   child: SizedBox(
                              child: Row(
                                children: [
                                  Expanded(
                              child: FocusTraversalOrder(
                              order: const NumericFocusOrder(1),
                                    child: Focus(
                                      onKeyEvent: (node, event) {
                                        if (event is KeyDownEvent) {
                                          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {

                                            controller.moveHighlightDown(viaConditionValue: false);
                                            return KeyEventResult.handled;
                                          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                                            controller.moveHighlightUp(viaConditionValue: false);
                                            return KeyEventResult.handled;
                                          }
                                        }
                                        return KeyEventResult.ignored;
                                      },
                                      child: CustomTextField(
                                        key: fieldKey,
                                        focusNode: focusNode,
                                        controller: addressCtrl,
                                        // textCapitalization: TextCapitalization.characters,
                                        inputFormatters: [UpperCaseTextFormatter()],
                                        onTap: () {
                                          controller.selectedTextFieldsValue.value = "via";
                                          controller.activeFieldKey.value = fieldKey;
                                        },
                                        onChanged: (v) {
                                          if (v.isEmpty) {
                                            controller.allAddressesData.clear();
                                            controller.selectedModel = null;
                                            controller.selectedTextFieldsValue.value = "";
                                          } else {
                                            controller.selectedTextFieldsValue.value = "via";
                                            controller.activeFieldKey.value = fieldKey;
                                            controller.onChangeHandler(fieldName: "via", searchingText: v);
                                          }
                                        },
                                        onSubmitted: (_) {
                                          if (controller.allAddressesData.isNotEmpty) {
                                            final index = controller.highlightedIndex.value;
                                            if (index >= 0 && index < controller.allAddressesData.length) {
                                              final selected = controller.allAddressesData[index];
                                              controller.selectedModel = selected;
                                              addressCtrl.text = "${selected.name} ${selected.postcode}".toUpperCase();

                                              controller.allAddressesData.clear();
                                              controller.selectedTextFieldsValue.value = "";
                                              controller.update();

                                              focusNode.requestFocus();
                                            }
                                          }
                                        },
                                          hintText: isReturnSection ? "SEARCH RETURN ADDRESS..." : "SEARCH ADDRESS...",
                                          hintStyle: outFitRegular(fontSize: 11),
                                          fillColor: Colors.white,
                                        borderRadius: 6,
                                        ),
                                      ),
                                    )),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 34,
                                    height: double.infinity,
                                    child: FocusTraversalOrder(
                                      order: const NumericFocusOrder(2),
                                    child: ElevatedButton(
                                      focusNode: isReturnSection ? returnAddBtnFocusNode : outboundAddBtnFocusNode,
                                      onPressed: () => _addViaPoint(isReturnWay: isReturnSection, addressCtrl: addressCtrl),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: DynamicColors.primaryClr,
                                        padding: EdgeInsets.zero,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        // ),
                      // ),
                      Container(width: 1, color: const Color(0xFFCBD5E1)),
                      SizedBox(
                        width: 52,
                        child: Center(
                          child: Text(
                            "ACTION",
                            style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // TABLE
              if (filteredList.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFCBD5E1)),
                  itemBuilder: (context, index) {
                    final point = filteredList[index];
                    final mainIndex = controller.viaPoints.indexOf(point);

                    return Container(
                      color: Colors.white,
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: Center(
                                child: Text('${index + 1}', style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                            Container(width: 1, color: const Color(0xFFCBD5E1)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                  child: FocusTraversalGroup(
                                      policy: WidgetOrderTraversalPolicy(),
                                  child: Focus(
                                    canRequestFocus: false,
                                    skipTraversal: true,
                                      child: TextField(
                                        focusNode: FocusNode(skipTraversal: true, canRequestFocus: false),
                                        style: outFitRegular(fontSize: 11, fontWeight: FontWeight.w600),
                                        readOnly: true,
                                        controller: TextEditingController(text: point.address.toUpperCase()),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                          fillColor: Color(0xFFFAFAFA),
                                          filled: true,
                                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
                                        ),
                                      ),
                                    ))),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 30,
                                            child: FocusTraversalOrder(
                                              order: NumericFocusOrder(3 + (index * 3)),
                                            child: TextField(
                                              textCapitalization: TextCapitalization.characters,
                                              inputFormatters: [UpperCaseTextFormatter()],
                                              style: outFitRegular(fontSize: 11),
                                              controller: mainIndex < controller.viaTextEditingController.length
                                                  ? controller.viaTextEditingController[mainIndex].name
                                                  : TextEditingController(),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                                hintText: "NAME",
                                                hintStyle: outFitRegular(fontSize: 10),
                                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
                                              ),
                                            ),
                                          ),
                                        )),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: SizedBox(
                                            height: 30,
                                            child: FocusTraversalOrder(
                                              order: NumericFocusOrder(4 + (index * 3)),
                                            child: TextField(
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              style: outFitRegular(fontSize: 11),
                                              controller: mainIndex < controller.viaTextEditingController.length
                                                  ? controller.viaTextEditingController[mainIndex].mobile
                                                  : TextEditingController(),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                                hintText: "MOBILE",
                                                hintStyle: outFitRegular(fontSize: 10),
                                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
                                              ),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(width: 1, color: const Color(0xFFCBD5E1)),
                            SizedBox(
                              width: 52,
                              child: Center(
                                child: SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: FocusTraversalOrder(
                                    order: NumericFocusOrder(5 + (index * 3)),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (mainIndex != -1) {
                                        controller.viaPoints.removeAt(mainIndex);
                                        if (mainIndex < controller.viaTextEditingController.length) {
                                          controller.viaTextEditingController.removeAt(mainIndex);
                                        }
                                        controller.update();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF4D4D),
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    child: const Icon(Icons.delete, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    ));
  }
}