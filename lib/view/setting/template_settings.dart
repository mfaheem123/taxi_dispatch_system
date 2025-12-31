
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/view/setting/setting_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/color.dart';
import '../../component/dropdown_button.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../accounts/controller/account_controller.dart';
import '../administration/User/create_userScreen.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "templateSettings";
    controller.getTemplateTypes();

  }



  /// Editable Invoice HTML Template
  final String invoiceHtml = """
<style>
  body {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 12px;
  }

  h2 {
    margin-bottom: 10px;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 12px;
  }

  th, td {
    border: 2px solid  black;
    padding: 6px;
    vertical-align: top;
  }

  th {
    font-weight: bold;
    text-align: left;
    background: #f5f5f5;
  }

  .no-border td {
    border: none;
  }

  .right {
    text-align: right;
  }

  .center {
    text-align: center;
  }
</style>

<h2>CUSTOMER INVOICE</h2>

<!-- FROM / TO TABLE -->
<table>
  <tr>
    <th style="width:50%;">FROM {{DROPOFF}}</th>
    <th style="width:50%;">TO</th>
  </tr>
  <tr>
    <td>
      <%= COMPANY_INFORMATION.ADDRESS %>
    </td>
    <td>
      <b>CUSTOMER:</b> (<%= CUSTOMER_INVOICE?.CUSTOMER.ID || "" %>)<br/>
      <%= CUSTOMER_INVOICE?.CUSTOMER.NAME || "" %>
    </td>
  </tr>
  <tr>
    <td>
      <b>EMAIL:</b> <%= COMPANY_INFORMATION.EMAIL %>
    </td>
    <td>
      <b>DATE:</b> <%= CUSTOMER_INVOICE.INVOICE_DATE %>
    </td>
  </tr>
  <tr>
    <td>
      <b>MOBILE:</b> <%= COMPANY_INFORMATION.EMERGENCY_CONTACT_NUMBER %>
    </td>
    <td>
      <b>DUE DATE:</b> <%= CUSTOMER_INVOICE.INVOICE_DUE_DATE %>
    </td>
  </tr>
  <tr>
    <td>
      <b>TELEPHONE:</b> <%= COMPANY_INFORMATION.TELEPHONE_NUMBER %>
    </td>
    <td></td>
  </tr>
</table>

<!-- PERIOD -->
<p>
  <b>PERIOD:</b>
  (<%= CUSTOMER_INVOICE.FROM_DATE %> - <%= CUSTOMER_INVOICE.TO_DATE %>)
</p>

<!-- BOOKINGS LOOP -->
<% for (let i = 0; i < BOOKINGS.length; i++) { %>

<table>
  <thead>
    <tr>
      <th>REF #</th>
      <th>DATETIME</th>
      <th>VEH</th>
      <th>PICKUP</th>
      <th>DROPOFF</th>
      <th>J/T</th>
      <th>P/T</th>
      <th>FARE</th>
      <th>PC</th>
      <th>WC</th>
      <th>CC</th>
      <th>TOTAL</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><%= BOOKINGS[i].REFERENCE_NUMBER %></td>
      <td>
        <%= BOOKINGS[i].PICKUP_DATE %><br/>
        <%= BOOKINGS[i].PICKUP_TIME %>
      </td>
      <td><%= BOOKINGS[i].VEHICLE_TYPE?.NAME || "" %></td>
      <td>
        <%= BOOKINGS[i].PICKUP %><br/>
        <%= BOOKINGS[i].VIAPOINTS || "" %>
      </td>
      <td><%= BOOKINGS[i].DROPOFF %></td>
      <td><%= BOOKINGS[i].JOURNEY_TYPE?.JOURNEY_TYPE || "" %></td>
      <td><%= BOOKINGS[i].PAYMENT_TYPE?.NAME || "" %></td>
      <td>£ <%= BOOKINGS[i].FARES %></td>
      <td>£ <%= BOOKINGS[i].PARKING_CHARGES %></td>
      <td>£ <%= BOOKINGS[i].WAITING_CHARGES %></td>
      <td>£ <%= BOOKINGS[i].CONGESTION_CHARGES %></td>
      <td>£ <%= BOOKINGS[i].TOTAL_CHARGES %></td>
    </tr>
  </tbody>
</table>

<% } %>

<!-- TOTALS / FOOTER -->
<table>
  <tr>
    <td class="right"><b>TOTAL</b></td>
    <td class="right">£ <%= CUSTOMER_INVOICE.GRAND_TOTAL %></td>
  </tr>
</table>

<p style="font-size:11px;">
  <b>PC</b> = Parking Charges &nbsp;
  <b>WC</b> = Waiting Charges &nbsp;
  <b>CC</b> = Congestion Charges
</p>

<hr/>

<p class="center" style="font-size:11px;">
  MYCABIFY, ALL RIGHTS RESERVED © 2019 – 2025
</p>

""";









  DropdownModel? selectedTag;

  List<DropdownModel> templateList = [
    DropdownModel(id:1, name: "REFERNCE NUMBER"),
    DropdownModel(id:2, name: "PICKUP DOOR NUMBER"),
    DropdownModel(id:3, name: "DROPOFF DOOR NUMBER"),
    DropdownModel(id:4, name: "PICKUP POINT"),
    DropdownModel(id:5, name: "DROPOFF POINT"),
    DropdownModel(id:6, name: "VIAPOINTS"),
    DropdownModel(id:7, name: "CUSTOMER"),
    DropdownModel(id:8, name: "CUSTOMER EMAIL"),
    DropdownModel(id:9, name: "CUSTOMER MOBILE"),
    DropdownModel(id:10, name: "CUSTOMER TELEPHONE"),
    DropdownModel(id:11, name: "DATETIME"),
    DropdownModel(id:12, name: "DATE"),
    DropdownModel(id:13, name: "TIME"),
    DropdownModel(id:14, name: "JOURNEY TYPE"),
    DropdownModel(id:15, name: "ACCOUNT"),
    DropdownModel(id:16, name: "VEHICLE TYPE"),
    DropdownModel(id:17, name: "VEHICLE MAKE"),
    DropdownModel(id:18, name: "VEHICLE MODEL"),
    DropdownModel(id:19, name: "VEHICLE COLOR"),
    DropdownModel(id:20, name: "VEHICLE NUMBER"),
    DropdownModel(id:21, name: "DRIVER NAME"),
    DropdownModel(id:22, name: "PASSENGERS"),
    DropdownModel(id:23, name: "CHILD SEATS"),
    DropdownModel(id:24, name: "LUGGAGES"),
    DropdownModel(id:25, name: "HAND LUGGAGES"),
    DropdownModel(id:26, name: "NOTES"),
    DropdownModel(id:4, name: "PAYMENT TYPE"),
    DropdownModel(id:4, name: "FARES"),
    DropdownModel(id:4, name: "COMPANY CHARGES"),
    DropdownModel(id:4, name: "PARKING CHARGES"),
    DropdownModel(id:4, name: "CONGESTION CHARGES"),
    DropdownModel(id:4, name: "MEET & GREET CHARGES"),
    DropdownModel(id:4, name: "WAITING CHARGES"),
    DropdownModel(id:4, name: "EXTRA DROPOFF CHARGES"),
    DropdownModel(id:4, name: "CREDIT CARD CHARGES"),
    DropdownModel(id:4, name: "T/FARES"),
    DropdownModel(id:4, name: "RETURN FARES"),
    DropdownModel(id:4, name: "MILES"),
    DropdownModel(id:4, name: "COMPANY NAME"),
    DropdownModel(id:4, name: "COMPANY TELEPHONE NUMBER"),
    DropdownModel(id:4, name: "COMPANY EMAIL"),
    DropdownModel(id:4, name: "COMPANY ADDRESS"),
    DropdownModel(id:4, name: "FLIGHT NUMBER"),
    DropdownModel(id:4, name: "ARRIVING FROM"),


  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return GetBuilder<SettingController>(
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

            return
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(AppText.templateSettings, style: titleDesign())),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 16,
                    children: [
                      Container(

                        // width: fieldWidth*2.5,

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: DynamicColors.textClr)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 16,
                            children: [
                              Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                child: Text(AppText.templateSelection, style: titleDesign()),
                              ),
                                CustomDropdownField<TemplateType>(
                                  text: "SELECT TEMPLATE TYPE",
                                  label: "SELECT TEMPLATE TYPE",
                                  items: controller.selectTempleteType!.templateTypes!,
                                  value: controller.selectedTemplateType,
                                  itemLabel: (val) => val.name ?? "",
                                  onChanged: (val) {
                                    controller.selectedTemplateType = val;
                                    controller.getTemplateByTypes(selectedTempId: val!.id);
                                  },
                                ),
                              CustomDropdownField<Template>(
                                text: "Select User",
                                label: "Select User",
                                items: controller.templeteByTypeMOdel?.templates ?? [],
                                value: controller.templeteByTypeMOdel?.templates
                                    ?.contains(controller.template) == true
                                    ? controller.template
                                    : null,
                                itemLabel: (val) => val.name ?? "",
                                onChanged: (val) {
                                  controller.template = val;
                                  controller.getTemplateHtmlText(selectedTempId: val!.id);
                                },
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.emailController,
                                  width: fieldWidth/1.5,
                                  hintText: AppText.email,


                                  // columnText: true,
                                  height: 30,
                                ),
                              ),
                              /*CustomDropdownField<String>(
                                width: fieldWidth/1.5,
                                label: "SELECT TEMPLATE", items:[
                                "DRIVER DISPATCH",
                                "CUSTOMER DISPATCH",
                                "AIRPORT ARRIVAL",
                                "BOOKING CONFIRMATION SMS",
                                "BOOKING CANCEL SMS",
                                "BOOKING COMPLETE SMS",],
                                value: controller.selectedTemplate,
                                itemLabel: (val) => val, // just show the string
                                onChanged: (val) {
                                  controller.selectedTemplate = val;
                                  controller.update();
                                },
                              ),*/
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                              //   child: CustomButton(
                              //     width: fieldWidth/2.5,
                              //     height: 30,
                              //     borderRadius: 4,
                              //     verticalPadding: 0.0,
                              //     fontSize: 11,
                              //     btnText: AppText.save,
                              //   ),
                              // ),



                          Padding(
                            padding: const EdgeInsets.only(top:  20.0),
                            child: CustomButton(
                              onTap: (){
                                controller.updateTemplateHtml(templateId:  controller.templeteHtmlModel!.templates!.id!);
                                print(controller.getTemplateHtmlText(selectedTempId: controller.templeteHtmlModel!.templates!.id)
                                );
                                /// use for download that time is comment
                                /// controller.showDownloadButtons.value = true;
                              },
                              verticalPadding: 0.0,
                              width: fieldWidth/2.5,
                              height: 30,
                              borderRadius: 4,
                              btnText:  AppText.save,
                              style: mozillaTextRegularText(
                                  fontSize: 10, color: DynamicColors.whiteClr),
                            ),
                          ),

                             /// Download PDF BUTTON
                          //     Obx(() => controller.showDownloadButtons.value
                          //         ? CustomButton(
                          //       onTap: () {
                          //         print("DOWNLOAD PDF");
                          //         controller.downloadPdfWebDynamic();
                          //       },
                          //       verticalPadding: 0.0,
                          //       width: 110,
                          //       height: 35,
                          //       borderRadius: 4,
                          //       btnText: "DOWNLOAD PDF",
                          //       style: mozillaTextRegularText(
                          //         fontSize: 10,
                          //         color: DynamicColors.whiteClr,
                          //       ),
                          //     )
                          //         : const SizedBox(),
                          //     ),
                          //

                           /// Download  EXCEL BUTTON
                          // Obx(() => controller.showDownloadButtons.value
                          //     ? CustomButton(
                          //   onTap: () {
                          //     print("DOWNLOAD EXCEL");
                          //   },
                          //   verticalPadding: 0.0,
                          //   width: 120,
                          //   height: 35,
                          //   borderRadius: 4,
                          //   btnText: "DOWNLOAD EXCEL",
                          //   style: mozillaTextRegularText(
                          //     fontSize: 10,
                          //     color: DynamicColors.whiteClr,
                          //   ),
                          // )       : const SizedBox()),

                              /// UPDATE Button
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 20),
                              //   child: CustomButton(
                              //     width: fieldWidth/2.5,
                              //     height: 30,
                              //     borderRadius: 4,
                              //     verticalPadding: 0.0,
                              //     fontSize: 11,
                              //     btnText: AppText.update,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),





                      Container(
                          width: fieldWidth*2.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: DynamicColors.textClr)
                          ),
                          height: 500,
                          child: HtmlEditor(
                            controller: controller.templateTitleController,
                            htmlEditorOptions: HtmlEditorOptions(
                              hint: 'Write text here...',
                              shouldEnsureVisible: true,
initialText: invoiceHtml,
                              //initialText: "<p>text content initial, if any</p>",
                            ),
                            htmlToolbarOptions: HtmlToolbarOptions(
                              toolbarPosition: ToolbarPosition.aboveEditor, //by default
                              toolbarType: ToolbarType.nativeScrollable, //by default
                              onButtonPressed:
                                  (ButtonType type, bool? status, Function? updateStatus) {
                                print(
                                    "button '${type.name}' pressed, the current selected status is $status");
                                return true;
                              },
                              onDropdownChanged: (DropdownType type, dynamic changed,
                                  Function(dynamic)? updateSelectedItem) {
                                print(
                                    "dropdown '${type.name}' changed to $changed");
                                return true;
                              },
                              mediaLinkInsertInterceptor:
                                  (String url, InsertFileType type) {
                                print(url);
                                return true;
                              },
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
                                ColorButtons(highlightColor: true, foregroundColor: false),
                                FontSettingButtons(fontName: false, fontSize: false, fontSizeUnit: false),
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
                                StyleButtons(style: false),
                                FontSettingButtons(
                                  fontSize: false,
                                  fontName: false,
                                  fontSizeUnit: false,
                                ),
                                ListButtons(listStyles: false),
                                InsertButtons(
                                  audio: false,
                                  video: false,
                                  table: false,
                                  hr: false,
                                  link: false,
                                  otherFile: false,
                                  picture: false,
                                ),
                                OtherButtons(
                                  codeview: false,
                                  help: false,
                                  copy: false,
                                  paste: false,
                                  fullscreen: false,
                                  redo: false,
                                  undo: false,
                                ),
                              ],

                            ),
                            otherOptions: OtherOptions(height: 500),
                            callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                              print('html before change is $currentHtml');
                            },
                                onChangeContent: (String? changed) {
                                  print('content changed to $changed');
                                },
                                onChangeCodeview: (String? changed) {
                                  print('code changed to $changed');
                                },
                                onChangeSelection: (EditorSettings settings) {
                                  print('parent element is ${settings.parentElement}');
                                  print('font name is ${settings.fontName}');
                                },
                                onDialogShown: () {
                                  print('dialog shown');
                                },
                                onEnter: () {
                                  print('enter/return pressed');
                                },
                                onFocus: () {
                                  print('editor focused');
                                }, onBlur: () {
                                  print('editor unfocused');
                                }, onBlurCodeview: () {
                                  print('codeview either focused or unfocused');
                                }, onInit: () {
                                  print('init');
                                },
                                onImageUploadError: (FileUpload? file, String? base64Str,
                                    UploadError error) {
                                  print(error.name);
                                  print(base64Str ?? '');
                                  if (file != null) {
                                    print(file.name);
                                    print(file.size);
                                    print(file.type);
                                  }
                                }, onKeyDown: (int? keyCode) {
                                  print('$keyCode key downed');
                                }, onKeyUp: (int? keyCode) {
                                  print('$keyCode key released');
                                }, onMouseDown: () {
                                  print('mouse downed');
                                }, onMouseUp: () {
                                  print('mouse released');
                                }, onNavigationRequestMobile: (String url) {
                                  print(url);
                                  return NavigationActionPolicy.ALLOW;
                                }, onPaste: () {
                                  print('pasted into editor');
                                }, onScroll: () {
                                  print('editor scrolled');
                                }),
                            plugins: [
                              SummernoteAtMention(
                                  getSuggestionsMobile: (String value) {
                                    var mentions = <String>['test1', 'test2', 'test3'];
                                    return mentions
                                        .where((element) => element.contains(value))
                                        .toList();
                                  },
                                  mentionsWeb: ['test1', 'test2', 'test3'],
                                  onSelect: (String value) {
                                    print(value);
                                  }),
                            ],
                          )
                      ),
                      Container(
                        width: fieldWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: DynamicColors.textClr)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Column(
                            children: [

                              Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                child: Text(AppText.tags, style: titleDesign()),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                                child: CustomDropdownField<DropdownModel>(
                                  label: "Select User",
                                  items: templateList,
                                  value: selectedTag,
                                  itemLabel: (templateList) => templateList.name!, // show name
                                  onChanged: (val) {

                                    selectedTag = val;
                                    controller.insertTagValue(value: val?.name);
                                    print("Selected User ID: ${val?.id}");

                                  },
                                ),
                              ),
                       /*       CustomButton(
                                width: fieldWidth/2.5,
                                height: 30,
                                borderRadius: 4,
                                verticalPadding: 0.0,
                                fontSize: 11,
                                btnText: AppText.tags,
                              )*/
                            ],
                          )
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            );
          }
        );
      }
    );
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

}






