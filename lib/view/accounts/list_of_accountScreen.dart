// class ListOfAccountScreen extends StatefulWidget {

import 'dart:io';

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/accounts/account/account_view.dart';
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

  final DashboardController _controller = Get.find();

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
      child: LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 400;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;
        return GetBuilder<AccountController>(builder: (controller) {
          final listToShow = controller.filteredAccount.isNotEmpty
              ? controller.filteredAccount
              : controller.AccountList;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "ACCOUNTS" + " (${controller.listofAccount?.count})",
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
                          width: isMobile || isTablet
                              ? Get.width + 600
                              : Get.width, // give extra space for last column
                          child: DatatableWidget(
                              columns: [
                                buildHeaderWithSearch(
                                  title: "NAME",
                                  onChanged: (value) {
                                    controller.searchName.value = value;
                                    controller.onSearchChanged();
                                  },
                                ),
                                buildHeaderWithSearch(
                                  title: "ACCOUNT TYPE",
                                  onChanged: (value) {
                                    controller.searchAccountType.value = value;
                                    controller.onSearchChanged();
                                  },
                                ),
                                buildHeaderWithSearch(
                                  title: "ADDRESS",
                                  onChanged: (value) {
                                    controller.searchAddress.value = value;
                                    controller.onSearchChanged();
                                  },
                                ),
                                buildHeaderWithSearch(
                                  title: "EMAIL",
                                  onChanged: (value) {
                                    controller.searchEmail.value = value;
                                    controller.onSearchChanged();
                                  },
                                ),
                                buildHeaderWithSearch(
                                  title: "MOBILE",
                                  onChanged: (value) {
                                    controller.searchMobile.value = value;
                                    controller.onSearchChanged();
                                  },
                                ),
                                buildHeaderWithSearch(
                                  title: "TELEPHONE",
                                  onChanged: (value) {
                                    controller.searchTelephone.value = value;
                                    controller.onSearchChanged();
                                  },
                                ),
                                buildHeaderWithSearch(
                                  title: "CONTACT NAME",
                                  onChanged: (value) {
                                    controller.searchcontactName.value = value;
                                    controller.onSearchChanged();
                                  },
                                ),
                                buildHeaderWithSearch(
                                  title: "SUBSIDIARY",
                                  onChanged: (value) {
                                    controller.searchSubsiDiary.value = value;
                                    controller.onSearchChanged();
                                  },
                                ),
                                buildHeaderWithSearch(
                                    title: "ACTIONS", removeSearching: true),
                              ],
                              totalRow: listToShow.length,
                              rows: (listToShow ?? []).map((item) {
                                return DataRow(
                                  cells: [
                                    DataCell(Center(
                                        child: Text(item.name!.toString()))),
                                    DataCell(Center(
                                        child: Text(
                                            item.accountType!.toString()))),
                                    DataCell(Center(
                                        child: Text(item.address!.toString()))),
                                    DataCell(Center(
                                        child: Text(item.email!.toString()))),
                                    DataCell(Center(
                                        child: Text(item.mobile!.toString()))),
                                    DataCell(Center(
                                        child:
                                            Text(item.telephone!.toString()))),
                                    DataCell(Center(
                                        child: Text(
                                            item.contactName!.toString()))),
                                    DataCell(Center(
                                        child: Text(
                                            item.subsidiary!.name.toString()))),
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
                                              onPressed: () {
                                                controller.bindAccountUpdateValue(data: item);
                                                int index = _controller.selectedMenuItems.indexWhere(
                                                        (element) => element.title == "CREATE ACCOUNT");
                                                if (index != -1) {
                                                  _controller.selectedMenuItems[index].selectedItem = true;
                                                  _controller.currentPage.value = AccountView();
                                                }else{
                                                  _controller.currentPage.value = AccountView();
                                                  _controller.menuBarRefresh(
                                                      title: "CREATE ACCOUNT", pageName: AccountView());
                                                }
                                                controller.update();
                                              },
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
                                    ),
                                  ],
                                );
                              }).toList()),
                        ),
                      ),
                PaginationWidget(
                  currentPage: controller.currentPage.value,
                  totalPages: controller.totalPages.value,
                  onPageChange: controller.onPageChange,
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}
