import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';

class VoipSettingsScreen extends StatelessWidget {
  const VoipSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      width: w,
      height: h,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              "VOIP SETTINGS",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Dropdown Row
          Container(
            width: w * 0.5,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text("SERVICE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: "YESTECH",
                        items: const [
                          DropdownMenuItem(value: "YESTECH", child: Text("YESTECH")),
                          DropdownMenuItem(value: "OTHER", child: Text("OTHER")),
                        ],
                        onChanged: (v) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Status
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text("STATUS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 30),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: "RINGING",
                        items: const [
                          DropdownMenuItem(value: "RINGING", child: Text("RINGING")),
                          DropdownMenuItem(value: "ACTIVE", child: Text("ACTIVE")),
                        ],
                        onChanged: (v) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Save Button
                Center(
                  child:    CustomButton(
                    height: 35,
                    width: 80,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                      child:  Text(
                        AppText.save,
                        style: mozillaTextRegularText(
                            fontSize: 12, color: DynamicColors.whiteClr),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Manage Extensions Title
          Container(
            // alignment: Alignment.centerLeft,
            child: const Text(
              "MANAGE EXTENSIONS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          // Table
          Expanded(
            child: Container(
              width: w * 0.6,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("EMPLOYEE")),
                  DataColumn(label: Text("EXTENSION")),
                  DataColumn(label: Text("ACTIONS")),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text("USER")),
                    const DataCell(Text("210")),
                    DataCell(Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit, color:  DynamicColors.primaryClr)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete, color: Colors.red)),
                      ],
                    )),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("NADEEM")),
                    const DataCell(Text("210")),
                    DataCell(Row(
                      children: [
                        IconButton(
                            onPressed: () {},

                            icon:  Icon(Icons.edit, color:  DynamicColors.primaryClr,)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete, color: Colors.red)),
                      ],
                    )),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
