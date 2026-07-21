import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';

class ReportHistoryAlert extends StatefulWidget {
  const ReportHistoryAlert({super.key});

  @override
  State<ReportHistoryAlert> createState() => _ReportHistoryAlertState();
}

class _ReportHistoryAlertState extends State<ReportHistoryAlert> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController(text: "07/19/2026");
  final TextEditingController _toDateController = TextEditingController(text: "07/19/2026");

  String selectedStatus = "RECIEVED";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.white,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // ── Title Section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      "CALL LOGS ",
                      style: mozillaTextSemiBoldText(
                        fontSize: 22,
                        color: const Color(0xFF101B2E), // Dark blue/black like image
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "(1)",
                      style: mozillaTextSemiBoldText(
                        fontSize: 22,
                        color: const Color(0xFF4CAF50), // Green 1
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Filter Section ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // FROM Date Picker
                    Text("FROM", style: mozillaTextSemiBoldText(fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(width: 8),
                    _buildDatePicker(_fromDateController,""),
                    const SizedBox(width: 8),

                    // TO Date Picker
                    Text("TO", style: mozillaTextSemiBoldText(fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(width: 8),
                    _buildDatePicker(_toDateController, ""),
                    const SizedBox(width: 16),

                    // Mobile TextField
                    Text("MOBILE", style: mozillaTextSemiBoldText(fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 180,
                      height: 32,
                      child: TextField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: DynamicColors.primaryClr),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Search & Clear Buttons
                    Column(
                      children: [
                        _buildSmallButton("SEARCH", const Color(0xFF4CAF50), Colors.white),
                        const SizedBox(height: 4),
                        _buildSmallButton("CLEAR", const Color(0xFFF44336), Colors.white),
                      ],
                    ),
                    const SizedBox(width: 32),

                    // Status Filter Buttons Group
                    Row(
                      children: [
                        _buildStatusButton("ALL"),
                        const SizedBox(width: 4),
                        _buildStatusButton("RECIEVED"),
                        const SizedBox(width: 4),
                        _buildStatusButton("MISSED"),
                      ],
                    ),
                    const Spacer(),

                    // View Button
                    _buildSmallButton("VIEW", const Color(0xFF4CAF50), Colors.white, onTap: () {
                      _showCallHistoryAlert(context);
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Data Table ──
              Container(
                width: double.infinity,
                color: Colors.white,
                child: DatatableWidget(
                  columns: const [
                    DataColumn(label: Text("NAME")),
                    DataColumn(label: Text("MOBILE")),
                    DataColumn(label: Text("DATE")),
                    DataColumn(label: Text("TIME")),
                    DataColumn(label: Text("EXTENSION")),
                    DataColumn(label: Text("ACTIONS")),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text("TEST NO", style: mozillaTextSemiBoldText(fontSize: 12))),
                        DataCell(Text("02083491515", style: mozillaTextSemiBoldText(fontSize: 12))),
                        DataCell(Text("20-05-26", style: mozillaTextSemiBoldText(fontSize: 12))),
                        DataCell(Text("01:25", style: mozillaTextSemiBoldText(fontSize: 12))),
                        DataCell(Text("255", style: mozillaTextSemiBoldText(fontSize: 12))),
                        DataCell(
                          Center(
                            child: _buildSmallButton("PICK", const Color(0xFF4CAF50), Colors.white),
                          ),
                        ),
                      ]
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
          ],
        ),
      );
    });
  }

  Widget _buildDatePicker(TextEditingController controller, String timeHint) {
    return SizedBox(
      width: 140,
      height: 32,
      child: KeyboardDatePicker(
        key: ValueKey(controller.text),
        initialDate: controller.text.isNotEmpty && controller.text != ""
            ? DateTime.tryParse(controller.text) ?? DateTime.now()
            : DateTime.now(),
        borderClr: Colors.grey.shade400,
        fontSize: 12,
        iconSize: 14,
        onChanged: (date) {
          setState(() {
            controller.text = date.toIso8601String().split("T").first;
          });
        },
        onSubmitted: (date) {
          setState(() {
            controller.text = date.toIso8601String().split("T").first;
          });
        },
      ),
    );
  }

  Widget _buildSmallButton(String text, Color bgColor, Color textColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: mozillaTextSemiBoldText(
            fontSize: 11,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showCallHistoryAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 700,
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo placeholder
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF4CAF50), width: 3),
                  ),
                  child: Center(
                    child: Text(
                      "NEXUS TECH GROUPS",
                      textAlign: TextAlign.center,
                      style: mozillaTextSemiBoldText(
                        fontSize: 20,
                        color: const Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  "CALL HISTORY",
                  style: mozillaTextSemiBoldText(
                    fontSize: 28,
                    color: const Color(0xFF101B2E),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Details Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("MOBILE: 02082017777", style: mozillaTextSemiBoldText(fontSize: 16, color: Colors.grey.shade800)),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text("TOTAL CALLS: 100", style: mozillaTextSemiBoldText(fontSize: 16, color: Colors.grey.shade800)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Right Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("EMAIL: DEMO@DEMO.COM", style: mozillaTextSemiBoldText(fontSize: 16, color: Colors.grey.shade800)),
                          const SizedBox(height: 4),
                          Text("TELEPHONE: 02082017777", style: mozillaTextSemiBoldText(fontSize: 16, color: Colors.grey.shade800)),
                          const SizedBox(height: 8),
                          const Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Data Table inside Dialog
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: DatatableWidget(
                    columns: const [
                      DataColumn(label: Text("NAME")),
                      DataColumn(label: Text("MOBILE")),
                      DataColumn(label: Text("DATE")),
                      DataColumn(label: Text("TIME")),
                      DataColumn(label: Text("EXTENSION")),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text("TEST", style: mozillaTextSemiBoldText(fontSize: 12))),
                          DataCell(Text("", style: mozillaTextSemiBoldText(fontSize: 12))),
                          DataCell(Text("05-07-26-2026", style: mozillaTextSemiBoldText(fontSize: 12))),
                          DataCell(Text("03:17", style: mozillaTextSemiBoldText(fontSize: 12))),
                          DataCell(Text("600", style: mozillaTextSemiBoldText(fontSize: 12))),
                        ]
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(String title) {
    bool isSelected = selectedStatus == title;

    // According to screenshot:
    // ALL = white bg, green text, green border
    // RECIEVED = green bg, white text, green border (Selected)
    // MISSED = white bg, red text, red border

    Color bgColor = Colors.white;
    Color textColor = Colors.black;
    Color borderColor = Colors.grey;

    if (title == "ALL") {
      textColor = isSelected ? Colors.white : const Color(0xFF4CAF50);
      bgColor = isSelected ? const Color(0xFF4CAF50) : Colors.white;
      borderColor = const Color(0xFF4CAF50);
    } else if (title == "RECIEVED") {
      textColor = isSelected ? Colors.white : const Color(0xFF4CAF50);
      bgColor = isSelected ? const Color(0xFF4CAF50) : Colors.white;
      borderColor = const Color(0xFF4CAF50);
    } else if (title == "MISSED") {
      textColor = isSelected ? Colors.white : const Color(0xFFF44336);
      bgColor = isSelected ? const Color(0xFFF44336) : Colors.white;
      borderColor = const Color(0xFFF44336);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          title,
          style: mozillaTextSemiBoldText(
            fontSize: 11,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
