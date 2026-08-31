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
import '../page_scroller.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     controller.getCallRecordings();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<SettingController>(
        initState: (state) {
          controller.getCallRecordings();
        },
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
                                      key: ValueKey("from_date_${controller.datePickerKey}"),
                                    // key: ValueKey(controller.callFromDate.value.toString()),
                                    initialDate: controller.callFromDate.value,
                                      onChanged: (date) {
                                        controller.callFromDate.value = date;
                                        controller.isDateSelected = true;
                                        setState(() => {});
                                      }
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
                                  controller: controller.callStartTimeController,
                                  onTimeSelected: (time) => setState(() {}),
                                ),
                              ),
                              SizedBox(width: 10),
                              labeledField(
                                context: context,
                                isMobile: isMobile,
                                label: "TO:",
                                column: false,
                                width: 200,
                                child: SizedBox(
                                  height: 30,
                                  child: KeyboardDatePicker(
                                      key: ValueKey("to_date_${controller.datePickerKey}"),
                                    initialDate: controller.callToDate.value,
                                      onChanged: (date) {
                                        controller.callToDate.value = date;
                                        controller.isDateSelected = true;
                                        setState(() => {});
                                      }
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
                                  controller: controller.callEndTimeController,
                                  onTimeSelected: (time) => setState(() {}),
                                ),
                              ),
                              SizedBox(width: 10),
                              CustomTextField(
                                borderRadius: 4,
                                controller: controller.callMobileController,
                                width: fieldWidth / 2.2,
                                hintText: "MOBILE",
                              ),

                              const Spacer(),

                              CustomButton(
                                height: 35,
                                width: 80,
                                verticalPadding: 0.0,
                                borderRadius: 4,
                                btnText: AppText.clear,
                                fontSize: 14,
                                onTap: () {
                                  controller.clearCallFilters();
                                },
                              ),
                              const SizedBox(width: 10),

                              CustomButton(
                                height: 35,
                                width: 80,
                                verticalPadding: 0.0,
                                borderRadius: 4,
                                btnText: AppText.search,
                                fontSize: 14,
                                onTap: () {
                                  controller.getCallRecordings();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),

                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: controller.isCallLoading
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : SingleChildScrollView(
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: "DATEIME", removeSearching: true),
                            buildHeaderWithSearch(title: "DURATION", removeSearching: true),
                            buildHeaderWithSearch(title: "CUSTOMER", removeSearching: true),
                            buildHeaderWithSearch(title: "MOBILE", removeSearching: true),
                            buildHeaderWithSearch(title: "RECORDING", removeSearching: true),
                          ],
                          totalRow: controller.callRecordingModel?.recordings?.length ?? 0,
                          rows: (controller.callRecordingModel?.recordings ?? []).map((recording) {
                            return DataRow(cells: [
                              // DataCell(Center(child: Text(recording.datetime ?? ''))),
                              DataCell(Center(child: Text(
                                  recording.datetime != null
                                      ? recording.datetime!.split('.').first.replaceFirst('T', ' ').substring(0, 16)
                                      : ''
                              ))),
                              DataCell(Center(child: Text('${recording.duration ?? 0}'))),
                              DataCell(Center(child: Text(recording.customer ?? ''))),
                              DataCell(Center(child: Text(recording.source ?? ''))),
                              DataCell(
                                Center(
                                  child: IconButton(
                                    visualDensity: VisualDensity.compact,
                                    splashRadius: 15,
                                    icon: const Icon(Icons.play_arrow_rounded,
                                        color: Colors.green, size: 28),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AudioPlayerDialog(
                                          audioUrl: recording.filePath ?? '',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ]),
            );
          });
        }));
  }
}
