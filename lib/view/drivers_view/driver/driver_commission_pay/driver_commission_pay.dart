import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/driver_controller.dart';

class DriverCommissionPay extends StatefulWidget {
  const DriverCommissionPay({super.key});

  @override
  State<DriverCommissionPay> createState() => _DriverCommissionPayState();
}

class _DriverCommissionPayState extends State<DriverCommissionPay> {
  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  String? selectDrv = "SELECT DRIVER";

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "driverCommissionPay";
  }

  int selectedRowIndex = 0;
  final int totalRows = 5;

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<DriverController>(builder: (controller) {
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

          return SingleChildScrollView(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  child: Text(AppText.driverCommissionPay, style: titleDesign()),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomDropdownField(
                          text: "DRIVER",
                          label: AppText.selectDriver,
                          items: [
                            "25 GEORGE HAMPTON",
                            "26 PAUL DOUBLEDAY",
                            "27 RICHARD HARDWICK",
                            "28 LANRE OKERJO",
                          ],
                          value: selectDrv,
                          itemLabel: (val) => val,
                          onChanged: (val) {
                            selectDrv = val;
                            controller.update();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: labeledTextField(
                          context,
                          isMobile,
                          AppText.commissionDue,
                          controller.commissionDueController,
                          textInputAction: TextInputAction.next,
                          column: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: labeledTextField(
                          context,
                          isMobile,
                          AppText.amount,
                          controller.amountController,
                          textInputAction: TextInputAction.next,
                          column: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: labeledTextField(
                          context,
                          isMobile,
                          "CURRENT BALANCE",
                          controller.amountController,
                          textInputAction: TextInputAction.next,
                          column: true,
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
                          textInputAction: TextInputAction.next,
                          column: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<int>(
                            value: 0,
                            groupValue: 0,
                            onChanged: (v) {},
                          ),
                          Text(AppText.credit),
                          const SizedBox(width: 8),
                          Radio<int>(
                            value: 1,
                            groupValue: 0,
                            onChanged: (v) {},
                          ),
                          Text(AppText.debit),
                        ],
                      ),
                      const SizedBox(width: 30),
                      CustomButton(
                        width: 90,
                        height: 33,
                        borderRadius: 4,
                        style: mozillaTextSemiBoldText(fontSize: 13, color: DynamicColors.whiteClr),
                        verticalPadding: 0.0,
                        btnText: AppText.save,
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
                      totalRow: totalRows,
                      cells: [
                        DataCell(Center(child: Text("20/10/2025"))),
                        DataCell(Center(child: Text("PHC VEHICLE"))),
                        DataCell(Center(child: Text("PHC VEHICLE"))),
                        DataCell(Center(child: Text("#PHC VEHICLE"))),
                        DataCell(Center(child: Text("PHC VEHICLE"))),
                        DataCell(Center(child: Text("PHC VEHICLE"))),
                      ],
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
}
