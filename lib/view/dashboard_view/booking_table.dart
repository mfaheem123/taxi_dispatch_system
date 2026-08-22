
import 'dart:convert';
import 'dart:ui';
import 'dart:ui' as html show window;
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../alert/cancel_booking_alert.dart';
import '../../alert/complete_alert.dart';
import '../../alert/delete_permission_alert.dart';
import '../../alert/dispatch_booking.dart';
import '../../alert/dispatch_booking_alert.dart';
import '../../alert/edit_booking_fare.dart';
import '../../alert/fob_alert.dart';
import '../../component/images.dart';
import '../../component/networks/api.dart';
import '../../component/pagination.dart';
import '../../component/text_field.dart';
import '../../routes/app_pages.dart';
import '../booking_view/update_booking.dart';
import 'Controller/dashboard_controller.dart';
import 'dashboard/F3_alert.dart';
import 'models/dashboard_model.dart';

class BookingTable extends StatefulWidget {
  @override
  State<BookingTable> createState() => _BookingTableState();
}

class _BookingTableState extends State<BookingTable> {

  late final DashboardController controller;

  int selectedRowIndex = 0; // currently selected row
  int totalRows = 10; // total rows (dynamic list ke hisaab se change hoga)

  /// Set to true whenever the user navigates to a new page; cleared once
  /// the first row's checkbox has received keyboard focus.
  bool _pendingFocusFirstRow = false;

  // skipTraversal: this node only exists to catch arrow keys for row navigation
  // and it covers the whole table, so landing on it via Tab highlights nothing
  // and reads as "Tab did nothing". It stays focusable, so autofocus and the
  // arrow-key handler are unaffected, and the first Tab press now steps from
  // here onto the first tab-strip button instead of onto an invisible node.
  final FocusNode _tableFocusNode = FocusNode(skipTraversal: true);

  /// FocusNode for the first tab button in the tab strip.
  /// When the user Tabs into the table, this receives focus so the user can
  /// select a tab before tabbing into the search fields and rows.
  final FocusNode _firstTabFocusNode = FocusNode();

  /// One FocusNode per table row — keeps keyboard focus in sync with selectedRowIndex.
  List<FocusNode> _rowFocusNodes = [];

  List permissions = [];

  /// Ensures _rowFocusNodes always matches the current data length.
  void _syncRowFocusNodes(int length) {
    if (_rowFocusNodes.length == length) return;
    // Dispose extras
    for (int i = length; i < _rowFocusNodes.length; i++) {
      _rowFocusNodes[i].dispose();
    }
    _rowFocusNodes = List.generate(length, (i) {
      return i < _rowFocusNodes.length ? _rowFocusNodes[i] : FocusNode();
    });
  }

