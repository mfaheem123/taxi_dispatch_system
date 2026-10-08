import 'package:dashboard_new1/component/action_icon_button.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alert/ducument_number_alert.dart';
import '../../component/networks/api.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../page_scroller.dart';
import 'controller/setting_controller.dart';

class DocumentNumberScreen extends StatefulWidget {
  const DocumentNumberScreen({super.key});

  @override
  State<DocumentNumberScreen> createState() => _DocumentNumberScreenState();
}

class _DocumentNumberScreenState extends State<DocumentNumberScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "DocumentNumberScreen";
  }

  List permissions = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return PageScrollWrapper(
        child: GetBuilder<SettingController>(initState: (v) {
        controller.getDocumentNumber();
        permissions = Api().sp.read('all_permissions') ?? [];
      },
      builder: (controller) {
        final documentList = controller.getDocumentNumberModel?.documentNumbers ?? [];

        return LayoutBuilder(builder: (context, constraints) {
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
                    Text(AppText.documentsNumber,
                      style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    Spacer(),
                    CustomButton(
                      height: 35,
                      width: 40,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      widget: Icon(
                          Icons.add,
                          color: DynamicColors.whiteClr),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddDocumentDialog(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: controller.isDocumentNumber
                      ? const Center(child: CircularProgressIndicator())
                      : documentList.isEmpty
                          ? const Center(
                              child: Padding(padding: EdgeInsets.all(20.0),
                              child: Text("No Data Found"),
                            ))
                          : SingleChildScrollView(
                              child: SizedBox(
                                width: Get.width,
                                child: DatatableWidget(
                                  columns: [
                                    buildHeaderWithSearch(title: "TABLE", removeSearching: true),
                                    buildHeaderWithSearch(title: "COLUMN", removeSearching: true),
                                    buildHeaderWithSearch(title: "SUBSIDIARY", removeSearching: true),
                                    buildHeaderWithSearch(title: "PREFIX", removeSearching: true),
                                    buildHeaderWithSearch(title: "START #", removeSearching: true),
                                    buildHeaderWithSearch(title: "END #", removeSearching: true),
                                    buildHeaderWithSearch(title: "INCREMENT", removeSearching: true),
                                    buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                                  ],
                                  totalRow: documentList.length,
                                  rows: documentList.map((document) {
                                    return DataRow(cells: [
                                      DataCell(Center(child: Text((document.documentTable ?? "-").replaceAll("_", " ").toUpperCase()))),
                                      DataCell(Center(child: Text((document.documentColumn ?? "-").replaceAll("_", " ").toUpperCase()))),
                                      DataCell(Center(child: Text((document.subsidiary?.name ?? "-").toUpperCase()))),
                                      DataCell(Center(child: Text((document.prefix ?? "-").toUpperCase()))),
                                      DataCell(Center(child: Text((document.startNumber?.toString() ?? "-").toUpperCase()))),
                                      DataCell(Center(child: Text((document.endNumber?.toString() ?? "-").toUpperCase()))),
                                      DataCell(Center(child: Text((document.incrementValue?.toString() ?? "-").toUpperCase()))),
                                      DataCell(Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              if (permissions.contains('update_document_number'))
                                                ActionIconButton(
                                                  onPressed: () {
                                                    controller.bindDocumentNumber(document);
                                                    controller.update();
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => const AddDocumentDialog(),
                                                    );
                                                  },
                                                  icon: Icons.edit_calendar,
                                                  color: DynamicColors.primaryClr,
                                                  size: 22,
                                                ),
                                              if (permissions.contains('delete_document_number'))
                                                ActionIconButton(
                                                  onPressed: () {
                                                    controller.documentNumberDelete(document.id);
                                                  },
                                                  icon: Icons.delete_forever,
                                                  color: DynamicColors.redClr,
                                                  size: 22,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            )),
            ],
          );
        });
      },
    ));
  }
}
