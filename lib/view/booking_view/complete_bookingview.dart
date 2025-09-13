import 'package:flutter/material.dart';

class CompleteBookingsScreen extends StatelessWidget {
  const CompleteBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F9FC),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔎 Title + Filters Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "COMPLETE BOOKINGS (77)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Keyword",
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {},
                    child: const Text("SEARCH"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {},
                    child: const Text("CLEAR"),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),

          // 📋 Data Table
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                columnSpacing: 40,
                columns: const [
                  DataColumn(label: Text("SOURCE")),
                  DataColumn(label: Text("REF #")),
                  DataColumn(label: Text("DATETIME")),
                  DataColumn(label: Text("CUSTOMER")),
                  DataColumn(label: Text("PICKUP")),
                  DataColumn(label: Text("DROPOFF")),
                  DataColumn(label: Text("ACC")),
                  DataColumn(label: Text("DRV")),
                  DataColumn(label: Text("P/T")),
                  DataColumn(label: Text("VEH")),
                  DataColumn(label: Text("FARE")),
                  DataColumn(label: Text("STATUS")),
                  DataColumn(label: Text("ACTIONS")),
                ],
                rows: [
                  DataRow(
                    cells: [
                      const DataCell(Text("OPT")),
                      const DataCell(Text("BCB75044")),
                      const DataCell(Text("26-08-25 06:00")),
                      const DataCell(Text("CUSTOMER")),
                      const DataCell(Text("NORTHWICK AVENUE")),
                      const DataCell(Text("GREEN PARK WAY")),
                      const DataCell(Text("TEST")),
                      const DataCell(Text("TEST")),
                      const DataCell(Text("CASH")),
                      const DataCell(Text("SAL...")),
                      const DataCell(Text("£10.90")),
                      DataCell(Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "COMP",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                      DataCell(
                        Row(
                          children: const [
                            Icon(Icons.edit, color: Colors.purple),
                            SizedBox(width: 8),
                            Icon(Icons.delete, color: Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ✅ Yahan aur rows add kar sakte ho
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
