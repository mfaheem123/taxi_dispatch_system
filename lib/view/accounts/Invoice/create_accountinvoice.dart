import 'package:flutter/material.dart';

class CustomerPreInvoice extends StatelessWidget {
  const CustomerPreInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;


    /// ye screen bni hui hai attech nh ki hai >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "CUSTOMER PRE INVOICE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 16),

            // Top Form (Dates + Invoice #)
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _dateField("INVOICE DATE"),
                _dateField("INVOICE DUE DATE"),
                _textField("INVOICE #", hint: "PRECSH2", readOnly: true, color: Colors.red),
              ],
            ),

            const SizedBox(height: 16),

            // Name + Email + Mobile + Telephone
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _textField("NAME"),
                _textField("EMAIL"),
                _textField("MOBILE"),
                _textField("TELEPHONE"),
              ],
            ),

            const SizedBox(height: 20),

            // Date range + checkboxes
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _dateField("FROM"),
                _dateField("TO"),
                _checkbox("CASH"),
                _checkbox("CREDIT CARD"),
                _checkbox("ACCOUNT"),
                _checkbox("CREDIT CARD PAID"),
                ElevatedButton(onPressed: () {}, child: const Text("FILTER")),
                ElevatedButton(onPressed: () {}, child: const Text("SAVE")),
              ],
            ),

            const SizedBox(height: 20),

            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
                columns: const [

                  DataColumn(label: Text("REF #")),
                  DataColumn(label: Text("DATETIME")),
                  DataColumn(label: Text("PICKUP")),
                  DataColumn(label: Text("DROPOFF")),
                  DataColumn(label: Text("VEH")),
                  DataColumn(label: Text("J/T")),
                  DataColumn(label: Text("P/T")),
                  DataColumn(label: Text("FARE")),
                  DataColumn(label: Text("PC")),
                  DataColumn(label: Text("WC")),
                  DataColumn(label: Text("EDC")),
                  DataColumn(label: Text("M&G")),
                  DataColumn(label: Text("CC")),
                  DataColumn(label: Text("TOTAL")),
                  DataColumn(label: Text("ACTIONS")),

                ],
                rows: const [
                  // Empty row for n
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(String label,
      {String? hint, bool readOnly = false, Color? color}) {
    return SizedBox(
      width: 250,
      child: TextField(
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: color ?? Colors.grey),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget _dateField(String label) {
    return SizedBox(
      width: 200,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
          isDense: true,
        ),
      ),
    );
  }

  Widget _checkbox(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: false, onChanged: (val) {}),
        Text(label),
      ],
    );
  }
}
