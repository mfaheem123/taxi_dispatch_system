import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../component/action_icon_button.dart';
import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';

class DriverRentPay extends StatefulWidget {
  const DriverRentPay({super.key});

  @override
  State<DriverRentPay> createState() => _DriverRentPayState();
}

class _DriverRentPayState extends State<DriverRentPay> {
  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  final FocusNode _amountFocusNode = FocusNode();

  String? selectDrv = "SELECT DRIVER";

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverRentPay";
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    super.dispose();
  }

  int selectedRowIndex = 0;
  final int totalRows = 5;

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<DriverController>(initState: (state) {
        controller.clearLedgerForm();
        controller.getDriver();
        // controller.getAllDriverPay(invoiceType: "rent");
      }, builder: (controller) {
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

          final int ledgerCount = controller.getAllDriverPayModel?.driverCommissionLedgers?.length ?? 0;
          final bool isDriverSelected = controller.rentDriverSelectionController.text.isNotEmpty;

          return SingleChildScrollView(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  child: Text(
                      isDriverSelected
                          ? "${AppText.driverRentPay} ($ledgerCount)"
                          : AppText.driverRentPay,
                      style: titleDesign(),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          flex: 1,
                          child: CustomDropdownField<dynamic>(
                            width: fieldWidth,
                            height: 30,
                            text: AppText.driver,
                            label: "SELECT DRIVER",
                            value: controller.rentDriverSelectionController.text.isEmpty
                                ? null
                                : controller.driverRentModel?.drivers?.firstWhereOrNull(
                                    (d) => "${d.username} ${d.name}" == controller.rentDriverSelectionController.text
                            ),
                            items: controller.driverRentModel?.drivers ?? [],
                            itemLabel: (driver) => "${driver.username} ${driver.name}".toUpperCase(),
                            onChanged: (driver) {
                              if (driver != null) {
                                String selectedText = "${driver.username} ${driver.name}";
                                controller.rentDriverSelectionController.text = selectedText;
                                controller.selectedDriverId = driver.id;
                                controller.fillDriverDetails(selectedText);
                                controller.getAllDriverPay(invoiceType: "rent");
                                controller.update();
                              }
                            },
                          ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        flex: 1,
                        child: labeledTextField(
                          context, isMobile,
                          AppText.rentDue,
                          controller.commissionDueController,
                          width: fieldWidth,
                          textInputAction: TextInputAction.next,
                          column: true,
                          readOnly: true,
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                          child: KeyboardListener(
                              focusNode: _amountFocusNode,
                              onKeyEvent: (event) {
                                if (event is KeyDownEvent) {
                                  double currentVal = double.tryParse(controller.amountController.text) ?? 0.0;
                                  if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                                    controller.amountController.text = (currentVal + 1).toString();
                                    controller.update();
                                  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                                    controller.amountController.text = (currentVal - 1).toString();
                                    controller.update();
                                  }
                                }
                              },
                              child: CustomTextField(
                                borderRadius: 4,
                                controller: controller.amountController,
                                width: fieldWidth,
                                hintText: AppText.amount,
                                columnText: true,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                suffixIcon: arrowIcons(controller.amountController),
                              )
                          )
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: labeledTextField(
                            context, isMobile,
                            "CURRENT BALANCE",
                            controller.currentBalanceController,
                            width: fieldWidth,
                            column: true,
                          readOnly: true,
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: labeledTextField(
                            context,
                            isMobile,
                            AppText.description,
                            controller.descriptionController,
                            width: fieldWidth,
                            textInputAction: TextInputAction.next,
                            column: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: "CREDIT",
                            groupValue: controller.selectedType,
                            onChanged: (v) {
                              controller.selectedType = v;
                              controller.update();
                            },
                          ),
                          Text(AppText.credit),
                          const SizedBox(width: 8),
                          Radio<String>(
                            value: "DEBIT",
                            groupValue: controller.selectedType,
                            onChanged: (v) {
                              controller.selectedType = v;
                              controller.update();
                            },
                          ),
                          Text(AppText.debit),
                        ],
                      ),
                      const SizedBox(width: 30),
                      CustomButton(
                        width: 100,
                        height: 33,
                        borderRadius: 4,
                        style: mozillaTextSemiBoldText(fontSize: 13, color: DynamicColors.whiteClr),
                        verticalPadding: 0.0,
                        btnText: AppText.save,
                        onTap: () {
                          controller.createDriverLedger(invoiceType: "rent");
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  child: SizedBox(
                    width: Get.width,
                    child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "DATE", removeSearching: true),
                        buildHeaderWithSearch(title: "TYPE"),
                        buildHeaderWithSearch(title: "AMOUNT", removeSearching: true),
                        buildHeaderWithSearch(title: "DESCRIPTION", removeSearching: true),
                        buildHeaderWithSearch(title: "BALANCE", removeSearching: true),
                        buildHeaderWithSearch(title: "ACTION", removeSearching: true),
                      ],
                      totalRow: controller.getAllDriverPayModel?.driverCommissionLedgers?.length ?? 0,
                      rows: controller.getAllDriverPayModel?.driverCommissionLedgers?.map((item) {

                        String formatDateTime(String? dateStr) {
                          if (dateStr == null || dateStr.isEmpty) return "";
                          try {
                            DateTime parsed = DateTime.parse(dateStr);
                            String datePart = parsed.toIso8601String().split('T').first;
                            String timePart = "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}";
                            return "$datePart   $timePart";
                          } catch (e) {
                            return dateStr;
                          }
                        }
                        return DataRow(cells: [
                          DataCell(Center(child: Text(formatDateTime(item.date)))),
                          DataCell(Center(child: Text(item.type ?? ""))),
                          DataCell(Center(child: Text(item.amount ?? ""))),
                          DataCell(Center(child: Text(item.description ?? ""))),
                          DataCell(Center(child: Text(item.currentBalance ?? ""))),
                          DataCell(Center(child:
                          ActionIconButton(
                            icon: Icons.delete_forever,
                            color: DynamicColors.redClr,
                            onPressed: () {
                              controller.deleteDriverLedger(item.id);
                            },
                          ),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }

  Widget arrowIcons(TextEditingController ctrl) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: () => ctrl.text = ((double.tryParse(ctrl.text) ?? 0) + 1).toString(),
        child: const Icon(Icons.arrow_drop_up, size: 13),
      ),
      InkWell(
        onTap: () => ctrl.text = ((double.tryParse(ctrl.text) ?? 0) - 1).toString(),
        child: const Icon(Icons.arrow_drop_down, size: 13),
      ),
    ],
  );
}
