import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/view/administration/User/administration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';

class SubsiDiariesScreen extends StatefulWidget {
  const SubsiDiariesScreen({super.key});

  @override
  State<SubsiDiariesScreen> createState() => _SubsiDiariesScreenState();
}

class _SubsiDiariesScreenState extends State<SubsiDiariesScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  AdministrationController controller =
      Get.isRegistered<AdministrationController>()
          ? Get.find<AdministrationController>()
          : Get.put(AdministrationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "SubsiDiariesScreen";
    controller.listSubsDiary();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<AdministrationController>(builder: (controller) {
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

        return Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: DynamicColors.gryClr.withOpacity(0.5),
              child: Row(
                children: [
                  Text(
                    "SUBSIDIARIES",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  Spacer(),
                  CustomButton(
                    onTap: () {
                      controller.listSubsDiary();
                    },
                    height: 40,
                    width: 80,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                      child: Icon(
                        Icons.refresh,
                        color: DynamicColors.whiteClr,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            controller.subsDiaryLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: Get.width,
                      child: DatatableWidget(
                        columns: [
                          DataColumn(
                            label: Center(
                              child: Checkbox(
                                  value: controller.subsDiaryAllSelection.value,
                                  onChanged: (v) {
                                    controller.subsDiaryAllSelection.value = v!;
                                    controller.update();
                                  }),
                            ),
                          ),
                          buildHeaderWithSearch(title: "NAME"),
                          buildHeaderWithSearch(title: "EMAIL"),
                          buildHeaderWithSearch(title: "TELEPHONE"),
                          buildHeaderWithSearch(title: "ADDRESS"),
                          buildHeaderWithSearch(title: "FAX"),
                          buildHeaderWithSearch(
                              title: "ACTIONS", removeSearching: true),
                        ],
                        totalRow:
                            controller.subsDiaryModel!.subsidiaries!.length ??
                                0,
                        rows: (controller.subsDiaryModel!.subsidiaries ?? [])
                            .map((item) {
                          return DataRow(
                            cells: [
                              DataCell(

                                Center(
                                  child: Checkbox(
                                      value:
                                          controller.subsDiarySelection.value,
                                      onChanged: (v) {
                                        controller.subsDiarySelection.value =
                                            v!;
                                        controller.update();
                                      }),
                                ),
                              ),
                              DataCell(Center(child: Text(item.name!))),
                              DataCell(Center(child: Text(item.email!))),
                              DataCell(
                                  Center(child: Text(item.telephoneNumber!))),
                              DataCell(Center(child: Text(item.address!))),
                              DataCell(Center(child: Text(item.fax!))),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Colors.transparent,
                                        ), // border color & thickness
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
                                        side: BorderSide(
                                          color: Colors.transparent,
                                        ), // border color & thickness
                                      ),
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.delete,
                                        size: 28,
                                        color: DynamicColors.redClr,
                                      ),
                                    ),
                                  ],
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
      });
    });
  }
}
