import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'component/textStyle.dart';

class TopNavBar extends StatefulWidget {
  final void Function(String)? onMenuSelect;

  const TopNavBar({Key? key, this.onMenuSelect}) : super(key: key);

  @override
  _TopNavBarState createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {
  String selectedMenu = "";
  String selectedDropdownItem = "";

  // ... your keys (unchanged)
  final GlobalKey fareKey = GlobalKey();
  final GlobalKey bookingKey = GlobalKey();
  final GlobalKey customerKey = GlobalKey();
  final GlobalKey reportKey = GlobalKey();
  final GlobalKey locationKey = GlobalKey();
  final GlobalKey driverKey = GlobalKey();
  final GlobalKey accountKey = GlobalKey();
  final GlobalKey vehicleKey = GlobalKey();
  final GlobalKey userKey = GlobalKey();
  final GlobalKey subsidiaryrKey = GlobalKey();
  final GlobalKey reportrKey = GlobalKey();
  final GlobalKey settingrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: screenHeight / 15,
          width: screenWidth,
          decoration: BoxDecoration(color: Color(0xFF43489A)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    AppText.appName,
                    style: headingText(
                      color: DynamicColors.whiteClr,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(width: 20),
                  buildMenuTab(Icons.book_online, "BOOKINGS", "BOOKINGS",
                      ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"], bookingKey),
                  buildMenuTab(Icons.headset_mic_rounded, "CUSTOMERS", "CUSTOMERS",
                      ["CREATE CUSTOMER", "LIST OF CUSTOMERS", "CREATE LOST PROPERTY", "LIST OF LOST PROPERTIES", "CREATE COMPLAINTS", "READ COMPLAINTS"], customerKey),
                  buildMenuTab(Icons.wallet_outlined, "FARES", "FARES",
                      ["CREATE FARE SETTINGS", "CREATE FIXED FARE SETTINGS", "CREATE FARE BY VEHICLE SETTINGS"], fareKey),
                  buildMenuTab(Icons.location_pin, "LOCATIONS", "LOCATIONS",
                      ["CREATE LOCATIONS", "LIST OF LOCATIONS", "CREATE ZONE", "LIST OF ZONES", "LOCALIZATION", "PLOTTING"], locationKey),
                  buildMenuTab(Icons.person, "DRIVERS", "DRIVERS",
                      ["CREATE DRIVER", "LIST OF DRIVERS", "LIST OF INACTIVE DRIVERS", "LIST OF LOGGED IN DRIVERS", "LIST OF LOGGED OUT DRIVERS", "CREATE DRIVER COMMISSION", "LIST OF DRIVER COMMISSION"], driverKey),
                  buildMenuTab(Icons.account_circle, "ACCOUNTS", "ACCOUNTS",
                      ["CREATE ACCOUNT", "LIST OF ACCOUNTS", "CREATE CUSTOMER INVOICE", "LIST OF CUSTOMER INVOICES", "CREATE ACCOUNT INVOICE", "LIST OF ACCOUNT INVOICES"], accountKey),
                  buildMenuTab(Icons.directions_car_filled, "VEHICLES", "VEHICLES",
                      ["CREATE VEHICLE TYPE", "LIST OF VEHICLE TYPES", "CREATE COMPANY VEHICLE", "LIST OF COMPANY VEHICLE"], vehicleKey),
                  buildMenuTab(Icons.supervised_user_circle, "USERS", "USERS",
                      ["CREATE USER", "LIST OF USER", "AUTHORIZATION"], userKey),
                  buildMenuTab(Icons.supervised_user_circle, "SUBSIDIARY", "SUBSIDIARY",
                      ["CREATE SUBSIDIARY", "LIST OF SUBSIDIARIES"], subsidiaryrKey),
                  buildMenuTab(Icons.receipt_long, "REPORTS", "REPORTS",
                      ["DRIVER", "BOOKINGS", "CALL", "INCOME", "PCO"], reportrKey),
                  buildMenuTab(Icons.settings, "SETTINGS", "SETTINGS",
                      ["COMPANY INFORMATION", "COMPANY CONFIGURATION", "DOCUMENT NUMBER", "TEMPLATE SETTINGS", "BOOKING CLEARING UTILITY", "LOCATION TYPE SHORTCUTS", "VOIP SETTINGS", "GENERAL SMS CONFIG", "SMS SETTINGS", "CHAT WITH DRIVER AND PASSENGER", "PERMISSION SETTINGS"], settingrKey),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/4.3,
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.cyanAccent.shade400,
                    child: Icon(Icons.email, color: DynamicColors.whiteClr),
                  ),
                  SizedBox(width: 15),
                  Icon(Icons.notifications, color: Colors.cyanAccent.shade400),
                  SizedBox(width: 15),
                  Icon(Icons.power_settings_new, color: Colors.red),
                  SizedBox(width: 15),
                ],
              ),
            ),
          ),
        ),
        // if (selectedDropdownItem.isNotEmpty)
        //   Container(
        //     width: double.infinity,
        //     color: Colors.grey.shade300,
        //     padding: EdgeInsets.all(12),
        //     child: Text(
        //       selectedDropdownItem",
        //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        //     ),
        //   ),
      ],
    );
  }

  Widget buildMenuTab(IconData icon, String label, String menuKey,
      List<String> items, GlobalKey key) {
    return Row(
      children: [
        GestureDetector(
          key: key,
          onTap: () async {
            setState(() {
              selectedMenu = menuKey;
            });

            final RenderBox renderBox =
            key.currentContext!.findRenderObject() as RenderBox;
            final Offset offset = renderBox.localToGlobal(Offset.zero);
            final Size size = renderBox.size;

            final selected = await showMenu<String>(
              context: context,
              position: RelativeRect.fromLTRB(
                offset.dx,
                offset.dy + size.height,
                offset.dx + size.width,
                offset.dy,
              ),
              items: items
                  .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
              elevation: 8.0,
            );

            if (selected != null) {
              setState(() {
                selectedDropdownItem = selected;
              });
              if (widget.onMenuSelect != null) {
                widget.onMenuSelect!(selected);
              }
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selectedMenu == menuKey
                  ? Colors.cyanAccent.shade400
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: DynamicColors.whiteClr,
                  size: 16,
                ),
                SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: DynamicColors.whiteClr,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                // Icon(
                //   Icons.arrow_drop_down,
                //   color: selectedMenu == menuKey ? Color(0xFF43489A) : Colors.white,
                // ),
              ],
            ),

          ),
        ),
      ],
    );
  }

 MenuList bookingList = MenuList(bookingList: ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"]
 ,title:"BOOKINGS");
}

class MenuList {
  String? title= "BOOKINGS";
  List<String>? bookingList;
  MenuList({this.bookingList,this.title});
}

