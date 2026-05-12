import 'package:dashboard_new1/alert/restrict_drivers_alert.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../../dashboard_view/widgets/user_info_widget.dart';
import '../../controller/report_controller.dart';

class EarningAndInfoScreen extends StatefulWidget {
  const EarningAndInfoScreen({super.key});

  @override
  State<EarningAndInfoScreen> createState() => _EarningAndInfoScreenState();
}

class _EarningAndInfoScreenState extends State<EarningAndInfoScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // MAIN CONTAINER
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: DynamicColors.gryClr.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // --- UPDATED HEADING ROW ---
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        // Left Heading (40%)
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: DynamicColors.gryClr,
                            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                            child: Text(
                              AppText.driverEarning,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
                        Expanded(
                          flex: 6,
                          child: Container(
                            color: DynamicColors.gryClr,
                            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                            child: Text(
                              "DRIVER INFORMATION",
                              style: mozillaTextSemiBoldText(context: context, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- CONTENT ROW ---
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        // LEFT SIDE CONTENT (40%)
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 15,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: AppText.from,
                                  column: true,
                                  width: 130,
                                  child: SizedBox(height: 30, child: KeyboardDatePicker(
                                    initialDate: fromDate,
                                    onChanged: (date) =>
                                        setState(() => fromDate = date),
                                  )),
                                ),
                                labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: AppText.to,
                                  column: true,
                                  width: 130,
                                  child: SizedBox(height: 30, child: KeyboardDatePicker(
                                    initialDate: toDate,
                                    onChanged: (date) =>
                                        setState(() => toDate = date),
                                  )),
                                ),
                                CustomButton(
                                  verticalPadding: 0.0,
                                  width: 60,
                                  height: 32,
                                  borderRadius: 4,
                                  fontSize: 12,
                                  btnText: AppText.all,
                                ),
                                CustomButton(
                                  verticalPadding: 0.0,
                                  width: 60,
                                  height: 32,
                                  borderRadius: 4,
                                  fontSize: 12,
                                  btnText: AppText.login,
                                ),
                                CustomButton(
                                  verticalPadding: 0.0,
                                  width: 60,
                                  height: 32,
                                  borderRadius: 4,
                                  fontSize: 12,
                                  btnText: "LOGOUT",
                                ),
                                SizedBox(width: 10),
                                CustomButton(
                                  verticalPadding: 0.0,
                                  width: 60,
                                  height: 32,
                                  borderRadius: 4,
                                  fontSize: 12,
                                  btnText: AppText.view,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // MAIN VERTICAL DIVIDER
                        const VerticalDivider(color: Colors.grey, thickness: 1, width: 1),

                        // RIGHT SIDE CONTENT (60%)
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 15,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppText.driver,
                                        style: mozillaTextSemiBoldText(context: context, fontSize: 12)),
                                    const SizedBox(height: 5),
                                    RestrictedDrivers(
                                      width: 200,
                                      padding: 0.0,
                                      border: Border.all(color: DynamicColors.gryClr),
                                      titleText: AppText.selectDriver,
                                      driversList: const ["Driver 01", "Driver 02", "Driver 03"],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppText.driverStatus,
                                        style: mozillaTextSemiBoldText(context: context, fontSize: 12)),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildStatusBtn("ACTIVE", DynamicColors.primaryClr),
                                        const SizedBox(width: 8),
                                        _buildStatusBtn("IN ACTIVE", DynamicColors.redClr),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        );
      });
    },
    );
  }

  Widget _buildStatusBtn(String text, Color color) {
    return CustomButton(
      width: 90,
      height: 30,
      btnText: text,
      verticalPadding: 0.0,
      borderRadius: 4,
      fontSize: 11,
      btnColor: color,
      onTap: () {},
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final double sales;
}