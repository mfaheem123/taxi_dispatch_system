import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../component/color.dart';
import '../component/textStyle.dart';


class DriverExpiryDocumentsAlert {
  DriverExpiryDocumentsAlert(context);

  static void show(BuildContext context, List<DriverExpiryItem> drivers) {
    final ScrollController scrollController = ScrollController();

    final tableBorder = TableBorder(
      horizontalInside: BorderSide(width: 0.5, color: Colors.grey.shade400),
      verticalInside: BorderSide(width: 0.5, color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(4),
      top: BorderSide(width: 1, color: DynamicColors.textClr.withOpacity(0.5)),
      left: BorderSide(width: 1, color: DynamicColors.textClr.withOpacity(0.5)),
      right: BorderSide(width: 1, color: DynamicColors.textClr.withOpacity(0.5)),
      bottom: BorderSide(width: 1, color: DynamicColors.textClr.withOpacity(0.5)),
    );

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 1000,
          height: 400,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DRIVER EXPIRY DOCUMENTS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DRIVER EXPIRY DOCUMENTS",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Flexible(
                child: RawScrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  thickness: 8.0,
                  radius: const Radius.circular(4),
                  thumbColor: Colors.grey.shade400,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0), // Padding so table doesn't overlap scrollbar
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Table(
                          border: tableBorder,
                          columnWidths: const {
                            0: FlexColumnWidth(1.1),
                            1: FlexColumnWidth(1.5),
                            2: FlexColumnWidth(1.5),
                            3: FlexColumnWidth(1.5),
                            4: FlexColumnWidth(1.5),
                            5: FlexColumnWidth(1.5),
                            6: FlexColumnWidth(1.5),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: DynamicColors.secondaryClr,
                              ),
                              children: [
                                _headerCell("USERNAME"),
                                _headerCell("VEHICLE EXPIRY"),
                                _headerCell("DRIVER EXPIRY"),
                                _headerCell("MOT EXPIRY"),
                                _headerCell("MOT2 EXPIRY"),
                                _headerCell("INSURANCE EXPIRY"),
                                _headerCell("LICENSE EXPIRY"),
                              ],
                            ),

                            ...drivers.map((driver) {
                              return TableRow(
                                children: [
                                  _dataCell(driver.username, isUsername: true),
                                  _dataCell(driver.vehicleExpiry),
                                  _dataCell(driver.driverExpiry),
                                  _dataCell(driver.motExpiry),
                                  _dataCell(driver.mot2Expiry),
                                  _dataCell(driver.insuranceExpiry),
                                  _dataCell(driver.licenceExpiry),
                                ],
                              );
                            }).toList(),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Bottom Close Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DynamicColors.secondaryClr,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    "CLOSE",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),

      barrierDismissible: true,
    );
  }

  static Widget _headerCell(String title) {
    const headingTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      child: Center(
        child: Text(
          title,
          style: headingTextStyle,
        ),
      ),
    );
  }

  static Widget _dataCell(String dateStr, {bool isUsername = false}) {
    const dataTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w900);
    bool isExpired = !isUsername && _checkIfExpired(dateStr);

    return Container(
      color: isExpired ? const Color(0xFFFFD6D6) : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Center(
        child: Text(
          dateStr,
          style: dataTextStyle,
        ),
      ),
    );
  }

  static bool _checkIfExpired(String dateStr) {
    if (dateStr.trim().isEmpty) return false;
    try {
      DateTime expiryDate;
      if (dateStr.contains(" ")) {
        expiryDate = DateFormat("dd-MM-yyyy HH:mm").parse(dateStr);
      } else {
        expiryDate = DateTime.parse(dateStr);
      }
      return expiryDate.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}


///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/// Driver Expiry Document
///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class DriverExpiryResponse {
  final bool status;
  final int total;
  final List<DriverExpiryItem> drivers;

  DriverExpiryResponse({
    required this.status,
    required this.total,
    required this.drivers,
  });

  factory DriverExpiryResponse.fromJson(Map<String, dynamic> json) {
    return DriverExpiryResponse(
      status: json['status'] ?? false,
      total: json['total'] ?? 0,
      drivers: (json['drivers'] as List<dynamic>?)
          ?.map((e) => DriverExpiryItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class DriverExpiryItem {
  final int id;
  final String username;
  final String vehicleExpiry;
  final String driverExpiry;
  final String motExpiry;
  final String mot2Expiry;
  final String insuranceExpiry;
  final String licenceExpiry;

  DriverExpiryItem({
    required this.id,
    required this.username,
    required this.vehicleExpiry,
    required this.driverExpiry,
    required this.motExpiry,
    required this.mot2Expiry,
    required this.insuranceExpiry,
    required this.licenceExpiry,
  });

  factory DriverExpiryItem.fromJson(Map<String, dynamic> json) {
    return DriverExpiryItem(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      vehicleExpiry: json['vehicle_expiry'] ?? '',
      driverExpiry: json['driver_expiry'] ?? '',
      motExpiry: json['mot_expiry'] ?? '',
      mot2Expiry: json['mot2_expiry'] ?? '',
      insuranceExpiry: json['insurance_expiry'] ?? '',
      licenceExpiry: json['licence_expiry'] ?? '',
    );
  }
}