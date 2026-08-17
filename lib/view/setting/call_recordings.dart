import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../dashboard_view/booking_table.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'audio_player_alert.dart';
import 'controller/extension_controller.dart';
import 'controller/setting_controller.dart';

class CallRecordingScreen extends StatefulWidget {
  const CallRecordingScreen({super.key});

  @override
  State<CallRecordingScreen> createState() => _CallRecordingScreenState();
}

class _CallRecordingScreenState extends State<CallRecordingScreen> {
  final SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
        initState: (v) {},
        builder: (controller) {
          return LayoutBuilder(builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

            final double fieldWidth = isMobile
                ? maxWidth // full width
                : isTablet
                    ? maxWidth / 2
                    : maxWidth / 4;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Container(
                        width: Get.width,
                        padding: EdgeInsets.all(16.0),
                        color: DynamicColors.gryClr.withOpacity(0.5),
                        child: Text(
                          "CALL RECORDINGS",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w800, fontSize: 23),
                        )),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Wrap(
                        spacing: 24,
                        runSpacing: 20,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: "FROM:",
                                column: false,
                                width: 200,
                                child: SizedBox(
                                  height: 30,
                                  child: KeyboardDatePicker(
                                      // initialDate: controller.loginFromDate.value,
                                      // onChanged: (date) =>
                                      //     setState(() => controller.loginFromDate.value = date),
                                      ),
                                ),
                              ),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: "",
                                column: false,
                                width: 150,
                                child: CustomTimePicker(
                                    // controller: controller.loginStartTimeController,
                                    // onTimeSelected: (time) => setState(() {}),
                                    ),
                              ),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: "TO:",
                                column: false,
                                width: 200,
                                child: SizedBox(
                                  height: 30,
                                  child: KeyboardDatePicker(
                                      // initialDate: controller.loginToDate.value,
                                      // onChanged: (date) =>
                                      //     setState(() => controller.loginToDate.value = date),
                                      ),
                                ),
                              ),

                              // End Time
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: "",
                                column: false,
                                width: 150,
                                child: CustomTimePicker(
                                    // controller: controller.loginEndTimeController,
                                    // onTimeSelected: (time) => setState(() {}),
                                    ),
                              ),
                              SizedBox(width: 10),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.mobileController,
                                width: fieldWidth / 2.2,
                                hintText: "MOBILE",
                              ),

                              const Spacer(),

                              CustomButton(
                                height: 40,
                                width: 80,
                                verticalPadding: 0.0,
                                borderRadius: 4,
                                btnText: AppText.clear,
                                fontSize: 14,
                                onTap: () {},
                              ),
                              const SizedBox(width: 10),

                              CustomButton(
                                height: 40,
                                width: 80,
                                verticalPadding: 0.0,
                                borderRadius: 4,
                                btnText: AppText.search,
                                fontSize: 14,
                                onTap: () {},
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width,
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: "DATE & TIME"),
                            buildHeaderWithSearch(title: "DURATION"),
                            buildHeaderWithSearch(title: "CUSTOMER"),
                            buildHeaderWithSearch(title: "MOBILE"),
                            buildHeaderWithSearch(title: "RECORDING"),
                          ],
                          totalRow: 1,
                          rows: [
                            DataRow(cells: [
                              const DataCell(
                                  Center(child: Text('2026-07-13 11:20 AM'))),
                              const DataCell(Center(child: Text('02:30 mins'))),
                              const DataCell(Center(child: Text('John Doe'))),
                              const DataCell(
                                  Center(child: Text('+1987654321'))),
                              DataCell(
                                Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.play_arrow_rounded,
                                        color: Colors.green, size: 28),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const AudioPlayerDialog(
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ]),
            );
          });
        });
  }
}
