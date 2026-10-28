import 'package:dashboard_new1/view/drivers_view/controller/driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../component/color.dart';
import '../../../../component/textStyle.dart';
import '../../model/update_driver_rent_model.dart' show DriverRent;
import '../../model/create_driver_rent_model.dart';


class DriverRentWindowWrapper extends StatefulWidget {
  @override
  _DriverRentWindowWrapperState createState() =>
      _DriverRentWindowWrapperState();
}

class _DriverRentWindowWrapperState extends State<DriverRentWindowWrapper> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          // Size toggle logic
          width: isFullScreen
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width * 0.8,
          height: isFullScreen
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                isFullScreen ? BorderRadius.zero : BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                color: DynamicColors.primaryClr,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                              isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.crop_square,
                              color: Colors.white,
                              size: 20),
                          onPressed: () =>
                              setState(() => isFullScreen = !isFullScreen),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(child: DriverRentViewScreen()),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverRentViewScreen extends StatelessWidget {
  final DriverRent? rent;
  const DriverRentViewScreen({super.key, this.rent});

  @override
  Widget build(BuildContext context) {
    final controller =  Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : null;

    final data = rent ?? controller?.updateDriverRentByIdModel?.driverRent;
    final items = data?.driverRentLineitems ?? [];

    final currentDriverId = data?.driver?.id;

    final storage = GetStorage();

    String mobileNumber = storage.read<String>('temp_driver_rent_mobile') ??
        storage.read<String>('temp_driver_mobile') ??
        "";
    String telephoneNumber = storage.read<String>('temp_driver_rent_telephone') ??
        storage.read<String>('temp_driver_telephone') ??
        "";

    if (controller != null && controller.driverRentModel?.drivers != null) {
      try {
        final selectedDriverData = controller.driverRentModel!.drivers!.firstWhere(
              (d) => d.id == currentDriverId,
        );
        if (mobileNumber.isEmpty && (selectedDriverData.mobile ?? "").isNotEmpty) {
          mobileNumber = selectedDriverData.mobile!;
        }
        if (telephoneNumber.isEmpty && (selectedDriverData.telephone ?? "").isNotEmpty) {
          telephoneNumber = selectedDriverData.telephone!;
        }
      } catch (_) {}
    }

    final fromDate = data?.fromDate != null
        ? data!.fromDate.toString().split(' ').first
        : (controller?.updateRentFilterFromDate ?? '');

    final toDate = data?.toDate != null
        ? data!.toDate.toString().split(' ').first
        : (controller?.updateRentFilterToDate ?? '');

    final transactionDate = data?.transactionDate != null
        ? data!.transactionDate.toString().split('T').first.split(' ').first
        : (controller?.rentTransactionDateController.toString().split("T").first.split(" ").first ?? '');

    double calculatedParkingCongestion = 0.0;
    for (var item in items) {
      final b = item.booking;
      if (b != null) {
        final pc = double.tryParse(b.parkingCharges ?? '0') ?? 0.0;
        final cc = double.tryParse(b.congestionCharges ?? '0') ?? 0.0;
        calculatedParkingCongestion += (pc + cc);
      }
    }

    const tableBorder = TableBorder(
      verticalInside: BorderSide(color: Colors.black, width: 0.5),
      horizontalInside: BorderSide(color: Colors.black, width: 0.5),
      top: BorderSide(color: Colors.black, width: 0.5),
      left: BorderSide(color: Colors.black, width: 0.5),
      right: BorderSide(color: Colors.black, width: 0.5),
      bottom: BorderSide(color: Colors.black, width: 0.5),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Center(
              child: Text("DRIVER RENT",
                  style: mozillaTextSemiBoldText(
                      fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildUIInfoColumn("", [
                  "PERIOD: ($fromDate - $toDate)",
                ]),
                const Spacer(flex: 1),
                Expanded(
                  flex: 5,
                  child: _buildUIInfoColumn("", [
                    "EMAIL: ${(data?.driver?.email ?? "").toUpperCase()}",
                    "MOBILE: $mobileNumber",
                    "TELEPHONE: $telephoneNumber",
                  ]),
                ),
                Expanded(
                  flex: 3,
                  child: _buildUIInfoColumn(
                    "",
                    [
                      "DRIVER: (${data?.driver?.username ?? ""})",
                      "${(data?.driver?.name ?? "").toUpperCase()}",
                      "RENT: ${data?.driver?.driverCommission ?? ""}",
                      "DATE: $transactionDate",
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Table(
              border: tableBorder,
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
                13: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: DynamicColors.primaryClr),
                  children: [
                    _buildTableCell("REF#", isHeader: true),
                    _buildTableCell("D/T", isHeader: true),
                    _buildTableCell("PICKUP", isHeader: true),
                    _buildTableCell("DROPOFF", isHeader: true),
                    _buildTableCell("VEH", isHeader: true),
                    _buildTableCell("ACC", isHeader: true),
                    _buildTableCell("J/T", isHeader: true),
                    _buildTableCell("P/T", isHeader: true),
                    _buildTableCell("FARE", isHeader: true),
                    _buildTableCell("PC", isHeader: true),
                    _buildTableCell("WC", isHeader: true),
                    _buildTableCell("EDC", isHeader: true),
                    _buildTableCell("CC", isHeader: true),
                    _buildTableCell("TOTAL", isHeader: true),
                  ],
                ),
                ...items.map((item) {
                  final b = item.booking;
                  return TableRow(
                    children: [
                      _buildTableCell(b?.referenceNumber ?? "",
                          hasEllipsis: true),
                      _buildTableCell(
                          "${b?.pickupDate ?? ''}\n${b?.pickupTime ?? ''}"),
                      _buildTableCell((b?.pickup ?? "").toUpperCase(),
                          hasEllipsis: true),
                      _buildTableCell((b?.dropoff ?? "").toUpperCase(),
                          hasEllipsis: true),
                      _buildTableCell(
                          (b?.vehicleType?.name ?? "").toUpperCase(),
                          hasEllipsis: true),
                      _buildTableCell((b?.account?.name ?? "").toUpperCase(),
                          hasEllipsis: true),
                      _buildTableCell(
                          (b?.journeyType?.journeyType ?? "").toUpperCase(),
                          hasEllipsis: true),
                      _buildTableCell(
                          (b?.paymentType?.name ?? "").toUpperCase(),
                          hasEllipsis: true),
                      _buildTableCell("£${b?.fares ?? '0'}"),
                      _buildTableCell("£${b?.parkingCharges ?? '0'}"),
                      _buildTableCell("£${b?.waitingCharges ?? '0'}"),
                      _buildTableCell("£${b?.extraDropCharges ?? '0'}"),
                      _buildTableCell("£${b?.congestionCharges ?? '0'}"),
                      _buildTableCell("£${b?.totalCharges ?? '0'}", isBold: true),
                    ],
                  );
                }).toList(),
              ],
            ),

            // FOOTER
            Table(
              border: null,
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FixedColumnWidth(98), // Matching TOTAL column
              },
              children: [
                _buildFooterRow(context, "CASH TOTAL:", double.tryParse(data?.cashJobsTotal ?? '0') ?? controller?.updateCashTotal ?? 0.0),
                _buildFooterRow(context, "TOTAL:", double.tryParse(data?.jobsTotal ?? '0') ?? controller?.updateGrandTotal ?? 0.0),
                _buildFooterRow(context, "ACCOUNT TOTAL:", double.tryParse(data?.accountJobsTotal ?? '0') ?? controller?.updateAccountTotal ?? 0.0),
                _buildFooterRow(context, "PARKING/CONGESTION TOTAL:", controller?.updateParkingCongestion ?? calculatedParkingCongestion),
                _buildFooterRow(context, "RENT TOTAL:", double.tryParse(data?.rentTotal ?? '0') ?? controller?.rTotal ?? 0.0),
                _buildFooterRow(context, "OWED:", double.tryParse(data?.owed ?? '0') ?? controller?.updateOwed ?? 0.0),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text,
      {bool isHeader = false, bool isBold = false, bool hasEllipsis = false}) {
    return Builder(builder: (context) {
      bool isLaptop = MediaQuery.of(context).size.width <= 1400;

      double finalFontSize =
      isHeader ? (isLaptop ? 11.0 : 14.0) : (isLaptop ? 10.0 : 12.0);
      double vPadding = isLaptop ? 4.0 : 8.0;
      double hPadding = isLaptop ? 2.0 : 4.0;

      return Padding(
        padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: isHeader ? 2 : (hasEllipsis ? 1 : 3),
          overflow: hasEllipsis ? TextOverflow.ellipsis : TextOverflow.clip,
          style: TextStyle(
              fontSize: finalFontSize,
              fontWeight:
              (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black),
        ),
      );
    });
  }


  TableRow _buildFooterRow(BuildContext context, String label, double value,
      {bool isBold = false, bool isRed = false}) {
    bool isLaptop = MediaQuery.of(context).size.width <= 1400;
    double finalFontSize = isLaptop ? 11.0 : 14.0;
    double vPadding = isLaptop ? 4.0 : 6.0;

    return TableRow(
      children: [
        Container(
            alignment: Alignment.centerRight,
            padding:
            EdgeInsets.only(right: 15, top: vPadding, bottom: vPadding),
            child: SizedBox(
                width: isLaptop ? 220 : 260,
                child: Text(label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: finalFontSize,
                        fontWeight:
                        isBold ? FontWeight.bold : FontWeight.w500)))),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: vPadding),
            child: Text("£${value.toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: finalFontSize,
                    fontWeight: FontWeight.bold,
                    color: isRed ? Colors.red : Colors.black))),
      ],
    );
  }

  Widget _buildUIInfoColumn(String title, List<String> lines,
      {bool alignEnd = false}) {
    return Builder(builder: (context) {
      bool isLaptop = MediaQuery.of(context).size.width <= 1400;

      double titleFontSize = isLaptop ? 12.0 : 16.0;
      double contentFontSize = isLaptop ? 12.0 : 16.0;
      double plainTextFontSize = isLaptop ? 12.0 : 18.0;
      double bottomPadding = isLaptop ? 2.0 : 4.0;
      return Column(
        crossAxisAlignment:
        alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                    color: DynamicColors.primaryClr)),
          const SizedBox(height: 5),
          ...lines.map((line) {
            if (line.isEmpty) return SizedBox(height: isLaptop ? 6 : 10);
            if (line.contains(":")) {
              final parts = line.split(":");
              return Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "${parts[0]}: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentFontSize,
                              color: Colors.black)),
                      TextSpan(
                          text: parts.sublist(1).join(":"),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: contentFontSize,
                              color: Colors.black87)),
                    ]),
                    textAlign: alignEnd ? TextAlign.right : TextAlign.left),
              );
            }
            return Text(line,
                style: TextStyle(
                    fontSize: plainTextFontSize, fontWeight: FontWeight.w500));
          }),
        ],
      );
    });
  }
}
