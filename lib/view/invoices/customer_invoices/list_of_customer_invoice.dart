import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/keyboard_checkBox_widget.dart';
import 'package:dashboard_new1/view/invoices/customer_invoices/update_customer_invoice.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../alert/update_customer_invoice_email.dart';
import '../../../component/action_icon_button.dart';
import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/customer_invoice_controller.dart';

class InvoiceList extends StatefulWidget {
  const InvoiceList({super.key});

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  CustomerInvoiceController controller = Get.isRegistered<CustomerInvoiceController>()
      ? Get.find<CustomerInvoiceController>()
      : Get.put(CustomerInvoiceController());

  final DashboardController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "invoiceList";
  }

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<CustomerInvoiceController>(
        initState: (state) {
          controller.getCustomerInvoice();
        },
        builder: (controller) {
          final invoices = controller.filteredInvoices;
          final totalRows = invoices.length;

          return LayoutBuilder(builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

            final double fieldWidth = isMobile
                ? maxWidth // full width
                : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  // Header section
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    child: Row(
                      children: [
                        Text(
                            "${AppText.customerInvoices} (${controller.listOfCustomerInvoiceModel?.count ?? "0"})",
                            style: titleDesign()
                        ),
                        const SizedBox(width: 120),
                        KeyboardCheckbox(
                          onChanged: (v) {
                            controller.paid.value = v;
                            controller.getCustomerInvoice();
                            controller.update();
                          },
                          label: AppText.paid,
                          value: controller.paid.value,
                          focusNode: controller.paidNode,
                          width: 200,
                        ),
                        const Spacer(),
                        CustomButton(
                          height: 40,
                          width: 80,
                          verticalPadding: 0.0,
                          borderRadius: 4,
                          onTap: () {
                            controller.getCustomerInvoice();
                          },
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

                  controller.isLoadingList
                      ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                      :
                  // invoices.isEmpty
                  //     ? const Center(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(40.0),
                  //     child: Text("No Invoices Found"),
                  //   ),
                  // )
                  //     :
                  SingleChildScrollView(
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(title: "INVOICE #",
                              onChanged: (value) {
                                controller.searchQuery.value = value;
                                controller.update();
                              }),
                          buildHeaderWithSearch(title: "CUSTOMER",
                              onChanged: (value) {
                                controller.searchQuery.value = value;
                                controller.update();
                              }),
                          buildHeaderWithSearch(title: "DATE",
                              onChanged: (value) {
                                controller.searchQuery.value = value;
                                controller.update();
                              }),
                          buildHeaderWithSearch(title: "DUE DATE",
                              onChanged: (value) {
                                controller.searchQuery.value = value;
                                controller.update();
                              }),
                          buildHeaderWithSearch(title: "STATUS",
                              onChanged: (value) {
                                controller.searchQuery.value = value;
                                controller.update();
                              }),
                          buildHeaderWithSearch(title: "AMOUNT",
                              onChanged: (value) {
                                controller.searchQuery.value = value;
                                controller.update();
                              }),
                          buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                        ],
                        totalRow: totalRows,

                        rows: invoices.map((invoice) {
                          return DataRow(
                            cells: [
                              DataCell(Center(child: Text(invoice.invoiceNumber ?? "-"))),
                              DataCell(Center(child: Text((invoice.customer?.name ?? "-").toUpperCase()))),
                              DataCell(Center(child: Text(invoice.invoiceDate != null ? invoice.invoiceDate!.toIso8601String().split('T').first : "-"))),
                              DataCell(Center(child: Text(invoice.invoiceDueDate != null ? invoice.invoiceDueDate!.toIso8601String().split('T').first : "-"))),
                              DataCell(Center(child: Text(invoice.status?.toUpperCase() ?? "-"))),
                              DataCell(Center(child: Text("£ ${invoice.amount ?? "0"}"))),
                              DataCell(
                                  Center(child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ActionIconButton(
                                        onPressed: () {
                                          Get.back();
                                          controller
                                              .getUpdateCustomerInvoice(
                                              selectedId: invoice.id);
                                          int index = _controller
                                              .selectedMenuItems
                                              .indexWhere((element) =>
                                          element.title ==
                                              "UPDATE CUSTOMER INVOICE");
                                          if (index != -1) {
                                            _controller
                                                .selectedMenuItems[index]
                                                .selectedItem = true;
                                            _controller.currentPage
                                                .value =
                                                UpdateCustomerInvoiceScreen();
                                          } else {
                                            _controller.currentPage
                                                .value =
                                                UpdateCustomerInvoiceScreen();
                                            _controller.menuBarRefresh(
                                                title:
                                                "UPDATE CUSTOMER INVOICE",
                                                pageName:
                                                UpdateCustomerInvoiceScreen());
                                          }
                                          controller.update();
                                        },
                                       icon: Icons.edit_calendar, color: DynamicColors.primaryClr,
                                      ),
                                      Text("|"),
                                        ActionIconButton(
                                            icon: Icons.delete,
                                            color: Colors.red,
                                          onPressed: () {
                                            controller.customerInvoiceDelete(invoice.id);
                                          }),
                                      Text("|"),
                                      ActionIconButton(
                                          icon: Icons.picture_as_pdf,
                                          color: Colors.black,
                                          onPressed: () {
                                            controller.downloadPdfFile();
                                          }),
                                      Text("|"),
                                      ActionIconButton(
                                          icon: Icons.mail,
                                          color: Colors.black,
                                          onPressed: () {
                                            EmailCustomerInvoiceAlert.show();
                                          }),
                                    ],
                                  ),
                                  )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}