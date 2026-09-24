import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../component/networks/api.dart';
import '../administration/model/list_subsDiary.dart';
import '../dashboard_view/models/dashboard_table_model.dart';
import '../dashboard_view/models/jobs_details_model.dart';

Future<void> exportReceiptPdf({
  JobsDetailsJobs? bookingItem,
  Subsidiaries? selectedSubsidiary,
}) async {
  if (bookingItem == null || bookingItem.booking.isEmpty) return;

  final mainBooking = bookingItem.booking[0];
  final returnBooking = bookingItem.booking.length > 1 ? bookingItem.booking[1] : null;

  // Fetch Subsidiary from API
  if (selectedSubsidiary == null && mainBooking.subsidiaryId != null) {
    try {
      var response = await Api().get('subsidiaries/get', sendCompanyId: true);
      if (response.statusCode == 200) {
        SubsDiaryModel subsDiaryModel = SubsDiaryModel.fromJson(response.data);
        int indexx = subsDiaryModel.subsidiaries?.indexWhere((test) => test.id == mainBooking.subsidiaryId) ?? -1;
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
  if (mainBooking.pickupDate != null) {
    formattedDate = "${mainBooking.pickupDate!.year}-${mainBooking.pickupDate!.month.toString().padLeft(2, '0')}-${mainBooking.pickupDate!.day.toString().padLeft(2, '0')}";
  }
  String dateTimeStr = "$formattedDate ${mainBooking.pickupTime ?? ''}".trim();

  // Date Formatting for Return (if index 1 exists)
  String returnDateTimeStr = "";
  if (returnBooking != null && returnBooking.pickupDate != null) {
    String retDate = "${returnBooking.pickupDate!.year}-${returnBooking.pickupDate!.month.toString().padLeft(2, '0')}-${returnBooking.pickupDate!.day.toString().padLeft(2, '0')}";
    returnDateTimeStr = "$retDate ${returnBooking.pickupTime ?? ''}".trim();
  }

  String notesText = '';
  if (mainBooking.notes != null && mainBooking.notes!.isNotEmpty) {
    notesText = mainBooking.notes!
        .map((n) => n.note ?? '')
        .where((text) => text.trim().isNotEmpty)
        .join(', ')
        .toUpperCase();
  }

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
                  pw.Text('NAME: ${mainBooking.name ?? ''}', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('EMAIL: ${mainBooking.email ?? ''}', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('MOBILE: ${mainBooking.mobile ?? ''}', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('TELEPHONE: ${mainBooking.telephone ?? ''}', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('REFERENCE #: ${(mainBooking.referenceNumber ?? '').toUpperCase()}',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                  pw.Text('STATUS: ${(mainBooking.bookingStatus?.bookingStatus ?? '').toUpperCase()}',
                      style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('DATETIME: $dateTimeStr', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('RETURN DATETIME: $returnDateTimeStr', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 15),

          // BOOKING Section Header
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: PdfColor.fromHex("#F7F7F9"),
            child: pw.Row(
              children: [
                pw.Text('BOOKING', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.SizedBox(height: 6),

          // BOOKING Details Rows
          _pdfRow('PICKUP DOOR #:', (mainBooking.pickupDoorNumber ?? '').toUpperCase(),
              'DROPOFF DOOR #:', (mainBooking.dropoffDoorNumber ?? '').toUpperCase()),
          _pdfRow('PICKUP:', mainBooking.pickup ?? '',
              'DROPOFF:', mainBooking.dropoff ?? ''),
          _pdfRow('RETURN PICKUP:', returnBooking?.pickup ?? '',
              'RETURN DROPOFF:', returnBooking?.dropoff ?? ''),

          _pdfRow('JOURNEY TYPE:', (mainBooking.journeyType?.journeyType ?? '').toUpperCase(),
              'ACCOUNT:', (mainBooking.account?.name ?? '').toUpperCase()),
          _pdfRow('VEHICLE TYPE:', mainBooking.vehicleType?.name ?? '',
              'DRIVER:', mainBooking.driver?.username ?? ''),
          _pdfRow('', '', 'NOTES:', notesText),

          pw.SizedBox(height: 15),

          // PAYMENT & CHARGES Section
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: PdfColor.fromHex("#F7F7F9"),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('PAYMENT & CHARGES', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.SizedBox(height: 6),

          // PAYMENT Details
          _pdfRow('PAYMENT TYPE:', (mainBooking.paymentType?.name ?? '').toUpperCase(),
              'MEET & GREET:', '£ ${mainBooking.meetAndGreet ?? '0.00'}'),
          _pdfRow('PARKING:', '£ ${mainBooking.parkingCharges ?? '0.00'}',
              'WAITING:', '£ ${mainBooking.waitingCharges ?? '0.00'}'),
          _pdfRow('EXTRA DROP:', '£ ${mainBooking.extraDropCharges ?? '0.00'}',
              'FARES:', '£ ${mainBooking.fares ?? '0.00'}'),
          _pdfRow('CONGESTION:', '£ ${mainBooking.congestionCharges ?? '0.00'}',
              'RETURN FARES:', '£ ${returnBooking?.fares ?? '0.00'}'),

          pw.SizedBox(height: 10),

          // TOTAL CHARGES
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            color: PdfColor.fromHex("#F7F7F9"),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL CHARGES', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text('£ ${mainBooking.totalCharges ?? mainBooking.fares ?? '0.00'}',
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
    filename: 'Booking_Receipt_${mainBooking.referenceNumber ?? mainBooking.id ?? 'receipt'}.pdf',
  );
}

// Future<void> exportReceiptPdf({
//   JobsDetailsJobs? bookingItem,
//   Subsidiaries? selectedSubsidiary,
// }) async {
//   if (bookingItem == null) return;
//
//   // Fetch Subsidiary from API
//   if (selectedSubsidiary == null && bookingItem.booking[0].subsidiaryId != null) {
//     try {
//       var response = await Api().get('subsidiaries/get', sendCompanyId: true);
//       if (response.statusCode == 200) {
//         SubsDiaryModel subsDiaryModel = SubsDiaryModel.fromJson(response.data);
//         int indexx = subsDiaryModel.subsidiaries?.indexWhere((test) => test.id == bookingItem.booking[0].subsidiaryId) ?? -1;
//         if (indexx != -1) {
//           selectedSubsidiary = subsDiaryModel.subsidiaries![indexx];
//         }
//       }
//     } catch (e) {
//       print("Error fetching subsidiary: $e");
//     }
//   }
//
//   pw.MemoryImage? logoImage;
//   try {
//     final imageBytes = await rootBundle.load('assets/cabflow_logo.png');
//     logoImage = pw.MemoryImage(imageBytes.buffer.asUint8List());
//   } catch (e) {
//     print("Error loading asset logo image: $e");
//   }
//
//   // Date Formatting
//   String formattedDate = "";
//   if (bookingItem.booking[0].pickupDate != null) {
//     formattedDate = "${bookingItem.booking[0].pickupDate!.year}-${bookingItem.booking[0].pickupDate!.month.toString().padLeft(2, '0')}-${bookingItem.booking[0].pickupDate!.day.toString().padLeft(2, '0')}";
//   }
//   String dateTimeStr = "$formattedDate ${bookingItem.booking[0].pickupTime ?? ''}".trim();
//
//   // Subsidiary Details
//   String subEmail = selectedSubsidiary?.email ?? '';
//   String subMobile = selectedSubsidiary?.emergencyContactNumber ?? '';
//   String subTel = selectedSubsidiary?.telephoneNumber ?? '';
//   String subName = selectedSubsidiary?.name ?? '';
//
//   final pdf = pw.Document();
//
//   pdf.addPage(
//     pw.MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       margin: const pw.EdgeInsets.all(30),
//       footer: (pw.Context context) {
//         return pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.SizedBox(width: 20),
//             pw.Text(subName, style: const pw.TextStyle(fontSize: 8)),
//             pw.Text(
//               '${context.pageNumber}/${context.pagesCount}',
//               style: const pw.TextStyle(fontSize: 8),
//             ),
//           ],
//         );
//       },
//       build: (pw.Context context) {
//         return [
//           // Logo
//           pw.Center(
//             child: logoImage != null
//                 ? pw.Image(logoImage, height: 50, fit: pw.BoxFit.contain)
//                 : pw.SizedBox(height: 50),
//           ),
//           pw.SizedBox(height: 10),
//
//           // Header
//           pw.Center(
//             child: pw.Text('BOOKING RECEIPT',
//                 style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
//           ),
//           pw.SizedBox(height: 4),
//           pw.Center(
//             child: pw.Text('EMAIL: $subEmail', style: const pw.TextStyle(fontSize: 10)),
//           ),
//           pw.Center(
//             child: pw.Text('MOBILE: $subMobile | TELEPHONE: $subTel',
//                 style: const pw.TextStyle(fontSize: 10)),
//           ),
//           pw.SizedBox(height: 20),
//
//           // Customer & Status
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text('NAME: ${bookingItem.booking[0].name ?? ''}', style: const pw.TextStyle(fontSize: 9)),
//                   pw.Text('EMAIL: ${bookingItem.booking[0].email ?? ''}', style: const pw.TextStyle(fontSize: 9)),
//                   pw.Text('MOBILE: ${bookingItem.booking[0].mobile ?? ''}', style: const pw.TextStyle(fontSize: 9)),
//                   pw.Text('TELEPHONE: ${bookingItem.booking[0].telephone ?? ''}', style: const pw.TextStyle(fontSize: 9)),
//                 ],
//               ),
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.end,
//                 children: [
//                   pw.Text('REFERENCE #: ${(bookingItem.booking[0].referenceNumber ?? '').toUpperCase()}',
//                       style: pw.TextStyle(fontSize: 9)),
//                   pw.Text('STATUS: ${(bookingItem.booking[0].bookingStatus?.bookingStatus ?? '').toUpperCase()}',
//                       style: pw.TextStyle(fontSize: 9)),
//                   pw.Text('DATETIME: $dateTimeStr', style: const pw.TextStyle(fontSize: 9)),
//                 ],
//               ),
//             ],
//           ),
//           pw.SizedBox(height: 15),
//
//           // BOOKING Section
//           pw.Container(
//             padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             color: PdfColor.fromHex("#F7F7F9"),
//             child: pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text('BOOKING', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//               ],
//             ),
//           ),
//           pw.SizedBox(height: 6),
//
//           // BOOKING Details
//           _pdfRow('PICKUP DOOR #:', (bookingItem.booking[0].pickupDoorNumber ?? '').toUpperCase(),
//               'DROPOFF DOOR #:', (bookingItem.booking[0].dropoffDoorNumber ?? '').toUpperCase()),
//           _pdfRow('PICKUP:', bookingItem.booking[0].pickup ?? '',
//               'DROPOFF:', bookingItem.booking[0].dropoff ?? ''),
//           _pdfRow('JOURNEY TYPE:', (bookingItem.booking[0].journeyType?.journeyType ?? '').toUpperCase(),
//               'ACCOUNT:', (bookingItem.booking[0].account?.name ?? '').toUpperCase()),
//           _pdfRow('VEHICLE TYPE:', bookingItem.booking[0].vehicleType?.name ?? '',
//               'DRIVER:', bookingItem.booking[0].driver?.username ?? ''),
//
//           pw.SizedBox(height: 15),
//
//           // PAYMENT & CHARGES Section
//           pw.Container(
//             padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             color: PdfColor.fromHex("#F7F7F9"),
//             child: pw.Text('PAYMENT & CHARGES', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           ),
//           pw.SizedBox(height: 6),
//
//           // PAYMENT Details
//           _pdfRow('PAYMENT TYPE:', (bookingItem.booking[0].paymentType?.name ?? '').toUpperCase(),
//               'MEET & GREET:', '£ ${bookingItem.booking[0].meetAndGreet ?? '0'}'),
//           _pdfRow('PARKING:', '£ ${bookingItem.booking[0].parkingCharges ?? '0'}',
//               'WAITING:', '£ ${bookingItem.booking[0].waitingCharges ?? '0'}'),
//           _pdfRow('EXTRA DROP:', '£ ${bookingItem.booking[0].extraDropCharges ?? '0'}',
//               'FARES:', '£ ${bookingItem.booking[0].fares ?? '0'}'),
//           _pdfRow('CONGESTION:', '£ ${bookingItem.booking[0].congestionCharges ?? '0'}', '', ''),
//
//           pw.SizedBox(height: 10),
//
//           // TOTAL CHARGES Footer
//           pw.Container(
//             padding: const pw.EdgeInsets.all(8),
//             color: PdfColor.fromHex("#F7F7F9"),
//             child: pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text('TOTAL CHARGES', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
//                 pw.Text('£ ${bookingItem.booking[0].totalCharges ?? bookingItem.booking[0].fares ?? '0.00'}',
//                     style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
//               ],
//             ),
//           ),
//         ];
//       },
//     ),
//   );
//
//   final bytes = await pdf.save();
//   await Printing.sharePdf(
//     bytes: bytes,
//     filename: 'Booking_Receipt_${bookingItem.booking[0].referenceNumber ?? bookingItem.booking[0].id ?? 'receipt'}.pdf',
//   );
// }

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