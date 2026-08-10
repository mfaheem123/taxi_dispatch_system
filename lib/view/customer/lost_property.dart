import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/networks/api.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'controller/customer_controller.dart';
import 'create_lost_propertyScreen.dart';

class LostProperty extends StatefulWidget {
  const LostProperty({super.key});

  @override
  State<LostProperty> createState() => _LostPropertyState();
}

class _LostPropertyState extends State<LostProperty> {
  CustomerController controller = Get.isRegistered<CustomerController>()
      ? Get.find<CustomerController>()
      : Get.put(CustomerController());
  final DashboardController _controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "lostProperty";
  }

  List permissions = [];




  int selectedRowIndex = 0;
  final int totalRows = 5;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<CustomerController>(initState: (v) {

        permissions = Api().sp.read('all_permissions') ?? [];
      controller.getAllLostProperty();
    }, builder: (controller) {
      if (controller.lostPropertyLoader.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final listToShow = controller.filteredLostProperty.isNotEmpty
          ? controller.filteredLostProperty
          : controller.lostPropertyAll;
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        final double fieldWidth = isMobile
            ? maxWidth
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Text(
                        AppText.lostProperties +
                            " (${controller.lostPropertyModel?.count})",
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: CustomButton(
                          height: 40,
                          width: 80,
                          verticalPadding: 0.0,
                          borderRadius: 4,
                          widget: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0.0),
                            child: Icon(
                              Icons.refresh,
                              color: DynamicColors.whiteClr,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DatatableWidget(
                    columns: [
                      buildHeaderWithSearch(
                          title: "LOST #",
                          onChanged: (v) {
                            controller.searchLostNumber.value = v;
                            controller.onSearchLostProperty();
                          }),
                      buildHeaderWithSearch(
                          title: "REPORT DATE",
                          onChanged: (v) {
                            controller.searchReportDate.value = v;
                            controller.onSearchLostProperty();
                          }),
                      buildHeaderWithSearch(
                          title: "LOST DATE",
                          onChanged: (v) {
                            controller.searchLostDate.value = v;
                            controller.onSearchLostProperty();
                          }),
                      buildHeaderWithSearch(
                          title: "CUSTOMER",
                          onChanged: (v) {
                            controller.searchCustomer.value = v;
                            controller.onSearchLostProperty();
                          }),
                      buildHeaderWithSearch(
                          title: "ITEM DESCRIPTION",
                          onChanged: (v) {
                            controller.searchItemDescription.value = v;
                            controller.onSearchLostProperty();
                          }),
                      buildHeaderWithSearch(
                          title: "ACTIONS",
                          customWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ),
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
                                  Icons.close,
                                  size: 28,
                                  color: DynamicColors.redClr,
                                ),
                              ),
                            ],
                          )),
                    ],
                    totalRow: listToShow.length,
                    rows: listToShow.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Center(child: Text((item.lostNumber ?? "").toUpperCase()))),
                          DataCell(
                            Center(
                              child: Text(item.reportDate != null
                                  ? item.reportDate!.toString().split(' ').first
                                  : ""),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(item.lostDate != null
                                  ? item.lostDate!.toString().split(' ').first
                                  : ""),
                            ),
                          ),
                          DataCell(
                              Center(child: Text((item.customer?.name ?? "").toUpperCase()))),
                          DataCell(
                              Center(child: Text((item.itemDescription ?? "").toUpperCase()))),
                          DataCell(
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    onPressed: () {

                                      if(permissions.contains('update_lost_property')){
                                        controller.lostPropertyUpdate(
                                            lostPropertyUpdate: item);
                                        int index = _controller.selectedMenuItems
                                            .indexWhere((element) =>
                                        element.title == "UPDATE LOST PROPERTY");
                                        if (index != -1) {
                                          _controller.selectedMenuItems[index]
                                              .selectedItem = true;
                                          _controller.currentPage.value =
                                              LostPropertyScreen();
                                        } else {
                                          _controller.currentPage.value =
                                              LostPropertyScreen();
                                          _controller.menuBarRefresh(
                                              title: "UPDATE LOST PROPERTY",
                                              pageName: LostPropertyScreen());
                                        }
                                        controller.update();
                                      }


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
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.delete_forever,
                                      size: 28,
                                      color: DynamicColors.redClr,
                                    ),
                                    onPressed: () {
                      if(permissions.contains('delete_lost_property')){
                        controller.deleteLostProperty(item.id);
                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              PaginationWidget(
                currentPage: controller.currentPageLostProperty.value,
                totalPages: controller.totalPagesLostProperty.value,
                onPageChange: controller.onPageLostProperty,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });
    });
  }
}
