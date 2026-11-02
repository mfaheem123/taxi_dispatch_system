import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';

import '../../../alert/search_booking.dart';

class ListOfAccountPreInvoiceScreen extends StatefulWidget {
  const ListOfAccountPreInvoiceScreen({super.key});

  @override
  State<ListOfAccountPreInvoiceScreen> createState() =>
      _ListOfAccountPreInvoiceScreenState();
}

class _ListOfAccountPreInvoiceScreenState
    extends State<ListOfAccountPreInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    double width = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return PageScrollWrapper(
      child: LayoutBuilder(builder: (context, constraints) {
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
            // Top Header Bar
            Container(
              width: width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: DynamicColors.gryClr.withOpacity(0.5),
              child: Row(
                children: [
                  Text(
                    "ACCOUNT PRE INVOICES",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  const Spacer(),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 60,
                    height: 40,
                    borderRadius: 4,
                    btnText: AppText.create,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    onTap: () {},
                    height: 40,
                    width: 80,
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
                        initialDate: DateTime.now(),
                        onChanged: (fromDate) {},
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
                        initialDate: DateTime.now(),
                        onChanged: (toDate) {},
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
                        value: "ALL",
                        itemLabel: (val) => val,
                        onChanged: (val) {},
                      ),
                    ],
                  ),

                  // Action Buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        onTap: () {},
                        verticalPadding: 0.0,
                        width: 60,
                        height: 40,
                        borderRadius: 4,
                        btnText: AppText.clear,
                        style: mozillaTextRegularText(fontSize: 10, color: DynamicColors.whiteClr),
                      ),
                      const SizedBox(width: 15),
                      CustomButton(
                        onTap: () {},
                        verticalPadding: 0.0,
                        width: 60,
                        height: 40,
                        borderRadius: 4,
                        btnText: AppText.search,
                        style: mozillaTextRegularText(fontSize: 10, color: DynamicColors.whiteClr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: isMobile || isTablet ? width + 600 : width,
                child: DatatableWidget(
                  columns: [
                    buildHeaderWithSearch(title: "INVOICE #", onChanged: (v) {}),
                    buildHeaderWithSearch(title: "ACCOUNT", onChanged: (v) {}),
                    buildHeaderWithSearch(title: "DEPARTMENT", onChanged: (v) {}),
                    buildHeaderWithSearch(title: "ORDER #", onChanged: (v) {}),
                    buildHeaderWithSearch(title: "DATE", onChanged: (v) {}),
                    buildHeaderWithSearch(title: "DUE DATE", onChanged: (v) {}),
                    buildHeaderWithSearch(title: "STATUS", onChanged: (v) {}),
                    buildHeaderWithSearch(title: "AMOUNT", onChanged: (v) {}),
                    buildHeaderWithSearch(title: "SUBSIDIARY", onChanged: (v) {}),
                    buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                  ],
                  totalRow: 3,
                  rows: [
                    // Row 1
                    DataRow(cells: [
                      DataCell(Center(child: Text("INV-001"))),
                      DataCell(Center(child: Text("ABC CORPORATION"))),
                      DataCell(Center(child: Text("SALES"))),
                      DataCell(Center(child: Text("ORD-9876"))),
                      DataCell(Center(child: Text("2026-06-01"))),
                      DataCell(Center(child: Text("2026-06-15"))),
                      DataCell(Center(child: Text("PAID"))),
                      DataCell(Center(child: Text("1,500.00"))),
                      DataCell(Center(child: Text("SUBSIDIARY A"))),
                      DataCell(
                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.transparent)),
                              onPressed: () {},
                              child: Icon(Icons.edit_calendar_rounded, size: 28, color: DynamicColors.primaryClr),
                            ),
                            const Text("|"),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.transparent)),
                              onPressed: () {},
                              child: Icon(Icons.delete_forever, size: 28, color: DynamicColors.redClr),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}