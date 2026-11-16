import 'package:dashboard_new1/component/responsive_datatable_widget.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/services.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../customer/model/search_customer_by_mobile.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/customer_invoice_controller.dart';

class CreateCustomerPreInvoice extends StatefulWidget {
  const CreateCustomerPreInvoice({super.key});

  @override
  State<CreateCustomerPreInvoice> createState() => _CreateCustomerPreInvoiceState();
}

class _CreateCustomerPreInvoiceState extends State<CreateCustomerPreInvoice> {
  int selectedRowIndex = 0;
  final int totalRows = 5;
  final ScrollController _autocompleteScrollController = ScrollController();

  CustomerInvoiceController controller = Get.isRegistered<CustomerInvoiceController>()
      ? Get.find<CustomerInvoiceController>()
      : Get.put(CustomerInvoiceController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "CreateCustomerPreInvoice";
    // controller.setDefaultDates();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return PageScrollWrapper(
      child: GetBuilder<CustomerInvoiceController>(initState: (v) {
        controller.getPaymentTypes();
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

          return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                      width: Get.width,
                      padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      child: Text(AppText.customerPreInvoice, style: titleDesign()),
                    ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        labeledField(
                          context: context,
                          isMobile: isMobile,
                          label: AppText.invoiceDate,
                          column: true,
                          width: fieldWidth / 1.8,
                          child: SizedBox(
                              height: 30,
                              child: KeyboardDatePicker(
                                key: ValueKey("invoice_date_${controller.datePickerKey}"),
                                initialDate: DateTime.now(),
                                onChanged: (date) {
                                  setState(() {
                                    controller.customerInvoiceDateController =
                                    "${date.year}-${date.month}-${date.day}";
                                    print(date);
                                  });
                                },
                                onSubmitted: (date) {
                                  setState(() {
                                    controller.customerInvoiceDateController =
                                    "${date.year}-${date.month}-${date.day}";
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
                              height: 30,
                              child: KeyboardDatePicker(
                                key: ValueKey("invoice_due_date_${controller.datePickerKey}"),
                                initialDate: DateTime.now().add(Duration(days: 7)),
                                onChanged: (date) {
                                  setState(() {
                                    controller.customerInvoiceDueDateController =
                                    "${date.year}-${date.month}-${date.day}";
                                    print(date);
                                  });
                                },
                                onSubmitted: (date) {
                                  setState(() {
                                    controller.customerInvoiceDueDateController =
                                    "${date.year}-${date.month}-${date.day}";
                                  });
                                  print("User pressed enter: $date");
                                },
                              )),
                        ),
                        SizedBox(width: 20),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: RichText(
                              text: TextSpan(
                                  text: 'INVOICE #',
                                  style: mozillaTextSemiBoldText(
                                      fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            borderRadius: 4,
                            controller: controller.customerNameController,
                            width: double.infinity,
                            hintText: AppText.name,
                            columnText: true,
                            height: 30,
                            inputFormatters: [UpperCaseTextFormatter(),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            borderRadius: 4,
                            controller: controller.customerEmailController,
                            width: double.infinity,
                            hintText: AppText.email,
                            columnText: true,
                            height: 30,
                            inputFormatters: [UpperCaseTextFormatter(),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AppText.mobile,
                                    style: mozillaTextSemiBoldText(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black)),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 30,
                                  child: RawAutocomplete<SearchCustomer>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) async {
                                      if (textEditingValue.text.length < 2) {
                                        return const Iterable<
                                            SearchCustomer>.empty();
                                      }
                                      await controller.getCustomer(textEditingValue.text);
                                      return controller.searchCustomerByMobileModel?.customer ??
                                          const Iterable<SearchCustomer>.empty();
                                    },
                                    displayStringForOption: (SearchCustomer option) => option.mobile ?? '',

                                    //  INPUT FIELD VIEW
                                    fieldViewBuilder: (context,
                                        textEditingController,
                                        focusNode,
                                        onFieldSubmitted) {
                                      if (controller.customerMobileController.text.isEmpty) {
                                        textEditingController.clear();
                                      } else if (textEditingController.text.isEmpty &&
                                          controller.customerMobileController.text.isNotEmpty) {
                                        textEditingController.text = controller.customerMobileController.text;
                                      }

                                      return TextField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        onSubmitted: (value) => onFieldSubmitted(),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          // isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                          hintText: AppText.mobile,
                                          hintStyle: mozillaTextSemiBoldText(
                                              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(4)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            borderSide: BorderSide(color: DynamicColors.primaryClr),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            borderSide: BorderSide(color: DynamicColors.primaryClr),
                                          ),
                                          suffixIcon: controller.isSearchingCustomer
                                              ? const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: SizedBox(
                                                width: 12,
                                                height: 12,
                                                child:
                                                CircularProgressIndicator(strokeWidth: 1.5)),
                                          ) : null,
                                        ),
                                        style: mozillaTextSemiBoldText(
                                            fontSize: 10, fontWeight: FontWeight.w800),
                                        onChanged: (val) {
                                          controller.customerMobileController.text = val;
                                        },
                                      );
                                    },

                                    optionsViewBuilder: (context, onSelected, options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 4.0,
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white,
                                          child: Container(
                                            width: constraints.maxWidth,
                                            height: 250,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.grey.shade200),
                                            ),
                                            child: Builder(
                                              builder: (context) {
                                                final int highlightedIndex = AutocompleteHighlightedOption.of(context);
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  if (_autocompleteScrollController.hasClients && highlightedIndex >= 0) {
                                                    final double itemHeight = 35.0;
                                                    final double targetOffset = highlightedIndex * itemHeight;

                                                    final double currentScroll = _autocompleteScrollController.position.pixels;
                                                    final double viewportHeight = 250.0;
                                                    if (targetOffset + itemHeight > currentScroll + viewportHeight) {
                                                      _autocompleteScrollController.animateTo(
                                                        (targetOffset + itemHeight - viewportHeight).clamp(0.0, _autocompleteScrollController.position.maxScrollExtent),
                                                        duration: const Duration(milliseconds: 80),
                                                        curve: Curves.easeOut,
                                                      );
                                                    }
                                                    else if (targetOffset < currentScroll) {
                                                      _autocompleteScrollController.animateTo(
                                                        targetOffset.clamp(0.0, _autocompleteScrollController.position.maxScrollExtent),
                                                        duration: const Duration(milliseconds: 80),
                                                        curve: Curves.easeOut,
                                                      );
                                                    }
                                                  }
                                                });

                                                return ListView.builder(
                                                  controller: _autocompleteScrollController,
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: options.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    final SearchCustomer option = options.elementAt(index);
                                                    final bool highlight = highlightedIndex == index;

                                                    return InkWell(
                                                      onTap: () => onSelected(option),
                                                      child: Container(
                                                        color: highlight ? const Color(0xFFE1F2FE) : null,
                                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              (option.name ?? '').toUpperCase(),
                                                              style: const TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 13,
                                                                  color: Colors.black),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Text(
                                                              "${option.mobile ?? ''}",
                                                              style: const TextStyle(color: Colors.black, fontSize: 13),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },

                                    // ACTION ON SELECTION
                                    onSelected: (SearchCustomer selection) {
                                      controller.selectedCustomerId = selection.id;
                                      controller.customerMobileController.text =
                                          selection.mobile ?? '';
                                      controller.customerNameController.text =
                                          (selection.name ?? '').toUpperCase();
                                      controller.customerEmailController.text =
                                          (selection.email ?? '').toUpperCase();
                                      controller.customerTelephoneController.text =
                                          selection.telephone ?? '';
                                      controller.update();
                                    },
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            borderRadius: 4,
                            controller: controller.customerTelephoneController,
                            width: double.infinity,
                            hintText: AppText.tel,
                            columnText: true,
                            height: 30,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Wrap(
                      runSpacing: 10,
                      spacing: maxWidth < 1366 ? 6 : 10,
                      children: [
                        labeledField(
                          context: context,
                          isMobile: isMobile,
                          label: AppText.from,
                          width: maxWidth < 1366 ? fieldWidth / 2.2 : fieldWidth / 1.8,
                          child: SizedBox(
                            height: 30,
                            child: KeyboardDatePicker(
                              key: ValueKey("from_date_${controller.datePickerKey}"),
                              initialDate: controller.filterFromDate.isNotEmpty
                                  ? DateTime.parse(controller.filterFromDate)
                                  : DateTime.now().add(Duration(days: 1)),
                              onChanged: (date) {
                                controller.filterFromDate = date.toIso8601String().split("T").first;
                                controller.update();
                              },
                              onSubmitted: (date) {
                                controller.filterFromDate = date.toIso8601String().split("T").first;
                                controller.update();
                              },
                            ),
                          ),
                        ),
                        labeledField(
                          context: context,
                          isMobile: isMobile,
                          label: AppText.to,
                          width: maxWidth < 1366 ? fieldWidth / 2.2 : fieldWidth / 1.8,
                          child: SizedBox(
                            height: 30,
                            child: KeyboardDatePicker(
                              key: ValueKey("to_date_${controller.datePickerKey}"),
                              initialDate: controller.filterToDate.isNotEmpty
                                  ? DateTime.parse(controller.filterToDate)
                                  : DateTime.now().add(Duration(days: 7)),
                              onChanged: (date) {
                                controller.filterToDate = date.toIso8601String().split("T").first;
                                controller.update();
                              },
                              onSubmitted: (date) {
                                controller.filterToDate = date.toIso8601String().split("T").first;
                                controller.update();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: maxWidth < 1366 ? 4 : 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: maxWidth < 1366 ? 4.0 : 10.0),
                          child: Transform.translate(
                              offset: const Offset(0, 6),
                              child: Text(AppText.pt,
                                  style: mozillaTextSemiBoldText(
                                      context: context,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: DynamicColors.primaryClr))),
                        ),
                        if (controller.isLoadingPayments)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2)),
                          )
                        else
                          ...?controller.paymentTypeModel?.paymentTypes
                              ?.map((payment) {
                            return InkWell(
                              onTap: () {
                                if (controller.selectedPaymentTypeIds
                                    .contains(payment.id)) {
                                  controller.selectedPaymentTypeIds
                                      .remove(payment.id);
                                } else {
                                  controller.selectedPaymentTypeIds.add(payment.id!);
                                }
                                controller.update();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: maxWidth < 1366 ? 6 : 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      visualDensity: VisualDensity.compact,
                                      value: controller.selectedPaymentTypeIds
                                          .contains(payment.id),
                                      onChanged: (v) {
                                        if (v == true) {
                                          controller.selectedPaymentTypeIds
                                              .add(payment.id!);
                                        } else {
                                          controller.selectedPaymentTypeIds
                                              .remove(payment.id);
                                        }
                                        controller.update();
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        payment.name?.toUpperCase() ?? "",
                                        style: mozillaTextSemiBoldText(
                                          context: context,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: DynamicColors.primaryClr,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        SizedBox(width: maxWidth < 1366 ? 10 : 40),
                        CustomButton(
                          verticalPadding: 0.0,
                          width: 70,
                          height: 30,
                          borderRadius: 4,
                          btnText: AppText.filter,
                          style: mozillaTextRegularText(
                              fontSize: 10, color: DynamicColors.whiteClr),
                          onTap: () {
                          },
                        ),
                        CustomButton(
                          verticalPadding: 0.0,
                          width: 70,
                          height: 30,
                          borderRadius: 4,
                          btnText: AppText.save,
                          style: mozillaTextRegularText(
                              fontSize: 10, color: DynamicColors.whiteClr),
                          onTap: () {
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
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
              ));
        });
      }),
    );
  }
}