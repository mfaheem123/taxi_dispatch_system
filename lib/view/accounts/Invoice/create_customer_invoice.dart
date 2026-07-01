import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:excel/excel.dart' show Excel, Sheet, CellValue, TextCellValue;
import 'package:flutter_html/flutter_html.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/booking_view/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../customer/model/search_customer_by_mobile.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/account_controller.dart';
import '../controller/customer_invoice_controller.dart';

class CreateCustomerInvoice extends StatefulWidget {
  const CreateCustomerInvoice({super.key});

  @override
  State<CreateCustomerInvoice> createState() => _CreateCustomerInvoiceState();
}

/// ye screen Customer invoice ki hai   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class _CreateCustomerInvoiceState extends State<CreateCustomerInvoice> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  CustomerInvoiceController controller = Get.isRegistered<CustomerInvoiceController>()
      ? Get.find<CustomerInvoiceController>()
      : Get.put(CustomerInvoiceController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "CreateCustomerInvoice";
  }

  List permissions = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<CustomerInvoiceController>(initState: (v) {
      controller.getPaymentTypes();
      controller.getCustomerInvoiceNumber();
      permissions = Api().sp.read('all_permissions') ?? [];
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
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      child:
                          Text(AppText.customerInvoice, style: titleDesign()),
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
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.invoiceDueDate,
                      column: true,
                      width: fieldWidth / 1.8,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                    SizedBox(width: 20),
                    Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: RichText(text: TextSpan(
                          text: 'INVOICE #',
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text:
                              " ${controller.customerInvoice?.invoiceNumber}",
                            style: mozillaTextRegularText(
                                color: DynamicColors.redClr)),
                          ]
                        )),
                    ),
                    // CustomTextField(
                    //   borderRadius: 4,
                    //   controller: controller.customerNameController,
                    //   width: fieldWidth,
                    //   hintText: AppText.name,
                    //   columnText: true,
                    //   height: 30,
                    // ),
                    // CustomTextField(
                    //   borderRadius: 4,
                    //   controller: controller.customerEmailController,
                    //   width: fieldWidth,
                    //   hintText: AppText.email,
                    //   columnText: true,
                    //   height: 30,
                    // ),
                    // CustomTextField(
                    //   borderRadius: 4,
                    //   controller: controller.customerMobileController,
                    //   width: fieldWidth,
                    //   hintText: AppText.mobile,
                    //   columnText: true,
                    //   height: 30,
                    // ),
                    // CustomTextField(
                    //   borderRadius: 4,
                    //   controller: controller.customerTelephoneController,
                    //   width: fieldWidth,
                    //   hintText: AppText.tel,
                    //   columnText: true,
                    //   height: 30,
                    // ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            borderRadius: 4,
                            controller: controller.customerNameController,
                            width: double.infinity,
                            hintText: AppText.name,
                            columnText: true,
                            height: 30,
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
                          ),
                        ),
                        SizedBox(width: 10),
                        // Expanded(
                        //   child: CustomTextField(
                        //     borderRadius: 4,
                        //     controller: controller.customerMobileController,
                        //     width: double.infinity,
                        //     hintText: AppText.mobile,
                        //     columnText: true,
                        //     height: 30,
                        //   ),
                        // ),
                        Expanded(
                          child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SizedBox(
                                  height: 52,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          AppText.mobile,
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        height: 30,
                                        child: RawAutocomplete<SearchCustomer>(
                                          optionsBuilder: (TextEditingValue textEditingValue) async {
                                            if (textEditingValue.text.length < 2) {
                                              return const Iterable<SearchCustomer>.empty();
                                            }
                                            await controller.getCustomer(textEditingValue.text);
                                            return controller.searchCustomerByMobileModel?.customer ?? const Iterable<SearchCustomer>.empty();
                                          },
                                          displayStringForOption: (SearchCustomer option) => option.mobile ?? '',

                                          //  INPUT FIELD VIEW
                                          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                            if (textEditingController.text.isEmpty && controller.customerMobileController.text.isNotEmpty) {
                                              textEditingController.text = controller.customerMobileController.text;
                                            }

                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onSubmitted: (value) => onFieldSubmitted(),
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                                hintText: AppText.mobile,
                                                hintStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
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
                                                      child: CircularProgressIndicator(strokeWidth: 1.5)
                                                  ),
                                                )
                                                    : null,
                                              ),
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                                                  child: ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    itemCount: options.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      final SearchCustomer option = options.elementAt(index);

                                                      final bool highlight = AutocompleteHighlightedOption.of(context) == index;

                                                      return InkWell(
                                                        onTap: () => onSelected(option),
                                                        child: Container(
                                                          color: highlight ? const Color(0xFFE1F2FE) : null,
                                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                option.name ?? '',
                                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
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
                                                  ),
                                                ),
                                              ),
                                            );
                                          },

                                          // ACTION ON SELECTION
                                          onSelected: (SearchCustomer selection) {
                                            controller.customerMobileController.text = selection.mobile ?? '';
                                            controller.customerNameController.text = selection.name ?? '';
                                            controller.customerEmailController.text = selection.email ?? '';
                                            controller.customerTelephoneController.text = selection.telephone ?? '';
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          ),
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
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
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
                       SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Transform.translate(
                              offset: const Offset(0, 4),
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
                                  controller.selectedPaymentTypeIds.remove(payment.id);
                                } else {
                                  controller.selectedPaymentTypeIds.add(payment.id!);
                                }
                                controller.update();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
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
                          }).toList(),
                        SizedBox(width: 40),
                        CustomButton(
                          verticalPadding: 0.0,
                          width: 70,
                          height: 30,
                          borderRadius: 4,
                          btnText: AppText.filter,
                          style: mozillaTextRegularText(
                              fontSize: 10, color: DynamicColors.whiteClr),
                        ),
                          CustomButton(
                            verticalPadding: 0.0,
                            width: 70,
                            height: 30,
                            borderRadius: 4,
                            btnText: AppText.save,
                            style: mozillaTextRegularText(
                                fontSize: 10, color: DynamicColors.whiteClr),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width,
                        child: DatatableWidget(
                          columns: [
                            DataColumn(label: Checkbox(value: false, onChanged: (val) {})),
                            buildHeaderWithSearch(title: "REF #"),
                            buildHeaderWithSearch(title: "DATETIME"),
                            buildHeaderWithSearch(title: "PICKUP"),
                            buildHeaderWithSearch(title: "DROPOFF"),
                            buildHeaderWithSearch(title: "VEH"),
                            buildHeaderWithSearch(title: "J/T"),
                            buildHeaderWithSearch(title: "P/T"),
                            buildHeaderWithSearch(title: "FARE"),
                            buildHeaderWithSearch(title: "PC"),
                            buildHeaderWithSearch(title: "WC"),
                            buildHeaderWithSearch(title: "EDC"),
                            buildHeaderWithSearch(title: "M&G"),
                            buildHeaderWithSearch(title: "Cc"),
                            buildHeaderWithSearch(title: "TOTA"),
                            buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                          ],

                          rows: [
                            DataRow(
                              cells: [
                                DataCell(Checkbox(value: false, onChanged: (val) {})),
                                const DataCell(Text("SALOON")),
                                const DataCell(Text("NW7")),
                                const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                                const DataCell(Text("£55.00")),
                                const DataCell(Text("SALOON")),
                                const DataCell(Text("NW7")),
                                const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                                const DataCell(Text("£55.00")),
                                const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                                const DataCell(Text("£55.00")),
                                const DataCell(Text("£55.00")),
                                const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                                const DataCell(Text("£55.00")),
                                const DataCell(Text("£55.00")),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.transparent)),
                                        onPressed: () {},
                                        child: Icon(Icons.search, size: 28, color: DynamicColors.primaryClr),
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.transparent)),
                                        onPressed: () {},
                                        child: Icon(Icons.clear, size: 28, color: DynamicColors.redClr),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                    ),
                  ],
                )));
      });
    });
  }
}