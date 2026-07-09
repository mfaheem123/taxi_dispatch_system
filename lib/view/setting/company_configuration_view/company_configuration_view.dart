import 'package:dashboard_new1/view/setting/company_configuration_view/general_configuration_view.dart';
import 'package:dashboard_new1/view/setting/company_configuration_view/payment_getways_view.dart';
import 'package:dashboard_new1/view/setting/company_configuration_view/sms_configuration_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../setting_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: GetBuilder<SettingController>(
          builder: (controller) {
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

              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                     crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    runSpacing: 12,
                    children: [
                      Padding(padding: EdgeInsetsGeometry.only(left: 10.0),
                      child:
                      Text(AppText.companyConfigurations, style: titleDesign())),
                      SizedBox(
                        width: 50,
                      ),
                      CustomDropdownField<String>(
                        text: AppText.subsidiary,
                        width: fieldWidth/1.5,
                        label: AppText.subsidiary,
                        items:[
                          "SUBSIDIARY 1",
                          "SUBSIDIARY 2",
                          "SUBSIDIARY 3",
                          "SUBSIDIARY 4",
                          "SUBSIDIARY 5",
                        ],
                        value: controller.selectSubsidiaryValue,
                        itemLabel: (val) => val, // just show the string
                        onChanged: (val) {
                          controller.selectSubsidiaryValue = val!;
                          controller.update();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: kToolbarHeight,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.blueGrey[50]),
                    child:  TabBar(
                      labelPadding: EdgeInsets.symmetric(horizontal: 70),
                      isScrollable: true,
                      labelColor: DynamicColors.primaryClr,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: DynamicColors.primaryClr,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(text: "GENERAL CONFIGURATIONS"),
                        Tab(text: "EMAIL CONFIGURATIONS"),
                        Tab(text: "SMS CONFIGURATIONS"),
                        Tab(text: "MAP CONFIGURATIONS"),
                        Tab(text: "DATETIME CONFIGURATIONS"),
                        Tab(text: "PAYMENT GATEWAYS"),
                      ],
                    ),
                  ),

                  /// 🔹 Neeche ka content flexible banado
                  Container(
                    height: Get.height/1.3,
                    child: TabBarView(
                      children: [
                        GeneralConfigurationView(), // General
                        EmailConfigurationView(), // Email
                        SmsConfigurationView(), // SMS
                        MapConfigurationView(), // Map

                        DateTimeConfigurationView(), // Payment
                        PaymentConfigurationView(), // DateTime
                      ],
                    ),
                  ),

              ],
              ));
            }
          );
        }
      ),
    );
  }
}
