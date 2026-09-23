import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';

class BookingReceiptScreen extends StatelessWidget {
  final dynamic bookingItem;

  const BookingReceiptScreen({Key? key, required this.bookingItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo & Company Info
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/cabflow_logo.png',
                      height: 55,
                    ),
                    const SizedBox(height: 8),
                     Text('BOOKING RECEIPT', style: outFitRegular(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                     Text('EMAIL: COMPANYTEST.COM', style: outFitRegular(fontSize: 16)),
                     Text('MOBILE: 020820177 | TELEPHONE: 020820177', style: outFitRegular(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NAME: ${bookingItem?.name ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('EMAIL: ${bookingItem?.email ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('MOBILE: ${bookingItem?.mobile ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('TELEPHONE: ${bookingItem?.telephone ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Text('STATUS: ', style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(
                            ((bookingItem?.bookingStatus?.bookingStatus ?? 'COMPLETED').toString()).toUpperCase(),
                            style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
                          ),
                        ],
                      ),
                      Text(
                        'DATETIME: ${bookingItem?.pickupDate?.toString().split('T').first.split(' ').first ?? ''} ${bookingItem?.pickupTime ?? ''}',
                        style: outFitRegular(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // BOOKING DETAILS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  color: DynamicColors.gryClr.withOpacity(0.5)),
               
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('BOOKING', style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 20)),
                    const Spacer(),
                    Text('REFERENCE # ', style: outFitRegular(fontSize: 16, fontWeight: FontWeight.bold)),
                       Text('${(bookingItem?.referenceNumber ?? bookingItem?.id ?? '').toString()}',
                        style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    _buildRow(
                      'PICKUP DOOR #', ((bookingItem?.pickupDoorNumber ?? '').toString()).toUpperCase(),
                      'DROPOFF DOOR #', ((bookingItem?.dropoffDoorNumber ?? '').toString()).toUpperCase(),
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'PICKUP', (bookingItem?.pickup ?? '').toString(),
                      'DROPOFF', (bookingItem?.dropoff ?? '').toString(),
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'JOURNEY TYPE', ((bookingItem?.journeyType?.journeyType ?? 'O/W').toString()).toUpperCase(),
                      'ACCOUNT', (bookingItem?.account?.name ?? '').toString(),
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'VEHICLE TYPE', (bookingItem?.vehicleType?.name ?? '').toString(),
                      'DRIVER', (bookingItem?.driver?.username ?? '').toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // PAYMENT & CHARGES
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    color: DynamicColors.gryClr.withOpacity(0.5)),
                child: Text('PAYMENT & CHARGES', style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    _buildRow(
                      'PAYMENT TYPE', ((bookingItem?.paymentType?.name ?? 'CASH').toString()).toUpperCase(),
                      'MEET & GREET', '£ ${bookingItem?.meetAndGreet ?? '0'}',
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'PARKING', '£ ${bookingItem?.parkingCharges ?? '0'}',
                      'WAITING', '£ ${bookingItem?.waitingCharges ?? '0'}',
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'EXTRA DROP', '£ ${bookingItem?.extraDropCharges ?? '0'}',
                      'FARES', '£ ${bookingItem?.fares ?? '0'}',
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'CONGESTION', '£ ${bookingItem?.congestionCharges ?? '0'}',
                      '', '',
                    ),
                  ],
                ),
              ),

              // --- TOTAL CHARGES FOOTER ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                  color: DynamicColors.gryClr.withOpacity(0.5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOTAL CHARGES', style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('£ ${bookingItem?.totalCharges ?? bookingItem?.fare ?? '0.00'}',
                        style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label1, String val1, String label2, String val2) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(width: 140, child: Text(label1, style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 14))),
              const SizedBox(width: 12),
              Expanded(child: Text(val1, style: outFitRegular(fontSize: 14, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
        const SizedBox(width: 24),
        if (label2.isNotEmpty)
          Expanded(
            child: Row(
              children: [
                SizedBox(width: 140, child: Text(label2, style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 14))),
                const SizedBox(width: 12),
                Expanded(child: Text(val2, style: outFitRegular(fontSize: 14, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
      ],
    );
  }
}