import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/quotation_widget.dart';
import '../controller/controller.dart';

class FareMeter extends StatefulWidget {
  const FareMeter({super.key});

  @override
  State<FareMeter> createState() => _FareMeterState();
}

class _FareMeterState extends State<FareMeter> {
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
    shortCutKeyValue.value = "fareMeter";
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
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: DynamicColors.gryClr.withOpacity(0.5),
              child: Text(AppText.fareMeterConfiguration, style: titleDesign()),
            ),
            Scrollbar(
              controller: _scrollController,
              thumbVisibility: true, // 👈 hamesha visible
              trackVisibility: true,
              interactive: true,
              child: SingleChildScrollView(
                controller: _scrollController, // 👈 yahan bhi same controller
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 56,
                  columnSpacing: 30.0,
                  border: TableBorder.all(
                    color: DynamicColors.gryClr,
                    width: 0.5,
                  ),
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
                    buildHeaderWithSearch(
                        title: " VEHICLES ",
                        removeSearching: true,
                        fontSize: 13),
                    buildHeaderWithSearch(
                        title: " METERED ",
                        removeSearching: true,
                        fontSize: 13),
                    buildHeaderWithSearch(
                        title: " AUTO WAIT ",
                        removeSearching: true,
                        fontSize: 13),
                    buildHeaderWithSearch(
                        title: " ACTIVATE WAITING ON SPEED ",
                        removeSearching: true,
                        fontSize: 13),
                    buildHeaderWithSearch(
                        title: " INITIATE WAITING AFTER ",
                        removeSearching: true,
                        fontSize: 13),
                    buildHeaderWithSearch(
                        title: " SUSPEND WAITING ON SPEED ",
                        removeSearching: true,
                        fontSize: 13),
                    buildHeaderWithSearch(
                        title: " WAITING CHAREGES/INTERVAL ",
                        removeSearching: true,
                        fontSize: 13),
                    buildHeaderWithSearch(
                        title: " INTERVALS ",
                        removeSearching: true,
                        fontSize: 13),
                    buildHeaderWithSearch(
                        title: " ACTIONS ",
                        removeSearching: true,
                        fontSize: 13),
                  ],
                  rows: List.generate(totalRows, (index) {
                    return DataRow(
                      cells: [
                        const DataCell(Center(child: Text("SALOON"))),
                        DataCell(Center(
                          child: DynamicSwitch(
                            controller: controller.meteredSwitch,
                            activeColor: DynamicColors.primaryClr,
                            inactiveColor: DynamicColors.gryClr,
                            focusScale: 1.5,
                            onToggle: () {
                              print(
                                  "Switch toggled: ${controller.meteredSwitch.value}");
                            },
                          ),
                        )),
                        DataCell(Center(
                          child: DynamicSwitch(
                            controller: controller.autoWaitSwitch,
                            activeColor: DynamicColors.primaryClr,
                            inactiveColor: DynamicColors.gryClr,
                            focusScale: 1.5,
                            onToggle: () {
                              print(
                                  "Switch toggled: ${controller.autoWaitSwitch.value}");
                            },
                          ),
                        )),
                        DataCell(Center(
                          child: customRow(
                            icons: Icons.speed,
                            controller.activeWaitingController,
                            width: fieldWidth / 3.9,
                            unitText: "MPH",
                          ),
                        )),
                        DataCell(Center(
                          child: customRow(
                            icons: Icons.alarm,
                            controller.activeWaitingController,
                            width: fieldWidth / 3.9,
                            unitText: "SECS",
                          ),
                        )),
                        DataCell(Center(
                          child: customRow(
                            icons: Icons.speed,
                            controller.activeWaitingController,
                            width: fieldWidth / 3.9,
                            unitText: "MPH",
                          ),
                        )),
                        DataCell(Center(
                          child: CustomButton(
                            width: fieldWidth / 1.9,
                            onTap: () {
                              print("object");
                            },
                            height: 30,
                            verticalPadding: 0.0,
                            btnText: "WAITING CONFIGURATION",
                            style: mozillaTextRegularText(
                              fontSize: 10,
                              color: DynamicColors.whiteClr,
                            ),
                            borderRadius: 4,
                          ),
                        )),
                        DataCell(Center(
                          child: customRow(
                            icons: Icons.alarm,
                            controller.activeWaitingController,
                            width: fieldWidth / 3.9,
                            unitText: "SEC",
                          ),
                        )),
                        DataCell(Center(
                          child: CustomButton(
                            width: 60,
                            onTap: () {
                              print("object");
                            },
                            height: 30,
                            verticalPadding: 0.0,
                            btnText: AppText.save,
                            style: mozillaTextSemiBoldText(
                              fontSize: 12,
                              color: DynamicColors.whiteClr,
                            ),
                            borderRadius: 4,
                          ),
                        )),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      });
    });
  }

  Widget customRow(
    TextEditingController controller, {
    double? width,
    String? unitText,
    IconData? icons,
    double borderRadius = 4,
  }) {
    return Row(
      children: [
        Container(
          height: 30,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: DynamicColors.primaryClr),
              right: BorderSide.none,
              bottom: BorderSide(color: DynamicColors.primaryClr),
              left: BorderSide(
                  color: DynamicColors.primaryClr), // left border hataya
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Icon(
              icons,
              size: 20,
            ),
          ),
        ),
        CustomTextField(
          borderRadius: 0,
          controller: controller,
          width: width,
          hintText: "",
          columnText: true,
        ),
        Container(
          height: 30,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: DynamicColors.primaryClr),
              right: BorderSide(color: DynamicColors.primaryClr),
              bottom: BorderSide(color: DynamicColors.primaryClr),
              left: BorderSide.none, // left border hataya
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Text(unitText!),
          ),
        ),
      ],
    );
  }
}
