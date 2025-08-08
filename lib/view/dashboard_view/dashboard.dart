import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/reservationpage.dart';
import 'package:dashboard_new1/tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../component/textStyle.dart';
import 'Controller/dashboard_controller.dart';
import 'booking_list.dart';
import 'booking_table.dart';
import 'dashboard/defult_dashboard_view.dart';

class DashBoarScreen extends StatefulWidget {
  const DashBoarScreen({super.key});

  @override
  State<DashBoarScreen> createState() => _DashBoarScreenState();
}

class _DashBoarScreenState extends State<DashBoarScreen> {

  final DashboardController locationCtrl = Get.put(DashboardController());
  String? selectedValue;
  String selectedJourneyType = 'Journey Type';
  String selectedVehicleType = 'Saloon';
  String selectedPaymentMethod = 'Cash';
  String selectedAccountType = 'Account';
  String selectedDriver = 'Select Driver';
  List<String> selectedTexts = [];
  bool limitReached = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFEEF0F3),
      body: SafeArea(
        child:  Column(
          children: [
            // Column(
            //   children: [
             /* TopNavBar(
                  onMenuSelect: (String value) {
                    setState(() {
                      if (selectedTexts.contains(value)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("⚠ '$value' is already selected."),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else if (selectedTexts.length < 20) {
                        selectedTexts.add(value);
                        limitReached = false;
                      } else {
                        limitReached = true;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("⚠ You opened too many tabs."),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    });
                  },
                ),*/
            TopNavBarss(),
            Container(
              width: screenWidth,
              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 8),
              color: Colors.grey.shade300,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  // Home icon container
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: DynamicColors.primaryClr,
                      border: Border.all(color: DynamicColors.textClr),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.home,
                      color: DynamicColors.whiteClr,
                    ),
                  ),

                  // Dynamic selected tabs
                  ...selectedTexts.map((text) {
                    return Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(text, style: TextStyle(fontSize: 16)),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTexts.remove(text);
                              });
                            },
                            child: Icon(
                              Icons.cancel,
                              color: Color(0xFF43489A),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            //   ],
            // ),
            getSelectedWidget(),
            // ),
          ],
        ),
      ),
    );

  }

  Widget getSelectedWidget() {
    if (selectedTexts.isEmpty) return ByDefaultDashboard();

    switch (selectedTexts.last) {
      case 'LIST OF BOOKINGS':
        return BookingList();
      case 'Option 2':
        return Text("text 2");
      case 'Option 3':
        return Text("text 3");
      default:
        return ByDefaultDashboard();
    }
  }


}
