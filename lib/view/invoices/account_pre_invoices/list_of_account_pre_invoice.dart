import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:dashboard_new1/view/invoices/account_pre_invoices/update_acc_pre_inv.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../alert/search_booking.dart';
import '../../../component/pagination.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../account_invoices/update_account_invoice.dart';
import '../controller/account_invoice_controller.dart';
import 'create_account_pre_invoice.dart';

class ListOfAccountPreInvoiceScreen extends StatefulWidget {
  const ListOfAccountPreInvoiceScreen({super.key});

  @override
  State<ListOfAccountPreInvoiceScreen> createState() =>
      _ListOfAccountPreInvoiceScreenState();
}

class _ListOfAccountPreInvoiceScreenState extends State<ListOfAccountPreInvoiceScreen> {

  InvoiceController controller = Get.isRegistered<InvoiceController>()
      ? Get.find<InvoiceController>()
      :Get.put(InvoiceController());


  final DashboardController _controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "ListOfAccountPreInvoiceScreen";
  }

  @override
  Widget build(BuildContext context) {
    double width = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return PageScrollWrapper(
      child: GetBuilder<InvoiceController>(initState: (state) {
        controller.clearData();
        controller.listAccountInvoice(isFirstTime: true, invoiceType: "PRE");
      },
          builder: (controller) {
            final listToShow = controller.filteredAccountInvoice.isNotEmpty
                ? controller.filteredAccountInvoice
                : controller.accountInvoiceListAll;

      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        final double fieldWidth = isMobile
            ? maxWidth
            : isTablet
            ? maxWidth / 2
            : maxWidth / 4;

        return Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: DynamicColors.gryClr.withOpacity(0.5),
              child: Row(
                children: [
                  Text(
                    "ACCOUNT PRE INVOICES (${controller.listOfAccountInvoice?.count ?? "0"})",
                    style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  const Spacer(),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 70,
                    height: 30,
                    borderRadius: 4,
                    btnText: AppText.create,
                    style: mozillaTextSemiBoldText(fontSize: 12, color: DynamicColors.whiteClr),
                    onTap: () {
                      int index = _controller.selectedMenuItems.indexWhere((element) =>
                      element.title == "CREATE ACCOUNT PRE INVOICE");
                      if (index != -1) {
                        _controller.selectedMenuItems[index].selectedItem = true;
                        _controller.currentPage.value = CreateAccountPreInvoice();
                      } else {
                        _controller.currentPage.value = CreateAccountPreInvoice();
                        _controller.menuBarRefresh(
                            title: "CREATE ACCOUNT PRE INVOICE",
                            pageName: CreateAccountPreInvoice());
                      }
                      controller.update();
                    },
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    onTap: () {
                      controller.listAccountInvoice(isFirstTime: true, invoiceType: "PRE");
                      controller.update();
                    },
                    height: 30,
                    width: 70,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
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
            const SizedBox(height: 8),

            // Filter Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  labeledField(
                    context: context,
                    isMobile: isMobile,
                    label: AppText.from,
                    width: fieldWidth / 1.8,
                    child: SizedBox(
                      height: 30,
                      child: KeyboardDatePicker(
                        initialDate: controller.invoiceListFromDate ?? DateTime.now(),
                        onChanged: (fromDate) {
                          controller.invoiceListFromDate = fromDate;
                          controller.update();
                        },
                      ),
                    ),
                  ),
                  labeledField(
                    context: context,
                    isMobile: isMobile,
                    label: AppText.to,
                    width: fieldWidth / 1.8,
                    child: SizedBox(
                      height: 30,
                      child: KeyboardDatePicker(
                        initialDate: controller.invoiceListToDate ?? DateTime.now(),
                        onChanged: (toDate) {
                          controller.invoiceListToDate = toDate;
                          controller.update();
                        },
                      ),
                    ),
                  ),

                  // Status Dropdown Row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("STATUS", style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
                      const SizedBox(width: 14),
                      CustomDropdownField<String>(
                        width: fieldWidth / 4,
                        label: "STATUS",
                        items: const ["ALL", "PAID", "UNPAID"],
                        value: (controller.status == null || controller.status!.isEmpty)
                            ? "ALL"
                            : controller.status!.toUpperCase(),
                        itemLabel: (val) => val,
                        onChanged: (val) {
                          if (val != null) {
                            controller.status = val;
                            controller.update();
                          }
                        },
                      ),
                    ],
                  ),

                  // Action Buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        onTap: () {
                          controller.invoiceNumber.value = "";
                          controller.searchAccount.value = "";
                          controller.status = "ALL";
                          controller.invoiceListFromDate = DateTime.now();
                          controller.invoiceListToDate = DateTime.now();
                          controller.listAccountInvoice(isFirstTime: true, invoiceType: "PRE");
                        },
                        verticalPadding: 0.0,
                        width: 70,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.clear,
                        style: mozillaTextSemiBoldText(fontSize: 12, color: DynamicColors.whiteClr),
                      ),
                      const SizedBox(width: 15),
                      CustomButton(
                        onTap: () {
                          controller.listAccountInvoice(isFirstTime: true, invoiceType: "PRE");
                        },
                        verticalPadding: 0.0,
                        width: 70,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.search,
                        style: mozillaTextSemiBoldText(fontSize: 12, color: DynamicColors.whiteClr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            SingleChildScrollView(
              child: SizedBox(
                width: isMobile || isTablet ? width + 600 : width,
                child: DatatableWidget(
                  columns: [
                    buildHeaderWithSearch(title: "INVOICE #", onChanged: (v) {
                      controller.invoiceNumber.value = v;
                      controller.onSearchAccountInvoice(invoiceType: "PRE");
                    }),
                    buildHeaderWithSearch(title: "ACCOUNT", onChanged: (v) {
                      controller.searchAccount.value = v;
                      controller.onSearchAccountInvoice(invoiceType: "PRE");
                    }),
                    buildHeaderWithSearch(title: "DEPARTMENT", onChanged: (v) {
                      controller.searchDepartment.value = v;
                      controller.onSearchAccountInvoice(invoiceType: "PRE");
                    }),
                    buildHeaderWithSearch(title: "ORDER #", onChanged: (v) {
                      controller.searchOrder.value = v;
                      controller.onSearchAccountInvoice(invoiceType: "PRE");
                    }),
                    buildHeaderWithSearch(title: "DATE", onChanged: (v) {
                      controller.searchDate.value = v;
                      controller.onSearchAccountInvoice(invoiceType: "PRE");
                    }),
                    buildHeaderWithSearch(title: "DUE DATE", onChanged: (v) {
                      controller.searchDueDate.value = v;
                      controller.onSearchAccountInvoice(invoiceType: "PRE");
                    }),
                    buildHeaderWithSearch(title: "STATUS", onChanged: (v) {
                      controller.searchStatus.value = v;
                      controller.onSearchAccountInvoice(invoiceType: "PRE");
                    }),
                    buildHeaderWithSearch(title: "AMOUNT", onChanged: (v) {
                      controller.searchAmount.value = v;
                      controller.onSearchAccountInvoice(invoiceType: "PRE");
                    }),
                    buildHeaderWithSearch(title: "SUBSIDIARY", onChanged: (v) {
                      controller.searchSubsidiary.value = v;
                      controller.onSearchAccountInvoice(invoiceType: "PRE");
                    }),
                    buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                  ],
                    totalRow: listToShow.length ?? 0,
                    rows: (listToShow).map((item) {
                      return DataRow(cells: [
                        DataCell(Center(child: Text((item.invoiceNumber ?? "").toUpperCase()))),
                        DataCell(Center(child: Text((item.account?.name ?? "").toUpperCase()))),
                        DataCell(Center(child: Text((item.department?.name ?? "").toUpperCase()))),
                        DataCell(Center(child: Text((item.orderNumber ?? "").toUpperCase()))),
                        DataCell(Center(child: Text(item.invoiceDate != null ? item.invoiceDate!.toIso8601String().split('T').first : "-"))),
                        DataCell(Center(child: Text(item.invoiceDueDate != null ? item.invoiceDueDate!.toIso8601String().split('T').first : "-"))),
                        DataCell(Center(child: Text(item.status?.toUpperCase() ?? "",))),
                        DataCell(Center(child: Text(item.amount ?? "0.00"))),
                        DataCell(Center(child: Text((item.account?.subsidiary?.name ?? "").toUpperCase()))),
                        DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.transparent,
                                      )),
                                  onPressed: () {
                                    controller.getAccountInvoice(
                                        selectedInvoiceId: item.id);

                                    int index = _controller.selectedMenuItems
                                        .indexWhere((element) => element.title ==
                                        "UPDATE ACCOUNT PRE INVOICE");
                                    if (index != -1) {
                                      _controller.selectedMenuItems[index]
                                          .selectedItem = true;
                                      _controller.currentPage.value =
                                          UpdateAccountPreInvoice();
                                    } else {
                                      _controller.currentPage.value =
                                          UpdateAccountPreInvoice();
                                      _controller.menuBarRefresh(
                                          title: "UPDATE ACCOUNT PRE INVOICE",
                                          pageName: UpdateAccountPreInvoice());
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
                                    ),
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
          }),
    );
  }
}
