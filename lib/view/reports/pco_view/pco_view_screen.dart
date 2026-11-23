import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../administration/model/list_subsDiary.dart';
import '../controller/report_controller.dart';
import 'model/pco_driver_model.dart';
import 'model/pco_vehicle_model.dart';

class PcoViewData {
  final bool isDriver;
  final Subsidiaries? subsidiary;
  final List<dynamic> bookings;

  PcoViewData({
    required this.isDriver,
    this.subsidiary,
    required this.bookings,
  });

  factory PcoViewData.fromJson(Map<String, dynamic> json) {
    final bool driver = json["is_driver"] ?? false;
    final rawList = (json["bookings"] as List?) ?? [];

    return PcoViewData(
      isDriver: driver,
      subsidiary: json["subsidiary"] == null
          ? null
          : Subsidiaries.fromJson(json["subsidiary"]),
      bookings: driver
          ? PcoDriverModel.fromJson({"bookings": rawList}).bookings ?? []
          : PcoVehicleModel.fromJson({"bookings": rawList}).bookings ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    "is_driver": isDriver,
    "subsidiary": subsidiary?.toJson(),
    "bookings": bookings.map((e) => e.toJson()).toList(),
  };
}

class PcoViewScreen extends StatelessWidget {
  final PcoViewData? pcoData;

  const PcoViewScreen({super.key, this.pcoData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ReportController>()
        ? Get.find<ReportController>()
        : null;

    final Subsidiaries? sub =
        pcoData?.subsidiary ?? controller?.selectedSubsidiary;

    final bool showDriver = pcoData?.isDriver ??
        ((controller?.showDriverTable ?? false) ||
            (controller?.pcoDriverModel?.bookings?.isNotEmpty ?? false));

    final List bookings = pcoData?.bookings ??
        (showDriver
            ? (controller?.pcoDriverModel?.bookings ?? [])
            : (controller?.pcoVehicleModel?.bookings ?? []));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo + PCO
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/cabflow_logo.png', height: 45),
                const SizedBox(height: 8),
                const Text(
                  "PCO",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Subsidiary Info Section (Address, Mobile, Telephone, Email)
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoColumn([
                      {"ADDRESS": (sub?.address ?? "").toUpperCase()},
                      {
                        "MOBILE":
                        (sub?.emergencyContactNumber ?? "").toUpperCase()
                      },
                    ]),
                    _infoColumn(
                      [
                        {"EMAIL": (sub?.email ?? "").toUpperCase()},
                        {
                          "TELEPHONE":
                          (sub?.telephoneNumber ?? "").toUpperCase()
                        },
                      ],
                      isRight: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Table
            if (showDriver)
              _buildDriverTable(bookings)
            else
              _buildVehicleTable(bookings),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverTable(List bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Text("NO DRIVER PCO DATA FOUND"),
        ),
      );
    }

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400, width: 1),
      children: [
        TableRow(
          decoration: BoxDecoration(color: DynamicColors.primaryClr),
          children: [
            _cell("DRIVER USERNAME", isHeader: true),
            _cell("DRIVER NAME", isHeader: true),
            _cell("VEHICLE NUMBER", isHeader: true),
            _cell("VEHICLE TYPE", isHeader: true),
            _cell("PRIVATE HIRE DRIVER LICENCE NUMBER", isHeader: true),
            _cell("FIRST NAME", isHeader: true),
            _cell("LAST NAME", isHeader: true),
          ],
        ),
        ...bookings.map((b) {
          return TableRow(
            children: [
              _cell(b.username ?? ""),
              _cell(b.driverName ?? ""),
              _cell(b.vehicleNumber ?? ""),
              _cell(b.vehicleType ?? ""),
              _cell(b.phcDriverNumber ?? ""),
              _cell(b.firstName ?? ""),
              _cell(b.lastName ?? ""),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildVehicleTable(List bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Text("NO VEHICLE PCO DATA FOUND"),
        ),
      );
    }

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400, width: 1),
      children: [
        TableRow(
          decoration: BoxDecoration(color: DynamicColors.primaryClr),
          children: [
            _cell("VRM", isHeader: true),
            _cell("VEHICLE MAKE", isHeader: true),
            _cell("VEHICLE TYPE", isHeader: true),
            _cell("VEHICLE LICENCE NUMBER", isHeader: true),
          ],
        ),
        ...bookings.map((b) {
          return TableRow(
            children: [
              _cell(b.vehicleNumber ?? "-"),
              _cell(b.vehicleMake ?? "-"),
              _cell(b.vehicleType ?? "-"),
              _cell(b.phcVehicleNumber ?? "-"),
            ],
          );
        }),
      ],
    );
  }

  Widget _infoColumn(List data, {bool isRight = false}) {
    return Column(
      crossAxisAlignment:
      isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: data.map((item) {
        final String key = item.keys.first;
        final String value = item.values.first;
        final String label = value.isEmpty ? key : "$key: ";

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                if (value.isNotEmpty)
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _cell(
      String text, {
        bool isHeader = false,
        bool isBold = false,
        TextAlign align = TextAlign.center,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Container(
        alignment: align == TextAlign.center
            ? Alignment.center
            : (align == TextAlign.right
            ? Alignment.centerRight
            : Alignment.centerLeft),
        child: Text(
          text.toUpperCase(),
          textAlign: align,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isHeader ? 14 : 13,
            fontWeight:
            (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
            color: isHeader ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}