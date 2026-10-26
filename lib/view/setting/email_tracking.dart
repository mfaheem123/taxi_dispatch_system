import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alert/email_tracking_alert.dart';
import '../../component/color.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/pagination.dart';
import '../../component/textStyle.dart';
import '../dashboard_view/booking_table.dart';
import 'controller/setting_controller.dart';

class EmailTrackingScreen extends StatefulWidget {
  const EmailTrackingScreen({super.key});

  @override
  State<EmailTrackingScreen> createState() => _EmailTrackingScreenState();
}

class _EmailTrackingScreenState extends State<EmailTrackingScreen> {
  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  void initState() {
    super.initState();
    controller.getEmailTracking();
  }
  @override
  Widget build(BuildContext context) {
    return PageScrollWrapper(
        child: GetBuilder<SettingController>(
      builder: (controller) {
        final emailList = controller.emailTrackingModel?.emails ?? [];
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
                            widget: controller.isLoadingEmail
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
                              if (!controller.isLoadingEmail) {
                                controller.getEmailTracking();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    controller.isLoadingEmail
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                        : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: maxWidth,
                          child: DatatableWidget(
                            columns: [
                              buildHeaderWithSearch(title: "EMAIL", removeSearching: true),
                              buildHeaderWithSearch(title: "SUBJECT", removeSearching: true),
                              buildHeaderWithSearch(title: "DATE", removeSearching: true),
                              buildHeaderWithSearch(title: "TIME", removeSearching: true),
                              buildHeaderWithSearch(title: "STATUS", removeSearching: true),
                              buildHeaderWithSearch(title: "CONTENT", removeSearching: true),
                            ],
                            totalRow: emailList.length,
                            rows: emailList.map((emailItem) {
                              String statusText = (emailItem.status ?? 'SENT').toUpperCase();

                              String formattedDate = emailItem.date != null
                                  ? "${emailItem.date!.year}-${emailItem.date!.month.toString().padLeft(2, '0')}-${emailItem.date!.day.toString().padLeft(2, '0')}"
                                  : '';

                              return DataRow(cells: [
                                DataCell(Center(child: Text((emailItem.email ?? '').toUpperCase()))),
                                DataCell(Center(child: Text((emailItem.subject ?? '').toUpperCase()))),
                                DataCell(Center(child: Text(formattedDate))),
                                DataCell(Center(child: Text(emailItem.time ?? ''))),
                                DataCell(
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: DynamicColors.primaryClr,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        statusText,
                                        style: mozillaTextSemiBoldText(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: CustomButton(
                                      height: 26,
                                      width: 55,
                                      verticalPadding: 0.0,
                                      borderRadius: 4,
                                      btnText: "VIEW",
                                      btnColor: DynamicColors.primaryClr,
                                      style: mozillaTextRegularText(
                                          fontSize: 10, color: DynamicColors.whiteClr),
                                      onTap: () {
                                        Get.dialog(
                                          EmailContentAlert(
                                            emailContent: emailItem.content ?? '',
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
                    ),
                    PaginationWidget(
                      currentPage: controller.currentEmailPage.value,
                      totalPages: controller.totalEmailPages.value,
                      onPageChange: controller.onPageEmail,
                    ),
                  ],
            );
          },
        );
      },
        ));
  }
}