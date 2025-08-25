import 'package:flutter/material.dart';
import '../../../Model/driver_model.dart';
import '../../../component/calender.dart';
import '../Controller/driver_controller.dart';


class DriverForm extends StatefulWidget {
  const DriverForm({Key? key}) : super(key: key);

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  final _formKey = GlobalKey<FormState>();
  final DriverController controller = DriverController();
  final Driver driver = Driver();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Driver",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Colors.grey[200],
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildActionButton("Shifts", Colors.green),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildActionButton("Notes", Colors.green),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upload Image
                  Expanded(flex: 2, child: _buildUploadCard()),

                  const SizedBox(width: 12),

                  // Personal Info
                  Expanded(flex: 5, child: _buildPersonalCard()),

                  const SizedBox(width: 12),

                  // Vehicle Info
                  Expanded(flex: 5, child: _buildVehicleCard()),
                ],
              ),
              const SizedBox(height: 20),

              // TABLES SECTION
              Row(
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
      ),
    );
  }

  Widget _buildUploadCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          height: 445,
          width: double.infinity,
          // color: Colors.grey[200],
          alignment: Alignment.center,
          child: const Text(
            "UPLOAD IMAGE",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Personal Info Card
  Widget _buildPersonalCard() {
    return _buildCard(
      "Personal Information",
      [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                    value: driver.hasPDA,
                    onChanged: (val) => setState(() => driver.hasPDA = val!),
                  ),
                  const Text("Has PDA"),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                    value: driver.rentPaid,
                    onChanged: (val) => setState(() => driver.rentPaid = val!),
                  ),
                  const Text("Rent Paid"),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                    value: driver.isActive,
                    onChanged: (val) => setState(() => driver.isActive = val!),
                  ),
                  const Text("Active"),
                ],
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Company"),
                items: ["Demo Company", "Other Company"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _textField("Username", (val) => driver.username = val),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _textField("Password", (val) => driver.password = val),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _textField("Full Name", (val) => driver.fullName = val),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DOB",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  CalendarDropdown(),
                ],
              ),
            ),

          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(child: _textField("Email", (val) => driver.email = val)),
            const SizedBox(width: 10),
            Expanded(
              child: _textField("Mobile #", (val) => driver.mobile = val),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _textField("Telephone #", (val) => driver.telephone = val),
            ),
            const SizedBox(width: 10),
            Expanded(child: _textField("NI", (val) => driver.ni = val)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _dropdownField("Driver Type", [
                "Commission",
                "Owner Driver",
              ], (val) => driver.driverType = val),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _textField("Commission", (val) => driver.commission = val),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _textField("Rent Limit", (val) => driver.rentLimit = val),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _textField("Balance", (val) => driver.balance = val),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: _textField("Address", (val) => driver.address = val),
            ),
            const Spacer(),
          ],
        ),
      ],
      footer: Container(
        height: kToolbarHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 200,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                _formKey.currentState?.save();
                controller.update(driver as List<Object>?);
                controller.saveDriver();
              },
              child: const Text(
                "SAVE",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Vehicle Info Card
  Widget _buildVehicleCard() {
    return _buildCard(
      "Vehicle Information",
      [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(value: false, onChanged: (val) {}),
                  const Text("Use Company Vehicle"),
                ],
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Company Vehicle",
                ),
                items: ["Company Car 1", "Company Car 2"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Start Date",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  CalendarDropdown(),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "End Date",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  CalendarDropdown(),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _textField("Vehicle #", (val) => driver.vehicleNo = val),
            ),
            const SizedBox(width: 10),
            Expanded(child: _textField("Make", (val) => driver.make = val)),
            const SizedBox(width: 10),
            Expanded(child: _textField("Model", (val) => driver.model = val)),
            const SizedBox(width: 10),
            Expanded(child: _textField("Color", (val) => driver.color = val)),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _dropdownField("Vehicle Type", [
                "Saloon",
                "SUV",
                "Van",
              ], (val) => driver.vehicleType = val),
            ),
            const SizedBox(width: 10),
            Expanded(child: _textField("Owner", (val) => driver.owner = val)),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _textField("Log Book #", (val) => driver.logBook = val),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Log Book Document",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        // Choose File
                        Container(
                          height: double.infinity,
                          color: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          child: const Text(
                            "Choose File",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "NO FILE CHOSEN",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: double.infinity,
                            color: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      footer: Container(
        height: kToolbarHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
      ),
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
