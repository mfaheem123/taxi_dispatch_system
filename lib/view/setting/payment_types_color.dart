import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../component/color_picker_widget.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import 'controller/setting_controller.dart';
import '../dashboard_view/booking_table.dart';

class PaymentTypeDialog extends StatelessWidget {
  const PaymentTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.isRegistered<SettingController>()
        ? Get.find<SettingController>()
        : Get.put(SettingController());

    return AlertDialog(
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        color: DynamicColors.gryClr,
        child: Text(
          "PAYMENT TYPE COLOR CODE",
          style: mozillaTextSemiBoldText(
            fontSize: 18,
            color: DynamicColors.black,
          ),
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
                          rows: List.generate(list.length, (index) {
                            final item = list[index];
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
                                        logic.updateBackgroundColor(index, color);
                                      },
                                      onColorSelected: (color) {
                                        logic.updateBackgroundColor(index, color);
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
                                        logic.updateForegroundColor(index, color);
                                      },
                                      onColorSelected: (color) {
                                        logic.updateForegroundColor(index, color);
                                      },
                                      width: fieldWidth,
                                      colorContainerHeight: 12,
                                      borderColor: DynamicColors.gryClr,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}