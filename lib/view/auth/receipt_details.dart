import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';

import '../../component/networks/api.dart';
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
                    Image.asset(
                      'assets/cabflow_logo.png',
                      height: 55,
                    ),
                    const SizedBox(height: 8),
                     Text('BOOKING RECEIPT', style: outFitRegular(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                     Text('EMAIL: ${selectedSubsidiary !=null? selectedSubsidiary!.email : ''}', style: outFitRegular(fontSize: 12, color: Colors.grey)),
                     Text('MOBILE:  ${selectedSubsidiary !=null?selectedSubsidiary!.emergencyContactNumber : ''}| TELEPHONE: ${selectedSubsidiary !=null?selectedSubsidiary!.telephoneNumber : ''}', style: outFitRegular(fontSize: 12, color: Colors.grey)),
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
                      Text('NAME: ${widget.bookingItem!.name ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('EMAIL: ${widget.bookingItem!.email ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('MOBILE: ${widget.bookingItem!.mobile ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('TELEPHONE: ${widget.bookingItem!.telephone ?? ''}',
                          style: outFitRegular(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Text('STATUS: ', style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(
                            ((widget.bookingItem!.bookingStatus?.bookingStatus ?? 'COMPLETED').toString()).toUpperCase(),
                            style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green),
                          ),
                        ],
                      ),
                      Text(
                        'DATETIME: ${widget.bookingItem!.pickupDate ?? ''} ${widget.bookingItem!.pickupTime ?? ''}'.trim().isEmpty
                            ? 'DATETIME: ${widget.bookingItem!.createdAt ?? ''}'
                            : 'DATETIME: ${widget.bookingItem!.pickupDate ?? ''} ${widget.bookingItem!.pickupTime ?? ''}'.trim(),
                        style: outFitRegular(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // BOOKING DETAILS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: const Color(0xFFF3F4F6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('BOOKING', style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('REFERENCE # ${(widget.bookingItem?.referenceNumber ?? widget.bookingItem?.id ?? '').toString()}',
                        style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildRow(
                      'PICKUP DOOR #', (widget.bookingItem?.pickupDoorNumber ?? '').toString(),
                      'DROPOFF DOOR #', (widget.bookingItem?.dropoffDoorNumber ?? '').toString(),
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'PICKUP', (widget.bookingItem?.pickup ?? '').toString(),
                      'DROPOFF', (widget.bookingItem?.dropoff ?? '').toString(),
                    ),
                    const SizedBox(height: 8),
                    _buildRow(
                      'JOURNEY TYPE', (widget.bookingItem?.journeyType?.journeyType ?? 'O/W').toString(),
                      'ACCOUNT', (widget.bookingItem?.account?.name ?? '').toString(),
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
                color: const Color(0xFFF3F4F6),
                child: const Text('PAYMENT & CHARGES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildRow(
                      'PAYMENT TYPE', (widget.bookingItem?.paymentType?.name ?? 'CASH').toString(),
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
                color: const Color(0xFFF3F4F6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL CHARGES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('£ ${widget.bookingItem?.totalCharges ?? widget.bookingItem?.fares ?? '0.00'}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
              SizedBox(width: 120, child: Text(label1, style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 11))),
              Expanded(child: Text(val1, style: outFitRegular(fontSize: 12, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
        if (label2.isNotEmpty)
          Expanded(
            child: Row(
              children: [
                SizedBox(width: 120, child: Text(label2, style: outFitRegular(fontWeight: FontWeight.bold, fontSize: 11))),
                Expanded(child: Text(val2, style: outFitRegular(fontSize: 12, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
      ],
    );
  }
}