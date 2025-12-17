import 'package:dashboard_new1/alert/delete_permission_alert.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/view/customer/add_customerScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/dropdown_button.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'controller/customer_controller.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  CustomerController controller = Get.isRegistered<CustomerController>()
      ? Get.find<CustomerController>()
      : Get.put(CustomerController());
  final DashboardController _controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "customersScreen";
    controller.getCustomer();
  }

  // int selectedRowIndex = 0; // currently selected row
  // final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<CustomerController>(builder: (controller) {
      final listToShow = controller.filteredCustomer.isNotEmpty
          ? controller.filteredCustomer
          : controller.customerListAll;
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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    AppText.customer +
                        "(${controller.getCustomerModel?.count})",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: CustomButton(
                      onTap: () {
                        controller.getCustomer();
                      },
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
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // CustomTextField(
                  //   onChanged: (value) {

                  //   },
                  //   borderRadius: 4,
                  //   controller: controller.keyWordsController,
                  //   width: fieldWidth / 1.2,
                  //   hintText: "ENTER KEYWORDS",
                  //   columnText: true,
                  // ),
                  // Column(
                  //   children: [
                  //     CustomDropdownField<String>(
                  //       text: "SELECT TYPE",
                  //       width: fieldWidth / 1.5,
                  //       label: "SELECT TYPE",
                  //       items: [
                  //         "NAME",
                  //         "MOBILE",
                  //         "TELEPHONE",
                  //         "EMAIL",
                  //         "ADDRESS",
                  //       ],
                  //       value: controller.selectFilterType,
                  //       itemLabel: (val) => val, // just show the string
                  //       onChanged: (val) {
                  //         controller.selectFilterType = val!;
                  //         controller.update();
                  //       },
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                        value: controller.blackList.value,
                        onChanged: (v) {
                          controller.blackList.value = v!;
                          controller.getCustomer();
                          controller.update();
                        }),
                  ),
                  Text(
                    AppText.blackList,
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: DynamicColors.redClr),
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  // CustomButton(
                  //   height: 30,
                  //   verticalPadding: 0.0,
                  //   width: 100,
                  //   btnText: AppText.clear,
                  //   borderRadius: 4,
                  //   fontSize: 11,
                  //   btnColor: DynamicColors.redClr,
                  // ),
                  // CustomButton(
                  //   height: 30,
                  //   verticalPadding: 0.0,
                  //   width: 100,
                  //   fontSize: 11,
                  //   btnText: AppText.search,
                  //   borderRadius: 4,
                  // ),
                ],
              ),
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
                        title: "NAME",
                        onChanged: (v) {
                          controller.searchName.value = v;
                          controller.onSearchCustomer();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "MOBILE",
                        onChanged: (v) {
                          controller.searchMobile.value = v;
                          controller.onSearchCustomer();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "TELEPHONE",
                        onChanged: (v) {
                          controller.searchTele.value = v;
                          controller.onSearchCustomer();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "EMAIL",
                        onChanged: (v) {
                          controller.searchEmail.value = v;
                          controller.onSearchCustomer();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "ADDRESS",
                        onChanged: (v) {
                          controller.searchAddress.value = v;
                          controller.onSearchCustomer();
                        },
                      ),
                      buildHeaderWithSearch(
                          title: "ACTIONS",
                          customWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  Icons.close,
                                  size: 28,
                                  color: DynamicColors.redClr,
                                ),
                              ),
                            ],
                          )),
                    ],
                    totalRow: listToShow.length ?? 0,
                    rows: (listToShow ?? []).map((item) {
                      return DataRow(cells: [
                        DataCell(Center(child: Text(item.name ?? "-"))),
                        DataCell(Center(child: Text(item.mobile ?? "-"))),
                        DataCell(
                            Center(child: Text(item.telephone ?? "-"))),
                        DataCell(Center(child: Text(item.email ?? "-"))),
                        DataCell(
                            Center(child: Text(item.address1 ?? "-"))),
                        DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ), // border color & thickness
                                ),
                                onPressed: () {
                                  controller.customerUpdate(
                                      customerUpdate: item);
                                  int index = _controller.selectedMenuItems
                                      .indexWhere((element) =>
                                          element.title == "CUSTOMERS");
                                  if (index != -1) {
                                    _controller.selectedMenuItems[index]
                                        .selectedItem = true;
                                    _controller.currentPage.value =
                                        CustomerFormScreen();
                                  } else {
                                    _controller.currentPage.value =
                                        CustomerFormScreen();
                                    _controller.menuBarRefresh(
                                        title: "CUSTOMERS",
                                        pageName: CustomerFormScreen());
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
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => DeletePermissionAlert(
                                      deleteFunctionName: () =>
                                          controller.deleteCustomer(item.id!),
                                    ),
                                  );
                              
                                },
                                child: Icon(
                                  Icons.delete_forever,
                                  size: 28,
                                  color: DynamicColors.redClr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              // PaginationWidget(
              //   currentPage: controller.currentPage.value,
              //   totalPages: controller.totalPages.value,
              //   onPageChange: controller.onPageCustomer,
              // )
            ],
          ),
        );
      });
    });
  }
}
