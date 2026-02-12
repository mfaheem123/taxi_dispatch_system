import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../alert/delete_permission_alert.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/account_controller.dart';

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

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

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

    return GetBuilder<AccountController>(
        initState: (state) {
controller.listAccountInvoice();
        },

        builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final listToShow = controller.filteredInvoice.isNotEmpty
            ? controller.filteredInvoice
            : controller.InvoiceList;
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
                    "ACCOUNTS Invoice (0)",
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
                  ),
                  SizedBox(
                    width: 12,
                  ),
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
                            SizedBox(height: 30, child: KeyboardDatePicker()),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.to,
                        width: fieldWidth / 1.8,
                        child:
                            SizedBox(height: 30, child: KeyboardDatePicker()),
                      ),
                      Text("STATUS"),
                      CustomDropdownField<String>(
                        width: fieldWidth / 4,
                        label: AppText.status,
                        items: [
                          "Paid 1",
                          "Paid 2",
                          "Paid 3",
                          "Paid 4",
                          "Paid 5",
                          "Paid 6",
                        ],
                        value: controller.status,
                        itemLabel: (val) => val, // just show the string
                        onChanged: (val) {
                          controller.status = val!;
                          controller.update();
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  CustomButton(
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
            controller.isLoadingListOfAccountInvoice == true
                ? Center(
              child: CircularProgressIndicator(),
            )
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: isMobile || isTablet ? Get.width + 600 : Get.width,
                child: DatatableWidget(
                    columns: [
                      DataColumn(
                        label: Checkbox(
                          value: false, // a bool you keep in state
                          onChanged: (val) {},
                        ),
                      ),
                      buildHeaderWithSearch(
                        title: "INVOICE #",
                        onChanged: (v) {
                          controller.searchInvoiceNumber.value = v;
                          controller.SearchAccountInvoice();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "ACCOUNT",
                        onChanged: (v) {
                          controller.searchAccountName.value = v;
                          controller.SearchAccountInvoice();
                        },
                      ),
                      buildHeaderWithSearch(
                        title: "DEPARTMENT",
                        onChanged: (v) {
                          controller.searchDepartment.value = v;
                          controller.SearchAccountInvoice();
                        },
                      ),
                      buildHeaderWithSearch(
                          title: "ORDER #",
                          onChanged: (v) {
                            controller.searchOrderNumber.value = v;
                            controller.SearchAccountInvoice();
                          }),
                      buildHeaderWithSearch(
                          title: "DATE",
                          onChanged: (v) {
                            controller.searchDate.value = v;
                            controller.SearchAccountInvoice();
                          }),
                      buildHeaderWithSearch(
                          title: "DUE DATE",
                          onChanged: (v) {
                            controller.searchDueDate.value = v;
                            controller.SearchAccountInvoice();
                          }),
                      buildHeaderWithSearch(
                          title: "STATUS",
                          onChanged: (v) {
                            controller.searchStatus.value = v;
                            controller.SearchAccountInvoice();
                          }),
                      buildHeaderWithSearch(
                          title: "AMOUNT",
                          onChanged: (v) {
                            controller.searchAmount.value = v;
                            controller.SearchAccountInvoice();
                          }),
                      buildHeaderWithSearch(
                          title: "SUBSIDIARY",
                          onChanged: (v) {
                            controller.searchSubsiDiary.value = v;
                            controller.SearchAccountInvoice();
                          }),
                      buildHeaderWithSearch(
                          title: "ACTIONS", removeSearching: true),
                    ],
                    totalRow: listToShow.length ?? 0,
                    rows: (listToShow ?? []).map((item) {
                      return DataRow(cells: [
                        DataCell(
                          Checkbox(
                            value: false, // ✅ controlled by your state
                            onChanged: (val) {
                              // update your selected index or list here
                            },
                          ),
                        ),
                        DataCell(
                            Center(child: Text(item.invoiceNumber!))),
                        DataCell(Center(child: Text(item.accountName!))),
                        DataCell(Center(child: Text(item.department!))),
                        DataCell(Center(child: Text(item.orderNumber!))),
                        DataCell(Center(child: Text(item.date!))),
                        DataCell(Center(child: Text(item.dueDate!))),
                        DataCell(Center(child: Text(item.status!))),
                        DataCell(Center(child: Text(item.amount!))),
                        DataCell(Center(child: Text(item.subsidiary!))),
                        DataCell(
                          Row(
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                onPressed: () {},
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
                                onPressed: () {},
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
          ],
        );
      });
    });
  }
}
