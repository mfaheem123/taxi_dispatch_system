import 'package:flutter/material.dart';

class CompanyVehicleForm extends StatelessWidget {
  const CompanyVehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int columnCount = screenWidth > 900 ? 2 : 1; // Web = 2 columns, Mobile = 1

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Title
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    "COMPANY VEHICLE",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 20),

                // Grid Form
                GridView.count(
                  crossAxisCount: columnCount,
                  shrinkWrap: true,
                  crossAxisSpacing: 20,
                  // mainAxisSpacing: 10,
                  childAspectRatio: 7.0, // Compact height
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildTextField("Vehicle #"),
                    _buildDropdown("Vehicle Type", ["Saloon", "SUV", "Van"]),
                    _buildTextField("Color"),
                    _buildTextField("Make"),
                    _buildTextField("Model"),
                    _buildTextField("Log Book #"),
                    _buildFilePicker("Log Book Document"),
                    _buildDateField("PHC Vehicle Expiry"),
                    _buildTextField("PHC Vehicle Number"),
                    _buildFilePicker("PHC Vehicle Document"),
                    _buildDateField("MOT Expiry"),
                    _buildTextField("MOT Number"),
                    _buildFilePicker("MOT Document"),
                    _buildDateField("MOT2 Expiry"),
                    _buildTextField("MOT2 Number"),
                    _buildFilePicker("MOT2 Document"),
                    _buildDateField("Insurance Expiry"),
                    _buildTextField("Insurance Number"),
                    _buildFilePicker("Insurance Document"),
                  ],
                ),

                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 15)),
                    onPressed: () {},
                    child: const Text("SAVE",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Text Field
  static Widget _buildTextField(String label) {
    return TextField(
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  // Dropdown
  static Widget _buildDropdown(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14))))
          .toList(),
      onChanged: (val) {},
    );
  }

  // Date Field
  static Widget _buildDateField(String label) {
    return TextField(
      readOnly: true,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      onTap: () {
        // Date picker logic
      },
    );
  }

  // File Picker (placeholder)
// File Picker
  static Widget _buildFilePicker(String label) {
    return SizedBox(
      height: 48, // same as TextField
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          suffixIcon: IconButton(
            icon: const Icon(Icons.upload_file, size: 18),
            onPressed: () {
              // File picker logic
            },
          ),
        ),
      ),
    );
  }

}
