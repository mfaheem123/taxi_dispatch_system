


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
  }

  DropdownModel? selectedTag;

  List<DropdownModel> templateList = [
    DropdownModel(id:1, name: "VIAPOINTS"),
    DropdownModel(id:2, name: "CUSTOMER"),
    DropdownModel(id:3, name: "CUSTOMER EMAIL"),
    DropdownModel(id:4, name: "CUSTOMER MOBILE"),
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
                  height: 8,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(AppText.templateSettings, style: titleDesign())),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Container(
                        width: fieldWidth*2.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: DynamicColors.textClr)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                child: Text(AppText.templateSelection, style: titleDesign()),
                              ),
                              CustomDropdownField<String>(
                                width: fieldWidth/1.5,
                                label: "SELECT TEMPLATE TYPE", items:[
                                "SELECT TEMPLATE TYPE",
                                "EMAIL",
                                "SMS",
                                "NOTIFICATION",
                                "INVOICE",
                                "REPORT",],
                                value: controller.selectedTemplateTitle,
                                itemLabel: (val) => val, // just show the string
                                onChanged: (val) {
                                  controller.selectedTemplateTitle = val;
                                  controller.update();
                                },
                              ),
                              CustomDropdownField<String>(
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
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              CustomButton(
                                width: fieldWidth/2.5,
                                height: 30,
                                borderRadius: 4,
                                verticalPadding: 0.0,
                                fontSize: 11,
                                btnText: AppText.save,
                              )
                            ],
                          ),
                        ),
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
                              CustomDropdownField<DropdownModel>(
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
                      SizedBox(
                          width: fieldWidth*2.4,
                          // height: 300,
                          child: HtmlEditor(
                            controller: controller.templateTitleController,
                            htmlEditorOptions: HtmlEditorOptions(
                              hint: 'Your text here...',
                              shouldEnsureVisible: true,
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
                              mediaUploadInterceptor:
                                  (PlatformFile file, InsertFileType type) async {
                                print(file.name); //filename
                                print(file.size); //size in bytes
                                print(file.extension); //file extension (eg jpeg or mp4)
                                return true;
                              },
                            ),
                            otherOptions: OtherOptions(height: 300),
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
                                //this is commented because it overrides the default Summernote handlers
                                /*onImageLinkInsert: (String? url) {
                      print(url ?? "unknown url");
                    },
                    onImageUpload: (FileUpload file) async {
                      print(file.name);
                      print(file.size);
                      print(file.type);
                      print(file.base64);
                    },*/
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
}
