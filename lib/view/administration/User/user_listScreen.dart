import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
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
        final users = controller.userModel?.employees ?? [];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "USER (7)",
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
              controller.userLoading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.all(Colors.grey[200]),
                          dataRowMinHeight: 48,
                          dataRowMaxHeight: 56,
                          headingTextStyle: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                          dataTextStyle: TextStyle(
                            fontSize: 10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color:
                                      DynamicColors.textClr.withOpacity(0.5))),
                          columns: [
                            buildHeaderWithSearch(title: "USERNAME"),
                            buildHeaderWithSearch(title: "EMAIL"),
                            buildHeaderWithSearch(title: "PHONE #"),
                            buildHeaderWithSearch(title: "FAX"),
                            buildHeaderWithSearch(title: "ROLE"),
                            buildHeaderWithSearch(title: "SUBSIDIARY"),
                            buildHeaderWithSearch(
                                title: "ACTIONS", removeSearching: true),
                          ],
                          rows: List.generate(users.length, (index) {
                            final user = users[index];

                            return DataRow(
                              cells: [
                                DataCell(Center(
                                  child: Text(
                                    user.username ?? 'no data',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )),
                                DataCell(Center(
                                  child: Text(
                                    user.email ?? 'no data',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )),
                                DataCell(Center(
                                  child: Text(
                                    user.phone ?? 'no data',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )),
                                DataCell(Center(
                                  child: Text(
                                    user.fax! ?? 'no data',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )),
                                DataCell(Center(
                                  child: Text(
                                    user.role!.name ?? 'no data',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )),
                                DataCell(Center(
                                  child: Text(
                                    user.subsidiary!.name ?? 'no data',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )),
                                DataCell(
                                  Row(
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                          ), // border color & thickness
                                        ),
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.edit_calendar,
                                          size: 28,
                                        ),
                                      ),
                                      Text("|"),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                          ), // border color & thickness
                                        ),
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.delete_forever,
                                          size: 28,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          })),
                    )
            ],
          ),
        );
      }),
    );
  }
}
