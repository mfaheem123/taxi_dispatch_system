import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/administration/model/list_subsDiary.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../component/editable_cell_widget.dart';
import '../../../component/responsive_datatable_widget.dart';
import '../../dashboard_view/models/account_darshboard_model.dart';
import '../../setting/model/get_document_number_model.dart';
import '../controller/account_invoice_controller.dart';

class CreateAccountPreInvoice extends StatefulWidget {
  const CreateAccountPreInvoice({super.key});

  @override
  State<CreateAccountPreInvoice> createState() =>
      _CreateAccountPreInvoiceState();
}

class _CreateAccountPreInvoiceState extends State<CreateAccountPreInvoice> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  InvoiceController controller = Get.isRegistered<InvoiceController>()
      ? Get.find<InvoiceController>()
      : Get.put(InvoiceController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "CreateAccountInvoiceScreen";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return PageScrollWrapper(
      child: GetBuilder<InvoiceController>(initState: (state) {
        controller.getAccInvoiceNumber();
        controller.getSubsidiary();
        controller.subsidiaries = null;
        controller.selectAccountValue = null;
        controller.selectDepartmentData = null;
        controller.orderNumber.clear();
        // controller.fromDate = DateTime.now();
        // controller.toDate = DateTime.now();
      }, builder: (controller) {

        final listToShow = controller.filteredAccountPreInvoice.isNotEmpty
            ? controller.filteredAccountPreInvoice
            : controller.preInvoiceAll;

        return LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isMobile = maxWidth < 600;
          final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

          final double totalAvailableWidth = constraints.maxWidth;
          // Instead of fixed width, we calculate flexible field widths
          final double fieldWidth = isMobile
              ? maxWidth // full width
              : isTablet
                  ? maxWidth / 2
                  : maxWidth / 4;

          return controller.isSubsidiary == true
              ? Center(child: CircularProgressIndicator())
              : Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      child: Text(AppText.accountPreInvoice, style: titleDesign()),
                    ),
                    SizedBox(height: 8),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.invoiceDate,
                      column: true,
                      width: fieldWidth / 1.8,
                      child: SizedBox(
                          height: 35,
                          child: KeyboardDatePicker(
                            key: ValueKey("invoice_date_${controller.datePickerKey}"),
                            initialDate: DateTime.now(),
                            onChanged: (date) {
                              setState(() {
                                controller.invoiceDateController = "${date.year}-${date.month}-${date.day}";
                                print(date);
                              });
                            },
                            onSubmitted: (date) {
                              setState(() {
                                controller.invoiceDateController = "${date.year}-${date.month}-${date.day}";
                              });
                              print("User pressed enter: $date");
                            },
                          )),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.invoiceDueDate,
                      column: true,
                      width: fieldWidth / 1.8,
                      child: SizedBox(
                          height: 35,
                          child: KeyboardDatePicker(
                            key: ValueKey("invoice_due_date_${controller.datePickerKey}"),
                            initialDate: DateTime.now().add(Duration(days: 5)),
                            onChanged: (date) {
                              setState(() {
                                controller.invoiceDueDateController = "${date.year}-${date.month}-${date.day}";
                                print(date);
                              });
                            },
                            onSubmitted: (date) {
                              setState(() {
                                controller.invoiceDueDateController = "${date.year}-${date.month}-${date.day}";
                              });
                              print("User pressed enter: $date");
                            },
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: RichText(
                            text: TextSpan(
                                text: 'INVOICE #',
                                style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: () {
                                      final preInvoice = controller.documentNumberModel?.documentNumbers?.firstWhere(
                                            (doc) => doc.documentTable == 'account_pre_invoice',
                                        orElse: () => DocumentNumber(),
                                      );
                                      return " ${preInvoice?.prefix ?? ''}${preInvoice?.endNumber ?? ''}".toUpperCase();
                                    }(),
                                    style: mozillaTextSemiBoldText(color: DynamicColors.redClr, fontWeight: FontWeight.bold),
                                  ),
                                ]
                            )
                        )
                    ),
                    CustomDropdownField<Subsidiaries>(
                      height: 35,
                      text: AppText.subsidiary,
                      width: fieldWidth / 1.5,
                      label: AppText.subsidiary,
                      items: controller.subsDiaryModel?.subsidiaries ?? [],
                      value: controller.subsidiaries,
                      itemLabel: (item) => item.name ?? "",
                      onChanged: (val) {
                        controller.subsidiaries = val;
                        controller.selectAccountValue = null;
                        controller.selectDepartmentData = null;
                        controller.dashboardAccountData = null;
                        controller.getAccountData(subsidiariesId: val!.id);
                      },
                    ),
                    CustomDropdownField<DashboardAccountObject>(
                      height: 35,
                      text: "ACCOUNT",
                      width: fieldWidth / 1.5,
                      label: "ACCOUNT",
                      items: controller.dashboardAccountData?.accounts ?? [],
                      value: (controller.dashboardAccountData?.accounts?.contains(controller.selectAccountValue) ?? false)
                          ? controller.selectAccountValue : null,
                      itemLabel: (item) => item.name ?? "",
                      onChanged: (val) {
                        controller.selectAccountValue = val;
                        controller.selectDepartmentData = null;
                        controller.update();
                      },
                    ),
                    CustomDropdownField<DepartmentObject>(
                      height: 35,
                      text: "DEPARTMENT",
                      width: fieldWidth / 1.5,
                      label: "DEPARTMENT",
                      items: controller.selectAccountValue?.departments ?? [],
                      value: (controller.selectAccountValue?.departments?.contains(controller.selectDepartmentData) ?? false)
                          ? controller.selectDepartmentData : null,
                      itemLabel: (item) => item.name ?? "",
                      onChanged: (val) {
                        controller.selectDepartmentData = val;
                        controller.update();
                      },
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.only(left: 10),
                      child: CustomTextField(
                        borderRadius: 4,
                        controller: controller.orderNumber,
                        width: fieldWidth,
                        hintText: AppText.order,
                        columnText: true,
                        height: 35,
                        inputFormatters: [UpperCaseTextFormatter()],
                      ),
                    ),
                    labeledField(
                      column: true,
                      context: context,
                      isMobile: isMobile,
                      label: AppText.from,
                      width: fieldWidth / 1.8,
                      child: SizedBox(
                        height: 35,
                        child: KeyboardDatePicker(
                          initialDate: controller.preInvFromDate.isNotEmpty
                              ? DateTime.parse(controller.preInvFromDate)
                              : DateTime.now().add(Duration(days: 1)),
                          onChanged: (date) {
                            controller.preInvFromDate = date.toIso8601String().split("T").first;
                            controller.update();
                          },
                          onSubmitted: (date) {
                            controller.preInvFromDate = date.toIso8601String().split("T").first;
                            controller.update();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    labeledField(
                      column: true,
                      context: context,
                      isMobile: isMobile,
                      label: AppText.to,
                      width: fieldWidth / 1.8,
                      child: SizedBox(
                          height: 35,
                          child: KeyboardDatePicker(
                            initialDate: controller.preInvToDate.isNotEmpty
                                ? DateTime.parse(controller.preInvToDate)
                                : DateTime.now().add(Duration(days: 7)),
                            onChanged: (date) {
                              controller.preInvToDate = date.toIso8601String().split("T").first;
                              controller.update();
                            },
                            onSubmitted: (date) {
                              controller.preInvToDate = date.toIso8601String().split("T").first;
                              controller.update();
                            },
                          )),
                    ),
                    SizedBox(width: 50),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomButton(
                        verticalPadding: 0.0,
                        width: 80,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.filter,
                        style: mozillaTextSemiBoldText(fontSize: 13, color: DynamicColors.whiteClr),
                        onTap: () {
                          controller.getAccInvoiceNumber();
                          controller.getPreInvoiceFilter();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomButton(
                        verticalPadding: 0.0,
                        width: 80,
                        height: 30,
                        borderRadius: 4,
                        btnText: AppText.save,
                        style: mozillaTextSemiBoldText(fontSize: 13, color: DynamicColors.whiteClr),
                        onTap: () {},
                      ),
                    ),
                    ResponsiveDataTableWidget(
                        totalWidth: totalAvailableWidth,
                        columnConfigs: [
                          TableColumnConfig(
                            title: "SELECT",
                            sizeType: ColumnSizeType.fixed,
                            fixedWidth: 35,
                            removeSearching: true,
                            customHeader: Checkbox(
                              value: controller.isAllSelected,
                              onChanged: (val) {
                                controller.isAllSelected = val ?? false;
                                controller.selectedCreateBookingIds.clear();
                                if (controller.isAllSelected) {
                                  controller.selectedCreateBookingIds.addAll(
                                      controller.accPreInvFilterModel!.bookings!.map((e) => e.id.toString()));
                                }
                                controller.recalculateCreateInvoiceTotal(null);
                                controller.update();
                              },
                            ),
                          ),
                          TableColumnConfig(
                              title: "REF#", sizeType: ColumnSizeType.medium,
                              onChanged: (v) {
                                controller.searchRef.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "DATETIME", sizeType: ColumnSizeType.medium,
                              onChanged: (v) {
                                controller.searchDateTime.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "PICKUP", sizeType: ColumnSizeType.large,
                              onChanged: (v) {
                                controller.searchPickup.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "DROPOFF", sizeType: ColumnSizeType.large,
                              onChanged: (v) {
                                controller.searchDropOff.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "CUST", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchCustomer.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "VEH", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchVehicle.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "J/T", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchJourType.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "P/T", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchPaymentType.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "FARE", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchFare.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "PC", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchPc.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "WC", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchWc.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "EDC", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchEdc.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "M&G", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchMg.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "CC", sizeType: ColumnSizeType.small,
                              onChanged: (v) {
                                controller.searchCc.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "TOTAL", sizeType: ColumnSizeType.medium,
                              onChanged: (v) {
                                controller.searchTotal.value = v;
                                controller.onSearchPreInvoice();
                              }),
                          TableColumnConfig(
                              title: "ACTIONS",
                              sizeType: ColumnSizeType.fixed,
                              fixedWidth: 70,
                              removeSearching: true),
                        ],
                        items: listToShow.isEmpty
                            ? []
                            : [
                          ...listToShow,
                          ...?controller.accPreInvFilterModel?.total?.map((t) => {'type': 'TOTAL', 'data': t}),
                          ...?controller.accPreInvFilterModel?.total?.map((t) => {'type': 'GRAND_TOTAL', 'data': t}),
                        ],
                        rowBuilder: (item, widths) {

                          if (item is Map && item['type'] == 'TOTAL') {
                            final totalData = item['data'];
                            return [
                              "", "", "", "", "", "", "", "",
                              Center(child: Text("TOTAL", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 12))),
                              Center(child: Text("£${totalData.fareTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.parkingChargesTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.waitingChargesTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.extraDropChargesTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.meetAndGreetTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.congestionChargesTotal ?? "0.00"}")),
                              Center(child: Text("£${totalData.total ?? "0.00"}", style: mozillaTextSemiBoldText(color: Colors.blue, fontSize: 12))),
                              "",
                            ];
                          }

                          // 2. GRAND TOTAL ROW HANDLING
                          if (item is Map && item['type'] == 'GRAND_TOTAL') {
                            final totalData = item['data'];
                            return [
                              "", "", "", "", "", "", "", "",
                              Center(child: Text("GRAND\nTOTAL", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 12))),
                              "", "", "", "", "", "",
                              Center(child: Text("£${totalData.grandTotal ?? "0.00"}", style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 12))),
                              "",
                            ];
                          }

                          final modelItem = item;
                          return [
                            Center(
                              child:  Checkbox(
                                value: controller.selectedCreateBookingIds.contains(modelItem.id),
                                onChanged: (val) {
                                  if (val == true) {
                                    controller.selectedCreateBookingIds.add(modelItem.id!);
                                  } else {
                                    controller.selectedCreateBookingIds.remove(modelItem.id);
                                  }
                                  controller.isAllSelected = controller.selectedCreateBookingIds.length ==
                                      controller.accPreInvFilterModel!.bookings!.length;
                                  controller.recalculateCreateInvoiceTotal(modelItem, isPreInvoice: true);
                                  controller.update();
                                },
                              ),
                            ),
                            Center(child: Text(modelItem.referenceNumber ?? "")),
                            Center(child: Text("${(modelItem.pickupDate ?? "").toString().split(' ')[0]} ${(modelItem.pickupTime ?? "").toString().split('.')[0].substring(0, 5)}")),
                            Center(child: Text(modelItem.pickup ?? "")),
                            Center(child: Text(modelItem.dropoff ?? "")),
                            Center(child: Text(modelItem.customer?.address1 ?? "")),
                            Center(child: Text(modelItem.vehicleType?.name ?? "")),
                            Center(child: Text(modelItem.journeyType?.journeyType ?? "")),
                            Center(child: Text(modelItem.paymentType?.name ?? "")),
                            EditableCellWidget(
                              initialValue: modelItem.fares,
                              onChanged: (val) {
                                modelItem.fares = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(modelItem, isPreInvoice: true);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: modelItem.parkingCharges,
                              onChanged: (val) {
                                modelItem.parkingCharges = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(modelItem, isPreInvoice: true);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: modelItem.waitingCharges,
                              onChanged: (val) {
                                modelItem.waitingCharges = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(modelItem, isPreInvoice: true);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: modelItem.extraDropCharges,
                              onChanged: (val) {
                                modelItem.extraDropCharges = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(modelItem, isPreInvoice: true);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: modelItem.meetAndGreet,
                              onChanged: (val) {
                                modelItem.meetAndGreet = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(modelItem, isPreInvoice: true);
                              },
                            ),
                            EditableCellWidget(
                              initialValue: modelItem.congestionCharges,
                              onChanged: (val) {
                                modelItem.congestionCharges = (double.tryParse(val) ?? 0.0).toString();
                                controller.recalculateCreateInvoiceTotal(modelItem, isPreInvoice: true);
                                controller.update();
                              },
                            ),
                            Center(
                              child: Text(
                                "£${modelItem.totalCharges ?? '0.0'}",
                                style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            Center(
                              child: CustomButton(
                                verticalPadding: 0.0,
                                width: 55,
                                height: 26,
                                borderRadius: 4,
                                btnText: "SAVE",
                                btnColor: DynamicColors.primaryClr,
                                style: mozillaTextRegularText(
                                    fontSize: 10,
                                    color: DynamicColors.whiteClr),
                                onTap: () {
                                  if (modelItem != null) {
                                    controller.updateBookingCharges(modelItem);
                                    print("Updating Booking ID: ${modelItem.id}");
                                  }
                                },
                              ),
                            ),
                          ];
                        }),
                  ],
                );
        });
      }),
    );
  }
}
