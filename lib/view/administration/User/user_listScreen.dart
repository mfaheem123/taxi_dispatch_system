import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/administration/User/administration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';

class UserListscreen extends StatefulWidget {
  UserListscreen({super.key});

  @override
  State<UserListscreen> createState() => _UserListscreenState();
}

class _UserListscreenState extends State<UserListscreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  AdministrationController controller =
      Get.isRegistered<AdministrationController>()
          ? Get.find<AdministrationController>()
          : Get.put(AdministrationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "driversList";
    controller.userData();
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          selectedRowIndex = (selectedRowIndex + 1) % totalRows; // move down
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          selectedRowIndex =
              (selectedRowIndex - 1 + totalRows) % totalRows; // move up
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        // Enter dabane par row ke action button ka kaam
        debugPrint("Row $selectedRowIndex Enter Pressed (Search/Delete)");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<AdministrationController>(builder: (controller) {
        return LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isMobile = maxWidth < 600;
          final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

          // Instead of fixed width, we calculate flexible field widths
          final double fieldWidth = isMobile
              ? maxWidth // full width
              : isTablet
                  ? maxWidth / 2
                  : maxWidth / 4;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "USER" + "(${controller.userModel?.count})",
                      style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                        value: controller.inActive.value,
                        onChanged: (v) {
                          controller.inActive.value = v!;
                          controller.update();
                        }),
                    Text(
                      AppText.inactive,
                      style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: DynamicColors.redClr),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    CustomButton(
                      height: 40,
                      width: 80,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      widget: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                        child: Icon(
                          Icons.refresh,
                          color: DynamicColors.whiteClr,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                controller.userLoading.value == true
                    ? Center(child: CircularProgressIndicator())
                    // : (controller.userModel?.employees == null ||
                    //         controller.userModel!.employees!.isEmpty)
                    //     ? const Center(child: Text("No users found"))
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: Get.width,
                              child: DatatableWidget(
                                columns: [
                                  DataColumn(
                                    label: Center(
                                      child: Checkbox(
                                        value: controller
                                            .subsDiaryAllSelection.value,
                                        onChanged: (v) {
                                          controller
                                              .subsDiaryAllSelection.value = v!;
                                          controller.update();
                                        },
                                      ),
                                    ),
                                  ),
                                  buildHeaderWithSearch(title: "USERNAME"),
                                  buildHeaderWithSearch(title: "EMAIL"),
                                  buildHeaderWithSearch(title: "PHONE #"),
                                  buildHeaderWithSearch(title: "FAX"),
                                  buildHeaderWithSearch(title: "ROLE"),
                                  buildHeaderWithSearch(title: "SUBSIDIARY"),
                                  buildHeaderWithSearch(
                                      title: "ACTIONS", removeSearching: true),
                                ],
                                totalRow:
                                    controller.userModel!.employees!.length,
                                rows: controller.userModel!.employees!
                                    .map((item) {
                                  return 
                                  DataRow(cells: [
  DataCell(
    Center(
      child: Checkbox(
        value: false,
        onChanged: (v) {},
      ),
    ),
  ),
  DataCell(Center(child: Text(item.username ?? 'no data'))),
  DataCell(Center(child: Text(item.email ?? 'no data'))),
  DataCell(Center(child: Text(item.phone ?? 'no data'))),
  DataCell(Center(child: Text(item.fax ?? 'no data'))),
  DataCell(Center(child: Text(item.role?.name ?? 'no data'))),
  DataCell(Center(child: Text(item.subsidiary?.name ?? 'no data'))),
  DataCell(Row(
    children: [
      IconButton(
        icon: Icon(Icons.edit_calendar),
        onPressed: () {},
      ),
      const Text("|"),
      IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () {},
      ),
    ],
  )),
])
;
                                }).toList(),
                              ),
                            ),
                          ),
              ],
            ),
          );
        });
      }),
    );
  }
}
