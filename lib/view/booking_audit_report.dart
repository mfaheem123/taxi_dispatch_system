import 'package:flutter/material.dart';

import '../component/textStyle.dart';
// Apne project ke mutabiq textStyle import kar lein agar zaroorat ho
// import '../../../../component/textStyle.dart';

class BookingAuditReportView extends StatelessWidget {
  const BookingAuditReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Outer background white kar di hai taake koi extra border/shadow na lage
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          color: Colors.white, // Shadow aur outer decoration hata di hai
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Top Custom Logo & Header Section
              SizedBox(
                height: 45,
                child: Image.asset(
                  "assets/cabflow_logo.png",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "BOOKING AUDIT REPORT",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              const SizedBox(height: 4),
              const Text(
                "66 KINGSLEY ROAD, HOUNSLOW MIDDLESEX, TW3 1QA\nDEMO@DEMO.COM\n02083017777",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 24),

              // 2. Customer & Driver Info Header Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn("CUSTOMER", "NADEM", "MOBILE", "07590455607"),
                    _buildInfoColumn("DRIVER DETAILS", "", "NADEEM KHAN", "(USER: 50)", crossAlign: CrossAxisAlignment.end),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Main Booking Info Table
              _buildSectionHeader("BOOKING DETAILS"),
              const SizedBox(height: 10),
              Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(1.2),
                  1: FlexColumnWidth(1.4),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1.1),
                  4: FlexColumnWidth(1.8),
                  5: FlexColumnWidth(1.8),
                  6: FlexColumnWidth(3.2),
                  7: FlexColumnWidth(0.9),
                  8: FlexColumnWidth(1.1),
                  9: FlexColumnWidth(0.9),
                  10: FlexColumnWidth(0.9),
                  11: FlexColumnWidth(0.8),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                    children: [
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("REF #", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("SUBSIDIARY", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("DATETIME", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("CUSTOMER", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("PICKUP", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("DROPOFF", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("STATUS TIMELINE", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("FARES", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("SOURCE", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("PHC-D", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("PHC-V", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text("VRM", style: mozillaTextSemiBoldText(fontSize: 10, color: Colors.black))),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                          child: const Text("DCB78FE0", style: TextStyle(color: Colors.white, fontSize: 9), textAlign: TextAlign.center),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("DEMO COMPANY", style: TextStyle(fontSize: 10))),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("27-10-26\n21:49", style: TextStyle(fontSize: 9))),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("NADEM", style: TextStyle(fontSize: 10))),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("10 CHAPLIN ROAD", style: TextStyle(fontSize: 10))),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("CAMDEN TOWN", style: TextStyle(fontSize: 10))),
                      Padding(padding: const EdgeInsets.all(6.0), child: _buildStatusTimeline()),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("£14.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("OPERATOR", style: TextStyle(fontSize: 10))),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("558723", style: TextStyle(fontSize: 10))),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("235545", style: TextStyle(fontSize: 10))),
                      const Padding(padding: EdgeInsets.all(6.0), child: Text("SUV", style: TextStyle(fontSize: 10))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 4. Booking Activities Section
              _buildSectionHeader("BOOKING ACTIVITIES"),
              const SizedBox(height: 10),
              _buildActivitiesTable(),
              const SizedBox(height: 30),

              // 5. Booking Updates Section
              _buildSectionHeader("BOOKING UPDATES"),
              const SizedBox(height: 10),
              _buildUpdatesTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title1, String val1, String title2, String val2, {CrossAxisAlignment crossAlign = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(title1, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(val1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title2, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(val2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFFF1F5F9),
      child: Center(
        child: Text(
          title,
          style: mozillaTextSemiBoldText(fontSize: 13, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _statusBadge("ON HOUSE\n21:52:57", Colors.green.shade100, Colors.green),
        const Icon(Icons.chevron_right, size: 12, color: Colors.grey),
        _statusBadge("ASSIGNED\n21:52:58", Colors.green.shade100, Colors.green),
        const Icon(Icons.chevron_right, size: 12, color: Colors.grey),
        _statusBadge("POD\n21:53:05", Colors.green.shade100, Colors.green),
        const Icon(Icons.chevron_right, size: 12, color: Colors.grey),
        _statusBadge("COMPLETED\n21:54:55", Colors.green.shade100, Colors.green),
      ],
    );
  }

  Widget _statusBadge(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: textCol, width: 0.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 7.5, color: textCol, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActivitiesTable() {
    final activities = [
      {"emp": "-", "driver": "(50) NADEEM KHAN", "desc": "DRIVER COMPLETED THE BOOKING", "date": "27-10-26", "time": "21:54:55"},
      {"emp": "-", "driver": "(50) NADEEM KHAN", "desc": "DRIVER POD THE BOOKING", "date": "27-10-26", "time": "21:53:05"},
      {"emp": "-", "driver": "(50) NADEEM KHAN", "desc": "DRIVER ARRIVED AT BOOKING", "date": "27-10-26", "time": "21:53:04"},
      {"emp": "-", "driver": "(50) NADEEM KHAN", "desc": "DRIVER ACCEPTED THE BOOKING", "date": "27-10-26", "time": "21:52:57"},
      {"emp": "NADEEM", "driver": "(50) NADEEM KHAN", "desc": "BOOKING DISPATCH", "date": "27-10-26", "time": "21:52:41"},
    ];

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
        bottom: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(4),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: Text("EMPLOYEE", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
            Padding(padding: const EdgeInsets.all(8.0), child: Text("DRIVER", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
            Padding(padding: const EdgeInsets.all(8.0), child: Text("ACTIVITY DESCRIPTION", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
            Padding(padding: const EdgeInsets.all(8.0), child: Text("DATE", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
            Padding(padding: const EdgeInsets.all(8.0), child: Text("TIME", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
          ],
        ),
        for (var item in activities)
          TableRow(
            children: [
              Padding(padding: const EdgeInsets.all(8.0), child: Text(item["emp"]!, style: const TextStyle(fontSize: 11))),
              Padding(padding: const EdgeInsets.all(8.0), child: Text(item["driver"]!, style: const TextStyle(fontSize: 11))),
              Padding(padding: const EdgeInsets.all(8.0), child: Text(item["desc"]!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))),
              Padding(padding: const EdgeInsets.all(8.0), child: Text(item["date"]!, style: const TextStyle(fontSize: 11))),
              Padding(padding: const EdgeInsets.all(8.0), child: Text(item["time"]!, style: const TextStyle(fontSize: 11, color: Colors.green))),
            ],
          ),
      ],
    );
  }

  Widget _buildUpdatesTable() {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
        bottom: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: Text("EMPLOYEE", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
            Padding(padding: const EdgeInsets.all(8.0), child: Text("PREVIOUS STATE", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
            Padding(padding: const EdgeInsets.all(8.0), child: Text("NEW STATE", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
            Padding(padding: const EdgeInsets.all(8.0), child: Text("DATE", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
            Padding(padding: const EdgeInsets.all(8.0), child: Text("TIME", style: mozillaTextSemiBoldText(fontSize: 11, color: Colors.black))),
          ],
        ),
        TableRow(
          children: [
            const Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontSize: 11))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "MILES: 9.14\nTOTAL CHARGES: 14.0\nPARKING CHARGES: 0\nWAITING CHARGES: 0\nEXTRA DROP CHARGES: 0",
                style: TextStyle(fontSize: 10, color: Colors.grey.shade700, height: 1.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                color: Colors.green.shade50,
                child: const Text(
                  "MILES: 9.14\nTOTAL CHARGES: 14.00\nPARKING CHARGES: 0\nWAITING CHARGES: 0\nEXTRA DROP CHARGES: 0",
                  style: TextStyle(fontSize: 10, height: 1.3),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0), child: Text("27-10-26", style: TextStyle(fontSize: 11))),
            const Padding(padding: EdgeInsets.all(8.0), child: Text("21:55:38", style: TextStyle(fontSize: 11, color: Colors.green))),
          ],
        ),
        TableRow(
          children: [
            const Padding(padding: EdgeInsets.all(8.0), child: Text("NADEEM", style: TextStyle(fontSize: 11))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "MILES: 8.50\nTOTAL CHARGES: 12.0\nPARKING CHARGES: 0\nWAITING CHARGES: 0\nEXTRA DROP CHARGES: 0",
                style: TextStyle(fontSize: 10, color: Colors.grey.shade700, height: 1.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                color: Colors.green.shade50,
                child: const Text(
                  "MILES: 9.14\nTOTAL CHARGES: 14.00\nPARKING CHARGES: 0\nWAITING CHARGES: 0\nEXTRA DROP CHARGES: 0",
                  style: TextStyle(fontSize: 10, height: 1.3),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0), child: Text("27-10-26", style: TextStyle(fontSize: 11))),
            const Padding(padding: EdgeInsets.all(8.0), child: Text("21:52:41", style: TextStyle(fontSize: 11, color: Colors.green))),
          ],
        ),
      ],
    );
  }
}