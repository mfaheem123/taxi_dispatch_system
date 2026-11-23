import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/alert/search_booking.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:dashboard_new1/view/reports/pco_view/pco_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/customButton.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/radio_button_widget.dart';
import '../../../component/text_widget.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/new_window.dart';
import '../../administration/model/list_subsDiary.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class PcoScreen extends StatefulWidget {
  const PcoScreen({super.key});

  @override
  State<PcoScreen> createState() => _PcoScreenState();
}

class _PcoScreenState extends State<PcoScreen> {

  int selectedRowIndex = 0;
  final int totalRows = 50;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
      child: GetBuilder<ReportController>(
        initState: (state){
          controller.clearPcoData();
          controller.getSubsidiary();
        }, builder: (controller) {

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
                  SizedBox(height: 10),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    runAlignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 16,
                    children: [
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.from,
                        width: fieldWidth/2,
                        column: true,
                        child: SizedBox(height: 30, child: KeyboardDatePicker(
                          initialDate: controller.pcoFromDate.isNotEmpty
                              ? DateTime.parse(controller.pcoFromDate)
                              : DateTime(DateTime.now().year, DateTime.now().month, 1),
                          onChanged: (date) {
                            controller.pcoFromDate = date.toIso8601String().split("T").first;
                            controller.update();
                          },
                          onSubmitted: (date) {
                            controller.pcoFromDate = date.toIso8601String().split("T").first;
                            controller.update();
                          },
                        )),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        column: true,
                        label: AppText.to,
                        width: fieldWidth/2,
                        child: SizedBox(height: 30, child: KeyboardDatePicker(
                          initialDate: controller.pcoToDate.isNotEmpty
                              ? DateTime.parse(controller.pcoToDate)
                              : DateTime.now(),
                          onChanged: (date) {
                            controller.pcoToDate = date.toIso8601String().split("T").first;
                            controller.update();
                          },
                          onSubmitted: (date) {
                            controller.pcoToDate = date.toIso8601String().split("T").first;
                            controller.update();
                          },
                        )),
                      ),

                      CustomDropdownField<Subsidiaries>(
                        width: fieldWidth / 2,
                        label: AppText.selectSubsidiary,
                        items: controller.subsDiaryModel?.subsidiaries ?? [],
                        value: controller.selectedSubsidiary,
                        itemLabel: (item) => item.name ?? "",
                        onChanged: (val) {
                          controller.selectedSubsidiary = val;
                          controller.update();
                        },
                      ),

                      CustomDropdownField<String>(
                        width: fieldWidth / 3.5,
                        items: [
                          "ACTIVE ONLY",
                          "SHOW INACTIVE",
                        ],
                        value: controller.selectActive,
                        itemLabel: (val) => val,
                        onChanged: (val) {
                          controller.selectActive = val!;
                          controller.update();
                        },
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "JOBS",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          StatusRadioGroup(
                            options: const [
                              "All",
                              "Completed",
                              "Cancelled",
                            ],
                            onChanged: (index, value) {
                              debugPrint("Selected index: $index, value: $value");
                              controller.selectedJobStatusIndex = index;
                              controller.update();
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),
                      CustomButton(
                        width: 80,
                        height: 30,
                        borderRadius: 4,
                        verticalPadding: 0.0,
                        btnText: AppText.driver,
                        fontSize: 12,
                        onTap: () {
                          controller.getDriverPco();
                        },
                      ),
                      CustomButton(
                        width: 80,
                        height: 30,
                        borderRadius: 4,
                        verticalPadding: 0.0,
                        btnText: "VEHICLE",
                        fontSize: 12,
                        onTap: () {
                          controller.getVehiclePco();
                        },
                      ),
                      CustomButton(
                        width: 80,
                        height: 30,
                        borderRadius: 4,
                        verticalPadding: 0.0,
                        btnText: AppText.view,
                        fontSize: 12,
                        onTap: () {
                          final bool isDriver = controller.showDriverTable;
                          final List bookings = isDriver
                              ? (controller.pcoDriverModel?.bookings ?? [])
                              : (controller.pcoVehicleModel?.bookings ?? []);

                          if (bookings.isEmpty) {
                            BotToast.showText(text: "NO PCO DATA FOUND");
                            return;
                          }
                          openScreenInNewWindow(
                            Routes.pcoView,
                            data: PcoViewData(
                              isDriver: isDriver,
                              subsidiary: controller.selectedSubsidiary,
                              bookings: bookings,
                            ),
                          );
                        },
                      ),
                      Obx(
                            () => CustomButton(
                          width: 95,
                          height: 30,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          btnText: controller.isPcoDownloadReady.value ? "DOWNLOAD" : "GENERATE",
                          fontSize: 12,
                          onTap: () => controller.onPcoGenerateOrDownloadTap(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  if (controller.showDriverTable) ...[
                    if (controller.isLoadingDriverPco)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      Center(
                        child: SizedBox(
                          width: Get.width / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "TOTAL DRIVERS: ${controller.pcoDriverModel?.bookings?.length ?? 0}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: DatatableWidget(
                                    columns: [
                                      buildHeaderWithSearch(
                                          title: "PRIVATE HIRE DRIVER LICENCE NUMBER",
                                          removeSearching: true),
                                      buildHeaderWithSearch(
                                          title: "FIRST NAME", removeSearching: true),
                                      buildHeaderWithSearch(
                                          title: "LAST NAME", removeSearching: true),
                                    ],
                                    totalRow: controller.pcoDriverModel?.bookings?.length ?? 0,
                                    rows: controller.pcoDriverModel?.bookings?.map((booking) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Center(
                                              child: Text((booking.phcDriverNumber ?? "").toUpperCase()))),
                                          DataCell(Center(
                                              child: Text((booking.firstName ?? "").toUpperCase()))),
                                          DataCell(Center(
                                              child: Text((booking.lastName ?? "").toUpperCase()))),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                  if (controller.showVehicleTable) ...[
                    if (controller.isLoadingVehiclePco)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      Center(
                        child: SizedBox(
                          width: Get.width / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "TOTAL VEHICLES: ${controller.pcoVehicleModel?.bookings?.length ?? 0}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                child: SizedBox(
                                  width: Get.width /2,
                                child: DatatableWidget(
                                  columns: [
                                    buildHeaderWithSearch(title: "VRM", removeSearching: true),
                                    buildHeaderWithSearch(title: "VEHICLE MAKE", removeSearching: true),
                                    buildHeaderWithSearch(title: "VEHICLE LICENCE NUMBER", removeSearching: true),
                                  ],
                                  totalRow: controller.pcoVehicleModel?.bookings?.length ?? 0,
                                  rows: controller.pcoVehicleModel?.bookings?.map((booking) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text((booking.vehicleNumber ?? "").toUpperCase()))),
                                        DataCell(Center(child: Text((booking.vehicleMake ?? "").toUpperCase()))),
                                        DataCell(Center(child: Text((booking.phcVehicleNumber ?? "").toUpperCase()))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 10),
                ],
              );
            }
          );
        }
      ),
    );
  }
}
