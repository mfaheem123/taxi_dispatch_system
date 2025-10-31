import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';

class ESCORTScreen extends StatefulWidget {
  const ESCORTScreen({super.key});

  @override
  State<ESCORTScreen> createState() => _ESCORTScreenState();
}

class _ESCORTScreenState extends State<ESCORTScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "ESCORTScreen";
    controller.listEscort();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<AccountController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final listToShow = controller.escortFiltered.isNotEmpty
            ? controller.escortFiltered
            : controller.escortAll;

        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        return Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: DynamicColors.gryClr.withOpacity(0.5),
              child: Row(
                children: [
                  Text(
                    AppText.escort,
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  Spacer(),
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
            ),
            controller.listEscortLoding == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                    width: isMobile || isTablet
                                  ? Get.width + 600
                                  : Get.width,
                      child: DatatableWidget(
                        columns: [
                          DataColumn(
                            label: Checkbox(
                              value: false, // a bool you keep in state
                              onChanged: (val) {},
                            ),
                          ),
                          buildHeaderWithSearch(
                            title: "NAME",
                            onChanged: (v) {
                              controller.searchEscortName.value = v;
                              controller.SearchEscort();
                            },
                          ),
                          buildHeaderWithSearch(
                            title: "SAFEGUARDING EXPIRY",
                            onChanged: (v) {
                              controller.searchEscortSafeguarding.value = v;
                              controller.SearchEscort();
                            },
                          ),
                          buildHeaderWithSearch(
                            title: "PAT EXPIRY",
                            onChanged: (v) {
                              controller.searchEscortPAT.value = v;
                              controller.SearchEscort();
                            },
                          ),
                          buildHeaderWithSearch(
                              title: "FIRSTAID EXPIRY",
                              onChanged: (v) {
                                controller.searchEscortFirstAid.value = v;
                                controller.SearchEscort();
                              }),
                          buildHeaderWithSearch(
                              title: "DBS EXPIRY",
                              onChanged: (v) {
                                controller.searchEscortDBS.value = v;
                                controller.SearchEscort();
                              }),
                          buildHeaderWithSearch(
                              title: "ACTIONS", removeSearching: true),
                        ],
                        totalRow: listToShow.length ?? 0,
                        rows: (listToShow ?? []).map((item) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Checkbox(
                                  value: false,
                                  onChanged: (val) {},
                                ),
                              ),
                              DataCell(Center(child: Text(item.name!))),
                              DataCell(Center(
                                  child: Text(item.safeguardingExpiry!))),
                              DataCell(Center(child: Text(item.patExpiry!))),
                              DataCell(
                                  Center(child: Text(item.firstaidExpiry!))),
                              DataCell(Center(child: Text(item.dbsExpiry!))),
                              DataCell(
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Colors.transparent,
                                        ), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.edit,
                                        size: 28,
                                        color: DynamicColors.primaryClr,
                                      ),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Colors.transparent,
                                        ), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.delete,
                                        size: 28,
                                        color: DynamicColors.redClr,
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
                  ),
            PaginationWidget(
                currentPage: controller.escortCurrentPage.value,
                totalPages: controller.escortTotalPages.value,
                onPageChange: controller.PageEscort)
          ],
        );
      });
    });
  }
}