  @override
  void initState() {
    // Ensure controller is available even if widget is built before route bindings complete.
    controller = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());
    permissions = Api().sp.read('all_permissions') ?? [];
    // Let the driver panel Tab into this table (after the last map button).
    controller.focusFirstTableRow = _focusFirstRow;
    setState(() {});
    super.initState();
  }

  /// Moves keyboard focus to the first tab button.
  /// Registered on the controller so the driver panel can hand focus off
  /// when the user Tabs past the last map button. The user can then
  /// Tab through the tabs, search fields, and finally into the rows.
  /// Returns false if there is nothing to focus.
  bool _focusFirstRow() {
    _firstTabFocusNode.requestFocus();
    return true;
  }

  @override
  void dispose() {
    // Only clear the hook if it still points at this instance.
    if (controller.focusFirstTableRow == _focusFirstRow) {
      controller.focusFirstTableRow = null;
    }
    _tableFocusNode.dispose();
    _firstTabFocusNode.dispose();
    for (final fn in _rowFocusNodes) fn.dispose();
    super.dispose();
  }

  /// Scrolls the row at [index] into view after an arrow-key move.
  ///
  /// Row focus is moved with a direct `requestFocus()`, and that — unlike Tab
  /// traversal, where FocusTraversalPolicy calls ensureVisible for you — never
  /// scrolls anything. So on a 50-row page the highlight kept walking past the
  /// bottom of the viewport with nothing on screen following it.
  ///
  /// [Scrollable.ensureVisible] walks up EVERY enclosing scroll view, so it
  /// moves both this table's own scroller and the shell page scroller in
  /// main_appbar.dart that ultimately holds it (inside the shell this table's
  /// scroller gets unbounded height and cannot scroll on its own).
  ///
  /// keepVisibleAtStart / keepVisibleAtEnd, chosen by direction, scroll by the
  /// minimum needed and refuse to move backwards — so a row already on screen
  /// stays put instead of the list jumping to re-centre it on every press.
  void _ensureRowVisible(int index, {required bool movingDown}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || index < 0 || index >= _rowFocusNodes.length) return;
      final rowContext = _rowFocusNodes[index].context;
      if (rowContext == null || !rowContext.mounted) return;
      Scrollable.ensureVisible(
        rowContext,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        alignmentPolicy: movingDown
            ? ScrollPositionAlignmentPolicy.keepVisibleAtEnd
            : ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    });
  }

  KeyEventResult _handleArrowKeys(FocusNode node, KeyEvent event) {
    // Only react on key-down / repeat, not key-up.
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final data = controller.dashboardTableModelData?.data;
    if (data == null || data.isEmpty) return KeyEventResult.ignored;
    final lastIndex = data.length - 1;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      final next = selectedRowIndex < 0 ? 0 : (selectedRowIndex + 1).clamp(0, lastIndex);
      setState(() => selectedRowIndex = next);
      // Move actual keyboard focus to the new row's checkbox
      if (next < _rowFocusNodes.length) _rowFocusNodes[next].requestFocus();
      _ensureRowVisible(next, movingDown: true);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      final prev = selectedRowIndex <= 0 ? 0 : (selectedRowIndex - 1).clamp(0, lastIndex);
      setState(() => selectedRowIndex = prev);
      // Move actual keyboard focus to the new row's checkbox
      if (prev < _rowFocusNodes.length) _rowFocusNodes[prev].requestFocus();
      _ensureRowVisible(prev, movingDown: false);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    double widthss = MediaQuery.of(context).size.width;
    // if(controller.allAddressesData.isNotEmpty){
    //   totalRows = 4;
    // }else{
    //   totalRows = 10;
    // }

    return Focus(
      focusNode: _tableFocusNode,
      autofocus: true,
      onKeyEvent: _handleArrowKeys,
      child: GetBuilder<DashboardController>(
          builder: (controller) {
            // Sync one FocusNode per row so arrow-key navigation keeps real focus in step.
            _syncRowFocusNodes(
                controller.dashboardTableModelData?.data?.length ?? 0);

            // After a page change, focus the first row's checkbox as soon as
            // the new page's widgets are laid out.
            if (_pendingFocusFirstRow && _rowFocusNodes.isNotEmpty) {
              _pendingFocusFirstRow = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_rowFocusNodes.isNotEmpty && mounted) {
                  _rowFocusNodes[0].requestFocus();
                  // A new page starts at its first row, so bring the top of the
                  // table back into view instead of leaving the reader wherever
                  // the previous page had been scrolled to.
                  _ensureRowVisible(0, movingDown: false);
                }
              });
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width,
                    // Bounded height is required: a horizontal viewport constrains its
                    // children in the cross axis, so inside this Column (which offers
                    // unbounded height) an unwrapped horizontal scroller throws
                    // "Horizontal viewport was given unbounded height."
                    child: SizedBox(
                      height: 40,
                      // A Row in a horizontal SingleChildScrollView, not ListView.builder:
                      // the builder only creates the items currently in view, and focus
                      // traversal can only move to nodes that EXIST — so Tab used to run
                      // out at the last built tab. Building every tab up front makes Tab
                      // walk the whole strip, and traversal scrolls each one into view.
                      child: FocusTraversalGroup(
                        // Pins the step order to the list index rather than leaving it to
                        // a geometry tie-break, so Tab / Shift+Tab go strictly
                        // left-to-right through the tabs, one per press.
                        policy: OrderedTraversalPolicy(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(), // smooth scrolling
                          child: Row(
                            children: List.generate(
                                controller.bookingTabsList!.length, (index) {
                              return FocusTraversalOrder(
                                order: NumericFocusOrder(index.toDouble()),
                                child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          // ONE focus ring for BOTH kinds of tab in this strip, so
                          // the indicator does not depend on CustomButton's internals.
                          child: _FocusRing(
                                  child: controller.bookingTabsList![index].dropDownList!.isEmpty? CustomButton(
                            focusNode: index == 0 ? _firstTabFocusNode : null,
                            width: widthss/11.5,
                            verticalPadding: 0,
                            borderRadius: 4,
                            // Transparent, not null: a non-null focusBorderColor is
                            // what suppresses CustomButton's default zoom cue (which
                            // this 40px strip crops). Transparent suppresses the zoom
                            // without drawing a second ring inside the one above.
                            focusBorderColor: Colors.transparent,
                            style: mozillaTextRegularText(
                              fontSize: widthss/135,
                              color: controller.bookingTabsList![index].deletedClr!.value == true?DynamicColors.whiteClr: DynamicColors.textClr,
                            ),
                            btnText: controller.bookingTabsList![index].deletedClr!.value == true ?controller.bookingTabsList![index].bookingTabs:
                            "${controller.bookingTabsList![index].bookingTabs}(${controller.bookingTabsList![index].bookingCount.toString()})",
                            btnColor: controller.bookingTabsList![index].deletedClr!.value == true ? DynamicColors.redClr:
                            controller.bookingTabsList![index].selectedClr!.value == true ? DynamicColors.primaryClr.withOpacity(0.4) : DynamicColors.secondaryClr,
                            onTap: () {
                              controller.dropDownShow.value = false;
                              if(controller.bookingTabsList![index].deletedClr!.value == true){
                                controller.deleteJobs();
                              }else{
                                controller.selectionIndex = index;
                                controller.temSelectedTab = index;
                                controller.getTableDataStatus(index: index);
                              }
                            },
                          ):

                          SizedBox(
                            width: widthss/11.5,
                            // The ring for this branch comes from the shared observer
                            // above; this only supplies the tab's background.
                            child: Container(
                              color: DynamicColors.secondaryClr,
                                    child: Focus(
                                      focusNode: index == 0 ? _firstTabFocusNode : null,
                                      child: DropdownButton<String>(
                                        value: controller.bookingTabsList![index].selectedDropDownValue,
                                        icon: const Icon(Icons.arrow_drop_down),
                                      isExpanded: true,
                                      hint: Text("JOB DUE BY",
                                        style: mozillaTextRegularText(
                                            fontSize: widthss/135,
                                            color: DynamicColors.textClr
                                        ),
                                      ),
                                      underline: const SizedBox(),
                                      items: controller.bookingTabsList![index].dropDownList!.map((item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item,
                                            style: mozillaTextRegularText(
                                                fontSize: 13,
                                                color: DynamicColors.textClr
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        controller.dropDownShow.value = false;
                                        print(controller.bookingTabsList![index].id);
                                        print(index);
                                        controller.selectionIndex = index;
                                        controller.getTableDataStatus(index: index, value: value);
                                        // });
                                      },
                                    ),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // _buildTabs(),


                  const SizedBox(height: 10),


                  if(permissions.contains('read_booking'))
                    controller.dashboardTableModelData == null?SizedBox():
                    SizedBox(
                      width: Get.width,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                        columnSpacing: widthss/80,
                        dataRowMinHeight: 40,
                        dataRowMaxHeight: 48,

                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        dataTextStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            width: 0.5,
                            color: Colors.grey.shade400,
                          ),
                          verticalInside: BorderSide(
                            width: 0.5,
                            color: Colors.grey.shade400, // 👈 vertical lines added
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        columns: [
                          buildHeaderWithSearch(widget: SizedBox(
                            width: 20,
                            child: Checkbox(value: false, onChanged: (v){
                            }),
                          )),
                          buildHeaderWithSearch(title: "TYPE"),
                          buildHeaderWithSearch(
                              widhtss: widthss/20.5,
                              title: "REF #", onChanged: (v){
                            controller.referenceNumber.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(
                              widhtss: widthss/20.5,
                              title: "DATETIME", onChanged: (v){
                            controller.pickupDate.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(
                              widhtss: widthss/20.5,
                              title: "CUS", onChanged: (v){
                            controller.name.text = v;
                            controller.getDashboardTableData(tableId: controller.selectedTabId);
                          }),
                          buildHeaderWithSearch(
                              widhtss: widthss/20.5,
                              title: "PICKUP", onChanged: (v){
                            controller.pickup.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(
                              widhtss: widthss/20.5,
                              title: "DROPOFF", onChanged: (v){
                            controller.dropOff.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(widhtss: widthss/20.5,title: "ACC", onChanged: (v){
                            controller.accountName.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(widhtss: widthss/20.5,title: "DRV", onChanged: (v){
                            controller.driverName.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(widhtss: widthss/20.5,title: "VEH", onChanged: (v){
                            controller.vehicleTypeName.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(widhtss: widthss/20.5,title: "NOTE", onChanged: (v){
                            controller.notes.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(widhtss: widthss/20.5,title: "FARE", onChanged: (v){
                            controller.fares.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(widhtss: widthss/20.5,title: "STATUS", onChanged: (v){
                            controller.bookingStatus.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(widhtss: widthss/20.5,title: "J/T", onChanged: (v){
                            controller.journeyType.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(widhtss: widthss/20.5,title: "P/T", onChanged: (v){
                            controller.paymentType.text = v;
                            controller.onTableChangeHandler(tableId: controller.selectedTabId.toString(),);
                          }),
                          buildHeaderWithSearch(widhtss: widthss/20.5,title: "Action"),
                        ],
                        rows: List.generate(
                          controller.dashboardTableModelData!.data!.length,
                              (index) {
                            final item = controller.dashboardTableModelData!.data![index];
                            bool isSelected = index == selectedRowIndex;
                            return DataRow(
                              key: ValueKey(item.id),
                              // index: index,
                              selected: isSelected,
                              color: MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                                  if (isSelected) {
                                    return Colors.blue.withOpacity(0.2);
                                  }
                                  return null;
                                },
                              ),

                              cells: [

                                DataCell(
                                  Builder(
                                    builder: (context) {
                                      return Focus(
                                        focusNode: _rowFocusNodes.length > index
                                            ? _rowFocusNodes[index]
                                            : null,
                                        onKeyEvent: (node, event) {
                                          if (event is KeyDownEvent &&
                                              (event.logicalKey == LogicalKeyboardKey.enter ||
                                                  event.logicalKey == LogicalKeyboardKey.space)) {
                                            final bool isCurrentlySelected =
                                                controller.selectedDeletesItems?.contains(item) ?? false;
                                            final value = !isCurrentlySelected;
                                            setState(() {
                                              controller.selectedDeletesItems ??= [];
                                              if (value) {
                                                controller.selectedDeletesItems!.add(item);
                                                selectedRowIndex = index;
                                              } else {
                                                controller.selectedDeletesItems!.remove(item);
                                                selectedRowIndex = -1;
                                              }
                                            });
                                            return KeyEventResult.handled;
                                          }
                                          return KeyEventResult.ignored;
                                        },
                                        child: Builder(
                                          builder: (context) {
                                            final hasFocus = Focus.of(context).hasFocus;
                                            return Container(
                                              decoration: hasFocus
                                                  ? BoxDecoration(
                                                      border: Border.all(color: Colors.blue, width: 2),
                                                      borderRadius: BorderRadius.circular(4),
                                                    )
                                                  : null,
                                              child: Checkbox(
                                                focusNode: FocusNode(skipTraversal: true),
                                                value: controller.selectedDeletesItems?.contains(item) ?? false,
                                                onChanged: (bool? value) {
                                                  if (value == null) return;
                                                  setState(() {
                                                    controller.selectedDeletesItems ??= [];
                                                    if (value) {
                                                      controller.selectedDeletesItems!.add(item);
                                                      selectedRowIndex = index;
                                                    } else {
                                                      controller.selectedDeletesItems!.remove(item);
                                                      selectedRowIndex = -1;
                                                    }
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /// TYPE ❌
                                DataCell(
                                  Icon(
                                    switch (item.bookingSource) {
                                      'web' => Icons.language,
                                      'app' => Icons.phone_android,
                                      'ivr' => Icons.phone_in_talk,
                                      'dashboard' => Icons.laptop_chromebook,
                                      _ => Icons.help_outline,
                                    },
                                    color: Colors.blue,
                                  ),
                                ),

                                /// REF # ✅
                                DataCell(
                                  rightClickTextCell(
                                    item: item,
                                    tabIndex: controller.selectionIndex,
                                    onRightClick: () {
                                      print("RIGHT CLICK REF #: ${item.referenceNumber}");
                                    },
                                    child: Text(item.referenceNumber ?? "-",
                                      style: TextStyle(
                                        fontSize: widthss/140,
                                      ),
                                    ),
                                  ),
                                ),

                                /// DATETIME ✅
                                DataCell(
                                  rightClickTextCell(
                                    item: item,
                                    tabIndex: controller.selectionIndex,
                                    onRightClick: () {
                                      print("RIGHT CLICK DATETIME: ${item.pickupDate}");
                                    },
                                    child: Container(
                                      width: widthss/20.5,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      // APPLY YOUR COLOR HERE
                                      decoration: BoxDecoration(
                                        color: DynamicColors.secondaryClr.withOpacity(0.7),
                                        // Optional: borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text("${DateFormat('dd-MM-yyyy')
                                          .format(item.pickupDate!)} ${item.pickupTime}",
                                        style: TextStyle(
                                          fontSize: widthss/140,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// CUSTOMER ✅
                                DataCell(
                                  SizedBox(
                                    width: widthss/20.5,
                                    child: rightClickTextCell(
                                      item: item,
                                      tabIndex: controller.selectionIndex,
                                      onRightClick: () {
                                        print("RIGHT CLICK CUSTOMER: ${item.name}");
                                      },
                                      child: Text(item.name?.toUpperCase() ?? "-".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: widthss/140,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// PICKUP ✅
                                DataCell(
                                  rightClickTextCell(
                                    item: item,
                                    tabIndex: controller.selectionIndex,
                                    // onRightClick: () {
                                    //   print("RIGHT CLICK PICKUP: ${item.pickup}");
                                    //   showMenu(
                                    //     context: context,
                                    //     position: RelativeRect.fromLTRB(
                                    //       // event.position.dx,
                                    //       // event.position.dy,
                                    //       15,
                                    //       0,
                                    //       0,
                                    //       0,
                                    //     ),
                                    //     items: [
                                    //       const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    //       const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                    //     ],
                                    //   );
                                    //
                                    // },
                                    child: Container(
                                      width: widthss/20.5,
                                      // width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      // APPLY YOUR COLOR HERE
                                      decoration: BoxDecoration(
                                        color: item.airport!.pickup!.locationType!.backgroundColor == null?Colors.transparent:
                                        Color(int.parse("0xFF${item.airport!.pickup!.locationType!.backgroundColor}")),
                                        // Optional: borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        item.pickup?.toUpperCase() ?? "-".toUpperCase(),
                                        style: mozillaTextRegularText(
                                          fontSize: widthss/140,
                                          color: item.airport!.pickup!.locationType!.foregroundColor == null?DynamicColors.black:
                                          Color(int.parse("0xFF${item.airport!.pickup!.locationType!.foregroundColor}")),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),

                                /// DROPOFF ✅
                                DataCell(
                                  rightClickTextCell(
                                    item: item,
                                    tabIndex: controller.selectionIndex,
                                    child: Container(
                                      width: widthss / 20.5,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.transparent
                                            : (item.airport!.dropoff!.locationType!.backgroundColor == null
                                            ? Colors.transparent
                                            : Color(int.parse("0xFF${item.airport!.dropoff!.locationType!.backgroundColor}"))),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // 1. Dropoff Text
                                          Expanded(
                                            child: Text(
                                              (item.dropoff ?? "-").toUpperCase(),
                                              style: mozillaTextRegularText(
                                                fontSize: widthss / 140,
                                                color: item.airport!.dropoff!.locationType!.foregroundColor == null
                                                    ? DynamicColors.black
                                                    : Color(int.parse("0xFF${item.airport!.dropoff!.locationType!.foregroundColor}")),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          // 2. VIA Tag with Multi-Address Hover Tooltip
                                          if (item.viapoints != null && item.viapoints!.isNotEmpty) ...[
                                            const SizedBox(width: 4),
                                            Tooltip(
                                              richMessage: WidgetSpan(
                                                child: Container(
                                                  padding: const EdgeInsets.all(6),
                                                  constraints: const BoxConstraints(maxWidth: 250),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: item.viapoints!.asMap().entries.map((entry) {
                                                      int index = entry.key;
                                                      var via = entry.value;
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                        child: Text(
                                                          "${index + 1}. ${via.viapoint ?? 'No address'}",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              waitDuration: const Duration(milliseconds: 200),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade100,
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: Colors.blue.shade300, width: 0.8),
                                                ),
                                                child: Text(
                                                  "VIA",
                                                  style: TextStyle(
                                                    fontSize: widthss / 160,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                /// ACCOUNT ✅
                                DataCell(
                                  rightClickTextCell(
                                    item: item,
                                    tabIndex: controller.selectionIndex,
                                    onRightClick: () {
                                      print("RIGHT CLICK ACCOUNT: ${item.account?.name}");
                                    },
                                    child: Container(
                                        width: widthss/20.5,
                                        height: double.infinity,
                                        alignment: Alignment.center,

                                        // APPLY YOUR COLOR HERE
                                        decoration: BoxDecoration(
                                          color: item.account!.backgroundColor == null?Colors.transparent: Color(int.parse("0xFF${item.account!.backgroundColor}")),
                                          // Optional: borderRadius: BorderRadius.circular(2),
                                        ),
                                        child: Text(item.account?.name?.toUpperCase() ?? "".toUpperCase(),
                                          style: mozillaTextRegularText(
                                            fontSize: widthss/140,
                                            color: item.account!.foregroundColor == null?DynamicColors.black: Color(int.parse("0xFF${item.account!.foregroundColor}")),
                                          ),
                                        )),
                                  ),
                                ),
                                /// DRIVER ✅
                                DataCell(
                                  SizedBox(
                                    width: widthss/20.5,
                                    child: rightClickTextCell(
                                      item: item,
                                      tabIndex: controller.selectionIndex,
                                      onRightClick: () {
                                        print("RIGHT CLICK DRIVER: ${item.driver?.name}");
                                      },
                                      child: Text(item.driver?.name?.toUpperCase() ?? "",
                                        style: TextStyle(
                                          fontSize: widthss/140,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// VEHICLE ✅
                                DataCell(
                                  rightClickTextCell(
                                    item: item,
                                    tabIndex: controller.selectionIndex,
                                    onRightClick: () {
                                      print("RIGHT CLICK VEHICLE: ${item.vehicleType?.name}");
                                    },
                                    child: Container(
                                      width: widthss/20.5,
                                      height: double.infinity,
                                      alignment: Alignment.center,

                                      // APPLY YOUR COLOR HERE
                                      decoration: BoxDecoration(
                                        color: item.vehicleType!.backgroundColor == null?Colors.transparent: Color(int.parse("0xFF${item.vehicleType!.backgroundColor}")),
                                        // Optional: borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(item.vehicleType?.name?.toUpperCase() ?? "-".toUpperCase(),
                                        style: mozillaTextRegularText(
                                          fontSize: widthss/140,
                                          color: item.vehicleType!.foregroundColor == null?DynamicColors.black: Color(int.parse("0xFF${item.vehicleType!.foregroundColor}")),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// NOTE ✅
                                DataCell(
                                  rightClickTextCell(
                                    item: item,
                                    tabIndex: controller.selectionIndex,
                                    // onRightClick: () {
                                    //   print("RIGHT CLICK NOTE");
                                    // },
                                    child: SizedBox(
                                      width: widthss/20.5,
                                      child: Text(
                                        item.notes!.isEmpty ? "".toUpperCase() : item.notes![0].note?.toUpperCase() ?? "-",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: widthss/140,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// FARE ✅
                                DataCell(
                                  SizedBox(
                                    width: widthss/20.5,
                                    child: rightClickTextCell(
                                      item: item,
                                      tabIndex: controller.selectionIndex,
                                      // onRightClick: () {
                                      //   print("RIGHT CLICK FARE: ${item.fares}");
                                      // },
                                      child: Text("£ ${item.fares ?? "0.00"}",
                                        style: TextStyle(
                                          fontSize: widthss/140,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// STATUS ✅
                                DataCell(
                                  rightClickTextCell(
                                    item: item,
                                    tabIndex: controller.selectionIndex,
                                    // onRightClick: () {
                                    //   print("RIGHT CLICK STATUS");
                                    // },
                                    child: Container(
                                      width: widthss/20.5,
                                      height: double.infinity,
                                      alignment: Alignment.center,

                                      // APPLY YOUR COLOR HERE
                                      decoration: BoxDecoration(
                                        color: DynamicColors.statusColor,
                                        // Optional: borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        "${item.bookingStatus!.bookingStatus}".toUpperCase(),
                                        style: TextStyle(color: DynamicColors.whiteClr,
                                          fontSize: widthss/140,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// J/T ✅
                                DataCell(
                                  SizedBox(
                                    width: widthss/20.5,
                                    child: rightClickTextCell(
                                      item: item,
                                      tabIndex: controller.selectionIndex,
                                      onRightClick: () {
                                        print("RIGHT CLICK JOURNEY TYPE");
                                      },
                                      child: Text(item.journeyType?.journeyType?.toUpperCase() ?? "-",
                                        style: TextStyle(
                                          fontSize: widthss/140,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// P/T ✅
                                DataCell(
                                  rightClickTextCell(
                                    item: item,
                                    tabIndex: controller.selectionIndex,
                                    onRightClick: () {

                                      print("RIGHT CLICK PAYMENT TYPE");
                                    },
                                    child: Container(
                                        width: widthss/19.5,
                                        height: double.infinity,
                                        alignment: Alignment.center,

                                        // APPLY YOUR COLOR HERE
                                        decoration: BoxDecoration(
                                          color: DynamicColors.primaryClr,
                                          // Optional: borderRadius: BorderRadius.circular(2),
                                        ),
                                        child: Text(item.paymentType?.name?.toUpperCase() ?? "-",
                                          style: TextStyle(
                                            color: DynamicColors.whiteClr,
                                            fontSize: widthss/140,
                                          ),
                                        )),
                                  ),
                                ),

                                /// ACTIONS ❌
                                DataCell(
                                  Row(

                                    children: [
                                      IconButton(
                                        icon:  Icon(Icons.arrow_forward, color: Colors.green),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => DispatchBooking(bookingItem: item),
                                          );
                                        },
                                      ),
                                      Text("|"),
                                      if(permissions.contains('delete_booking'))  IconButton(
                                        icon:  Icon(Icons.delete_forever, color: Colors.red),
                                        onPressed: () {
                                          // showShortcutDialog(
                                          //   context,
                                          //   title: "Delete",
                                          //   contentWidget: const Text("Are you sure?"),
                                          // );
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                DeletePermissionAlert(
                                                  deleteFunctionName: (){
                                                    controller.deleteBooking(item.id);
                                                  },
                                                ),
                                          );
                                        },
                                      ),
                                      Text("|"),
                                      if(permissions.contains('update_booking')) Expanded(
                                        child: IconButton(
                                          icon:  Icon(Icons.more_horiz, color: Colors.green),
                                          onPressed: () async {
                                            controller.dashBoardDataBinding(id: item.id!);
                                            // Get.to(UpdateBooking(data: item.id,));

                                            //   final newTabUrl =
                                            //       "${Uri.base.origin}${Routes.updateBooking}?data=${item.id}";
                                            //     // final newTabUrl = Uri.base.origin + Routes.updateBooking;
                                            // if (await canLaunchUrl(Uri.parse(newTabUrl))) {
                                            //   await launchUrl(
                                            //   Uri.parse(newTabUrl),
                                            //   mode: LaunchMode.externalApplication,
                                            //   );
                                            //   } else {
                                            //   throw 'Could not launch $newTabUrl';
                                            //   }


                                            // Instead of launchUrl
                                            // Navigator.pushNamed(
                                            //   context,
                                            //   Routes.updateBooking,
                                            //   arguments: item.id,
                                            // );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  PaginationWidget(
                      currentPage: controller.dashboardTableCurrentPage.value,
                      totalPages: controller.dashboardTableTotalPages.value,
                      onPageChange: (page) {
                        // Mark that we need to focus the first row once the
                        // new page data has loaded and the widget rebuilds.
                        _pendingFocusFirstRow = true;
                        selectedRowIndex = 0;
                        controller.dashboardTablePageChange(page);
                      }),
                ],
              ),
            );
          }
      ),
    );
  }






  // 1. Right Click Wrapper
  Widget rightClickTextCell({
    required Widget child,
    required dynamic item,
    required tabIndex,
    VoidCallback? onRightClick,

  }) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {

          if (onRightClick != null) onRightClick();

          final overlayState = Overlay.maybeOf(context);
          final overlayObject = overlayState?.context.findRenderObject();
          if (overlayObject is! RenderBox) {
            return;
          }
          final RenderBox overlay = overlayObject;
          final RelativeRect position = RelativeRect.fromRect(
            Rect.fromPoints(event.position, event.position),
            Offset.zero & overlay.size,
          );

          showRowContextMenu(
              context: context,
              position: position,
              globalPosition: event.position,
              item: item,
              tabIndex: tabIndex
          );
        }
      },
      child: child,
    );
  }

  List<NestedMenuItem> _makeMenus(BuildContext context) {
    return [
      NestedMenuItem(title: "CUSTOMERS", children: [
        NestedMenuItem(
          title: "ADD CUSTOMER",
          onTap: () {

          },
        ),
      ]),
    ];
  }

// 1. Pehle context menu dikhane wala main function
  void showRowContextMenu({
    required BuildContext context,
    required RelativeRect position,
    required Offset globalPosition,
    required dynamic item,
    required tabIndex
  }) async {
    print("--- Context Menu Debug ---");
    print("TabIndex Value: $tabIndex");
    print("TabIndex Type: ${tabIndex.runtimeType}");
    print("--------------------------");
    print("DEBUG: tabIndex is $tabIndex and type is ${tabIndex.runtimeType}");


    _hideSubMenu();

    // Humne width fix rakhi hai taake submenu ki calculation asaan ho
    const double menuWidth = 200.0;

    await showMenu<String>(
      context: context,
      position: position,
      color: Colors.white,
      constraints: const BoxConstraints(minWidth: menuWidth, maxWidth: menuWidth),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        if (tabIndex != 2 && tabIndex != 3 && tabIndex != 4)
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            child: Builder(
                builder: (innerContext) {
                  return MouseRegion(
                    onEnter: (_) {
                      // Yahan hum innerContext use kar rahe hain jo menu item ki location dega
                      _showSubMenu(innerContext, [
                        if (tabIndex != 1) {'title': 'DISPATCH', 'icon': Icons.near_me},
                        if (tabIndex != 1) {'title': 'FOLLOW ON', 'icon': Icons.sync},
                        if (tabIndex != 1) {'title': 'SMS', 'icon': Icons.chat_bubble},
                        if(tabIndex == 1) {'title': 'FUTURE', 'icon': Icons.timelapse},
                      ], item);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _buildMenuRow(Icons.local_shipping, "DISPATCH", true),
                    ),
                  );
                }
            ),
          ),
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          child: Builder(
              builder: (innerContext) {
                return MouseRegion(
                  onEnter: (_){
                    _showSubMenu(innerContext, [
                      if (tabIndex == 4) {'title': 'ACCEPT', 'icon':Icons.thumb_up_alt_rounded},
                      if (tabIndex == 4) {'title': 'DECLINE', 'icon':Icons.thumb_down},
                      if(tabIndex != 3) {'title': 'COMPLETE', 'icon': Icons.task_alt},
                      {'title': 'COPY', 'icon': Icons.copy},
                      {'title': 'AUDIT REPORT', 'icon': Icons.description},
                      {'title': 'UPDATE', 'icon': Icons.update},
                      if (tabIndex != 2) {'title': 'CANCEL', 'icon': Icons.block},
                      if (tabIndex != 2) {'title': 'ALLOCATE', 'icon': Icons.manage_accounts},
                      if(tabIndex !=3) {'title': 'EDIT FARE', 'icon': Icons.edit_note},
                      if (tabIndex == 0 || tabIndex == 1 || tabIndex == 2) {'title': 'RECOVER', 'icon': Icons.settings_backup_restore},
                      {'title': 'CALL CUSTOMER', 'icon': Icons.phone},
                    ], item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _buildMenuRow(
                        Icons.build_circle_outlined, "ACTIONS", true),
                  ),
                );
              }
          ),
        ),
        if (tabIndex != 4)
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            child: Builder(
                builder: (innerContext) {
                  return MouseRegion(
                    onEnter: (_) {
                      _showSubMenu(innerContext, [
                        if (tabIndex == 2) {'title': 'RESEND DISPATCH SMS', 'icon': Icons.send},
                        if (tabIndex != 2) {'title': 'EMAIL', 'icon': Icons.email},
                        if (tabIndex != 2) {'title': 'SMS', 'icon': Icons.sms},
                      ], item);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _buildMenuRow(Icons.share, "SEND", true),
                    ),
                  );
                }
            ),
          ),
      ],
    );
    _hideSubMenu();
  }



  OverlayEntry? _subMenuEntry;

  void _hideSubMenu() {
    _subMenuEntry?.remove();
    _subMenuEntry = null;
  }

// 2. Submenu function jo RenderBox use karega (Dor jane wala masla khatam)
  void _showSubMenu(BuildContext itemContext, List<Map<String, dynamic>> subItems, dynamic item) {
    _hideSubMenu();

    // Ye main menu item ki position nikaal raha hai
    final renderObject = itemContext.findRenderObject();
    if (renderObject is! RenderBox) {
      return;
    }
    final RenderBox renderBox = renderObject;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final screenWidth = MediaQuery.of(itemContext).size.width;
    final screenHeight = MediaQuery.of(itemContext).size.height;
    const double subMenuWidth = 200.0;

    final double subMenuHeight = (subItems.length * 38.0) + 12.0;

    // Logic: Menu ke right side par space check karein
    double xPos = offset.dx + size.width - 5; // 5px overlap for smooth feel

    // Agar right side pe jagah nahi hai (Table ke end columns mein), to left side pe dikhayen
    if (xPos + subMenuWidth > screenWidth) {
      xPos = offset.dx - subMenuWidth + 5;
    }


    double yPos = offset.dy - 5;

    // Check: Agar niche jagah kam hai aur list screen se niche ja rahi hai
    if (yPos + subMenuHeight > screenHeight) {
      // To menu ko upar ki taraf khol do (Bottom alignment with item)
      yPos = (offset.dy + size.height) - subMenuHeight + 5;
    }

    _subMenuEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: xPos,
        top: yPos, // Menu item ke barabar alignment
        child: MouseRegion(
          onExit: (_) => _hideSubMenu(),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Container(
              width: subMenuWidth,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: subItems.map((sub) => InkWell(
                  onTap: () {
                    _hideSubMenu();
                    Navigator.pop(itemContext); // Main menu band karein
                    _handleSubMenuAction(itemContext, sub['title'], item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Icon(sub['icon'], size: 18, color: Colors.blueGrey.shade800),
                        const SizedBox(width: 12),
                        Text(sub['title'],
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
        ),
      ),
    );

    final overlayState = Overlay.maybeOf(itemContext);
    if (overlayState == null) {
      return;
    }
    overlayState.insert(_subMenuEntry!);
  }


  void _handleSubMenuAction(BuildContext context, String title, dynamic item) {
    if (title == "DISPATCH") {
      showDialog(
        context: context,
        builder: (context) => DispatchBooking(bookingItem: item), // Aapki existing class
      );
    } else if (title == "SMS") {
      // SMS wala Alert
      showShortcutDialog(
        context,
        title: "Send SMS",
        contentWidget: const Text("Do you want to send a notification?"),
      );
    } else if (title == "FOLLOW ON") {
      // Follow on logic
      showDialog(
        context: context,
        builder: (context) => DispatchFobAlert(bookingItem: item),
      );
    }
    else if (title == "COMPLETE") {
      showDialog(
        context: context,
        builder: (context) => CompleteBookingAlert(bookingId: item.id,
            bookingItem: item),
      );
    }
    else if (title == "CANCEL") {
      showDialog(
        context: context,
        builder: (context) => CancelBookingRequest(bookingId: item.id,
            bookingItem: item),
      );
    }
    else if (title == "EDIT FARE") {
      showDialog(
        context: context,
        builder: (context) => EditBookingFare(bookingId: item.id,
            bookingItem: item),
      );
    }
    else if(title == "RECOVER"){
      controller.recoverBooking(item.id);
    }
  }





// 3. Helper for Menu UI
  Widget _buildMenuRow(IconData icon, String title, bool hasArrow) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey.shade800),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black)
              )
          ),
          if (hasArrow) const Icon(Icons.arrow_right, size: 20, color: Colors.grey),
        ],
      ),
    );
  }
}


DataColumn buildHeaderWithSearch({String? title,removeSearching = false, Widget? widget, textFieldHeight, double? fontSize, Widget? customWidget, Function(String)? onChanged,
  TextEditingController? controller,
  FocusNode? focusNode,
  double? widhtss
}) {
  return DataColumn(
    label: Expanded(
      child: widget?? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title!, style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 13
          )),
          SizedBox(height: 4),
          title == "TYPE" || removeSearching == true
              ? SizedBox.shrink()
              : customWidget
              ?? SizedBox(
                width: widhtss??100,
                height: textFieldHeight??28,
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  onChanged: onChanged,
                  inputFormatters: [UpperCaseTextFormatter()],
                  onTap: () {
                    shortCutKeyValue.value = "tableSelected";
                  },
                  style: mozillaTextRegularText(
                      fontWeight: FontWeight.w800, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: mozillaTextRegularText(
                        fontWeight: FontWeight.w800,
                        color: DynamicColors.textClr.withOpacity(0.8),
                        fontSize: 12),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
        ],
      ),
    ),
  );

}
/// Draws a bold ring around whatever it wraps while that subtree holds keyboard
/// focus. Used by the booking-tab strip so the indicator works for both the
/// CustomButton tabs and the "JOB DUE BY" DropdownButton, without depending on
/// either widget's internals.
///
/// Two details are load-bearing, both verified against the framework:
///
/// 1. Focus is read via [Focus.onFocusChange] and kept in local state, NOT via
///    `Focus.of(context).hasFocus` in a Builder. _FocusState._handleFocusChanged
///    only calls setState when hasPrimaryFocus / canRequestFocus /
///    descendantsAre*able change — never for a plain hasFocus change. Because
///    this wrapper sets canRequestFocus: false it can never hold primary focus,
///    so the inherited scope would never rebuild and the ring would go stale.
///    onFocusChange, by contrast, is invoked unconditionally with hasFocus.
///
/// 2. foregroundDecoration is ALWAYS non-null and only its colour changes.
///    Toggling it between null and a decoration adds/removes a DecoratedBox,
///    which remounts the child subtree — that destroys the wrapped button's
///    FocusNode mid-traversal and drops focus back to an ancestor, so Tab
///    appears to stick instead of advancing.
class _FocusRing extends StatefulWidget {
  const _FocusRing({required this.child, this.width = 3, this.radius = 4});

  final Widget child;
  final double width;
  final double radius;

  @override
  State<_FocusRing> createState() => _FocusRingState();
}

class _FocusRingState extends State<_FocusRing> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      // Observer only: the button or dropdown inside stays the single Tab stop.
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (hasFocus) {
        if (hasFocus != _focused) setState(() => _focused = hasFocus);
      },
      child: Container(
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            color: _focused ? DynamicColors.primaryClr : Colors.transparent,
            width: widget.width,
          ),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: widget.child,
      ),
    );
  }
}
