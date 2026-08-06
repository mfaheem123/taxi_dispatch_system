import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/drivers_view/driver/create_driver_form/personal_info.dart';
import 'package:dashboard_new1/view/drivers_view/driver/create_driver_form/vehicle_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/image_model.dart';
import '../../../../alert/shift_alert.dart';
import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/networks/api.dart';
import '../../../../component/textStyle.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../controller/driver_controller.dart';

class DriverForm extends StatefulWidget {
  DriverForm({Key? key, this.driverUpdateFlow = false}) : super(key: key);
  bool driverUpdateFlow = false;

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isInitialLoad = true;

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "createDriver";
    if (controller.singleDriverData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.clearAddDriverData();
      });
    }
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _isInitialLoad = false;
      }
    });

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
    if (_isInitialLoad) return;
    
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

    double fieldWidth = isMobile
        ? maxWidth
        : isTablet
            ? maxWidth / 2
            : maxWidth / 4;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      // ensures NumericFocusOrder works globally

      child: GetBuilder<DriverController>(
          initState: (v){
            permissions = Api().sp.read('all_permissions') ?? [];
            if(controller.getCombineVehicleData == null)  {
          controller.getCombineVehicle();
        }
          if(widget.driverUpdateFlow == false){
            controller.clearAddDriverData();
          }
      },
          builder: (controller) {
        return controller.getCombineVehicleLoading.value == true?Center(
          child: CircularProgressIndicator(color: DynamicColors.primaryClr,),
        ):
        SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
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
                        if(permissions.contains('read_driver_shift')) CustomButton(
                          width: 80,
                          height: 35,
                          verticalPadding: 0.0,
                          btnText: "SHIFTS",
                          borderRadius: 4,
                          style: mozillaTextRegularText(
                              fontSize: 14, color: DynamicColors.whiteClr),
                          onTap: () {
                            ShiftAlert.show();
                          },
                        ),
                        const SizedBox(width: 8),
                        CustomButton(
                          width: 80,
                          height: 35,
                          verticalPadding: 0.0,
                          btnText: AppText.note,
                          borderRadius: 4,
                          onTap: (){
                            NoteAlert.show();
                          },
                          style: mozillaTextRegularText(
                              fontSize: 14, color: DynamicColors.whiteClr),
                        ),
                      ],
                    ),
                  ],
                ),
                Wrap(
                  runSpacing: 5,
                  spacing: 5,
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
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Container(
                            height: 345,
                            width: Get.width/5.5,
                            // width: double.infinity,
                            // color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: controller.profileImg != null
                                ? Image.memory(
                              controller.profileImg!.bytes,
                              fit: BoxFit.fill,
                            ):
                            ((controller.singleDriverData != null) && (controller.singleDriverData!.driver!.image != null ))?
                            Image(image: NetworkImage(controller.singleDriverData!.driver!.image!))
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
                    DriverPersonalInfo(),
                    VehicleInformation(),
                  ],
                ),
                SizedBox(height: 20),
                Wrap(
                  children: [
                    DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "EXPIRY DATE", removeSearching: true),
                        buildHeaderWithSearch(title: "EXPIRY TIME", removeSearching: true),
                        buildHeaderWithSearch(title: "BATCH #", removeSearching: true),
                        buildHeaderWithSearch(title: "DOCUMENT TITLE", removeSearching: true),
                        buildHeaderWithSearch(title: "FILE", removeSearching: true),
                        buildHeaderWithSearch(title: "DOCUMENT", removeSearching: true),
                      ],
                      totalRow: 7,
                      rows: List.generate(controller.rows.length, (index) {
                        final row = controller.rows[index];
                        return DataRow(
                          cells: [
                            DataCell(
                              KeyboardDatePicker(
                                key: ValueKey("expiry_date${controller.datePickerKey}"),
                                initialDate: row.expiryDate ?? DateTime.now(),
                                onChanged: (date) {
                                  controller.updateExpiryDate(index, date);
                                },
                              ),
                            ),
                            DataCell(

                        CustomTimePicker(
                          readOnly: true,
                        controller: row.expiryTime, // optional
                        onTimeSelected: (time) {
                        controller.updateExpiryTime(index, time);
                        },
                        )
                            ),
                            DataCell(
                              CustomTextField(
                                width: 150,
                                borderRadius: 4,
                                // readOnly: controller.vehicleInformation.value,
                                controller: row.batchNo,
                                hintText: "${row.documentTitle}",
                                onChanged: (val) {
                                  // row.batchNo.text = val;
                                  // controller.update();
                                  },
                              ),
                            ),
                            DataCell(Text(row.documentTitle ?? "PHC VEHICLE")),
                            DataCell(
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: DynamicColors.primaryClr),
                                ),
                                onPressed: () {
                                  controller.addDocument(index);
                                },
                                child: Text(
                                  row.fileName != null? "DOCUMENTS (1)": "DOCUMENTS",
                                  style: TextStyle(color: DynamicColors.primaryClr),
                                ),
                              ),
                            ),
                            DataCell(
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
                                      child: row.fileName!.bytes.isNotEmpty
                                          ? Image.memory(
                                          row.fileName!.bytes, fit: BoxFit.fill)
                                          : Image(image: NetworkImage(
                                          row.fileName!.name)),
                                    ),
                                    /// Remove button (X icon) to clear the document image
                                    Positioned(
                                      top: -8,
                                      right: -8,
                                      child: GestureDetector(
                                        onTap: () {
                                          /// Remove document image on tap
                                          controller.removeDocument(
                                              controller.rows.indexOf(row));
                                        },
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
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
                              // Container(
                              //   child:
                              //   row.fileName == null?SizedBox.shrink():
                              //   row.fileName!.bytes.isNotEmpty
                              //       ? Image.memory(row.fileName!.bytes,
                              //     fit: BoxFit.fill,
                              //   )
                              //       : Image(
                              //     image: NetworkImage(row.fileName!.name),
                              //   ),
                              // ),
                            ),
                          ],
                        );
                      }),
                    ),
                    _buildValidityTable(),

                  ],
                ),
             SizedBox(height: 90,)
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
              ],
            ),
          ),
        );
      }),
    );
  }

  // RIGHT TABLE
  Widget _buildValidityTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
        dataRowMinHeight: 48,
        dataRowMaxHeight: 56,
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
        columns: const [
          DataColumn(label: Text("START DATE")),
          DataColumn(label: Text("END DATE")),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
              //   KeyboardDatePicker(
              //   initialDate: controller.startDate ?? DateTime.now(),
              //   onChanged: (date) {
              //     controller.startDate = date;
              //     controller.update();
              //   },
              // ),
                  KeyboardDatePicker(
                    key: ValueKey("start_date${controller.datePickerKey}"),
                    initialDate: DateTime.tryParse(controller.startDate ?? '') ?? DateTime.now(),
                    onChanged: (date) => controller.startDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                    onSubmitted: (date) => controller.startDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                  )
              ),
              DataCell(
              //     KeyboardDatePicker(
              //   initialDate: controller.endDate ?? DateTime.now(),
              //   onChanged: (date) {
              //     controller.endDate = date;
              //     controller.update();
              //   },
              // )
                  KeyboardDatePicker(
                    key: ValueKey("end_date${controller.datePickerKey}"),
                    initialDate: DateTime.tryParse(controller.endDate ?? '') ?? DateTime.now(),
                    onChanged: (date) => controller.endDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                    onSubmitted: (date) => controller.endDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                  )
              ),

            ],
          ),
        ],
      ),
    );
  }

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

class ShiftAlertClass{
  String? shiftTitle;
  String? startTime;
  String? endTime;


  ShiftAlertClass({this.shiftTitle,this.endTime,this.startTime});
}

class NoteAlertClass{

  String? notesTitle;
  String? createdItTime;
  String? createdByTime;

  NoteAlertClass({this.createdByTime,this.createdItTime,this.notesTitle});
}
