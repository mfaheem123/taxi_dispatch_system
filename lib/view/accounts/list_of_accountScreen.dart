// class ListOfAccountScreen extends StatefulWidget {

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:number_pagination/number_pagination.dart';
import '../../component/datatable_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../drivers_view/controller/driver_controller.dart';
import 'controller/account_controller.dart';

class ListOfAccountScreen extends StatefulWidget {
  ListOfAccountScreen({super.key});

  @override
  State<ListOfAccountScreen> createState() => _ListOfAccountScreenState();
}

class _ListOfAccountScreenState extends State<ListOfAccountScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "driversList";
    controller.listOFAccount();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<AccountController>(builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "ACCOUNTS (7)",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Checkbox(
                      value: controller.activeDrivers.value,
                      onChanged: (v) {
                        controller.activeDrivers.value = v!;
                        controller.update();
                      }),
                  Text(
                    "Closed",
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
              controller.isLoadingListOfAccount == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width,
                        child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(title: "NAME"),
                              buildHeaderWithSearch(title: "ACCOUNT TYPE"),
                              buildHeaderWithSearch(title: "ADDRESS"),
                              buildHeaderWithSearch(title: "EMAIL"),
                              buildHeaderWithSearch(title: "MOBILE"),
                              buildHeaderWithSearch(title: "TELEPHONE"),
                              buildHeaderWithSearch(title: "CONTACT NAME"),
                              buildHeaderWithSearch(title: "SUBSIDIARY"),
                              buildHeaderWithSearch(
                                  title: "ACTIONS", removeSearching: true),
                            ],
                            totalRow:
                                controller.listofAccount?.accounts?.length,
                            rows: (controller.listofAccount!.accounts ?? [])
                                .map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Center(child: Text(item.name!.toString()))),
                                  DataCell(
                                      Center(child: Text(item.accountType!.toString()))),
                                  DataCell(Center(child: Text(item.address!.toString()))),
                                  DataCell(Center(child: Text(item.email!.toString()))),
                                  DataCell(Center(child: Text(item.mobile!.toString()))),
                                  DataCell(
                                      Center(child: Text(item.telephone!.toString()))),
                                  DataCell(
                                      Center(child: Text(item.contactName!.toString()))),
                                  DataCell(Center(
                                      child: Text(item.subsidiary!.name.toString()))),
                                  DataCell(
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.transparent,
                                              ), // border color & thickness
                                            ),
                                            onPressed: () {},
                                            child: Icon(
                                              Icons.search,
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
                                  ),
                                ],
                              );
                            }).toList()),
                      ),
                    ),

           Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child:  NumberPagination(
                  onPageChanged: controller.onPageChange,
                  totalPages: controller.totalPages.value,
                  currentPage: controller.currentPage.value,
                  visiblePagesCount: 4,
                )),

            ],
          ),
        );
      }),
    );
  }
}
