import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import '../../component/color.dart';
import '../../component/dropdown_button.dart';
import '../../component/networks/api.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../page_scroller.dart';
import 'model/select_templete_type.dart';
import 'model/templete_by_type_model.dart';

class TemplateSettings extends StatefulWidget {
  const TemplateSettings({super.key});

  @override
  State<TemplateSettings> createState() => _TemplateSettingsState();
}

class _TemplateSettingsState extends State<TemplateSettings> {
  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  List permissions = [];
  @override
  void initState() {
    // TODO: implement initState
    permissions = Api().sp.read('all_permissions') ?? [];
    super.initState();
    shortCutKeyValue.value = "templateSettings";
    controller.getTemplateTypes();
  }

  DropdownModel? selectedTag;

  List<DropdownModel> templateList = [
    DropdownModel(id: 1, name: "REFERNCE NUMBER"),
    DropdownModel(id: 2, name: "PICKUP DOOR NUMBER"),
    DropdownModel(id: 3, name: "DROPOFF DOOR NUMBER"),
    DropdownModel(id: 4, name: "PICKUP POINT"),
    DropdownModel(id: 5, name: "DROPOFF POINT"),
    DropdownModel(id: 6, name: "VIAPOINTS"),
    DropdownModel(id: 7, name: "CUSTOMER"),
    DropdownModel(id: 8, name: "CUSTOMER EMAIL"),
    DropdownModel(id: 9, name: "CUSTOMER MOBILE"),
    DropdownModel(id: 10, name: "CUSTOMER TELEPHONE"),
    DropdownModel(id: 11, name: "DATETIME"),
    DropdownModel(id: 12, name: "DATE"),
    DropdownModel(id: 13, name: "TIME"),
    DropdownModel(id: 14, name: "JOURNEY TYPE"),
    DropdownModel(id: 15, name: "ACCOUNT"),
    DropdownModel(id: 16, name: "VEHICLE TYPE"),
    DropdownModel(id: 17, name: "VEHICLE MAKE"),
    DropdownModel(id: 18, name: "VEHICLE MODEL"),
    DropdownModel(id: 19, name: "VEHICLE COLOR"),
    DropdownModel(id: 20, name: "VEHICLE NUMBER"),
    DropdownModel(id: 21, name: "DRIVER NAME"),
    DropdownModel(id: 22, name: "PASSENGERS"),
    DropdownModel(id: 23, name: "CHILD SEATS"),
    DropdownModel(id: 24, name: "LUGGAGES"),
    DropdownModel(id: 25, name: "HAND LUGGAGES"),
    DropdownModel(id: 26, name: "NOTES"),

    // DropdownModel(id: 4, name: "PAYMENT TYPE"),
    DropdownModel(id: 27, name: "PAYMENT TYPE"),
    DropdownModel(id: 28, name: "FARES"),
    DropdownModel(id: 29, name: "COMPANY CHARGES"),
    DropdownModel(id: 30, name: "PARKING CHARGES"),
    DropdownModel(id: 31, name: "CONGESTION CHARGES"),
    DropdownModel(id: 32, name: "MEET & GREET CHARGES"),
    DropdownModel(id: 33, name: "WAITING CHARGES"),
    DropdownModel(id: 34, name: "EXTRA DROPOFF CHARGES"),
    DropdownModel(id: 35, name: "CREDIT CARD CHARGES"),
    DropdownModel(id: 36, name: "T/FARES"),
    DropdownModel(id: 37, name: "RETURN FARES"),
    DropdownModel(id: 38, name: "MILES"),
    DropdownModel(id: 39, name: "COMPANY NAME"),
    DropdownModel(id: 40, name: "COMPANY TELEPHONE NUMBER"),
    DropdownModel(id: 41, name: "COMPANY EMAIL"),
    DropdownModel(id: 42, name: "COMPANY ADDRESS"),
    DropdownModel(id: 43, name: "FLIGHT NUMBER"),
    DropdownModel(id: 44, name: "ARRIVING FROM"),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return PageScrollWrapper(
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

          return controller.templateTypeLoad == true
              ? Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Align(alignment: Alignment.center,
                  child: Text(AppText.templateSettings, style: titleDesign())),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT SECTION
                    Expanded(
                      child: Column(
                        children: [
                          // 1. Template Selection Container
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: DynamicColors.textClr)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                  color: DynamicColors.gryClr.withOpacity(0.5),
                                  child: Text(AppText.templateSelection, style: titleDesign()),
                                ),
                                  
                                Padding(padding: EdgeInsets.all(10.0),
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    children: [
                                      if (permissions.contains('read_template_type'))
                                        CustomDropdownField<TemplateType>(
                                          label: "SELECT TEMPLATE TYPE",
                                          items: controller.selectTempleteType!.templateTypes!,
                                          value: controller.selectedTemplateType,
                                          itemLabel: (val) => (val.name ?? "").toUpperCase(),
                                          onChanged: (val) {
                                            controller.selectedTemplateType = val;
                                            controller.template = null;
                                            controller.templeteByTypeMOdel = null;
                                            controller.getTemplateByTypes(selectedTempId: val!.id);
                                            },
                                        ),
                                      CustomDropdownField<Template>(
                                        label: "SELECT USER",
                                        items: controller.templeteByTypeMOdel?.templates ?? [],
                                        // value: controller.templeteByTypeMOdel?.templates?.contains(controller.template) == true ? controller.template : null,
                                        value: controller.template,
                                        itemLabel: (val) => (val.name ?? "").toUpperCase(),
                                        onChanged: (val) {
                                          controller.template = val;
                                          controller.getTemplateHtmlText(
                                              selectedTempId: val!.id);
                                          },
                                      ),
                                      if (controller.showSubjectField) ...[
                                        Padding(padding: const EdgeInsets.only(top: 15),
                                          child: CustomTextField(
                                            borderRadius: 4,
                                            controller: controller.subjectController,
                                            width: fieldWidth / 1.5,
                                            hintText: "SUBJECT",
                                            height: 30,
                                            columnText: true,
                                            readOnly: controller.template == null,
                                          ),
                                        ),
                                      ],
                                      if (permissions.contains('update_template'))
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20.0),
                                          child: CustomButton(
                                            onTap: () {
                                              controller.updateTemplateHtml(
                                                  templateId: controller.templeteHtmlModel!
                                                      .templates!.id!);
                                              },
                                            verticalPadding: 0.0,
                                            width: controller.showSubjectField ? fieldWidth / 2.5 : fieldWidth / 1.5,
                                            height: 30,
                                            borderRadius: 4,
                                            btnText: AppText.save,
                                            style: mozillaTextSemiBoldText(
                                                fontSize: 10,
                                                color: DynamicColors.whiteClr),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          // 2. HTML Editor Container
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: DynamicColors.textClr)),
                            height: 500,
                            child: IgnorePointer(
                                ignoring: controller.isDropdownOpen,
                                child: HtmlEditor(
                              controller: controller.templateTitleController,
                              htmlEditorOptions: const HtmlEditorOptions(
                                hint: 'WRITE TEXT HERE...',
                                shouldEnsureVisible: true,
                              ),
                              htmlToolbarOptions: HtmlToolbarOptions(
                                toolbarPosition:
                                ToolbarPosition.aboveEditor,
                                toolbarType: ToolbarType.nativeScrollable,
                                defaultToolbarButtons: [
                                  StyleButtons(style: false),
                                  FontButtons(
                                    bold: true,
                                    italic: true,
                                    underline: true,
                                    subscript: false,
                                    strikethrough: false,
                                    superscript: false,
                                  ),
                                  ColorButtons(
                                      highlightColor: true,
                                      foregroundColor: false),
                                  FontSettingButtons(
                                      fontName: false,
                                      fontSize: false,
                                      fontSizeUnit: false),
                                  ParagraphButtons(
                                    alignCenter: true,
                                    alignJustify: true,
                                    alignLeft: true,
                                    alignRight: true,
                                    caseConverter: false,
                                    decreaseIndent: false,
                                    increaseIndent: false,
                                    lineHeight: false,
                                    textDirection: false,
                                  ),
                                ],
                              ),
                              otherOptions:
                              const OtherOptions(height: 500),
                            )
                          ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 15),

                    // RIGHT SECTION
                    SizedBox(width: 280,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: DynamicColors.textClr),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              color: DynamicColors.gryClr.withOpacity(0.5),
                              child: Text(AppText.tags, style: titleDesign()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 580,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: templateList.map((tag) {
                                      return InkWell(
                                        onTap: () {
                                          controller.insertTagValue(
                                              value: tag.name);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Text(
                                            tag.name ?? '',
                                            style: outFitRegular(
                                                fontSize: 10,
                                                fontWeight:
                                                FontWeight.w600,
                                                color: Colors.black87),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    ));
  }
}
//
// DropdownModel? selectedTemplateValue;
//
// List<DropdownModel> selectTemplateList = [
//   DropdownModel(id:1, name: "DRIVER DISPATCH", templateValue: "{{payment_type}} booking | {{reference_number}}customer: {{customer}}mobile: {{customer_mobile}}ph: {{customer_telephone}}{{pickup_door_number}}pickup: {{pickup}}{{viapoints}}{{dropoff_door_number}}dropoff: {{dropoff}}{{flight_number}}{{arriving_from}}pickup date: {{date}}pickup time: {{time}}fares: {{fares}} gbpVEHICLE: {{vehicle_type}}payment type: {{payment_type}}{{special_instructions}}{{company_name}}* reply to these messages are not monitored"),
//   DropdownModel(id:2, name: "CUSTOMER DISPATCH", templateValue: "thank you for booking with {{company_name}} ({{company_telephone}})vehicle: {{vehicle_type}}colour: {{vehicle_color}}make: {{vehicle_make}}model: {{vehicle_model}}reg #: {{vehicle_number}}driver {{driver_name}} will be there with you shortlyfares: {{fares}} gbpmail us on {{company_email}}call us on {{company_telephone}}plus car park/DROP OFF for airport TRANSFERS onlyplease do not replyreply to these messages are not monitored"),
//   DropdownModel(id:3, name: "NORMAL ARRIVAL", templateValue: "do not replyyour driver has arrived and waiting outside in {{vehicle_type}} car* reply to these messages are not monitored"),
//   DropdownModel(id:4, name: "AIRPORT ARRIVAL", templateValue: "do not replyyour driver has arrived and waiting outside in {{vehicle_type}} car* reply to these messages are not monitored"),
//   DropdownModel(id:5, name: "BOOKING CONFIRMATION SMS", templateValue: "DO NOT REPLY.Your car has been booked, From {{pickup_door_number}} {{pickup}} {{viapoints}} {{dropoff_door_number}} {{dropoff}} For {{customer}} at {{date}} {{time}} Fare: {{fares}} GBP TOtal Fare: {{total_fares}} gbp. Thank you for booking with {{company_name}} {{company_telephone}}.Reply to these messages are not monitored."),
//   DropdownModel(id:6, name: "BOOKING CANCEL SMS", templateValue: "DO NOT REPLY.Your booking has been canceled. However, if you still require the taxi, please call the office direct on {{company_telephone}}.Thank you"),
//   DropdownModel(id:6, name: "BOOKING COMPLETE SMS", templateValue: "DO NOT REPLY.Thank you for booking with {{company_name}} ({{company_telephone}}). We hope to serve your again with our best services.Kindly send us your feedback via Call or email on {{company_email}}{{company_telephone}}Reply to these messages are not monitored."),
//   DropdownModel(id:6, name: "MULTIBOOKING CONFIRMATION MESSAGE", templateValue: "do not replyyour car has booked from {{pickup}} to {{dropoff}} for {{customer}} from {{from}} to {{to}}, you need to pay {{fares}} gbp each.thank you for booking with {{company_name}}. for query call us on {{company_telephone}}* reply to these messages are not monitored"),
//   DropdownModel(id:6, name: "BOOKING QUOTATION SMS", templateValue: "DO NOT REPLYBOOKING QUOTATIONThank you for your inquiry about booking information with {{company_name}}Journey details; {{reference_number}}Pickup {{date}} {{time}}From: {{pickup}}To:{{dropoff}}fare: {{total_fares}}\"Please call us at {{company_telephone}} for confirmation or to make any amendments.\"* reply to these messages are not monitored"),
// ];
