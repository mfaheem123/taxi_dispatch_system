import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/shortcut_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../Controller/dashboard_controller.dart';
import '../booking_table.dart';
import '../widgets/via_location.dart';
import 'booking_form_widget.dart';
import 'drivers.dart';
import 'map_view_widget.dart';

class ByDefaultDashboard extends StatefulWidget {
  ByDefaultDashboard({super.key,
  this.onTap,
  });
  final GestureTapCallback? onTap;

  @override
  State<ByDefaultDashboard> createState() => _ByDefaultDashboardState();
}

class _ByDefaultDashboardState extends State<ByDefaultDashboard> {

  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    print(width);
    print(width);
    print(width);
    print(width);

    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        return RawKeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent) {
              final key = event.logicalKey;
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                width: screenWidth,
                decoration: BoxDecoration(color: DynamicColors.secondaryClr),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Wrap(
                    spacing: 10, // horizontal gap
                    runSpacing: 8, // vertical gap when wrapped
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           ShortcutKeyWidget(),
                           ShortcutKeyWidget(keyss: "F2",valuess: "BOOKING FORM"),
                           ShortcutKeyWidget(keyss: "F3",valuess: "DRIVER VEHICLE"),
                           ShortcutKeyWidget(keyss: "F4",valuess: "DRIVER EARNING"),
                           ShortcutKeyWidget(keyss: "F6",valuess: "QUOTATION"),
                          width >= 1900 ?
                          Spacer():SizedBox.shrink(),
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: CustomButton(
                              width: 120,
                              height: 35,
                              borderRadius: 6,
                              verticalPadding: 0,
                              style: mozillaTextSemiBoldText(
                                  fontSize: 11,
                                  color: DynamicColors.whiteClr
                              ),
                              onTap: (){
                                dashboardController.hideDashBoard.value = !dashboardController.hideDashBoard.value;
                                dashboardController.update();
                              },
                              btnText:dashboardController.hideDashBoard.value? "HIDE DASHBOARD":"SHOW DASHBOARD",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
                Stack(
                  key: dashboardController.stackKey,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Visibility(
                            visible: dashboardController.hideDashBoard.value,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: width <= 1366 ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.007,
                                  ),
                                  BookingFormWidget(),
                                  SizedBox(width: screenWidth * 0.011),

                                  /// todo MAP SECTION
                                  MapViewWidget(),
                                  /// todo MAP SECTION
                                  SizedBox(width: screenWidth * 0.0133),

                                  //Driver
                                  DriversView(),
                                ],
                              ):Column(
                                children: [
                                  BookingFormWidget(),
                                  Row(
                                    children: [
                                      /// todo MAP SECTION
                                      MapViewWidget(),
                                      /// todo MAP SECTION
                                      SizedBox(width: screenWidth * 0.0133),

                                      //Driver
                                      DriversView(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: BookingTable(),
                              )),
                        ],
                      ),
                    ),
                    // SizedBox(height: 12),
                    Obx(() {
                      if (dashboardController.suggestions.isEmpty) return SizedBox();
                      final GlobalKey<State<StatefulWidget>>? activeKey =
                          dashboardController.activeFieldKey.value;
                      final RenderBox? fieldBox = activeKey?.currentContext
                          ?.findRenderObject() as RenderBox?;
                      final RenderBox? stackBox =
                      dashboardController.stackKey.currentContext?.findRenderObject()
                      as RenderBox?;

                      double top = 0.0;
                      double left = 0.0;
                      double width = screenWidth;

                      if (fieldBox != null && stackBox != null) {
                        final Offset localOffset = fieldBox
                            .localToGlobal(Offset.zero, ancestor: stackBox);
                        final double fieldHeight = fieldBox.size.height;
                        width = fieldBox.size.width;
                        top = localOffset.dy + fieldHeight;
                        left = localOffset.dx;
                      }

                      return Positioned(
                        top: top,
                        left: left,
                        width: width,
                        child: Container(
                          height: screenHeight * 0.4,
                          decoration: BoxDecoration(
                            color: Color(0xFFEFF0F2),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: dashboardController.suggestions
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              String suggestion = entry.value;
                              bool isHighlighted = index == dashboardController.highlightedIndex.value;
                              return Container(
                                color: isHighlighted ? Color(0xffA0DCFF) : null,
                                child: ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  title: Text(suggestion,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isHighlighted
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isHighlighted
                                            ? Colors.blue
                                            : Colors.black,
                                      )),
                                  onTap: () {
                                    // dashboardController.selectSuggestion(suggestion);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget buildChip(String label, {bool isFirst = false, bool isLast = false}) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          border: Border.all(color: Colors.blue.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

}
