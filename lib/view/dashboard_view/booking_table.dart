
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Controller/dashboard_controller.dart';

class BookingTable extends StatelessWidget {
  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabs(),
          const SizedBox(height: 10),


          SizedBox(
            height: 500,
            width: double.infinity,
            child: Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
                  border: TableBorder.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  columnSpacing: 60,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 56,
                  columns: const [
                    DataColumn(label: Text('S.NO', style: _headerStyle)),
                    DataColumn(label: Text('REF#', style: _headerStyle)),
                    DataColumn(label: Text('DATE', style: _headerStyle)),
                    DataColumn(label: Text('TIME', style: _headerStyle)),
                    DataColumn(label: Text('CUSTOMER NAME', style: _headerStyle)),
                    DataColumn(label: Text('PICKUP POINT', style: _headerStyle)),
                    DataColumn(label: Text('DROPOFF POINT', style: _headerStyle)),
                    DataColumn(label: Text('PHONE', style: _headerStyle)),
                    DataColumn(label: Text('VEHICLE', style: _headerStyle)),
                    DataColumn(label: Text('STATUS', style: _headerStyle)),
                    DataColumn(label: Text('DRIVER', style: _headerStyle)),
                    DataColumn(label: Text('ACCOUNT', style: _headerStyle)),
                    DataColumn(label: Text('FARES', style: _headerStyle)),
                    DataColumn(label: Text('ACTION', style: _headerStyle)),
                  ],
                  rows: List.generate(controller.bookings.length, (index) {
                    final booking = controller.bookings[index];
                    return DataRow(cells: [
                      DataCell(Text('${booking.sno}')),
                      DataCell(Text(booking.ref)),
                      DataCell(Text(booking.date)),
                      DataCell(Text(booking.time)),
                      DataCell(Text(booking.customerName)),
                      DataCell(Text(booking.pickupPoint)),
                      DataCell(Text(booking.dropoffPoint)),
                      DataCell(Text(booking.phone)),
                      DataCell(Text(booking.vehicle)),
                      DataCell(Text(booking.status)),
                      DataCell(_buildStatus(booking.driver)),
                      DataCell(Text(booking.account)),
                      DataCell(Text('\$${booking.fares.toStringAsFixed(2)}')),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFF43489A)),
                            onPressed: () => controller.editBooking(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.deleteBooking(index),
                          ),
                        ],
                      )),
                    ]);
                  }),
                ),
              ),
            )),
        ],
      ),
    );
  }

  static const _headerStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );


  Widget _buildTabs() {
    List<String> tabs = [
      "TODAY BOOKINGS",
      "PRE BOOKINGS",
      "RECENT",
      "COMPLETED",
      "QUOTES",
      "SEARCH",
      "NO PICKUP",
      "CANCELED",
      "DRIVER STATS",
    ];

    return Obx(() => Container(
      width: double.infinity,
      color: const Color(0xFF43489A),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 80),
              ...tabs.map((tab) {
                bool isActive = controller.selectedBookingTab.value == tab;

                return Padding(
                  padding: const EdgeInsets.only(right: 70),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        controller.selectedBookingTab(tab);
                      }
                    },
                    onKey: (FocusNode node, RawKeyEvent event) {
                      if (event is RawKeyDownEvent &&
                          (event.logicalKey == LogicalKeyboardKey.enter ||
                              event.logicalKey == LogicalKeyboardKey.space)) {
                        controller.selectedBookingTab(tab);
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: Builder(
                      builder: (context) {
                        final bool isFocused = Focus.of(context).hasFocus;
                        final bool isActive = controller.selectedBookingTab.value == tab;

                        return GestureDetector(
                          onTap: () {
                            controller.selectedBookingTab(tab);
                            FocusScope.of(context).requestFocus(Focus.of(context));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.cyanAccent.shade400
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: isFocused ? Border.all(color: Colors.white, width: 2) : null,
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isActive || isFocused
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                );
              }).toList(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildStatus(String status) {
    Color color = status == "!" ? Colors.redAccent : Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
