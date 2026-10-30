import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:dashboard_new1/view/administration/model/list_subsDiary.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import 'package:dashboard_new1/view/invoices/model/account_invoice_model.dart';

import '../../../component/editable_cell_widget.dart';
import '../../../component/networks/api.dart';
import '../../../component/responsive_datatable_widget.dart';
import '../../dashboard_view/models/account_darshboard_model.dart';
import '../controller/account_invoice_controller.dart';

class CreateAccountPreInvoice extends StatefulWidget {
  const CreateAccountPreInvoice({super.key});

  @override
  State<CreateAccountPreInvoice> createState() =>
      _CreateAccountPreInvoiceState();
}

class _CreateAccountPreInvoiceState
    extends State<CreateAccountPreInvoice> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  InvoiceController Controller = Get.isRegistered<InvoiceController>()
      ? Get.find<InvoiceController>()
      : Get.put(InvoiceController());
  List permissions = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permissions = Api().sp.read('all_permissions') ?? [];
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
        Controller.fromDate = DateTime.now();
        Controller.toDate = DateTime.now();
      }, builder: (controller) {
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
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12),
                color: DynamicColors.gryClr.withOpacity(0.5),
                child: Text(AppText.accountPreInvoice, style: titleDesign()),
              ),
              SizedBox(
                height: 8,
              ),
              labeledField(
                context: context,
                isMobile: isMobile,
                label: AppText.invoiceDate,
                column: true,
                width: fieldWidth / 1.8,
                child: SizedBox(
                    height: 35,
                    child: KeyboardDatePicker(
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
                    )),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: RichText(
                      text: TextSpan(
                          text: 'INVOICE #',
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.bold),
                         ))),
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
                    ? controller.selectAccountValue
                    : null,
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
                    ? controller.selectDepartmentData
                    : null,
                itemLabel: (item) => item.name ?? "",
                onChanged: (val) {
                  controller.selectDepartmentData = val;
                  controller.update();
                },
              ),

              Padding(padding: EdgeInsetsGeometry.only(left: 10),
                child: CustomTextField(
                  borderRadius: 4,
                  controller: controller.orderNumber,
                  width: fieldWidth,
                  hintText: AppText.order,
                  columnText: true,
                  height: 35,
                  inputFormatters: [UpperCaseTextFormatter()
                  ],
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
                       )),
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
                  style: mozillaTextSemiBoldText(
                      fontSize: 10, color: DynamicColors.whiteClr),
                  onTap: () {
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
                  style: mozillaTextSemiBoldText(
                      fontSize: 10, color: DynamicColors.whiteClr),
                  onTap: () {
                  },
                ),
              ),

              ResponsiveDataTableWidget(
                  totalWidth: totalAvailableWidth,
                  columnConfigs: [
                    TableColumnConfig(
                        title: "CHECKBOX",
                        sizeType: ColumnSizeType.fixed,
                        fixedWidth: 40,
                        customHeader: Checkbox(
                          value: false,
                          onChanged: (bool? val) {},
                        )),
                    TableColumnConfig(title: "REF#", sizeType: ColumnSizeType.medium),
                    TableColumnConfig(title: "DATETIME", sizeType: ColumnSizeType.medium),
                    TableColumnConfig(title: "PICKUP", sizeType: ColumnSizeType.large),
                    TableColumnConfig(title: "DROPOFF", sizeType: ColumnSizeType.large),
                    TableColumnConfig(title: "VEH", sizeType: ColumnSizeType.small),
                    TableColumnConfig(title: "J/T", sizeType: ColumnSizeType.small),
                    TableColumnConfig(title: "P/T", sizeType: ColumnSizeType.small),
                    TableColumnConfig(title: "FARE", sizeType: ColumnSizeType.small),
                    TableColumnConfig(title: "PC", sizeType: ColumnSizeType.small),
                    TableColumnConfig(title: "WC", sizeType: ColumnSizeType.small),
                    TableColumnConfig(title: "EDC", sizeType: ColumnSizeType.small),
                    TableColumnConfig(title: "M&G", sizeType: ColumnSizeType.small),
                    TableColumnConfig(title: "CC", sizeType: ColumnSizeType.small),
                    TableColumnConfig(title: "TOTAL", sizeType: ColumnSizeType.medium),
                    TableColumnConfig(
                        title: "ACTIONS",
                        sizeType: ColumnSizeType.fixed,
                        fixedWidth: 70,
                        removeSearching: true),
                  ],
                  items: const [
                    "ROW_1",
                    "ROW_2",
                    "TOTAL_ROW"
                  ],
                  rowBuilder: (item, widths) {
                    if (item == "TOTAL_ROW") {
                      return [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        const Center(
                          child: Text("TOTAL",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        const Center(
                            child: Text("£ 60.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 11))),
                        const Center(
                            child: Text("£ 5.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 11))),
                        const Center(
                            child: Text("£ 0.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 11))),
                        const Center(
                            child: Text("£ 0.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 11))),
                        const Center(
                            child: Text("£ 0.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 11))),
                        const Center(
                            child: Text("£ 0.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 11))),
                        const Center(
                            child: Text("£ 65.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 11))),
                        "",
                      ];
                    }

                    // Static Dummy Data Helper Widget for Editable Cells
                    Widget staticEditableCell(String initialVal) {
                      return Center(
                        child: SizedBox(
                          width: 50,
                          child: TextFormField(
                            initialValue: initialVal,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 4),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {},
                          ),
                        ),
                      );
                    }

                    return [
                      Center(
                        child: Checkbox(
                          value: false,
                          onChanged: (bool? val) {},
                        ),
                      ),
                      const Center(child: Text("REF-1001")),
                      const Center(child: Text("2026-04-01 12:18")),
                      const Center(child: Text("1 WARRIOR GARDENS")),
                      const Center(child: Text("36 DUKE ROAD")),
                      const Center(child: Text("SALOON")),
                      const Center(child: Text("ASAP")),
                      const Center(child: Text("CASH")),
                      staticEditableCell("30.00"),
                      staticEditableCell("5.00"),
                      staticEditableCell("0.00"),
                      staticEditableCell("0.00"),
                      staticEditableCell("0.00"),
                      staticEditableCell("0.00"),
                      const Center(child: Text("£ 35.00")),
                      Center(
                        child: CustomButton(
                          verticalPadding: 0.0,
                          width: 55,
                          height: 26,
                          borderRadius: 4,
                          btnText: "SAVE",
                          btnColor: DynamicColors.primaryClr,
                          style: mozillaTextRegularText(
                              fontSize: 10, color: DynamicColors.whiteClr),
                          onTap: () {},
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
