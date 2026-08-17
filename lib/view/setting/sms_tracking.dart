import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import '../../view/setting/controller/extension_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'controller/setting_controller.dart';

class SmsSettingsScreen extends StatefulWidget {
  const SmsSettingsScreen({super.key});

  @override
  State<SmsSettingsScreen> createState() => _SmsSettingsScreenState();
}

class _SmsSettingsScreenState extends State<SmsSettingsScreen> {
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
                          "SMS",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w800, fontSize: 23),
                        ),
                        const Spacer(),
                        CustomButton(
                          height: 40,
                          width: 160,
                          verticalPadding: 0.0,
                          borderRadius: 4,
                          btnText: "ONGOING MESSAGE",
                          fontSize: 14,
                          onTap: () {
                          },
                        ),
                        const SizedBox(width: 10),
                        // Refresh Custom Button
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
                          buildHeaderWithSearch(title: "NUMBER"),
                          buildHeaderWithSearch(title: "SMS"),
                          buildHeaderWithSearch(title: "DATE"),
                          buildHeaderWithSearch(title: "TIME"),
                          buildHeaderWithSearch(title: "STATUS"),
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
                                    'DELIVERED',
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