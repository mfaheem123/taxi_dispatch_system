import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/datatable_widget.dart';
import '../component/textStyle.dart';
import '../view/dashboard_view/booking_table.dart';

class DriverBookingsAlert extends StatefulWidget {
  const DriverBookingsAlert({super.key});

  @override
  State<DriverBookingsAlert> createState() => _DriverBookingsAlertState();

  static void show() {
    Get.dialog(
      const DriverBookingsAlert(),
      barrierColor: Colors.black54,
    );
  }
}

class _DriverBookingsAlertState extends State<DriverBookingsAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.only(top: 42, left: 12, right: 12, bottom: 30),
      clipBehavior: Clip.antiAlias,

      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        color: DynamicColors.secondaryClr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "DRIVER BOOKINGS",
              style: mozillaTextSemiBoldText(
                fontWeight: FontWeight.w900,
                fontSize: 23,
              ),
            ),
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, size: 20),
            ),
          ],
        ),
      ),

      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: DatatableWidget(
              columns: [
                buildHeaderWithSearch(title: "REF #", removeSearching: true),
                buildHeaderWithSearch(title: "DATE/TIME", removeSearching: true),
                buildHeaderWithSearch(title: "VEHICLE", removeSearching: true),
                buildHeaderWithSearch(title: "PICKUP", removeSearching: true),
                buildHeaderWithSearch(title: "DROPOFF", removeSearching: true),
                buildHeaderWithSearch(title: "FARES", removeSearching: true),
                buildHeaderWithSearch(title: "CUSTOMER", removeSearching: true),
                buildHeaderWithSearch(title: "ACCOUNT", removeSearching: true),
                buildHeaderWithSearch(title: "DRIVER", removeSearching: true),
                buildHeaderWithSearch(title: "P/T", removeSearching: true),
                buildHeaderWithSearch(title: "STATUS", removeSearching: true),
              ],
              rows: [
                _buildBookingRow("DCB76872", "04-07-25\n13:25", "SALOON", "D", "D", "£0.00", "CUSTOMER", "", "26", "", "COMPLETED"),
                _buildBookingRow("DC572538", "16-06-26\n14:05", "SALOON", "NORTHWICK AVENUE HARROW HA3 0AA", "GREEN PARK WAY GREENFORD UB6 0AD", "£22.50", "CUSTOMER", "", "25", "", "COMPLETED"),
                _buildBookingRow("DC572539", "17-06-26\n16:32", "SALOON", "NORTHWICK AVENUE HARROW HA3 0AA", "ROCKWARE AVENUE GREENFORD JBB6 0AA", "£4.50", "CUSTOMER", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB76866", "04-07-26\n02:28", "SALOON", "1 MEADOW GARDENS EDGWARE HA8 9LQ", "WOODSIDE PARK, CASTLE POINT, ESSEX", "£0.00", "CUSTOMER", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB75562", "01-07-26\n14:00", "SALOON", "NORTHWICK AVENUE HARROW HA3 0AA", "ACE CONTINENTAL EXPORTS RAYS HOUSE N...", "£4.50", "TEST", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB72553", "01-07-26\n14:02", "SALOON", "BROMEFIELD STANMORE HA7 1AB", "HARMONDSWORTH LANE HARMONDSWORT...", "£4.50", "TEST", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB75171", "04-07-25\n13:25", "SALOON", "D", "D", "£0.00", "CUSTOMER", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB76667", "04-07-25\n02:28", "SALOON", "1 MEADOW GARDENS EDGWARE HA8 9LQ", "WOODSIDE PARK, CASTLE POINT, ESSEX", "£0.00", "CUSTOMER", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB72568", "04-07-25\n02:22", "SALOON", "F", "F", "£0.00", "CUSTOMER", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB76869", "04-07-25\n03:19", "SALOON", "D", "D", "£0.00", "CUSTOMER", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB76870", "04-07-25\n03:32", "SALOON", "D", "D", "£0.00", "CUSTOMER", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB76497", "04-06-26\n15:43", "SALOON", "NORTHWICK AVENUE HARROW HA3 0AA", "ROCKWARE AVENUE GREENFORD JBB6 0AA", "£10.50", "CUSTOMER", "ABC-12", "25", "", "COMPLETED"),
                _buildBookingRow("DCB75028", "02-06-25\n15:31", "SALOON", "95 KINGSLEY SO, HOUNSLOW TW3 1QA, UK", "HIGH STREET BRENTFORD TW8 0AA", "£4.50", "JOHN DOE", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB76531", "02-06-26\n13:23", "SALOON", "NORTHWICK AVENUE HARROW HA3 0AA", "ROCKWARE AVENUE GREENFORD JBB6 0AA", "£4.50", "CUSTOMER", "", "25", "", "COMPLETED"),
                _buildBookingRow("DCB76532", "02-06-26\n13:26", "SALOON", "NORTHWICK AVENUE HARROW HA3 0AA", "ROCKWARE AVENUE GREENFORD JBB6 0AA", "£4.50", "CUSTOMER", "", "25", "", "COMPLETED"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildBookingRow(
    String ref,
    String dateTime,
    String vehicle,
    String pickup,
    String dropoff,
    String fares,
    String customer,
    String account,
    String driver,
    String pt,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Text(
              ref.toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              dateTime.toUpperCase(),
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              vehicle.toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 180,
            child: Text(
              pickup.toUpperCase(),
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 200,
            child: Text(
              dropoff.toUpperCase(),
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              fares,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              customer.toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              account.toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              driver,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              pt.toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: status == "COMPLETED"
                    ? DynamicColors.greenClr.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: status == "COMPLETED"
                      ? DynamicColors.greenClr
                      : DynamicColors.textClr,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
