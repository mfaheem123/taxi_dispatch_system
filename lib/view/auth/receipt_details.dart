import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../component/networks/api.dart';
import '../../utils/new_window_booking.dart';
import '../administration/model/list_subsDiary.dart';
import '../dashboard_view/models/dashboard_table_model.dart';

class BookingReceiptScreen extends StatefulWidget {
  BookingObjectData? bookingItem;

  BookingReceiptScreen({Key? key, this.bookingItem}) : super(key: key);

  @override
  State<BookingReceiptScreen> createState() => _BookingReceiptScreenState();
}

class _BookingReceiptScreenState extends State<BookingReceiptScreen> {

  SubsDiaryModel? subsDiaryModel;
  Subsidiaries? selectedSubsidiary;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Opened from a booking in another window: the booking travelled through
    // storage rather than the constructor (a popped window boots as a fresh
    // instance), so it is picked up here before the first build.
    if (widget.bookingItem == null) {
      final handedOver = takeHandedOverBooking();
      if (handedOver != null) {
        widget.bookingItem = handedOver;
      }
    }

    if(widget.bookingItem?.subsidiaryId != null){
      getSubsidiary();
    }
  }

  getSubsidiary() async {
      var response = await Api().get('subsidiaries/get', sendCompanyId: true);
      if (response.statusCode == 200) {
        subsDiaryModel = SubsDiaryModel.fromJson(response.data);
        int indexx = subsDiaryModel!.subsidiaries!.indexWhere((test) => test.id == widget.bookingItem?.subsidiaryId);
        if (indexx != -1) {
          selectedSubsidiary = subsDiaryModel!.subsidiaries![indexx];
          setState(() {});
        }
      }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.bookingItem?.subsidiaryId != null && selectedSubsidiary == null?Center(child: CircularProgressIndicator(),): SafeArea(
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
                     Text('EMAIL: ${selectedSubsidiary !=null? selectedSubsidiary!.email : ''}', style: outFitRegular(fontSize: 14)),
                     Text('MOBILE:  ${selectedSubsidiary !=null?selectedSubsidiary!.emergencyContactNumber : ''}| TELEPHONE: ${selectedSubsidiary !=null?selectedSubsidiary!.telephoneNumber : ''}', style: outFitRegular(fontSize: 14)),

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
                      Text('NAME: ${widget.bookingItem?.name ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('EMAIL: ${widget.bookingItem?.email ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('MOBILE: ${widget.bookingItem?.mobile ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('TELEPHONE: ${widget.bookingItem?.telephone ?? ''}',
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
                            ((widget.bookingItem?.bookingStatus?.bookingStatus ?? '').toString()).toUpperCase(),
                            style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),

                          ),
                        ],
                      ),
                      Text(
                        'DATETIME: ${_formatDate(widget.bookingItem?.pickupDate)} ${widget.bookingItem?.pickupTime ?? ''}'.trim(),
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
                    Text('BOOKING', style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    Text('REFERENCE # ', style: outFitRegular(fontSize: 14, fontWeight: FontWeight.bold),),
                        Text ('${(widget.bookingItem?.referenceNumber ?? widget.bookingItem?.id ?? '').toString()}',
                        style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red)),
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
                      'PICKUP DOOR #', ((widget.bookingItem?.pickupDoorNumber ?? '').toString()).toUpperCase(),
                      'DROPOFF DOOR #', ((widget.bookingItem?.dropoffDoorNumber ?? '').toString()).toUpperCase(),

                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'PICKUP', (widget.bookingItem?.pickup ?? '').toString(),
                      'DROPOFF', (widget.bookingItem?.dropoff ?? '').toString(),
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'JOURNEY TYPE', ((widget.bookingItem?.journeyType?.journeyType ?? 'O/W').toString()).toUpperCase(),
                      'ACCOUNT', ((widget.bookingItem?.account?.name ?? '').toString()).toUpperCase(),

                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'VEHICLE TYPE', (widget.bookingItem?.vehicleType?.name ?? '').toString(),
                      'DRIVER', (widget.bookingItem?.driver?.username ?? '').toString(),
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
                      'PAYMENT TYPE', ((widget.bookingItem?.paymentType?.name ?? 'CASH').toString()).toUpperCase(),
                      'MEET & GREET', '£ ${widget.bookingItem?.meetAndGreet ?? '0'}',

                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'PARKING', '£ ${widget.bookingItem?.parkingCharges ?? '0'}',
                      'WAITING', '£ ${widget.bookingItem?.waitingCharges ?? '0'}',
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'EXTRA DROP', '£ ${widget.bookingItem?.extraDropCharges ?? '0'}',
                      'FARES', '£ ${widget.bookingItem?.fares ?? '0'}',
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'CONGESTION', '£ ${widget.bookingItem?.congestionCharges ?? '0'}',
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
                    Text('TOTAL CHARGES', style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('£ ${widget.bookingItem?.totalCharges ?? widget.bookingItem?.fares ?? '0.00'}',
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

  String _formatDate(DateTime? rawDate) {
    if (rawDate == null) return '';
    return "${rawDate.year}-${rawDate.month.toString().padLeft(2, '0')}-${rawDate.day.toString().padLeft(2, '0')}";
  }
}