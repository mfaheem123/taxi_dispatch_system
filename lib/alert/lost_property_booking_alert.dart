import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../component/color.dart';
import '../component/datatable_widget.dart';
import '../component/textStyle.dart';
import '../view/dashboard_view/booking_table.dart';

class LostPropertyBookingAlert {
  static void showSearchDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.only(top: 42, left: 12, right: 12, bottom: 30),
        clipBehavior: Clip.antiAlias,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          color: DynamicColors.secondaryClr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("BOOKINGS",
                  style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 23)),
              IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, size: 20)
              )
            ],
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(
                  width: double.infinity,
                  child: DatatableWidget(
                    columns: [
                      buildHeaderWithSearch(title: "REF #", removeSearching: true),
                      buildHeaderWithSearch(title: "DATETIME", removeSearching: true),
                      buildHeaderWithSearch(title: "VEHICLE", removeSearching: true),
                      buildHeaderWithSearch(title: "PICKUP", removeSearching: true),
                      buildHeaderWithSearch(title: "DROPOFF", removeSearching: true),
                      buildHeaderWithSearch(title: "ACTIONS", removeSearching: true),
                    ],
                    totalRow: 30,
                    cells: [
                      const DataCell(Center(child: Text("1"))),
                      const DataCell(Center(child: Text("John Doe"))),
                      const DataCell(Center(child: Text("0123456789"))),
                      const DataCell(Center(child: Text("10 High Street, London"))),
                      const DataCell(Center(child: Text("Heathrow Airport"))),
                      DataCell(Center(
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: const Text(
                              "PICK",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                // fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}