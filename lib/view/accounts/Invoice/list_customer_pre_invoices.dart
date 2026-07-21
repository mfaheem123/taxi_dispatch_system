import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/textStyle.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import 'create_customer_pre_invoice.dart';
import '../controller/preinvoice_controller.dart';

class PreInvoiceList extends StatelessWidget {
   PreInvoiceList({super.key});

  final dashboardController = Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerPreInvoiceController>(
      init: CustomerPreInvoiceController(),
      builder: (controller) {
        return LayoutBuilder(builder: (context, constraints) {
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
                          "CUSTOMER PRE INVOICES (${controller.filteredPreInvoices.length})",
                          style: titleDesign()
                      ),
                      const SizedBox(width: 120),
                      KeyboardCheckbox(
                        onChanged: (v) {
                          controller.togglePaid(v);
                        },
                        label: "PAID",
                        value: controller.isPaid,
                        focusNode: controller.paidNode,
                        width: 200,
                      ),
                      const Spacer(),
                      CustomButton(
                        height: 35,
                        width: 45,
                        btnColor: DynamicColors.primaryClr,
                        verticalPadding: 0.0,
                        borderRadius: 4,
                        onTap: () {
                          // refresh logic here
                        },
                        widget: const Center(
                          child: Icon(
                            Icons.autorenew,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "INVOICE #", onChanged: (val) {
                          controller.searchQuery = val;
                          controller.update();
                        }),
                        buildHeaderWithSearch(title: "CUSTOMER", onChanged: (val) {
                          controller.searchQuery = val;
                          controller.update();
                        }),
                        buildHeaderWithSearch(title: "DATE", onChanged: (val) {
                          controller.searchQuery = val;
                          controller.update();
                        }),
                        buildHeaderWithSearch(title: "DUE DATE", onChanged: (val) {
                          controller.searchQuery = val;
                          controller.update();
                        }),
                        buildHeaderWithSearch(title: "STATUS", onChanged: (val) {
                          controller.searchQuery = val;
                          controller.update();
                        }),
                        buildHeaderWithSearch(title: "AMOUNT", onChanged: (val) {
                          controller.searchQuery = val;
                          controller.update();
                        }),
                        buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                      ],
                      totalRow: controller.filteredPreInvoices.length,
                      rows: controller.filteredPreInvoices.map((invoice) {
                        return DataRow(
                          cells: [
                            DataCell(Text(invoice["invoiceNumber"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            DataCell(Text(invoice["customer"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            DataCell(Text(invoice["date"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            DataCell(Text(invoice["dueDate"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: invoice["status"] == "UNPAID" ? Colors.red : Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  invoice["status"],
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              )
                            ),
                            DataCell(Text("£${invoice["amount"]}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _actionButton(Icons.edit, Colors.green, onTap: () {
                                    controller.setEditData(invoice);
                                    dashboardController.currentPage.value = const CustomerPreInvoice();
                                    dashboardController.menuBarRefresh(
                                        title: "CREATE CUSTOMER PRE INVOICE",
                                        pageName: const CustomerPreInvoice());
                                  }),
                                  _actionButton(Icons.delete, Colors.red),
                                  _actionButton(Icons.copy, Colors.blue),
                                  _actionButton(Icons.email, Colors.blue.shade800),
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
      }
    );
  }

  Widget _actionButton(IconData icon, Color color, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: onTap ?? () {},
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
