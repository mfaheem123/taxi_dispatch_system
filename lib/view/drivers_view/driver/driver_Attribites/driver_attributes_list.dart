import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../page_scroller.dart';

/// Data Model for Driver Attribute
class DriverAttributeItem {
  int id;
  String name;
  String shortName;

  DriverAttributeItem({
    required this.id,
    required this.name,
    required this.shortName,
  });
}

class DriverAttributesList extends StatefulWidget {
  const DriverAttributesList({super.key});

  @override
  State<DriverAttributesList> createState() => _DriverAttributesListState();
}

class _DriverAttributesListState extends State<DriverAttributesList> {
  // Master list of attributes
  final List<DriverAttributeItem> _attributes = [
    DriverAttributeItem(id: 1, name: "PET FRIENDLY", shortName: "PF"),
    DriverAttributeItem(id: 2, name: "WHEEL CHAIR", shortName: "WC"),
  ];

  // Filtered list displayed on table
  List<DriverAttributeItem> _filteredAttributes = [];

  // Filter Search strings
  String _searchName = "";
  String _searchShortName = "";

  // FocusNodes for Keyboard Navigation (Tab, Space, Enter)
  final FocusNode _addButtonFocusNode = FocusNode();
  final FocusNode _refreshButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _filteredAttributes = List.from(_attributes);
  }

  @override
  void dispose() {
    _addButtonFocusNode.dispose();
    _refreshButtonFocusNode.dispose();
    super.dispose();
  }

  // Filter logic
  void _applyFilter() {
    final attributeQuery = _searchName.trim().toLowerCase();
    final shortNameQuery = _searchShortName.trim().toLowerCase();

    setState(() {
      _filteredAttributes = _attributes.where((item) {
        final matchesAttribute = attributeQuery.isEmpty ||
            item.name.toLowerCase().contains(attributeQuery);
        final matchesShortName = shortNameQuery.isEmpty ||
            item.shortName.toLowerCase().contains(shortNameQuery);
        return matchesAttribute && matchesShortName;
      }).toList();
    });
  }

  // Reset filter
  void _clearFilter() {
    _searchName = "";
    _searchShortName = "";
    setState(() {
      _filteredAttributes = List.from(_attributes);
    });
  }

  // Refresh entire screen state
  void _refreshList() {
    _clearFilter();
    Get.snackbar(
      "Refreshed",
      "Driver Attributes list updated successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: DynamicColors.primaryClr,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 6,
    );
  }

  // Add / Edit Dialog
  void _showAddEditDialog({DriverAttributeItem? itemToEdit, int? indexToEdit}) {
    final isEditing = itemToEdit != null;
    final nameController = TextEditingController(text: isEditing ? itemToEdit.name : '');
    final shortNameController = TextEditingController(text: isEditing ? itemToEdit.shortName : '');

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
                        isEditing ? "EDIT DRIVER ATTRIBUTE" : "ADD DRIVER ATTRIBUTE",
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
                      controller: nameController,
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
                      controller: shortNameController,
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
                      onSubmitted: (_) {
                        _saveAttribute(
                          isEditing: isEditing,
                          itemToEdit: itemToEdit,
                          nameController: nameController,
                          shortNameController: shortNameController,
                        );
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
                          onTap: () {
                            _saveAttribute(
                              isEditing: isEditing,
                              itemToEdit: itemToEdit,
                              nameController: nameController,
                              shortNameController: shortNameController,
                            );
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

  void _saveAttribute({
    required bool isEditing,
    DriverAttributeItem? itemToEdit,
    required TextEditingController nameController,
    required TextEditingController shortNameController,
  }) {
    final name = nameController.text.trim().toUpperCase();
    final shortName = shortNameController.text.trim().toUpperCase();

    if (name.isEmpty || shortName.isEmpty) {
      Get.snackbar(
        "Required Fields",
        "Please enter both Attribute Name and Short Code.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade800,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      if (isEditing && itemToEdit != null) {
        itemToEdit.name = name;
        itemToEdit.shortName = shortName;
      } else {
        int nextId = 1;
        if (_attributes.isNotEmpty) {
          nextId = _attributes.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
        }
        _attributes.add(DriverAttributeItem(id: nextId, name: name, shortName: shortName));
      }
      _applyFilter();
    });

    Get.back();
  }

  // Delete Confirmation Dialog
  void _showDeleteDialog(DriverAttributeItem item) {
    final deleteFocusNode = FocusNode();
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
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, size: 48, color: DynamicColors.redClr),
                const SizedBox(height: 12),
                Text(
                  "DELETE ATTRIBUTE",
                  style: mozillaTextSemiBoldText(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Are you sure you want to delete '${item.name}'?",
                  textAlign: TextAlign.center,
                  style: outFitRegular(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      focusNode: cancelFocusNode,
                      onTap: () => Get.back(),
                      width: 90,
                      height: 34,
                      verticalPadding: 0.0,
                      borderRadius: 6,
                      btnText: "CANCEL",
                      btnColor: const Color(0xFF94A3B8),
                      style: mozillaTextSemiBoldText(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      focusNode: deleteFocusNode,
                      onTap: () {
                        setState(() {
                          _attributes.removeWhere((element) => element.id == item.id);
                          _applyFilter();
                        });
                        Get.back();
                      },
                      width: 90,
                      height: 34,
                      verticalPadding: 0.0,
                      borderRadius: 6,
                      btnText: "DELETE",
                      btnColor: DynamicColors.redClr,
                      style: mozillaTextSemiBoldText(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: FocusTraversalGroup(
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
                    color: DynamicColors.gryClr.withOpacity(0.5),
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
                                text: "${_attributes.length}",
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
                          onTap: () => _showAddEditDialog(),
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
                          onTap: _refreshList,
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

                  // ── Datatable Widget ──
                  SizedBox(
                    width: isMobile || isTablet ? Get.width + 600 : Get.width,
                    child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(
                          title: "S.NO",
                          removeSearching: true,
                        ),
                        buildHeaderWithSearch(
                          title: "NAME",
                          onChanged: (v) {
                            _searchName = v;
                            _applyFilter();
                          },
                        ),
                        buildHeaderWithSearch(
                          title: "SHORT NAME",
                          onChanged: (v) {
                            _searchShortName = v;
                            _applyFilter();
                          },
                        ),
                        buildHeaderWithSearch(
                          title: "ACTIONS",
                          removeSearching: true,
                        ),
                      ],
                      totalRow: _filteredAttributes.length,
                      rows: _filteredAttributes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final rowNumber = index + 1;

                        return DataRow(
                          cells: [
                            DataCell(Center(child: Text("$rowNumber"))),
                            DataCell(Center(child: Text(item.name.toUpperCase()))),
                            DataCell(Center(child: Text(item.shortName.toUpperCase()))),
                            DataCell(
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _FocusableButton(
                                    onTap: () => _showAddEditDialog(
                                      itemToEdit: item,
                                      indexToEdit: index,
                                    ),
                                    tooltip: "Edit",
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide.none,
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(32, 32),
                                      ),
                                      onPressed: () => _showAddEditDialog(
                                        itemToEdit: item,
                                        indexToEdit: index,
                                      ),
                                      child: Icon(
                                        Icons.edit_calendar,
                                        size: 28,
                                        color: DynamicColors.primaryClr,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _FocusableButton(
                                    onTap: () => _showDeleteDialog(item),
                                    tooltip: "Delete",
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide.none,
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(32, 32),
                                      ),
                                      onPressed: () => _showDeleteDialog(item),
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
