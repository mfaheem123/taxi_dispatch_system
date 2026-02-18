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
          controller.listAccountInvoice();

        },

        builder: (controller) {
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
            final listToShow = controller.filteredAccountInvoice.isNotEmpty
                ? controller.filteredAccountInvoice
                : controller.accountInvoiceListAll;
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
                          "ACCOUNTS Invoice (${controller.listOfAccountInvoice!.count ?? "0"})",
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
                                  label: "Status",
                                  items: ["ALL", "PAID", "UNPAID",],
                                  value: controller.status,
                                  itemLabel: (val) => val, // just show the string
                                  onChanged: (val) {
                                    controller.status = val!;
                                    controller.update();
                                  },
                                ),
                              ],
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
                                controller.invoiceNumber.value = v;
                                controller.listAccountInvoice();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "ACCOUNT",
                              onChanged: (v) {
                                controller.searchAccount.value = v;
                                controller.listAccountInvoice();
                              },
                            ),
                            buildHeaderWithSearch(
                              title: "DEPARTMENT",
                              onChanged: (v) {
                                controller.searchDepartment.value = v;
                                controller.listAccountInvoice();
                                },
                            ),
                            buildHeaderWithSearch(
                              title: "ORDER #",
                              onChanged: (v) {
                                controller.searchOrder.value = v;
                                controller.listAccountInvoice();
                              }
                            ),
                            buildHeaderWithSearch(
                              title: "DATE",
                              onChanged: (v) {
                                controller.searchDate.value = v;
                                controller.listAccountInvoice();
                               }
                            ),
                            buildHeaderWithSearch(
                              title: "DUE DATE",
                              onChanged: (v) {
                                controller.searchDueDate.value = v;
                                controller.listAccountInvoice();
                              }
                            ),
                            buildHeaderWithSearch(
                              title: "STATUS",
                              onChanged: (v) {
                                controller.searchStatus.value = v;
                                controller.listAccountInvoice();
                              }
                            ),
                            buildHeaderWithSearch(
                              title: "AMOUNT",
                              onChanged: (v) {
                                controller.searchAmount.value = v;
                                controller.listAccountInvoice();
                              }
                            ),
                            buildHeaderWithSearch(
                              title: "SUBSIDIARY",
                              onChanged: (v) {
                                controller.searchSubsidiary.value = v;
                                controller.listAccountInvoice();
                              }
                            ),
                            buildHeaderWithSearch(
                                title: "ACTIONS", removeSearching: true),
                          ],
                          totalRow: listToShow.length ?? 0,
                          rows: (listToShow ?? []).map((item) {
                            return DataRow(cells: [
                              DataCell(
                                Checkbox(
                                  value: false,
                                  onChanged: (val) {

                                  },
                                ),
                              ),
                              DataCell(
                                  Center(child: Text(item.invoiceNumber!))),
                              DataCell(Center(child: Text(item.account!.name!))),
                              DataCell(Center(child: Text(item.account!.email ?? ""))),
                              DataCell(Center(child: Text(item.orderNumber!))),
                              DataCell(Center(child: Text(item.toDate.toString()))),
                              DataCell(Center(child: Text(item.fromDate.toString()))),
                              DataCell(Center(child: Text(item.status!))),
                              DataCell(Center(child: Text(item.amount!))),
                              DataCell(Center(child: Text(item.orderNumber!))),
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
                                        // controller.bindAccountInvoiceValue(item);


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
                ],
              );
          });
        });
  }
}