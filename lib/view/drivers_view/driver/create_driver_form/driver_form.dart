import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/drivers_view/driver/create_driver_form/personal_info.dart';
import 'package:dashboard_new1/view/drivers_view/driver/create_driver_form/vehicle_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/image_model.dart';
import '../../../../alert/complaint_alert.dart';
import '../../../../alert/shift_alert.dart';
import '../../../../alert/update_driver_rent_email.dart';
import '../../../../alert/vehicle_history_alert.dart';
import '../../../../alert/attribute_alert.dart';
import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/networks/api.dart';
import '../../../../component/responsive_datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../controller/driver_controller.dart';
import '../../../../utils/open_new_tab_web.dart';

class DriverForm extends StatefulWidget {
  DriverForm({Key? key, this.driverUpdateFlow = false}) : super(key: key);
  bool driverUpdateFlow = false;

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  final _formKey = GlobalKey<FormState>();

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "createDriver";

    /// Listen for focus changes to auto-scroll the page to the focused widget
    FocusManager.instance.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    /// Remove focus change listener to prevent memory leaks
    FocusManager.instance.removeListener(_onFocusChange);
    super.dispose();
  }

  /// Auto-scroll to the focused widget when focus changes (e.g. via Tab key)
  /// Wrapped in try-catch to handle cases where focused widget is outside a Scrollable (e.g. dialogs, overlays)
  void _onFocusChange() {
    final focusNode = FocusManager.instance.primaryFocus;
    if (focusNode != null && focusNode.context != null && mounted) {
      try {
        Scrollable.ensureVisible(
          focusNode.context!,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (_) {
        /// Ignore error if focused widget has no Scrollable ancestor
      }
    }
  }

  List permissions = [];

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    bool isMobile = maxWidth < 600;
    bool isTablet = maxWidth >= 600 && maxWidth < 1024;
    bool isLaptop = maxWidth >= 1100 && maxWidth <= 1400;

    double fieldWidth = isMobile
        ? maxWidth
        : isTablet
            ? maxWidth / 2
            : maxWidth / 4;
    // double width = WidgetsBinding
    //         .instance.platformDispatcher.views.first.physicalSize.width /
    //     WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      // ensures NumericFocusOrder works globally

      child: GetBuilder<DriverController>(initState: (v) {
        permissions = Api().sp.read('all_permissions') ?? [];
        if (controller.getCombineVehicleData == null) {
          controller.getCombineVehicle();
        }
        if (widget.driverUpdateFlow == false) {
          controller.clearAddDriverData();
        }
      }, builder: (controller) {
        return controller.getCombineVehicleLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: DynamicColors.primaryClr,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "DRIVER",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              if (controller.singleDriverData != null) ...[
                                Container(
                                  height: 35,
                                  width: 145,
                                  padding: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: DynamicColors.primaryClr,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: DynamicColors.whiteClr,
                                          size: 20),
                                      dropdownColor: Colors.white,
                                      focusColor: Colors.transparent,
                                      hint: Center(
                                        child: Text("DOWNLOAD PDF",
                                            style: mozillaTextRegularText(
                                                fontSize: 12,
                                                color: DynamicColors.whiteClr)),
                                      ),
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: 'driver',
                                          child: Text('DRIVER INFORMATION',
                                              style: mozillaTextRegularText(
                                                  fontSize: 12,
                                                  color: Colors.black)),
                                        ),
                                        DropdownMenuItem<String>(
                                          value: 'vehicle',
                                          child: Text('VEHICLE INFORMATION',
                                              style: mozillaTextRegularText(
                                                  fontSize: 12,
                                                  color: Colors.black)),
                                        ),
                                      ],
                                      onChanged: (String? value) {
                                        if (value == 'driver') {
                                          controller.downloadDriverInfoPdf();
                                        } else if (value == 'vehicle') {
                                          controller.downloadVehicleInfoPdf();
                                        }
                                      },
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return [
                                          Center(
                                            child: Text("DOWNLOAD PDF",
                                                style: mozillaTextRegularText(
                                                    fontSize: 12,
                                                    color: DynamicColors
                                                        .whiteClr)),
                                          ),
                                          Center(
                                            child: Text("DOWNLOAD PDF",
                                                style: mozillaTextRegularText(
                                                    fontSize: 12,
                                                    color: DynamicColors
                                                        .whiteClr)),
                                          ),
                                        ];
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(width: 8),
                              CustomButton(
                                width: 100,
                                height: 35,
                                verticalPadding: 0.0,
                                btnText: "ATTRIBUTES",
                                borderRadius: 4,
                                onTap: () {
                                  AttributeAlert.show();
                                },
                                style: mozillaTextRegularText(
                                    fontSize: 12,
                                    color: DynamicColors.whiteClr),
                              ),
                              const SizedBox(width: 8),
                              if (controller.singleDriverData != null) ...[
                                CustomButton(
                                  width: 130,
                                  height: 35,
                                  verticalPadding: 0.0,
                                  btnText: "AUDIT REPORT",
                                  borderRadius: 4,
                                  onTap: () {
                                    String driverId = controller
                                            .singleDriverData?.driver?.id
                                            ?.toString() ??
                                        '';
                                    if (driverId.isNotEmpty) {
                                      openInNewTab(
                                          '#/view/driver_audit_report?id=$driverId');
                                    }
                                  },
                                  style: mozillaTextRegularText(
                                      fontSize: 12,
                                      color: DynamicColors.whiteClr),
                                ),
                              ],
                              const SizedBox(width: 8),
                              if (permissions.contains('read_driver_shift'))
                                CustomButton(
                                  width: 80,
                                  height: 35,
                                  verticalPadding: 0.0,
                                  btnText: "SHIFTS",
                                  borderRadius: 4,
                                  style: mozillaTextRegularText(
                                      fontSize: 14,
                                      color: DynamicColors.whiteClr),
                                  onTap: () {
                                    ShiftAlert.show();
                                  },
                                ),
                              const SizedBox(width: 8),
                              if (controller.singleDriverData != null) ...[
                                CustomButton(
                                  width: 130,
                                  height: 35,
                                  verticalPadding: 0.0,
                                  btnText: "VEHICLE HISTORY",
                                  borderRadius: 4,
                                  onTap: () {
                                    VehicleHistoryAlert.show();
                                  },
                                  style: mozillaTextRegularText(
                                      fontSize: 12,
                                      color: DynamicColors.whiteClr),
                                ),
                              ],
                              const SizedBox(width: 8),
                              CustomButton(
                                width: 80,
                                height: 35,
                                verticalPadding: 0.0,
                                btnText: "NOTES",
                                borderRadius: 4,
                                onTap: () {
                                  NoteAlert.show();
                                },
                                style: mozillaTextRegularText(
                                    fontSize: 14,
                                    color: DynamicColors.whiteClr),
                              ),
                              const SizedBox(width: 8),
                              if (controller.singleDriverData != null) ...[
                                CustomButton(
                                  width: 130,
                                  height: 35,
                                  verticalPadding: 0.0,
                                  btnText: "COMPLAINTS",
                                  borderRadius: 4,
                                  onTap: () {
                                    ComplaintAlert.show();
                                  },
                                  style: mozillaTextRegularText(
                                      fontSize: 12,
                                      color: DynamicColors.whiteClr),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        runSpacing: 12,
                        spacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.pickImage(singleImg: "profileImg");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1),
                              ),
                              width: isMobile
                                  ? maxWidth
                                  : (isTablet ? maxWidth * 0.3 : maxWidth / 6),
                              height: 495,
                              // margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  // height: 345,
                                  // width: Get.width/5.5,
                                  // width: double.infinity,
                                  // color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: controller.profileImg != null
                                      ? Image.memory(
                                          controller.profileImg!.bytes,
                                          fit: BoxFit.fill,
                                          // fit: BoxFit.cover,
                                        )
                                      : ((controller.singleDriverData !=
                                                  null) &&
                                              (controller.singleDriverData!
                                                      .driver!.image !=
                                                  null))
                                          ? Image(
                                              image: NetworkImage(controller
                                                  .singleDriverData!
                                                  .driver!
                                                  .image!))
                                          : Text(
                                              AppText.uploadImage,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 505,
                            child: DriverPersonalInfo(),
                          ),
                          SizedBox(
                            height: 505,
                            child: VehicleInformation(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      LayoutBuilder(builder: (context, tableConstraints) {
                        double leftTableWidth = isMobile
                            ? tableConstraints.maxWidth
                            : isLaptop
                                ? tableConstraints.maxWidth * 0.58
                                : tableConstraints.maxWidth * 0.59;

                        double rightTableWidth = isMobile
                            ? tableConstraints.maxWidth
                            : isLaptop
                                ? tableConstraints.maxWidth * 0.38
                                : tableConstraints.maxWidth * 0.37;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: leftTableWidth,
                              child: ResponsiveDataTableWidget(
                                  totalWidth: leftTableWidth,
                                  columnConfigs: [
                                    TableColumnConfig(
                                        title: "EXPIRY DATE",
                                        sizeType: ColumnSizeType.medium,
                                        removeSearching: true),
                                    TableColumnConfig(
                                        title: "EXPIRY TIME",
                                        sizeType: ColumnSizeType.medium,
                                        removeSearching: true),
                                    TableColumnConfig(
                                        title: "BATCH #",
                                        sizeType: ColumnSizeType.medium,
                                        removeSearching: true),
                                    TableColumnConfig(
                                        title: "DOCUMENT TITLE",
                                        sizeType: ColumnSizeType.large,
                                        removeSearching: true),
                                    TableColumnConfig(
                                        title: "FILE",
                                        sizeType: ColumnSizeType.small,
                                        removeSearching: true),
                                    TableColumnConfig(
                                        title: "DOCUMENT",
                                        sizeType: ColumnSizeType.small,
                                        removeSearching: true),
                                  ],
                                  items: controller.rows,
                                  rowBuilder: (item, widths) {
                                    final row = item as DocumentRow;
                                    return [
                                      Center(
                                          child: SizedBox(
                                              width: 130,
                                              child: KeyboardDatePicker(
                                                  initialDate: row.expiryDate ??
                                                      DateTime.now(),
                                                  onChanged: (date) {
                                                    controller.updateExpiryDate(
                                                        controller.rows
                                                            .indexOf(row),
                                                        date);
                                                  }))),
                                      Center(
                                          child: SizedBox(
                                              height: 38,
                                              child: CustomTimePicker(
                                                  readOnly: true,
                                                  controller: row.expiryTime,
                                                  onTimeSelected: (time) {
                                                    controller.updateExpiryTime(
                                                        controller.rows
                                                            .indexOf(row),
                                                        time);
                                                  }))),
                                      Center(
                                          child: SizedBox(
                                            height: 38,
                                            child: CustomTextField(
                                            width: widths["BATCH #"] ?? 110,
                                            borderRadius: 4,
                                            controller: row.batchNo,
                                            hintText: "${row.documentTitle}",
                                            onChanged: (val) {}),
                                          )),
                                      Center(
                                          child: Text(row.documentTitle ??
                                              "PHC VEHICLE")),
                                      Container(
                                        width: widths["FILE"] != null
                                            ? (widths["FILE"]! + 20)
                                            : 130,
                                        alignment: Alignment.center,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            side: BorderSide(
                                                color:
                                                    DynamicColors.primaryClr),
                                          ),
                                          onPressed: () {
                                            controller.addDocument(
                                                controller.rows.indexOf(row));
                                          },
                                          child: Text(
                                            row.fileName != null
                                                ? "DOCUMENTS (1)"
                                                : "DOCUMENTS",
                                            style: TextStyle(
                                              color: DynamicColors.primaryClr,
                                              fontSize: 11,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),

                                      /// Document image preview with remove button
                                      Container(
                                        width: 60,
                                        height: 40,
                                        child: row.fileName == null
                                            ? SizedBox.shrink()
                                            : Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  /// Show the selected document image
                                                  Positioned.fill(
                                                    child: row.fileName!.bytes
                                                            .isNotEmpty
                                                        ? Image.memory(
                                                            row.fileName!.bytes,
                                                            fit: BoxFit.fill)
                                                        : Image(
                                                            image: NetworkImage(
                                                                row.fileName!
                                                                    .name)),
                                                  ),

                                                  /// Remove button (X icon) to clear the document image
                                                  Positioned(
                                                    top: -8,
                                                    right: -8,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        /// Remove document image on tap
                                                        controller
                                                            .removeDocument(
                                                                controller.rows
                                                                    .indexOf(
                                                                        row));
                                                      },
                                                      child: Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 12,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ];
                                  }),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: rightTableWidth,
                              child: ResponsiveDataTableWidget(
                                totalWidth: rightTableWidth,
                                columnConfigs: [
                                  TableColumnConfig(
                                      title: "START DATE",
                                      sizeType: ColumnSizeType.medium,
                                      removeSearching: true),
                                  TableColumnConfig(
                                      title: "END DATE",
                                      sizeType: ColumnSizeType.medium,
                                      removeSearching: true),
                                ],
                                items: [1],
                                rowBuilder: (item, widths) {
                                  return [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: KeyboardDatePicker(
                                          initialDate: controller.startDate ??
                                              DateTime.now(),
                                          onChanged: (date) {
                                            controller.startDate = date;
                                            controller.update();
                                          },
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: KeyboardDatePicker(
                                          initialDate: controller.endDate ??
                                              DateTime.now(),
                                          onChanged: (date) {
                                            controller.endDate = date;
                                            controller.update();
                                          },
                                        )),
                                  ];
                                },
                              ),
                            ),
                          ],
                        );
                        /*   // TABLES SECTION
                width < 1920
                    ? Column(
                        children: [
                          _buildDocumentsTable(),
                          const SizedBox(height: 12),
                          _buildValidityTable(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LEFT SIDE
                          Expanded(flex: 7, child: _buildDocumentsTable()),
                          const SizedBox(width: 12),
                          // RIGHT SIDE
                          Expanded(flex: 5, child: _buildValidityTable()),
                        ],
                      ),*/
                      }),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  // RIGHT TABLE
  // Widget _buildValidityTable() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(6),
  //       border: Border.all(color: Colors.grey.shade400, width: 1),
  //     ),
  //     margin: const EdgeInsets.only(bottom: 12),
  //     child: DataTable(
  //       headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
  //       dataRowMinHeight: 48,
  //       dataRowMaxHeight: 56,
  //       headingTextStyle: const TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 14,
  //         color: Colors.black,
  //       ),
  //       columns: const [
  //         DataColumn(label: Text("START DATE")),
  //         DataColumn(label: Text("END DATE")),
  //       ],
  //       rows: [
  //         DataRow(
  //           cells: [
  //             DataCell( KeyboardDatePicker(
  //               initialDate: controller.startDate ?? DateTime.now(),
  //               onChanged: (date) {
  //                 controller.startDate = date;
  //                 controller.update();
  //               },
  //             ),),
  //             DataCell(KeyboardDatePicker(
  //               initialDate: controller.endDate ?? DateTime.now(),
  //               onChanged: (date) {
  //                 controller.endDate = date;
  //                 controller.update();
  //               },
  //             )
  //             ),
  //
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class DocumentRow {
  DateTime? expiryDate;
  TextEditingController expiryTime = TextEditingController();
  TextEditingController batchNo = TextEditingController();
  String? documentTitle;
  ImageModel? fileName;
  String? paramTitle;

  DocumentRow({
    this.expiryDate,
    required this.expiryTime,
    required this.batchNo,
    this.documentTitle,
    this.fileName,
    this.paramTitle,
  });
}

class ShiftAlertClass {
  String? shiftTitle;
  String? startTime;
  String? endTime;

  ShiftAlertClass({this.shiftTitle, this.endTime, this.startTime});
}

class NoteAlertClass {
  String? notesTitle;
  String? createdItTime;
  String? createdByTime;

  NoteAlertClass({this.createdByTime, this.createdItTime, this.notesTitle});
}
