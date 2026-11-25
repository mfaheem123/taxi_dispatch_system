import 'package:collection/collection.dart';
import 'package:dashboard_new1/view/drivers_view/controller/driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../component/color.dart';
import '../../../../component/networks/api.dart';
import '../../../../component/textStyle.dart';
import '../../../administration/model/list_subsDiary.dart';
import '../../model/update_driver_commission_model.dart' show UpdateDriverCommission;

class DriverCommissionViewScreen extends StatefulWidget {
  final UpdateDriverCommission? commission;
  final Subsidiaries? subsidiary;
  const DriverCommissionViewScreen({super.key, this.commission, this.subsidiary});

  @override
  State<DriverCommissionViewScreen> createState() => _DriverCommissionViewScreenState();
}

class _DriverCommissionViewScreenState extends State<DriverCommissionViewScreen> {
  Subsidiaries? _subsidiary;

  @override
  void initState() {
    super.initState();
    _subsidiary = widget.subsidiary;
    _fetchSubsidiary();
  }

  @override
  void didUpdateWidget(covariant DriverCommissionViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subsidiary != null && widget.subsidiary != _subsidiary) {
      setState(() {
        _subsidiary = widget.subsidiary;
      });
    }
  }

  Future<void> _fetchSubsidiary() async {
    if (_subsidiary != null) return;

    final controller = Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : null;

    final data = widget.commission ?? controller?.updateDriverCommissionByIdModel?.driverCommission;
    final subId = data?.driver?.subsidiaryId;

    if (controller != null) {
      if (controller.subsDiaryModel?.subsidiaries != null &&
          controller.subsDiaryModel!.subsidiaries!.isNotEmpty) {
        Subsidiaries? matched;
        if (subId != null) {
          matched = controller.subsDiaryModel!.subsidiaries!
              .firstWhereOrNull((s) => s.id == subId);
        }
        matched ??= controller.selectedSubsidiary ??
            controller.subsDiaryModel!.subsidiaries!.first;

        if (mounted) {
          setState(() {
            _subsidiary = matched;
          });
        }
        return;
      }
    }

    try {
      final response = await Api().get('subsidiaries/get', sendCompanyId: true);
      if (response.statusCode == 200) {
        final model = SubsDiaryModel.fromJson(response.data);
        if (model.subsidiaries != null && model.subsidiaries!.isNotEmpty) {
          Subsidiaries? matched;
          if (subId != null) {
            matched = model.subsidiaries!.firstWhereOrNull((s) => s.id == subId);
          }
          matched ??= model.subsidiaries!.first;

          if (mounted) {
            setState(() {
              _subsidiary = matched;
            });
          }

          if (controller != null) {
            controller.subsDiaryModel = model;
          }
        }
      }
    } catch (e) {
      print("Error fetching subsidiary in DriverCommissionViewScreen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DriverController>()
        ? Get.find<DriverController>()
        : null;
    final data = widget.commission ?? controller?.updateDriverCommissionByIdModel?.driverCommission;
    final items = data?.driverCommissionLineitems ?? [];

    final subsidiaryData = _subsidiary ??
        (controller != null ? (controller.selectedSubsidiary ??
                (data?.driver?.subsidiaryId != null
                    ? controller.subsDiaryModel?.subsidiaries?.firstWhereOrNull((s) => s.id == data!.driver!.subsidiaryId)
                    : null) ??
                controller.subsDiaryModel?.subsidiaries?.firstOrNull)
            : null);

    final currentDriverId = data?.driver?.id;
    final storage = GetStorage();

    String mobileNumber = storage.read<String>('temp_driver_commission_mobile') ??
        storage.read<String>('temp_driver_mobile') ??
        "";
    String telephoneNumber = storage.read<String>('temp_driver_commission_telephone') ??
        storage.read<String>('temp_driver_telephone') ??
        "";

    if (controller != null && controller.listDriverCommission?.drivers != null) {
      try {
        final selectedDriverData = controller.listDriverCommission!.drivers!.firstWhere(
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

    final fromDate = data?.fromDate != null ? data!.fromDate.toString().split(' ').first : (controller?.updateFilterFromDate ?? '');
    final toDate = data?.toDate != null ? data!.toDate.toString().split(' ').first : (controller?.updateFilterToDate ?? '');
    final transactionDate = data?.transactionDate != null ? data!.transactionDate.toString().split(' ').first : (controller?.updateTransactionDateController ?? '');

    double pDouble(dynamic val) => double.tryParse(val?.toString() ?? '0') ?? 0.0;

    double getWithoutComm(dynamic b) {
      if (controller != null) {
        return pDouble(controller.calculateWithoutCommission(b));
      }
      return pDouble(b?.fares) + pDouble(b?.waitingCharges) + pDouble(b?.extraDropCharges);
    }

    double getFinalDriverComm(dynamic b) {
      if (controller != null) {
        return pDouble(controller.calculateFinalDriverComm(b));
      }
      final commRate = pDouble(data?.driver?.driverCommission) / 100;
      return getWithoutComm(b) * commRate;
    }

    final activeBookings = items.map((e) => e.booking).where((b) => b != null).toList();

    // 1. Cash Total
    final double cashTotal = activeBookings.fold(0.0, (sum, b) {
      bool isCash = b?.paymentType?.name?.toString().trim().toLowerCase() == "cash";
      if (isCash && b?.commission == true) {
        return sum + getWithoutComm(b);
      }
      return sum;
    });

    // 2. Account W/Comm Total
    final double accountFareTotal = activeBookings.fold(0.0, (sum, b) {
      bool isAccount = b?.paymentType?.name?.toString().trim().toLowerCase() == "account";
      if (isAccount && b?.commission == true) {
        return sum + pDouble(b?.fares);
      }
      return sum;
    });

    // 3. Parking & Congestion Charges
    final double parkingCongestionTotal = activeBookings.fold(0.0, (sum, b) {
      bool isAccount = b?.paymentType?.name?.toString().trim().toLowerCase() == "account";
      if (isAccount) {
        return sum + pDouble(b?.parkingCharges) + pDouble(b?.congestionCharges);
      }
      return sum;
    });

    // 4. Commission Total
    final double commissionTotal = activeBookings.fold(0.0, (sum, b) {
      return sum + getFinalDriverComm(b);
    });

    // 5. Account WO/Comm Total
    final double accountWOCmmTotal = activeBookings.fold(0.0, (sum, b) {
      bool isAccount = b?.paymentType?.name?.toString().trim().toLowerCase() == "account";
      if (isAccount && b?.commission == false) {
        return sum + getWithoutComm(b);
      }
      return sum;
    });

    // 6. Grand Total & Owed
    final double grandTotal = cashTotal + accountFareTotal;
    final double owedTotal = commissionTotal - accountFareTotal - parkingCongestionTotal;
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
              child: Text("DRIVER COMMISSION",
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
                    "EMAIL: ${(subsidiaryData?.email ?? "").toUpperCase()}",
                    "MOBILE: ${subsidiaryData?.emergencyContactNumber ?? ""}",
                    "TELEPHONE: ${subsidiaryData?.telephoneNumber ?? ""}",
                  ]),
                ),
                Expanded(
                  flex: 3,
                  child: _buildUIInfoColumn(
                    "",
                    [
                      "DRIVER: (${data?.driver?.username ?? ""})",
                      "${(data?.driver?.name ?? "").toUpperCase()}",
                      "COMMISSION: ${data?.driver?.driverCommission ?? ""}%",
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
                    _buildTableCell("W/COMM", isHeader: true),
                    _buildTableCell("COMM", isHeader: true),
                    _buildTableCell("TOTAL", isHeader: true),
                  ],
                ),
                ...items.map((item) {
                  final b = item.booking;
                  String cleanDate =
                      (b?.pickupDate ?? "").toString().split(' ')[0];
                  String cleanTime =
                      (b?.pickupTime ?? "").toString().split('.')[0];
                  if (cleanTime.contains(":")) {
                    var parts = cleanTime.split(":");
                    cleanTime = "${parts[0]}:${parts[1]}";
                  }
                  String formattedDateTime = "$cleanDate $cleanTime".trim();
                  return TableRow(
                    children: [
                      _buildTableCell(b?.referenceNumber ?? "", hasEllipsis: true),
                      _buildTableCell(formattedDateTime.isEmpty ? "-" : formattedDateTime),
                      _buildTableCell((b?.pickup ?? "").toUpperCase(), hasEllipsis: true),
                      _buildTableCell((b?.dropoff ?? "").toUpperCase(), hasEllipsis: true),
                      _buildTableCell((b?.vehicleType?.name ?? "").toUpperCase(), hasEllipsis: true),
                      _buildTableCell((b?.account?.name ?? "").toUpperCase(), hasEllipsis: true),
                      _buildTableCell((b?.journeyType?.journeyType ?? "").toUpperCase(), hasEllipsis: true),
                      _buildTableCell((b?.paymentType?.name ?? "").toUpperCase(), hasEllipsis: true),
                      _buildTableCell("£${b?.fares ?? '0'}"),
                      _buildTableCell("£${b?.parkingCharges ?? '0'}"),
                      _buildTableCell("£${b?.waitingCharges ?? '0'}"),
                      _buildTableCell("£${b?.extraDropCharges ?? '0'}"),
                      _buildTableCell("£${b?.congestionCharges ?? '0'}"),
                      _buildTableCell(
                          controller != null
                              ? "£${controller.calculateWithoutCommission(b)}"
                              : "£${(double.tryParse(b?.fares ?? '0') ?? 0) + (double.tryParse(b?.waitingCharges ?? '0') ?? 0) + (double.tryParse(b?.extraDropCharges ?? '0') ?? 0)}"
                      ),
                      _buildTableCell(
                          controller != null
                              ? "£${controller.calculateFinalDriverComm(b)}"
                              : "£${(
                              (controller != null ? (double.tryParse(controller.calculateWithoutCommission(b).toString()) ?? 0.0) : ((double.tryParse(b?.fares ?? '0') ?? 0) + (double.tryParse(b?.waitingCharges ?? '0') ?? 0) + (double.tryParse(b?.extraDropCharges ?? '0') ?? 0)))
                                  * ((double.tryParse(data?.driver?.driverCommission?.toString() ?? '0') ?? 0) / 100)
                          ).toStringAsFixed(2)}"
                      ),
                      _buildTableCell(
                          controller != null
                              ? "£${controller.calculateBookingTotalCharges(b)}"
                              : "£${(double.tryParse(b?.fares ?? '0') ?? 0) + (double.tryParse(b?.parkingCharges ?? '0') ?? 0) + (double.tryParse(b?.waitingCharges ?? '0') ?? 0) +
                              (double.tryParse(b?.extraDropCharges ?? '0') ?? 0) + (double.tryParse(b?.congestionCharges ?? '0') ?? 0)}", isBold: true
                      ),
                      // _buildTableCell("£${b?.totalCharges ?? '0'}", isBold: true),
                    ],
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 8),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildFooterRowPlain("CASH TOTAL", cashTotal),
                      _buildFooterRowPlain("COMMISSION TOTAL", commissionTotal),
                      _buildFooterRowPlain("OWED", owedTotal),
                      _buildFooterRowPlain("TOTAL", grandTotal, isBold: true),
                    ],
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildFooterRowPlain("ACCOUNT W/COMM TOTAL", accountFareTotal),
                      _buildFooterRowPlain("ACCOUNT WO/COMM TOTAL", accountWOCmmTotal),
                      _buildFooterRowPlain("PARKING & CONGESTION CHARGES", parkingCongestionTotal),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Helper for footer row
  Widget _buildFooterRowPlain(String label, double value,
      {bool isBold = false}) {
    return Builder(builder: (context) {
      bool isLaptop = MediaQuery.of(context).size.width <= 1366;

      double labelFontSize =
          isBold ? (isLaptop ? 12.0 : 15.0) : (isLaptop ? 11.0 : 14.0);
      double valueFontSize = isLaptop ? 11.0 : 14.0;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: labelFontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.w600)),
            ),
            const SizedBox(width: 4),
            Text("£${value.toStringAsFixed(2)}",
                style: TextStyle(fontSize: valueFontSize, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    });
  }

  Widget _buildTableCell(String text,
      {bool isHeader = false, bool isBold = false, bool hasEllipsis = false}) {
    return Builder(builder: (context) {
      bool isLaptop = MediaQuery.of(context).size.width <= 1366;

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
          style: TextStyle(fontSize: finalFontSize, fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal, color: isHeader ? Colors.white : Colors.black),
        ),
      );
    });
  }

  Widget _buildUIInfoColumn(String title, List<String> lines,
      {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DynamicColors.primaryClr)),
        const SizedBox(height: 5),
        ...lines.map((line) {
          if (line.isEmpty) return const SizedBox(height: 10);
          if (line.contains(":")) {
            final parts = line.split(":");
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: "${parts[0]}: ",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
                    TextSpan(
                        text: parts.sublist(1).join(":"),
                        style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black87)),
                  ]),
                  textAlign: alignEnd ? TextAlign.right : TextAlign.left),
            );
          }
          return Text(line, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500));
        }),
      ],
    );
  }
}
