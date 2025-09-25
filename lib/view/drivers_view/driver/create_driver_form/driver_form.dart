import 'package:dashboard_new1/component/text_field.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/drivers_view/driver/create_driver_form/personal_info.dart';
import 'package:dashboard_new1/view/drivers_view/driver/create_driver_form/vehicle_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../alert/shift_alert.dart';
import '../../../../component/color.dart';
import '../../../../component/customButton.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../../dashboard_view/widgets/time_picker_widget.dart';
import '../../controller/driver_controller.dart';

class DriverForm extends StatefulWidget {
  const DriverForm({Key? key}) : super(key: key);

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  final _formKey = GlobalKey<FormState>();
  final DriverController controller = Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "createDriver";
  }

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

      child: GetBuilder<DriverController>(builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Driver",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        CustomButton(
                          width: 80,
                          height: 35,
                          verticalPadding: 0.0,
                          btnText: "Shifts",
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
                            )
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
                const SizedBox(height: 20),
                Wrap(
                  children: [
                    DatatableWidget(
                      columns: [
                        buildHeaderWithSearch(title: "EXPIRY DATE"),
                        buildHeaderWithSearch(title: "EXPIRY TIME"),
                        buildHeaderWithSearch(title: "BATCH #"),
                        buildHeaderWithSearch(title: "DOCUMENT TITLE"),
                        buildHeaderWithSearch(title: "FILE"),
                      ],
                      totalRow: 7,
                      cells: [
                        DataCell(
                            KeyboardDatePicker(),
                        ),
                        DataCell(CustomTimePicker()),
                        DataCell(Center(
                          child: CustomTextField(
                            width: 150,
                            borderRadius: 4,
                            controller: TextEditingController(),
                            hintText: "PHC VEHICLE",
                          ),
                        )),
                        const DataCell(Text("PHC VEHICLE")),
                        DataCell(    OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: DynamicColors.primaryClr),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Documents",
                            style: TextStyle(color: DynamicColors.primaryClr),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
                // TABLES SECTION
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
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // LEFT TABLE
  Widget _buildDocumentsTable() {
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
          DataColumn(label: Text("Expiry Date")),
          DataColumn(label: Text("Batch #")),
          DataColumn(label: Text("Document Title")),
          DataColumn(label: Text("File")),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text("20/10/2025")),
              const DataCell(Text("#PHC VEHICLE")),
              const DataCell(Text("PHC VEHICLE")),
              DataCell(
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Documents",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text("15/11/2026")),
              const DataCell(Text("#PHC DRIVER")),
              const DataCell(Text("PHC DRIVER")),
              DataCell(
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Documents",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
          DataColumn(label: Text("Start Date")),
          DataColumn(label: Text("End Date")),
          DataColumn(label: Text("Actions")),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text("10/01/2025")),
              const DataCell(Text("15/12/2025")),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        debugPrint("Edit row 1");
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        debugPrint("Delete row 1");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text("01/03/2026")),
              const DataCell(Text("20/08/2026")),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        debugPrint("Edit row 2");
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        debugPrint("Delete row 2");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Card Builder
  Widget _buildCard(String title, List<Widget> children, {Widget? footer}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),

          if (footer != null) const Divider(height: 1),
          if (footer != null) footer,
        ],
      ),
    );
  }

  Widget _textField(String label, Function(String?)? onSaved) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
          onSaved: onSaved,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }

  // Helper dropdown
  Widget _dropdownField(
    String label,
    List<String> items,
    Function(String?)? onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: () {
          if (label == "Shifts") {
            debugPrint("Shifts button clicked");
          } else if (label == "Notes") {
            debugPrint("Notes button clicked");
          }
        },
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
