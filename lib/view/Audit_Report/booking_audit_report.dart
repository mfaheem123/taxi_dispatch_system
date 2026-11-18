import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../component/textStyle.dart';
import 'booking_audit_controller.dart';
import 'booking_audit_model.dart';

class BookingAuditReportScreen extends StatefulWidget {
  final int bookingId;

  const BookingAuditReportScreen({super.key, required this.bookingId});

  @override
  State<BookingAuditReportScreen> createState() =>
      _BookingAuditReportScreenState();
}

class _BookingAuditReportScreenState extends State<BookingAuditReportScreen> {
  late BookingAuditController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      BookingAuditController(bookingId: widget.bookingId),
      tag: 'audit_${widget.bookingId}',
    );
  }

  @override
  void dispose() {
    Get.delete<BookingAuditController>(tag: 'audit_${widget.bookingId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty &&
            controller.bookingDetail == null &&
            controller.auditData == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return _buildMainLayout(context);
      }),
    );
  }

  Widget _buildMainLayout(BuildContext context) {
    return Column(
      children: [
        // ── Top Action Bar ───────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.assessment_outlined, color: Color(0xFF22C55E)),
              const SizedBox(width: 10),
              Text(
                'BOOKING AUDIT REPORT - #${controller.bookingDetail?.referenceNumber ?? widget.bookingId}',
                style: mozillaTextSemiBoldText(fontSize: 16, color: Colors.black),
              ),
              const Spacer(),
              // ── PDF Download Button ──────────────────────────────
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                label: const Text(
                  'DOWNLOAD PDF',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: _downloadPdf,
              ),
              const SizedBox(width: 12),
              // ── Refresh button ───────────────────────────────────
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.grey),
                tooltip: 'Refresh',
                onPressed: controller.refresh,
              ),
            ],
          ),
        ),

        // ── Report Content Body ───────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Green Accent Bar
                      Container(
                        height: 3,
                        width: double.infinity,
                        color: const Color(0xFF22C55E),
                      ),
                      const SizedBox(height: 18),

                      // Logo
                      SizedBox(
                        height: 52,
                        child: Image.asset(
                          "assets/cabflow_logo.png",
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF22C55E), width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                "MY\ncabify",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF22C55E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title
                      const Text(
                        "BOOKING AUDIT REPORT",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "66 KINGSLEY ROAD, HOUNSLOW MIDDLESEX, TW3 1QA\nDEMO@DEMO.COM\n02082017777",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Customer + Driver Info Header
                      _buildCustomerDriverHeader(),
                      const SizedBox(height: 22),

                      // 1. Booking Details Table
                      _buildSectionHeader("BOOKING DETAILS"),
                      const SizedBox(height: 10),
                      _buildBookingDetailsTable(),
                      const SizedBox(height: 32),

                      // 2. Booking Activities Section
                      _buildSectionHeader("BOOKING ACTIVITIES"),
                      const SizedBox(height: 10),
                      _buildActivitiesTable(),
                      const SizedBox(height: 32),

                      // 3. Booking Updates Section
                      _buildSectionHeader("BOOKING UPDATES"),
                      const SizedBox(height: 10),
                      _buildUpdatesTable(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Header Bar: Customer & Driver details ──────────────────────────────────
  Widget _buildCustomerDriverHeader() {
    final booking = controller.bookingDetail;
    final driver = controller.driverDetail;

    final customerName = (booking?.name ?? 'CUSTOMER').toUpperCase();
    final mobileNumber = booking?.mobile ?? '000';

    final isDriverAssigned = driver != null || (booking?.driverId != null && booking!.driverId! > 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildInfoColumn("CUSTOMER", customerName),
              const SizedBox(width: 32),
              _buildInfoColumn("MOBILE", mobileNumber),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "DRIVER DETAILS",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              if (isDriverAssigned) ...[
                Text(
                  (driver?.name ?? booking?.driverName ?? 'DRIVER').toUpperCase(),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  "(USER: ${driver?.username ?? driver?.id ?? booking?.driverId ?? ''})",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else ...[
                const Text(
                  "NOT ASSIGNED",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(val,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold)),
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

  // ── Main Booking Table ────────────────────────────────────────────────────
  Widget _buildBookingDetailsTable() {
    final booking = controller.bookingDetail;
    final driver = controller.driverDetail;

    final ref = booking?.referenceNumber ?? '-';
    final subsidiary = (booking?.subsidiaryName ?? 'DEMO COMPANY').toUpperCase();
    final dateTime = "${booking?.pickupDate ?? '-'}\n${booking?.pickupTime ?? ''}".trim();
    final customer = (booking?.name ?? 'CUSTOMER').toUpperCase();
    final pickup = (booking?.pickup ?? '-').toUpperCase();
    final dropoff = (booking?.dropoff ?? '-').toUpperCase();
    final fares = "£${booking?.fares ?? '0.00'}";
    final source = (booking?.bookingSource ?? 'OPERATOR').toUpperCase();

    // Driver specific fields
    final isDriverAssigned = driver != null || (booking?.driverId != null && booking!.driverId! > 0);

    final phcD = isDriverAssigned
        ? (driver?.phcDriverNumber ?? booking?.phcD ?? '-')

        : '-';
    final phcV = isDriverAssigned
        ? (driver?.phcVehicleNumber ?? booking?.phcV ?? '-')
        : '-';
    final vrm = isDriverAssigned
        ? (driver?.vehicleNumber ?? booking?.vrm ?? '-')
        : '-';

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
        verticalInside: BorderSide(color: Colors.grey.shade200, width: 1),
        top: BorderSide(color: Colors.grey.shade300, width: 1),

        left: BorderSide(color: Colors.grey.shade300, width: 1),
        right: BorderSide(color: Colors.grey.shade300, width: 1),
        bottom: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.4),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.1),
        4: FlexColumnWidth(1.8),
        5: FlexColumnWidth(1.8),
        6: FlexColumnWidth(3.4),
        7: FlexColumnWidth(0.9),
        8: FlexColumnWidth(1.1),
        9: FlexColumnWidth(0.9),
        10: FlexColumnWidth(0.9),
        11: FlexColumnWidth(0.8),
      },
      children: [
        // Header Row
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
        // Data Row
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF22C55E), borderRadius: BorderRadius.circular(4)),
                  child: Text(ref, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(6.0), child: Text(subsidiary, style: const TextStyle(fontSize: 10))),
            Padding(padding: const EdgeInsets.all(6.0), child: Text(dateTime, style: const TextStyle(fontSize: 9))),
            Padding(padding: const EdgeInsets.all(6.0), child: Text(customer, style: const TextStyle(fontSize: 10))),
            Padding(padding: const EdgeInsets.all(6.0), child: Text(pickup, style: const TextStyle(fontSize: 10))),
            Padding(padding: const EdgeInsets.all(6.0), child: Text(dropoff, style: const TextStyle(fontSize: 10))),
            Padding(padding: const EdgeInsets.all(6.0), child: _buildStatusTimelineWidget()),
            Padding(padding: const EdgeInsets.all(6.0), child: Text(fares, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(source, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(6.0), child: Text(phcD, style: const TextStyle(fontSize: 10))),
            Padding(padding: const EdgeInsets.all(6.0), child: Text(phcV, style: const TextStyle(fontSize: 10))),
            Padding(padding: const EdgeInsets.all(6.0), child: Text(vrm, style: const TextStyle(fontSize: 10))),
          ],
        ),
      ],
    );
  }

  // ── Status Timeline: [ON ROUTE] > [ARRIVED] > [POB] > [COMPLETED] ──────────
  Widget _buildStatusTimelineWidget() {
    final stages = [
      {'key': 'ON ROUTE', 'label': 'ON ROUTE'},
      {'key': 'ARRIVED', 'label': 'ARRIVED'},
      {'key': 'POB', 'label': 'POB'},
      {'key': 'COMPLETED', 'label': 'COMPLETED'},
    ];

    List<Widget> children = [];
    for (int i = 0; i < stages.length; i++) {
      final stage = stages[i];
      final time = controller.statusTimeline[stage['key']];
      final isDone = time != null && time.isNotEmpty;

      children.add(
        _statusBadge(
          "${stage['label']}\n${isDone ? time : '--:--'}",
          isDone ? Colors.green.shade50 : const Color(0xFFF1F5F9),
          isDone ? Colors.green.shade700 : Colors.grey.shade500,
          isDone ? Colors.green.shade400 : Colors.grey.shade300,
        ),
      );

      if (i < stages.length - 1) {
        children.add(const Icon(Icons.chevron_right, size: 12, color: Colors.grey));
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _statusBadge(String text, Color bg, Color textCol, Color borderCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: borderCol, width: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8,
          color: textCol,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      ),
    );
  }

  // ── Activities Table ──────────────────────────────────────────────────────
  Widget _buildActivitiesTable() {
    final activities = controller.auditData?.activities ?? [];

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
        verticalInside: BorderSide(color: Colors.grey.shade200, width: 1),
        top: BorderSide(color: Colors.grey.shade300, width: 1),
        left: BorderSide(color: Colors.grey.shade300, width: 1),
        right: BorderSide(color: Colors.grey.shade300, width: 1),
        bottom: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(4.5),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1.2),
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
        if (activities.isEmpty)
          const TableRow(
            children: [
              Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontSize: 11))),
              Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontSize: 11))),
              Padding(padding: EdgeInsets.all(8.0), child: Text("No activities recorded", style: TextStyle(fontSize: 11, color: Colors.grey))),
              Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontSize: 11))),
              Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontSize: 11))),
            ],
          )
        else
          for (var item in activities)
            TableRow(
              children: [
                Padding(padding: const EdgeInsets.all(8.0), child: Text(item.employee ?? '-', style: const TextStyle(fontSize: 11))),
                Padding(padding: const EdgeInsets.all(8.0), child: Text(item.driver ?? '-', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))),
                Padding(padding: const EdgeInsets.all(8.0), child: Text((item.activityDescription ?? '-').toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))),
                Padding(padding: const EdgeInsets.all(8.0), child: Text(item.date ?? '-', style: const TextStyle(fontSize: 11))),
                Padding(padding: const EdgeInsets.all(8.0), child: Text(item.time ?? '-', style: const TextStyle(fontSize: 11, color: Color(0xFF22C55E), fontWeight: FontWeight.w600))),
              ],
            ),
      ],
    );
  }

  // ── Updates Table ─────────────────────────────────────────────────────────
  Widget _buildUpdatesTable() {
    final updates = controller.auditData?.updates ?? [];

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
        verticalInside: BorderSide(color: Colors.grey.shade200, width: 1),
        top: BorderSide(color: Colors.grey.shade300, width: 1),
        left: BorderSide(color: Colors.grey.shade300, width: 1),
        right: BorderSide(color: Colors.grey.shade300, width: 1),
        bottom: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(3.5),
        2: FlexColumnWidth(3.5),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1.2),
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
        if (updates.isEmpty)
          const TableRow(
            children: [
              Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontSize: 11))),
              Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontSize: 11))),
              Padding(padding: EdgeInsets.all(8.0), child: Text("No updates recorded", style: TextStyle(fontSize: 11, color: Colors.grey))),
              Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontSize: 11))),
              Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontSize: 11))),
            ],
          )
        else
          for (var item in updates)
            TableRow(
              children: [
                Padding(padding: const EdgeInsets.all(8.0), child: Text(item.employee ?? '-', style: const TextStyle(fontSize: 11))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.previousState,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade700, height: 1.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.green.shade50,
                    child: Text(
                      item.newState,
                      style: TextStyle(fontSize: 10, color: Colors.green.shade900, height: 1.3),
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0), child: Text(item.date ?? '-', style: const TextStyle(fontSize: 11))),
                Padding(padding: const EdgeInsets.all(8.0), child: Text(item.time ?? '-', style: const TextStyle(fontSize: 11, color: Color(0xFF22C55E), fontWeight: FontWeight.w600))),
              ],
            ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // ── PDF GENERATION (Identical Design & Format) ─────────────────────────────
  // ════════════════════════════════════════════════════════════════════════════

  Future<void> _downloadPdf() async {
    final pdf = pw.Document();
    final c = controller;

    final booking = c.bookingDetail;
    final driver = c.driverDetail;
    final audit = c.auditData;

    final isDriverAssigned = driver != null || (booking?.driverId != null && booking!.driverId! > 0);
    final driverDisplay = isDriverAssigned
        ? '${(driver?.name ?? booking?.driverName ?? 'DRIVER').toUpperCase()}\n(USER: ${driver?.username ?? driver?.id ?? booking?.driverId ?? ''})'
        : 'NOT ASSIGNED';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (ctx) => [
          // Header Accent Bar
          pw.Container(
            height: 3,
            width: double.infinity,
            color: PdfColor.fromHex('#22C55E'),
          ),
          pw.SizedBox(height: 12),

          // Title & Address
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  'BOOKING AUDIT REPORT',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, letterSpacing: 1.1),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  '66 KINGSLEY ROAD, HOUNSLOW MIDDLESEX, TW3 1QA\nDEMO@DEMO.COM\n02082017777',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600, lineSpacing: 1.2),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),

          // Customer + Driver Box
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#F1F5F9'),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  children: [
                    _pdfInfoCol('CUSTOMER', (booking?.name ?? 'CUSTOMER').toUpperCase()),
                    pw.SizedBox(width: 24),
                    _pdfInfoCol('MOBILE', booking?.mobile ?? '000'),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('DRIVER DETAILS',
                        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      driverDisplay,
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),

          // 1. BOOKING DETAILS Table
          _pdfSectionHeader('BOOKING DETAILS'),
          pw.SizedBox(height: 6),
          _buildPdfBookingTable(booking, driver, isDriverAssigned),
          pw.SizedBox(height: 16),

          // 2. BOOKING ACTIVITIES Table
          _pdfSectionHeader('BOOKING ACTIVITIES'),
          pw.SizedBox(height: 6),
          _buildPdfActivitiesTable(audit?.activities ?? []),
          pw.SizedBox(height: 16),

          // 3. BOOKING UPDATES Table
          _pdfSectionHeader('BOOKING UPDATES'),
          pw.SizedBox(height: 6),
          _buildPdfUpdatesTable(audit?.updates ?? []),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'Booking_Audit_${booking?.referenceNumber ?? widget.bookingId}.pdf',
    );
  }

  pw.Widget _pdfInfoCol(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        pw.SizedBox(height: 2),
        pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  pw.Widget _pdfSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      color: PdfColor.fromHex('#F1F5F9'),
      child: pw.Center(
        child: pw.Text(
          title,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
      ),
    );
  }

  pw.Widget _buildPdfBookingTable(
    BookingDetailModel? b,
    DriverDetailModel? d,
    bool isDriverAssigned,
  ) {
    final cellStyle = const pw.TextStyle(fontSize: 7.5);
    final headerStyle = pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold);

    final phcD = isDriverAssigned ? (d?.phcDriverNumber ?? b?.phcD ?? '-') : '-';
    final phcV = isDriverAssigned ? (d?.phcVehicleNumber ?? b?.phcV ?? '-') : '-';
    final vrm = isDriverAssigned ? (d?.vehicleNumber ?? b?.vrm ?? '-') : '-';

    // Status timeline text
    final stages = ['ON ROUTE', 'ARRIVED', 'POB', 'COMPLETED'];
    final tlText = stages.map((s) {
      final t = controller.statusTimeline[s];
      return '$s: ${t ?? '--:--'}';
    }).join(' > ');

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.2),
        1: pw.FlexColumnWidth(1.3),
        2: pw.FlexColumnWidth(1.1),
        3: pw.FlexColumnWidth(1.1),
        4: pw.FlexColumnWidth(1.8),
        5: pw.FlexColumnWidth(1.8),
        6: pw.FlexColumnWidth(2.8),
        7: pw.FlexColumnWidth(0.9),
        8: pw.FlexColumnWidth(1.0),
        9: pw.FlexColumnWidth(0.8),
        10: pw.FlexColumnWidth(0.8),
        11: pw.FlexColumnWidth(0.8),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F8FAFC')),
          children: [
            'REF #', 'SUBSIDIARY', 'DATETIME', 'CUSTOMER',
            'PICKUP', 'DROPOFF', 'STATUS TIMELINE',
            'FARES', 'SOURCE', 'PHC-D', 'PHC-V', 'VRM',
          ]
              .map((h) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(h, style: headerStyle)))
              .toList(),
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#22C55E'),
                  borderRadius: pw.BorderRadius.circular(3),
                ),
                child: pw.Text(
                  b?.referenceNumber ?? '-',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(color: PdfColors.white, fontSize: 7.5, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text((b?.subsidiaryName ?? '-').toUpperCase(), style: cellStyle)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${b?.pickupDate ?? ''}\n${b?.pickupTime ?? ''}'.trim(), style: cellStyle)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text((b?.name ?? '-').toUpperCase(), style: cellStyle)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text((b?.pickup ?? '-').toUpperCase(), style: cellStyle)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text((b?.dropoff ?? '-').toUpperCase(), style: cellStyle)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(tlText, style: cellStyle)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('£${b?.fares ?? '0.00'}', style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold))),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text((b?.bookingSource ?? 'OPERATOR').toUpperCase(), style: cellStyle)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(phcD, style: cellStyle)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(phcV, style: cellStyle)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(vrm, style: cellStyle)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfActivitiesTable(List<AuditActivity> activities) {
    final cellStyle = const pw.TextStyle(fontSize: 7.5);
    final headerStyle = pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.5),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(4.5),
        3: pw.FlexColumnWidth(1.2),
        4: pw.FlexColumnWidth(1.2),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F8FAFC')),
          children: ['EMPLOYEE', 'DRIVER', 'ACTIVITY DESCRIPTION', 'DATE', 'TIME']
              .map((h) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(h, style: headerStyle)))
              .toList(),
        ),
        if (activities.isEmpty)
          pw.TableRow(children: List.generate(
            5,
            (_) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('-', style: cellStyle)),
          ))
        else
          ...activities.map(
            (a) => pw.TableRow(children: [
              pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(a.employee ?? '-', style: cellStyle)),
              pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(a.driver ?? '-', style: cellStyle)),
              pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text((a.activityDescription ?? '-').toUpperCase(), style: cellStyle)),
              pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(a.date ?? '-', style: cellStyle)),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(a.time ?? '-', style: pw.TextStyle(fontSize: 7.5, color: PdfColor.fromHex('#22C55E'), fontWeight: pw.FontWeight.bold)),
              ),
            ]),
          ),
      ],
    );
  }

  pw.Widget _buildPdfUpdatesTable(List<AuditUpdate> updates) {
    final cellStyle = const pw.TextStyle(fontSize: 7.5);
    final headerStyle = pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.5),
        1: pw.FlexColumnWidth(3.5),
        2: pw.FlexColumnWidth(3.5),
        3: pw.FlexColumnWidth(1.2),
        4: pw.FlexColumnWidth(1.2),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F8FAFC')),
          children: ['EMPLOYEE', 'PREVIOUS STATE', 'NEW STATE', 'DATE', 'TIME']
              .map((h) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(h, style: headerStyle)))
              .toList(),
        ),
        if (updates.isEmpty)
          pw.TableRow(children: List.generate(
            5,
            (_) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('-', style: cellStyle)),
          ))
        else
          ...updates.map(
            (u) => pw.TableRow(children: [
              pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(u.employee ?? '-', style: cellStyle)),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(u.previousState, style: pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700)),
              ),
              pw.Container(
                color: PdfColor.fromHex('#DCFCE7'),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(u.newState, style: pw.TextStyle(fontSize: 7.5, color: PdfColor.fromHex('#14532D'))),
              ),
              pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(u.date ?? '-', style: cellStyle)),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(u.time ?? '-', style: pw.TextStyle(fontSize: 7.5, color: PdfColor.fromHex('#22C55E'), fontWeight: pw.FontWeight.bold)),
              ),
            ]),
          ),
      ],
    );
  }
}
