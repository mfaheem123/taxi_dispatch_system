import 'dart:ui';

import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import '../dashboard_view/booking_table.dart';
import 'controller/setting_controller.dart';

class SmsSettingsScreen extends StatefulWidget {
  const SmsSettingsScreen({super.key});

  @override
  State<SmsSettingsScreen> createState() => _SmsSettingsScreenState();
}

class _SmsSettingsScreenState extends State<SmsSettingsScreen> {
   SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
        child: GetBuilder<SettingController>(
        initState: (v) {
          controller.getSmsTracking();
        },
        builder: (controller) {
          final messagesList = controller.smsTrackingModel?.messages ?? [];

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
                          btnText: "OUTGOING MESSAGE",
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
                          widget: controller.isLoadingSms
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Icon(
                            Icons.refresh,
                            color: DynamicColors.whiteClr,
                            size: 25,
                          ),
                          onTap: () {
                            if (!controller.isLoadingSms) {
                              controller.getSmsTracking();
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  controller.isLoadingSms
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : messagesList.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "No SMS Data Found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                  : SingleChildScrollView(
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
                        totalRow: messagesList.length,
                        rows: messagesList.map((msg) {
                          // Date Formatting
                          String formattedDate = msg.date != null
                              ? "${msg.date!.year}-${msg.date!.month.toString().padLeft(2, '0')}-${msg.date!.day.toString().padLeft(2, '0')}"
                              : '';

                          return DataRow(cells: [
                            DataCell(Center(child: Text((msg.number ?? '').toUpperCase()))),
                            DataCell(Center(child: Text((msg.sms ?? '').toUpperCase()))),
                            DataCell(Center(child: Text(formattedDate))),
                            DataCell(Center(child: Text(msg.time ?? ''))),
                            DataCell(
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
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
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ));
            },
          );
        },
    ));
  }
}