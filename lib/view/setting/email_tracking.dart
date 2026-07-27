import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import '../../view/setting/controller/setting_controller.dart';
import '../dashboard_view/booking_table.dart';

class EmailTrackingScreen extends StatefulWidget {
  const EmailTrackingScreen({super.key});

  @override
  State<EmailTrackingScreen> createState() => _EmailTrackingScreenState();
}

class _EmailTrackingScreenState extends State<EmailTrackingScreen> {
  final SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      initState: (v) {},
      builder: (controller) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

            final double fieldWidth = isMobile
                ? maxWidth // full width
                : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

            return SingleChildScrollView(
                child: Wrap(
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
                            "EMAIL",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.w800, fontSize: 23),
                          ),
                          const Spacer(),

                          CustomButton(
                            height: 40,
                            width: 50,
                            verticalPadding: 0.0,
                            borderRadius: 4,
                            widget: Icon(
                              Icons.refresh,
                              color: DynamicColors.whiteClr,
                              size: 25,
                            ),
                            onTap: () {
                            },
                          ),
                        ],
                      ),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width,
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: "EMAIL", removeSearching: true),
                            buildHeaderWithSearch(title: "SUBJECT", removeSearching: true),
                            buildHeaderWithSearch(title: "DATE", removeSearching: true),
                            buildHeaderWithSearch(title: "TIME", removeSearching: true),
                            buildHeaderWithSearch(title: "STATUS", removeSearching: true),
                            buildHeaderWithSearch(title: "CONTENT", removeSearching: true),
                          ],
                          totalRow: 1,
                          rows: [
                            DataRow(cells: [
                              const DataCell(Center(child: Text('+1234567890'))),
                              const DataCell(Center(child: Text('HELLO, THIS IS A TEST MESSAGE.'))),
                              const DataCell(Center(child: Text('2026-07-11'))),
                              const DataCell(Center(child: Text('14:30'))),
                              DataCell(
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'SENT',
                                      style: mozillaTextSemiBoldText(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ).copyWith(color: DynamicColors.whiteClr),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'VIEW',
                                      style: mozillaTextSemiBoldText(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ).copyWith(color: DynamicColors.whiteClr),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }
}