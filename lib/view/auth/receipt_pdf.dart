import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../component/networks/api.dart';
import '../administration/model/list_subsDiary.dart';
import '../dashboard_view/models/dashboard_table_model.dart';

Future<void> exportReceiptPdf({
  BookingObjectData? bookingItem,
  Subsidiaries? selectedSubsidiary,
}) async {
  if (bookingItem == null) return;

  // Fetch Subsidiary from API
  if (selectedSubsidiary == null && bookingItem.subsidiaryId != null) {
    try {
      var response = await Api().get('subsidiaries/get', sendCompanyId: true);
      if (response.statusCode == 200) {
        SubsDiaryModel subsDiaryModel = SubsDiaryModel.fromJson(response.data);
        int indexx = subsDiaryModel.subsidiaries?.indexWhere((test) => test.id == bookingItem.subsidiaryId) ?? -1;
        if (indexx != -1) {
          selectedSubsidiary = subsDiaryModel.subsidiaries![indexx];
        }
      }
    } catch (e) {
      print("Error fetching subsidiary: $e");
    }
  }

  pw.MemoryImage? logoImage;
  try {
    final imageBytes = await rootBundle.load('assets/cabflow_logo.png');
    logoImage = pw.MemoryImage(imageBytes.buffer.asUint8List());
  } catch (e) {
    print("Error loading asset logo image: $e");
  }

  // Date Formatting
  String formattedDate = "";
  if (bookingItem.pickupDate != null) {
    formattedDate = "${bookingItem.pickupDate!.year}-${bookingItem.pickupDate!.month.toString().padLeft(2, '0')}-${bookingItem.pickupDate!.day.toString().padLeft(2, '0')}";
  }
  String dateTimeStr = "$formattedDate ${bookingItem.pickupTime ?? ''}".trim();

  // Subsidiary Details
  String subEmail = selectedSubsidiary?.email ?? '';
  String subMobile = selectedSubsidiary?.emergencyContactNumber ?? '';
  String subTel = selectedSubsidiary?.telephoneNumber ?? '';
  String subName = selectedSubsidiary?.name ?? '';

  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(30),
      footer: (pw.Context context) {
        return pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.SizedBox(width: 20),
            pw.Text(subName, style: const pw.TextStyle(fontSize: 8)),
            pw.Text(
              '${context.pageNumber}/${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8),
            ),
          ],
        );
      },
      build: (pw.Context context) {
        return [
          // Logo
          pw.Center(
            child: logoImage != null
                ? pw.Image(logoImage, height: 50, fit: pw.BoxFit.contain)
                : pw.SizedBox(height: 50),
          ),
          pw.SizedBox(height: 10),

          // Header
          pw.Center(
            child: pw.Text('BOOKING RECEIPT',
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text('EMAIL: $subEmail', style: const pw.TextStyle(fontSize: 10)),
          ),
          pw.Center(
            child: pw.Text('MOBILE: $subMobile | TELEPHONE: $subTel',
                style: const pw.TextStyle(fontSize: 10)),
          ),
          pw.SizedBox(height: 20),

          // Customer & Status
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('NAME: ${bookingItem.name ?? ''}', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('EMAIL: ${bookingItem.email ?? ''}', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('MOBILE: ${bookingItem.mobile ?? ''}', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('TELEPHONE: ${bookingItem.telephone ?? ''}', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('REFERENCE #: ${(bookingItem.referenceNumber ?? '').toUpperCase()}',
                      style: pw.TextStyle(fontSize: 9)),
                  pw.Text('STATUS: ${(bookingItem.bookingStatus?.bookingStatus ?? '').toUpperCase()}',
                      style: pw.TextStyle(fontSize: 9)),
                  pw.Text('DATETIME: $dateTimeStr', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 15),

          // BOOKING Section
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: PdfColor.fromHex("#F7F7F9"),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('BOOKING', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.SizedBox(height: 6),

          // BOOKING Details
          _pdfRow('PICKUP DOOR #:', (bookingItem.pickupDoorNumber ?? '').toUpperCase(),
              'DROPOFF DOOR #:', (bookingItem.dropoffDoorNumber ?? '').toUpperCase()),
          _pdfRow('PICKUP:', bookingItem.pickup ?? '',
              'DROPOFF:', bookingItem.dropoff ?? ''),
          _pdfRow('JOURNEY TYPE:', (bookingItem.journeyType?.journeyType ?? '').toUpperCase(),
              'ACCOUNT:', (bookingItem.account?.name ?? '').toUpperCase()),
          _pdfRow('VEHICLE TYPE:', bookingItem.vehicleType?.name ?? '',
              'DRIVER:', bookingItem.driver?.username ?? ''),

          pw.SizedBox(height: 15),

          // PAYMENT & CHARGES Section
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: PdfColor.fromHex("#F7F7F9"),
            child: pw.Text('PAYMENT & CHARGES', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 6),

          // PAYMENT Details
          _pdfRow('PAYMENT TYPE:', (bookingItem.paymentType?.name ?? '').toUpperCase(),
              'MEET & GREET:', '£ ${bookingItem.meetAndGreet ?? '0'}'),
          _pdfRow('PARKING:', '£ ${bookingItem.parkingCharges ?? '0'}',
              'WAITING:', '£ ${bookingItem.waitingCharges ?? '0'}'),
          _pdfRow('EXTRA DROP:', '£ ${bookingItem.extraDropCharges ?? '0'}',
              'FARES:', '£ ${bookingItem.fares ?? '0'}'),
          _pdfRow('CONGESTION:', '£ ${bookingItem.congestionCharges ?? '0'}', '', ''),

          pw.SizedBox(height: 10),

          // TOTAL CHARGES Footer
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            color: PdfColor.fromHex("#F7F7F9"),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL CHARGES', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text('£ ${bookingItem.totalCharges ?? bookingItem.fares ?? '0.00'}',
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
        ];
      },
    ),
  );

  final bytes = await pdf.save();
  await Printing.sharePdf(
    bytes: bytes,
    filename: 'Booking_Receipt_${bookingItem.referenceNumber ?? bookingItem.id ?? 'receipt'}.pdf',
  );
}

// Simple Row Builder for PDF
pw.Widget _pdfRow(String label1, String val1, String label2, String val2) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text('$label1 $val1'.trim(), style: const pw.TextStyle(fontSize: 8)),
        ),
        if (label2.isNotEmpty)
          pw.Expanded(
            child: pw.Text('$label2 $val2'.trim(), style: const pw.TextStyle(fontSize: 8)),
          ),
      ],
    ),
  );
}