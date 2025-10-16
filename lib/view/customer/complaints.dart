import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'controller/customer_controller.dart';

class ComplaintsView extends StatefulWidget {
  const ComplaintsView({super.key});

  @override
  State<ComplaintsView> createState() => _ComplaintsViewState();
}

class _ComplaintsViewState extends State<ComplaintsView> {
  CustomerController controller = Get.isRegistered<CustomerController>()
      ? Get.find<CustomerController>()
      : Get.put(CustomerController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "lostProperty";
  }

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<CustomerController>(builder: (controller) {
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

        return SizedBox(
          // width: Get.width/1.6,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    AppText.lostProperties + " (10)",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: CustomButton(
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
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "REF #"),
                        buildHeaderWithSearch(title: "COMPLAIN DATE"),
                        buildHeaderWithSearch(title: "NAME"),
                        buildHeaderWithSearch(
                            title: "ACTIONS",
                            customWidget: Row(
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
                                  ),
                                ),
                                Text("|"),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.transparent,
                                    ), // border color & thickness
                                  ),
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.close,
                                    size: 28,
                                    color: DynamicColors.redClr,
                                  ),
                                ),
                              ],
                            )),
                      ],
                      totalRow: totalRows,
                      cells: [
                        const DataCell(Center(child: Text("#PHC VEHICLE"))),
                        const DataCell(Center(child: Text("20/10/2025"))),
                        const DataCell(Center(child: Text("#PHC VEHICLE"))),
                        DataCell(
                          Center(
                            child: Row(
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
                                    Icons.edit_calendar,
                                    size: 28,
                                  ),
                                ),
                                Text("|"),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.transparent,
                                    ), // border color & thickness
                                  ),
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.delete_forever,
                                    size: 28,
                                    color: DynamicColors.redClr,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });
    });
  }
}
