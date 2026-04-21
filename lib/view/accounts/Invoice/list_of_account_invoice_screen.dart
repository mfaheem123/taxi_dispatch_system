import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/accounts/Invoice/update_list_of_account_invoice.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../alert/delete_permission_alert.dart';
import '../../../component/pagination.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/account_controller.dart';
import '../controller/invoice_controller.dart';
import 'create_account_invoice_screen.dart';

class ListOfAccountInvoiceScreen extends StatefulWidget {
  const ListOfAccountInvoiceScreen({super.key});

  @override
  State<ListOfAccountInvoiceScreen> createState() =>
      _ListOfAccountInvoiceScreenState();
}

class _ListOfAccountInvoiceScreenState
    extends State<ListOfAccountInvoiceScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)


  InvoiceController controller = Get.isRegistered<InvoiceController>()?
      Get.find<InvoiceController>()
      :Get.put(InvoiceController());


  final DashboardController _controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "ListOfAccountInvoiceScreen";
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<InvoiceController>(
        initState: (state) {
          controller.listAccountInvoice(isFirstTime: true);
        },
        builder: (controller) {
          final listToShow = controller.filteredAccountInvoice.isNotEmpty
              ? controller.filteredAccountInvoice
              : controller.accountInvoiceListAll;
          bool isAllSelected = listToShow.isNotEmpty && controller.selectedIds.length == listToShow.length;

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

            return
              controller.isLoadingListOfAccountInvoice == true?
              CircularProgressIndicator():

              Wrap(
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
                          "ACCOUNT INVOICES (${controller.listOfAccountInvoice!.count ?? "0"})",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        Spacer(),
                        CustomButton(
                          verticalPadding: 0.0,
                          width: 60,
                          height: 40,
                          borderRadius: 4,
                          btnText: AppText.create,
                          style: mozillaTextRegularText(
                              fontSize: 10, color: DynamicColors.whiteClr),
                          onTap: () {
                            int index = _controller.selectedMenuItems
                                .indexWhere((element) =>
                            element.title == "CREATE ACCOUNT INVOICE");
                            if (index != -1) {
                              _controller.selectedMenuItems[index]
                                  .selectedItem = true;
                              _controller.currentPage.value =
                                  CreateAccountInvoiceScreen();
                            } else {
                              _controller.currentPage.value =
                                  CreateAccountInvoiceScreen();
                              _controller.menuBarRefresh(
                                  title: "CREATE ACCOUNT INVOICE",
                                  pageName: CreateAccountInvoiceScreen());
                            }
                            controller.update();
                          },
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        CustomButton(
onTap: () {
  controller.listAccountInvoice();
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.from,
                              width: fieldWidth / 1.8,
                              child:
                              SizedBox(height: 30, child: KeyboardDatePicker(

                                  initialDate: controller.invoiceListFromDate ?? DateTime.now(),
                                  onChanged: (fromDate) {
                                    controller.invoiceListFromDate = fromDate;
                                    controller.update();
                                  }



                              )),
                            ),
                            labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.to,
                              width: fieldWidth / 1.8,
                              child:
                              SizedBox(height: 30, child: KeyboardDatePicker(
                                  initialDate: controller.invoiceListToDate ?? DateTime.now(),
                                  onChanged: (fromDate) {
                                    controller.invoiceListToDate = fromDate;
                                    controller.update();
                                  }
                              )),
                            ),
                            Row(
                              children: [
                            Text("STATUS", style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                            SizedBox(width: 14),
                                CustomDropdownField<String>(
                                  width: fieldWidth / 4,
                                  label: "STATUS",
                                  items: ["all", "paid", "unpaid"],
                                  value: controller.status,
                                  itemLabel: (val) => val, // just show the string
                                  onChanged: (val) {
                                    controller.status = val!.toLowerCase();
                                    controller.update();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        CustomButton(
                          onTap: () {
                            controller.invoiceNumber.value = "";
                            controller.searchAccount.value = "";
                            controller.status = "all";
                            controller.invoiceListFromDate = DateTime.now();
                            controller.invoiceListToDate = DateTime.now();
                            controller.listAccountInvoice();
                          },
                          verticalPadding: 0.0,
                          width: 60,
                          height: 40,
                          borderRadius: 4,
                          btnText: AppText.clear,
                          style: mozillaTextRegularText(
                              fontSize: 10, color: DynamicColors.whiteClr),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CustomButton(
                          onTap: () {
                            controller.listAccountInvoice();
                          },
                          verticalPadding: 0.0,
                          width: 60,
                          height: 40,
                          borderRadius: 4,
                          btnText: AppText.search,
                          style: mozillaTextRegularText(
                              fontSize: 10, color: DynamicColors.whiteClr),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
              SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: isMobile || isTablet ? Get.width + 600 : Get.width,
                      child: DatatableWidget(
                          columns: [
                            // DataColumn(
                            //   label: Checkbox(
                            //     value: isAllSelected,
                            //     tristate: false,
                            //     onChanged: (bool? val) {
                            //       setState(() {
                            //         if (val == true) {
                            //           controller.selectedIds = listToShow.map((item) => item.id.toString()).toSet();
                            //         } else {
                            //           controller.selectedIds.clear();
                            //         }
                            //       });
                            //     },
                            //   ),
                            // ),
                            buildHeaderWithSearch(
                              title: "INVOICE #",
                              onChanged: (v) {
                                controller.invoiceNumber.value = v;
                                controller.listAccountInvoice(activeFilter: "invoice");
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "ACCOUNT",
                              onChanged: (v) {
                                controller.searchAccount.value = v;
                                controller.listAccountInvoice(activeFilter: "account");
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "DEPARTMENT",
                              onChanged: (v) {
                                controller.searchDepartment.value = v;
                                controller.listAccountInvoice(activeFilter: "department");
                                },
                            ),
                            buildHeaderWithSearch(
                              title: "ORDER #",
                              onChanged: (v) {
                                controller.searchOrder.value = v;
                                controller.listAccountInvoice(activeFilter: "order");
                              }
                            ),
                            buildHeaderWithSearch(
                              title: "DATE",
                              onChanged: (v) {
                                controller.searchDate.value = v;
                                controller.listAccountInvoice(activeFilter: "invoicedate");
                               }
                            ),
                            buildHeaderWithSearch(
                              title: "DUE DATE",
                              onChanged: (v) {
                                controller.searchDueDate.value = v;
                                controller.listAccountInvoice(activeFilter: "duedate");
                              }
                            ),
                            buildHeaderWithSearch(
                              title: "STATUS",
                              onChanged: (v) {
                                controller.searchStatus.value = v;
                                controller.listAccountInvoice(activeFilter: "status");;
                              }
                            ),
                            buildHeaderWithSearch(
                              title: "AMOUNT",
                              onChanged: (v) {
                                controller.searchAmount.value = v;
                                controller.listAccountInvoice(activeFilter: "amount");
                              }
                            ),
                            buildHeaderWithSearch(
                              title: "SUBSIDIARY",
                              onChanged: (v) {
                                controller.searchSubsidiary.value = v;
                                controller.listAccountInvoice(activeFilter: "subsidiary");
                              }
                            ),
                            buildHeaderWithSearch(
                                title: "ACTIONS", removeSearching: true),
                          ],
                          totalRow: listToShow.length ?? 0,
                          rows: (listToShow ?? []).map((item) {
                            bool isRowSelected = controller.selectedIds.contains(item.id.toString());
                            return DataRow(cells: [
                              // DataCell(
                              //   Checkbox(
                              //     value: isRowSelected,
                              //     onChanged: (bool? val) {
                              //       setState(() {
                              //         if (val == true) {
                              //           controller.selectedIds.add(item.id.toString());
                              //         } else {
                              //           controller.selectedIds.remove(item.id.toString());
                              //         }
                              //       });
                              //     },
                              //   ),
                              // ),
                              // 1. Invoice Number
                              DataCell(Center(child: Text(item.invoiceNumber ?? "-"))),
                              DataCell(Center(child: Text((item.account?.name ?? "-").toUpperCase()))),
                              DataCell(Center(child: Text((
                                  item.department is Map
                                      ? item.department['name'] ?? "-"
                                      : item.department?.name ?? "-"
                              ).toUpperCase()))),
                              DataCell(Center(child: Text((item.orderNumber ?? "-").toUpperCase()))),
                              DataCell(Center(child: Text(item.invoiceDate != null ? item.invoiceDate!.toIso8601String().split('T').first : "-"))),
                              DataCell(Center(child: Text(item.invoiceDueDate != null ? item.invoiceDueDate!.toIso8601String().split('T').first : "-"))),
                              DataCell(Center(
                                child: Text(item.status?.toUpperCase() ?? "-",))),
                              DataCell(Center(child: Text(item.amount ?? "0.00"))),
                              DataCell(Center(child: Text((item.account?.subsidiary?.name ?? "-").toUpperCase()))),
                              DataCell(
                                Row(
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      onPressed: () {
                                        controller.getAccountInvoice(selectedInvoiceId:  item.id);

                                        int index = _controller.selectedMenuItems
                                            .indexWhere((element) =>
                                        element.title == "UPDATE ACCOUNT INVOICE");
                                        if (index != -1) {
                                          _controller.selectedMenuItems[index]
                                              .selectedItem = true;
                                          _controller.currentPage.value =
                                              UpdateAccountInvoiceScreen();
                                        } else {
                                          _controller.currentPage.value =
                                              UpdateAccountInvoiceScreen();
                                          _controller.menuBarRefresh(
                                              title: "UPDATE ACCOUNT INVOICE",
                                              pageName: UpdateAccountInvoiceScreen());
                                        }
                                        controller.update();
                                        // Get.to();
                                      },
                                      child: Icon(
                                        Icons.edit_calendar_rounded,
                                        size: 28,
                                        color: DynamicColors.primaryClr,
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
                                        controller.accountInvoiceDelete(item.id);
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
                          }).toList()),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: controller.currentPage.value,
                    totalPages: controller.totalPages.value,
                    onPageChange: controller.onPageAccountInvoice,
                  )
                ],
              );
          });
        });
  }
}