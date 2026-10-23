import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/keyboard_checkBox_widget.dart';
import 'package:dashboard_new1/view/invoices/customer_invoices/update_customer_invoice.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/customer_invoice_controller.dart';

class CustomerPreInvoiceList extends StatefulWidget {
  const CustomerPreInvoiceList({super.key});

  @override
  State<CustomerPreInvoiceList> createState() => _CustomerPreInvoiceListState();
}

class _CustomerPreInvoiceListState extends State<CustomerPreInvoiceList> {
  CustomerInvoiceController controller = Get.isRegistered<CustomerInvoiceController>()
      ? Get.find<CustomerInvoiceController>()
      : Get.put(CustomerInvoiceController());

  final DashboardController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "customerPreInvoiceList";
  }

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<CustomerInvoiceController>(
        initState: (state) {
        },
        builder: (controller) {

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
                            AppText.customerPreInvoices,
                            style: titleDesign()
                        ),
                        const SizedBox(width: 120),
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

                  SingleChildScrollView(
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(title: "INVOICE #", onChanged: (value) {}),
                          buildHeaderWithSearch(title: "CUSTOMER", onChanged: (value) {}),
                          buildHeaderWithSearch(title: "DATE", onChanged: (value) {}),
                          buildHeaderWithSearch(title: "DUE DATE", onChanged: (value) {}),
                          buildHeaderWithSearch(title: "STATUS", onChanged: (value) {}),
                          buildHeaderWithSearch(title: "AMOUNT", onChanged: (value) {}),
                          buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                        ],
                        totalRow: 2, // Static total rows count
                        rows: [
                          // Static Row 1
                          DataRow(
                            cells: [
                              const DataCell(Center(child: Text("CINV635168"))),
                              const DataCell(Center(child: Text("CUSTOMER TESTTT"))),
                              const DataCell(Center(child: Text("2026-04-01"))),
                              const DataCell(Center(child: Text("2026-04-08"))),
                              const DataCell(Center(child: Text("PAID"))),
                              const DataCell(Center(child: Text("£ 65.00"))),
                              DataCell(
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.transparent),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {},
                                        child: Icon(Icons.edit_calendar, size: 28, color: DynamicColors.primaryClr),
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.transparent),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {},
                                        child: Icon(Icons.delete_forever, size: 28, color: DynamicColors.redClr),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Static Row 2
                          DataRow(
                            cells: [
                              const DataCell(Center(child: Text("CINV194852"))),
                              const DataCell(Center(child: Text("JOHN DOE"))),
                              const DataCell(Center(child: Text("2026-04-02"))),
                              const DataCell(Center(child: Text("2026-04-09"))),
                              const DataCell(Center(child: Text("PENDING"))),
                              const DataCell(Center(child: Text("£ 120.00"))),
                              DataCell(
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.transparent),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {},
                                        child: Icon(Icons.edit_calendar, size: 28, color: DynamicColors.primaryClr),
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.transparent),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {},
                                        child: Icon(Icons.delete_forever, size: 28, color: DynamicColors.redClr),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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