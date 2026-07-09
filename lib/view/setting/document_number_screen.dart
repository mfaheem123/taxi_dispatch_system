import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/administration/controller/administration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alert/ducument_number_alert.dart';
import '../../component/networks/api.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'setting_controller.dart';

class DocumentNumberScreen extends StatefulWidget {
  const DocumentNumberScreen({super.key});

  @override
  State<DocumentNumberScreen> createState() => _DocumentNumberScreenState();
}

class _DocumentNumberScreenState extends State<DocumentNumberScreen> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  SettingController controller =
      Get.isRegistered<SettingController>()
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

    return GetBuilder<SettingController>(initState: (v) {
      controller.getDocumentNumber();
      permissions = Api().sp.read('all_permissions') ?? [];
    }, builder: (controller) {
      final documentList = controller.getDocumentNumberModel?.documentNumbers ?? [];

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
                    AppText.documentsNumber,
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 23),
                  ),
                  Spacer(),
                  CustomButton(
                    height: 40,
                    width: 80,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                      child: Icon(
                        Icons.add,
                        color: DynamicColors.whiteClr,
                        size: 25,
                      ),
                    ),
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
            controller.isDocumentNumber
            ? const Center(child: CircularProgressIndicator())
            : documentList.isEmpty
                ? const Center(child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No Data Found"),
            ))
            : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: Get.width,
                child: DatatableWidget(
                  columns: [
                    buildHeaderWithSearch(title: "TABLE"),
                    buildHeaderWithSearch(title: "COLUMN"),
                    buildHeaderWithSearch(title: "SUBSIDIARY"),
                    buildHeaderWithSearch(title: "PREFIX"),
                    buildHeaderWithSearch(title: "START #"),
                    buildHeaderWithSearch(title: "END #"),
                    buildHeaderWithSearch(title: "INCREMENT"),
                    buildHeaderWithSearch(
                        title: "ACTIONS", removeSearching: true),
                  ],
                  totalRow: documentList.length,
                  rows: documentList.map((document) {
                    return DataRow(cells: [
                      DataCell(Center(child: Text((document.documentTable ?? "-").toUpperCase()))),
                      DataCell(Center(child: Text((document.documentColumn ?? "-").toUpperCase()))),
                      DataCell(Center(child: Text((document.subsidiary?.name ?? "-").toUpperCase()))),
                      DataCell(Center(child: Text((document.prefix ?? "-").toUpperCase()))),
                      DataCell(Center(child: Text((document.startNumber?.toString() ?? "-").toUpperCase()))),
                      DataCell(Center(child: Text((document.endNumber?.toString() ?? "-").toUpperCase()))),
                      DataCell(Center(child: Text((document.incrementValue?.toString() ?? "-").toUpperCase()))),
                      DataCell(Center(child:
                        Row(
                          children: [
                            if (permissions.contains('update_document_number'))
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.transparent),
                                ),
                                onPressed: () {
                                  controller.bindDocumentNumber(document);
                                  controller.update();
                                },
                                child: Icon(
                                  Icons.edit_calendar,
                                  size: 28,
                                  color: DynamicColors.primaryClr,
                                ),
                              ),
                            if (permissions.contains('delete_document_number'))
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.transparent),
                                ),
                                onPressed: () {},
                                child:  Icon(
                                  Icons.delete_forever,
                                  size: 28,
                                  color: DynamicColors.redClr,
                                ),
                              ),
                          ],
                        ),
                      ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      });
    },
    );
  }
}
