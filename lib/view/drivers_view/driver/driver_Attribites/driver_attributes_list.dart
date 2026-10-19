import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../page_scroller.dart';
import '../../controller/driver_attribute_controller.dart';
import '../../model/driver_attribute_model.dart';

class DriverAttributesList extends StatefulWidget {
  const DriverAttributesList({super.key});

  @override
  State<DriverAttributesList> createState() => _DriverAttributesListState();
}

class _DriverAttributesListState extends State<DriverAttributesList> {
  DriverAttributeController controller = Get.isRegistered<DriverAttributeController>()
      ? Get.find<DriverAttributeController>()
      : Get.put(DriverAttributeController());

  // FocusNodes for Keyboard Navigation (Tab, Space, Enter)
  final FocusNode _addButtonFocusNode = FocusNode();
  final FocusNode _refreshButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "DriverAttributesList";
    controller.getDriverAttributes();
  }

  @override
  void dispose() {
    _addButtonFocusNode.dispose();
    _refreshButtonFocusNode.dispose();
    super.dispose();
  }

  // Add / Edit Dialog
  void _showAddEditDialog({DriverAttribute? itemToEdit}) {
    if (itemToEdit != null) {
      controller.bindData(itemToEdit);
    } else {
      controller.clearForm();
    }

    final nameFocusNode = FocusNode();
    final shortNameFocusNode = FocusNode();
    final saveFocusNode = FocusNode();
    final cancelFocusNode = FocusNode();

    Get.dialog(
      KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
            Get.back();
          }
        },
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(20),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        itemToEdit != null ? "EDIT DRIVER ATTRIBUTE" : "ADD DRIVER ATTRIBUTE",
                        style: mozillaTextSemiBoldText(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                      )
                    ],
                  ),
                  const Divider(height: 20, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 10),

                  // Attribute Name Field
                  Text(
                    "ATTRIBUTE NAME",
                    style: outFitRegular(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(1),
                    child: TextField(
                      controller: controller.attributeNameController,
                      focusNode: nameFocusNode,
                      autofocus: true,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: "E.G. PET FRIENDLY",
                        hintStyle: outFitRegular(fontSize: 13, color: const Color(0xFF94A3B8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: DynamicColors.primaryClr, width: 2),
                        ),
                      ),
                      onSubmitted: (_) => FocusScope.of(Get.context!).requestFocus(shortNameFocusNode),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Short Name Field
                  Text(
                    "SHORT CODE",
                    style: outFitRegular(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(2),
                    child: TextField(
                      controller: controller.shortNameController,
                      focusNode: shortNameFocusNode,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: "E.G. PF",
                        hintStyle: outFitRegular(fontSize: 13, color: const Color(0xFF94A3B8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: DynamicColors.primaryClr, width: 2),
                        ),
                      ),
                      onSubmitted: (_) async {
                        bool success = await controller.saveDriverAttribute();
                        if (success) {
                          Get.back();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(4),
                        child: CustomButton(
                          focusNode: cancelFocusNode,
                          onTap: () => Get.back(),
                          width: 80,
                          height: 34,
                          verticalPadding: 0.0,
                          borderRadius: 6,
                          btnText: "CANCEL",
                          btnColor: DynamicColors.redClr,
                          style: mozillaTextSemiBoldText(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(3),
                        child: CustomButton(
                          focusNode: saveFocusNode,
                          onTap: () async {
                            bool success = await controller.saveDriverAttribute();
                            if (success) {
                              Get.back();
                            }
                          },
                          width: 80,
                          height: 34,
                          verticalPadding: 0.0,
                          borderRadius: 6,
                          btnText: "SAVE",
                          btnColor: DynamicColors.primaryClr,
                          style: mozillaTextSemiBoldText(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Delete Confirmation Dialog
  // void _showDeleteDialog(DriverAttribute item) {
  //   final deleteFocusNode = FocusNode();
  //   final cancelFocusNode = FocusNode();
  //
  //   Get.dialog(
  //     KeyboardListener(
  //       focusNode: FocusNode(),
  //       onKeyEvent: (event) {
  //         if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
  //           Get.back();
  //         }
  //       },
  //       child: Dialog(
  //         backgroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //         child: Container(
  //           width: 380,
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Icon(Icons.warning_amber_rounded, size: 48, color: DynamicColors.redClr),
  //               const SizedBox(height: 12),
  //               Text(
  //                 "DELETE ATTRIBUTE",
  //                 style: mozillaTextSemiBoldText(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: const Color(0xFF1E293B),
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 "Are you sure you want to delete '${item.attributeName ?? ''}'?",
  //                 textAlign: TextAlign.center,
  //                 style: outFitRegular(
  //                   fontSize: 13,
  //                   color: const Color(0xFF64748B),
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               const SizedBox(height: 24),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   CustomButton(
  //                     focusNode: cancelFocusNode,
  //                     onTap: () => Get.back(),
  //                     width: 90,
  //                     height: 34,
  //                     verticalPadding: 0.0,
  //                     borderRadius: 6,
  //                     btnText: "CANCEL",
  //                     btnColor: const Color(0xFF94A3B8),
  //                     style: mozillaTextSemiBoldText(
  //                       fontSize: 12,
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 16),
  //                   CustomButton(
  //                     focusNode: deleteFocusNode,
  //                     onTap: () async {
  //                       await controller.deleteDriverAttribute(item.id);
  //                       Get.back();
  //                     },
  //                     width: 90,
  //                     height: 34,
  //                     verticalPadding: 0.0,
  //                     borderRadius: 6,
  //                     btnText: "DELETE",
  //                     btnColor: DynamicColors.redClr,
  //                     style: mozillaTextSemiBoldText(
  //                       fontSize: 12,
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<DriverAttributeController>(
        builder: (controller) {
          return FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth;
                final bool isMobile = maxWidth < 600;
                final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // ── Top Header Bar ──
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        // color: DynamicColors.gryClr,
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "DRIVER ATTRIBUTES ",
                                    style: mozillaTextSemiBoldText(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      color: DynamicColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "(",
                                    style: mozillaTextSemiBoldText(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      color: DynamicColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${controller.allAttributes.length}",
                                    style: mozillaTextSemiBoldText(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      color: DynamicColors.primaryClr,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ")",
                                    style: mozillaTextSemiBoldText(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      color: DynamicColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            _FocusableButton(
                              focusNode: _addButtonFocusNode,
                              onTap: ()
                              => _showAddEditDialog(),
                              tooltip: "Add New Attribute",
                              child: CustomButton(
                                height: 38,
                                width: 42,
                                verticalPadding: 0.0,
                                borderRadius: 4,
                                btnColor: DynamicColors.primaryClr,
                                widget: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _FocusableButton(
                              focusNode: _refreshButtonFocusNode,
                              onTap: () => controller.getDriverAttributes(),
                              tooltip: "Refresh List",
                              child: CustomButton(
                                height: 38,
                                width: 42,
                                verticalPadding: 0.0,
                                borderRadius: 4,
                                btnColor: DynamicColors.primaryClr,
                                widget: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Datatable Widget or Loading ──
                      controller.isLoading.value && controller.allAttributes.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : SizedBox(
                              width: isMobile || isTablet ? Get.width + 600 : Get.width,
                              child: DatatableWidget(
                                columns: [
                                  // buildHeaderWithSearch(
                                  //   title: "S.NO",
                                  //   removeSearching: true,
                                  // ),
                                  buildHeaderWithSearch(
                                    title: "NAME",
                                    onChanged: (v) {
                                      controller.searchName.value = v;
                                      controller.filterAttributes();
                                    },
                                  ),
                                  buildHeaderWithSearch(
                                    title: "SHORT NAME",
                                    onChanged: (v) {
                                      controller.searchShortName.value = v;
                                      controller.filterAttributes();
                                    },
                                  ),
                                  buildHeaderWithSearch(
                                    title: "ACTIONS",
                                    removeSearching: true,
                                  ),
                                ],
                                totalRow: controller.filteredAttributes.length,
                                rows: controller.filteredAttributes.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  // final rowNumber = index + 1;

                                  return DataRow(
                                    cells: [
                                      // DataCell(Center(child: Text("$rowNumber"))),
                                      DataCell(Center(
                                        child: Text((item.attributeName ?? '').toUpperCase()),
                                      )),
                                      DataCell(Center(
                                        child: Text((item.shortName ?? '').toUpperCase()),
                                      )),
                                      DataCell(
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            _FocusableButton(
                                              onTap: () =>
                                                  // print("Edit button pressed"),
                                                  _showAddEditDialog(
                                                itemToEdit: item),
                                              tooltip: "Edit",
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide.none,
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: const Size(32, 32),
                                                ),
                                                onPressed: () =>
                                                    // print("Edit button pressed"),
                                                  _showAddEditDialog(
                                                  itemToEdit: item),
                                                child: Icon(
                                                  Icons.edit_calendar,
                                                  size: 28,
                                                  color: DynamicColors.primaryClr,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            _FocusableButton(
                                              onTap: () async {
                                                await controller.deleteDriverAttribute(item.id);
                                                Get.back();
                                              },
                                              tooltip: "Delete",
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide.none,
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: const Size(32, 32),
                                                ),
                                                onPressed: () async {
                                                   await controller.deleteDriverAttribute(item.id);
                                                   Get.back();
                                                              } ,
                                                  // _showDeleteDialog(item),
                                                child: Icon(
                                                  Icons.delete_forever,
                                                  size: 28,
                                                  color: DynamicColors.redClr,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Custom Focusable Button that provides visual focus state (border ring)
/// and triggers onTap on Space / Enter keys and Mouse Clicks.
class _FocusableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? tooltip;
  final FocusNode? focusNode;

  const _FocusableButton({
    required this.child,
    required this.onTap,
    this.tooltip,
    this.focusNode,
  });

  @override
  State<_FocusableButton> createState() => _FocusableButtonState();
}

class _FocusableButtonState extends State<_FocusableButton> {
  late FocusNode _node;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _node = widget.focusNode ?? FocusNode();
    _node.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _node.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _node.dispose();
    } else {
      _node.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        widget.onTap();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _node,
      onKeyEvent: _handleKeyEvent,
      child: Tooltip(
        message: widget.tooltip ?? '',
        child: InkWell(
          canRequestFocus: false,
          onTap: () {
            _node.requestFocus();
            widget.onTap();
          },
          borderRadius: BorderRadius.circular(4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: _isFocused
                  ? Border.all(color: DynamicColors.primaryClr, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
