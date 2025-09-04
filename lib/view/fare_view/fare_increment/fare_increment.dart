import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/controller.dart';

class FareIncrement extends StatefulWidget {
  const FareIncrement({super.key});

  @override
  State<FareIncrement> createState() => _FareIncrementState();
}

class _FareIncrementState extends State<FareIncrement> {
  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows =
      50; // total rows (dynamic list ke hisaab se change hoga)
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "fareIncrement";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(builder: (controller) {
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

        return Column(
          children: [
            Container(
              width: Get.width / 1.5,
              decoration: BoxDecoration(
                  border: Border.all(color: DynamicColors.gryClr)),
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    child: Text(AppText.fareIncrement, style: titleDesign()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    runSpacing: 8,
                    spacing: 20,
                    children: [
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.startDate,
                        width: fieldWidth / 2.0,
                        column: true,
                        child:
                            SizedBox(height: 30, child: KeyboardDatePicker()),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.endDate,
                        column: true,
                        width: fieldWidth / 2.0,
                        child:
                            SizedBox(height: 30, child: KeyboardDatePicker()),
                      ),
                      SizedBox(
                        width: fieldWidth / 2.5,
                        // height: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppText.operator,
                                style: mozillaTextSemiBoldText(
                                    context: context, fontSize: 13)),
                            RestrictedDrivers(
                              width: fieldWidth,
                              height: 35,
                              padding: 0.0,

                              border: Border.all(
                                color: Colors.grey,
                              ),
                              titleText: "SELECT OPERATOR",
                              driversList: [
                                "25 GEORGE HAMPTON",
                                "26 PAUL DOUBLEDAY",
                                "27 RICHARD HARDWICK",
                                "28 LANRE OKERJO",
                              ],
                            ),
                          ],
                        ),
                      ),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.incrementValueVehicleController,
                        width: fieldWidth / 2.8,
                        hintText: AppText.value,
                        columnText: true,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: DynamicColors.primaryClr,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // 👈 yahan ap radius set karen
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          AppText.fixeFare,
                          style: mozillaTextRegularText(
                              fontSize: 12, color: DynamicColors.primaryClr),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: DynamicColors.primaryClr,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // 👈 yahan ap radius set karen
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          AppText.mileage,
                          style: mozillaTextRegularText(
                              fontSize: 12, color: DynamicColors.primaryClr),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: DynamicColors.primaryClr,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // 👈 yahan ap radius set karen
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          AppText.save,
                          style: mozillaTextRegularText(
                              fontSize: 12, color: DynamicColors.whiteClr),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                dataRowMinHeight: 48,
                dataRowMaxHeight: 56,
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
                dataTextStyle: const TextStyle(
                  fontSize: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: DynamicColors.textClr.withOpacity(0.5),
                  ),
                ),
                columns: [
                  buildHeaderWithSearch(title: "FROM"),
                  buildHeaderWithSearch(title: "TO"),
                  buildHeaderWithSearch(title: "OPERATOR"),
                  buildHeaderWithSearch(title: "VALUE"),
                  buildHeaderWithSearch(title: "FIX FARE"),
                  buildHeaderWithSearch(title: "MILEAGE"),
                  buildHeaderWithSearch(
                      title: "ACTIONS", removeSearching: true),
                ],
                rows: List.generate(totalRows, (index) {
                  bool isSelected = index == selectedRowIndex;
                  return DataRow(
                    cells: [
                      const DataCell(Text("SALOON")),
                      const DataCell(Text("NW7")),
                      const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                      const DataCell(Text("£55.00")),
                      const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                      const DataCell(Text("£55.00")),
                      DataCell(
                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide.none,
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.search,
                                size: 28,
                                color: DynamicColors.primaryClr,
                              ),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide.none,
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.clear,
                                size: 28,
                                color: DynamicColors.redClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            )
          ],
        );
      });
    });
  }
}
