import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../component/color_picker_widget.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import 'controller/setting_controller.dart';
import '../dashboard_view/booking_table.dart';

class PaymentTypeDialog extends StatefulWidget {
  const PaymentTypeDialog({super.key});

  @override
  State<PaymentTypeDialog> createState() => _PaymentTypeDialogState();
}

class _PaymentTypeDialogState extends State<PaymentTypeDialog> {
  final SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  int? selectedPaymentId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        color: DynamicColors.gryClr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PAYMENT TYPE COLOR CODE",
              style: mozillaTextSemiBoldText(
                fontSize: 18,
                color: DynamicColors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.close,
                color: DynamicColors.black,
                size: 24,
              ),
            ),
          ],
        ),
      ),
      content: GetBuilder<SettingController>(
        initState: (state) {
          controller.getSettingPaymentTypes();
        },
        builder: (logic) {
          final list = logic.driverCommissionPaymentModel?.paymentTypes ?? [];

          return SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: logic.isLoadingPaymentTypes
                  ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
                  : list.isEmpty
                  ? const SizedBox(
                height: 200,
                child: Center(child: Text("No Payment Types Available")),
              )
                  : SingleChildScrollView(
                child: LayoutBuilder(builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth;
                  final double fieldWidth = maxWidth / 3.5;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            height: 35,
                            btnText: "Save",
                            verticalPadding: 0.0,
                            width: 100,
                            borderRadius: 4,
                            onTap: () {
                              if (selectedPaymentId != null) {
                                logic.updatePaymentTypeColor(selectedPaymentId!);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Scrollbar(
                        thickness: 8,
                        radius: const Radius.circular(10),
                        child: SizedBox(
                          width: maxWidth,
                          child: DatatableWidget(
                            totalRow: list.length,
                            columns: [
                              buildHeaderWithSearch(
                                title: "PAYMENT TYPE",
                                removeSearching: true,
                              ),
                              buildHeaderWithSearch(
                                title: "BACKGROUND COLOR",
                                removeSearching: true,
                              ),
                              buildHeaderWithSearch(
                                title: "FOREGROUND COLOR",
                                removeSearching: true,
                              ),
                            ],
                            rows: list.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      (item.name ?? "").toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: ColorPickerWidget(
                                        pickerColor: logic.parseColor(item.backgroundColor, Colors.white),
                                        onColorChanged: (color) {
                                          setState(() {
                                            String hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                                            item.backgroundColor = hex;

                                            logic.paymentBackgroundHex.value = hex;
                                            selectedPaymentId = item.id;
                                          });
                                          logic.update();
                                        },
                                        onColorSelected: (color) {
                                          setState(() {
                                            String hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                                            item.backgroundColor = hex;

                                            logic.paymentBackgroundHex.value = hex;
                                            selectedPaymentId = item.id;
                                          });
                                          logic.update();
                                        },
                                        width: fieldWidth,
                                        colorContainerHeight: 12,
                                        borderColor: DynamicColors.gryClr,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: ColorPickerWidget(
                                        pickerColor: logic.parseColor(item.foregroundColor, Colors.black),
                                        onColorChanged: (color) {
                                          setState(() {
                                            String hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                                            item.foregroundColor = hex;

                                            logic.paymentForegroundHex.value = hex;
                                            selectedPaymentId = item.id;
                                          });
                                          logic.update();
                                        },
                                        onColorSelected: (color) {
                                          setState(() {
                                            String hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                                            item.foregroundColor = hex;

                                            logic.paymentForegroundHex.value = hex;
                                            selectedPaymentId = item.id;
                                          });
                                          logic.update();
                                        },
                                        width: fieldWidth,
                                        colorContainerHeight: 12,
                                        borderColor: DynamicColors.gryClr,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ));
        },
      ),
    );
  }
}