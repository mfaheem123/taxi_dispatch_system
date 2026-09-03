import 'package:dashboard_new1/view/setting/company_configuration_view/general_configuration_view.dart';
import 'package:dashboard_new1/view/setting/company_configuration_view/payment_getways_view.dart';
import 'package:dashboard_new1/view/setting/company_configuration_view/sms_configuration_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/customButton.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../controller/setting_controller.dart';
import 'date_time_configuration_view.dart';
import 'email_configuration_view.dart';
import 'map_configuration_view.dart';

class CompanyConfigurationView extends StatefulWidget {
  const CompanyConfigurationView({super.key});

  @override
  State<CompanyConfigurationView> createState() => _CompanyConfigurationViewState();
}
class _CompanyConfigurationViewState extends State<CompanyConfigurationView> {
  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of tab views
    final List<Widget> tabViews = [
      const GeneralConfigurationView(),
      const EmailConfigurationView(),
      const SmsConfigurationView(),
      const MapConfigurationView(),
      const DateTimeConfigurationView(),
      const PaymentConfigurationView(),
    ];

    return GetBuilder<SettingController>( initState: (state)  {
      controller.getDocumentSubsidiary();

      // if (controller.selectSubsidiaryValue != null) {
      //   controller.getCompanyConfiguration(controller.selectSubsidiaryValue!);
      // }
    },
      builder: (controller) {
        return LayoutBuilder(builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isMobile = maxWidth < 600;
          final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

          final double fieldWidth = isMobile
              ? maxWidth
              : isTablet
              ? maxWidth / 2
              : maxWidth / 4;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    runSpacing: 12,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(AppText.companyConfigurations, style: titleDesign()),
                      ),
                      const SizedBox(width: 50),
                      CustomDropdownField<dynamic>(
                        width: fieldWidth / 1.5,
                        text: AppText.subsidiary,
                        label: AppText.selectSubsidiary,
                        items: controller.subsDiaryModel?.subsidiaries ?? [],
                        value: controller.subsDiaryModel?.subsidiaries?.firstWhereOrNull(
                              (element) => element.id.toString() == controller.selectSubsidiaryValue.toString(),
                        ),
                        itemLabel: (item) => (item.name ?? "").toUpperCase(),
                        onChanged: (val) {
                          controller.selectSubsidiaryValue = val?.id?.toString();
                          controller.update();
                          // controller.getCompanyConfiguration(controller.selectSubsidiaryValue!);
                        },
                      ),
                      // CustomDropdownField<String>(
                      //   text: AppText.subsidiary,
                      //   width: fieldWidth / 1.5,
                      //   label: AppText.selectSubsidiary,
                      //   items: controller.subsDiaryModel?.subsidiaries?.map((e) => e.id.toString()).toList() ?? [],
                      //   value: controller.selectSubsidiaryValue,
                      //   itemLabel: (val) => val,
                      //   onChanged: (val) {
                      //     controller.selectSubsidiaryValue = val!;
                      //     controller.update();
                      //   },
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // TAB HEADERS (Custom Clickable buttons/tabs)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: Get.width,
                      height: kToolbarHeight,
                      decoration: BoxDecoration(color: Colors.blueGrey[50]),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTabItem("GENERAL CONFIGURATIONS", 0),
                            _buildTabItem("EMAIL CONFIGURATIONS", 1),
                            _buildTabItem("SMS CONFIGURATIONS", 2),
                            _buildTabItem("MAP CONFIGURATIONS", 3),
                            _buildTabItem("DATETIME CONFIGURATIONS", 4),
                            _buildTabItem("PAYMENT GATEWAYS", 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Direct screen render (No height restriction!)
                  tabViews[selectedTabIndex],

                  const SizedBox(height: 20),

                  // SAVE BUTTON
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                      height: 35,
                      width: fieldWidth,
                      fontSize: 14,
                      borderRadius: 4,
                      verticalPadding: 0.0,
                      btnText: AppText.save,
                      onTap: () {
                        controller.saveCompanyConfiguration();

                        // if (controller.selectSubsidiaryValue != null) {
                        //   controller.getCompanyConfiguration(
                        //       controller.selectSubsidiaryValue!);
                        // }
                      }
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isSelected = selectedTabIndex == index;
    final bool isSmallScreen = Get.width < 1024;

    return Focus(
    onKeyEvent: (node, event) {
      return KeyEventResult.ignored;
      },
       child: Builder(builder: (context) {
     final bool isFocused = Focus.of(context).hasFocus;

    return InkWell(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16.0 : 24.0,
          vertical: 14.0,
        ),
        decoration: BoxDecoration(
         color: isFocused ? Colors.blueGrey[100] : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: (isSelected || isFocused) ? DynamicColors.primaryClr : Colors.transparent,
              width: 3.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: (isSelected || isFocused) ? DynamicColors.primaryClr : Colors.black,
            fontSize: Get.width < 1200 ? 11 : 13,
          ),
        ),
      ),
    );
       },

       ),
    );
  }
}
// class _CompanyConfigurationViewState extends State<CompanyConfigurationView> {
//
//   SettingController controller = Get.isRegistered<SettingController>()
//       ? Get.find<SettingController>()
//       : Get.put(SettingController());
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 6,
//       child: GetBuilder<SettingController>(
//           builder: (controller) {
//             return LayoutBuilder(builder: (context, constraints) {
//               final double maxWidth = constraints.maxWidth;
//               final bool isMobile = maxWidth < 600;
//               final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
//
//               // Instead of fixed width, we calculate flexible field widths
//               final double fieldWidth = isMobile
//                   ? maxWidth // full width
//                   : isTablet
//                   ? maxWidth / 2
//                   : maxWidth / 4;
//
//               final double tabViewHeight = maxWidth >= 1400
//                   ? Get.height / 1.6
//                   : isMobile
//                   ? 1100
//                   : 550;
//
//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//                   child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 10),
//                   Wrap(
//                      crossAxisAlignment: WrapCrossAlignment.center,
//                     spacing: 20,
//                     runSpacing: 12,
//                     children: [
//                       Padding(padding: EdgeInsetsGeometry.only(left: 10.0),
//                         child: Text(AppText.companyConfigurations, style: titleDesign())),
//                       SizedBox(width: 50),
//                       CustomDropdownField<String>(
//                         text: AppText.subsidiary,
//                         width: fieldWidth/1.5,
//                         label: AppText.selectSubsidiary,
//                         items:[
//                           "SUBSIDIARY 1",
//                           "SUBSIDIARY 2",
//                           "SUBSIDIARY 3",
//                           "SUBSIDIARY 4",
//                           "SUBSIDIARY 5",
//                         ],
//                         value: controller.selectSubsidiaryValue,
//                         itemLabel: (val) => val, // just show the string
//                         onChanged: (val) {
//                           controller.selectSubsidiaryValue = val!;
//                           controller.update();
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   // Padding(
//                   //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   //   child: Container(
//                   //   width: Get.width,
//                   //   height: kToolbarHeight,
//                   //   decoration: BoxDecoration(color: Colors.blueGrey[50]),
//                   //   child: TabBar(
//                   //     labelPadding: EdgeInsets.symmetric(horizontal: 70),
//                   //     isScrollable: true,
//                   //     labelColor: DynamicColors.primaryClr,
//                   //     unselectedLabelColor: Colors.black,
//                   //     indicatorColor: DynamicColors.primaryClr,
//                   //     labelStyle: TextStyle(
//                   //       fontWeight: FontWeight.bold,
//                   //     ),
//                   //     tabs: [
//                   //       Tab(text: "GENERAL CONFIGURATIONS"),
//                   //       Tab(text: "EMAIL CONFIGURATIONS"),
//                   //       Tab(text: "SMS CONFIGURATIONS"),
//                   //       Tab(text: "MAP CONFIGURATIONS"),
//                   //       Tab(text: "DATETIME CONFIGURATIONS"),
//                   //       Tab(text: "PAYMENT GATEWAYS"),
//                   //     ],
//                   //   ),
//                   // ),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Container(
//                       width: Get.width,
//                       height: kToolbarHeight,
//                       decoration: BoxDecoration(color: Colors.blueGrey[50]),
//                       child: TabBar(
//                         isScrollable: Get.width < 1024,
//                         labelPadding: Get.width < 1024
//                             ? const EdgeInsets.symmetric(horizontal: 16.0)
//                             : EdgeInsets.zero,
//                         labelColor: DynamicColors.primaryClr,
//                         unselectedLabelColor: Colors.black,
//                         indicatorColor: DynamicColors.primaryClr,
//                         labelStyle: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: Get.width < 1200 ? 11 : 13,
//                         ),
//                         tabs: const [
//                           Tab(text: "GENERAL CONFIGURATIONS"),
//                           Tab(text: "EMAIL CONFIGURATIONS"),
//                           Tab(text: "SMS CONFIGURATIONS"),
//                           Tab(text: "MAP CONFIGURATIONS"),
//                           Tab(text: "DATETIME CONFIGURATIONS"),
//                           Tab(text: "PAYMENT GATEWAYS"),
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//
//                   /// 🔹 Neeche ka content flexible banado
//                   Container(
//                     height: tabViewHeight,
//                     child: TabBarView(
//                       children: [
//                         GeneralConfigurationView(), // General
//                         EmailConfigurationView(), // Email
//                         SmsConfigurationView(), // SMS
//                         MapConfigurationView(), // Map
//
//                         DateTimeConfigurationView(), // Payment
//                         PaymentConfigurationView(), // DateTime
//                       ],
//                     ),
//                   ),
//                   // SAVE BUTTON
//                   Align(
//                     alignment: Alignment.center,
//                     child: CustomButton(
//                       height: 35,
//                       width: fieldWidth,
//                       fontSize: 14,
//                       borderRadius: 4,
//                       verticalPadding: 0.0,
//                       btnText: AppText.save,
//                     ),
//                   ),
//                 ],
//                   ),
//               ));
//             });
//           },
//       ),
//     );
//   }
// }