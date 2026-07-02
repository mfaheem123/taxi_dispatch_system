import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/keyboard_checkBox_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
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

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "invoiceList";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerInvoiceController>(
      initState: (state) {
        controller.getCustomerInvoice();
      },
      builder: (controller) {
        final invoices = controller.listOfCustomerInvoiceModel?.customerInvoices ?? [];
        final totalRows = invoices.length;

        return LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                // Header section
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  child: Row(
                    children: [
                      Text(
                          "${AppText.customerInvoices} (${controller.listOfCustomerInvoiceModel?.count ?? "0"})",
                          style: titleDesign()
                      ),
                      const SizedBox(width: 20),
                      KeyboardCheckbox(
                        onChanged: (v) {
                          controller.paid.value = v;
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
                    : invoices.isEmpty
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text("No Invoices Found"),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: Get.width,
                    child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "INVOICE #"),
                        buildHeaderWithSearch(title: "CUSTOMER"),
                        buildHeaderWithSearch(title: "DATE"),
                        buildHeaderWithSearch(title: "DUE DATE"),
                        buildHeaderWithSearch(title: "STATUS"),
                        buildHeaderWithSearch(title: "AMOUNT"),
                        buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                      ],
                      totalRow: totalRows,

                      rows: invoices.map((invoice) {
                        return DataRow(
                          cells: [
                            DataCell(Text(invoice.invoiceNumber ?? "-")),
                            DataCell(Text(invoice.customer?.name ?? "-")),
                            DataCell(Text(invoice.invoiceDate ?? "-")),
                            DataCell(Text(invoice.invoiceDueDate ?? "-")),
                            DataCell(Text(invoice.status?.toUpperCase() ?? "-")),
                            DataCell(Text(invoice.amount ?? "0")),
                            DataCell(
                              Row(
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.transparent),
                                    ),
                                    onPressed: () {},
                                    child: Icon(Icons.search, size: 28, color: DynamicColors.primaryClr),
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.transparent),
                                    ),
                                    onPressed: () {},
                                    child: Icon(Icons.clear, size: 28, color: DynamicColors.redClr),
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
              ],
            ),
          );
        });
      },
    );
  }
}